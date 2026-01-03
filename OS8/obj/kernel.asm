
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00015297          	auipc	t0,0x15
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0215000 <boot_hartid>
ffffffffc020000c:	00015297          	auipc	t0,0x15
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0215008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02142b7          	lui	t0,0xc0214
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0214137          	lui	sp,0xc0214
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00092517          	auipc	a0,0x92
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0292060 <buf>
ffffffffc0200052:	00098617          	auipc	a2,0x98
ffffffffc0200056:	8c660613          	addi	a2,a2,-1850 # ffffffffc0297918 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16 # ffffffffc0213ff0 <bootstack+0x1ff0>
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	46f0b0ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0200066:	54e000ef          	jal	ffffffffc02005b4 <cons_init>
ffffffffc020006a:	0000c597          	auipc	a1,0xc
ffffffffc020006e:	cce58593          	addi	a1,a1,-818 # ffffffffc020bd38 <etext>
ffffffffc0200072:	0000c517          	auipc	a0,0xc
ffffffffc0200076:	ce650513          	addi	a0,a0,-794 # ffffffffc020bd58 <etext+0x20>
ffffffffc020007a:	12c000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020007e:	1ac000ef          	jal	ffffffffc020022a <print_kerninfo>
ffffffffc0200082:	68c000ef          	jal	ffffffffc020070e <dtb_init>
ffffffffc0200086:	39f020ef          	jal	ffffffffc0202c24 <pmm_init>
ffffffffc020008a:	3ed000ef          	jal	ffffffffc0200c76 <pic_init>
ffffffffc020008e:	50f000ef          	jal	ffffffffc0200d9c <idt_init>
ffffffffc0200092:	699030ef          	jal	ffffffffc0203f2a <vmm_init>
ffffffffc0200096:	037070ef          	jal	ffffffffc02078cc <sched_init>
ffffffffc020009a:	6fd060ef          	jal	ffffffffc0206f96 <proc_init>
ffffffffc020009e:	1b7000ef          	jal	ffffffffc0200a54 <ide_init>
ffffffffc02000a2:	1d4050ef          	jal	ffffffffc0205276 <fs_init>
ffffffffc02000a6:	452000ef          	jal	ffffffffc02004f8 <clock_init>
ffffffffc02000aa:	3c1000ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02000ae:	0bc070ef          	jal	ffffffffc020716a <cpu_idle>

ffffffffc02000b2 <readline>:
ffffffffc02000b2:	7179                	addi	sp,sp,-48
ffffffffc02000b4:	f406                	sd	ra,40(sp)
ffffffffc02000b6:	f022                	sd	s0,32(sp)
ffffffffc02000b8:	ec26                	sd	s1,24(sp)
ffffffffc02000ba:	e84a                	sd	s2,16(sp)
ffffffffc02000bc:	e44e                	sd	s3,8(sp)
ffffffffc02000be:	c901                	beqz	a0,ffffffffc02000ce <readline+0x1c>
ffffffffc02000c0:	85aa                	mv	a1,a0
ffffffffc02000c2:	0000c517          	auipc	a0,0xc
ffffffffc02000c6:	c9e50513          	addi	a0,a0,-866 # ffffffffc020bd60 <etext+0x28>
ffffffffc02000ca:	0dc000ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02000ce:	4481                	li	s1,0
ffffffffc02000d0:	497d                	li	s2,31
ffffffffc02000d2:	00092997          	auipc	s3,0x92
ffffffffc02000d6:	f8e98993          	addi	s3,s3,-114 # ffffffffc0292060 <buf>
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
ffffffffc020014c:	00092517          	auipc	a0,0x92
ffffffffc0200150:	f1450513          	addi	a0,a0,-236 # ffffffffc0292060 <buf>
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
ffffffffc0200192:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd5f1c1>
ffffffffc0200196:	ec06                	sd	ra,24(sp)
ffffffffc0200198:	c602                	sw	zero,12(sp)
ffffffffc020019a:	69a0b0ef          	jal	ffffffffc020b834 <vprintfmt>
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
ffffffffc02001c4:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd5f1c1>
ffffffffc02001c8:	ec06                	sd	ra,24(sp)
ffffffffc02001ca:	e4be                	sd	a5,72(sp)
ffffffffc02001cc:	e8c2                	sd	a6,80(sp)
ffffffffc02001ce:	ecc6                	sd	a7,88(sp)
ffffffffc02001d0:	c202                	sw	zero,4(sp)
ffffffffc02001d2:	e41a                	sd	t1,8(sp)
ffffffffc02001d4:	6600b0ef          	jal	ffffffffc020b834 <vprintfmt>
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
ffffffffc02001fc:	2210b0ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc0200200:	842a                	mv	s0,a0
ffffffffc0200202:	0505                	addi	a0,a0,1
ffffffffc0200204:	785010ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0200208:	87aa                	mv	a5,a0
ffffffffc020020a:	c911                	beqz	a0,ffffffffc020021e <strdup+0x2c>
ffffffffc020020c:	8622                	mv	a2,s0
ffffffffc020020e:	85a6                	mv	a1,s1
ffffffffc0200210:	e42a                	sd	a0,8(sp)
ffffffffc0200212:	30f0b0ef          	jal	ffffffffc020bd20 <memcpy>
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
ffffffffc020022c:	0000c517          	auipc	a0,0xc
ffffffffc0200230:	b3c50513          	addi	a0,a0,-1220 # ffffffffc020bd68 <etext+0x30>
ffffffffc0200234:	e406                	sd	ra,8(sp)
ffffffffc0200236:	f71ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020023a:	00000597          	auipc	a1,0x0
ffffffffc020023e:	e1058593          	addi	a1,a1,-496 # ffffffffc020004a <kern_init>
ffffffffc0200242:	0000c517          	auipc	a0,0xc
ffffffffc0200246:	b4650513          	addi	a0,a0,-1210 # ffffffffc020bd88 <etext+0x50>
ffffffffc020024a:	f5dff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020024e:	0000c597          	auipc	a1,0xc
ffffffffc0200252:	aea58593          	addi	a1,a1,-1302 # ffffffffc020bd38 <etext>
ffffffffc0200256:	0000c517          	auipc	a0,0xc
ffffffffc020025a:	b5250513          	addi	a0,a0,-1198 # ffffffffc020bda8 <etext+0x70>
ffffffffc020025e:	f49ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200262:	00092597          	auipc	a1,0x92
ffffffffc0200266:	dfe58593          	addi	a1,a1,-514 # ffffffffc0292060 <buf>
ffffffffc020026a:	0000c517          	auipc	a0,0xc
ffffffffc020026e:	b5e50513          	addi	a0,a0,-1186 # ffffffffc020bdc8 <etext+0x90>
ffffffffc0200272:	f35ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200276:	00097597          	auipc	a1,0x97
ffffffffc020027a:	6a258593          	addi	a1,a1,1698 # ffffffffc0297918 <end>
ffffffffc020027e:	0000c517          	auipc	a0,0xc
ffffffffc0200282:	b6a50513          	addi	a0,a0,-1174 # ffffffffc020bde8 <etext+0xb0>
ffffffffc0200286:	f21ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020028a:	00000717          	auipc	a4,0x0
ffffffffc020028e:	dc070713          	addi	a4,a4,-576 # ffffffffc020004a <kern_init>
ffffffffc0200292:	00098797          	auipc	a5,0x98
ffffffffc0200296:	a8578793          	addi	a5,a5,-1403 # ffffffffc0297d17 <end+0x3ff>
ffffffffc020029a:	8f99                	sub	a5,a5,a4
ffffffffc020029c:	43f7d593          	srai	a1,a5,0x3f
ffffffffc02002a0:	60a2                	ld	ra,8(sp)
ffffffffc02002a2:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002a6:	95be                	add	a1,a1,a5
ffffffffc02002a8:	85a9                	srai	a1,a1,0xa
ffffffffc02002aa:	0000c517          	auipc	a0,0xc
ffffffffc02002ae:	b5e50513          	addi	a0,a0,-1186 # ffffffffc020be08 <etext+0xd0>
ffffffffc02002b2:	0141                	addi	sp,sp,16
ffffffffc02002b4:	bdcd                	j	ffffffffc02001a6 <cprintf>

ffffffffc02002b6 <print_stackframe>:
ffffffffc02002b6:	1141                	addi	sp,sp,-16
ffffffffc02002b8:	0000c617          	auipc	a2,0xc
ffffffffc02002bc:	b8060613          	addi	a2,a2,-1152 # ffffffffc020be38 <etext+0x100>
ffffffffc02002c0:	04e00593          	li	a1,78
ffffffffc02002c4:	0000c517          	auipc	a0,0xc
ffffffffc02002c8:	b8c50513          	addi	a0,a0,-1140 # ffffffffc020be50 <etext+0x118>
ffffffffc02002cc:	e406                	sd	ra,8(sp)
ffffffffc02002ce:	17c000ef          	jal	ffffffffc020044a <__panic>

ffffffffc02002d2 <mon_help>:
ffffffffc02002d2:	1101                	addi	sp,sp,-32
ffffffffc02002d4:	e822                	sd	s0,16(sp)
ffffffffc02002d6:	e426                	sd	s1,8(sp)
ffffffffc02002d8:	ec06                	sd	ra,24(sp)
ffffffffc02002da:	0000f417          	auipc	s0,0xf
ffffffffc02002de:	08e40413          	addi	s0,s0,142 # ffffffffc020f368 <commands>
ffffffffc02002e2:	0000f497          	auipc	s1,0xf
ffffffffc02002e6:	0ce48493          	addi	s1,s1,206 # ffffffffc020f3b0 <commands+0x48>
ffffffffc02002ea:	6410                	ld	a2,8(s0)
ffffffffc02002ec:	600c                	ld	a1,0(s0)
ffffffffc02002ee:	0000c517          	auipc	a0,0xc
ffffffffc02002f2:	b7a50513          	addi	a0,a0,-1158 # ffffffffc020be68 <etext+0x130>
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
ffffffffc0200332:	0000c517          	auipc	a0,0xc
ffffffffc0200336:	b4650513          	addi	a0,a0,-1210 # ffffffffc020be78 <etext+0x140>
ffffffffc020033a:	fd06                	sd	ra,184(sp)
ffffffffc020033c:	f922                	sd	s0,176(sp)
ffffffffc020033e:	f526                	sd	s1,168(sp)
ffffffffc0200340:	ed4e                	sd	s3,152(sp)
ffffffffc0200342:	e556                	sd	s5,136(sp)
ffffffffc0200344:	e15a                	sd	s6,128(sp)
ffffffffc0200346:	e61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020034a:	0000c517          	auipc	a0,0xc
ffffffffc020034e:	b5650513          	addi	a0,a0,-1194 # ffffffffc020bea0 <etext+0x168>
ffffffffc0200352:	e55ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200356:	000a0563          	beqz	s4,ffffffffc0200360 <kmonitor+0x34>
ffffffffc020035a:	8552                	mv	a0,s4
ffffffffc020035c:	429000ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc0200360:	0000fa97          	auipc	s5,0xf
ffffffffc0200364:	008a8a93          	addi	s5,s5,8 # ffffffffc020f368 <commands>
ffffffffc0200368:	49bd                	li	s3,15
ffffffffc020036a:	0000c517          	auipc	a0,0xc
ffffffffc020036e:	b5e50513          	addi	a0,a0,-1186 # ffffffffc020bec8 <etext+0x190>
ffffffffc0200372:	d41ff0ef          	jal	ffffffffc02000b2 <readline>
ffffffffc0200376:	842a                	mv	s0,a0
ffffffffc0200378:	d96d                	beqz	a0,ffffffffc020036a <kmonitor+0x3e>
ffffffffc020037a:	00054583          	lbu	a1,0(a0)
ffffffffc020037e:	4481                	li	s1,0
ffffffffc0200380:	e99d                	bnez	a1,ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc0200382:	8b26                	mv	s6,s1
ffffffffc0200384:	fe0b03e3          	beqz	s6,ffffffffc020036a <kmonitor+0x3e>
ffffffffc0200388:	0000f497          	auipc	s1,0xf
ffffffffc020038c:	fe048493          	addi	s1,s1,-32 # ffffffffc020f368 <commands>
ffffffffc0200390:	4401                	li	s0,0
ffffffffc0200392:	6582                	ld	a1,0(sp)
ffffffffc0200394:	6088                	ld	a0,0(s1)
ffffffffc0200396:	0cd0b0ef          	jal	ffffffffc020bc62 <strcmp>
ffffffffc020039a:	478d                	li	a5,3
ffffffffc020039c:	c149                	beqz	a0,ffffffffc020041e <kmonitor+0xf2>
ffffffffc020039e:	2405                	addiw	s0,s0,1
ffffffffc02003a0:	04e1                	addi	s1,s1,24
ffffffffc02003a2:	fef418e3          	bne	s0,a5,ffffffffc0200392 <kmonitor+0x66>
ffffffffc02003a6:	6582                	ld	a1,0(sp)
ffffffffc02003a8:	0000c517          	auipc	a0,0xc
ffffffffc02003ac:	b5050513          	addi	a0,a0,-1200 # ffffffffc020bef8 <etext+0x1c0>
ffffffffc02003b0:	df7ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02003b4:	bf5d                	j	ffffffffc020036a <kmonitor+0x3e>
ffffffffc02003b6:	0000c517          	auipc	a0,0xc
ffffffffc02003ba:	b1a50513          	addi	a0,a0,-1254 # ffffffffc020bed0 <etext+0x198>
ffffffffc02003be:	1010b0ef          	jal	ffffffffc020bcbe <strchr>
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
ffffffffc02003f8:	0000c517          	auipc	a0,0xc
ffffffffc02003fc:	ad850513          	addi	a0,a0,-1320 # ffffffffc020bed0 <etext+0x198>
ffffffffc0200400:	0bf0b0ef          	jal	ffffffffc020bcbe <strchr>
ffffffffc0200404:	d575                	beqz	a0,ffffffffc02003f0 <kmonitor+0xc4>
ffffffffc0200406:	00044583          	lbu	a1,0(s0)
ffffffffc020040a:	dda5                	beqz	a1,ffffffffc0200382 <kmonitor+0x56>
ffffffffc020040c:	b76d                	j	ffffffffc02003b6 <kmonitor+0x8a>
ffffffffc020040e:	45c1                	li	a1,16
ffffffffc0200410:	0000c517          	auipc	a0,0xc
ffffffffc0200414:	ac850513          	addi	a0,a0,-1336 # ffffffffc020bed8 <etext+0x1a0>
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
ffffffffc020044a:	00097317          	auipc	t1,0x97
ffffffffc020044e:	41e33303          	ld	t1,1054(t1) # ffffffffc0297868 <is_panic>
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
ffffffffc0200470:	0000c517          	auipc	a0,0xc
ffffffffc0200474:	b3050513          	addi	a0,a0,-1232 # ffffffffc020bfa0 <etext+0x268>
ffffffffc0200478:	00097697          	auipc	a3,0x97
ffffffffc020047c:	3ee6b823          	sd	a4,1008(a3) # ffffffffc0297868 <is_panic>
ffffffffc0200480:	e43e                	sd	a5,8(sp)
ffffffffc0200482:	d25ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200486:	65a2                	ld	a1,8(sp)
ffffffffc0200488:	8522                	mv	a0,s0
ffffffffc020048a:	cf7ff0ef          	jal	ffffffffc0200180 <vcprintf>
ffffffffc020048e:	0000c517          	auipc	a0,0xc
ffffffffc0200492:	b3250513          	addi	a0,a0,-1230 # ffffffffc020bfc0 <etext+0x288>
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
ffffffffc02004c2:	0000c517          	auipc	a0,0xc
ffffffffc02004c6:	b0650513          	addi	a0,a0,-1274 # ffffffffc020bfc8 <etext+0x290>
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
ffffffffc02004e4:	0000c517          	auipc	a0,0xc
ffffffffc02004e8:	adc50513          	addi	a0,a0,-1316 # ffffffffc020bfc0 <etext+0x288>
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
ffffffffc0200516:	0000c517          	auipc	a0,0xc
ffffffffc020051a:	ad250513          	addi	a0,a0,-1326 # ffffffffc020bfe8 <etext+0x2b0>
ffffffffc020051e:	00097797          	auipc	a5,0x97
ffffffffc0200522:	3407b923          	sd	zero,850(a5) # ffffffffc0297870 <ticks>
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
ffffffffc0200568:	00092717          	auipc	a4,0x92
ffffffffc020056c:	0fc72703          	lw	a4,252(a4) # ffffffffc0292664 <cons+0x204>
ffffffffc0200570:	00092797          	auipc	a5,0x92
ffffffffc0200574:	ef078793          	addi	a5,a5,-272 # ffffffffc0292460 <cons>
ffffffffc0200578:	02071693          	slli	a3,a4,0x20
ffffffffc020057c:	9281                	srli	a3,a3,0x20
ffffffffc020057e:	2705                	addiw	a4,a4,1
ffffffffc0200580:	20e7a223          	sw	a4,516(a5)
ffffffffc0200584:	97b6                	add	a5,a5,a3
ffffffffc0200586:	00a78023          	sb	a0,0(a5)
ffffffffc020058a:	5bf080ef          	jal	ffffffffc0209348 <dev_stdin_write>
ffffffffc020058e:	00092717          	auipc	a4,0x92
ffffffffc0200592:	0d672703          	lw	a4,214(a4) # ffffffffc0292664 <cons+0x204>
ffffffffc0200596:	20000793          	li	a5,512
ffffffffc020059a:	faf718e3          	bne	a4,a5,ffffffffc020054a <serial_intr+0xa>
ffffffffc020059e:	00092797          	auipc	a5,0x92
ffffffffc02005a2:	0c07a323          	sw	zero,198(a5) # ffffffffc0292664 <cons+0x204>
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
ffffffffc020063e:	00092497          	auipc	s1,0x92
ffffffffc0200642:	e2248493          	addi	s1,s1,-478 # ffffffffc0292460 <cons>
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
ffffffffc0200668:	00092797          	auipc	a5,0x92
ffffffffc020066c:	ffc7a783          	lw	a5,-4(a5) # ffffffffc0292664 <cons+0x204>
ffffffffc0200670:	02079713          	slli	a4,a5,0x20
ffffffffc0200674:	9301                	srli	a4,a4,0x20
ffffffffc0200676:	2785                	addiw	a5,a5,1
ffffffffc0200678:	20f4a223          	sw	a5,516(s1)
ffffffffc020067c:	00e487b3          	add	a5,s1,a4
ffffffffc0200680:	00a78023          	sb	a0,0(a5)
ffffffffc0200684:	4c5080ef          	jal	ffffffffc0209348 <dev_stdin_write>
ffffffffc0200688:	00092717          	auipc	a4,0x92
ffffffffc020068c:	fdc72703          	lw	a4,-36(a4) # ffffffffc0292664 <cons+0x204>
ffffffffc0200690:	20000793          	li	a5,512
ffffffffc0200694:	faf71be3          	bne	a4,a5,ffffffffc020064a <cons_getc+0x20>
ffffffffc0200698:	00092797          	auipc	a5,0x92
ffffffffc020069c:	fc07a623          	sw	zero,-52(a5) # ffffffffc0292664 <cons+0x204>
ffffffffc02006a0:	b76d                	j	ffffffffc020064a <cons_getc+0x20>
ffffffffc02006a2:	4521                	li	a0,8
ffffffffc02006a4:	b7d1                	j	ffffffffc0200668 <cons_getc+0x3e>
ffffffffc02006a6:	00092797          	auipc	a5,0x92
ffffffffc02006aa:	fba7a783          	lw	a5,-70(a5) # ffffffffc0292660 <cons+0x200>
ffffffffc02006ae:	00092717          	auipc	a4,0x92
ffffffffc02006b2:	fb672703          	lw	a4,-74(a4) # ffffffffc0292664 <cons+0x204>
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
ffffffffc02006e6:	00092797          	auipc	a5,0x92
ffffffffc02006ea:	f607ad23          	sw	zero,-134(a5) # ffffffffc0292660 <cons+0x200>
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
ffffffffc0200710:	0000c517          	auipc	a0,0xc
ffffffffc0200714:	8f850513          	addi	a0,a0,-1800 # ffffffffc020c008 <etext+0x2d0>
ffffffffc0200718:	f406                	sd	ra,40(sp)
ffffffffc020071a:	f022                	sd	s0,32(sp)
ffffffffc020071c:	a8bff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200720:	00015597          	auipc	a1,0x15
ffffffffc0200724:	8e05b583          	ld	a1,-1824(a1) # ffffffffc0215000 <boot_hartid>
ffffffffc0200728:	0000c517          	auipc	a0,0xc
ffffffffc020072c:	8f050513          	addi	a0,a0,-1808 # ffffffffc020c018 <etext+0x2e0>
ffffffffc0200730:	00015417          	auipc	s0,0x15
ffffffffc0200734:	8d840413          	addi	s0,s0,-1832 # ffffffffc0215008 <boot_dtb>
ffffffffc0200738:	a6fff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020073c:	600c                	ld	a1,0(s0)
ffffffffc020073e:	0000c517          	auipc	a0,0xc
ffffffffc0200742:	8ea50513          	addi	a0,a0,-1814 # ffffffffc020c028 <etext+0x2f0>
ffffffffc0200746:	a61ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020074a:	6018                	ld	a4,0(s0)
ffffffffc020074c:	0000c517          	auipc	a0,0xc
ffffffffc0200750:	8f450513          	addi	a0,a0,-1804 # ffffffffc020c040 <etext+0x308>
ffffffffc0200754:	10070163          	beqz	a4,ffffffffc0200856 <dtb_init+0x148>
ffffffffc0200758:	57f5                	li	a5,-3
ffffffffc020075a:	07fa                	slli	a5,a5,0x1e
ffffffffc020075c:	973e                	add	a4,a4,a5
ffffffffc020075e:	431c                	lw	a5,0(a4)
ffffffffc0200760:	d00e06b7          	lui	a3,0xd00e0
ffffffffc0200764:	eed68693          	addi	a3,a3,-275 # ffffffffd00dfeed <end+0xfe485d5>
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
ffffffffc020083e:	0000c517          	auipc	a0,0xc
ffffffffc0200842:	8ca50513          	addi	a0,a0,-1846 # ffffffffc020c108 <etext+0x3d0>
ffffffffc0200846:	961ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020084a:	64e2                	ld	s1,24(sp)
ffffffffc020084c:	6942                	ld	s2,16(sp)
ffffffffc020084e:	0000c517          	auipc	a0,0xc
ffffffffc0200852:	8f250513          	addi	a0,a0,-1806 # ffffffffc020c140 <etext+0x408>
ffffffffc0200856:	7402                	ld	s0,32(sp)
ffffffffc0200858:	70a2                	ld	ra,40(sp)
ffffffffc020085a:	6145                	addi	sp,sp,48
ffffffffc020085c:	b2a9                	j	ffffffffc02001a6 <cprintf>
ffffffffc020085e:	7402                	ld	s0,32(sp)
ffffffffc0200860:	70a2                	ld	ra,40(sp)
ffffffffc0200862:	0000b517          	auipc	a0,0xb
ffffffffc0200866:	7fe50513          	addi	a0,a0,2046 # ffffffffc020c060 <etext+0x328>
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
ffffffffc02008a8:	3740b0ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc02008ac:	84aa                	mv	s1,a0
ffffffffc02008ae:	4619                	li	a2,6
ffffffffc02008b0:	8522                	mv	a0,s0
ffffffffc02008b2:	0000b597          	auipc	a1,0xb
ffffffffc02008b6:	7d658593          	addi	a1,a1,2006 # ffffffffc020c088 <etext+0x350>
ffffffffc02008ba:	3dc0b0ef          	jal	ffffffffc020bc96 <strncmp>
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
ffffffffc02008e2:	7b258593          	addi	a1,a1,1970 # ffffffffc020c090 <etext+0x358>
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
ffffffffc0200914:	34e0b0ef          	jal	ffffffffc020bc62 <strcmp>
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
ffffffffc0200938:	76450513          	addi	a0,a0,1892 # ffffffffc020c098 <etext+0x360>
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
ffffffffc0200a02:	6ba50513          	addi	a0,a0,1722 # ffffffffc020c0b8 <etext+0x380>
ffffffffc0200a06:	fa0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200a0a:	01445613          	srli	a2,s0,0x14
ffffffffc0200a0e:	85a2                	mv	a1,s0
ffffffffc0200a10:	0000b517          	auipc	a0,0xb
ffffffffc0200a14:	6c050513          	addi	a0,a0,1728 # ffffffffc020c0d0 <etext+0x398>
ffffffffc0200a18:	f8eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200a1c:	009405b3          	add	a1,s0,s1
ffffffffc0200a20:	15fd                	addi	a1,a1,-1
ffffffffc0200a22:	0000b517          	auipc	a0,0xb
ffffffffc0200a26:	6ce50513          	addi	a0,a0,1742 # ffffffffc020c0f0 <etext+0x3b8>
ffffffffc0200a2a:	f7cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200a2e:	00097797          	auipc	a5,0x97
ffffffffc0200a32:	e497b923          	sd	s1,-430(a5) # ffffffffc0297880 <memory_base>
ffffffffc0200a36:	00097797          	auipc	a5,0x97
ffffffffc0200a3a:	e487b123          	sd	s0,-446(a5) # ffffffffc0297878 <memory_size>
ffffffffc0200a3e:	b531                	j	ffffffffc020084a <dtb_init+0x13c>

ffffffffc0200a40 <get_memory_base>:
ffffffffc0200a40:	00097517          	auipc	a0,0x97
ffffffffc0200a44:	e4053503          	ld	a0,-448(a0) # ffffffffc0297880 <memory_base>
ffffffffc0200a48:	8082                	ret

ffffffffc0200a4a <get_memory_size>:
ffffffffc0200a4a:	00097517          	auipc	a0,0x97
ffffffffc0200a4e:	e2e53503          	ld	a0,-466(a0) # ffffffffc0297878 <memory_size>
ffffffffc0200a52:	8082                	ret

ffffffffc0200a54 <ide_init>:
ffffffffc0200a54:	1141                	addi	sp,sp,-16
ffffffffc0200a56:	00092597          	auipc	a1,0x92
ffffffffc0200a5a:	c6258593          	addi	a1,a1,-926 # ffffffffc02926b8 <ide_devices+0x50>
ffffffffc0200a5e:	4505                	li	a0,1
ffffffffc0200a60:	00092797          	auipc	a5,0x92
ffffffffc0200a64:	c007a423          	sw	zero,-1016(a5) # ffffffffc0292668 <ide_devices>
ffffffffc0200a68:	00092797          	auipc	a5,0x92
ffffffffc0200a6c:	c407a823          	sw	zero,-944(a5) # ffffffffc02926b8 <ide_devices+0x50>
ffffffffc0200a70:	00092797          	auipc	a5,0x92
ffffffffc0200a74:	c807ac23          	sw	zero,-872(a5) # ffffffffc0292708 <ide_devices+0xa0>
ffffffffc0200a78:	00092797          	auipc	a5,0x92
ffffffffc0200a7c:	ce07a023          	sw	zero,-800(a5) # ffffffffc0292758 <ide_devices+0xf0>
ffffffffc0200a80:	e406                	sd	ra,8(sp)
ffffffffc0200a82:	24c000ef          	jal	ffffffffc0200cce <ramdisk_init>
ffffffffc0200a86:	00092797          	auipc	a5,0x92
ffffffffc0200a8a:	c327a783          	lw	a5,-974(a5) # ffffffffc02926b8 <ide_devices+0x50>
ffffffffc0200a8e:	c385                	beqz	a5,ffffffffc0200aae <ide_init+0x5a>
ffffffffc0200a90:	00092597          	auipc	a1,0x92
ffffffffc0200a94:	c7858593          	addi	a1,a1,-904 # ffffffffc0292708 <ide_devices+0xa0>
ffffffffc0200a98:	4509                	li	a0,2
ffffffffc0200a9a:	234000ef          	jal	ffffffffc0200cce <ramdisk_init>
ffffffffc0200a9e:	00092797          	auipc	a5,0x92
ffffffffc0200aa2:	c6a7a783          	lw	a5,-918(a5) # ffffffffc0292708 <ide_devices+0xa0>
ffffffffc0200aa6:	c39d                	beqz	a5,ffffffffc0200acc <ide_init+0x78>
ffffffffc0200aa8:	60a2                	ld	ra,8(sp)
ffffffffc0200aaa:	0141                	addi	sp,sp,16
ffffffffc0200aac:	8082                	ret
ffffffffc0200aae:	0000b697          	auipc	a3,0xb
ffffffffc0200ab2:	6aa68693          	addi	a3,a3,1706 # ffffffffc020c158 <etext+0x420>
ffffffffc0200ab6:	0000b617          	auipc	a2,0xb
ffffffffc0200aba:	6ba60613          	addi	a2,a2,1722 # ffffffffc020c170 <etext+0x438>
ffffffffc0200abe:	45c5                	li	a1,17
ffffffffc0200ac0:	0000b517          	auipc	a0,0xb
ffffffffc0200ac4:	6c850513          	addi	a0,a0,1736 # ffffffffc020c188 <etext+0x450>
ffffffffc0200ac8:	983ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200acc:	0000b697          	auipc	a3,0xb
ffffffffc0200ad0:	6d468693          	addi	a3,a3,1748 # ffffffffc020c1a0 <etext+0x468>
ffffffffc0200ad4:	0000b617          	auipc	a2,0xb
ffffffffc0200ad8:	69c60613          	addi	a2,a2,1692 # ffffffffc020c170 <etext+0x438>
ffffffffc0200adc:	45d1                	li	a1,20
ffffffffc0200ade:	0000b517          	auipc	a0,0xb
ffffffffc0200ae2:	6aa50513          	addi	a0,a0,1706 # ffffffffc020c188 <etext+0x450>
ffffffffc0200ae6:	965ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200aea <ide_device_valid>:
ffffffffc0200aea:	478d                	li	a5,3
ffffffffc0200aec:	00a7ef63          	bltu	a5,a0,ffffffffc0200b0a <ide_device_valid+0x20>
ffffffffc0200af0:	00251793          	slli	a5,a0,0x2
ffffffffc0200af4:	97aa                	add	a5,a5,a0
ffffffffc0200af6:	00092717          	auipc	a4,0x92
ffffffffc0200afa:	b7270713          	addi	a4,a4,-1166 # ffffffffc0292668 <ide_devices>
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
ffffffffc0200b1a:	00092717          	auipc	a4,0x92
ffffffffc0200b1e:	b4e70713          	addi	a4,a4,-1202 # ffffffffc0292668 <ide_devices>
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
ffffffffc0200b52:	00092817          	auipc	a6,0x92
ffffffffc0200b56:	b1680813          	addi	a6,a6,-1258 # ffffffffc0292668 <ide_devices>
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
ffffffffc0200b94:	62868693          	addi	a3,a3,1576 # ffffffffc020c1b8 <etext+0x480>
ffffffffc0200b98:	0000b617          	auipc	a2,0xb
ffffffffc0200b9c:	5d860613          	addi	a2,a2,1496 # ffffffffc020c170 <etext+0x438>
ffffffffc0200ba0:	02200593          	li	a1,34
ffffffffc0200ba4:	0000b517          	auipc	a0,0xb
ffffffffc0200ba8:	5e450513          	addi	a0,a0,1508 # ffffffffc020c188 <etext+0x450>
ffffffffc0200bac:	89fff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200bb0:	0000b697          	auipc	a3,0xb
ffffffffc0200bb4:	63068693          	addi	a3,a3,1584 # ffffffffc020c1e0 <etext+0x4a8>
ffffffffc0200bb8:	0000b617          	auipc	a2,0xb
ffffffffc0200bbc:	5b860613          	addi	a2,a2,1464 # ffffffffc020c170 <etext+0x438>
ffffffffc0200bc0:	02300593          	li	a1,35
ffffffffc0200bc4:	0000b517          	auipc	a0,0xb
ffffffffc0200bc8:	5c450513          	addi	a0,a0,1476 # ffffffffc020c188 <etext+0x450>
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
ffffffffc0200bec:	00092817          	auipc	a6,0x92
ffffffffc0200bf0:	a7c80813          	addi	a6,a6,-1412 # ffffffffc0292668 <ide_devices>
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
ffffffffc0200c2e:	58e68693          	addi	a3,a3,1422 # ffffffffc020c1b8 <etext+0x480>
ffffffffc0200c32:	0000b617          	auipc	a2,0xb
ffffffffc0200c36:	53e60613          	addi	a2,a2,1342 # ffffffffc020c170 <etext+0x438>
ffffffffc0200c3a:	02900593          	li	a1,41
ffffffffc0200c3e:	0000b517          	auipc	a0,0xb
ffffffffc0200c42:	54a50513          	addi	a0,a0,1354 # ffffffffc020c188 <etext+0x450>
ffffffffc0200c46:	805ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0200c4a:	0000b697          	auipc	a3,0xb
ffffffffc0200c4e:	59668693          	addi	a3,a3,1430 # ffffffffc020c1e0 <etext+0x4a8>
ffffffffc0200c52:	0000b617          	auipc	a2,0xb
ffffffffc0200c56:	51e60613          	addi	a2,a2,1310 # ffffffffc020c170 <etext+0x438>
ffffffffc0200c5a:	02a00593          	li	a1,42
ffffffffc0200c5e:	0000b517          	auipc	a0,0xb
ffffffffc0200c62:	52a50513          	addi	a0,a0,1322 # ffffffffc020c188 <etext+0x450>
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
ffffffffc0200c98:	0880b0ef          	jal	ffffffffc020bd20 <memcpy>
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
ffffffffc0200cc2:	05e0b0ef          	jal	ffffffffc020bd20 <memcpy>
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
ffffffffc0200ce2:	7ef0a0ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0200ce6:	4785                	li	a5,1
ffffffffc0200ce8:	06f48a63          	beq	s1,a5,ffffffffc0200d5c <ramdisk_init+0x8e>
ffffffffc0200cec:	4789                	li	a5,2
ffffffffc0200cee:	00091617          	auipc	a2,0x91
ffffffffc0200cf2:	32260613          	addi	a2,a2,802 # ffffffffc0292010 <arena>
ffffffffc0200cf6:	0001c597          	auipc	a1,0x1c
ffffffffc0200cfa:	01a58593          	addi	a1,a1,26 # ffffffffc021cd10 <_binary_bin_sfs_img_start>
ffffffffc0200cfe:	08f49363          	bne	s1,a5,ffffffffc0200d84 <ramdisk_init+0xb6>
ffffffffc0200d02:	06c58763          	beq	a1,a2,ffffffffc0200d70 <ramdisk_init+0xa2>
ffffffffc0200d06:	40b604b3          	sub	s1,a2,a1
ffffffffc0200d0a:	86a6                	mv	a3,s1
ffffffffc0200d0c:	167d                	addi	a2,a2,-1
ffffffffc0200d0e:	0000b517          	auipc	a0,0xb
ffffffffc0200d12:	52a50513          	addi	a0,a0,1322 # ffffffffc020c238 <etext+0x500>
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
ffffffffc0200d36:	55e58593          	addi	a1,a1,1374 # ffffffffc020c290 <etext+0x558>
ffffffffc0200d3a:	7170a0ef          	jal	ffffffffc020bc50 <strcpy>
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
ffffffffc0200d5c:	0001c617          	auipc	a2,0x1c
ffffffffc0200d60:	fb460613          	addi	a2,a2,-76 # ffffffffc021cd10 <_binary_bin_sfs_img_start>
ffffffffc0200d64:	00014597          	auipc	a1,0x14
ffffffffc0200d68:	2ac58593          	addi	a1,a1,684 # ffffffffc0215010 <_binary_bin_swap_img_start>
ffffffffc0200d6c:	f8c59de3          	bne	a1,a2,ffffffffc0200d06 <ramdisk_init+0x38>
ffffffffc0200d70:	7402                	ld	s0,32(sp)
ffffffffc0200d72:	70a2                	ld	ra,40(sp)
ffffffffc0200d74:	64e2                	ld	s1,24(sp)
ffffffffc0200d76:	0000b517          	auipc	a0,0xb
ffffffffc0200d7a:	4aa50513          	addi	a0,a0,1194 # ffffffffc020c220 <etext+0x4e8>
ffffffffc0200d7e:	6145                	addi	sp,sp,48
ffffffffc0200d80:	c26ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0200d84:	0000b617          	auipc	a2,0xb
ffffffffc0200d88:	4dc60613          	addi	a2,a2,1244 # ffffffffc020c260 <etext+0x528>
ffffffffc0200d8c:	03200593          	li	a1,50
ffffffffc0200d90:	0000b517          	auipc	a0,0xb
ffffffffc0200d94:	4e850513          	addi	a0,a0,1256 # ffffffffc020c278 <etext+0x540>
ffffffffc0200d98:	eb2ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0200d9c <idt_init>:
ffffffffc0200d9c:	14005073          	csrwi	sscratch,0
ffffffffc0200da0:	00000797          	auipc	a5,0x0
ffffffffc0200da4:	5ac78793          	addi	a5,a5,1452 # ffffffffc020134c <__alltraps>
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
ffffffffc0200dc2:	4e250513          	addi	a0,a0,1250 # ffffffffc020c2a0 <etext+0x568>
ffffffffc0200dc6:	e406                	sd	ra,8(sp)
ffffffffc0200dc8:	bdeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dcc:	640c                	ld	a1,8(s0)
ffffffffc0200dce:	0000b517          	auipc	a0,0xb
ffffffffc0200dd2:	4ea50513          	addi	a0,a0,1258 # ffffffffc020c2b8 <etext+0x580>
ffffffffc0200dd6:	bd0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200dda:	680c                	ld	a1,16(s0)
ffffffffc0200ddc:	0000b517          	auipc	a0,0xb
ffffffffc0200de0:	4f450513          	addi	a0,a0,1268 # ffffffffc020c2d0 <etext+0x598>
ffffffffc0200de4:	bc2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200de8:	6c0c                	ld	a1,24(s0)
ffffffffc0200dea:	0000b517          	auipc	a0,0xb
ffffffffc0200dee:	4fe50513          	addi	a0,a0,1278 # ffffffffc020c2e8 <etext+0x5b0>
ffffffffc0200df2:	bb4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200df6:	700c                	ld	a1,32(s0)
ffffffffc0200df8:	0000b517          	auipc	a0,0xb
ffffffffc0200dfc:	50850513          	addi	a0,a0,1288 # ffffffffc020c300 <etext+0x5c8>
ffffffffc0200e00:	ba6ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e04:	740c                	ld	a1,40(s0)
ffffffffc0200e06:	0000b517          	auipc	a0,0xb
ffffffffc0200e0a:	51250513          	addi	a0,a0,1298 # ffffffffc020c318 <etext+0x5e0>
ffffffffc0200e0e:	b98ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e12:	780c                	ld	a1,48(s0)
ffffffffc0200e14:	0000b517          	auipc	a0,0xb
ffffffffc0200e18:	51c50513          	addi	a0,a0,1308 # ffffffffc020c330 <etext+0x5f8>
ffffffffc0200e1c:	b8aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e20:	7c0c                	ld	a1,56(s0)
ffffffffc0200e22:	0000b517          	auipc	a0,0xb
ffffffffc0200e26:	52650513          	addi	a0,a0,1318 # ffffffffc020c348 <etext+0x610>
ffffffffc0200e2a:	b7cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e2e:	602c                	ld	a1,64(s0)
ffffffffc0200e30:	0000b517          	auipc	a0,0xb
ffffffffc0200e34:	53050513          	addi	a0,a0,1328 # ffffffffc020c360 <etext+0x628>
ffffffffc0200e38:	b6eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e3c:	642c                	ld	a1,72(s0)
ffffffffc0200e3e:	0000b517          	auipc	a0,0xb
ffffffffc0200e42:	53a50513          	addi	a0,a0,1338 # ffffffffc020c378 <etext+0x640>
ffffffffc0200e46:	b60ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e4a:	682c                	ld	a1,80(s0)
ffffffffc0200e4c:	0000b517          	auipc	a0,0xb
ffffffffc0200e50:	54450513          	addi	a0,a0,1348 # ffffffffc020c390 <etext+0x658>
ffffffffc0200e54:	b52ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e58:	6c2c                	ld	a1,88(s0)
ffffffffc0200e5a:	0000b517          	auipc	a0,0xb
ffffffffc0200e5e:	54e50513          	addi	a0,a0,1358 # ffffffffc020c3a8 <etext+0x670>
ffffffffc0200e62:	b44ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e66:	702c                	ld	a1,96(s0)
ffffffffc0200e68:	0000b517          	auipc	a0,0xb
ffffffffc0200e6c:	55850513          	addi	a0,a0,1368 # ffffffffc020c3c0 <etext+0x688>
ffffffffc0200e70:	b36ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e74:	742c                	ld	a1,104(s0)
ffffffffc0200e76:	0000b517          	auipc	a0,0xb
ffffffffc0200e7a:	56250513          	addi	a0,a0,1378 # ffffffffc020c3d8 <etext+0x6a0>
ffffffffc0200e7e:	b28ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e82:	782c                	ld	a1,112(s0)
ffffffffc0200e84:	0000b517          	auipc	a0,0xb
ffffffffc0200e88:	56c50513          	addi	a0,a0,1388 # ffffffffc020c3f0 <etext+0x6b8>
ffffffffc0200e8c:	b1aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e90:	7c2c                	ld	a1,120(s0)
ffffffffc0200e92:	0000b517          	auipc	a0,0xb
ffffffffc0200e96:	57650513          	addi	a0,a0,1398 # ffffffffc020c408 <etext+0x6d0>
ffffffffc0200e9a:	b0cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200e9e:	604c                	ld	a1,128(s0)
ffffffffc0200ea0:	0000b517          	auipc	a0,0xb
ffffffffc0200ea4:	58050513          	addi	a0,a0,1408 # ffffffffc020c420 <etext+0x6e8>
ffffffffc0200ea8:	afeff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eac:	644c                	ld	a1,136(s0)
ffffffffc0200eae:	0000b517          	auipc	a0,0xb
ffffffffc0200eb2:	58a50513          	addi	a0,a0,1418 # ffffffffc020c438 <etext+0x700>
ffffffffc0200eb6:	af0ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200eba:	684c                	ld	a1,144(s0)
ffffffffc0200ebc:	0000b517          	auipc	a0,0xb
ffffffffc0200ec0:	59450513          	addi	a0,a0,1428 # ffffffffc020c450 <etext+0x718>
ffffffffc0200ec4:	ae2ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ec8:	6c4c                	ld	a1,152(s0)
ffffffffc0200eca:	0000b517          	auipc	a0,0xb
ffffffffc0200ece:	59e50513          	addi	a0,a0,1438 # ffffffffc020c468 <etext+0x730>
ffffffffc0200ed2:	ad4ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ed6:	704c                	ld	a1,160(s0)
ffffffffc0200ed8:	0000b517          	auipc	a0,0xb
ffffffffc0200edc:	5a850513          	addi	a0,a0,1448 # ffffffffc020c480 <etext+0x748>
ffffffffc0200ee0:	ac6ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ee4:	744c                	ld	a1,168(s0)
ffffffffc0200ee6:	0000b517          	auipc	a0,0xb
ffffffffc0200eea:	5b250513          	addi	a0,a0,1458 # ffffffffc020c498 <etext+0x760>
ffffffffc0200eee:	ab8ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200ef2:	784c                	ld	a1,176(s0)
ffffffffc0200ef4:	0000b517          	auipc	a0,0xb
ffffffffc0200ef8:	5bc50513          	addi	a0,a0,1468 # ffffffffc020c4b0 <etext+0x778>
ffffffffc0200efc:	aaaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f00:	7c4c                	ld	a1,184(s0)
ffffffffc0200f02:	0000b517          	auipc	a0,0xb
ffffffffc0200f06:	5c650513          	addi	a0,a0,1478 # ffffffffc020c4c8 <etext+0x790>
ffffffffc0200f0a:	a9cff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f0e:	606c                	ld	a1,192(s0)
ffffffffc0200f10:	0000b517          	auipc	a0,0xb
ffffffffc0200f14:	5d050513          	addi	a0,a0,1488 # ffffffffc020c4e0 <etext+0x7a8>
ffffffffc0200f18:	a8eff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f1c:	646c                	ld	a1,200(s0)
ffffffffc0200f1e:	0000b517          	auipc	a0,0xb
ffffffffc0200f22:	5da50513          	addi	a0,a0,1498 # ffffffffc020c4f8 <etext+0x7c0>
ffffffffc0200f26:	a80ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f2a:	686c                	ld	a1,208(s0)
ffffffffc0200f2c:	0000b517          	auipc	a0,0xb
ffffffffc0200f30:	5e450513          	addi	a0,a0,1508 # ffffffffc020c510 <etext+0x7d8>
ffffffffc0200f34:	a72ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f38:	6c6c                	ld	a1,216(s0)
ffffffffc0200f3a:	0000b517          	auipc	a0,0xb
ffffffffc0200f3e:	5ee50513          	addi	a0,a0,1518 # ffffffffc020c528 <etext+0x7f0>
ffffffffc0200f42:	a64ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f46:	706c                	ld	a1,224(s0)
ffffffffc0200f48:	0000b517          	auipc	a0,0xb
ffffffffc0200f4c:	5f850513          	addi	a0,a0,1528 # ffffffffc020c540 <etext+0x808>
ffffffffc0200f50:	a56ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f54:	746c                	ld	a1,232(s0)
ffffffffc0200f56:	0000b517          	auipc	a0,0xb
ffffffffc0200f5a:	60250513          	addi	a0,a0,1538 # ffffffffc020c558 <etext+0x820>
ffffffffc0200f5e:	a48ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f62:	786c                	ld	a1,240(s0)
ffffffffc0200f64:	0000b517          	auipc	a0,0xb
ffffffffc0200f68:	60c50513          	addi	a0,a0,1548 # ffffffffc020c570 <etext+0x838>
ffffffffc0200f6c:	a3aff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f70:	7c6c                	ld	a1,248(s0)
ffffffffc0200f72:	6402                	ld	s0,0(sp)
ffffffffc0200f74:	60a2                	ld	ra,8(sp)
ffffffffc0200f76:	0000b517          	auipc	a0,0xb
ffffffffc0200f7a:	61250513          	addi	a0,a0,1554 # ffffffffc020c588 <etext+0x850>
ffffffffc0200f7e:	0141                	addi	sp,sp,16
ffffffffc0200f80:	a26ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200f84 <print_trapframe>:
ffffffffc0200f84:	1141                	addi	sp,sp,-16
ffffffffc0200f86:	e022                	sd	s0,0(sp)
ffffffffc0200f88:	85aa                	mv	a1,a0
ffffffffc0200f8a:	842a                	mv	s0,a0
ffffffffc0200f8c:	0000b517          	auipc	a0,0xb
ffffffffc0200f90:	61450513          	addi	a0,a0,1556 # ffffffffc020c5a0 <etext+0x868>
ffffffffc0200f94:	e406                	sd	ra,8(sp)
ffffffffc0200f96:	a10ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200f9a:	8522                	mv	a0,s0
ffffffffc0200f9c:	e1bff0ef          	jal	ffffffffc0200db6 <print_regs>
ffffffffc0200fa0:	10043583          	ld	a1,256(s0)
ffffffffc0200fa4:	0000b517          	auipc	a0,0xb
ffffffffc0200fa8:	61450513          	addi	a0,a0,1556 # ffffffffc020c5b8 <etext+0x880>
ffffffffc0200fac:	9faff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200fb0:	10843583          	ld	a1,264(s0)
ffffffffc0200fb4:	0000b517          	auipc	a0,0xb
ffffffffc0200fb8:	61c50513          	addi	a0,a0,1564 # ffffffffc020c5d0 <etext+0x898>
ffffffffc0200fbc:	9eaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200fc0:	11043583          	ld	a1,272(s0)
ffffffffc0200fc4:	0000b517          	auipc	a0,0xb
ffffffffc0200fc8:	62450513          	addi	a0,a0,1572 # ffffffffc020c5e8 <etext+0x8b0>
ffffffffc0200fcc:	9daff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0200fd0:	11843583          	ld	a1,280(s0)
ffffffffc0200fd4:	6402                	ld	s0,0(sp)
ffffffffc0200fd6:	60a2                	ld	ra,8(sp)
ffffffffc0200fd8:	0000b517          	auipc	a0,0xb
ffffffffc0200fdc:	62050513          	addi	a0,a0,1568 # ffffffffc020c5f8 <etext+0x8c0>
ffffffffc0200fe0:	0141                	addi	sp,sp,16
ffffffffc0200fe2:	9c4ff06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0200fe6 <interrupt_handler>:
ffffffffc0200fe6:	11853783          	ld	a5,280(a0)
ffffffffc0200fea:	472d                	li	a4,11
ffffffffc0200fec:	0786                	slli	a5,a5,0x1
ffffffffc0200fee:	8385                	srli	a5,a5,0x1
ffffffffc0200ff0:	06f76c63          	bltu	a4,a5,ffffffffc0201068 <interrupt_handler+0x82>
ffffffffc0200ff4:	0000e717          	auipc	a4,0xe
ffffffffc0200ff8:	3bc70713          	addi	a4,a4,956 # ffffffffc020f3b0 <commands+0x48>
ffffffffc0200ffc:	078a                	slli	a5,a5,0x2
ffffffffc0200ffe:	97ba                	add	a5,a5,a4
ffffffffc0201000:	439c                	lw	a5,0(a5)
ffffffffc0201002:	97ba                	add	a5,a5,a4
ffffffffc0201004:	8782                	jr	a5
ffffffffc0201006:	0000b517          	auipc	a0,0xb
ffffffffc020100a:	66a50513          	addi	a0,a0,1642 # ffffffffc020c670 <etext+0x938>
ffffffffc020100e:	998ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201012:	0000b517          	auipc	a0,0xb
ffffffffc0201016:	63e50513          	addi	a0,a0,1598 # ffffffffc020c650 <etext+0x918>
ffffffffc020101a:	98cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020101e:	0000b517          	auipc	a0,0xb
ffffffffc0201022:	5f250513          	addi	a0,a0,1522 # ffffffffc020c610 <etext+0x8d8>
ffffffffc0201026:	980ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020102a:	0000b517          	auipc	a0,0xb
ffffffffc020102e:	60650513          	addi	a0,a0,1542 # ffffffffc020c630 <etext+0x8f8>
ffffffffc0201032:	974ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201036:	1141                	addi	sp,sp,-16
ffffffffc0201038:	e406                	sd	ra,8(sp)
ffffffffc020103a:	ceeff0ef          	jal	ffffffffc0200528 <clock_set_next_event>
ffffffffc020103e:	d02ff0ef          	jal	ffffffffc0200540 <serial_intr>
ffffffffc0201042:	00097797          	auipc	a5,0x97
ffffffffc0201046:	82e7b783          	ld	a5,-2002(a5) # ffffffffc0297870 <ticks>
ffffffffc020104a:	60a2                	ld	ra,8(sp)
ffffffffc020104c:	0785                	addi	a5,a5,1
ffffffffc020104e:	00097717          	auipc	a4,0x97
ffffffffc0201052:	82f73123          	sd	a5,-2014(a4) # ffffffffc0297870 <ticks>
ffffffffc0201056:	0141                	addi	sp,sp,16
ffffffffc0201058:	3cb0606f          	j	ffffffffc0207c22 <run_timer_list>
ffffffffc020105c:	0000b517          	auipc	a0,0xb
ffffffffc0201060:	63450513          	addi	a0,a0,1588 # ffffffffc020c690 <etext+0x958>
ffffffffc0201064:	942ff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201068:	bf31                	j	ffffffffc0200f84 <print_trapframe>

ffffffffc020106a <pgfault_handler>:
ffffffffc020106a:	11853703          	ld	a4,280(a0)
ffffffffc020106e:	1141                	addi	sp,sp,-16
ffffffffc0201070:	e022                	sd	s0,0(sp)
ffffffffc0201072:	e406                	sd	ra,8(sp)
ffffffffc0201074:	47b5                	li	a5,13
ffffffffc0201076:	11053583          	ld	a1,272(a0)
ffffffffc020107a:	842a                	mv	s0,a0
ffffffffc020107c:	05200613          	li	a2,82
ffffffffc0201080:	00f70463          	beq	a4,a5,ffffffffc0201088 <pgfault_handler+0x1e>
ffffffffc0201084:	05700613          	li	a2,87
ffffffffc0201088:	10043783          	ld	a5,256(s0)
ffffffffc020108c:	05500693          	li	a3,85
ffffffffc0201090:	1007f793          	andi	a5,a5,256
ffffffffc0201094:	c399                	beqz	a5,ffffffffc020109a <pgfault_handler+0x30>
ffffffffc0201096:	04b00693          	li	a3,75
ffffffffc020109a:	0000b517          	auipc	a0,0xb
ffffffffc020109e:	61650513          	addi	a0,a0,1558 # ffffffffc020c6b0 <etext+0x978>
ffffffffc02010a2:	904ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02010a6:	11043603          	ld	a2,272(s0)
ffffffffc02010aa:	ca0d                	beqz	a2,ffffffffc02010dc <pgfault_handler+0x72>
ffffffffc02010ac:	c1500793          	li	a5,-1003
ffffffffc02010b0:	07da                	slli	a5,a5,0x16
ffffffffc02010b2:	97b2                	add	a5,a5,a2
ffffffffc02010b4:	c785                	beqz	a5,ffffffffc02010dc <pgfault_handler+0x72>
ffffffffc02010b6:	00097517          	auipc	a0,0x97
ffffffffc02010ba:	80a53503          	ld	a0,-2038(a0) # ffffffffc02978c0 <check_mm_struct>
ffffffffc02010be:	e901                	bnez	a0,ffffffffc02010ce <pgfault_handler+0x64>
ffffffffc02010c0:	00097797          	auipc	a5,0x97
ffffffffc02010c4:	8107b783          	ld	a5,-2032(a5) # ffffffffc02978d0 <current>
ffffffffc02010c8:	cf85                	beqz	a5,ffffffffc0201100 <pgfault_handler+0x96>
ffffffffc02010ca:	7788                	ld	a0,40(a5)
ffffffffc02010cc:	c915                	beqz	a0,ffffffffc0201100 <pgfault_handler+0x96>
ffffffffc02010ce:	11842583          	lw	a1,280(s0)
ffffffffc02010d2:	6402                	ld	s0,0(sp)
ffffffffc02010d4:	60a2                	ld	ra,8(sp)
ffffffffc02010d6:	0141                	addi	sp,sp,16
ffffffffc02010d8:	33a0306f          	j	ffffffffc0204412 <do_pgfault>
ffffffffc02010dc:	11843703          	ld	a4,280(s0)
ffffffffc02010e0:	47b5                	li	a5,13
ffffffffc02010e2:	fcf71ae3          	bne	a4,a5,ffffffffc02010b6 <pgfault_handler+0x4c>
ffffffffc02010e6:	10043783          	ld	a5,256(s0)
ffffffffc02010ea:	1007f793          	andi	a5,a5,256
ffffffffc02010ee:	f7e1                	bnez	a5,ffffffffc02010b6 <pgfault_handler+0x4c>
ffffffffc02010f0:	2601                	sext.w	a2,a2
ffffffffc02010f2:	4581                	li	a1,0
ffffffffc02010f4:	0000b517          	auipc	a0,0xb
ffffffffc02010f8:	5dc50513          	addi	a0,a0,1500 # ffffffffc020c6d0 <etext+0x998>
ffffffffc02010fc:	8aaff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0201100:	60a2                	ld	ra,8(sp)
ffffffffc0201102:	6402                	ld	s0,0(sp)
ffffffffc0201104:	5575                	li	a0,-3
ffffffffc0201106:	0141                	addi	sp,sp,16
ffffffffc0201108:	8082                	ret

ffffffffc020110a <exception_handler>:
ffffffffc020110a:	11853783          	ld	a5,280(a0)
ffffffffc020110e:	473d                	li	a4,15
ffffffffc0201110:	18f76e63          	bltu	a4,a5,ffffffffc02012ac <exception_handler+0x1a2>
ffffffffc0201114:	0000e717          	auipc	a4,0xe
ffffffffc0201118:	2cc70713          	addi	a4,a4,716 # ffffffffc020f3e0 <commands+0x78>
ffffffffc020111c:	078a                	slli	a5,a5,0x2
ffffffffc020111e:	97ba                	add	a5,a5,a4
ffffffffc0201120:	439c                	lw	a5,0(a5)
ffffffffc0201122:	1101                	addi	sp,sp,-32
ffffffffc0201124:	ec06                	sd	ra,24(sp)
ffffffffc0201126:	97ba                	add	a5,a5,a4
ffffffffc0201128:	862a                	mv	a2,a0
ffffffffc020112a:	8782                	jr	a5
ffffffffc020112c:	e02a                	sd	a0,0(sp)
ffffffffc020112e:	0000b517          	auipc	a0,0xb
ffffffffc0201132:	6a250513          	addi	a0,a0,1698 # ffffffffc020c7d0 <etext+0xa98>
ffffffffc0201136:	870ff0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020113a:	6602                	ld	a2,0(sp)
ffffffffc020113c:	10863783          	ld	a5,264(a2)
ffffffffc0201140:	60e2                	ld	ra,24(sp)
ffffffffc0201142:	0791                	addi	a5,a5,4
ffffffffc0201144:	10f63423          	sd	a5,264(a2)
ffffffffc0201148:	6105                	addi	sp,sp,32
ffffffffc020114a:	5290606f          	j	ffffffffc0207e72 <syscall>
ffffffffc020114e:	60e2                	ld	ra,24(sp)
ffffffffc0201150:	0000b517          	auipc	a0,0xb
ffffffffc0201154:	6a050513          	addi	a0,a0,1696 # ffffffffc020c7f0 <etext+0xab8>
ffffffffc0201158:	6105                	addi	sp,sp,32
ffffffffc020115a:	84cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020115e:	60e2                	ld	ra,24(sp)
ffffffffc0201160:	0000b517          	auipc	a0,0xb
ffffffffc0201164:	6b050513          	addi	a0,a0,1712 # ffffffffc020c810 <etext+0xad8>
ffffffffc0201168:	6105                	addi	sp,sp,32
ffffffffc020116a:	83cff06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020116e:	e02a                	sd	a0,0(sp)
ffffffffc0201170:	efbff0ef          	jal	ffffffffc020106a <pgfault_handler>
ffffffffc0201174:	6602                	ld	a2,0(sp)
ffffffffc0201176:	10051463          	bnez	a0,ffffffffc020127e <exception_handler+0x174>
ffffffffc020117a:	60e2                	ld	ra,24(sp)
ffffffffc020117c:	6105                	addi	sp,sp,32
ffffffffc020117e:	8082                	ret
ffffffffc0201180:	e02a                	sd	a0,0(sp)
ffffffffc0201182:	ee9ff0ef          	jal	ffffffffc020106a <pgfault_handler>
ffffffffc0201186:	6602                	ld	a2,0(sp)
ffffffffc0201188:	d96d                	beqz	a0,ffffffffc020117a <exception_handler+0x70>
ffffffffc020118a:	e42a                	sd	a0,8(sp)
ffffffffc020118c:	8532                	mv	a0,a2
ffffffffc020118e:	df7ff0ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc0201192:	6602                	ld	a2,0(sp)
ffffffffc0201194:	66a2                	ld	a3,8(sp)
ffffffffc0201196:	10063783          	ld	a5,256(a2)
ffffffffc020119a:	1007f793          	andi	a5,a5,256
ffffffffc020119e:	cf95                	beqz	a5,ffffffffc02011da <exception_handler+0xd0>
ffffffffc02011a0:	0000b617          	auipc	a2,0xb
ffffffffc02011a4:	69060613          	addi	a2,a2,1680 # ffffffffc020c830 <etext+0xaf8>
ffffffffc02011a8:	0d700593          	li	a1,215
ffffffffc02011ac:	0000b517          	auipc	a0,0xb
ffffffffc02011b0:	5f450513          	addi	a0,a0,1524 # ffffffffc020c7a0 <etext+0xa68>
ffffffffc02011b4:	a96ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02011b8:	e02a                	sd	a0,0(sp)
ffffffffc02011ba:	eb1ff0ef          	jal	ffffffffc020106a <pgfault_handler>
ffffffffc02011be:	6602                	ld	a2,0(sp)
ffffffffc02011c0:	dd4d                	beqz	a0,ffffffffc020117a <exception_handler+0x70>
ffffffffc02011c2:	e42a                	sd	a0,8(sp)
ffffffffc02011c4:	8532                	mv	a0,a2
ffffffffc02011c6:	dbfff0ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc02011ca:	6602                	ld	a2,0(sp)
ffffffffc02011cc:	66a2                	ld	a3,8(sp)
ffffffffc02011ce:	10063783          	ld	a5,256(a2)
ffffffffc02011d2:	1007f793          	andi	a5,a5,256
ffffffffc02011d6:	0c079c63          	bnez	a5,ffffffffc02012ae <exception_handler+0x1a4>
ffffffffc02011da:	0000b517          	auipc	a0,0xb
ffffffffc02011de:	67650513          	addi	a0,a0,1654 # ffffffffc020c850 <etext+0xb18>
ffffffffc02011e2:	fc5fe0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02011e6:	60e2                	ld	ra,24(sp)
ffffffffc02011e8:	555d                	li	a0,-9
ffffffffc02011ea:	6105                	addi	sp,sp,32
ffffffffc02011ec:	77d0406f          	j	ffffffffc0206168 <do_exit>
ffffffffc02011f0:	60e2                	ld	ra,24(sp)
ffffffffc02011f2:	0000b517          	auipc	a0,0xb
ffffffffc02011f6:	4f650513          	addi	a0,a0,1270 # ffffffffc020c6e8 <etext+0x9b0>
ffffffffc02011fa:	6105                	addi	sp,sp,32
ffffffffc02011fc:	fabfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201200:	60e2                	ld	ra,24(sp)
ffffffffc0201202:	0000b517          	auipc	a0,0xb
ffffffffc0201206:	50650513          	addi	a0,a0,1286 # ffffffffc020c708 <etext+0x9d0>
ffffffffc020120a:	6105                	addi	sp,sp,32
ffffffffc020120c:	f9bfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201210:	60e2                	ld	ra,24(sp)
ffffffffc0201212:	0000b517          	auipc	a0,0xb
ffffffffc0201216:	51650513          	addi	a0,a0,1302 # ffffffffc020c728 <etext+0x9f0>
ffffffffc020121a:	6105                	addi	sp,sp,32
ffffffffc020121c:	f8bfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201220:	60e2                	ld	ra,24(sp)
ffffffffc0201222:	0000b517          	auipc	a0,0xb
ffffffffc0201226:	51e50513          	addi	a0,a0,1310 # ffffffffc020c740 <etext+0xa08>
ffffffffc020122a:	6105                	addi	sp,sp,32
ffffffffc020122c:	f7bfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201230:	60e2                	ld	ra,24(sp)
ffffffffc0201232:	0000b517          	auipc	a0,0xb
ffffffffc0201236:	51e50513          	addi	a0,a0,1310 # ffffffffc020c750 <etext+0xa18>
ffffffffc020123a:	6105                	addi	sp,sp,32
ffffffffc020123c:	f6bfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201240:	60e2                	ld	ra,24(sp)
ffffffffc0201242:	0000b517          	auipc	a0,0xb
ffffffffc0201246:	52e50513          	addi	a0,a0,1326 # ffffffffc020c770 <etext+0xa38>
ffffffffc020124a:	6105                	addi	sp,sp,32
ffffffffc020124c:	f5bfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201250:	60e2                	ld	ra,24(sp)
ffffffffc0201252:	0000b517          	auipc	a0,0xb
ffffffffc0201256:	56650513          	addi	a0,a0,1382 # ffffffffc020c7b8 <etext+0xa80>
ffffffffc020125a:	6105                	addi	sp,sp,32
ffffffffc020125c:	f4bfe06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc0201260:	60e2                	ld	ra,24(sp)
ffffffffc0201262:	6105                	addi	sp,sp,32
ffffffffc0201264:	b305                	j	ffffffffc0200f84 <print_trapframe>
ffffffffc0201266:	0000b617          	auipc	a2,0xb
ffffffffc020126a:	52260613          	addi	a2,a2,1314 # ffffffffc020c788 <etext+0xa50>
ffffffffc020126e:	0b300593          	li	a1,179
ffffffffc0201272:	0000b517          	auipc	a0,0xb
ffffffffc0201276:	52e50513          	addi	a0,a0,1326 # ffffffffc020c7a0 <etext+0xa68>
ffffffffc020127a:	9d0ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020127e:	e42a                	sd	a0,8(sp)
ffffffffc0201280:	8532                	mv	a0,a2
ffffffffc0201282:	d03ff0ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc0201286:	6602                	ld	a2,0(sp)
ffffffffc0201288:	66a2                	ld	a3,8(sp)
ffffffffc020128a:	10063783          	ld	a5,256(a2)
ffffffffc020128e:	1007f793          	andi	a5,a5,256
ffffffffc0201292:	d7a1                	beqz	a5,ffffffffc02011da <exception_handler+0xd0>
ffffffffc0201294:	0000b617          	auipc	a2,0xb
ffffffffc0201298:	59c60613          	addi	a2,a2,1436 # ffffffffc020c830 <etext+0xaf8>
ffffffffc020129c:	0cc00593          	li	a1,204
ffffffffc02012a0:	0000b517          	auipc	a0,0xb
ffffffffc02012a4:	50050513          	addi	a0,a0,1280 # ffffffffc020c7a0 <etext+0xa68>
ffffffffc02012a8:	9a2ff0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02012ac:	b9e1                	j	ffffffffc0200f84 <print_trapframe>
ffffffffc02012ae:	0000b617          	auipc	a2,0xb
ffffffffc02012b2:	58260613          	addi	a2,a2,1410 # ffffffffc020c830 <etext+0xaf8>
ffffffffc02012b6:	0e200593          	li	a1,226
ffffffffc02012ba:	0000b517          	auipc	a0,0xb
ffffffffc02012be:	4e650513          	addi	a0,a0,1254 # ffffffffc020c7a0 <etext+0xa68>
ffffffffc02012c2:	988ff0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02012c6 <trap>:
ffffffffc02012c6:	00096717          	auipc	a4,0x96
ffffffffc02012ca:	60a73703          	ld	a4,1546(a4) # ffffffffc02978d0 <current>
ffffffffc02012ce:	11853583          	ld	a1,280(a0)
ffffffffc02012d2:	cf21                	beqz	a4,ffffffffc020132a <trap+0x64>
ffffffffc02012d4:	10053603          	ld	a2,256(a0)
ffffffffc02012d8:	0a073803          	ld	a6,160(a4)
ffffffffc02012dc:	1101                	addi	sp,sp,-32
ffffffffc02012de:	ec06                	sd	ra,24(sp)
ffffffffc02012e0:	10067613          	andi	a2,a2,256
ffffffffc02012e4:	f348                	sd	a0,160(a4)
ffffffffc02012e6:	e432                	sd	a2,8(sp)
ffffffffc02012e8:	e042                	sd	a6,0(sp)
ffffffffc02012ea:	0205c763          	bltz	a1,ffffffffc0201318 <trap+0x52>
ffffffffc02012ee:	e1dff0ef          	jal	ffffffffc020110a <exception_handler>
ffffffffc02012f2:	6622                	ld	a2,8(sp)
ffffffffc02012f4:	6802                	ld	a6,0(sp)
ffffffffc02012f6:	00096697          	auipc	a3,0x96
ffffffffc02012fa:	5da68693          	addi	a3,a3,1498 # ffffffffc02978d0 <current>
ffffffffc02012fe:	6298                	ld	a4,0(a3)
ffffffffc0201300:	0b073023          	sd	a6,160(a4)
ffffffffc0201304:	e619                	bnez	a2,ffffffffc0201312 <trap+0x4c>
ffffffffc0201306:	0b072783          	lw	a5,176(a4)
ffffffffc020130a:	8b85                	andi	a5,a5,1
ffffffffc020130c:	e79d                	bnez	a5,ffffffffc020133a <trap+0x74>
ffffffffc020130e:	6f1c                	ld	a5,24(a4)
ffffffffc0201310:	e38d                	bnez	a5,ffffffffc0201332 <trap+0x6c>
ffffffffc0201312:	60e2                	ld	ra,24(sp)
ffffffffc0201314:	6105                	addi	sp,sp,32
ffffffffc0201316:	8082                	ret
ffffffffc0201318:	ccfff0ef          	jal	ffffffffc0200fe6 <interrupt_handler>
ffffffffc020131c:	6802                	ld	a6,0(sp)
ffffffffc020131e:	6622                	ld	a2,8(sp)
ffffffffc0201320:	00096697          	auipc	a3,0x96
ffffffffc0201324:	5b068693          	addi	a3,a3,1456 # ffffffffc02978d0 <current>
ffffffffc0201328:	bfd9                	j	ffffffffc02012fe <trap+0x38>
ffffffffc020132a:	0005c363          	bltz	a1,ffffffffc0201330 <trap+0x6a>
ffffffffc020132e:	bbf1                	j	ffffffffc020110a <exception_handler>
ffffffffc0201330:	b95d                	j	ffffffffc0200fe6 <interrupt_handler>
ffffffffc0201332:	60e2                	ld	ra,24(sp)
ffffffffc0201334:	6105                	addi	sp,sp,32
ffffffffc0201336:	6e20606f          	j	ffffffffc0207a18 <schedule>
ffffffffc020133a:	555d                	li	a0,-9
ffffffffc020133c:	62d040ef          	jal	ffffffffc0206168 <do_exit>
ffffffffc0201340:	00096717          	auipc	a4,0x96
ffffffffc0201344:	59073703          	ld	a4,1424(a4) # ffffffffc02978d0 <current>
ffffffffc0201348:	b7d9                	j	ffffffffc020130e <trap+0x48>
	...

ffffffffc020134c <__alltraps>:
ffffffffc020134c:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0201350:	00011463          	bnez	sp,ffffffffc0201358 <__alltraps+0xc>
ffffffffc0201354:	14002173          	csrr	sp,sscratch
ffffffffc0201358:	712d                	addi	sp,sp,-288
ffffffffc020135a:	e002                	sd	zero,0(sp)
ffffffffc020135c:	e406                	sd	ra,8(sp)
ffffffffc020135e:	ec0e                	sd	gp,24(sp)
ffffffffc0201360:	f012                	sd	tp,32(sp)
ffffffffc0201362:	f416                	sd	t0,40(sp)
ffffffffc0201364:	f81a                	sd	t1,48(sp)
ffffffffc0201366:	fc1e                	sd	t2,56(sp)
ffffffffc0201368:	e0a2                	sd	s0,64(sp)
ffffffffc020136a:	e4a6                	sd	s1,72(sp)
ffffffffc020136c:	e8aa                	sd	a0,80(sp)
ffffffffc020136e:	ecae                	sd	a1,88(sp)
ffffffffc0201370:	f0b2                	sd	a2,96(sp)
ffffffffc0201372:	f4b6                	sd	a3,104(sp)
ffffffffc0201374:	f8ba                	sd	a4,112(sp)
ffffffffc0201376:	fcbe                	sd	a5,120(sp)
ffffffffc0201378:	e142                	sd	a6,128(sp)
ffffffffc020137a:	e546                	sd	a7,136(sp)
ffffffffc020137c:	e94a                	sd	s2,144(sp)
ffffffffc020137e:	ed4e                	sd	s3,152(sp)
ffffffffc0201380:	f152                	sd	s4,160(sp)
ffffffffc0201382:	f556                	sd	s5,168(sp)
ffffffffc0201384:	f95a                	sd	s6,176(sp)
ffffffffc0201386:	fd5e                	sd	s7,184(sp)
ffffffffc0201388:	e1e2                	sd	s8,192(sp)
ffffffffc020138a:	e5e6                	sd	s9,200(sp)
ffffffffc020138c:	e9ea                	sd	s10,208(sp)
ffffffffc020138e:	edee                	sd	s11,216(sp)
ffffffffc0201390:	f1f2                	sd	t3,224(sp)
ffffffffc0201392:	f5f6                	sd	t4,232(sp)
ffffffffc0201394:	f9fa                	sd	t5,240(sp)
ffffffffc0201396:	fdfe                	sd	t6,248(sp)
ffffffffc0201398:	14001473          	csrrw	s0,sscratch,zero
ffffffffc020139c:	100024f3          	csrr	s1,sstatus
ffffffffc02013a0:	14102973          	csrr	s2,sepc
ffffffffc02013a4:	143029f3          	csrr	s3,stval
ffffffffc02013a8:	14202a73          	csrr	s4,scause
ffffffffc02013ac:	e822                	sd	s0,16(sp)
ffffffffc02013ae:	e226                	sd	s1,256(sp)
ffffffffc02013b0:	e64a                	sd	s2,264(sp)
ffffffffc02013b2:	ea4e                	sd	s3,272(sp)
ffffffffc02013b4:	ee52                	sd	s4,280(sp)
ffffffffc02013b6:	850a                	mv	a0,sp
ffffffffc02013b8:	f0fff0ef          	jal	ffffffffc02012c6 <trap>

ffffffffc02013bc <__trapret>:
ffffffffc02013bc:	6492                	ld	s1,256(sp)
ffffffffc02013be:	6932                	ld	s2,264(sp)
ffffffffc02013c0:	1004f413          	andi	s0,s1,256
ffffffffc02013c4:	e401                	bnez	s0,ffffffffc02013cc <__trapret+0x10>
ffffffffc02013c6:	1200                	addi	s0,sp,288
ffffffffc02013c8:	14041073          	csrw	sscratch,s0
ffffffffc02013cc:	10049073          	csrw	sstatus,s1
ffffffffc02013d0:	14191073          	csrw	sepc,s2
ffffffffc02013d4:	60a2                	ld	ra,8(sp)
ffffffffc02013d6:	61e2                	ld	gp,24(sp)
ffffffffc02013d8:	7202                	ld	tp,32(sp)
ffffffffc02013da:	72a2                	ld	t0,40(sp)
ffffffffc02013dc:	7342                	ld	t1,48(sp)
ffffffffc02013de:	73e2                	ld	t2,56(sp)
ffffffffc02013e0:	6406                	ld	s0,64(sp)
ffffffffc02013e2:	64a6                	ld	s1,72(sp)
ffffffffc02013e4:	6546                	ld	a0,80(sp)
ffffffffc02013e6:	65e6                	ld	a1,88(sp)
ffffffffc02013e8:	7606                	ld	a2,96(sp)
ffffffffc02013ea:	76a6                	ld	a3,104(sp)
ffffffffc02013ec:	7746                	ld	a4,112(sp)
ffffffffc02013ee:	77e6                	ld	a5,120(sp)
ffffffffc02013f0:	680a                	ld	a6,128(sp)
ffffffffc02013f2:	68aa                	ld	a7,136(sp)
ffffffffc02013f4:	694a                	ld	s2,144(sp)
ffffffffc02013f6:	69ea                	ld	s3,152(sp)
ffffffffc02013f8:	7a0a                	ld	s4,160(sp)
ffffffffc02013fa:	7aaa                	ld	s5,168(sp)
ffffffffc02013fc:	7b4a                	ld	s6,176(sp)
ffffffffc02013fe:	7bea                	ld	s7,184(sp)
ffffffffc0201400:	6c0e                	ld	s8,192(sp)
ffffffffc0201402:	6cae                	ld	s9,200(sp)
ffffffffc0201404:	6d4e                	ld	s10,208(sp)
ffffffffc0201406:	6dee                	ld	s11,216(sp)
ffffffffc0201408:	7e0e                	ld	t3,224(sp)
ffffffffc020140a:	7eae                	ld	t4,232(sp)
ffffffffc020140c:	7f4e                	ld	t5,240(sp)
ffffffffc020140e:	7fee                	ld	t6,248(sp)
ffffffffc0201410:	6142                	ld	sp,16(sp)
ffffffffc0201412:	10200073          	sret

ffffffffc0201416 <forkrets>:
ffffffffc0201416:	812a                	mv	sp,a0
ffffffffc0201418:	b755                	j	ffffffffc02013bc <__trapret>

ffffffffc020141a <default_init>:
ffffffffc020141a:	00091797          	auipc	a5,0x91
ffffffffc020141e:	38e78793          	addi	a5,a5,910 # ffffffffc02927a8 <free_area>
ffffffffc0201422:	e79c                	sd	a5,8(a5)
ffffffffc0201424:	e39c                	sd	a5,0(a5)
ffffffffc0201426:	0007a823          	sw	zero,16(a5)
ffffffffc020142a:	8082                	ret

ffffffffc020142c <default_nr_free_pages>:
ffffffffc020142c:	00091517          	auipc	a0,0x91
ffffffffc0201430:	38c56503          	lwu	a0,908(a0) # ffffffffc02927b8 <free_area+0x10>
ffffffffc0201434:	8082                	ret

ffffffffc0201436 <default_check>:
ffffffffc0201436:	711d                	addi	sp,sp,-96
ffffffffc0201438:	e0ca                	sd	s2,64(sp)
ffffffffc020143a:	00091917          	auipc	s2,0x91
ffffffffc020143e:	36e90913          	addi	s2,s2,878 # ffffffffc02927a8 <free_area>
ffffffffc0201442:	00893783          	ld	a5,8(s2)
ffffffffc0201446:	ec86                	sd	ra,88(sp)
ffffffffc0201448:	e8a2                	sd	s0,80(sp)
ffffffffc020144a:	e4a6                	sd	s1,72(sp)
ffffffffc020144c:	fc4e                	sd	s3,56(sp)
ffffffffc020144e:	f852                	sd	s4,48(sp)
ffffffffc0201450:	f456                	sd	s5,40(sp)
ffffffffc0201452:	f05a                	sd	s6,32(sp)
ffffffffc0201454:	ec5e                	sd	s7,24(sp)
ffffffffc0201456:	e862                	sd	s8,16(sp)
ffffffffc0201458:	e466                	sd	s9,8(sp)
ffffffffc020145a:	2f278363          	beq	a5,s2,ffffffffc0201740 <default_check+0x30a>
ffffffffc020145e:	4401                	li	s0,0
ffffffffc0201460:	4481                	li	s1,0
ffffffffc0201462:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201466:	8b09                	andi	a4,a4,2
ffffffffc0201468:	2e070063          	beqz	a4,ffffffffc0201748 <default_check+0x312>
ffffffffc020146c:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201470:	679c                	ld	a5,8(a5)
ffffffffc0201472:	2485                	addiw	s1,s1,1
ffffffffc0201474:	9c39                	addw	s0,s0,a4
ffffffffc0201476:	ff2796e3          	bne	a5,s2,ffffffffc0201462 <default_check+0x2c>
ffffffffc020147a:	89a2                	mv	s3,s0
ffffffffc020147c:	747000ef          	jal	ffffffffc02023c2 <nr_free_pages>
ffffffffc0201480:	73351463          	bne	a0,s3,ffffffffc0201ba8 <default_check+0x772>
ffffffffc0201484:	4505                	li	a0,1
ffffffffc0201486:	6cb000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc020148a:	8a2a                	mv	s4,a0
ffffffffc020148c:	44050e63          	beqz	a0,ffffffffc02018e8 <default_check+0x4b2>
ffffffffc0201490:	4505                	li	a0,1
ffffffffc0201492:	6bf000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0201496:	89aa                	mv	s3,a0
ffffffffc0201498:	72050863          	beqz	a0,ffffffffc0201bc8 <default_check+0x792>
ffffffffc020149c:	4505                	li	a0,1
ffffffffc020149e:	6b3000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02014a2:	8aaa                	mv	s5,a0
ffffffffc02014a4:	4c050263          	beqz	a0,ffffffffc0201968 <default_check+0x532>
ffffffffc02014a8:	40a987b3          	sub	a5,s3,a0
ffffffffc02014ac:	40aa0733          	sub	a4,s4,a0
ffffffffc02014b0:	0017b793          	seqz	a5,a5
ffffffffc02014b4:	00173713          	seqz	a4,a4
ffffffffc02014b8:	8fd9                	or	a5,a5,a4
ffffffffc02014ba:	30079763          	bnez	a5,ffffffffc02017c8 <default_check+0x392>
ffffffffc02014be:	313a0563          	beq	s4,s3,ffffffffc02017c8 <default_check+0x392>
ffffffffc02014c2:	000a2783          	lw	a5,0(s4)
ffffffffc02014c6:	2a079163          	bnez	a5,ffffffffc0201768 <default_check+0x332>
ffffffffc02014ca:	0009a783          	lw	a5,0(s3)
ffffffffc02014ce:	28079d63          	bnez	a5,ffffffffc0201768 <default_check+0x332>
ffffffffc02014d2:	411c                	lw	a5,0(a0)
ffffffffc02014d4:	28079a63          	bnez	a5,ffffffffc0201768 <default_check+0x332>
ffffffffc02014d8:	00096797          	auipc	a5,0x96
ffffffffc02014dc:	3e07b783          	ld	a5,992(a5) # ffffffffc02978b8 <pages>
ffffffffc02014e0:	0000f617          	auipc	a2,0xf
ffffffffc02014e4:	b4863603          	ld	a2,-1208(a2) # ffffffffc0210028 <nbase>
ffffffffc02014e8:	00096697          	auipc	a3,0x96
ffffffffc02014ec:	3c86b683          	ld	a3,968(a3) # ffffffffc02978b0 <npage>
ffffffffc02014f0:	40fa0733          	sub	a4,s4,a5
ffffffffc02014f4:	8719                	srai	a4,a4,0x6
ffffffffc02014f6:	9732                	add	a4,a4,a2
ffffffffc02014f8:	0732                	slli	a4,a4,0xc
ffffffffc02014fa:	06b2                	slli	a3,a3,0xc
ffffffffc02014fc:	2ad77663          	bgeu	a4,a3,ffffffffc02017a8 <default_check+0x372>
ffffffffc0201500:	40f98733          	sub	a4,s3,a5
ffffffffc0201504:	8719                	srai	a4,a4,0x6
ffffffffc0201506:	9732                	add	a4,a4,a2
ffffffffc0201508:	0732                	slli	a4,a4,0xc
ffffffffc020150a:	4cd77f63          	bgeu	a4,a3,ffffffffc02019e8 <default_check+0x5b2>
ffffffffc020150e:	40f507b3          	sub	a5,a0,a5
ffffffffc0201512:	8799                	srai	a5,a5,0x6
ffffffffc0201514:	97b2                	add	a5,a5,a2
ffffffffc0201516:	07b2                	slli	a5,a5,0xc
ffffffffc0201518:	32d7f863          	bgeu	a5,a3,ffffffffc0201848 <default_check+0x412>
ffffffffc020151c:	4505                	li	a0,1
ffffffffc020151e:	00093c03          	ld	s8,0(s2)
ffffffffc0201522:	00893b83          	ld	s7,8(s2)
ffffffffc0201526:	00091b17          	auipc	s6,0x91
ffffffffc020152a:	292b2b03          	lw	s6,658(s6) # ffffffffc02927b8 <free_area+0x10>
ffffffffc020152e:	01293023          	sd	s2,0(s2)
ffffffffc0201532:	01293423          	sd	s2,8(s2)
ffffffffc0201536:	00091797          	auipc	a5,0x91
ffffffffc020153a:	2807a123          	sw	zero,642(a5) # ffffffffc02927b8 <free_area+0x10>
ffffffffc020153e:	613000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0201542:	2e051363          	bnez	a0,ffffffffc0201828 <default_check+0x3f2>
ffffffffc0201546:	8552                	mv	a0,s4
ffffffffc0201548:	4585                	li	a1,1
ffffffffc020154a:	641000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc020154e:	854e                	mv	a0,s3
ffffffffc0201550:	4585                	li	a1,1
ffffffffc0201552:	639000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc0201556:	8556                	mv	a0,s5
ffffffffc0201558:	4585                	li	a1,1
ffffffffc020155a:	631000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc020155e:	00091717          	auipc	a4,0x91
ffffffffc0201562:	25a72703          	lw	a4,602(a4) # ffffffffc02927b8 <free_area+0x10>
ffffffffc0201566:	478d                	li	a5,3
ffffffffc0201568:	2af71063          	bne	a4,a5,ffffffffc0201808 <default_check+0x3d2>
ffffffffc020156c:	4505                	li	a0,1
ffffffffc020156e:	5e3000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0201572:	89aa                	mv	s3,a0
ffffffffc0201574:	26050a63          	beqz	a0,ffffffffc02017e8 <default_check+0x3b2>
ffffffffc0201578:	4505                	li	a0,1
ffffffffc020157a:	5d7000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc020157e:	8aaa                	mv	s5,a0
ffffffffc0201580:	3c050463          	beqz	a0,ffffffffc0201948 <default_check+0x512>
ffffffffc0201584:	4505                	li	a0,1
ffffffffc0201586:	5cb000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc020158a:	8a2a                	mv	s4,a0
ffffffffc020158c:	38050e63          	beqz	a0,ffffffffc0201928 <default_check+0x4f2>
ffffffffc0201590:	4505                	li	a0,1
ffffffffc0201592:	5bf000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0201596:	36051963          	bnez	a0,ffffffffc0201908 <default_check+0x4d2>
ffffffffc020159a:	4585                	li	a1,1
ffffffffc020159c:	854e                	mv	a0,s3
ffffffffc020159e:	5ed000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02015a2:	00893783          	ld	a5,8(s2)
ffffffffc02015a6:	1f278163          	beq	a5,s2,ffffffffc0201788 <default_check+0x352>
ffffffffc02015aa:	4505                	li	a0,1
ffffffffc02015ac:	5a5000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02015b0:	8caa                	mv	s9,a0
ffffffffc02015b2:	30a99b63          	bne	s3,a0,ffffffffc02018c8 <default_check+0x492>
ffffffffc02015b6:	4505                	li	a0,1
ffffffffc02015b8:	599000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02015bc:	2e051663          	bnez	a0,ffffffffc02018a8 <default_check+0x472>
ffffffffc02015c0:	00091797          	auipc	a5,0x91
ffffffffc02015c4:	1f87a783          	lw	a5,504(a5) # ffffffffc02927b8 <free_area+0x10>
ffffffffc02015c8:	2c079063          	bnez	a5,ffffffffc0201888 <default_check+0x452>
ffffffffc02015cc:	8566                	mv	a0,s9
ffffffffc02015ce:	4585                	li	a1,1
ffffffffc02015d0:	01893023          	sd	s8,0(s2)
ffffffffc02015d4:	01793423          	sd	s7,8(s2)
ffffffffc02015d8:	01692823          	sw	s6,16(s2)
ffffffffc02015dc:	5af000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02015e0:	8556                	mv	a0,s5
ffffffffc02015e2:	4585                	li	a1,1
ffffffffc02015e4:	5a7000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02015e8:	8552                	mv	a0,s4
ffffffffc02015ea:	4585                	li	a1,1
ffffffffc02015ec:	59f000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02015f0:	4515                	li	a0,5
ffffffffc02015f2:	55f000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02015f6:	89aa                	mv	s3,a0
ffffffffc02015f8:	26050863          	beqz	a0,ffffffffc0201868 <default_check+0x432>
ffffffffc02015fc:	651c                	ld	a5,8(a0)
ffffffffc02015fe:	8b89                	andi	a5,a5,2
ffffffffc0201600:	54079463          	bnez	a5,ffffffffc0201b48 <default_check+0x712>
ffffffffc0201604:	4505                	li	a0,1
ffffffffc0201606:	00093b83          	ld	s7,0(s2)
ffffffffc020160a:	00893b03          	ld	s6,8(s2)
ffffffffc020160e:	01293023          	sd	s2,0(s2)
ffffffffc0201612:	01293423          	sd	s2,8(s2)
ffffffffc0201616:	53b000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc020161a:	50051763          	bnez	a0,ffffffffc0201b28 <default_check+0x6f2>
ffffffffc020161e:	08098a13          	addi	s4,s3,128
ffffffffc0201622:	8552                	mv	a0,s4
ffffffffc0201624:	458d                	li	a1,3
ffffffffc0201626:	00091c17          	auipc	s8,0x91
ffffffffc020162a:	192c2c03          	lw	s8,402(s8) # ffffffffc02927b8 <free_area+0x10>
ffffffffc020162e:	00091797          	auipc	a5,0x91
ffffffffc0201632:	1807a523          	sw	zero,394(a5) # ffffffffc02927b8 <free_area+0x10>
ffffffffc0201636:	555000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc020163a:	4511                	li	a0,4
ffffffffc020163c:	515000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0201640:	4c051463          	bnez	a0,ffffffffc0201b08 <default_check+0x6d2>
ffffffffc0201644:	0889b783          	ld	a5,136(s3)
ffffffffc0201648:	8b89                	andi	a5,a5,2
ffffffffc020164a:	48078f63          	beqz	a5,ffffffffc0201ae8 <default_check+0x6b2>
ffffffffc020164e:	0909a503          	lw	a0,144(s3)
ffffffffc0201652:	478d                	li	a5,3
ffffffffc0201654:	48f51a63          	bne	a0,a5,ffffffffc0201ae8 <default_check+0x6b2>
ffffffffc0201658:	4f9000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc020165c:	8aaa                	mv	s5,a0
ffffffffc020165e:	46050563          	beqz	a0,ffffffffc0201ac8 <default_check+0x692>
ffffffffc0201662:	4505                	li	a0,1
ffffffffc0201664:	4ed000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0201668:	44051063          	bnez	a0,ffffffffc0201aa8 <default_check+0x672>
ffffffffc020166c:	415a1e63          	bne	s4,s5,ffffffffc0201a88 <default_check+0x652>
ffffffffc0201670:	4585                	li	a1,1
ffffffffc0201672:	854e                	mv	a0,s3
ffffffffc0201674:	517000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc0201678:	8552                	mv	a0,s4
ffffffffc020167a:	458d                	li	a1,3
ffffffffc020167c:	50f000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc0201680:	0089b783          	ld	a5,8(s3)
ffffffffc0201684:	8b89                	andi	a5,a5,2
ffffffffc0201686:	3e078163          	beqz	a5,ffffffffc0201a68 <default_check+0x632>
ffffffffc020168a:	0109aa83          	lw	s5,16(s3)
ffffffffc020168e:	4785                	li	a5,1
ffffffffc0201690:	3cfa9c63          	bne	s5,a5,ffffffffc0201a68 <default_check+0x632>
ffffffffc0201694:	008a3783          	ld	a5,8(s4)
ffffffffc0201698:	8b89                	andi	a5,a5,2
ffffffffc020169a:	3a078763          	beqz	a5,ffffffffc0201a48 <default_check+0x612>
ffffffffc020169e:	010a2703          	lw	a4,16(s4)
ffffffffc02016a2:	478d                	li	a5,3
ffffffffc02016a4:	3af71263          	bne	a4,a5,ffffffffc0201a48 <default_check+0x612>
ffffffffc02016a8:	8556                	mv	a0,s5
ffffffffc02016aa:	4a7000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02016ae:	36a99d63          	bne	s3,a0,ffffffffc0201a28 <default_check+0x5f2>
ffffffffc02016b2:	85d6                	mv	a1,s5
ffffffffc02016b4:	4d7000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02016b8:	4509                	li	a0,2
ffffffffc02016ba:	497000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02016be:	34aa1563          	bne	s4,a0,ffffffffc0201a08 <default_check+0x5d2>
ffffffffc02016c2:	4589                	li	a1,2
ffffffffc02016c4:	4c7000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02016c8:	04098513          	addi	a0,s3,64
ffffffffc02016cc:	85d6                	mv	a1,s5
ffffffffc02016ce:	4bd000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02016d2:	4515                	li	a0,5
ffffffffc02016d4:	47d000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02016d8:	89aa                	mv	s3,a0
ffffffffc02016da:	48050763          	beqz	a0,ffffffffc0201b68 <default_check+0x732>
ffffffffc02016de:	8556                	mv	a0,s5
ffffffffc02016e0:	471000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc02016e4:	2e051263          	bnez	a0,ffffffffc02019c8 <default_check+0x592>
ffffffffc02016e8:	00091797          	auipc	a5,0x91
ffffffffc02016ec:	0d07a783          	lw	a5,208(a5) # ffffffffc02927b8 <free_area+0x10>
ffffffffc02016f0:	2a079c63          	bnez	a5,ffffffffc02019a8 <default_check+0x572>
ffffffffc02016f4:	854e                	mv	a0,s3
ffffffffc02016f6:	4595                	li	a1,5
ffffffffc02016f8:	01892823          	sw	s8,16(s2)
ffffffffc02016fc:	01793023          	sd	s7,0(s2)
ffffffffc0201700:	01693423          	sd	s6,8(s2)
ffffffffc0201704:	487000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc0201708:	00893783          	ld	a5,8(s2)
ffffffffc020170c:	01278963          	beq	a5,s2,ffffffffc020171e <default_check+0x2e8>
ffffffffc0201710:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201714:	679c                	ld	a5,8(a5)
ffffffffc0201716:	34fd                	addiw	s1,s1,-1
ffffffffc0201718:	9c19                	subw	s0,s0,a4
ffffffffc020171a:	ff279be3          	bne	a5,s2,ffffffffc0201710 <default_check+0x2da>
ffffffffc020171e:	26049563          	bnez	s1,ffffffffc0201988 <default_check+0x552>
ffffffffc0201722:	46041363          	bnez	s0,ffffffffc0201b88 <default_check+0x752>
ffffffffc0201726:	60e6                	ld	ra,88(sp)
ffffffffc0201728:	6446                	ld	s0,80(sp)
ffffffffc020172a:	64a6                	ld	s1,72(sp)
ffffffffc020172c:	6906                	ld	s2,64(sp)
ffffffffc020172e:	79e2                	ld	s3,56(sp)
ffffffffc0201730:	7a42                	ld	s4,48(sp)
ffffffffc0201732:	7aa2                	ld	s5,40(sp)
ffffffffc0201734:	7b02                	ld	s6,32(sp)
ffffffffc0201736:	6be2                	ld	s7,24(sp)
ffffffffc0201738:	6c42                	ld	s8,16(sp)
ffffffffc020173a:	6ca2                	ld	s9,8(sp)
ffffffffc020173c:	6125                	addi	sp,sp,96
ffffffffc020173e:	8082                	ret
ffffffffc0201740:	4981                	li	s3,0
ffffffffc0201742:	4401                	li	s0,0
ffffffffc0201744:	4481                	li	s1,0
ffffffffc0201746:	bb1d                	j	ffffffffc020147c <default_check+0x46>
ffffffffc0201748:	0000b697          	auipc	a3,0xb
ffffffffc020174c:	12068693          	addi	a3,a3,288 # ffffffffc020c868 <etext+0xb30>
ffffffffc0201750:	0000b617          	auipc	a2,0xb
ffffffffc0201754:	a2060613          	addi	a2,a2,-1504 # ffffffffc020c170 <etext+0x438>
ffffffffc0201758:	0ef00593          	li	a1,239
ffffffffc020175c:	0000b517          	auipc	a0,0xb
ffffffffc0201760:	11c50513          	addi	a0,a0,284 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201764:	ce7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201768:	0000b697          	auipc	a3,0xb
ffffffffc020176c:	1d068693          	addi	a3,a3,464 # ffffffffc020c938 <etext+0xc00>
ffffffffc0201770:	0000b617          	auipc	a2,0xb
ffffffffc0201774:	a0060613          	addi	a2,a2,-1536 # ffffffffc020c170 <etext+0x438>
ffffffffc0201778:	0bd00593          	li	a1,189
ffffffffc020177c:	0000b517          	auipc	a0,0xb
ffffffffc0201780:	0fc50513          	addi	a0,a0,252 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201784:	cc7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201788:	0000b697          	auipc	a3,0xb
ffffffffc020178c:	27868693          	addi	a3,a3,632 # ffffffffc020ca00 <etext+0xcc8>
ffffffffc0201790:	0000b617          	auipc	a2,0xb
ffffffffc0201794:	9e060613          	addi	a2,a2,-1568 # ffffffffc020c170 <etext+0x438>
ffffffffc0201798:	0d800593          	li	a1,216
ffffffffc020179c:	0000b517          	auipc	a0,0xb
ffffffffc02017a0:	0dc50513          	addi	a0,a0,220 # ffffffffc020c878 <etext+0xb40>
ffffffffc02017a4:	ca7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017a8:	0000b697          	auipc	a3,0xb
ffffffffc02017ac:	1d068693          	addi	a3,a3,464 # ffffffffc020c978 <etext+0xc40>
ffffffffc02017b0:	0000b617          	auipc	a2,0xb
ffffffffc02017b4:	9c060613          	addi	a2,a2,-1600 # ffffffffc020c170 <etext+0x438>
ffffffffc02017b8:	0bf00593          	li	a1,191
ffffffffc02017bc:	0000b517          	auipc	a0,0xb
ffffffffc02017c0:	0bc50513          	addi	a0,a0,188 # ffffffffc020c878 <etext+0xb40>
ffffffffc02017c4:	c87fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017c8:	0000b697          	auipc	a3,0xb
ffffffffc02017cc:	14868693          	addi	a3,a3,328 # ffffffffc020c910 <etext+0xbd8>
ffffffffc02017d0:	0000b617          	auipc	a2,0xb
ffffffffc02017d4:	9a060613          	addi	a2,a2,-1632 # ffffffffc020c170 <etext+0x438>
ffffffffc02017d8:	0bc00593          	li	a1,188
ffffffffc02017dc:	0000b517          	auipc	a0,0xb
ffffffffc02017e0:	09c50513          	addi	a0,a0,156 # ffffffffc020c878 <etext+0xb40>
ffffffffc02017e4:	c67fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02017e8:	0000b697          	auipc	a3,0xb
ffffffffc02017ec:	0c868693          	addi	a3,a3,200 # ffffffffc020c8b0 <etext+0xb78>
ffffffffc02017f0:	0000b617          	auipc	a2,0xb
ffffffffc02017f4:	98060613          	addi	a2,a2,-1664 # ffffffffc020c170 <etext+0x438>
ffffffffc02017f8:	0d100593          	li	a1,209
ffffffffc02017fc:	0000b517          	auipc	a0,0xb
ffffffffc0201800:	07c50513          	addi	a0,a0,124 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201804:	c47fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201808:	0000b697          	auipc	a3,0xb
ffffffffc020180c:	1e868693          	addi	a3,a3,488 # ffffffffc020c9f0 <etext+0xcb8>
ffffffffc0201810:	0000b617          	auipc	a2,0xb
ffffffffc0201814:	96060613          	addi	a2,a2,-1696 # ffffffffc020c170 <etext+0x438>
ffffffffc0201818:	0cf00593          	li	a1,207
ffffffffc020181c:	0000b517          	auipc	a0,0xb
ffffffffc0201820:	05c50513          	addi	a0,a0,92 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201824:	c27fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201828:	0000b697          	auipc	a3,0xb
ffffffffc020182c:	1b068693          	addi	a3,a3,432 # ffffffffc020c9d8 <etext+0xca0>
ffffffffc0201830:	0000b617          	auipc	a2,0xb
ffffffffc0201834:	94060613          	addi	a2,a2,-1728 # ffffffffc020c170 <etext+0x438>
ffffffffc0201838:	0ca00593          	li	a1,202
ffffffffc020183c:	0000b517          	auipc	a0,0xb
ffffffffc0201840:	03c50513          	addi	a0,a0,60 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201844:	c07fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201848:	0000b697          	auipc	a3,0xb
ffffffffc020184c:	17068693          	addi	a3,a3,368 # ffffffffc020c9b8 <etext+0xc80>
ffffffffc0201850:	0000b617          	auipc	a2,0xb
ffffffffc0201854:	92060613          	addi	a2,a2,-1760 # ffffffffc020c170 <etext+0x438>
ffffffffc0201858:	0c100593          	li	a1,193
ffffffffc020185c:	0000b517          	auipc	a0,0xb
ffffffffc0201860:	01c50513          	addi	a0,a0,28 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201864:	be7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201868:	0000b697          	auipc	a3,0xb
ffffffffc020186c:	1e068693          	addi	a3,a3,480 # ffffffffc020ca48 <etext+0xd10>
ffffffffc0201870:	0000b617          	auipc	a2,0xb
ffffffffc0201874:	90060613          	addi	a2,a2,-1792 # ffffffffc020c170 <etext+0x438>
ffffffffc0201878:	0f700593          	li	a1,247
ffffffffc020187c:	0000b517          	auipc	a0,0xb
ffffffffc0201880:	ffc50513          	addi	a0,a0,-4 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201884:	bc7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201888:	0000b697          	auipc	a3,0xb
ffffffffc020188c:	1b068693          	addi	a3,a3,432 # ffffffffc020ca38 <etext+0xd00>
ffffffffc0201890:	0000b617          	auipc	a2,0xb
ffffffffc0201894:	8e060613          	addi	a2,a2,-1824 # ffffffffc020c170 <etext+0x438>
ffffffffc0201898:	0de00593          	li	a1,222
ffffffffc020189c:	0000b517          	auipc	a0,0xb
ffffffffc02018a0:	fdc50513          	addi	a0,a0,-36 # ffffffffc020c878 <etext+0xb40>
ffffffffc02018a4:	ba7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018a8:	0000b697          	auipc	a3,0xb
ffffffffc02018ac:	13068693          	addi	a3,a3,304 # ffffffffc020c9d8 <etext+0xca0>
ffffffffc02018b0:	0000b617          	auipc	a2,0xb
ffffffffc02018b4:	8c060613          	addi	a2,a2,-1856 # ffffffffc020c170 <etext+0x438>
ffffffffc02018b8:	0dc00593          	li	a1,220
ffffffffc02018bc:	0000b517          	auipc	a0,0xb
ffffffffc02018c0:	fbc50513          	addi	a0,a0,-68 # ffffffffc020c878 <etext+0xb40>
ffffffffc02018c4:	b87fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018c8:	0000b697          	auipc	a3,0xb
ffffffffc02018cc:	15068693          	addi	a3,a3,336 # ffffffffc020ca18 <etext+0xce0>
ffffffffc02018d0:	0000b617          	auipc	a2,0xb
ffffffffc02018d4:	8a060613          	addi	a2,a2,-1888 # ffffffffc020c170 <etext+0x438>
ffffffffc02018d8:	0db00593          	li	a1,219
ffffffffc02018dc:	0000b517          	auipc	a0,0xb
ffffffffc02018e0:	f9c50513          	addi	a0,a0,-100 # ffffffffc020c878 <etext+0xb40>
ffffffffc02018e4:	b67fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02018e8:	0000b697          	auipc	a3,0xb
ffffffffc02018ec:	fc868693          	addi	a3,a3,-56 # ffffffffc020c8b0 <etext+0xb78>
ffffffffc02018f0:	0000b617          	auipc	a2,0xb
ffffffffc02018f4:	88060613          	addi	a2,a2,-1920 # ffffffffc020c170 <etext+0x438>
ffffffffc02018f8:	0b800593          	li	a1,184
ffffffffc02018fc:	0000b517          	auipc	a0,0xb
ffffffffc0201900:	f7c50513          	addi	a0,a0,-132 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201904:	b47fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201908:	0000b697          	auipc	a3,0xb
ffffffffc020190c:	0d068693          	addi	a3,a3,208 # ffffffffc020c9d8 <etext+0xca0>
ffffffffc0201910:	0000b617          	auipc	a2,0xb
ffffffffc0201914:	86060613          	addi	a2,a2,-1952 # ffffffffc020c170 <etext+0x438>
ffffffffc0201918:	0d500593          	li	a1,213
ffffffffc020191c:	0000b517          	auipc	a0,0xb
ffffffffc0201920:	f5c50513          	addi	a0,a0,-164 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201924:	b27fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201928:	0000b697          	auipc	a3,0xb
ffffffffc020192c:	fc868693          	addi	a3,a3,-56 # ffffffffc020c8f0 <etext+0xbb8>
ffffffffc0201930:	0000b617          	auipc	a2,0xb
ffffffffc0201934:	84060613          	addi	a2,a2,-1984 # ffffffffc020c170 <etext+0x438>
ffffffffc0201938:	0d300593          	li	a1,211
ffffffffc020193c:	0000b517          	auipc	a0,0xb
ffffffffc0201940:	f3c50513          	addi	a0,a0,-196 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201944:	b07fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201948:	0000b697          	auipc	a3,0xb
ffffffffc020194c:	f8868693          	addi	a3,a3,-120 # ffffffffc020c8d0 <etext+0xb98>
ffffffffc0201950:	0000b617          	auipc	a2,0xb
ffffffffc0201954:	82060613          	addi	a2,a2,-2016 # ffffffffc020c170 <etext+0x438>
ffffffffc0201958:	0d200593          	li	a1,210
ffffffffc020195c:	0000b517          	auipc	a0,0xb
ffffffffc0201960:	f1c50513          	addi	a0,a0,-228 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201964:	ae7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201968:	0000b697          	auipc	a3,0xb
ffffffffc020196c:	f8868693          	addi	a3,a3,-120 # ffffffffc020c8f0 <etext+0xbb8>
ffffffffc0201970:	0000b617          	auipc	a2,0xb
ffffffffc0201974:	80060613          	addi	a2,a2,-2048 # ffffffffc020c170 <etext+0x438>
ffffffffc0201978:	0ba00593          	li	a1,186
ffffffffc020197c:	0000b517          	auipc	a0,0xb
ffffffffc0201980:	efc50513          	addi	a0,a0,-260 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201984:	ac7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201988:	0000b697          	auipc	a3,0xb
ffffffffc020198c:	21068693          	addi	a3,a3,528 # ffffffffc020cb98 <etext+0xe60>
ffffffffc0201990:	0000a617          	auipc	a2,0xa
ffffffffc0201994:	7e060613          	addi	a2,a2,2016 # ffffffffc020c170 <etext+0x438>
ffffffffc0201998:	12400593          	li	a1,292
ffffffffc020199c:	0000b517          	auipc	a0,0xb
ffffffffc02019a0:	edc50513          	addi	a0,a0,-292 # ffffffffc020c878 <etext+0xb40>
ffffffffc02019a4:	aa7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019a8:	0000b697          	auipc	a3,0xb
ffffffffc02019ac:	09068693          	addi	a3,a3,144 # ffffffffc020ca38 <etext+0xd00>
ffffffffc02019b0:	0000a617          	auipc	a2,0xa
ffffffffc02019b4:	7c060613          	addi	a2,a2,1984 # ffffffffc020c170 <etext+0x438>
ffffffffc02019b8:	11900593          	li	a1,281
ffffffffc02019bc:	0000b517          	auipc	a0,0xb
ffffffffc02019c0:	ebc50513          	addi	a0,a0,-324 # ffffffffc020c878 <etext+0xb40>
ffffffffc02019c4:	a87fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019c8:	0000b697          	auipc	a3,0xb
ffffffffc02019cc:	01068693          	addi	a3,a3,16 # ffffffffc020c9d8 <etext+0xca0>
ffffffffc02019d0:	0000a617          	auipc	a2,0xa
ffffffffc02019d4:	7a060613          	addi	a2,a2,1952 # ffffffffc020c170 <etext+0x438>
ffffffffc02019d8:	11700593          	li	a1,279
ffffffffc02019dc:	0000b517          	auipc	a0,0xb
ffffffffc02019e0:	e9c50513          	addi	a0,a0,-356 # ffffffffc020c878 <etext+0xb40>
ffffffffc02019e4:	a67fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02019e8:	0000b697          	auipc	a3,0xb
ffffffffc02019ec:	fb068693          	addi	a3,a3,-80 # ffffffffc020c998 <etext+0xc60>
ffffffffc02019f0:	0000a617          	auipc	a2,0xa
ffffffffc02019f4:	78060613          	addi	a2,a2,1920 # ffffffffc020c170 <etext+0x438>
ffffffffc02019f8:	0c000593          	li	a1,192
ffffffffc02019fc:	0000b517          	auipc	a0,0xb
ffffffffc0201a00:	e7c50513          	addi	a0,a0,-388 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201a04:	a47fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a08:	0000b697          	auipc	a3,0xb
ffffffffc0201a0c:	15068693          	addi	a3,a3,336 # ffffffffc020cb58 <etext+0xe20>
ffffffffc0201a10:	0000a617          	auipc	a2,0xa
ffffffffc0201a14:	76060613          	addi	a2,a2,1888 # ffffffffc020c170 <etext+0x438>
ffffffffc0201a18:	11100593          	li	a1,273
ffffffffc0201a1c:	0000b517          	auipc	a0,0xb
ffffffffc0201a20:	e5c50513          	addi	a0,a0,-420 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201a24:	a27fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a28:	0000b697          	auipc	a3,0xb
ffffffffc0201a2c:	11068693          	addi	a3,a3,272 # ffffffffc020cb38 <etext+0xe00>
ffffffffc0201a30:	0000a617          	auipc	a2,0xa
ffffffffc0201a34:	74060613          	addi	a2,a2,1856 # ffffffffc020c170 <etext+0x438>
ffffffffc0201a38:	10f00593          	li	a1,271
ffffffffc0201a3c:	0000b517          	auipc	a0,0xb
ffffffffc0201a40:	e3c50513          	addi	a0,a0,-452 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201a44:	a07fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a48:	0000b697          	auipc	a3,0xb
ffffffffc0201a4c:	0c868693          	addi	a3,a3,200 # ffffffffc020cb10 <etext+0xdd8>
ffffffffc0201a50:	0000a617          	auipc	a2,0xa
ffffffffc0201a54:	72060613          	addi	a2,a2,1824 # ffffffffc020c170 <etext+0x438>
ffffffffc0201a58:	10d00593          	li	a1,269
ffffffffc0201a5c:	0000b517          	auipc	a0,0xb
ffffffffc0201a60:	e1c50513          	addi	a0,a0,-484 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201a64:	9e7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a68:	0000b697          	auipc	a3,0xb
ffffffffc0201a6c:	08068693          	addi	a3,a3,128 # ffffffffc020cae8 <etext+0xdb0>
ffffffffc0201a70:	0000a617          	auipc	a2,0xa
ffffffffc0201a74:	70060613          	addi	a2,a2,1792 # ffffffffc020c170 <etext+0x438>
ffffffffc0201a78:	10c00593          	li	a1,268
ffffffffc0201a7c:	0000b517          	auipc	a0,0xb
ffffffffc0201a80:	dfc50513          	addi	a0,a0,-516 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201a84:	9c7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201a88:	0000b697          	auipc	a3,0xb
ffffffffc0201a8c:	05068693          	addi	a3,a3,80 # ffffffffc020cad8 <etext+0xda0>
ffffffffc0201a90:	0000a617          	auipc	a2,0xa
ffffffffc0201a94:	6e060613          	addi	a2,a2,1760 # ffffffffc020c170 <etext+0x438>
ffffffffc0201a98:	10700593          	li	a1,263
ffffffffc0201a9c:	0000b517          	auipc	a0,0xb
ffffffffc0201aa0:	ddc50513          	addi	a0,a0,-548 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201aa4:	9a7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201aa8:	0000b697          	auipc	a3,0xb
ffffffffc0201aac:	f3068693          	addi	a3,a3,-208 # ffffffffc020c9d8 <etext+0xca0>
ffffffffc0201ab0:	0000a617          	auipc	a2,0xa
ffffffffc0201ab4:	6c060613          	addi	a2,a2,1728 # ffffffffc020c170 <etext+0x438>
ffffffffc0201ab8:	10600593          	li	a1,262
ffffffffc0201abc:	0000b517          	auipc	a0,0xb
ffffffffc0201ac0:	dbc50513          	addi	a0,a0,-580 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201ac4:	987fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201ac8:	0000b697          	auipc	a3,0xb
ffffffffc0201acc:	ff068693          	addi	a3,a3,-16 # ffffffffc020cab8 <etext+0xd80>
ffffffffc0201ad0:	0000a617          	auipc	a2,0xa
ffffffffc0201ad4:	6a060613          	addi	a2,a2,1696 # ffffffffc020c170 <etext+0x438>
ffffffffc0201ad8:	10500593          	li	a1,261
ffffffffc0201adc:	0000b517          	auipc	a0,0xb
ffffffffc0201ae0:	d9c50513          	addi	a0,a0,-612 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201ae4:	967fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201ae8:	0000b697          	auipc	a3,0xb
ffffffffc0201aec:	fa068693          	addi	a3,a3,-96 # ffffffffc020ca88 <etext+0xd50>
ffffffffc0201af0:	0000a617          	auipc	a2,0xa
ffffffffc0201af4:	68060613          	addi	a2,a2,1664 # ffffffffc020c170 <etext+0x438>
ffffffffc0201af8:	10400593          	li	a1,260
ffffffffc0201afc:	0000b517          	auipc	a0,0xb
ffffffffc0201b00:	d7c50513          	addi	a0,a0,-644 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201b04:	947fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b08:	0000b697          	auipc	a3,0xb
ffffffffc0201b0c:	f6868693          	addi	a3,a3,-152 # ffffffffc020ca70 <etext+0xd38>
ffffffffc0201b10:	0000a617          	auipc	a2,0xa
ffffffffc0201b14:	66060613          	addi	a2,a2,1632 # ffffffffc020c170 <etext+0x438>
ffffffffc0201b18:	10300593          	li	a1,259
ffffffffc0201b1c:	0000b517          	auipc	a0,0xb
ffffffffc0201b20:	d5c50513          	addi	a0,a0,-676 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201b24:	927fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b28:	0000b697          	auipc	a3,0xb
ffffffffc0201b2c:	eb068693          	addi	a3,a3,-336 # ffffffffc020c9d8 <etext+0xca0>
ffffffffc0201b30:	0000a617          	auipc	a2,0xa
ffffffffc0201b34:	64060613          	addi	a2,a2,1600 # ffffffffc020c170 <etext+0x438>
ffffffffc0201b38:	0fd00593          	li	a1,253
ffffffffc0201b3c:	0000b517          	auipc	a0,0xb
ffffffffc0201b40:	d3c50513          	addi	a0,a0,-708 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201b44:	907fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b48:	0000b697          	auipc	a3,0xb
ffffffffc0201b4c:	f1068693          	addi	a3,a3,-240 # ffffffffc020ca58 <etext+0xd20>
ffffffffc0201b50:	0000a617          	auipc	a2,0xa
ffffffffc0201b54:	62060613          	addi	a2,a2,1568 # ffffffffc020c170 <etext+0x438>
ffffffffc0201b58:	0f800593          	li	a1,248
ffffffffc0201b5c:	0000b517          	auipc	a0,0xb
ffffffffc0201b60:	d1c50513          	addi	a0,a0,-740 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201b64:	8e7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b68:	0000b697          	auipc	a3,0xb
ffffffffc0201b6c:	01068693          	addi	a3,a3,16 # ffffffffc020cb78 <etext+0xe40>
ffffffffc0201b70:	0000a617          	auipc	a2,0xa
ffffffffc0201b74:	60060613          	addi	a2,a2,1536 # ffffffffc020c170 <etext+0x438>
ffffffffc0201b78:	11600593          	li	a1,278
ffffffffc0201b7c:	0000b517          	auipc	a0,0xb
ffffffffc0201b80:	cfc50513          	addi	a0,a0,-772 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201b84:	8c7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201b88:	0000b697          	auipc	a3,0xb
ffffffffc0201b8c:	02068693          	addi	a3,a3,32 # ffffffffc020cba8 <etext+0xe70>
ffffffffc0201b90:	0000a617          	auipc	a2,0xa
ffffffffc0201b94:	5e060613          	addi	a2,a2,1504 # ffffffffc020c170 <etext+0x438>
ffffffffc0201b98:	12500593          	li	a1,293
ffffffffc0201b9c:	0000b517          	auipc	a0,0xb
ffffffffc0201ba0:	cdc50513          	addi	a0,a0,-804 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201ba4:	8a7fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201ba8:	0000b697          	auipc	a3,0xb
ffffffffc0201bac:	ce868693          	addi	a3,a3,-792 # ffffffffc020c890 <etext+0xb58>
ffffffffc0201bb0:	0000a617          	auipc	a2,0xa
ffffffffc0201bb4:	5c060613          	addi	a2,a2,1472 # ffffffffc020c170 <etext+0x438>
ffffffffc0201bb8:	0f200593          	li	a1,242
ffffffffc0201bbc:	0000b517          	auipc	a0,0xb
ffffffffc0201bc0:	cbc50513          	addi	a0,a0,-836 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201bc4:	887fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201bc8:	0000b697          	auipc	a3,0xb
ffffffffc0201bcc:	d0868693          	addi	a3,a3,-760 # ffffffffc020c8d0 <etext+0xb98>
ffffffffc0201bd0:	0000a617          	auipc	a2,0xa
ffffffffc0201bd4:	5a060613          	addi	a2,a2,1440 # ffffffffc020c170 <etext+0x438>
ffffffffc0201bd8:	0b900593          	li	a1,185
ffffffffc0201bdc:	0000b517          	auipc	a0,0xb
ffffffffc0201be0:	c9c50513          	addi	a0,a0,-868 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201be4:	867fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201be8 <default_free_pages>:
ffffffffc0201be8:	1141                	addi	sp,sp,-16
ffffffffc0201bea:	e406                	sd	ra,8(sp)
ffffffffc0201bec:	14058663          	beqz	a1,ffffffffc0201d38 <default_free_pages+0x150>
ffffffffc0201bf0:	00659713          	slli	a4,a1,0x6
ffffffffc0201bf4:	00e506b3          	add	a3,a0,a4
ffffffffc0201bf8:	87aa                	mv	a5,a0
ffffffffc0201bfa:	c30d                	beqz	a4,ffffffffc0201c1c <default_free_pages+0x34>
ffffffffc0201bfc:	6798                	ld	a4,8(a5)
ffffffffc0201bfe:	8b05                	andi	a4,a4,1
ffffffffc0201c00:	10071c63          	bnez	a4,ffffffffc0201d18 <default_free_pages+0x130>
ffffffffc0201c04:	6798                	ld	a4,8(a5)
ffffffffc0201c06:	8b09                	andi	a4,a4,2
ffffffffc0201c08:	10071863          	bnez	a4,ffffffffc0201d18 <default_free_pages+0x130>
ffffffffc0201c0c:	0007b423          	sd	zero,8(a5)
ffffffffc0201c10:	0007a023          	sw	zero,0(a5)
ffffffffc0201c14:	04078793          	addi	a5,a5,64
ffffffffc0201c18:	fed792e3          	bne	a5,a3,ffffffffc0201bfc <default_free_pages+0x14>
ffffffffc0201c1c:	c90c                	sw	a1,16(a0)
ffffffffc0201c1e:	00850893          	addi	a7,a0,8
ffffffffc0201c22:	4789                	li	a5,2
ffffffffc0201c24:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0201c28:	00091717          	auipc	a4,0x91
ffffffffc0201c2c:	b9072703          	lw	a4,-1136(a4) # ffffffffc02927b8 <free_area+0x10>
ffffffffc0201c30:	00091697          	auipc	a3,0x91
ffffffffc0201c34:	b7868693          	addi	a3,a3,-1160 # ffffffffc02927a8 <free_area>
ffffffffc0201c38:	669c                	ld	a5,8(a3)
ffffffffc0201c3a:	9f2d                	addw	a4,a4,a1
ffffffffc0201c3c:	ca98                	sw	a4,16(a3)
ffffffffc0201c3e:	0ad78163          	beq	a5,a3,ffffffffc0201ce0 <default_free_pages+0xf8>
ffffffffc0201c42:	fe878713          	addi	a4,a5,-24
ffffffffc0201c46:	4581                	li	a1,0
ffffffffc0201c48:	01850613          	addi	a2,a0,24
ffffffffc0201c4c:	00e56a63          	bltu	a0,a4,ffffffffc0201c60 <default_free_pages+0x78>
ffffffffc0201c50:	6798                	ld	a4,8(a5)
ffffffffc0201c52:	04d70c63          	beq	a4,a3,ffffffffc0201caa <default_free_pages+0xc2>
ffffffffc0201c56:	87ba                	mv	a5,a4
ffffffffc0201c58:	fe878713          	addi	a4,a5,-24
ffffffffc0201c5c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201c50 <default_free_pages+0x68>
ffffffffc0201c60:	c199                	beqz	a1,ffffffffc0201c66 <default_free_pages+0x7e>
ffffffffc0201c62:	0106b023          	sd	a6,0(a3)
ffffffffc0201c66:	6398                	ld	a4,0(a5)
ffffffffc0201c68:	e390                	sd	a2,0(a5)
ffffffffc0201c6a:	e710                	sd	a2,8(a4)
ffffffffc0201c6c:	ed18                	sd	a4,24(a0)
ffffffffc0201c6e:	f11c                	sd	a5,32(a0)
ffffffffc0201c70:	00d70d63          	beq	a4,a3,ffffffffc0201c8a <default_free_pages+0xa2>
ffffffffc0201c74:	ff872583          	lw	a1,-8(a4)
ffffffffc0201c78:	fe870613          	addi	a2,a4,-24
ffffffffc0201c7c:	02059813          	slli	a6,a1,0x20
ffffffffc0201c80:	01a85793          	srli	a5,a6,0x1a
ffffffffc0201c84:	97b2                	add	a5,a5,a2
ffffffffc0201c86:	02f50c63          	beq	a0,a5,ffffffffc0201cbe <default_free_pages+0xd6>
ffffffffc0201c8a:	711c                	ld	a5,32(a0)
ffffffffc0201c8c:	00d78c63          	beq	a5,a3,ffffffffc0201ca4 <default_free_pages+0xbc>
ffffffffc0201c90:	4910                	lw	a2,16(a0)
ffffffffc0201c92:	fe878693          	addi	a3,a5,-24
ffffffffc0201c96:	02061593          	slli	a1,a2,0x20
ffffffffc0201c9a:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0201c9e:	972a                	add	a4,a4,a0
ffffffffc0201ca0:	04e68c63          	beq	a3,a4,ffffffffc0201cf8 <default_free_pages+0x110>
ffffffffc0201ca4:	60a2                	ld	ra,8(sp)
ffffffffc0201ca6:	0141                	addi	sp,sp,16
ffffffffc0201ca8:	8082                	ret
ffffffffc0201caa:	e790                	sd	a2,8(a5)
ffffffffc0201cac:	f114                	sd	a3,32(a0)
ffffffffc0201cae:	6798                	ld	a4,8(a5)
ffffffffc0201cb0:	ed1c                	sd	a5,24(a0)
ffffffffc0201cb2:	8832                	mv	a6,a2
ffffffffc0201cb4:	02d70f63          	beq	a4,a3,ffffffffc0201cf2 <default_free_pages+0x10a>
ffffffffc0201cb8:	4585                	li	a1,1
ffffffffc0201cba:	87ba                	mv	a5,a4
ffffffffc0201cbc:	bf71                	j	ffffffffc0201c58 <default_free_pages+0x70>
ffffffffc0201cbe:	491c                	lw	a5,16(a0)
ffffffffc0201cc0:	5875                	li	a6,-3
ffffffffc0201cc2:	9fad                	addw	a5,a5,a1
ffffffffc0201cc4:	fef72c23          	sw	a5,-8(a4)
ffffffffc0201cc8:	6108b02f          	amoand.d	zero,a6,(a7)
ffffffffc0201ccc:	01853803          	ld	a6,24(a0)
ffffffffc0201cd0:	710c                	ld	a1,32(a0)
ffffffffc0201cd2:	8532                	mv	a0,a2
ffffffffc0201cd4:	00b83423          	sd	a1,8(a6)
ffffffffc0201cd8:	671c                	ld	a5,8(a4)
ffffffffc0201cda:	0105b023          	sd	a6,0(a1)
ffffffffc0201cde:	b77d                	j	ffffffffc0201c8c <default_free_pages+0xa4>
ffffffffc0201ce0:	60a2                	ld	ra,8(sp)
ffffffffc0201ce2:	01850713          	addi	a4,a0,24
ffffffffc0201ce6:	f11c                	sd	a5,32(a0)
ffffffffc0201ce8:	ed1c                	sd	a5,24(a0)
ffffffffc0201cea:	e398                	sd	a4,0(a5)
ffffffffc0201cec:	e798                	sd	a4,8(a5)
ffffffffc0201cee:	0141                	addi	sp,sp,16
ffffffffc0201cf0:	8082                	ret
ffffffffc0201cf2:	e290                	sd	a2,0(a3)
ffffffffc0201cf4:	873e                	mv	a4,a5
ffffffffc0201cf6:	bfad                	j	ffffffffc0201c70 <default_free_pages+0x88>
ffffffffc0201cf8:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201cfc:	56f5                	li	a3,-3
ffffffffc0201cfe:	9f31                	addw	a4,a4,a2
ffffffffc0201d00:	c918                	sw	a4,16(a0)
ffffffffc0201d02:	ff078713          	addi	a4,a5,-16
ffffffffc0201d06:	60d7302f          	amoand.d	zero,a3,(a4)
ffffffffc0201d0a:	6398                	ld	a4,0(a5)
ffffffffc0201d0c:	679c                	ld	a5,8(a5)
ffffffffc0201d0e:	60a2                	ld	ra,8(sp)
ffffffffc0201d10:	e71c                	sd	a5,8(a4)
ffffffffc0201d12:	e398                	sd	a4,0(a5)
ffffffffc0201d14:	0141                	addi	sp,sp,16
ffffffffc0201d16:	8082                	ret
ffffffffc0201d18:	0000b697          	auipc	a3,0xb
ffffffffc0201d1c:	ea868693          	addi	a3,a3,-344 # ffffffffc020cbc0 <etext+0xe88>
ffffffffc0201d20:	0000a617          	auipc	a2,0xa
ffffffffc0201d24:	45060613          	addi	a2,a2,1104 # ffffffffc020c170 <etext+0x438>
ffffffffc0201d28:	08200593          	li	a1,130
ffffffffc0201d2c:	0000b517          	auipc	a0,0xb
ffffffffc0201d30:	b4c50513          	addi	a0,a0,-1204 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201d34:	f16fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201d38:	0000b697          	auipc	a3,0xb
ffffffffc0201d3c:	e8068693          	addi	a3,a3,-384 # ffffffffc020cbb8 <etext+0xe80>
ffffffffc0201d40:	0000a617          	auipc	a2,0xa
ffffffffc0201d44:	43060613          	addi	a2,a2,1072 # ffffffffc020c170 <etext+0x438>
ffffffffc0201d48:	07f00593          	li	a1,127
ffffffffc0201d4c:	0000b517          	auipc	a0,0xb
ffffffffc0201d50:	b2c50513          	addi	a0,a0,-1236 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201d54:	ef6fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201d58 <default_alloc_pages>:
ffffffffc0201d58:	c951                	beqz	a0,ffffffffc0201dec <default_alloc_pages+0x94>
ffffffffc0201d5a:	00091597          	auipc	a1,0x91
ffffffffc0201d5e:	a5e5a583          	lw	a1,-1442(a1) # ffffffffc02927b8 <free_area+0x10>
ffffffffc0201d62:	86aa                	mv	a3,a0
ffffffffc0201d64:	02059793          	slli	a5,a1,0x20
ffffffffc0201d68:	9381                	srli	a5,a5,0x20
ffffffffc0201d6a:	00a7ef63          	bltu	a5,a0,ffffffffc0201d88 <default_alloc_pages+0x30>
ffffffffc0201d6e:	00091617          	auipc	a2,0x91
ffffffffc0201d72:	a3a60613          	addi	a2,a2,-1478 # ffffffffc02927a8 <free_area>
ffffffffc0201d76:	87b2                	mv	a5,a2
ffffffffc0201d78:	a029                	j	ffffffffc0201d82 <default_alloc_pages+0x2a>
ffffffffc0201d7a:	ff87e703          	lwu	a4,-8(a5)
ffffffffc0201d7e:	00d77763          	bgeu	a4,a3,ffffffffc0201d8c <default_alloc_pages+0x34>
ffffffffc0201d82:	679c                	ld	a5,8(a5)
ffffffffc0201d84:	fec79be3          	bne	a5,a2,ffffffffc0201d7a <default_alloc_pages+0x22>
ffffffffc0201d88:	4501                	li	a0,0
ffffffffc0201d8a:	8082                	ret
ffffffffc0201d8c:	ff87a883          	lw	a7,-8(a5)
ffffffffc0201d90:	0007b803          	ld	a6,0(a5)
ffffffffc0201d94:	6798                	ld	a4,8(a5)
ffffffffc0201d96:	02089313          	slli	t1,a7,0x20
ffffffffc0201d9a:	02035313          	srli	t1,t1,0x20
ffffffffc0201d9e:	00e83423          	sd	a4,8(a6)
ffffffffc0201da2:	01073023          	sd	a6,0(a4)
ffffffffc0201da6:	fe878513          	addi	a0,a5,-24
ffffffffc0201daa:	0266fa63          	bgeu	a3,t1,ffffffffc0201dde <default_alloc_pages+0x86>
ffffffffc0201dae:	00669713          	slli	a4,a3,0x6
ffffffffc0201db2:	40d888bb          	subw	a7,a7,a3
ffffffffc0201db6:	972a                	add	a4,a4,a0
ffffffffc0201db8:	01172823          	sw	a7,16(a4)
ffffffffc0201dbc:	00870313          	addi	t1,a4,8
ffffffffc0201dc0:	4889                	li	a7,2
ffffffffc0201dc2:	4113302f          	amoor.d	zero,a7,(t1)
ffffffffc0201dc6:	00883883          	ld	a7,8(a6)
ffffffffc0201dca:	01870313          	addi	t1,a4,24
ffffffffc0201dce:	0068b023          	sd	t1,0(a7) # 10000000 <_binary_bin_sfs_img_size+0xff8ad00>
ffffffffc0201dd2:	00683423          	sd	t1,8(a6)
ffffffffc0201dd6:	03173023          	sd	a7,32(a4)
ffffffffc0201dda:	01073c23          	sd	a6,24(a4)
ffffffffc0201dde:	9d95                	subw	a1,a1,a3
ffffffffc0201de0:	ca0c                	sw	a1,16(a2)
ffffffffc0201de2:	5775                	li	a4,-3
ffffffffc0201de4:	17c1                	addi	a5,a5,-16
ffffffffc0201de6:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0201dea:	8082                	ret
ffffffffc0201dec:	1141                	addi	sp,sp,-16
ffffffffc0201dee:	0000b697          	auipc	a3,0xb
ffffffffc0201df2:	dca68693          	addi	a3,a3,-566 # ffffffffc020cbb8 <etext+0xe80>
ffffffffc0201df6:	0000a617          	auipc	a2,0xa
ffffffffc0201dfa:	37a60613          	addi	a2,a2,890 # ffffffffc020c170 <etext+0x438>
ffffffffc0201dfe:	06100593          	li	a1,97
ffffffffc0201e02:	0000b517          	auipc	a0,0xb
ffffffffc0201e06:	a7650513          	addi	a0,a0,-1418 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201e0a:	e406                	sd	ra,8(sp)
ffffffffc0201e0c:	e3efe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201e10 <default_init_memmap>:
ffffffffc0201e10:	1141                	addi	sp,sp,-16
ffffffffc0201e12:	e406                	sd	ra,8(sp)
ffffffffc0201e14:	c9e1                	beqz	a1,ffffffffc0201ee4 <default_init_memmap+0xd4>
ffffffffc0201e16:	00659713          	slli	a4,a1,0x6
ffffffffc0201e1a:	00e506b3          	add	a3,a0,a4
ffffffffc0201e1e:	87aa                	mv	a5,a0
ffffffffc0201e20:	cf11                	beqz	a4,ffffffffc0201e3c <default_init_memmap+0x2c>
ffffffffc0201e22:	6798                	ld	a4,8(a5)
ffffffffc0201e24:	8b05                	andi	a4,a4,1
ffffffffc0201e26:	cf59                	beqz	a4,ffffffffc0201ec4 <default_init_memmap+0xb4>
ffffffffc0201e28:	0007a823          	sw	zero,16(a5)
ffffffffc0201e2c:	0007b423          	sd	zero,8(a5)
ffffffffc0201e30:	0007a023          	sw	zero,0(a5)
ffffffffc0201e34:	04078793          	addi	a5,a5,64
ffffffffc0201e38:	fed795e3          	bne	a5,a3,ffffffffc0201e22 <default_init_memmap+0x12>
ffffffffc0201e3c:	c90c                	sw	a1,16(a0)
ffffffffc0201e3e:	4789                	li	a5,2
ffffffffc0201e40:	00850713          	addi	a4,a0,8
ffffffffc0201e44:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0201e48:	00091717          	auipc	a4,0x91
ffffffffc0201e4c:	97072703          	lw	a4,-1680(a4) # ffffffffc02927b8 <free_area+0x10>
ffffffffc0201e50:	00091697          	auipc	a3,0x91
ffffffffc0201e54:	95868693          	addi	a3,a3,-1704 # ffffffffc02927a8 <free_area>
ffffffffc0201e58:	669c                	ld	a5,8(a3)
ffffffffc0201e5a:	9f2d                	addw	a4,a4,a1
ffffffffc0201e5c:	ca98                	sw	a4,16(a3)
ffffffffc0201e5e:	04d78663          	beq	a5,a3,ffffffffc0201eaa <default_init_memmap+0x9a>
ffffffffc0201e62:	fe878713          	addi	a4,a5,-24
ffffffffc0201e66:	4581                	li	a1,0
ffffffffc0201e68:	01850613          	addi	a2,a0,24
ffffffffc0201e6c:	00e56a63          	bltu	a0,a4,ffffffffc0201e80 <default_init_memmap+0x70>
ffffffffc0201e70:	6798                	ld	a4,8(a5)
ffffffffc0201e72:	02d70263          	beq	a4,a3,ffffffffc0201e96 <default_init_memmap+0x86>
ffffffffc0201e76:	87ba                	mv	a5,a4
ffffffffc0201e78:	fe878713          	addi	a4,a5,-24
ffffffffc0201e7c:	fee57ae3          	bgeu	a0,a4,ffffffffc0201e70 <default_init_memmap+0x60>
ffffffffc0201e80:	c199                	beqz	a1,ffffffffc0201e86 <default_init_memmap+0x76>
ffffffffc0201e82:	0106b023          	sd	a6,0(a3)
ffffffffc0201e86:	6398                	ld	a4,0(a5)
ffffffffc0201e88:	60a2                	ld	ra,8(sp)
ffffffffc0201e8a:	e390                	sd	a2,0(a5)
ffffffffc0201e8c:	e710                	sd	a2,8(a4)
ffffffffc0201e8e:	ed18                	sd	a4,24(a0)
ffffffffc0201e90:	f11c                	sd	a5,32(a0)
ffffffffc0201e92:	0141                	addi	sp,sp,16
ffffffffc0201e94:	8082                	ret
ffffffffc0201e96:	e790                	sd	a2,8(a5)
ffffffffc0201e98:	f114                	sd	a3,32(a0)
ffffffffc0201e9a:	6798                	ld	a4,8(a5)
ffffffffc0201e9c:	ed1c                	sd	a5,24(a0)
ffffffffc0201e9e:	8832                	mv	a6,a2
ffffffffc0201ea0:	00d70e63          	beq	a4,a3,ffffffffc0201ebc <default_init_memmap+0xac>
ffffffffc0201ea4:	4585                	li	a1,1
ffffffffc0201ea6:	87ba                	mv	a5,a4
ffffffffc0201ea8:	bfc1                	j	ffffffffc0201e78 <default_init_memmap+0x68>
ffffffffc0201eaa:	60a2                	ld	ra,8(sp)
ffffffffc0201eac:	01850713          	addi	a4,a0,24
ffffffffc0201eb0:	f11c                	sd	a5,32(a0)
ffffffffc0201eb2:	ed1c                	sd	a5,24(a0)
ffffffffc0201eb4:	e398                	sd	a4,0(a5)
ffffffffc0201eb6:	e798                	sd	a4,8(a5)
ffffffffc0201eb8:	0141                	addi	sp,sp,16
ffffffffc0201eba:	8082                	ret
ffffffffc0201ebc:	60a2                	ld	ra,8(sp)
ffffffffc0201ebe:	e290                	sd	a2,0(a3)
ffffffffc0201ec0:	0141                	addi	sp,sp,16
ffffffffc0201ec2:	8082                	ret
ffffffffc0201ec4:	0000b697          	auipc	a3,0xb
ffffffffc0201ec8:	d2468693          	addi	a3,a3,-732 # ffffffffc020cbe8 <etext+0xeb0>
ffffffffc0201ecc:	0000a617          	auipc	a2,0xa
ffffffffc0201ed0:	2a460613          	addi	a2,a2,676 # ffffffffc020c170 <etext+0x438>
ffffffffc0201ed4:	04800593          	li	a1,72
ffffffffc0201ed8:	0000b517          	auipc	a0,0xb
ffffffffc0201edc:	9a050513          	addi	a0,a0,-1632 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201ee0:	d6afe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0201ee4:	0000b697          	auipc	a3,0xb
ffffffffc0201ee8:	cd468693          	addi	a3,a3,-812 # ffffffffc020cbb8 <etext+0xe80>
ffffffffc0201eec:	0000a617          	auipc	a2,0xa
ffffffffc0201ef0:	28460613          	addi	a2,a2,644 # ffffffffc020c170 <etext+0x438>
ffffffffc0201ef4:	04500593          	li	a1,69
ffffffffc0201ef8:	0000b517          	auipc	a0,0xb
ffffffffc0201efc:	98050513          	addi	a0,a0,-1664 # ffffffffc020c878 <etext+0xb40>
ffffffffc0201f00:	d4afe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0201f04 <slob_free>:
ffffffffc0201f04:	c531                	beqz	a0,ffffffffc0201f50 <slob_free+0x4c>
ffffffffc0201f06:	e9b9                	bnez	a1,ffffffffc0201f5c <slob_free+0x58>
ffffffffc0201f08:	100027f3          	csrr	a5,sstatus
ffffffffc0201f0c:	8b89                	andi	a5,a5,2
ffffffffc0201f0e:	4581                	li	a1,0
ffffffffc0201f10:	efb1                	bnez	a5,ffffffffc0201f6c <slob_free+0x68>
ffffffffc0201f12:	00090797          	auipc	a5,0x90
ffffffffc0201f16:	13e7b783          	ld	a5,318(a5) # ffffffffc0292050 <slobfree>
ffffffffc0201f1a:	873e                	mv	a4,a5
ffffffffc0201f1c:	679c                	ld	a5,8(a5)
ffffffffc0201f1e:	02a77a63          	bgeu	a4,a0,ffffffffc0201f52 <slob_free+0x4e>
ffffffffc0201f22:	00f56463          	bltu	a0,a5,ffffffffc0201f2a <slob_free+0x26>
ffffffffc0201f26:	fef76ae3          	bltu	a4,a5,ffffffffc0201f1a <slob_free+0x16>
ffffffffc0201f2a:	4110                	lw	a2,0(a0)
ffffffffc0201f2c:	00461693          	slli	a3,a2,0x4
ffffffffc0201f30:	96aa                	add	a3,a3,a0
ffffffffc0201f32:	0ad78463          	beq	a5,a3,ffffffffc0201fda <slob_free+0xd6>
ffffffffc0201f36:	4310                	lw	a2,0(a4)
ffffffffc0201f38:	e51c                	sd	a5,8(a0)
ffffffffc0201f3a:	00461693          	slli	a3,a2,0x4
ffffffffc0201f3e:	96ba                	add	a3,a3,a4
ffffffffc0201f40:	08d50163          	beq	a0,a3,ffffffffc0201fc2 <slob_free+0xbe>
ffffffffc0201f44:	e708                	sd	a0,8(a4)
ffffffffc0201f46:	00090797          	auipc	a5,0x90
ffffffffc0201f4a:	10e7b523          	sd	a4,266(a5) # ffffffffc0292050 <slobfree>
ffffffffc0201f4e:	e9a5                	bnez	a1,ffffffffc0201fbe <slob_free+0xba>
ffffffffc0201f50:	8082                	ret
ffffffffc0201f52:	fcf574e3          	bgeu	a0,a5,ffffffffc0201f1a <slob_free+0x16>
ffffffffc0201f56:	fcf762e3          	bltu	a4,a5,ffffffffc0201f1a <slob_free+0x16>
ffffffffc0201f5a:	bfc1                	j	ffffffffc0201f2a <slob_free+0x26>
ffffffffc0201f5c:	25bd                	addiw	a1,a1,15
ffffffffc0201f5e:	8191                	srli	a1,a1,0x4
ffffffffc0201f60:	c10c                	sw	a1,0(a0)
ffffffffc0201f62:	100027f3          	csrr	a5,sstatus
ffffffffc0201f66:	8b89                	andi	a5,a5,2
ffffffffc0201f68:	4581                	li	a1,0
ffffffffc0201f6a:	d7c5                	beqz	a5,ffffffffc0201f12 <slob_free+0xe>
ffffffffc0201f6c:	1101                	addi	sp,sp,-32
ffffffffc0201f6e:	e42a                	sd	a0,8(sp)
ffffffffc0201f70:	ec06                	sd	ra,24(sp)
ffffffffc0201f72:	cfffe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0201f76:	6522                	ld	a0,8(sp)
ffffffffc0201f78:	00090797          	auipc	a5,0x90
ffffffffc0201f7c:	0d87b783          	ld	a5,216(a5) # ffffffffc0292050 <slobfree>
ffffffffc0201f80:	4585                	li	a1,1
ffffffffc0201f82:	873e                	mv	a4,a5
ffffffffc0201f84:	679c                	ld	a5,8(a5)
ffffffffc0201f86:	06a77663          	bgeu	a4,a0,ffffffffc0201ff2 <slob_free+0xee>
ffffffffc0201f8a:	00f56463          	bltu	a0,a5,ffffffffc0201f92 <slob_free+0x8e>
ffffffffc0201f8e:	fef76ae3          	bltu	a4,a5,ffffffffc0201f82 <slob_free+0x7e>
ffffffffc0201f92:	4110                	lw	a2,0(a0)
ffffffffc0201f94:	00461693          	slli	a3,a2,0x4
ffffffffc0201f98:	96aa                	add	a3,a3,a0
ffffffffc0201f9a:	06d78363          	beq	a5,a3,ffffffffc0202000 <slob_free+0xfc>
ffffffffc0201f9e:	4310                	lw	a2,0(a4)
ffffffffc0201fa0:	e51c                	sd	a5,8(a0)
ffffffffc0201fa2:	00461693          	slli	a3,a2,0x4
ffffffffc0201fa6:	96ba                	add	a3,a3,a4
ffffffffc0201fa8:	06d50163          	beq	a0,a3,ffffffffc020200a <slob_free+0x106>
ffffffffc0201fac:	e708                	sd	a0,8(a4)
ffffffffc0201fae:	00090797          	auipc	a5,0x90
ffffffffc0201fb2:	0ae7b123          	sd	a4,162(a5) # ffffffffc0292050 <slobfree>
ffffffffc0201fb6:	e1a9                	bnez	a1,ffffffffc0201ff8 <slob_free+0xf4>
ffffffffc0201fb8:	60e2                	ld	ra,24(sp)
ffffffffc0201fba:	6105                	addi	sp,sp,32
ffffffffc0201fbc:	8082                	ret
ffffffffc0201fbe:	cadfe06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0201fc2:	4114                	lw	a3,0(a0)
ffffffffc0201fc4:	853e                	mv	a0,a5
ffffffffc0201fc6:	e708                	sd	a0,8(a4)
ffffffffc0201fc8:	00c687bb          	addw	a5,a3,a2
ffffffffc0201fcc:	c31c                	sw	a5,0(a4)
ffffffffc0201fce:	00090797          	auipc	a5,0x90
ffffffffc0201fd2:	08e7b123          	sd	a4,130(a5) # ffffffffc0292050 <slobfree>
ffffffffc0201fd6:	ddad                	beqz	a1,ffffffffc0201f50 <slob_free+0x4c>
ffffffffc0201fd8:	b7dd                	j	ffffffffc0201fbe <slob_free+0xba>
ffffffffc0201fda:	4394                	lw	a3,0(a5)
ffffffffc0201fdc:	679c                	ld	a5,8(a5)
ffffffffc0201fde:	9eb1                	addw	a3,a3,a2
ffffffffc0201fe0:	c114                	sw	a3,0(a0)
ffffffffc0201fe2:	4310                	lw	a2,0(a4)
ffffffffc0201fe4:	e51c                	sd	a5,8(a0)
ffffffffc0201fe6:	00461693          	slli	a3,a2,0x4
ffffffffc0201fea:	96ba                	add	a3,a3,a4
ffffffffc0201fec:	f4d51ce3          	bne	a0,a3,ffffffffc0201f44 <slob_free+0x40>
ffffffffc0201ff0:	bfc9                	j	ffffffffc0201fc2 <slob_free+0xbe>
ffffffffc0201ff2:	f8f56ee3          	bltu	a0,a5,ffffffffc0201f8e <slob_free+0x8a>
ffffffffc0201ff6:	b771                	j	ffffffffc0201f82 <slob_free+0x7e>
ffffffffc0201ff8:	60e2                	ld	ra,24(sp)
ffffffffc0201ffa:	6105                	addi	sp,sp,32
ffffffffc0201ffc:	c6ffe06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0202000:	4394                	lw	a3,0(a5)
ffffffffc0202002:	679c                	ld	a5,8(a5)
ffffffffc0202004:	9eb1                	addw	a3,a3,a2
ffffffffc0202006:	c114                	sw	a3,0(a0)
ffffffffc0202008:	bf59                	j	ffffffffc0201f9e <slob_free+0x9a>
ffffffffc020200a:	4114                	lw	a3,0(a0)
ffffffffc020200c:	853e                	mv	a0,a5
ffffffffc020200e:	00c687bb          	addw	a5,a3,a2
ffffffffc0202012:	c31c                	sw	a5,0(a4)
ffffffffc0202014:	bf61                	j	ffffffffc0201fac <slob_free+0xa8>

ffffffffc0202016 <__slob_get_free_pages.constprop.0>:
ffffffffc0202016:	4785                	li	a5,1
ffffffffc0202018:	1141                	addi	sp,sp,-16
ffffffffc020201a:	00a7953b          	sllw	a0,a5,a0
ffffffffc020201e:	e406                	sd	ra,8(sp)
ffffffffc0202020:	330000ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0202024:	c91d                	beqz	a0,ffffffffc020205a <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0202026:	00096697          	auipc	a3,0x96
ffffffffc020202a:	8926b683          	ld	a3,-1902(a3) # ffffffffc02978b8 <pages>
ffffffffc020202e:	0000e797          	auipc	a5,0xe
ffffffffc0202032:	ffa7b783          	ld	a5,-6(a5) # ffffffffc0210028 <nbase>
ffffffffc0202036:	00096717          	auipc	a4,0x96
ffffffffc020203a:	87a73703          	ld	a4,-1926(a4) # ffffffffc02978b0 <npage>
ffffffffc020203e:	8d15                	sub	a0,a0,a3
ffffffffc0202040:	8519                	srai	a0,a0,0x6
ffffffffc0202042:	953e                	add	a0,a0,a5
ffffffffc0202044:	00c51793          	slli	a5,a0,0xc
ffffffffc0202048:	83b1                	srli	a5,a5,0xc
ffffffffc020204a:	0532                	slli	a0,a0,0xc
ffffffffc020204c:	00e7fa63          	bgeu	a5,a4,ffffffffc0202060 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0202050:	00096797          	auipc	a5,0x96
ffffffffc0202054:	8587b783          	ld	a5,-1960(a5) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0202058:	953e                	add	a0,a0,a5
ffffffffc020205a:	60a2                	ld	ra,8(sp)
ffffffffc020205c:	0141                	addi	sp,sp,16
ffffffffc020205e:	8082                	ret
ffffffffc0202060:	86aa                	mv	a3,a0
ffffffffc0202062:	0000b617          	auipc	a2,0xb
ffffffffc0202066:	bae60613          	addi	a2,a2,-1106 # ffffffffc020cc10 <etext+0xed8>
ffffffffc020206a:	07100593          	li	a1,113
ffffffffc020206e:	0000b517          	auipc	a0,0xb
ffffffffc0202072:	bca50513          	addi	a0,a0,-1078 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0202076:	bd4fe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020207a <slob_alloc.constprop.0>:
ffffffffc020207a:	7179                	addi	sp,sp,-48
ffffffffc020207c:	f406                	sd	ra,40(sp)
ffffffffc020207e:	f022                	sd	s0,32(sp)
ffffffffc0202080:	ec26                	sd	s1,24(sp)
ffffffffc0202082:	01050713          	addi	a4,a0,16
ffffffffc0202086:	6785                	lui	a5,0x1
ffffffffc0202088:	0af77e63          	bgeu	a4,a5,ffffffffc0202144 <slob_alloc.constprop.0+0xca>
ffffffffc020208c:	00f50413          	addi	s0,a0,15
ffffffffc0202090:	8011                	srli	s0,s0,0x4
ffffffffc0202092:	2401                	sext.w	s0,s0
ffffffffc0202094:	100025f3          	csrr	a1,sstatus
ffffffffc0202098:	8989                	andi	a1,a1,2
ffffffffc020209a:	edd1                	bnez	a1,ffffffffc0202136 <slob_alloc.constprop.0+0xbc>
ffffffffc020209c:	00090497          	auipc	s1,0x90
ffffffffc02020a0:	fb448493          	addi	s1,s1,-76 # ffffffffc0292050 <slobfree>
ffffffffc02020a4:	6090                	ld	a2,0(s1)
ffffffffc02020a6:	6618                	ld	a4,8(a2)
ffffffffc02020a8:	4314                	lw	a3,0(a4)
ffffffffc02020aa:	0886da63          	bge	a3,s0,ffffffffc020213e <slob_alloc.constprop.0+0xc4>
ffffffffc02020ae:	00e60a63          	beq	a2,a4,ffffffffc02020c2 <slob_alloc.constprop.0+0x48>
ffffffffc02020b2:	671c                	ld	a5,8(a4)
ffffffffc02020b4:	4394                	lw	a3,0(a5)
ffffffffc02020b6:	0286d863          	bge	a3,s0,ffffffffc02020e6 <slob_alloc.constprop.0+0x6c>
ffffffffc02020ba:	6090                	ld	a2,0(s1)
ffffffffc02020bc:	873e                	mv	a4,a5
ffffffffc02020be:	fee61ae3          	bne	a2,a4,ffffffffc02020b2 <slob_alloc.constprop.0+0x38>
ffffffffc02020c2:	e9b1                	bnez	a1,ffffffffc0202116 <slob_alloc.constprop.0+0x9c>
ffffffffc02020c4:	4501                	li	a0,0
ffffffffc02020c6:	f51ff0ef          	jal	ffffffffc0202016 <__slob_get_free_pages.constprop.0>
ffffffffc02020ca:	87aa                	mv	a5,a0
ffffffffc02020cc:	c915                	beqz	a0,ffffffffc0202100 <slob_alloc.constprop.0+0x86>
ffffffffc02020ce:	6585                	lui	a1,0x1
ffffffffc02020d0:	e35ff0ef          	jal	ffffffffc0201f04 <slob_free>
ffffffffc02020d4:	100025f3          	csrr	a1,sstatus
ffffffffc02020d8:	8989                	andi	a1,a1,2
ffffffffc02020da:	e98d                	bnez	a1,ffffffffc020210c <slob_alloc.constprop.0+0x92>
ffffffffc02020dc:	6098                	ld	a4,0(s1)
ffffffffc02020de:	671c                	ld	a5,8(a4)
ffffffffc02020e0:	4394                	lw	a3,0(a5)
ffffffffc02020e2:	fc86cce3          	blt	a3,s0,ffffffffc02020ba <slob_alloc.constprop.0+0x40>
ffffffffc02020e6:	04d40563          	beq	s0,a3,ffffffffc0202130 <slob_alloc.constprop.0+0xb6>
ffffffffc02020ea:	00441613          	slli	a2,s0,0x4
ffffffffc02020ee:	963e                	add	a2,a2,a5
ffffffffc02020f0:	e710                	sd	a2,8(a4)
ffffffffc02020f2:	6788                	ld	a0,8(a5)
ffffffffc02020f4:	9e81                	subw	a3,a3,s0
ffffffffc02020f6:	c214                	sw	a3,0(a2)
ffffffffc02020f8:	e608                	sd	a0,8(a2)
ffffffffc02020fa:	c380                	sw	s0,0(a5)
ffffffffc02020fc:	e098                	sd	a4,0(s1)
ffffffffc02020fe:	ed99                	bnez	a1,ffffffffc020211c <slob_alloc.constprop.0+0xa2>
ffffffffc0202100:	70a2                	ld	ra,40(sp)
ffffffffc0202102:	7402                	ld	s0,32(sp)
ffffffffc0202104:	64e2                	ld	s1,24(sp)
ffffffffc0202106:	853e                	mv	a0,a5
ffffffffc0202108:	6145                	addi	sp,sp,48
ffffffffc020210a:	8082                	ret
ffffffffc020210c:	b65fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202110:	6098                	ld	a4,0(s1)
ffffffffc0202112:	4585                	li	a1,1
ffffffffc0202114:	b7e9                	j	ffffffffc02020de <slob_alloc.constprop.0+0x64>
ffffffffc0202116:	b55fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020211a:	b76d                	j	ffffffffc02020c4 <slob_alloc.constprop.0+0x4a>
ffffffffc020211c:	e43e                	sd	a5,8(sp)
ffffffffc020211e:	b4dfe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202122:	67a2                	ld	a5,8(sp)
ffffffffc0202124:	70a2                	ld	ra,40(sp)
ffffffffc0202126:	7402                	ld	s0,32(sp)
ffffffffc0202128:	64e2                	ld	s1,24(sp)
ffffffffc020212a:	853e                	mv	a0,a5
ffffffffc020212c:	6145                	addi	sp,sp,48
ffffffffc020212e:	8082                	ret
ffffffffc0202130:	6794                	ld	a3,8(a5)
ffffffffc0202132:	e714                	sd	a3,8(a4)
ffffffffc0202134:	b7e1                	j	ffffffffc02020fc <slob_alloc.constprop.0+0x82>
ffffffffc0202136:	b3bfe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020213a:	4585                	li	a1,1
ffffffffc020213c:	b785                	j	ffffffffc020209c <slob_alloc.constprop.0+0x22>
ffffffffc020213e:	87ba                	mv	a5,a4
ffffffffc0202140:	8732                	mv	a4,a2
ffffffffc0202142:	b755                	j	ffffffffc02020e6 <slob_alloc.constprop.0+0x6c>
ffffffffc0202144:	0000b697          	auipc	a3,0xb
ffffffffc0202148:	b0468693          	addi	a3,a3,-1276 # ffffffffc020cc48 <etext+0xf10>
ffffffffc020214c:	0000a617          	auipc	a2,0xa
ffffffffc0202150:	02460613          	addi	a2,a2,36 # ffffffffc020c170 <etext+0x438>
ffffffffc0202154:	06300593          	li	a1,99
ffffffffc0202158:	0000b517          	auipc	a0,0xb
ffffffffc020215c:	b1050513          	addi	a0,a0,-1264 # ffffffffc020cc68 <etext+0xf30>
ffffffffc0202160:	aeafe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202164 <kmalloc_init>:
ffffffffc0202164:	1141                	addi	sp,sp,-16
ffffffffc0202166:	0000b517          	auipc	a0,0xb
ffffffffc020216a:	b1a50513          	addi	a0,a0,-1254 # ffffffffc020cc80 <etext+0xf48>
ffffffffc020216e:	e406                	sd	ra,8(sp)
ffffffffc0202170:	836fe0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202174:	60a2                	ld	ra,8(sp)
ffffffffc0202176:	0000b517          	auipc	a0,0xb
ffffffffc020217a:	b2250513          	addi	a0,a0,-1246 # ffffffffc020cc98 <etext+0xf60>
ffffffffc020217e:	0141                	addi	sp,sp,16
ffffffffc0202180:	826fe06f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0202184 <kallocated>:
ffffffffc0202184:	4501                	li	a0,0
ffffffffc0202186:	8082                	ret

ffffffffc0202188 <kmalloc>:
ffffffffc0202188:	1101                	addi	sp,sp,-32
ffffffffc020218a:	6685                	lui	a3,0x1
ffffffffc020218c:	ec06                	sd	ra,24(sp)
ffffffffc020218e:	16bd                	addi	a3,a3,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc0202190:	04a6f963          	bgeu	a3,a0,ffffffffc02021e2 <kmalloc+0x5a>
ffffffffc0202194:	e42a                	sd	a0,8(sp)
ffffffffc0202196:	4561                	li	a0,24
ffffffffc0202198:	e822                	sd	s0,16(sp)
ffffffffc020219a:	ee1ff0ef          	jal	ffffffffc020207a <slob_alloc.constprop.0>
ffffffffc020219e:	842a                	mv	s0,a0
ffffffffc02021a0:	c541                	beqz	a0,ffffffffc0202228 <kmalloc+0xa0>
ffffffffc02021a2:	47a2                	lw	a5,8(sp)
ffffffffc02021a4:	6705                	lui	a4,0x1
ffffffffc02021a6:	4501                	li	a0,0
ffffffffc02021a8:	00f75763          	bge	a4,a5,ffffffffc02021b6 <kmalloc+0x2e>
ffffffffc02021ac:	4017d79b          	sraiw	a5,a5,0x1
ffffffffc02021b0:	2505                	addiw	a0,a0,1
ffffffffc02021b2:	fef74de3          	blt	a4,a5,ffffffffc02021ac <kmalloc+0x24>
ffffffffc02021b6:	c008                	sw	a0,0(s0)
ffffffffc02021b8:	e5fff0ef          	jal	ffffffffc0202016 <__slob_get_free_pages.constprop.0>
ffffffffc02021bc:	e408                	sd	a0,8(s0)
ffffffffc02021be:	cd31                	beqz	a0,ffffffffc020221a <kmalloc+0x92>
ffffffffc02021c0:	100027f3          	csrr	a5,sstatus
ffffffffc02021c4:	8b89                	andi	a5,a5,2
ffffffffc02021c6:	eb85                	bnez	a5,ffffffffc02021f6 <kmalloc+0x6e>
ffffffffc02021c8:	00095797          	auipc	a5,0x95
ffffffffc02021cc:	6c07b783          	ld	a5,1728(a5) # ffffffffc0297888 <bigblocks>
ffffffffc02021d0:	00095717          	auipc	a4,0x95
ffffffffc02021d4:	6a873c23          	sd	s0,1720(a4) # ffffffffc0297888 <bigblocks>
ffffffffc02021d8:	e81c                	sd	a5,16(s0)
ffffffffc02021da:	6442                	ld	s0,16(sp)
ffffffffc02021dc:	60e2                	ld	ra,24(sp)
ffffffffc02021de:	6105                	addi	sp,sp,32
ffffffffc02021e0:	8082                	ret
ffffffffc02021e2:	0541                	addi	a0,a0,16
ffffffffc02021e4:	e97ff0ef          	jal	ffffffffc020207a <slob_alloc.constprop.0>
ffffffffc02021e8:	87aa                	mv	a5,a0
ffffffffc02021ea:	0541                	addi	a0,a0,16
ffffffffc02021ec:	fbe5                	bnez	a5,ffffffffc02021dc <kmalloc+0x54>
ffffffffc02021ee:	4501                	li	a0,0
ffffffffc02021f0:	60e2                	ld	ra,24(sp)
ffffffffc02021f2:	6105                	addi	sp,sp,32
ffffffffc02021f4:	8082                	ret
ffffffffc02021f6:	a7bfe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02021fa:	00095797          	auipc	a5,0x95
ffffffffc02021fe:	68e7b783          	ld	a5,1678(a5) # ffffffffc0297888 <bigblocks>
ffffffffc0202202:	00095717          	auipc	a4,0x95
ffffffffc0202206:	68873323          	sd	s0,1670(a4) # ffffffffc0297888 <bigblocks>
ffffffffc020220a:	e81c                	sd	a5,16(s0)
ffffffffc020220c:	a5ffe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202210:	6408                	ld	a0,8(s0)
ffffffffc0202212:	60e2                	ld	ra,24(sp)
ffffffffc0202214:	6442                	ld	s0,16(sp)
ffffffffc0202216:	6105                	addi	sp,sp,32
ffffffffc0202218:	8082                	ret
ffffffffc020221a:	8522                	mv	a0,s0
ffffffffc020221c:	45e1                	li	a1,24
ffffffffc020221e:	ce7ff0ef          	jal	ffffffffc0201f04 <slob_free>
ffffffffc0202222:	4501                	li	a0,0
ffffffffc0202224:	6442                	ld	s0,16(sp)
ffffffffc0202226:	b7e9                	j	ffffffffc02021f0 <kmalloc+0x68>
ffffffffc0202228:	6442                	ld	s0,16(sp)
ffffffffc020222a:	4501                	li	a0,0
ffffffffc020222c:	b7d1                	j	ffffffffc02021f0 <kmalloc+0x68>

ffffffffc020222e <kfree>:
ffffffffc020222e:	c969                	beqz	a0,ffffffffc0202300 <kfree+0xd2>
ffffffffc0202230:	03451793          	slli	a5,a0,0x34
ffffffffc0202234:	e3f1                	bnez	a5,ffffffffc02022f8 <kfree+0xca>
ffffffffc0202236:	1101                	addi	sp,sp,-32
ffffffffc0202238:	ec06                	sd	ra,24(sp)
ffffffffc020223a:	100027f3          	csrr	a5,sstatus
ffffffffc020223e:	8b89                	andi	a5,a5,2
ffffffffc0202240:	e7d1                	bnez	a5,ffffffffc02022cc <kfree+0x9e>
ffffffffc0202242:	00095797          	auipc	a5,0x95
ffffffffc0202246:	6467b783          	ld	a5,1606(a5) # ffffffffc0297888 <bigblocks>
ffffffffc020224a:	4581                	li	a1,0
ffffffffc020224c:	cbb5                	beqz	a5,ffffffffc02022c0 <kfree+0x92>
ffffffffc020224e:	00095617          	auipc	a2,0x95
ffffffffc0202252:	63a60613          	addi	a2,a2,1594 # ffffffffc0297888 <bigblocks>
ffffffffc0202256:	a021                	j	ffffffffc020225e <kfree+0x30>
ffffffffc0202258:	01070613          	addi	a2,a4,16
ffffffffc020225c:	c3ad                	beqz	a5,ffffffffc02022be <kfree+0x90>
ffffffffc020225e:	6794                	ld	a3,8(a5)
ffffffffc0202260:	873e                	mv	a4,a5
ffffffffc0202262:	6b9c                	ld	a5,16(a5)
ffffffffc0202264:	fea69ae3          	bne	a3,a0,ffffffffc0202258 <kfree+0x2a>
ffffffffc0202268:	e21c                	sd	a5,0(a2)
ffffffffc020226a:	e1c1                	bnez	a1,ffffffffc02022ea <kfree+0xbc>
ffffffffc020226c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202270:	0af56563          	bltu	a0,a5,ffffffffc020231a <kfree+0xec>
ffffffffc0202274:	00095797          	auipc	a5,0x95
ffffffffc0202278:	6347b783          	ld	a5,1588(a5) # ffffffffc02978a8 <va_pa_offset>
ffffffffc020227c:	00095697          	auipc	a3,0x95
ffffffffc0202280:	6346b683          	ld	a3,1588(a3) # ffffffffc02978b0 <npage>
ffffffffc0202284:	8d1d                	sub	a0,a0,a5
ffffffffc0202286:	00c55793          	srli	a5,a0,0xc
ffffffffc020228a:	06d7fc63          	bgeu	a5,a3,ffffffffc0202302 <kfree+0xd4>
ffffffffc020228e:	0000e617          	auipc	a2,0xe
ffffffffc0202292:	d9a63603          	ld	a2,-614(a2) # ffffffffc0210028 <nbase>
ffffffffc0202296:	00095517          	auipc	a0,0x95
ffffffffc020229a:	62253503          	ld	a0,1570(a0) # ffffffffc02978b8 <pages>
ffffffffc020229e:	4314                	lw	a3,0(a4)
ffffffffc02022a0:	8f91                	sub	a5,a5,a2
ffffffffc02022a2:	079a                	slli	a5,a5,0x6
ffffffffc02022a4:	4585                	li	a1,1
ffffffffc02022a6:	953e                	add	a0,a0,a5
ffffffffc02022a8:	00d595bb          	sllw	a1,a1,a3
ffffffffc02022ac:	e03a                	sd	a4,0(sp)
ffffffffc02022ae:	0dc000ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02022b2:	6502                	ld	a0,0(sp)
ffffffffc02022b4:	60e2                	ld	ra,24(sp)
ffffffffc02022b6:	45e1                	li	a1,24
ffffffffc02022b8:	6105                	addi	sp,sp,32
ffffffffc02022ba:	c4bff06f          	j	ffffffffc0201f04 <slob_free>
ffffffffc02022be:	e18d                	bnez	a1,ffffffffc02022e0 <kfree+0xb2>
ffffffffc02022c0:	60e2                	ld	ra,24(sp)
ffffffffc02022c2:	1541                	addi	a0,a0,-16
ffffffffc02022c4:	4581                	li	a1,0
ffffffffc02022c6:	6105                	addi	sp,sp,32
ffffffffc02022c8:	c3dff06f          	j	ffffffffc0201f04 <slob_free>
ffffffffc02022cc:	e02a                	sd	a0,0(sp)
ffffffffc02022ce:	9a3fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02022d2:	00095797          	auipc	a5,0x95
ffffffffc02022d6:	5b67b783          	ld	a5,1462(a5) # ffffffffc0297888 <bigblocks>
ffffffffc02022da:	6502                	ld	a0,0(sp)
ffffffffc02022dc:	4585                	li	a1,1
ffffffffc02022de:	fba5                	bnez	a5,ffffffffc020224e <kfree+0x20>
ffffffffc02022e0:	e02a                	sd	a0,0(sp)
ffffffffc02022e2:	989fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02022e6:	6502                	ld	a0,0(sp)
ffffffffc02022e8:	bfe1                	j	ffffffffc02022c0 <kfree+0x92>
ffffffffc02022ea:	e42a                	sd	a0,8(sp)
ffffffffc02022ec:	e03a                	sd	a4,0(sp)
ffffffffc02022ee:	97dfe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02022f2:	6522                	ld	a0,8(sp)
ffffffffc02022f4:	6702                	ld	a4,0(sp)
ffffffffc02022f6:	bf9d                	j	ffffffffc020226c <kfree+0x3e>
ffffffffc02022f8:	1541                	addi	a0,a0,-16
ffffffffc02022fa:	4581                	li	a1,0
ffffffffc02022fc:	c09ff06f          	j	ffffffffc0201f04 <slob_free>
ffffffffc0202300:	8082                	ret
ffffffffc0202302:	0000b617          	auipc	a2,0xb
ffffffffc0202306:	9de60613          	addi	a2,a2,-1570 # ffffffffc020cce0 <etext+0xfa8>
ffffffffc020230a:	06900593          	li	a1,105
ffffffffc020230e:	0000b517          	auipc	a0,0xb
ffffffffc0202312:	92a50513          	addi	a0,a0,-1750 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0202316:	934fe0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020231a:	86aa                	mv	a3,a0
ffffffffc020231c:	0000b617          	auipc	a2,0xb
ffffffffc0202320:	99c60613          	addi	a2,a2,-1636 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc0202324:	07700593          	li	a1,119
ffffffffc0202328:	0000b517          	auipc	a0,0xb
ffffffffc020232c:	91050513          	addi	a0,a0,-1776 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0202330:	91afe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202334 <pa2page.part.0>:
ffffffffc0202334:	1141                	addi	sp,sp,-16
ffffffffc0202336:	0000b617          	auipc	a2,0xb
ffffffffc020233a:	9aa60613          	addi	a2,a2,-1622 # ffffffffc020cce0 <etext+0xfa8>
ffffffffc020233e:	06900593          	li	a1,105
ffffffffc0202342:	0000b517          	auipc	a0,0xb
ffffffffc0202346:	8f650513          	addi	a0,a0,-1802 # ffffffffc020cc38 <etext+0xf00>
ffffffffc020234a:	e406                	sd	ra,8(sp)
ffffffffc020234c:	8fefe0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202350 <alloc_pages>:
ffffffffc0202350:	100027f3          	csrr	a5,sstatus
ffffffffc0202354:	8b89                	andi	a5,a5,2
ffffffffc0202356:	e799                	bnez	a5,ffffffffc0202364 <alloc_pages+0x14>
ffffffffc0202358:	00095797          	auipc	a5,0x95
ffffffffc020235c:	5387b783          	ld	a5,1336(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0202360:	6f9c                	ld	a5,24(a5)
ffffffffc0202362:	8782                	jr	a5
ffffffffc0202364:	1101                	addi	sp,sp,-32
ffffffffc0202366:	ec06                	sd	ra,24(sp)
ffffffffc0202368:	e42a                	sd	a0,8(sp)
ffffffffc020236a:	907fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020236e:	00095797          	auipc	a5,0x95
ffffffffc0202372:	5227b783          	ld	a5,1314(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0202376:	6522                	ld	a0,8(sp)
ffffffffc0202378:	6f9c                	ld	a5,24(a5)
ffffffffc020237a:	9782                	jalr	a5
ffffffffc020237c:	e42a                	sd	a0,8(sp)
ffffffffc020237e:	8edfe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202382:	60e2                	ld	ra,24(sp)
ffffffffc0202384:	6522                	ld	a0,8(sp)
ffffffffc0202386:	6105                	addi	sp,sp,32
ffffffffc0202388:	8082                	ret

ffffffffc020238a <free_pages>:
ffffffffc020238a:	100027f3          	csrr	a5,sstatus
ffffffffc020238e:	8b89                	andi	a5,a5,2
ffffffffc0202390:	e799                	bnez	a5,ffffffffc020239e <free_pages+0x14>
ffffffffc0202392:	00095797          	auipc	a5,0x95
ffffffffc0202396:	4fe7b783          	ld	a5,1278(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc020239a:	739c                	ld	a5,32(a5)
ffffffffc020239c:	8782                	jr	a5
ffffffffc020239e:	1101                	addi	sp,sp,-32
ffffffffc02023a0:	ec06                	sd	ra,24(sp)
ffffffffc02023a2:	e42e                	sd	a1,8(sp)
ffffffffc02023a4:	e02a                	sd	a0,0(sp)
ffffffffc02023a6:	8cbfe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02023aa:	00095797          	auipc	a5,0x95
ffffffffc02023ae:	4e67b783          	ld	a5,1254(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02023b2:	65a2                	ld	a1,8(sp)
ffffffffc02023b4:	6502                	ld	a0,0(sp)
ffffffffc02023b6:	739c                	ld	a5,32(a5)
ffffffffc02023b8:	9782                	jalr	a5
ffffffffc02023ba:	60e2                	ld	ra,24(sp)
ffffffffc02023bc:	6105                	addi	sp,sp,32
ffffffffc02023be:	8adfe06f          	j	ffffffffc0200c6a <intr_enable>

ffffffffc02023c2 <nr_free_pages>:
ffffffffc02023c2:	100027f3          	csrr	a5,sstatus
ffffffffc02023c6:	8b89                	andi	a5,a5,2
ffffffffc02023c8:	e799                	bnez	a5,ffffffffc02023d6 <nr_free_pages+0x14>
ffffffffc02023ca:	00095797          	auipc	a5,0x95
ffffffffc02023ce:	4c67b783          	ld	a5,1222(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02023d2:	779c                	ld	a5,40(a5)
ffffffffc02023d4:	8782                	jr	a5
ffffffffc02023d6:	1101                	addi	sp,sp,-32
ffffffffc02023d8:	ec06                	sd	ra,24(sp)
ffffffffc02023da:	897fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02023de:	00095797          	auipc	a5,0x95
ffffffffc02023e2:	4b27b783          	ld	a5,1202(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02023e6:	779c                	ld	a5,40(a5)
ffffffffc02023e8:	9782                	jalr	a5
ffffffffc02023ea:	e42a                	sd	a0,8(sp)
ffffffffc02023ec:	87ffe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02023f0:	60e2                	ld	ra,24(sp)
ffffffffc02023f2:	6522                	ld	a0,8(sp)
ffffffffc02023f4:	6105                	addi	sp,sp,32
ffffffffc02023f6:	8082                	ret

ffffffffc02023f8 <get_pte>:
ffffffffc02023f8:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02023fc:	1ff7f793          	andi	a5,a5,511
ffffffffc0202400:	078e                	slli	a5,a5,0x3
ffffffffc0202402:	00f50733          	add	a4,a0,a5
ffffffffc0202406:	6314                	ld	a3,0(a4)
ffffffffc0202408:	7139                	addi	sp,sp,-64
ffffffffc020240a:	f822                	sd	s0,48(sp)
ffffffffc020240c:	f426                	sd	s1,40(sp)
ffffffffc020240e:	fc06                	sd	ra,56(sp)
ffffffffc0202410:	0016f793          	andi	a5,a3,1
ffffffffc0202414:	842e                	mv	s0,a1
ffffffffc0202416:	8832                	mv	a6,a2
ffffffffc0202418:	00095497          	auipc	s1,0x95
ffffffffc020241c:	49848493          	addi	s1,s1,1176 # ffffffffc02978b0 <npage>
ffffffffc0202420:	ebd1                	bnez	a5,ffffffffc02024b4 <get_pte+0xbc>
ffffffffc0202422:	16060d63          	beqz	a2,ffffffffc020259c <get_pte+0x1a4>
ffffffffc0202426:	100027f3          	csrr	a5,sstatus
ffffffffc020242a:	8b89                	andi	a5,a5,2
ffffffffc020242c:	16079e63          	bnez	a5,ffffffffc02025a8 <get_pte+0x1b0>
ffffffffc0202430:	00095797          	auipc	a5,0x95
ffffffffc0202434:	4607b783          	ld	a5,1120(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0202438:	4505                	li	a0,1
ffffffffc020243a:	e43a                	sd	a4,8(sp)
ffffffffc020243c:	6f9c                	ld	a5,24(a5)
ffffffffc020243e:	e832                	sd	a2,16(sp)
ffffffffc0202440:	9782                	jalr	a5
ffffffffc0202442:	6722                	ld	a4,8(sp)
ffffffffc0202444:	6842                	ld	a6,16(sp)
ffffffffc0202446:	87aa                	mv	a5,a0
ffffffffc0202448:	14078a63          	beqz	a5,ffffffffc020259c <get_pte+0x1a4>
ffffffffc020244c:	00095517          	auipc	a0,0x95
ffffffffc0202450:	46c53503          	ld	a0,1132(a0) # ffffffffc02978b8 <pages>
ffffffffc0202454:	000808b7          	lui	a7,0x80
ffffffffc0202458:	00095497          	auipc	s1,0x95
ffffffffc020245c:	45848493          	addi	s1,s1,1112 # ffffffffc02978b0 <npage>
ffffffffc0202460:	40a78533          	sub	a0,a5,a0
ffffffffc0202464:	8519                	srai	a0,a0,0x6
ffffffffc0202466:	9546                	add	a0,a0,a7
ffffffffc0202468:	6090                	ld	a2,0(s1)
ffffffffc020246a:	00c51693          	slli	a3,a0,0xc
ffffffffc020246e:	4585                	li	a1,1
ffffffffc0202470:	82b1                	srli	a3,a3,0xc
ffffffffc0202472:	c38c                	sw	a1,0(a5)
ffffffffc0202474:	0532                	slli	a0,a0,0xc
ffffffffc0202476:	1ac6f763          	bgeu	a3,a2,ffffffffc0202624 <get_pte+0x22c>
ffffffffc020247a:	00095697          	auipc	a3,0x95
ffffffffc020247e:	42e6b683          	ld	a3,1070(a3) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0202482:	6605                	lui	a2,0x1
ffffffffc0202484:	4581                	li	a1,0
ffffffffc0202486:	9536                	add	a0,a0,a3
ffffffffc0202488:	ec42                	sd	a6,24(sp)
ffffffffc020248a:	e83e                	sd	a5,16(sp)
ffffffffc020248c:	e43a                	sd	a4,8(sp)
ffffffffc020248e:	043090ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0202492:	00095697          	auipc	a3,0x95
ffffffffc0202496:	4266b683          	ld	a3,1062(a3) # ffffffffc02978b8 <pages>
ffffffffc020249a:	67c2                	ld	a5,16(sp)
ffffffffc020249c:	000808b7          	lui	a7,0x80
ffffffffc02024a0:	6722                	ld	a4,8(sp)
ffffffffc02024a2:	40d786b3          	sub	a3,a5,a3
ffffffffc02024a6:	8699                	srai	a3,a3,0x6
ffffffffc02024a8:	96c6                	add	a3,a3,a7
ffffffffc02024aa:	06aa                	slli	a3,a3,0xa
ffffffffc02024ac:	6862                	ld	a6,24(sp)
ffffffffc02024ae:	0116e693          	ori	a3,a3,17
ffffffffc02024b2:	e314                	sd	a3,0(a4)
ffffffffc02024b4:	c006f693          	andi	a3,a3,-1024
ffffffffc02024b8:	6098                	ld	a4,0(s1)
ffffffffc02024ba:	068a                	slli	a3,a3,0x2
ffffffffc02024bc:	00c6d793          	srli	a5,a3,0xc
ffffffffc02024c0:	14e7f663          	bgeu	a5,a4,ffffffffc020260c <get_pte+0x214>
ffffffffc02024c4:	00095897          	auipc	a7,0x95
ffffffffc02024c8:	3e488893          	addi	a7,a7,996 # ffffffffc02978a8 <va_pa_offset>
ffffffffc02024cc:	0008b603          	ld	a2,0(a7)
ffffffffc02024d0:	01545793          	srli	a5,s0,0x15
ffffffffc02024d4:	1ff7f793          	andi	a5,a5,511
ffffffffc02024d8:	96b2                	add	a3,a3,a2
ffffffffc02024da:	078e                	slli	a5,a5,0x3
ffffffffc02024dc:	97b6                	add	a5,a5,a3
ffffffffc02024de:	6394                	ld	a3,0(a5)
ffffffffc02024e0:	0016f613          	andi	a2,a3,1
ffffffffc02024e4:	e659                	bnez	a2,ffffffffc0202572 <get_pte+0x17a>
ffffffffc02024e6:	0a080b63          	beqz	a6,ffffffffc020259c <get_pte+0x1a4>
ffffffffc02024ea:	10002773          	csrr	a4,sstatus
ffffffffc02024ee:	8b09                	andi	a4,a4,2
ffffffffc02024f0:	ef71                	bnez	a4,ffffffffc02025cc <get_pte+0x1d4>
ffffffffc02024f2:	00095717          	auipc	a4,0x95
ffffffffc02024f6:	39e73703          	ld	a4,926(a4) # ffffffffc0297890 <pmm_manager>
ffffffffc02024fa:	4505                	li	a0,1
ffffffffc02024fc:	e43e                	sd	a5,8(sp)
ffffffffc02024fe:	6f18                	ld	a4,24(a4)
ffffffffc0202500:	9702                	jalr	a4
ffffffffc0202502:	67a2                	ld	a5,8(sp)
ffffffffc0202504:	872a                	mv	a4,a0
ffffffffc0202506:	00095897          	auipc	a7,0x95
ffffffffc020250a:	3a288893          	addi	a7,a7,930 # ffffffffc02978a8 <va_pa_offset>
ffffffffc020250e:	c759                	beqz	a4,ffffffffc020259c <get_pte+0x1a4>
ffffffffc0202510:	00095697          	auipc	a3,0x95
ffffffffc0202514:	3a86b683          	ld	a3,936(a3) # ffffffffc02978b8 <pages>
ffffffffc0202518:	00080837          	lui	a6,0x80
ffffffffc020251c:	608c                	ld	a1,0(s1)
ffffffffc020251e:	40d706b3          	sub	a3,a4,a3
ffffffffc0202522:	8699                	srai	a3,a3,0x6
ffffffffc0202524:	96c2                	add	a3,a3,a6
ffffffffc0202526:	00c69613          	slli	a2,a3,0xc
ffffffffc020252a:	4505                	li	a0,1
ffffffffc020252c:	8231                	srli	a2,a2,0xc
ffffffffc020252e:	c308                	sw	a0,0(a4)
ffffffffc0202530:	06b2                	slli	a3,a3,0xc
ffffffffc0202532:	10b67663          	bgeu	a2,a1,ffffffffc020263e <get_pte+0x246>
ffffffffc0202536:	0008b503          	ld	a0,0(a7)
ffffffffc020253a:	6605                	lui	a2,0x1
ffffffffc020253c:	4581                	li	a1,0
ffffffffc020253e:	9536                	add	a0,a0,a3
ffffffffc0202540:	e83a                	sd	a4,16(sp)
ffffffffc0202542:	e43e                	sd	a5,8(sp)
ffffffffc0202544:	78c090ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0202548:	00095697          	auipc	a3,0x95
ffffffffc020254c:	3706b683          	ld	a3,880(a3) # ffffffffc02978b8 <pages>
ffffffffc0202550:	6742                	ld	a4,16(sp)
ffffffffc0202552:	00080837          	lui	a6,0x80
ffffffffc0202556:	67a2                	ld	a5,8(sp)
ffffffffc0202558:	40d706b3          	sub	a3,a4,a3
ffffffffc020255c:	8699                	srai	a3,a3,0x6
ffffffffc020255e:	96c2                	add	a3,a3,a6
ffffffffc0202560:	06aa                	slli	a3,a3,0xa
ffffffffc0202562:	0116e693          	ori	a3,a3,17
ffffffffc0202566:	e394                	sd	a3,0(a5)
ffffffffc0202568:	6098                	ld	a4,0(s1)
ffffffffc020256a:	00095897          	auipc	a7,0x95
ffffffffc020256e:	33e88893          	addi	a7,a7,830 # ffffffffc02978a8 <va_pa_offset>
ffffffffc0202572:	c006f693          	andi	a3,a3,-1024
ffffffffc0202576:	068a                	slli	a3,a3,0x2
ffffffffc0202578:	00c6d793          	srli	a5,a3,0xc
ffffffffc020257c:	06e7fc63          	bgeu	a5,a4,ffffffffc02025f4 <get_pte+0x1fc>
ffffffffc0202580:	0008b783          	ld	a5,0(a7)
ffffffffc0202584:	8031                	srli	s0,s0,0xc
ffffffffc0202586:	1ff47413          	andi	s0,s0,511
ffffffffc020258a:	040e                	slli	s0,s0,0x3
ffffffffc020258c:	96be                	add	a3,a3,a5
ffffffffc020258e:	70e2                	ld	ra,56(sp)
ffffffffc0202590:	00868533          	add	a0,a3,s0
ffffffffc0202594:	7442                	ld	s0,48(sp)
ffffffffc0202596:	74a2                	ld	s1,40(sp)
ffffffffc0202598:	6121                	addi	sp,sp,64
ffffffffc020259a:	8082                	ret
ffffffffc020259c:	70e2                	ld	ra,56(sp)
ffffffffc020259e:	7442                	ld	s0,48(sp)
ffffffffc02025a0:	74a2                	ld	s1,40(sp)
ffffffffc02025a2:	4501                	li	a0,0
ffffffffc02025a4:	6121                	addi	sp,sp,64
ffffffffc02025a6:	8082                	ret
ffffffffc02025a8:	e83a                	sd	a4,16(sp)
ffffffffc02025aa:	ec32                	sd	a2,24(sp)
ffffffffc02025ac:	ec4fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02025b0:	00095797          	auipc	a5,0x95
ffffffffc02025b4:	2e07b783          	ld	a5,736(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02025b8:	4505                	li	a0,1
ffffffffc02025ba:	6f9c                	ld	a5,24(a5)
ffffffffc02025bc:	9782                	jalr	a5
ffffffffc02025be:	e42a                	sd	a0,8(sp)
ffffffffc02025c0:	eaafe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02025c4:	6862                	ld	a6,24(sp)
ffffffffc02025c6:	6742                	ld	a4,16(sp)
ffffffffc02025c8:	67a2                	ld	a5,8(sp)
ffffffffc02025ca:	bdbd                	j	ffffffffc0202448 <get_pte+0x50>
ffffffffc02025cc:	e83e                	sd	a5,16(sp)
ffffffffc02025ce:	ea2fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02025d2:	00095717          	auipc	a4,0x95
ffffffffc02025d6:	2be73703          	ld	a4,702(a4) # ffffffffc0297890 <pmm_manager>
ffffffffc02025da:	4505                	li	a0,1
ffffffffc02025dc:	6f18                	ld	a4,24(a4)
ffffffffc02025de:	9702                	jalr	a4
ffffffffc02025e0:	e42a                	sd	a0,8(sp)
ffffffffc02025e2:	e88fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02025e6:	6722                	ld	a4,8(sp)
ffffffffc02025e8:	67c2                	ld	a5,16(sp)
ffffffffc02025ea:	00095897          	auipc	a7,0x95
ffffffffc02025ee:	2be88893          	addi	a7,a7,702 # ffffffffc02978a8 <va_pa_offset>
ffffffffc02025f2:	bf31                	j	ffffffffc020250e <get_pte+0x116>
ffffffffc02025f4:	0000a617          	auipc	a2,0xa
ffffffffc02025f8:	61c60613          	addi	a2,a2,1564 # ffffffffc020cc10 <etext+0xed8>
ffffffffc02025fc:	0f900593          	li	a1,249
ffffffffc0202600:	0000a517          	auipc	a0,0xa
ffffffffc0202604:	70050513          	addi	a0,a0,1792 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0202608:	e43fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020260c:	0000a617          	auipc	a2,0xa
ffffffffc0202610:	60460613          	addi	a2,a2,1540 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0202614:	0ec00593          	li	a1,236
ffffffffc0202618:	0000a517          	auipc	a0,0xa
ffffffffc020261c:	6e850513          	addi	a0,a0,1768 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0202620:	e2bfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202624:	86aa                	mv	a3,a0
ffffffffc0202626:	0000a617          	auipc	a2,0xa
ffffffffc020262a:	5ea60613          	addi	a2,a2,1514 # ffffffffc020cc10 <etext+0xed8>
ffffffffc020262e:	0e800593          	li	a1,232
ffffffffc0202632:	0000a517          	auipc	a0,0xa
ffffffffc0202636:	6ce50513          	addi	a0,a0,1742 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020263a:	e11fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020263e:	0000a617          	auipc	a2,0xa
ffffffffc0202642:	5d260613          	addi	a2,a2,1490 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0202646:	0f600593          	li	a1,246
ffffffffc020264a:	0000a517          	auipc	a0,0xa
ffffffffc020264e:	6b650513          	addi	a0,a0,1718 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0202652:	df9fd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202656 <get_page>:
ffffffffc0202656:	1141                	addi	sp,sp,-16
ffffffffc0202658:	e022                	sd	s0,0(sp)
ffffffffc020265a:	8432                	mv	s0,a2
ffffffffc020265c:	4601                	li	a2,0
ffffffffc020265e:	e406                	sd	ra,8(sp)
ffffffffc0202660:	d99ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202664:	c011                	beqz	s0,ffffffffc0202668 <get_page+0x12>
ffffffffc0202666:	e008                	sd	a0,0(s0)
ffffffffc0202668:	c511                	beqz	a0,ffffffffc0202674 <get_page+0x1e>
ffffffffc020266a:	611c                	ld	a5,0(a0)
ffffffffc020266c:	4501                	li	a0,0
ffffffffc020266e:	0017f713          	andi	a4,a5,1
ffffffffc0202672:	e709                	bnez	a4,ffffffffc020267c <get_page+0x26>
ffffffffc0202674:	60a2                	ld	ra,8(sp)
ffffffffc0202676:	6402                	ld	s0,0(sp)
ffffffffc0202678:	0141                	addi	sp,sp,16
ffffffffc020267a:	8082                	ret
ffffffffc020267c:	00095717          	auipc	a4,0x95
ffffffffc0202680:	23473703          	ld	a4,564(a4) # ffffffffc02978b0 <npage>
ffffffffc0202684:	078a                	slli	a5,a5,0x2
ffffffffc0202686:	83b1                	srli	a5,a5,0xc
ffffffffc0202688:	00e7ff63          	bgeu	a5,a4,ffffffffc02026a6 <get_page+0x50>
ffffffffc020268c:	00095517          	auipc	a0,0x95
ffffffffc0202690:	22c53503          	ld	a0,556(a0) # ffffffffc02978b8 <pages>
ffffffffc0202694:	60a2                	ld	ra,8(sp)
ffffffffc0202696:	6402                	ld	s0,0(sp)
ffffffffc0202698:	079a                	slli	a5,a5,0x6
ffffffffc020269a:	fe000737          	lui	a4,0xfe000
ffffffffc020269e:	97ba                	add	a5,a5,a4
ffffffffc02026a0:	953e                	add	a0,a0,a5
ffffffffc02026a2:	0141                	addi	sp,sp,16
ffffffffc02026a4:	8082                	ret
ffffffffc02026a6:	c8fff0ef          	jal	ffffffffc0202334 <pa2page.part.0>

ffffffffc02026aa <unmap_range>:
ffffffffc02026aa:	715d                	addi	sp,sp,-80
ffffffffc02026ac:	00c5e7b3          	or	a5,a1,a2
ffffffffc02026b0:	e486                	sd	ra,72(sp)
ffffffffc02026b2:	e0a2                	sd	s0,64(sp)
ffffffffc02026b4:	fc26                	sd	s1,56(sp)
ffffffffc02026b6:	f84a                	sd	s2,48(sp)
ffffffffc02026b8:	f44e                	sd	s3,40(sp)
ffffffffc02026ba:	f052                	sd	s4,32(sp)
ffffffffc02026bc:	ec56                	sd	s5,24(sp)
ffffffffc02026be:	03479713          	slli	a4,a5,0x34
ffffffffc02026c2:	ef61                	bnez	a4,ffffffffc020279a <unmap_range+0xf0>
ffffffffc02026c4:	00200a37          	lui	s4,0x200
ffffffffc02026c8:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc02026cc:	0145b733          	sltu	a4,a1,s4
ffffffffc02026d0:	0017b793          	seqz	a5,a5
ffffffffc02026d4:	8fd9                	or	a5,a5,a4
ffffffffc02026d6:	842e                	mv	s0,a1
ffffffffc02026d8:	84b2                	mv	s1,a2
ffffffffc02026da:	e3e5                	bnez	a5,ffffffffc02027ba <unmap_range+0x110>
ffffffffc02026dc:	4785                	li	a5,1
ffffffffc02026de:	07fe                	slli	a5,a5,0x1f
ffffffffc02026e0:	0785                	addi	a5,a5,1
ffffffffc02026e2:	892a                	mv	s2,a0
ffffffffc02026e4:	6985                	lui	s3,0x1
ffffffffc02026e6:	ffe00ab7          	lui	s5,0xffe00
ffffffffc02026ea:	0cf67863          	bgeu	a2,a5,ffffffffc02027ba <unmap_range+0x110>
ffffffffc02026ee:	4601                	li	a2,0
ffffffffc02026f0:	85a2                	mv	a1,s0
ffffffffc02026f2:	854a                	mv	a0,s2
ffffffffc02026f4:	d05ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc02026f8:	87aa                	mv	a5,a0
ffffffffc02026fa:	cd31                	beqz	a0,ffffffffc0202756 <unmap_range+0xac>
ffffffffc02026fc:	6118                	ld	a4,0(a0)
ffffffffc02026fe:	ef11                	bnez	a4,ffffffffc020271a <unmap_range+0x70>
ffffffffc0202700:	944e                	add	s0,s0,s3
ffffffffc0202702:	c019                	beqz	s0,ffffffffc0202708 <unmap_range+0x5e>
ffffffffc0202704:	fe9465e3          	bltu	s0,s1,ffffffffc02026ee <unmap_range+0x44>
ffffffffc0202708:	60a6                	ld	ra,72(sp)
ffffffffc020270a:	6406                	ld	s0,64(sp)
ffffffffc020270c:	74e2                	ld	s1,56(sp)
ffffffffc020270e:	7942                	ld	s2,48(sp)
ffffffffc0202710:	79a2                	ld	s3,40(sp)
ffffffffc0202712:	7a02                	ld	s4,32(sp)
ffffffffc0202714:	6ae2                	ld	s5,24(sp)
ffffffffc0202716:	6161                	addi	sp,sp,80
ffffffffc0202718:	8082                	ret
ffffffffc020271a:	00177693          	andi	a3,a4,1
ffffffffc020271e:	d2ed                	beqz	a3,ffffffffc0202700 <unmap_range+0x56>
ffffffffc0202720:	00095697          	auipc	a3,0x95
ffffffffc0202724:	1906b683          	ld	a3,400(a3) # ffffffffc02978b0 <npage>
ffffffffc0202728:	070a                	slli	a4,a4,0x2
ffffffffc020272a:	8331                	srli	a4,a4,0xc
ffffffffc020272c:	0ad77763          	bgeu	a4,a3,ffffffffc02027da <unmap_range+0x130>
ffffffffc0202730:	00095517          	auipc	a0,0x95
ffffffffc0202734:	18853503          	ld	a0,392(a0) # ffffffffc02978b8 <pages>
ffffffffc0202738:	071a                	slli	a4,a4,0x6
ffffffffc020273a:	fe0006b7          	lui	a3,0xfe000
ffffffffc020273e:	9736                	add	a4,a4,a3
ffffffffc0202740:	953a                	add	a0,a0,a4
ffffffffc0202742:	4118                	lw	a4,0(a0)
ffffffffc0202744:	377d                	addiw	a4,a4,-1 # fffffffffdffffff <end+0x3dd686e7>
ffffffffc0202746:	c118                	sw	a4,0(a0)
ffffffffc0202748:	cb19                	beqz	a4,ffffffffc020275e <unmap_range+0xb4>
ffffffffc020274a:	0007b023          	sd	zero,0(a5)
ffffffffc020274e:	12040073          	sfence.vma	s0
ffffffffc0202752:	944e                	add	s0,s0,s3
ffffffffc0202754:	b77d                	j	ffffffffc0202702 <unmap_range+0x58>
ffffffffc0202756:	9452                	add	s0,s0,s4
ffffffffc0202758:	01547433          	and	s0,s0,s5
ffffffffc020275c:	b75d                	j	ffffffffc0202702 <unmap_range+0x58>
ffffffffc020275e:	10002773          	csrr	a4,sstatus
ffffffffc0202762:	8b09                	andi	a4,a4,2
ffffffffc0202764:	eb19                	bnez	a4,ffffffffc020277a <unmap_range+0xd0>
ffffffffc0202766:	00095717          	auipc	a4,0x95
ffffffffc020276a:	12a73703          	ld	a4,298(a4) # ffffffffc0297890 <pmm_manager>
ffffffffc020276e:	4585                	li	a1,1
ffffffffc0202770:	e03e                	sd	a5,0(sp)
ffffffffc0202772:	7318                	ld	a4,32(a4)
ffffffffc0202774:	9702                	jalr	a4
ffffffffc0202776:	6782                	ld	a5,0(sp)
ffffffffc0202778:	bfc9                	j	ffffffffc020274a <unmap_range+0xa0>
ffffffffc020277a:	e43e                	sd	a5,8(sp)
ffffffffc020277c:	e02a                	sd	a0,0(sp)
ffffffffc020277e:	cf2fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202782:	00095717          	auipc	a4,0x95
ffffffffc0202786:	10e73703          	ld	a4,270(a4) # ffffffffc0297890 <pmm_manager>
ffffffffc020278a:	6502                	ld	a0,0(sp)
ffffffffc020278c:	4585                	li	a1,1
ffffffffc020278e:	7318                	ld	a4,32(a4)
ffffffffc0202790:	9702                	jalr	a4
ffffffffc0202792:	cd8fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202796:	67a2                	ld	a5,8(sp)
ffffffffc0202798:	bf4d                	j	ffffffffc020274a <unmap_range+0xa0>
ffffffffc020279a:	0000a697          	auipc	a3,0xa
ffffffffc020279e:	57668693          	addi	a3,a3,1398 # ffffffffc020cd10 <etext+0xfd8>
ffffffffc02027a2:	0000a617          	auipc	a2,0xa
ffffffffc02027a6:	9ce60613          	addi	a2,a2,-1586 # ffffffffc020c170 <etext+0x438>
ffffffffc02027aa:	12100593          	li	a1,289
ffffffffc02027ae:	0000a517          	auipc	a0,0xa
ffffffffc02027b2:	55250513          	addi	a0,a0,1362 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02027b6:	c95fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02027ba:	0000a697          	auipc	a3,0xa
ffffffffc02027be:	58668693          	addi	a3,a3,1414 # ffffffffc020cd40 <etext+0x1008>
ffffffffc02027c2:	0000a617          	auipc	a2,0xa
ffffffffc02027c6:	9ae60613          	addi	a2,a2,-1618 # ffffffffc020c170 <etext+0x438>
ffffffffc02027ca:	12200593          	li	a1,290
ffffffffc02027ce:	0000a517          	auipc	a0,0xa
ffffffffc02027d2:	53250513          	addi	a0,a0,1330 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02027d6:	c75fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02027da:	b5bff0ef          	jal	ffffffffc0202334 <pa2page.part.0>

ffffffffc02027de <exit_range>:
ffffffffc02027de:	7135                	addi	sp,sp,-160
ffffffffc02027e0:	00c5e7b3          	or	a5,a1,a2
ffffffffc02027e4:	ed06                	sd	ra,152(sp)
ffffffffc02027e6:	e922                	sd	s0,144(sp)
ffffffffc02027e8:	e526                	sd	s1,136(sp)
ffffffffc02027ea:	e14a                	sd	s2,128(sp)
ffffffffc02027ec:	fcce                	sd	s3,120(sp)
ffffffffc02027ee:	f8d2                	sd	s4,112(sp)
ffffffffc02027f0:	f4d6                	sd	s5,104(sp)
ffffffffc02027f2:	f0da                	sd	s6,96(sp)
ffffffffc02027f4:	ecde                	sd	s7,88(sp)
ffffffffc02027f6:	17d2                	slli	a5,a5,0x34
ffffffffc02027f8:	22079263          	bnez	a5,ffffffffc0202a1c <exit_range+0x23e>
ffffffffc02027fc:	00200937          	lui	s2,0x200
ffffffffc0202800:	00c5b7b3          	sltu	a5,a1,a2
ffffffffc0202804:	0125b733          	sltu	a4,a1,s2
ffffffffc0202808:	0017b793          	seqz	a5,a5
ffffffffc020280c:	8fd9                	or	a5,a5,a4
ffffffffc020280e:	26079263          	bnez	a5,ffffffffc0202a72 <exit_range+0x294>
ffffffffc0202812:	4785                	li	a5,1
ffffffffc0202814:	07fe                	slli	a5,a5,0x1f
ffffffffc0202816:	0785                	addi	a5,a5,1
ffffffffc0202818:	24f67d63          	bgeu	a2,a5,ffffffffc0202a72 <exit_range+0x294>
ffffffffc020281c:	c00004b7          	lui	s1,0xc0000
ffffffffc0202820:	ffe007b7          	lui	a5,0xffe00
ffffffffc0202824:	8a2a                	mv	s4,a0
ffffffffc0202826:	8ced                	and	s1,s1,a1
ffffffffc0202828:	00f5f833          	and	a6,a1,a5
ffffffffc020282c:	00095a97          	auipc	s5,0x95
ffffffffc0202830:	084a8a93          	addi	s5,s5,132 # ffffffffc02978b0 <npage>
ffffffffc0202834:	400009b7          	lui	s3,0x40000
ffffffffc0202838:	a809                	j	ffffffffc020284a <exit_range+0x6c>
ffffffffc020283a:	013487b3          	add	a5,s1,s3
ffffffffc020283e:	400004b7          	lui	s1,0x40000
ffffffffc0202842:	8826                	mv	a6,s1
ffffffffc0202844:	c3f1                	beqz	a5,ffffffffc0202908 <exit_range+0x12a>
ffffffffc0202846:	0cc7f163          	bgeu	a5,a2,ffffffffc0202908 <exit_range+0x12a>
ffffffffc020284a:	01e4d413          	srli	s0,s1,0x1e
ffffffffc020284e:	1ff47413          	andi	s0,s0,511
ffffffffc0202852:	040e                	slli	s0,s0,0x3
ffffffffc0202854:	9452                	add	s0,s0,s4
ffffffffc0202856:	00043883          	ld	a7,0(s0)
ffffffffc020285a:	0018f793          	andi	a5,a7,1
ffffffffc020285e:	dff1                	beqz	a5,ffffffffc020283a <exit_range+0x5c>
ffffffffc0202860:	000ab783          	ld	a5,0(s5)
ffffffffc0202864:	088a                	slli	a7,a7,0x2
ffffffffc0202866:	00c8d893          	srli	a7,a7,0xc
ffffffffc020286a:	20f8f263          	bgeu	a7,a5,ffffffffc0202a6e <exit_range+0x290>
ffffffffc020286e:	fff802b7          	lui	t0,0xfff80
ffffffffc0202872:	00588f33          	add	t5,a7,t0
ffffffffc0202876:	000803b7          	lui	t2,0x80
ffffffffc020287a:	007f0733          	add	a4,t5,t2
ffffffffc020287e:	00c71e13          	slli	t3,a4,0xc
ffffffffc0202882:	0f1a                	slli	t5,t5,0x6
ffffffffc0202884:	1cf77863          	bgeu	a4,a5,ffffffffc0202a54 <exit_range+0x276>
ffffffffc0202888:	00095f97          	auipc	t6,0x95
ffffffffc020288c:	020f8f93          	addi	t6,t6,32 # ffffffffc02978a8 <va_pa_offset>
ffffffffc0202890:	000fb783          	ld	a5,0(t6)
ffffffffc0202894:	4e85                	li	t4,1
ffffffffc0202896:	6b05                	lui	s6,0x1
ffffffffc0202898:	9e3e                	add	t3,t3,a5
ffffffffc020289a:	01348333          	add	t1,s1,s3
ffffffffc020289e:	01585713          	srli	a4,a6,0x15
ffffffffc02028a2:	1ff77713          	andi	a4,a4,511
ffffffffc02028a6:	070e                	slli	a4,a4,0x3
ffffffffc02028a8:	9772                	add	a4,a4,t3
ffffffffc02028aa:	631c                	ld	a5,0(a4)
ffffffffc02028ac:	0017f693          	andi	a3,a5,1
ffffffffc02028b0:	e6bd                	bnez	a3,ffffffffc020291e <exit_range+0x140>
ffffffffc02028b2:	4e81                	li	t4,0
ffffffffc02028b4:	984a                	add	a6,a6,s2
ffffffffc02028b6:	00080863          	beqz	a6,ffffffffc02028c6 <exit_range+0xe8>
ffffffffc02028ba:	879a                	mv	a5,t1
ffffffffc02028bc:	00667363          	bgeu	a2,t1,ffffffffc02028c2 <exit_range+0xe4>
ffffffffc02028c0:	87b2                	mv	a5,a2
ffffffffc02028c2:	fcf86ee3          	bltu	a6,a5,ffffffffc020289e <exit_range+0xc0>
ffffffffc02028c6:	f60e8ae3          	beqz	t4,ffffffffc020283a <exit_range+0x5c>
ffffffffc02028ca:	000ab783          	ld	a5,0(s5)
ffffffffc02028ce:	1af8f063          	bgeu	a7,a5,ffffffffc0202a6e <exit_range+0x290>
ffffffffc02028d2:	00095517          	auipc	a0,0x95
ffffffffc02028d6:	fe653503          	ld	a0,-26(a0) # ffffffffc02978b8 <pages>
ffffffffc02028da:	957a                	add	a0,a0,t5
ffffffffc02028dc:	100027f3          	csrr	a5,sstatus
ffffffffc02028e0:	8b89                	andi	a5,a5,2
ffffffffc02028e2:	10079b63          	bnez	a5,ffffffffc02029f8 <exit_range+0x21a>
ffffffffc02028e6:	00095797          	auipc	a5,0x95
ffffffffc02028ea:	faa7b783          	ld	a5,-86(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02028ee:	4585                	li	a1,1
ffffffffc02028f0:	e432                	sd	a2,8(sp)
ffffffffc02028f2:	739c                	ld	a5,32(a5)
ffffffffc02028f4:	9782                	jalr	a5
ffffffffc02028f6:	6622                	ld	a2,8(sp)
ffffffffc02028f8:	00043023          	sd	zero,0(s0)
ffffffffc02028fc:	013487b3          	add	a5,s1,s3
ffffffffc0202900:	400004b7          	lui	s1,0x40000
ffffffffc0202904:	8826                	mv	a6,s1
ffffffffc0202906:	f3a1                	bnez	a5,ffffffffc0202846 <exit_range+0x68>
ffffffffc0202908:	60ea                	ld	ra,152(sp)
ffffffffc020290a:	644a                	ld	s0,144(sp)
ffffffffc020290c:	64aa                	ld	s1,136(sp)
ffffffffc020290e:	690a                	ld	s2,128(sp)
ffffffffc0202910:	79e6                	ld	s3,120(sp)
ffffffffc0202912:	7a46                	ld	s4,112(sp)
ffffffffc0202914:	7aa6                	ld	s5,104(sp)
ffffffffc0202916:	7b06                	ld	s6,96(sp)
ffffffffc0202918:	6be6                	ld	s7,88(sp)
ffffffffc020291a:	610d                	addi	sp,sp,160
ffffffffc020291c:	8082                	ret
ffffffffc020291e:	000ab503          	ld	a0,0(s5)
ffffffffc0202922:	078a                	slli	a5,a5,0x2
ffffffffc0202924:	83b1                	srli	a5,a5,0xc
ffffffffc0202926:	14a7f463          	bgeu	a5,a0,ffffffffc0202a6e <exit_range+0x290>
ffffffffc020292a:	9796                	add	a5,a5,t0
ffffffffc020292c:	00778bb3          	add	s7,a5,t2
ffffffffc0202930:	00679593          	slli	a1,a5,0x6
ffffffffc0202934:	00cb9693          	slli	a3,s7,0xc
ffffffffc0202938:	10abf263          	bgeu	s7,a0,ffffffffc0202a3c <exit_range+0x25e>
ffffffffc020293c:	000fb783          	ld	a5,0(t6)
ffffffffc0202940:	96be                	add	a3,a3,a5
ffffffffc0202942:	01668533          	add	a0,a3,s6
ffffffffc0202946:	629c                	ld	a5,0(a3)
ffffffffc0202948:	8b85                	andi	a5,a5,1
ffffffffc020294a:	f7ad                	bnez	a5,ffffffffc02028b4 <exit_range+0xd6>
ffffffffc020294c:	06a1                	addi	a3,a3,8
ffffffffc020294e:	fea69ce3          	bne	a3,a0,ffffffffc0202946 <exit_range+0x168>
ffffffffc0202952:	00095517          	auipc	a0,0x95
ffffffffc0202956:	f6653503          	ld	a0,-154(a0) # ffffffffc02978b8 <pages>
ffffffffc020295a:	952e                	add	a0,a0,a1
ffffffffc020295c:	100027f3          	csrr	a5,sstatus
ffffffffc0202960:	8b89                	andi	a5,a5,2
ffffffffc0202962:	e3b9                	bnez	a5,ffffffffc02029a8 <exit_range+0x1ca>
ffffffffc0202964:	00095797          	auipc	a5,0x95
ffffffffc0202968:	f2c7b783          	ld	a5,-212(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc020296c:	4585                	li	a1,1
ffffffffc020296e:	e0b2                	sd	a2,64(sp)
ffffffffc0202970:	739c                	ld	a5,32(a5)
ffffffffc0202972:	fc1a                	sd	t1,56(sp)
ffffffffc0202974:	f846                	sd	a7,48(sp)
ffffffffc0202976:	f47a                	sd	t5,40(sp)
ffffffffc0202978:	f072                	sd	t3,32(sp)
ffffffffc020297a:	ec76                	sd	t4,24(sp)
ffffffffc020297c:	e842                	sd	a6,16(sp)
ffffffffc020297e:	e43a                	sd	a4,8(sp)
ffffffffc0202980:	9782                	jalr	a5
ffffffffc0202982:	6722                	ld	a4,8(sp)
ffffffffc0202984:	6842                	ld	a6,16(sp)
ffffffffc0202986:	6ee2                	ld	t4,24(sp)
ffffffffc0202988:	7e02                	ld	t3,32(sp)
ffffffffc020298a:	7f22                	ld	t5,40(sp)
ffffffffc020298c:	78c2                	ld	a7,48(sp)
ffffffffc020298e:	7362                	ld	t1,56(sp)
ffffffffc0202990:	6606                	ld	a2,64(sp)
ffffffffc0202992:	fff802b7          	lui	t0,0xfff80
ffffffffc0202996:	000803b7          	lui	t2,0x80
ffffffffc020299a:	00095f97          	auipc	t6,0x95
ffffffffc020299e:	f0ef8f93          	addi	t6,t6,-242 # ffffffffc02978a8 <va_pa_offset>
ffffffffc02029a2:	00073023          	sd	zero,0(a4)
ffffffffc02029a6:	b739                	j	ffffffffc02028b4 <exit_range+0xd6>
ffffffffc02029a8:	e4b2                	sd	a2,72(sp)
ffffffffc02029aa:	e09a                	sd	t1,64(sp)
ffffffffc02029ac:	fc46                	sd	a7,56(sp)
ffffffffc02029ae:	f47a                	sd	t5,40(sp)
ffffffffc02029b0:	f072                	sd	t3,32(sp)
ffffffffc02029b2:	ec76                	sd	t4,24(sp)
ffffffffc02029b4:	e842                	sd	a6,16(sp)
ffffffffc02029b6:	e43a                	sd	a4,8(sp)
ffffffffc02029b8:	f82a                	sd	a0,48(sp)
ffffffffc02029ba:	ab6fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02029be:	00095797          	auipc	a5,0x95
ffffffffc02029c2:	ed27b783          	ld	a5,-302(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02029c6:	7542                	ld	a0,48(sp)
ffffffffc02029c8:	4585                	li	a1,1
ffffffffc02029ca:	739c                	ld	a5,32(a5)
ffffffffc02029cc:	9782                	jalr	a5
ffffffffc02029ce:	a9cfe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02029d2:	6722                	ld	a4,8(sp)
ffffffffc02029d4:	6626                	ld	a2,72(sp)
ffffffffc02029d6:	6306                	ld	t1,64(sp)
ffffffffc02029d8:	78e2                	ld	a7,56(sp)
ffffffffc02029da:	7f22                	ld	t5,40(sp)
ffffffffc02029dc:	7e02                	ld	t3,32(sp)
ffffffffc02029de:	6ee2                	ld	t4,24(sp)
ffffffffc02029e0:	6842                	ld	a6,16(sp)
ffffffffc02029e2:	00095f97          	auipc	t6,0x95
ffffffffc02029e6:	ec6f8f93          	addi	t6,t6,-314 # ffffffffc02978a8 <va_pa_offset>
ffffffffc02029ea:	000803b7          	lui	t2,0x80
ffffffffc02029ee:	fff802b7          	lui	t0,0xfff80
ffffffffc02029f2:	00073023          	sd	zero,0(a4)
ffffffffc02029f6:	bd7d                	j	ffffffffc02028b4 <exit_range+0xd6>
ffffffffc02029f8:	e832                	sd	a2,16(sp)
ffffffffc02029fa:	e42a                	sd	a0,8(sp)
ffffffffc02029fc:	a74fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202a00:	00095797          	auipc	a5,0x95
ffffffffc0202a04:	e907b783          	ld	a5,-368(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0202a08:	6522                	ld	a0,8(sp)
ffffffffc0202a0a:	4585                	li	a1,1
ffffffffc0202a0c:	739c                	ld	a5,32(a5)
ffffffffc0202a0e:	9782                	jalr	a5
ffffffffc0202a10:	a5afe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202a14:	6642                	ld	a2,16(sp)
ffffffffc0202a16:	00043023          	sd	zero,0(s0)
ffffffffc0202a1a:	b5cd                	j	ffffffffc02028fc <exit_range+0x11e>
ffffffffc0202a1c:	0000a697          	auipc	a3,0xa
ffffffffc0202a20:	2f468693          	addi	a3,a3,756 # ffffffffc020cd10 <etext+0xfd8>
ffffffffc0202a24:	00009617          	auipc	a2,0x9
ffffffffc0202a28:	74c60613          	addi	a2,a2,1868 # ffffffffc020c170 <etext+0x438>
ffffffffc0202a2c:	13600593          	li	a1,310
ffffffffc0202a30:	0000a517          	auipc	a0,0xa
ffffffffc0202a34:	2d050513          	addi	a0,a0,720 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0202a38:	a13fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202a3c:	0000a617          	auipc	a2,0xa
ffffffffc0202a40:	1d460613          	addi	a2,a2,468 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0202a44:	07100593          	li	a1,113
ffffffffc0202a48:	0000a517          	auipc	a0,0xa
ffffffffc0202a4c:	1f050513          	addi	a0,a0,496 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0202a50:	9fbfd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202a54:	86f2                	mv	a3,t3
ffffffffc0202a56:	0000a617          	auipc	a2,0xa
ffffffffc0202a5a:	1ba60613          	addi	a2,a2,442 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0202a5e:	07100593          	li	a1,113
ffffffffc0202a62:	0000a517          	auipc	a0,0xa
ffffffffc0202a66:	1d650513          	addi	a0,a0,470 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0202a6a:	9e1fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0202a6e:	8c7ff0ef          	jal	ffffffffc0202334 <pa2page.part.0>
ffffffffc0202a72:	0000a697          	auipc	a3,0xa
ffffffffc0202a76:	2ce68693          	addi	a3,a3,718 # ffffffffc020cd40 <etext+0x1008>
ffffffffc0202a7a:	00009617          	auipc	a2,0x9
ffffffffc0202a7e:	6f660613          	addi	a2,a2,1782 # ffffffffc020c170 <etext+0x438>
ffffffffc0202a82:	13700593          	li	a1,311
ffffffffc0202a86:	0000a517          	auipc	a0,0xa
ffffffffc0202a8a:	27a50513          	addi	a0,a0,634 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0202a8e:	9bdfd0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0202a92 <page_remove>:
ffffffffc0202a92:	1101                	addi	sp,sp,-32
ffffffffc0202a94:	4601                	li	a2,0
ffffffffc0202a96:	e822                	sd	s0,16(sp)
ffffffffc0202a98:	ec06                	sd	ra,24(sp)
ffffffffc0202a9a:	842e                	mv	s0,a1
ffffffffc0202a9c:	95dff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202aa0:	c511                	beqz	a0,ffffffffc0202aac <page_remove+0x1a>
ffffffffc0202aa2:	6118                	ld	a4,0(a0)
ffffffffc0202aa4:	87aa                	mv	a5,a0
ffffffffc0202aa6:	00177693          	andi	a3,a4,1
ffffffffc0202aaa:	e689                	bnez	a3,ffffffffc0202ab4 <page_remove+0x22>
ffffffffc0202aac:	60e2                	ld	ra,24(sp)
ffffffffc0202aae:	6442                	ld	s0,16(sp)
ffffffffc0202ab0:	6105                	addi	sp,sp,32
ffffffffc0202ab2:	8082                	ret
ffffffffc0202ab4:	00095697          	auipc	a3,0x95
ffffffffc0202ab8:	dfc6b683          	ld	a3,-516(a3) # ffffffffc02978b0 <npage>
ffffffffc0202abc:	070a                	slli	a4,a4,0x2
ffffffffc0202abe:	8331                	srli	a4,a4,0xc
ffffffffc0202ac0:	06d77563          	bgeu	a4,a3,ffffffffc0202b2a <page_remove+0x98>
ffffffffc0202ac4:	00095517          	auipc	a0,0x95
ffffffffc0202ac8:	df453503          	ld	a0,-524(a0) # ffffffffc02978b8 <pages>
ffffffffc0202acc:	071a                	slli	a4,a4,0x6
ffffffffc0202ace:	fe0006b7          	lui	a3,0xfe000
ffffffffc0202ad2:	9736                	add	a4,a4,a3
ffffffffc0202ad4:	953a                	add	a0,a0,a4
ffffffffc0202ad6:	4118                	lw	a4,0(a0)
ffffffffc0202ad8:	377d                	addiw	a4,a4,-1
ffffffffc0202ada:	c118                	sw	a4,0(a0)
ffffffffc0202adc:	cb09                	beqz	a4,ffffffffc0202aee <page_remove+0x5c>
ffffffffc0202ade:	0007b023          	sd	zero,0(a5)
ffffffffc0202ae2:	12040073          	sfence.vma	s0
ffffffffc0202ae6:	60e2                	ld	ra,24(sp)
ffffffffc0202ae8:	6442                	ld	s0,16(sp)
ffffffffc0202aea:	6105                	addi	sp,sp,32
ffffffffc0202aec:	8082                	ret
ffffffffc0202aee:	10002773          	csrr	a4,sstatus
ffffffffc0202af2:	8b09                	andi	a4,a4,2
ffffffffc0202af4:	eb19                	bnez	a4,ffffffffc0202b0a <page_remove+0x78>
ffffffffc0202af6:	00095717          	auipc	a4,0x95
ffffffffc0202afa:	d9a73703          	ld	a4,-614(a4) # ffffffffc0297890 <pmm_manager>
ffffffffc0202afe:	4585                	li	a1,1
ffffffffc0202b00:	e03e                	sd	a5,0(sp)
ffffffffc0202b02:	7318                	ld	a4,32(a4)
ffffffffc0202b04:	9702                	jalr	a4
ffffffffc0202b06:	6782                	ld	a5,0(sp)
ffffffffc0202b08:	bfd9                	j	ffffffffc0202ade <page_remove+0x4c>
ffffffffc0202b0a:	e43e                	sd	a5,8(sp)
ffffffffc0202b0c:	e02a                	sd	a0,0(sp)
ffffffffc0202b0e:	962fe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202b12:	00095717          	auipc	a4,0x95
ffffffffc0202b16:	d7e73703          	ld	a4,-642(a4) # ffffffffc0297890 <pmm_manager>
ffffffffc0202b1a:	6502                	ld	a0,0(sp)
ffffffffc0202b1c:	4585                	li	a1,1
ffffffffc0202b1e:	7318                	ld	a4,32(a4)
ffffffffc0202b20:	9702                	jalr	a4
ffffffffc0202b22:	948fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202b26:	67a2                	ld	a5,8(sp)
ffffffffc0202b28:	bf5d                	j	ffffffffc0202ade <page_remove+0x4c>
ffffffffc0202b2a:	80bff0ef          	jal	ffffffffc0202334 <pa2page.part.0>

ffffffffc0202b2e <page_insert>:
ffffffffc0202b2e:	7139                	addi	sp,sp,-64
ffffffffc0202b30:	f426                	sd	s1,40(sp)
ffffffffc0202b32:	84b2                	mv	s1,a2
ffffffffc0202b34:	f822                	sd	s0,48(sp)
ffffffffc0202b36:	4605                	li	a2,1
ffffffffc0202b38:	842e                	mv	s0,a1
ffffffffc0202b3a:	85a6                	mv	a1,s1
ffffffffc0202b3c:	fc06                	sd	ra,56(sp)
ffffffffc0202b3e:	e436                	sd	a3,8(sp)
ffffffffc0202b40:	8b9ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202b44:	cd61                	beqz	a0,ffffffffc0202c1c <page_insert+0xee>
ffffffffc0202b46:	400c                	lw	a1,0(s0)
ffffffffc0202b48:	611c                	ld	a5,0(a0)
ffffffffc0202b4a:	66a2                	ld	a3,8(sp)
ffffffffc0202b4c:	0015861b          	addiw	a2,a1,1 # 1001 <_binary_bin_swap_img_size-0x6cff>
ffffffffc0202b50:	c010                	sw	a2,0(s0)
ffffffffc0202b52:	0017f613          	andi	a2,a5,1
ffffffffc0202b56:	872a                	mv	a4,a0
ffffffffc0202b58:	e61d                	bnez	a2,ffffffffc0202b86 <page_insert+0x58>
ffffffffc0202b5a:	00095617          	auipc	a2,0x95
ffffffffc0202b5e:	d5e63603          	ld	a2,-674(a2) # ffffffffc02978b8 <pages>
ffffffffc0202b62:	8c11                	sub	s0,s0,a2
ffffffffc0202b64:	8419                	srai	s0,s0,0x6
ffffffffc0202b66:	200007b7          	lui	a5,0x20000
ffffffffc0202b6a:	042a                	slli	s0,s0,0xa
ffffffffc0202b6c:	943e                	add	s0,s0,a5
ffffffffc0202b6e:	8ec1                	or	a3,a3,s0
ffffffffc0202b70:	0016e693          	ori	a3,a3,1
ffffffffc0202b74:	e314                	sd	a3,0(a4)
ffffffffc0202b76:	12048073          	sfence.vma	s1
ffffffffc0202b7a:	4501                	li	a0,0
ffffffffc0202b7c:	70e2                	ld	ra,56(sp)
ffffffffc0202b7e:	7442                	ld	s0,48(sp)
ffffffffc0202b80:	74a2                	ld	s1,40(sp)
ffffffffc0202b82:	6121                	addi	sp,sp,64
ffffffffc0202b84:	8082                	ret
ffffffffc0202b86:	00095617          	auipc	a2,0x95
ffffffffc0202b8a:	d2a63603          	ld	a2,-726(a2) # ffffffffc02978b0 <npage>
ffffffffc0202b8e:	078a                	slli	a5,a5,0x2
ffffffffc0202b90:	83b1                	srli	a5,a5,0xc
ffffffffc0202b92:	08c7f763          	bgeu	a5,a2,ffffffffc0202c20 <page_insert+0xf2>
ffffffffc0202b96:	00095617          	auipc	a2,0x95
ffffffffc0202b9a:	d2263603          	ld	a2,-734(a2) # ffffffffc02978b8 <pages>
ffffffffc0202b9e:	fe000537          	lui	a0,0xfe000
ffffffffc0202ba2:	079a                	slli	a5,a5,0x6
ffffffffc0202ba4:	97aa                	add	a5,a5,a0
ffffffffc0202ba6:	00f60533          	add	a0,a2,a5
ffffffffc0202baa:	00a40963          	beq	s0,a0,ffffffffc0202bbc <page_insert+0x8e>
ffffffffc0202bae:	411c                	lw	a5,0(a0)
ffffffffc0202bb0:	37fd                	addiw	a5,a5,-1 # 1fffffff <_binary_bin_sfs_img_size+0x1ff8acff>
ffffffffc0202bb2:	c11c                	sw	a5,0(a0)
ffffffffc0202bb4:	c791                	beqz	a5,ffffffffc0202bc0 <page_insert+0x92>
ffffffffc0202bb6:	12048073          	sfence.vma	s1
ffffffffc0202bba:	b765                	j	ffffffffc0202b62 <page_insert+0x34>
ffffffffc0202bbc:	c00c                	sw	a1,0(s0)
ffffffffc0202bbe:	b755                	j	ffffffffc0202b62 <page_insert+0x34>
ffffffffc0202bc0:	100027f3          	csrr	a5,sstatus
ffffffffc0202bc4:	8b89                	andi	a5,a5,2
ffffffffc0202bc6:	e39d                	bnez	a5,ffffffffc0202bec <page_insert+0xbe>
ffffffffc0202bc8:	00095797          	auipc	a5,0x95
ffffffffc0202bcc:	cc87b783          	ld	a5,-824(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0202bd0:	4585                	li	a1,1
ffffffffc0202bd2:	e83a                	sd	a4,16(sp)
ffffffffc0202bd4:	739c                	ld	a5,32(a5)
ffffffffc0202bd6:	e436                	sd	a3,8(sp)
ffffffffc0202bd8:	9782                	jalr	a5
ffffffffc0202bda:	00095617          	auipc	a2,0x95
ffffffffc0202bde:	cde63603          	ld	a2,-802(a2) # ffffffffc02978b8 <pages>
ffffffffc0202be2:	66a2                	ld	a3,8(sp)
ffffffffc0202be4:	6742                	ld	a4,16(sp)
ffffffffc0202be6:	12048073          	sfence.vma	s1
ffffffffc0202bea:	bfa5                	j	ffffffffc0202b62 <page_insert+0x34>
ffffffffc0202bec:	ec3a                	sd	a4,24(sp)
ffffffffc0202bee:	e836                	sd	a3,16(sp)
ffffffffc0202bf0:	e42a                	sd	a0,8(sp)
ffffffffc0202bf2:	87efe0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0202bf6:	00095797          	auipc	a5,0x95
ffffffffc0202bfa:	c9a7b783          	ld	a5,-870(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0202bfe:	6522                	ld	a0,8(sp)
ffffffffc0202c00:	4585                	li	a1,1
ffffffffc0202c02:	739c                	ld	a5,32(a5)
ffffffffc0202c04:	9782                	jalr	a5
ffffffffc0202c06:	864fe0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0202c0a:	00095617          	auipc	a2,0x95
ffffffffc0202c0e:	cae63603          	ld	a2,-850(a2) # ffffffffc02978b8 <pages>
ffffffffc0202c12:	6762                	ld	a4,24(sp)
ffffffffc0202c14:	66c2                	ld	a3,16(sp)
ffffffffc0202c16:	12048073          	sfence.vma	s1
ffffffffc0202c1a:	b7a1                	j	ffffffffc0202b62 <page_insert+0x34>
ffffffffc0202c1c:	5571                	li	a0,-4
ffffffffc0202c1e:	bfb9                	j	ffffffffc0202b7c <page_insert+0x4e>
ffffffffc0202c20:	f14ff0ef          	jal	ffffffffc0202334 <pa2page.part.0>

ffffffffc0202c24 <pmm_init>:
ffffffffc0202c24:	0000c797          	auipc	a5,0xc
ffffffffc0202c28:	7fc78793          	addi	a5,a5,2044 # ffffffffc020f420 <default_pmm_manager>
ffffffffc0202c2c:	638c                	ld	a1,0(a5)
ffffffffc0202c2e:	7159                	addi	sp,sp,-112
ffffffffc0202c30:	f486                	sd	ra,104(sp)
ffffffffc0202c32:	e8ca                	sd	s2,80(sp)
ffffffffc0202c34:	e4ce                	sd	s3,72(sp)
ffffffffc0202c36:	f85a                	sd	s6,48(sp)
ffffffffc0202c38:	f0a2                	sd	s0,96(sp)
ffffffffc0202c3a:	eca6                	sd	s1,88(sp)
ffffffffc0202c3c:	e0d2                	sd	s4,64(sp)
ffffffffc0202c3e:	fc56                	sd	s5,56(sp)
ffffffffc0202c40:	f45e                	sd	s7,40(sp)
ffffffffc0202c42:	f062                	sd	s8,32(sp)
ffffffffc0202c44:	ec66                	sd	s9,24(sp)
ffffffffc0202c46:	00095b17          	auipc	s6,0x95
ffffffffc0202c4a:	c4ab0b13          	addi	s6,s6,-950 # ffffffffc0297890 <pmm_manager>
ffffffffc0202c4e:	0000a517          	auipc	a0,0xa
ffffffffc0202c52:	10a50513          	addi	a0,a0,266 # ffffffffc020cd58 <etext+0x1020>
ffffffffc0202c56:	00fb3023          	sd	a5,0(s6)
ffffffffc0202c5a:	d4cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c5e:	000b3783          	ld	a5,0(s6)
ffffffffc0202c62:	00095997          	auipc	s3,0x95
ffffffffc0202c66:	c4698993          	addi	s3,s3,-954 # ffffffffc02978a8 <va_pa_offset>
ffffffffc0202c6a:	679c                	ld	a5,8(a5)
ffffffffc0202c6c:	9782                	jalr	a5
ffffffffc0202c6e:	57f5                	li	a5,-3
ffffffffc0202c70:	07fa                	slli	a5,a5,0x1e
ffffffffc0202c72:	00f9b023          	sd	a5,0(s3)
ffffffffc0202c76:	dcbfd0ef          	jal	ffffffffc0200a40 <get_memory_base>
ffffffffc0202c7a:	892a                	mv	s2,a0
ffffffffc0202c7c:	dcffd0ef          	jal	ffffffffc0200a4a <get_memory_size>
ffffffffc0202c80:	70050e63          	beqz	a0,ffffffffc020339c <pmm_init+0x778>
ffffffffc0202c84:	84aa                	mv	s1,a0
ffffffffc0202c86:	0000a517          	auipc	a0,0xa
ffffffffc0202c8a:	10a50513          	addi	a0,a0,266 # ffffffffc020cd90 <etext+0x1058>
ffffffffc0202c8e:	d18fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202c92:	00990433          	add	s0,s2,s1
ffffffffc0202c96:	864a                	mv	a2,s2
ffffffffc0202c98:	85a6                	mv	a1,s1
ffffffffc0202c9a:	fff40693          	addi	a3,s0,-1
ffffffffc0202c9e:	0000a517          	auipc	a0,0xa
ffffffffc0202ca2:	10a50513          	addi	a0,a0,266 # ffffffffc020cda8 <etext+0x1070>
ffffffffc0202ca6:	d00fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202caa:	c80007b7          	lui	a5,0xc8000
ffffffffc0202cae:	8522                	mv	a0,s0
ffffffffc0202cb0:	5287ed63          	bltu	a5,s0,ffffffffc02031ea <pmm_init+0x5c6>
ffffffffc0202cb4:	77fd                	lui	a5,0xfffff
ffffffffc0202cb6:	00096617          	auipc	a2,0x96
ffffffffc0202cba:	c6160613          	addi	a2,a2,-927 # ffffffffc0298917 <end+0xfff>
ffffffffc0202cbe:	8e7d                	and	a2,a2,a5
ffffffffc0202cc0:	8131                	srli	a0,a0,0xc
ffffffffc0202cc2:	00095b97          	auipc	s7,0x95
ffffffffc0202cc6:	bf6b8b93          	addi	s7,s7,-1034 # ffffffffc02978b8 <pages>
ffffffffc0202cca:	00095497          	auipc	s1,0x95
ffffffffc0202cce:	be648493          	addi	s1,s1,-1050 # ffffffffc02978b0 <npage>
ffffffffc0202cd2:	00cbb023          	sd	a2,0(s7)
ffffffffc0202cd6:	e088                	sd	a0,0(s1)
ffffffffc0202cd8:	000807b7          	lui	a5,0x80
ffffffffc0202cdc:	86b2                	mv	a3,a2
ffffffffc0202cde:	02f50763          	beq	a0,a5,ffffffffc0202d0c <pmm_init+0xe8>
ffffffffc0202ce2:	4701                	li	a4,0
ffffffffc0202ce4:	4585                	li	a1,1
ffffffffc0202ce6:	fff806b7          	lui	a3,0xfff80
ffffffffc0202cea:	00671793          	slli	a5,a4,0x6
ffffffffc0202cee:	97b2                	add	a5,a5,a2
ffffffffc0202cf0:	07a1                	addi	a5,a5,8 # 80008 <_binary_bin_sfs_img_size+0xad08>
ffffffffc0202cf2:	40b7b02f          	amoor.d	zero,a1,(a5)
ffffffffc0202cf6:	6088                	ld	a0,0(s1)
ffffffffc0202cf8:	0705                	addi	a4,a4,1
ffffffffc0202cfa:	000bb603          	ld	a2,0(s7)
ffffffffc0202cfe:	00d507b3          	add	a5,a0,a3
ffffffffc0202d02:	fef764e3          	bltu	a4,a5,ffffffffc0202cea <pmm_init+0xc6>
ffffffffc0202d06:	079a                	slli	a5,a5,0x6
ffffffffc0202d08:	00f606b3          	add	a3,a2,a5
ffffffffc0202d0c:	c02007b7          	lui	a5,0xc0200
ffffffffc0202d10:	16f6eee3          	bltu	a3,a5,ffffffffc020368c <pmm_init+0xa68>
ffffffffc0202d14:	0009b583          	ld	a1,0(s3)
ffffffffc0202d18:	77fd                	lui	a5,0xfffff
ffffffffc0202d1a:	8c7d                	and	s0,s0,a5
ffffffffc0202d1c:	8e8d                	sub	a3,a3,a1
ffffffffc0202d1e:	4e86ed63          	bltu	a3,s0,ffffffffc0203218 <pmm_init+0x5f4>
ffffffffc0202d22:	0000a517          	auipc	a0,0xa
ffffffffc0202d26:	0ae50513          	addi	a0,a0,174 # ffffffffc020cdd0 <etext+0x1098>
ffffffffc0202d2a:	c7cfd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202d2e:	000b3783          	ld	a5,0(s6)
ffffffffc0202d32:	00095917          	auipc	s2,0x95
ffffffffc0202d36:	b6e90913          	addi	s2,s2,-1170 # ffffffffc02978a0 <boot_pgdir_va>
ffffffffc0202d3a:	7b9c                	ld	a5,48(a5)
ffffffffc0202d3c:	9782                	jalr	a5
ffffffffc0202d3e:	0000a517          	auipc	a0,0xa
ffffffffc0202d42:	0aa50513          	addi	a0,a0,170 # ffffffffc020cde8 <etext+0x10b0>
ffffffffc0202d46:	c60fd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202d4a:	00011697          	auipc	a3,0x11
ffffffffc0202d4e:	2b668693          	addi	a3,a3,694 # ffffffffc0214000 <boot_page_table_sv39>
ffffffffc0202d52:	00d93023          	sd	a3,0(s2)
ffffffffc0202d56:	c02007b7          	lui	a5,0xc0200
ffffffffc0202d5a:	2af6eee3          	bltu	a3,a5,ffffffffc0203816 <pmm_init+0xbf2>
ffffffffc0202d5e:	0009b783          	ld	a5,0(s3)
ffffffffc0202d62:	8e9d                	sub	a3,a3,a5
ffffffffc0202d64:	00095797          	auipc	a5,0x95
ffffffffc0202d68:	b2d7ba23          	sd	a3,-1228(a5) # ffffffffc0297898 <boot_pgdir_pa>
ffffffffc0202d6c:	100027f3          	csrr	a5,sstatus
ffffffffc0202d70:	8b89                	andi	a5,a5,2
ffffffffc0202d72:	48079963          	bnez	a5,ffffffffc0203204 <pmm_init+0x5e0>
ffffffffc0202d76:	000b3783          	ld	a5,0(s6)
ffffffffc0202d7a:	779c                	ld	a5,40(a5)
ffffffffc0202d7c:	9782                	jalr	a5
ffffffffc0202d7e:	842a                	mv	s0,a0
ffffffffc0202d80:	6098                	ld	a4,0(s1)
ffffffffc0202d82:	c80007b7          	lui	a5,0xc8000
ffffffffc0202d86:	83b1                	srli	a5,a5,0xc
ffffffffc0202d88:	66e7e663          	bltu	a5,a4,ffffffffc02033f4 <pmm_init+0x7d0>
ffffffffc0202d8c:	00093503          	ld	a0,0(s2)
ffffffffc0202d90:	64050263          	beqz	a0,ffffffffc02033d4 <pmm_init+0x7b0>
ffffffffc0202d94:	03451793          	slli	a5,a0,0x34
ffffffffc0202d98:	62079e63          	bnez	a5,ffffffffc02033d4 <pmm_init+0x7b0>
ffffffffc0202d9c:	4601                	li	a2,0
ffffffffc0202d9e:	4581                	li	a1,0
ffffffffc0202da0:	8b7ff0ef          	jal	ffffffffc0202656 <get_page>
ffffffffc0202da4:	240519e3          	bnez	a0,ffffffffc02037f6 <pmm_init+0xbd2>
ffffffffc0202da8:	100027f3          	csrr	a5,sstatus
ffffffffc0202dac:	8b89                	andi	a5,a5,2
ffffffffc0202dae:	44079063          	bnez	a5,ffffffffc02031ee <pmm_init+0x5ca>
ffffffffc0202db2:	000b3783          	ld	a5,0(s6)
ffffffffc0202db6:	4505                	li	a0,1
ffffffffc0202db8:	6f9c                	ld	a5,24(a5)
ffffffffc0202dba:	9782                	jalr	a5
ffffffffc0202dbc:	8a2a                	mv	s4,a0
ffffffffc0202dbe:	00093503          	ld	a0,0(s2)
ffffffffc0202dc2:	4681                	li	a3,0
ffffffffc0202dc4:	4601                	li	a2,0
ffffffffc0202dc6:	85d2                	mv	a1,s4
ffffffffc0202dc8:	d67ff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc0202dcc:	280511e3          	bnez	a0,ffffffffc020384e <pmm_init+0xc2a>
ffffffffc0202dd0:	00093503          	ld	a0,0(s2)
ffffffffc0202dd4:	4601                	li	a2,0
ffffffffc0202dd6:	4581                	li	a1,0
ffffffffc0202dd8:	e20ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202ddc:	240509e3          	beqz	a0,ffffffffc020382e <pmm_init+0xc0a>
ffffffffc0202de0:	611c                	ld	a5,0(a0)
ffffffffc0202de2:	0017f713          	andi	a4,a5,1
ffffffffc0202de6:	58070f63          	beqz	a4,ffffffffc0203384 <pmm_init+0x760>
ffffffffc0202dea:	6098                	ld	a4,0(s1)
ffffffffc0202dec:	078a                	slli	a5,a5,0x2
ffffffffc0202dee:	83b1                	srli	a5,a5,0xc
ffffffffc0202df0:	58e7f863          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0202df4:	000bb683          	ld	a3,0(s7)
ffffffffc0202df8:	079a                	slli	a5,a5,0x6
ffffffffc0202dfa:	fe000637          	lui	a2,0xfe000
ffffffffc0202dfe:	97b2                	add	a5,a5,a2
ffffffffc0202e00:	97b6                	add	a5,a5,a3
ffffffffc0202e02:	14fa1ae3          	bne	s4,a5,ffffffffc0203756 <pmm_init+0xb32>
ffffffffc0202e06:	000a2683          	lw	a3,0(s4) # 200000 <_binary_bin_sfs_img_size+0x18ad00>
ffffffffc0202e0a:	4785                	li	a5,1
ffffffffc0202e0c:	12f695e3          	bne	a3,a5,ffffffffc0203736 <pmm_init+0xb12>
ffffffffc0202e10:	00093503          	ld	a0,0(s2)
ffffffffc0202e14:	77fd                	lui	a5,0xfffff
ffffffffc0202e16:	6114                	ld	a3,0(a0)
ffffffffc0202e18:	068a                	slli	a3,a3,0x2
ffffffffc0202e1a:	8efd                	and	a3,a3,a5
ffffffffc0202e1c:	00c6d613          	srli	a2,a3,0xc
ffffffffc0202e20:	0ee67fe3          	bgeu	a2,a4,ffffffffc020371e <pmm_init+0xafa>
ffffffffc0202e24:	0009bc03          	ld	s8,0(s3)
ffffffffc0202e28:	96e2                	add	a3,a3,s8
ffffffffc0202e2a:	0006ba83          	ld	s5,0(a3)
ffffffffc0202e2e:	0a8a                	slli	s5,s5,0x2
ffffffffc0202e30:	00fafab3          	and	s5,s5,a5
ffffffffc0202e34:	00cad793          	srli	a5,s5,0xc
ffffffffc0202e38:	0ce7f6e3          	bgeu	a5,a4,ffffffffc0203704 <pmm_init+0xae0>
ffffffffc0202e3c:	4601                	li	a2,0
ffffffffc0202e3e:	6585                	lui	a1,0x1
ffffffffc0202e40:	9c56                	add	s8,s8,s5
ffffffffc0202e42:	db6ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202e46:	0c21                	addi	s8,s8,8
ffffffffc0202e48:	05851ee3          	bne	a0,s8,ffffffffc02036a4 <pmm_init+0xa80>
ffffffffc0202e4c:	100027f3          	csrr	a5,sstatus
ffffffffc0202e50:	8b89                	andi	a5,a5,2
ffffffffc0202e52:	3e079b63          	bnez	a5,ffffffffc0203248 <pmm_init+0x624>
ffffffffc0202e56:	000b3783          	ld	a5,0(s6)
ffffffffc0202e5a:	4505                	li	a0,1
ffffffffc0202e5c:	6f9c                	ld	a5,24(a5)
ffffffffc0202e5e:	9782                	jalr	a5
ffffffffc0202e60:	8c2a                	mv	s8,a0
ffffffffc0202e62:	00093503          	ld	a0,0(s2)
ffffffffc0202e66:	46d1                	li	a3,20
ffffffffc0202e68:	6605                	lui	a2,0x1
ffffffffc0202e6a:	85e2                	mv	a1,s8
ffffffffc0202e6c:	cc3ff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc0202e70:	06051ae3          	bnez	a0,ffffffffc02036e4 <pmm_init+0xac0>
ffffffffc0202e74:	00093503          	ld	a0,0(s2)
ffffffffc0202e78:	4601                	li	a2,0
ffffffffc0202e7a:	6585                	lui	a1,0x1
ffffffffc0202e7c:	d7cff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202e80:	040502e3          	beqz	a0,ffffffffc02036c4 <pmm_init+0xaa0>
ffffffffc0202e84:	611c                	ld	a5,0(a0)
ffffffffc0202e86:	0107f713          	andi	a4,a5,16
ffffffffc0202e8a:	7e070163          	beqz	a4,ffffffffc020366c <pmm_init+0xa48>
ffffffffc0202e8e:	8b91                	andi	a5,a5,4
ffffffffc0202e90:	7a078e63          	beqz	a5,ffffffffc020364c <pmm_init+0xa28>
ffffffffc0202e94:	00093503          	ld	a0,0(s2)
ffffffffc0202e98:	611c                	ld	a5,0(a0)
ffffffffc0202e9a:	8bc1                	andi	a5,a5,16
ffffffffc0202e9c:	78078863          	beqz	a5,ffffffffc020362c <pmm_init+0xa08>
ffffffffc0202ea0:	000c2703          	lw	a4,0(s8)
ffffffffc0202ea4:	4785                	li	a5,1
ffffffffc0202ea6:	76f71363          	bne	a4,a5,ffffffffc020360c <pmm_init+0x9e8>
ffffffffc0202eaa:	4681                	li	a3,0
ffffffffc0202eac:	6605                	lui	a2,0x1
ffffffffc0202eae:	85d2                	mv	a1,s4
ffffffffc0202eb0:	c7fff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc0202eb4:	72051c63          	bnez	a0,ffffffffc02035ec <pmm_init+0x9c8>
ffffffffc0202eb8:	000a2703          	lw	a4,0(s4)
ffffffffc0202ebc:	4789                	li	a5,2
ffffffffc0202ebe:	70f71763          	bne	a4,a5,ffffffffc02035cc <pmm_init+0x9a8>
ffffffffc0202ec2:	000c2783          	lw	a5,0(s8)
ffffffffc0202ec6:	6e079363          	bnez	a5,ffffffffc02035ac <pmm_init+0x988>
ffffffffc0202eca:	00093503          	ld	a0,0(s2)
ffffffffc0202ece:	4601                	li	a2,0
ffffffffc0202ed0:	6585                	lui	a1,0x1
ffffffffc0202ed2:	d26ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0202ed6:	6a050b63          	beqz	a0,ffffffffc020358c <pmm_init+0x968>
ffffffffc0202eda:	6118                	ld	a4,0(a0)
ffffffffc0202edc:	00177793          	andi	a5,a4,1
ffffffffc0202ee0:	4a078263          	beqz	a5,ffffffffc0203384 <pmm_init+0x760>
ffffffffc0202ee4:	6094                	ld	a3,0(s1)
ffffffffc0202ee6:	00271793          	slli	a5,a4,0x2
ffffffffc0202eea:	83b1                	srli	a5,a5,0xc
ffffffffc0202eec:	48d7fa63          	bgeu	a5,a3,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0202ef0:	000bb683          	ld	a3,0(s7)
ffffffffc0202ef4:	fff80ab7          	lui	s5,0xfff80
ffffffffc0202ef8:	97d6                	add	a5,a5,s5
ffffffffc0202efa:	079a                	slli	a5,a5,0x6
ffffffffc0202efc:	97b6                	add	a5,a5,a3
ffffffffc0202efe:	66fa1763          	bne	s4,a5,ffffffffc020356c <pmm_init+0x948>
ffffffffc0202f02:	8b41                	andi	a4,a4,16
ffffffffc0202f04:	64071463          	bnez	a4,ffffffffc020354c <pmm_init+0x928>
ffffffffc0202f08:	00093503          	ld	a0,0(s2)
ffffffffc0202f0c:	4581                	li	a1,0
ffffffffc0202f0e:	b85ff0ef          	jal	ffffffffc0202a92 <page_remove>
ffffffffc0202f12:	000a2c83          	lw	s9,0(s4)
ffffffffc0202f16:	4785                	li	a5,1
ffffffffc0202f18:	60fc9a63          	bne	s9,a5,ffffffffc020352c <pmm_init+0x908>
ffffffffc0202f1c:	000c2783          	lw	a5,0(s8)
ffffffffc0202f20:	5e079663          	bnez	a5,ffffffffc020350c <pmm_init+0x8e8>
ffffffffc0202f24:	00093503          	ld	a0,0(s2)
ffffffffc0202f28:	6585                	lui	a1,0x1
ffffffffc0202f2a:	b69ff0ef          	jal	ffffffffc0202a92 <page_remove>
ffffffffc0202f2e:	000a2783          	lw	a5,0(s4)
ffffffffc0202f32:	52079d63          	bnez	a5,ffffffffc020346c <pmm_init+0x848>
ffffffffc0202f36:	000c2783          	lw	a5,0(s8)
ffffffffc0202f3a:	50079963          	bnez	a5,ffffffffc020344c <pmm_init+0x828>
ffffffffc0202f3e:	00093a03          	ld	s4,0(s2)
ffffffffc0202f42:	6098                	ld	a4,0(s1)
ffffffffc0202f44:	000a3783          	ld	a5,0(s4)
ffffffffc0202f48:	078a                	slli	a5,a5,0x2
ffffffffc0202f4a:	83b1                	srli	a5,a5,0xc
ffffffffc0202f4c:	42e7fa63          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0202f50:	000bb503          	ld	a0,0(s7)
ffffffffc0202f54:	97d6                	add	a5,a5,s5
ffffffffc0202f56:	079a                	slli	a5,a5,0x6
ffffffffc0202f58:	00f506b3          	add	a3,a0,a5
ffffffffc0202f5c:	4294                	lw	a3,0(a3)
ffffffffc0202f5e:	4d969763          	bne	a3,s9,ffffffffc020342c <pmm_init+0x808>
ffffffffc0202f62:	8799                	srai	a5,a5,0x6
ffffffffc0202f64:	00080637          	lui	a2,0x80
ffffffffc0202f68:	97b2                	add	a5,a5,a2
ffffffffc0202f6a:	00c79693          	slli	a3,a5,0xc
ffffffffc0202f6e:	4ae7f363          	bgeu	a5,a4,ffffffffc0203414 <pmm_init+0x7f0>
ffffffffc0202f72:	0009b783          	ld	a5,0(s3)
ffffffffc0202f76:	97b6                	add	a5,a5,a3
ffffffffc0202f78:	639c                	ld	a5,0(a5)
ffffffffc0202f7a:	078a                	slli	a5,a5,0x2
ffffffffc0202f7c:	83b1                	srli	a5,a5,0xc
ffffffffc0202f7e:	40e7f163          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0202f82:	8f91                	sub	a5,a5,a2
ffffffffc0202f84:	079a                	slli	a5,a5,0x6
ffffffffc0202f86:	953e                	add	a0,a0,a5
ffffffffc0202f88:	100027f3          	csrr	a5,sstatus
ffffffffc0202f8c:	8b89                	andi	a5,a5,2
ffffffffc0202f8e:	30079863          	bnez	a5,ffffffffc020329e <pmm_init+0x67a>
ffffffffc0202f92:	000b3783          	ld	a5,0(s6)
ffffffffc0202f96:	4585                	li	a1,1
ffffffffc0202f98:	739c                	ld	a5,32(a5)
ffffffffc0202f9a:	9782                	jalr	a5
ffffffffc0202f9c:	000a3783          	ld	a5,0(s4)
ffffffffc0202fa0:	6098                	ld	a4,0(s1)
ffffffffc0202fa2:	078a                	slli	a5,a5,0x2
ffffffffc0202fa4:	83b1                	srli	a5,a5,0xc
ffffffffc0202fa6:	3ce7fd63          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0202faa:	000bb503          	ld	a0,0(s7)
ffffffffc0202fae:	fe000737          	lui	a4,0xfe000
ffffffffc0202fb2:	079a                	slli	a5,a5,0x6
ffffffffc0202fb4:	97ba                	add	a5,a5,a4
ffffffffc0202fb6:	953e                	add	a0,a0,a5
ffffffffc0202fb8:	100027f3          	csrr	a5,sstatus
ffffffffc0202fbc:	8b89                	andi	a5,a5,2
ffffffffc0202fbe:	2c079463          	bnez	a5,ffffffffc0203286 <pmm_init+0x662>
ffffffffc0202fc2:	000b3783          	ld	a5,0(s6)
ffffffffc0202fc6:	4585                	li	a1,1
ffffffffc0202fc8:	739c                	ld	a5,32(a5)
ffffffffc0202fca:	9782                	jalr	a5
ffffffffc0202fcc:	00093783          	ld	a5,0(s2)
ffffffffc0202fd0:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd676e8>
ffffffffc0202fd4:	12000073          	sfence.vma
ffffffffc0202fd8:	100027f3          	csrr	a5,sstatus
ffffffffc0202fdc:	8b89                	andi	a5,a5,2
ffffffffc0202fde:	28079a63          	bnez	a5,ffffffffc0203272 <pmm_init+0x64e>
ffffffffc0202fe2:	000b3783          	ld	a5,0(s6)
ffffffffc0202fe6:	779c                	ld	a5,40(a5)
ffffffffc0202fe8:	9782                	jalr	a5
ffffffffc0202fea:	8a2a                	mv	s4,a0
ffffffffc0202fec:	4d441063          	bne	s0,s4,ffffffffc02034ac <pmm_init+0x888>
ffffffffc0202ff0:	0000a517          	auipc	a0,0xa
ffffffffc0202ff4:	14850513          	addi	a0,a0,328 # ffffffffc020d138 <etext+0x1400>
ffffffffc0202ff8:	9aefd0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0202ffc:	100027f3          	csrr	a5,sstatus
ffffffffc0203000:	8b89                	andi	a5,a5,2
ffffffffc0203002:	24079e63          	bnez	a5,ffffffffc020325e <pmm_init+0x63a>
ffffffffc0203006:	000b3783          	ld	a5,0(s6)
ffffffffc020300a:	779c                	ld	a5,40(a5)
ffffffffc020300c:	9782                	jalr	a5
ffffffffc020300e:	8c2a                	mv	s8,a0
ffffffffc0203010:	609c                	ld	a5,0(s1)
ffffffffc0203012:	c0200437          	lui	s0,0xc0200
ffffffffc0203016:	7a7d                	lui	s4,0xfffff
ffffffffc0203018:	00c79713          	slli	a4,a5,0xc
ffffffffc020301c:	6a85                	lui	s5,0x1
ffffffffc020301e:	02e47c63          	bgeu	s0,a4,ffffffffc0203056 <pmm_init+0x432>
ffffffffc0203022:	00c45713          	srli	a4,s0,0xc
ffffffffc0203026:	30f77063          	bgeu	a4,a5,ffffffffc0203326 <pmm_init+0x702>
ffffffffc020302a:	0009b583          	ld	a1,0(s3)
ffffffffc020302e:	00093503          	ld	a0,0(s2)
ffffffffc0203032:	4601                	li	a2,0
ffffffffc0203034:	95a2                	add	a1,a1,s0
ffffffffc0203036:	bc2ff0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc020303a:	32050363          	beqz	a0,ffffffffc0203360 <pmm_init+0x73c>
ffffffffc020303e:	611c                	ld	a5,0(a0)
ffffffffc0203040:	078a                	slli	a5,a5,0x2
ffffffffc0203042:	0147f7b3          	and	a5,a5,s4
ffffffffc0203046:	2e879d63          	bne	a5,s0,ffffffffc0203340 <pmm_init+0x71c>
ffffffffc020304a:	609c                	ld	a5,0(s1)
ffffffffc020304c:	9456                	add	s0,s0,s5
ffffffffc020304e:	00c79713          	slli	a4,a5,0xc
ffffffffc0203052:	fce468e3          	bltu	s0,a4,ffffffffc0203022 <pmm_init+0x3fe>
ffffffffc0203056:	00093783          	ld	a5,0(s2)
ffffffffc020305a:	639c                	ld	a5,0(a5)
ffffffffc020305c:	42079863          	bnez	a5,ffffffffc020348c <pmm_init+0x868>
ffffffffc0203060:	100027f3          	csrr	a5,sstatus
ffffffffc0203064:	8b89                	andi	a5,a5,2
ffffffffc0203066:	24079863          	bnez	a5,ffffffffc02032b6 <pmm_init+0x692>
ffffffffc020306a:	000b3783          	ld	a5,0(s6)
ffffffffc020306e:	4505                	li	a0,1
ffffffffc0203070:	6f9c                	ld	a5,24(a5)
ffffffffc0203072:	9782                	jalr	a5
ffffffffc0203074:	842a                	mv	s0,a0
ffffffffc0203076:	00093503          	ld	a0,0(s2)
ffffffffc020307a:	4699                	li	a3,6
ffffffffc020307c:	10000613          	li	a2,256
ffffffffc0203080:	85a2                	mv	a1,s0
ffffffffc0203082:	aadff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc0203086:	46051363          	bnez	a0,ffffffffc02034ec <pmm_init+0x8c8>
ffffffffc020308a:	4018                	lw	a4,0(s0)
ffffffffc020308c:	4785                	li	a5,1
ffffffffc020308e:	42f71f63          	bne	a4,a5,ffffffffc02034cc <pmm_init+0x8a8>
ffffffffc0203092:	00093503          	ld	a0,0(s2)
ffffffffc0203096:	6605                	lui	a2,0x1
ffffffffc0203098:	10060613          	addi	a2,a2,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc020309c:	4699                	li	a3,6
ffffffffc020309e:	85a2                	mv	a1,s0
ffffffffc02030a0:	a8fff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc02030a4:	72051963          	bnez	a0,ffffffffc02037d6 <pmm_init+0xbb2>
ffffffffc02030a8:	4018                	lw	a4,0(s0)
ffffffffc02030aa:	4789                	li	a5,2
ffffffffc02030ac:	70f71563          	bne	a4,a5,ffffffffc02037b6 <pmm_init+0xb92>
ffffffffc02030b0:	0000a597          	auipc	a1,0xa
ffffffffc02030b4:	1d058593          	addi	a1,a1,464 # ffffffffc020d280 <etext+0x1548>
ffffffffc02030b8:	10000513          	li	a0,256
ffffffffc02030bc:	395080ef          	jal	ffffffffc020bc50 <strcpy>
ffffffffc02030c0:	6585                	lui	a1,0x1
ffffffffc02030c2:	10058593          	addi	a1,a1,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc02030c6:	10000513          	li	a0,256
ffffffffc02030ca:	399080ef          	jal	ffffffffc020bc62 <strcmp>
ffffffffc02030ce:	6c051463          	bnez	a0,ffffffffc0203796 <pmm_init+0xb72>
ffffffffc02030d2:	000bb683          	ld	a3,0(s7)
ffffffffc02030d6:	000807b7          	lui	a5,0x80
ffffffffc02030da:	6098                	ld	a4,0(s1)
ffffffffc02030dc:	40d406b3          	sub	a3,s0,a3
ffffffffc02030e0:	8699                	srai	a3,a3,0x6
ffffffffc02030e2:	96be                	add	a3,a3,a5
ffffffffc02030e4:	00c69793          	slli	a5,a3,0xc
ffffffffc02030e8:	83b1                	srli	a5,a5,0xc
ffffffffc02030ea:	06b2                	slli	a3,a3,0xc
ffffffffc02030ec:	32e7f463          	bgeu	a5,a4,ffffffffc0203414 <pmm_init+0x7f0>
ffffffffc02030f0:	0009b783          	ld	a5,0(s3)
ffffffffc02030f4:	10000513          	li	a0,256
ffffffffc02030f8:	97b6                	add	a5,a5,a3
ffffffffc02030fa:	10078023          	sb	zero,256(a5) # 80100 <_binary_bin_sfs_img_size+0xae00>
ffffffffc02030fe:	31f080ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc0203102:	66051a63          	bnez	a0,ffffffffc0203776 <pmm_init+0xb52>
ffffffffc0203106:	00093a03          	ld	s4,0(s2)
ffffffffc020310a:	6098                	ld	a4,0(s1)
ffffffffc020310c:	000a3783          	ld	a5,0(s4) # fffffffffffff000 <end+0x3fd676e8>
ffffffffc0203110:	078a                	slli	a5,a5,0x2
ffffffffc0203112:	83b1                	srli	a5,a5,0xc
ffffffffc0203114:	26e7f663          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0203118:	00c79693          	slli	a3,a5,0xc
ffffffffc020311c:	2ee7fc63          	bgeu	a5,a4,ffffffffc0203414 <pmm_init+0x7f0>
ffffffffc0203120:	0009b783          	ld	a5,0(s3)
ffffffffc0203124:	00f689b3          	add	s3,a3,a5
ffffffffc0203128:	100027f3          	csrr	a5,sstatus
ffffffffc020312c:	8b89                	andi	a5,a5,2
ffffffffc020312e:	1e079163          	bnez	a5,ffffffffc0203310 <pmm_init+0x6ec>
ffffffffc0203132:	000b3783          	ld	a5,0(s6)
ffffffffc0203136:	8522                	mv	a0,s0
ffffffffc0203138:	4585                	li	a1,1
ffffffffc020313a:	739c                	ld	a5,32(a5)
ffffffffc020313c:	9782                	jalr	a5
ffffffffc020313e:	0009b783          	ld	a5,0(s3)
ffffffffc0203142:	6098                	ld	a4,0(s1)
ffffffffc0203144:	078a                	slli	a5,a5,0x2
ffffffffc0203146:	83b1                	srli	a5,a5,0xc
ffffffffc0203148:	22e7fc63          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc020314c:	000bb503          	ld	a0,0(s7)
ffffffffc0203150:	fe000737          	lui	a4,0xfe000
ffffffffc0203154:	079a                	slli	a5,a5,0x6
ffffffffc0203156:	97ba                	add	a5,a5,a4
ffffffffc0203158:	953e                	add	a0,a0,a5
ffffffffc020315a:	100027f3          	csrr	a5,sstatus
ffffffffc020315e:	8b89                	andi	a5,a5,2
ffffffffc0203160:	18079c63          	bnez	a5,ffffffffc02032f8 <pmm_init+0x6d4>
ffffffffc0203164:	000b3783          	ld	a5,0(s6)
ffffffffc0203168:	4585                	li	a1,1
ffffffffc020316a:	739c                	ld	a5,32(a5)
ffffffffc020316c:	9782                	jalr	a5
ffffffffc020316e:	000a3783          	ld	a5,0(s4)
ffffffffc0203172:	6098                	ld	a4,0(s1)
ffffffffc0203174:	078a                	slli	a5,a5,0x2
ffffffffc0203176:	83b1                	srli	a5,a5,0xc
ffffffffc0203178:	20e7f463          	bgeu	a5,a4,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc020317c:	000bb503          	ld	a0,0(s7)
ffffffffc0203180:	fe000737          	lui	a4,0xfe000
ffffffffc0203184:	079a                	slli	a5,a5,0x6
ffffffffc0203186:	97ba                	add	a5,a5,a4
ffffffffc0203188:	953e                	add	a0,a0,a5
ffffffffc020318a:	100027f3          	csrr	a5,sstatus
ffffffffc020318e:	8b89                	andi	a5,a5,2
ffffffffc0203190:	14079863          	bnez	a5,ffffffffc02032e0 <pmm_init+0x6bc>
ffffffffc0203194:	000b3783          	ld	a5,0(s6)
ffffffffc0203198:	4585                	li	a1,1
ffffffffc020319a:	739c                	ld	a5,32(a5)
ffffffffc020319c:	9782                	jalr	a5
ffffffffc020319e:	00093783          	ld	a5,0(s2)
ffffffffc02031a2:	0007b023          	sd	zero,0(a5)
ffffffffc02031a6:	12000073          	sfence.vma
ffffffffc02031aa:	100027f3          	csrr	a5,sstatus
ffffffffc02031ae:	8b89                	andi	a5,a5,2
ffffffffc02031b0:	10079e63          	bnez	a5,ffffffffc02032cc <pmm_init+0x6a8>
ffffffffc02031b4:	000b3783          	ld	a5,0(s6)
ffffffffc02031b8:	779c                	ld	a5,40(a5)
ffffffffc02031ba:	9782                	jalr	a5
ffffffffc02031bc:	842a                	mv	s0,a0
ffffffffc02031be:	1e8c1b63          	bne	s8,s0,ffffffffc02033b4 <pmm_init+0x790>
ffffffffc02031c2:	0000a517          	auipc	a0,0xa
ffffffffc02031c6:	13650513          	addi	a0,a0,310 # ffffffffc020d2f8 <etext+0x15c0>
ffffffffc02031ca:	fddfc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02031ce:	7406                	ld	s0,96(sp)
ffffffffc02031d0:	70a6                	ld	ra,104(sp)
ffffffffc02031d2:	64e6                	ld	s1,88(sp)
ffffffffc02031d4:	6946                	ld	s2,80(sp)
ffffffffc02031d6:	69a6                	ld	s3,72(sp)
ffffffffc02031d8:	6a06                	ld	s4,64(sp)
ffffffffc02031da:	7ae2                	ld	s5,56(sp)
ffffffffc02031dc:	7b42                	ld	s6,48(sp)
ffffffffc02031de:	7ba2                	ld	s7,40(sp)
ffffffffc02031e0:	7c02                	ld	s8,32(sp)
ffffffffc02031e2:	6ce2                	ld	s9,24(sp)
ffffffffc02031e4:	6165                	addi	sp,sp,112
ffffffffc02031e6:	f7ffe06f          	j	ffffffffc0202164 <kmalloc_init>
ffffffffc02031ea:	853e                	mv	a0,a5
ffffffffc02031ec:	b4e1                	j	ffffffffc0202cb4 <pmm_init+0x90>
ffffffffc02031ee:	a83fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02031f2:	000b3783          	ld	a5,0(s6)
ffffffffc02031f6:	4505                	li	a0,1
ffffffffc02031f8:	6f9c                	ld	a5,24(a5)
ffffffffc02031fa:	9782                	jalr	a5
ffffffffc02031fc:	8a2a                	mv	s4,a0
ffffffffc02031fe:	a6dfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203202:	be75                	j	ffffffffc0202dbe <pmm_init+0x19a>
ffffffffc0203204:	a6dfd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203208:	000b3783          	ld	a5,0(s6)
ffffffffc020320c:	779c                	ld	a5,40(a5)
ffffffffc020320e:	9782                	jalr	a5
ffffffffc0203210:	842a                	mv	s0,a0
ffffffffc0203212:	a59fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203216:	b6ad                	j	ffffffffc0202d80 <pmm_init+0x15c>
ffffffffc0203218:	6705                	lui	a4,0x1
ffffffffc020321a:	177d                	addi	a4,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020321c:	96ba                	add	a3,a3,a4
ffffffffc020321e:	8ff5                	and	a5,a5,a3
ffffffffc0203220:	00c7d713          	srli	a4,a5,0xc
ffffffffc0203224:	14a77e63          	bgeu	a4,a0,ffffffffc0203380 <pmm_init+0x75c>
ffffffffc0203228:	000b3683          	ld	a3,0(s6)
ffffffffc020322c:	8c1d                	sub	s0,s0,a5
ffffffffc020322e:	071a                	slli	a4,a4,0x6
ffffffffc0203230:	fe0007b7          	lui	a5,0xfe000
ffffffffc0203234:	973e                	add	a4,a4,a5
ffffffffc0203236:	6a9c                	ld	a5,16(a3)
ffffffffc0203238:	00c45593          	srli	a1,s0,0xc
ffffffffc020323c:	00e60533          	add	a0,a2,a4
ffffffffc0203240:	9782                	jalr	a5
ffffffffc0203242:	0009b583          	ld	a1,0(s3)
ffffffffc0203246:	bcf1                	j	ffffffffc0202d22 <pmm_init+0xfe>
ffffffffc0203248:	a29fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020324c:	000b3783          	ld	a5,0(s6)
ffffffffc0203250:	4505                	li	a0,1
ffffffffc0203252:	6f9c                	ld	a5,24(a5)
ffffffffc0203254:	9782                	jalr	a5
ffffffffc0203256:	8c2a                	mv	s8,a0
ffffffffc0203258:	a13fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020325c:	b119                	j	ffffffffc0202e62 <pmm_init+0x23e>
ffffffffc020325e:	a13fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203262:	000b3783          	ld	a5,0(s6)
ffffffffc0203266:	779c                	ld	a5,40(a5)
ffffffffc0203268:	9782                	jalr	a5
ffffffffc020326a:	8c2a                	mv	s8,a0
ffffffffc020326c:	9fffd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203270:	b345                	j	ffffffffc0203010 <pmm_init+0x3ec>
ffffffffc0203272:	9fffd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203276:	000b3783          	ld	a5,0(s6)
ffffffffc020327a:	779c                	ld	a5,40(a5)
ffffffffc020327c:	9782                	jalr	a5
ffffffffc020327e:	8a2a                	mv	s4,a0
ffffffffc0203280:	9ebfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203284:	b3a5                	j	ffffffffc0202fec <pmm_init+0x3c8>
ffffffffc0203286:	e42a                	sd	a0,8(sp)
ffffffffc0203288:	9e9fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020328c:	000b3783          	ld	a5,0(s6)
ffffffffc0203290:	6522                	ld	a0,8(sp)
ffffffffc0203292:	4585                	li	a1,1
ffffffffc0203294:	739c                	ld	a5,32(a5)
ffffffffc0203296:	9782                	jalr	a5
ffffffffc0203298:	9d3fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020329c:	bb05                	j	ffffffffc0202fcc <pmm_init+0x3a8>
ffffffffc020329e:	e42a                	sd	a0,8(sp)
ffffffffc02032a0:	9d1fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02032a4:	000b3783          	ld	a5,0(s6)
ffffffffc02032a8:	6522                	ld	a0,8(sp)
ffffffffc02032aa:	4585                	li	a1,1
ffffffffc02032ac:	739c                	ld	a5,32(a5)
ffffffffc02032ae:	9782                	jalr	a5
ffffffffc02032b0:	9bbfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02032b4:	b1e5                	j	ffffffffc0202f9c <pmm_init+0x378>
ffffffffc02032b6:	9bbfd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02032ba:	000b3783          	ld	a5,0(s6)
ffffffffc02032be:	4505                	li	a0,1
ffffffffc02032c0:	6f9c                	ld	a5,24(a5)
ffffffffc02032c2:	9782                	jalr	a5
ffffffffc02032c4:	842a                	mv	s0,a0
ffffffffc02032c6:	9a5fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02032ca:	b375                	j	ffffffffc0203076 <pmm_init+0x452>
ffffffffc02032cc:	9a5fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02032d0:	000b3783          	ld	a5,0(s6)
ffffffffc02032d4:	779c                	ld	a5,40(a5)
ffffffffc02032d6:	9782                	jalr	a5
ffffffffc02032d8:	842a                	mv	s0,a0
ffffffffc02032da:	991fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02032de:	b5c5                	j	ffffffffc02031be <pmm_init+0x59a>
ffffffffc02032e0:	e42a                	sd	a0,8(sp)
ffffffffc02032e2:	98ffd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02032e6:	000b3783          	ld	a5,0(s6)
ffffffffc02032ea:	6522                	ld	a0,8(sp)
ffffffffc02032ec:	4585                	li	a1,1
ffffffffc02032ee:	739c                	ld	a5,32(a5)
ffffffffc02032f0:	9782                	jalr	a5
ffffffffc02032f2:	979fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc02032f6:	b565                	j	ffffffffc020319e <pmm_init+0x57a>
ffffffffc02032f8:	e42a                	sd	a0,8(sp)
ffffffffc02032fa:	977fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02032fe:	000b3783          	ld	a5,0(s6)
ffffffffc0203302:	6522                	ld	a0,8(sp)
ffffffffc0203304:	4585                	li	a1,1
ffffffffc0203306:	739c                	ld	a5,32(a5)
ffffffffc0203308:	9782                	jalr	a5
ffffffffc020330a:	961fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020330e:	b585                	j	ffffffffc020316e <pmm_init+0x54a>
ffffffffc0203310:	961fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203314:	000b3783          	ld	a5,0(s6)
ffffffffc0203318:	8522                	mv	a0,s0
ffffffffc020331a:	4585                	li	a1,1
ffffffffc020331c:	739c                	ld	a5,32(a5)
ffffffffc020331e:	9782                	jalr	a5
ffffffffc0203320:	94bfd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203324:	bd29                	j	ffffffffc020313e <pmm_init+0x51a>
ffffffffc0203326:	86a2                	mv	a3,s0
ffffffffc0203328:	0000a617          	auipc	a2,0xa
ffffffffc020332c:	8e860613          	addi	a2,a2,-1816 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0203330:	25100593          	li	a1,593
ffffffffc0203334:	0000a517          	auipc	a0,0xa
ffffffffc0203338:	9cc50513          	addi	a0,a0,-1588 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020333c:	90efd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203340:	0000a697          	auipc	a3,0xa
ffffffffc0203344:	e5868693          	addi	a3,a3,-424 # ffffffffc020d198 <etext+0x1460>
ffffffffc0203348:	00009617          	auipc	a2,0x9
ffffffffc020334c:	e2860613          	addi	a2,a2,-472 # ffffffffc020c170 <etext+0x438>
ffffffffc0203350:	25200593          	li	a1,594
ffffffffc0203354:	0000a517          	auipc	a0,0xa
ffffffffc0203358:	9ac50513          	addi	a0,a0,-1620 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020335c:	8eefd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203360:	0000a697          	auipc	a3,0xa
ffffffffc0203364:	df868693          	addi	a3,a3,-520 # ffffffffc020d158 <etext+0x1420>
ffffffffc0203368:	00009617          	auipc	a2,0x9
ffffffffc020336c:	e0860613          	addi	a2,a2,-504 # ffffffffc020c170 <etext+0x438>
ffffffffc0203370:	25100593          	li	a1,593
ffffffffc0203374:	0000a517          	auipc	a0,0xa
ffffffffc0203378:	98c50513          	addi	a0,a0,-1652 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020337c:	8cefd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203380:	fb5fe0ef          	jal	ffffffffc0202334 <pa2page.part.0>
ffffffffc0203384:	0000a617          	auipc	a2,0xa
ffffffffc0203388:	b7460613          	addi	a2,a2,-1164 # ffffffffc020cef8 <etext+0x11c0>
ffffffffc020338c:	07f00593          	li	a1,127
ffffffffc0203390:	0000a517          	auipc	a0,0xa
ffffffffc0203394:	8a850513          	addi	a0,a0,-1880 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0203398:	8b2fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020339c:	0000a617          	auipc	a2,0xa
ffffffffc02033a0:	9d460613          	addi	a2,a2,-1580 # ffffffffc020cd70 <etext+0x1038>
ffffffffc02033a4:	06400593          	li	a1,100
ffffffffc02033a8:	0000a517          	auipc	a0,0xa
ffffffffc02033ac:	95850513          	addi	a0,a0,-1704 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02033b0:	89afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033b4:	0000a697          	auipc	a3,0xa
ffffffffc02033b8:	d5c68693          	addi	a3,a3,-676 # ffffffffc020d110 <etext+0x13d8>
ffffffffc02033bc:	00009617          	auipc	a2,0x9
ffffffffc02033c0:	db460613          	addi	a2,a2,-588 # ffffffffc020c170 <etext+0x438>
ffffffffc02033c4:	26c00593          	li	a1,620
ffffffffc02033c8:	0000a517          	auipc	a0,0xa
ffffffffc02033cc:	93850513          	addi	a0,a0,-1736 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02033d0:	87afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033d4:	0000a697          	auipc	a3,0xa
ffffffffc02033d8:	a5468693          	addi	a3,a3,-1452 # ffffffffc020ce28 <etext+0x10f0>
ffffffffc02033dc:	00009617          	auipc	a2,0x9
ffffffffc02033e0:	d9460613          	addi	a2,a2,-620 # ffffffffc020c170 <etext+0x438>
ffffffffc02033e4:	21300593          	li	a1,531
ffffffffc02033e8:	0000a517          	auipc	a0,0xa
ffffffffc02033ec:	91850513          	addi	a0,a0,-1768 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02033f0:	85afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02033f4:	0000a697          	auipc	a3,0xa
ffffffffc02033f8:	a1468693          	addi	a3,a3,-1516 # ffffffffc020ce08 <etext+0x10d0>
ffffffffc02033fc:	00009617          	auipc	a2,0x9
ffffffffc0203400:	d7460613          	addi	a2,a2,-652 # ffffffffc020c170 <etext+0x438>
ffffffffc0203404:	21200593          	li	a1,530
ffffffffc0203408:	0000a517          	auipc	a0,0xa
ffffffffc020340c:	8f850513          	addi	a0,a0,-1800 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203410:	83afd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203414:	00009617          	auipc	a2,0x9
ffffffffc0203418:	7fc60613          	addi	a2,a2,2044 # ffffffffc020cc10 <etext+0xed8>
ffffffffc020341c:	07100593          	li	a1,113
ffffffffc0203420:	0000a517          	auipc	a0,0xa
ffffffffc0203424:	81850513          	addi	a0,a0,-2024 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0203428:	822fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020342c:	0000a697          	auipc	a3,0xa
ffffffffc0203430:	cb468693          	addi	a3,a3,-844 # ffffffffc020d0e0 <etext+0x13a8>
ffffffffc0203434:	00009617          	auipc	a2,0x9
ffffffffc0203438:	d3c60613          	addi	a2,a2,-708 # ffffffffc020c170 <etext+0x438>
ffffffffc020343c:	23a00593          	li	a1,570
ffffffffc0203440:	0000a517          	auipc	a0,0xa
ffffffffc0203444:	8c050513          	addi	a0,a0,-1856 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203448:	802fd0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020344c:	0000a697          	auipc	a3,0xa
ffffffffc0203450:	c4c68693          	addi	a3,a3,-948 # ffffffffc020d098 <etext+0x1360>
ffffffffc0203454:	00009617          	auipc	a2,0x9
ffffffffc0203458:	d1c60613          	addi	a2,a2,-740 # ffffffffc020c170 <etext+0x438>
ffffffffc020345c:	23800593          	li	a1,568
ffffffffc0203460:	0000a517          	auipc	a0,0xa
ffffffffc0203464:	8a050513          	addi	a0,a0,-1888 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203468:	fe3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020346c:	0000a697          	auipc	a3,0xa
ffffffffc0203470:	c5c68693          	addi	a3,a3,-932 # ffffffffc020d0c8 <etext+0x1390>
ffffffffc0203474:	00009617          	auipc	a2,0x9
ffffffffc0203478:	cfc60613          	addi	a2,a2,-772 # ffffffffc020c170 <etext+0x438>
ffffffffc020347c:	23700593          	li	a1,567
ffffffffc0203480:	0000a517          	auipc	a0,0xa
ffffffffc0203484:	88050513          	addi	a0,a0,-1920 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203488:	fc3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020348c:	0000a697          	auipc	a3,0xa
ffffffffc0203490:	d2468693          	addi	a3,a3,-732 # ffffffffc020d1b0 <etext+0x1478>
ffffffffc0203494:	00009617          	auipc	a2,0x9
ffffffffc0203498:	cdc60613          	addi	a2,a2,-804 # ffffffffc020c170 <etext+0x438>
ffffffffc020349c:	25500593          	li	a1,597
ffffffffc02034a0:	0000a517          	auipc	a0,0xa
ffffffffc02034a4:	86050513          	addi	a0,a0,-1952 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02034a8:	fa3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034ac:	0000a697          	auipc	a3,0xa
ffffffffc02034b0:	c6468693          	addi	a3,a3,-924 # ffffffffc020d110 <etext+0x13d8>
ffffffffc02034b4:	00009617          	auipc	a2,0x9
ffffffffc02034b8:	cbc60613          	addi	a2,a2,-836 # ffffffffc020c170 <etext+0x438>
ffffffffc02034bc:	24200593          	li	a1,578
ffffffffc02034c0:	0000a517          	auipc	a0,0xa
ffffffffc02034c4:	84050513          	addi	a0,a0,-1984 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02034c8:	f83fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034cc:	0000a697          	auipc	a3,0xa
ffffffffc02034d0:	d3c68693          	addi	a3,a3,-708 # ffffffffc020d208 <etext+0x14d0>
ffffffffc02034d4:	00009617          	auipc	a2,0x9
ffffffffc02034d8:	c9c60613          	addi	a2,a2,-868 # ffffffffc020c170 <etext+0x438>
ffffffffc02034dc:	25a00593          	li	a1,602
ffffffffc02034e0:	0000a517          	auipc	a0,0xa
ffffffffc02034e4:	82050513          	addi	a0,a0,-2016 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02034e8:	f63fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02034ec:	0000a697          	auipc	a3,0xa
ffffffffc02034f0:	cdc68693          	addi	a3,a3,-804 # ffffffffc020d1c8 <etext+0x1490>
ffffffffc02034f4:	00009617          	auipc	a2,0x9
ffffffffc02034f8:	c7c60613          	addi	a2,a2,-900 # ffffffffc020c170 <etext+0x438>
ffffffffc02034fc:	25900593          	li	a1,601
ffffffffc0203500:	0000a517          	auipc	a0,0xa
ffffffffc0203504:	80050513          	addi	a0,a0,-2048 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203508:	f43fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020350c:	0000a697          	auipc	a3,0xa
ffffffffc0203510:	b8c68693          	addi	a3,a3,-1140 # ffffffffc020d098 <etext+0x1360>
ffffffffc0203514:	00009617          	auipc	a2,0x9
ffffffffc0203518:	c5c60613          	addi	a2,a2,-932 # ffffffffc020c170 <etext+0x438>
ffffffffc020351c:	23400593          	li	a1,564
ffffffffc0203520:	00009517          	auipc	a0,0x9
ffffffffc0203524:	7e050513          	addi	a0,a0,2016 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203528:	f23fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020352c:	0000a697          	auipc	a3,0xa
ffffffffc0203530:	a0c68693          	addi	a3,a3,-1524 # ffffffffc020cf38 <etext+0x1200>
ffffffffc0203534:	00009617          	auipc	a2,0x9
ffffffffc0203538:	c3c60613          	addi	a2,a2,-964 # ffffffffc020c170 <etext+0x438>
ffffffffc020353c:	23300593          	li	a1,563
ffffffffc0203540:	00009517          	auipc	a0,0x9
ffffffffc0203544:	7c050513          	addi	a0,a0,1984 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203548:	f03fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020354c:	0000a697          	auipc	a3,0xa
ffffffffc0203550:	b6468693          	addi	a3,a3,-1180 # ffffffffc020d0b0 <etext+0x1378>
ffffffffc0203554:	00009617          	auipc	a2,0x9
ffffffffc0203558:	c1c60613          	addi	a2,a2,-996 # ffffffffc020c170 <etext+0x438>
ffffffffc020355c:	23000593          	li	a1,560
ffffffffc0203560:	00009517          	auipc	a0,0x9
ffffffffc0203564:	7a050513          	addi	a0,a0,1952 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203568:	ee3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020356c:	0000a697          	auipc	a3,0xa
ffffffffc0203570:	9b468693          	addi	a3,a3,-1612 # ffffffffc020cf20 <etext+0x11e8>
ffffffffc0203574:	00009617          	auipc	a2,0x9
ffffffffc0203578:	bfc60613          	addi	a2,a2,-1028 # ffffffffc020c170 <etext+0x438>
ffffffffc020357c:	22f00593          	li	a1,559
ffffffffc0203580:	00009517          	auipc	a0,0x9
ffffffffc0203584:	78050513          	addi	a0,a0,1920 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203588:	ec3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020358c:	0000a697          	auipc	a3,0xa
ffffffffc0203590:	a3468693          	addi	a3,a3,-1484 # ffffffffc020cfc0 <etext+0x1288>
ffffffffc0203594:	00009617          	auipc	a2,0x9
ffffffffc0203598:	bdc60613          	addi	a2,a2,-1060 # ffffffffc020c170 <etext+0x438>
ffffffffc020359c:	22e00593          	li	a1,558
ffffffffc02035a0:	00009517          	auipc	a0,0x9
ffffffffc02035a4:	76050513          	addi	a0,a0,1888 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02035a8:	ea3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035ac:	0000a697          	auipc	a3,0xa
ffffffffc02035b0:	aec68693          	addi	a3,a3,-1300 # ffffffffc020d098 <etext+0x1360>
ffffffffc02035b4:	00009617          	auipc	a2,0x9
ffffffffc02035b8:	bbc60613          	addi	a2,a2,-1092 # ffffffffc020c170 <etext+0x438>
ffffffffc02035bc:	22d00593          	li	a1,557
ffffffffc02035c0:	00009517          	auipc	a0,0x9
ffffffffc02035c4:	74050513          	addi	a0,a0,1856 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02035c8:	e83fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035cc:	0000a697          	auipc	a3,0xa
ffffffffc02035d0:	ab468693          	addi	a3,a3,-1356 # ffffffffc020d080 <etext+0x1348>
ffffffffc02035d4:	00009617          	auipc	a2,0x9
ffffffffc02035d8:	b9c60613          	addi	a2,a2,-1124 # ffffffffc020c170 <etext+0x438>
ffffffffc02035dc:	22c00593          	li	a1,556
ffffffffc02035e0:	00009517          	auipc	a0,0x9
ffffffffc02035e4:	72050513          	addi	a0,a0,1824 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02035e8:	e63fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02035ec:	0000a697          	auipc	a3,0xa
ffffffffc02035f0:	a6468693          	addi	a3,a3,-1436 # ffffffffc020d050 <etext+0x1318>
ffffffffc02035f4:	00009617          	auipc	a2,0x9
ffffffffc02035f8:	b7c60613          	addi	a2,a2,-1156 # ffffffffc020c170 <etext+0x438>
ffffffffc02035fc:	22b00593          	li	a1,555
ffffffffc0203600:	00009517          	auipc	a0,0x9
ffffffffc0203604:	70050513          	addi	a0,a0,1792 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203608:	e43fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020360c:	0000a697          	auipc	a3,0xa
ffffffffc0203610:	a2c68693          	addi	a3,a3,-1492 # ffffffffc020d038 <etext+0x1300>
ffffffffc0203614:	00009617          	auipc	a2,0x9
ffffffffc0203618:	b5c60613          	addi	a2,a2,-1188 # ffffffffc020c170 <etext+0x438>
ffffffffc020361c:	22900593          	li	a1,553
ffffffffc0203620:	00009517          	auipc	a0,0x9
ffffffffc0203624:	6e050513          	addi	a0,a0,1760 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203628:	e23fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020362c:	0000a697          	auipc	a3,0xa
ffffffffc0203630:	9ec68693          	addi	a3,a3,-1556 # ffffffffc020d018 <etext+0x12e0>
ffffffffc0203634:	00009617          	auipc	a2,0x9
ffffffffc0203638:	b3c60613          	addi	a2,a2,-1220 # ffffffffc020c170 <etext+0x438>
ffffffffc020363c:	22800593          	li	a1,552
ffffffffc0203640:	00009517          	auipc	a0,0x9
ffffffffc0203644:	6c050513          	addi	a0,a0,1728 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203648:	e03fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020364c:	0000a697          	auipc	a3,0xa
ffffffffc0203650:	9bc68693          	addi	a3,a3,-1604 # ffffffffc020d008 <etext+0x12d0>
ffffffffc0203654:	00009617          	auipc	a2,0x9
ffffffffc0203658:	b1c60613          	addi	a2,a2,-1252 # ffffffffc020c170 <etext+0x438>
ffffffffc020365c:	22700593          	li	a1,551
ffffffffc0203660:	00009517          	auipc	a0,0x9
ffffffffc0203664:	6a050513          	addi	a0,a0,1696 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203668:	de3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020366c:	0000a697          	auipc	a3,0xa
ffffffffc0203670:	98c68693          	addi	a3,a3,-1652 # ffffffffc020cff8 <etext+0x12c0>
ffffffffc0203674:	00009617          	auipc	a2,0x9
ffffffffc0203678:	afc60613          	addi	a2,a2,-1284 # ffffffffc020c170 <etext+0x438>
ffffffffc020367c:	22600593          	li	a1,550
ffffffffc0203680:	00009517          	auipc	a0,0x9
ffffffffc0203684:	68050513          	addi	a0,a0,1664 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203688:	dc3fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020368c:	00009617          	auipc	a2,0x9
ffffffffc0203690:	62c60613          	addi	a2,a2,1580 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc0203694:	08000593          	li	a1,128
ffffffffc0203698:	00009517          	auipc	a0,0x9
ffffffffc020369c:	66850513          	addi	a0,a0,1640 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02036a0:	dabfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036a4:	0000a697          	auipc	a3,0xa
ffffffffc02036a8:	8ac68693          	addi	a3,a3,-1876 # ffffffffc020cf50 <etext+0x1218>
ffffffffc02036ac:	00009617          	auipc	a2,0x9
ffffffffc02036b0:	ac460613          	addi	a2,a2,-1340 # ffffffffc020c170 <etext+0x438>
ffffffffc02036b4:	22100593          	li	a1,545
ffffffffc02036b8:	00009517          	auipc	a0,0x9
ffffffffc02036bc:	64850513          	addi	a0,a0,1608 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02036c0:	d8bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036c4:	0000a697          	auipc	a3,0xa
ffffffffc02036c8:	8fc68693          	addi	a3,a3,-1796 # ffffffffc020cfc0 <etext+0x1288>
ffffffffc02036cc:	00009617          	auipc	a2,0x9
ffffffffc02036d0:	aa460613          	addi	a2,a2,-1372 # ffffffffc020c170 <etext+0x438>
ffffffffc02036d4:	22500593          	li	a1,549
ffffffffc02036d8:	00009517          	auipc	a0,0x9
ffffffffc02036dc:	62850513          	addi	a0,a0,1576 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02036e0:	d6bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02036e4:	0000a697          	auipc	a3,0xa
ffffffffc02036e8:	89c68693          	addi	a3,a3,-1892 # ffffffffc020cf80 <etext+0x1248>
ffffffffc02036ec:	00009617          	auipc	a2,0x9
ffffffffc02036f0:	a8460613          	addi	a2,a2,-1404 # ffffffffc020c170 <etext+0x438>
ffffffffc02036f4:	22400593          	li	a1,548
ffffffffc02036f8:	00009517          	auipc	a0,0x9
ffffffffc02036fc:	60850513          	addi	a0,a0,1544 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203700:	d4bfc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203704:	86d6                	mv	a3,s5
ffffffffc0203706:	00009617          	auipc	a2,0x9
ffffffffc020370a:	50a60613          	addi	a2,a2,1290 # ffffffffc020cc10 <etext+0xed8>
ffffffffc020370e:	22000593          	li	a1,544
ffffffffc0203712:	00009517          	auipc	a0,0x9
ffffffffc0203716:	5ee50513          	addi	a0,a0,1518 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020371a:	d31fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020371e:	00009617          	auipc	a2,0x9
ffffffffc0203722:	4f260613          	addi	a2,a2,1266 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0203726:	21f00593          	li	a1,543
ffffffffc020372a:	00009517          	auipc	a0,0x9
ffffffffc020372e:	5d650513          	addi	a0,a0,1494 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203732:	d19fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203736:	0000a697          	auipc	a3,0xa
ffffffffc020373a:	80268693          	addi	a3,a3,-2046 # ffffffffc020cf38 <etext+0x1200>
ffffffffc020373e:	00009617          	auipc	a2,0x9
ffffffffc0203742:	a3260613          	addi	a2,a2,-1486 # ffffffffc020c170 <etext+0x438>
ffffffffc0203746:	21d00593          	li	a1,541
ffffffffc020374a:	00009517          	auipc	a0,0x9
ffffffffc020374e:	5b650513          	addi	a0,a0,1462 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203752:	cf9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203756:	00009697          	auipc	a3,0x9
ffffffffc020375a:	7ca68693          	addi	a3,a3,1994 # ffffffffc020cf20 <etext+0x11e8>
ffffffffc020375e:	00009617          	auipc	a2,0x9
ffffffffc0203762:	a1260613          	addi	a2,a2,-1518 # ffffffffc020c170 <etext+0x438>
ffffffffc0203766:	21c00593          	li	a1,540
ffffffffc020376a:	00009517          	auipc	a0,0x9
ffffffffc020376e:	59650513          	addi	a0,a0,1430 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203772:	cd9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203776:	0000a697          	auipc	a3,0xa
ffffffffc020377a:	b5a68693          	addi	a3,a3,-1190 # ffffffffc020d2d0 <etext+0x1598>
ffffffffc020377e:	00009617          	auipc	a2,0x9
ffffffffc0203782:	9f260613          	addi	a2,a2,-1550 # ffffffffc020c170 <etext+0x438>
ffffffffc0203786:	26300593          	li	a1,611
ffffffffc020378a:	00009517          	auipc	a0,0x9
ffffffffc020378e:	57650513          	addi	a0,a0,1398 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203792:	cb9fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203796:	0000a697          	auipc	a3,0xa
ffffffffc020379a:	b0268693          	addi	a3,a3,-1278 # ffffffffc020d298 <etext+0x1560>
ffffffffc020379e:	00009617          	auipc	a2,0x9
ffffffffc02037a2:	9d260613          	addi	a2,a2,-1582 # ffffffffc020c170 <etext+0x438>
ffffffffc02037a6:	26000593          	li	a1,608
ffffffffc02037aa:	00009517          	auipc	a0,0x9
ffffffffc02037ae:	55650513          	addi	a0,a0,1366 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02037b2:	c99fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037b6:	0000a697          	auipc	a3,0xa
ffffffffc02037ba:	ab268693          	addi	a3,a3,-1358 # ffffffffc020d268 <etext+0x1530>
ffffffffc02037be:	00009617          	auipc	a2,0x9
ffffffffc02037c2:	9b260613          	addi	a2,a2,-1614 # ffffffffc020c170 <etext+0x438>
ffffffffc02037c6:	25c00593          	li	a1,604
ffffffffc02037ca:	00009517          	auipc	a0,0x9
ffffffffc02037ce:	53650513          	addi	a0,a0,1334 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02037d2:	c79fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037d6:	0000a697          	auipc	a3,0xa
ffffffffc02037da:	a4a68693          	addi	a3,a3,-1462 # ffffffffc020d220 <etext+0x14e8>
ffffffffc02037de:	00009617          	auipc	a2,0x9
ffffffffc02037e2:	99260613          	addi	a2,a2,-1646 # ffffffffc020c170 <etext+0x438>
ffffffffc02037e6:	25b00593          	li	a1,603
ffffffffc02037ea:	00009517          	auipc	a0,0x9
ffffffffc02037ee:	51650513          	addi	a0,a0,1302 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02037f2:	c59fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02037f6:	00009697          	auipc	a3,0x9
ffffffffc02037fa:	67268693          	addi	a3,a3,1650 # ffffffffc020ce68 <etext+0x1130>
ffffffffc02037fe:	00009617          	auipc	a2,0x9
ffffffffc0203802:	97260613          	addi	a2,a2,-1678 # ffffffffc020c170 <etext+0x438>
ffffffffc0203806:	21400593          	li	a1,532
ffffffffc020380a:	00009517          	auipc	a0,0x9
ffffffffc020380e:	4f650513          	addi	a0,a0,1270 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203812:	c39fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203816:	00009617          	auipc	a2,0x9
ffffffffc020381a:	4a260613          	addi	a2,a2,1186 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc020381e:	0c800593          	li	a1,200
ffffffffc0203822:	00009517          	auipc	a0,0x9
ffffffffc0203826:	4de50513          	addi	a0,a0,1246 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020382a:	c21fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020382e:	00009697          	auipc	a3,0x9
ffffffffc0203832:	69a68693          	addi	a3,a3,1690 # ffffffffc020cec8 <etext+0x1190>
ffffffffc0203836:	00009617          	auipc	a2,0x9
ffffffffc020383a:	93a60613          	addi	a2,a2,-1734 # ffffffffc020c170 <etext+0x438>
ffffffffc020383e:	21b00593          	li	a1,539
ffffffffc0203842:	00009517          	auipc	a0,0x9
ffffffffc0203846:	4be50513          	addi	a0,a0,1214 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020384a:	c01fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020384e:	00009697          	auipc	a3,0x9
ffffffffc0203852:	64a68693          	addi	a3,a3,1610 # ffffffffc020ce98 <etext+0x1160>
ffffffffc0203856:	00009617          	auipc	a2,0x9
ffffffffc020385a:	91a60613          	addi	a2,a2,-1766 # ffffffffc020c170 <etext+0x438>
ffffffffc020385e:	21800593          	li	a1,536
ffffffffc0203862:	00009517          	auipc	a0,0x9
ffffffffc0203866:	49e50513          	addi	a0,a0,1182 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc020386a:	be1fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020386e <copy_range>:
ffffffffc020386e:	7159                	addi	sp,sp,-112
ffffffffc0203870:	00d667b3          	or	a5,a2,a3
ffffffffc0203874:	f486                	sd	ra,104(sp)
ffffffffc0203876:	f0a2                	sd	s0,96(sp)
ffffffffc0203878:	eca6                	sd	s1,88(sp)
ffffffffc020387a:	e8ca                	sd	s2,80(sp)
ffffffffc020387c:	e4ce                	sd	s3,72(sp)
ffffffffc020387e:	e0d2                	sd	s4,64(sp)
ffffffffc0203880:	fc56                	sd	s5,56(sp)
ffffffffc0203882:	f85a                	sd	s6,48(sp)
ffffffffc0203884:	f45e                	sd	s7,40(sp)
ffffffffc0203886:	f062                	sd	s8,32(sp)
ffffffffc0203888:	ec66                	sd	s9,24(sp)
ffffffffc020388a:	e86a                	sd	s10,16(sp)
ffffffffc020388c:	e46e                	sd	s11,8(sp)
ffffffffc020388e:	03479713          	slli	a4,a5,0x34
ffffffffc0203892:	20071f63          	bnez	a4,ffffffffc0203ab0 <copy_range+0x242>
ffffffffc0203896:	002007b7          	lui	a5,0x200
ffffffffc020389a:	00d63733          	sltu	a4,a2,a3
ffffffffc020389e:	00f637b3          	sltu	a5,a2,a5
ffffffffc02038a2:	00173713          	seqz	a4,a4
ffffffffc02038a6:	8fd9                	or	a5,a5,a4
ffffffffc02038a8:	8432                	mv	s0,a2
ffffffffc02038aa:	8936                	mv	s2,a3
ffffffffc02038ac:	1e079263          	bnez	a5,ffffffffc0203a90 <copy_range+0x222>
ffffffffc02038b0:	4785                	li	a5,1
ffffffffc02038b2:	07fe                	slli	a5,a5,0x1f
ffffffffc02038b4:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc02038b6:	1cf6fd63          	bgeu	a3,a5,ffffffffc0203a90 <copy_range+0x222>
ffffffffc02038ba:	5b7d                	li	s6,-1
ffffffffc02038bc:	8baa                	mv	s7,a0
ffffffffc02038be:	8a2e                	mv	s4,a1
ffffffffc02038c0:	6a85                	lui	s5,0x1
ffffffffc02038c2:	00cb5b13          	srli	s6,s6,0xc
ffffffffc02038c6:	00094c97          	auipc	s9,0x94
ffffffffc02038ca:	feac8c93          	addi	s9,s9,-22 # ffffffffc02978b0 <npage>
ffffffffc02038ce:	00094c17          	auipc	s8,0x94
ffffffffc02038d2:	feac0c13          	addi	s8,s8,-22 # ffffffffc02978b8 <pages>
ffffffffc02038d6:	fff80d37          	lui	s10,0xfff80
ffffffffc02038da:	4601                	li	a2,0
ffffffffc02038dc:	85a2                	mv	a1,s0
ffffffffc02038de:	8552                	mv	a0,s4
ffffffffc02038e0:	b19fe0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc02038e4:	84aa                	mv	s1,a0
ffffffffc02038e6:	0e050a63          	beqz	a0,ffffffffc02039da <copy_range+0x16c>
ffffffffc02038ea:	611c                	ld	a5,0(a0)
ffffffffc02038ec:	8b85                	andi	a5,a5,1
ffffffffc02038ee:	e78d                	bnez	a5,ffffffffc0203918 <copy_range+0xaa>
ffffffffc02038f0:	9456                	add	s0,s0,s5
ffffffffc02038f2:	c019                	beqz	s0,ffffffffc02038f8 <copy_range+0x8a>
ffffffffc02038f4:	ff2463e3          	bltu	s0,s2,ffffffffc02038da <copy_range+0x6c>
ffffffffc02038f8:	4501                	li	a0,0
ffffffffc02038fa:	70a6                	ld	ra,104(sp)
ffffffffc02038fc:	7406                	ld	s0,96(sp)
ffffffffc02038fe:	64e6                	ld	s1,88(sp)
ffffffffc0203900:	6946                	ld	s2,80(sp)
ffffffffc0203902:	69a6                	ld	s3,72(sp)
ffffffffc0203904:	6a06                	ld	s4,64(sp)
ffffffffc0203906:	7ae2                	ld	s5,56(sp)
ffffffffc0203908:	7b42                	ld	s6,48(sp)
ffffffffc020390a:	7ba2                	ld	s7,40(sp)
ffffffffc020390c:	7c02                	ld	s8,32(sp)
ffffffffc020390e:	6ce2                	ld	s9,24(sp)
ffffffffc0203910:	6d42                	ld	s10,16(sp)
ffffffffc0203912:	6da2                	ld	s11,8(sp)
ffffffffc0203914:	6165                	addi	sp,sp,112
ffffffffc0203916:	8082                	ret
ffffffffc0203918:	4605                	li	a2,1
ffffffffc020391a:	85a2                	mv	a1,s0
ffffffffc020391c:	855e                	mv	a0,s7
ffffffffc020391e:	adbfe0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0203922:	c165                	beqz	a0,ffffffffc0203a02 <copy_range+0x194>
ffffffffc0203924:	0004b983          	ld	s3,0(s1)
ffffffffc0203928:	0019f793          	andi	a5,s3,1
ffffffffc020392c:	14078663          	beqz	a5,ffffffffc0203a78 <copy_range+0x20a>
ffffffffc0203930:	000cb703          	ld	a4,0(s9)
ffffffffc0203934:	00299793          	slli	a5,s3,0x2
ffffffffc0203938:	83b1                	srli	a5,a5,0xc
ffffffffc020393a:	12e7f363          	bgeu	a5,a4,ffffffffc0203a60 <copy_range+0x1f2>
ffffffffc020393e:	000c3483          	ld	s1,0(s8)
ffffffffc0203942:	97ea                	add	a5,a5,s10
ffffffffc0203944:	079a                	slli	a5,a5,0x6
ffffffffc0203946:	94be                	add	s1,s1,a5
ffffffffc0203948:	100027f3          	csrr	a5,sstatus
ffffffffc020394c:	8b89                	andi	a5,a5,2
ffffffffc020394e:	efc9                	bnez	a5,ffffffffc02039e8 <copy_range+0x17a>
ffffffffc0203950:	00094797          	auipc	a5,0x94
ffffffffc0203954:	f407b783          	ld	a5,-192(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc0203958:	4505                	li	a0,1
ffffffffc020395a:	6f9c                	ld	a5,24(a5)
ffffffffc020395c:	9782                	jalr	a5
ffffffffc020395e:	8daa                	mv	s11,a0
ffffffffc0203960:	c0e5                	beqz	s1,ffffffffc0203a40 <copy_range+0x1d2>
ffffffffc0203962:	0a0d8f63          	beqz	s11,ffffffffc0203a20 <copy_range+0x1b2>
ffffffffc0203966:	000c3783          	ld	a5,0(s8)
ffffffffc020396a:	00080637          	lui	a2,0x80
ffffffffc020396e:	000cb703          	ld	a4,0(s9)
ffffffffc0203972:	40f486b3          	sub	a3,s1,a5
ffffffffc0203976:	8699                	srai	a3,a3,0x6
ffffffffc0203978:	96b2                	add	a3,a3,a2
ffffffffc020397a:	0166f5b3          	and	a1,a3,s6
ffffffffc020397e:	06b2                	slli	a3,a3,0xc
ffffffffc0203980:	08e5f463          	bgeu	a1,a4,ffffffffc0203a08 <copy_range+0x19a>
ffffffffc0203984:	40fd87b3          	sub	a5,s11,a5
ffffffffc0203988:	8799                	srai	a5,a5,0x6
ffffffffc020398a:	97b2                	add	a5,a5,a2
ffffffffc020398c:	0167f633          	and	a2,a5,s6
ffffffffc0203990:	07b2                	slli	a5,a5,0xc
ffffffffc0203992:	06e67a63          	bgeu	a2,a4,ffffffffc0203a06 <copy_range+0x198>
ffffffffc0203996:	00094517          	auipc	a0,0x94
ffffffffc020399a:	f1253503          	ld	a0,-238(a0) # ffffffffc02978a8 <va_pa_offset>
ffffffffc020399e:	6605                	lui	a2,0x1
ffffffffc02039a0:	00a685b3          	add	a1,a3,a0
ffffffffc02039a4:	953e                	add	a0,a0,a5
ffffffffc02039a6:	37a080ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc02039aa:	01f9f693          	andi	a3,s3,31
ffffffffc02039ae:	85ee                	mv	a1,s11
ffffffffc02039b0:	8622                	mv	a2,s0
ffffffffc02039b2:	855e                	mv	a0,s7
ffffffffc02039b4:	97aff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc02039b8:	dd05                	beqz	a0,ffffffffc02038f0 <copy_range+0x82>
ffffffffc02039ba:	0000a697          	auipc	a3,0xa
ffffffffc02039be:	97e68693          	addi	a3,a3,-1666 # ffffffffc020d338 <etext+0x1600>
ffffffffc02039c2:	00008617          	auipc	a2,0x8
ffffffffc02039c6:	7ae60613          	addi	a2,a2,1966 # ffffffffc020c170 <etext+0x438>
ffffffffc02039ca:	1b000593          	li	a1,432
ffffffffc02039ce:	00009517          	auipc	a0,0x9
ffffffffc02039d2:	33250513          	addi	a0,a0,818 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc02039d6:	a75fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02039da:	002007b7          	lui	a5,0x200
ffffffffc02039de:	97a2                	add	a5,a5,s0
ffffffffc02039e0:	ffe00437          	lui	s0,0xffe00
ffffffffc02039e4:	8c7d                	and	s0,s0,a5
ffffffffc02039e6:	b731                	j	ffffffffc02038f2 <copy_range+0x84>
ffffffffc02039e8:	a88fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02039ec:	00094797          	auipc	a5,0x94
ffffffffc02039f0:	ea47b783          	ld	a5,-348(a5) # ffffffffc0297890 <pmm_manager>
ffffffffc02039f4:	4505                	li	a0,1
ffffffffc02039f6:	6f9c                	ld	a5,24(a5)
ffffffffc02039f8:	9782                	jalr	a5
ffffffffc02039fa:	8daa                	mv	s11,a0
ffffffffc02039fc:	a6efd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203a00:	b785                	j	ffffffffc0203960 <copy_range+0xf2>
ffffffffc0203a02:	5571                	li	a0,-4
ffffffffc0203a04:	bddd                	j	ffffffffc02038fa <copy_range+0x8c>
ffffffffc0203a06:	86be                	mv	a3,a5
ffffffffc0203a08:	00009617          	auipc	a2,0x9
ffffffffc0203a0c:	20860613          	addi	a2,a2,520 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0203a10:	07100593          	li	a1,113
ffffffffc0203a14:	00009517          	auipc	a0,0x9
ffffffffc0203a18:	22450513          	addi	a0,a0,548 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0203a1c:	a2ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203a20:	0000a697          	auipc	a3,0xa
ffffffffc0203a24:	90868693          	addi	a3,a3,-1784 # ffffffffc020d328 <etext+0x15f0>
ffffffffc0203a28:	00008617          	auipc	a2,0x8
ffffffffc0203a2c:	74860613          	addi	a2,a2,1864 # ffffffffc020c170 <etext+0x438>
ffffffffc0203a30:	19600593          	li	a1,406
ffffffffc0203a34:	00009517          	auipc	a0,0x9
ffffffffc0203a38:	2cc50513          	addi	a0,a0,716 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203a3c:	a0ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203a40:	0000a697          	auipc	a3,0xa
ffffffffc0203a44:	8d868693          	addi	a3,a3,-1832 # ffffffffc020d318 <etext+0x15e0>
ffffffffc0203a48:	00008617          	auipc	a2,0x8
ffffffffc0203a4c:	72860613          	addi	a2,a2,1832 # ffffffffc020c170 <etext+0x438>
ffffffffc0203a50:	19500593          	li	a1,405
ffffffffc0203a54:	00009517          	auipc	a0,0x9
ffffffffc0203a58:	2ac50513          	addi	a0,a0,684 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203a5c:	9effc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203a60:	00009617          	auipc	a2,0x9
ffffffffc0203a64:	28060613          	addi	a2,a2,640 # ffffffffc020cce0 <etext+0xfa8>
ffffffffc0203a68:	06900593          	li	a1,105
ffffffffc0203a6c:	00009517          	auipc	a0,0x9
ffffffffc0203a70:	1cc50513          	addi	a0,a0,460 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0203a74:	9d7fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203a78:	00009617          	auipc	a2,0x9
ffffffffc0203a7c:	48060613          	addi	a2,a2,1152 # ffffffffc020cef8 <etext+0x11c0>
ffffffffc0203a80:	07f00593          	li	a1,127
ffffffffc0203a84:	00009517          	auipc	a0,0x9
ffffffffc0203a88:	1b450513          	addi	a0,a0,436 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0203a8c:	9bffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203a90:	00009697          	auipc	a3,0x9
ffffffffc0203a94:	2b068693          	addi	a3,a3,688 # ffffffffc020cd40 <etext+0x1008>
ffffffffc0203a98:	00008617          	auipc	a2,0x8
ffffffffc0203a9c:	6d860613          	addi	a2,a2,1752 # ffffffffc020c170 <etext+0x438>
ffffffffc0203aa0:	17d00593          	li	a1,381
ffffffffc0203aa4:	00009517          	auipc	a0,0x9
ffffffffc0203aa8:	25c50513          	addi	a0,a0,604 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203aac:	99ffc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203ab0:	00009697          	auipc	a3,0x9
ffffffffc0203ab4:	26068693          	addi	a3,a3,608 # ffffffffc020cd10 <etext+0xfd8>
ffffffffc0203ab8:	00008617          	auipc	a2,0x8
ffffffffc0203abc:	6b860613          	addi	a2,a2,1720 # ffffffffc020c170 <etext+0x438>
ffffffffc0203ac0:	17c00593          	li	a1,380
ffffffffc0203ac4:	00009517          	auipc	a0,0x9
ffffffffc0203ac8:	23c50513          	addi	a0,a0,572 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203acc:	97ffc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203ad0 <pgdir_alloc_page>:
ffffffffc0203ad0:	7139                	addi	sp,sp,-64
ffffffffc0203ad2:	f426                	sd	s1,40(sp)
ffffffffc0203ad4:	f04a                	sd	s2,32(sp)
ffffffffc0203ad6:	ec4e                	sd	s3,24(sp)
ffffffffc0203ad8:	fc06                	sd	ra,56(sp)
ffffffffc0203ada:	f822                	sd	s0,48(sp)
ffffffffc0203adc:	892a                	mv	s2,a0
ffffffffc0203ade:	84ae                	mv	s1,a1
ffffffffc0203ae0:	89b2                	mv	s3,a2
ffffffffc0203ae2:	100027f3          	csrr	a5,sstatus
ffffffffc0203ae6:	8b89                	andi	a5,a5,2
ffffffffc0203ae8:	ebb5                	bnez	a5,ffffffffc0203b5c <pgdir_alloc_page+0x8c>
ffffffffc0203aea:	00094417          	auipc	s0,0x94
ffffffffc0203aee:	da640413          	addi	s0,s0,-602 # ffffffffc0297890 <pmm_manager>
ffffffffc0203af2:	601c                	ld	a5,0(s0)
ffffffffc0203af4:	4505                	li	a0,1
ffffffffc0203af6:	6f9c                	ld	a5,24(a5)
ffffffffc0203af8:	9782                	jalr	a5
ffffffffc0203afa:	85aa                	mv	a1,a0
ffffffffc0203afc:	c5b9                	beqz	a1,ffffffffc0203b4a <pgdir_alloc_page+0x7a>
ffffffffc0203afe:	86ce                	mv	a3,s3
ffffffffc0203b00:	854a                	mv	a0,s2
ffffffffc0203b02:	8626                	mv	a2,s1
ffffffffc0203b04:	e42e                	sd	a1,8(sp)
ffffffffc0203b06:	828ff0ef          	jal	ffffffffc0202b2e <page_insert>
ffffffffc0203b0a:	65a2                	ld	a1,8(sp)
ffffffffc0203b0c:	e515                	bnez	a0,ffffffffc0203b38 <pgdir_alloc_page+0x68>
ffffffffc0203b0e:	4198                	lw	a4,0(a1)
ffffffffc0203b10:	fd84                	sd	s1,56(a1)
ffffffffc0203b12:	4785                	li	a5,1
ffffffffc0203b14:	02f70c63          	beq	a4,a5,ffffffffc0203b4c <pgdir_alloc_page+0x7c>
ffffffffc0203b18:	0000a697          	auipc	a3,0xa
ffffffffc0203b1c:	83068693          	addi	a3,a3,-2000 # ffffffffc020d348 <etext+0x1610>
ffffffffc0203b20:	00008617          	auipc	a2,0x8
ffffffffc0203b24:	65060613          	addi	a2,a2,1616 # ffffffffc020c170 <etext+0x438>
ffffffffc0203b28:	1f900593          	li	a1,505
ffffffffc0203b2c:	00009517          	auipc	a0,0x9
ffffffffc0203b30:	1d450513          	addi	a0,a0,468 # ffffffffc020cd00 <etext+0xfc8>
ffffffffc0203b34:	917fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203b38:	100027f3          	csrr	a5,sstatus
ffffffffc0203b3c:	8b89                	andi	a5,a5,2
ffffffffc0203b3e:	ef95                	bnez	a5,ffffffffc0203b7a <pgdir_alloc_page+0xaa>
ffffffffc0203b40:	601c                	ld	a5,0(s0)
ffffffffc0203b42:	852e                	mv	a0,a1
ffffffffc0203b44:	4585                	li	a1,1
ffffffffc0203b46:	739c                	ld	a5,32(a5)
ffffffffc0203b48:	9782                	jalr	a5
ffffffffc0203b4a:	4581                	li	a1,0
ffffffffc0203b4c:	70e2                	ld	ra,56(sp)
ffffffffc0203b4e:	7442                	ld	s0,48(sp)
ffffffffc0203b50:	74a2                	ld	s1,40(sp)
ffffffffc0203b52:	7902                	ld	s2,32(sp)
ffffffffc0203b54:	69e2                	ld	s3,24(sp)
ffffffffc0203b56:	852e                	mv	a0,a1
ffffffffc0203b58:	6121                	addi	sp,sp,64
ffffffffc0203b5a:	8082                	ret
ffffffffc0203b5c:	914fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203b60:	00094417          	auipc	s0,0x94
ffffffffc0203b64:	d3040413          	addi	s0,s0,-720 # ffffffffc0297890 <pmm_manager>
ffffffffc0203b68:	601c                	ld	a5,0(s0)
ffffffffc0203b6a:	4505                	li	a0,1
ffffffffc0203b6c:	6f9c                	ld	a5,24(a5)
ffffffffc0203b6e:	9782                	jalr	a5
ffffffffc0203b70:	e42a                	sd	a0,8(sp)
ffffffffc0203b72:	8f8fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203b76:	65a2                	ld	a1,8(sp)
ffffffffc0203b78:	b751                	j	ffffffffc0203afc <pgdir_alloc_page+0x2c>
ffffffffc0203b7a:	8f6fd0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0203b7e:	601c                	ld	a5,0(s0)
ffffffffc0203b80:	6522                	ld	a0,8(sp)
ffffffffc0203b82:	4585                	li	a1,1
ffffffffc0203b84:	739c                	ld	a5,32(a5)
ffffffffc0203b86:	9782                	jalr	a5
ffffffffc0203b88:	8e2fd0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0203b8c:	bf7d                	j	ffffffffc0203b4a <pgdir_alloc_page+0x7a>

ffffffffc0203b8e <check_vma_overlap.part.0>:
ffffffffc0203b8e:	1141                	addi	sp,sp,-16
ffffffffc0203b90:	00009697          	auipc	a3,0x9
ffffffffc0203b94:	7d068693          	addi	a3,a3,2000 # ffffffffc020d360 <etext+0x1628>
ffffffffc0203b98:	00008617          	auipc	a2,0x8
ffffffffc0203b9c:	5d860613          	addi	a2,a2,1496 # ffffffffc020c170 <etext+0x438>
ffffffffc0203ba0:	07400593          	li	a1,116
ffffffffc0203ba4:	00009517          	auipc	a0,0x9
ffffffffc0203ba8:	7dc50513          	addi	a0,a0,2012 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203bac:	e406                	sd	ra,8(sp)
ffffffffc0203bae:	89dfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203bb2 <mm_create>:
ffffffffc0203bb2:	1101                	addi	sp,sp,-32
ffffffffc0203bb4:	05800513          	li	a0,88
ffffffffc0203bb8:	ec06                	sd	ra,24(sp)
ffffffffc0203bba:	dcefe0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0203bbe:	87aa                	mv	a5,a0
ffffffffc0203bc0:	c505                	beqz	a0,ffffffffc0203be8 <mm_create+0x36>
ffffffffc0203bc2:	e788                	sd	a0,8(a5)
ffffffffc0203bc4:	e388                	sd	a0,0(a5)
ffffffffc0203bc6:	00053823          	sd	zero,16(a0)
ffffffffc0203bca:	00053c23          	sd	zero,24(a0)
ffffffffc0203bce:	02052023          	sw	zero,32(a0)
ffffffffc0203bd2:	02053423          	sd	zero,40(a0)
ffffffffc0203bd6:	02052823          	sw	zero,48(a0)
ffffffffc0203bda:	4585                	li	a1,1
ffffffffc0203bdc:	03850513          	addi	a0,a0,56
ffffffffc0203be0:	e43e                	sd	a5,8(sp)
ffffffffc0203be2:	22d000ef          	jal	ffffffffc020460e <sem_init>
ffffffffc0203be6:	67a2                	ld	a5,8(sp)
ffffffffc0203be8:	60e2                	ld	ra,24(sp)
ffffffffc0203bea:	853e                	mv	a0,a5
ffffffffc0203bec:	6105                	addi	sp,sp,32
ffffffffc0203bee:	8082                	ret

ffffffffc0203bf0 <find_vma>:
ffffffffc0203bf0:	c505                	beqz	a0,ffffffffc0203c18 <find_vma+0x28>
ffffffffc0203bf2:	691c                	ld	a5,16(a0)
ffffffffc0203bf4:	c781                	beqz	a5,ffffffffc0203bfc <find_vma+0xc>
ffffffffc0203bf6:	6798                	ld	a4,8(a5)
ffffffffc0203bf8:	02e5f363          	bgeu	a1,a4,ffffffffc0203c1e <find_vma+0x2e>
ffffffffc0203bfc:	651c                	ld	a5,8(a0)
ffffffffc0203bfe:	00f50d63          	beq	a0,a5,ffffffffc0203c18 <find_vma+0x28>
ffffffffc0203c02:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203c06:	00e5e663          	bltu	a1,a4,ffffffffc0203c12 <find_vma+0x22>
ffffffffc0203c0a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0203c0e:	00e5ee63          	bltu	a1,a4,ffffffffc0203c2a <find_vma+0x3a>
ffffffffc0203c12:	679c                	ld	a5,8(a5)
ffffffffc0203c14:	fef517e3          	bne	a0,a5,ffffffffc0203c02 <find_vma+0x12>
ffffffffc0203c18:	4781                	li	a5,0
ffffffffc0203c1a:	853e                	mv	a0,a5
ffffffffc0203c1c:	8082                	ret
ffffffffc0203c1e:	6b98                	ld	a4,16(a5)
ffffffffc0203c20:	fce5fee3          	bgeu	a1,a4,ffffffffc0203bfc <find_vma+0xc>
ffffffffc0203c24:	e91c                	sd	a5,16(a0)
ffffffffc0203c26:	853e                	mv	a0,a5
ffffffffc0203c28:	8082                	ret
ffffffffc0203c2a:	1781                	addi	a5,a5,-32
ffffffffc0203c2c:	e91c                	sd	a5,16(a0)
ffffffffc0203c2e:	bfe5                	j	ffffffffc0203c26 <find_vma+0x36>

ffffffffc0203c30 <insert_vma_struct>:
ffffffffc0203c30:	6590                	ld	a2,8(a1)
ffffffffc0203c32:	0105b803          	ld	a6,16(a1)
ffffffffc0203c36:	1141                	addi	sp,sp,-16
ffffffffc0203c38:	e406                	sd	ra,8(sp)
ffffffffc0203c3a:	87aa                	mv	a5,a0
ffffffffc0203c3c:	01066763          	bltu	a2,a6,ffffffffc0203c4a <insert_vma_struct+0x1a>
ffffffffc0203c40:	a8b9                	j	ffffffffc0203c9e <insert_vma_struct+0x6e>
ffffffffc0203c42:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203c46:	04e66763          	bltu	a2,a4,ffffffffc0203c94 <insert_vma_struct+0x64>
ffffffffc0203c4a:	86be                	mv	a3,a5
ffffffffc0203c4c:	679c                	ld	a5,8(a5)
ffffffffc0203c4e:	fef51ae3          	bne	a0,a5,ffffffffc0203c42 <insert_vma_struct+0x12>
ffffffffc0203c52:	02a68463          	beq	a3,a0,ffffffffc0203c7a <insert_vma_struct+0x4a>
ffffffffc0203c56:	ff06b703          	ld	a4,-16(a3)
ffffffffc0203c5a:	fe86b883          	ld	a7,-24(a3)
ffffffffc0203c5e:	08e8f063          	bgeu	a7,a4,ffffffffc0203cde <insert_vma_struct+0xae>
ffffffffc0203c62:	04e66e63          	bltu	a2,a4,ffffffffc0203cbe <insert_vma_struct+0x8e>
ffffffffc0203c66:	00f50a63          	beq	a0,a5,ffffffffc0203c7a <insert_vma_struct+0x4a>
ffffffffc0203c6a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0203c6e:	05076863          	bltu	a4,a6,ffffffffc0203cbe <insert_vma_struct+0x8e>
ffffffffc0203c72:	ff07b603          	ld	a2,-16(a5)
ffffffffc0203c76:	02c77263          	bgeu	a4,a2,ffffffffc0203c9a <insert_vma_struct+0x6a>
ffffffffc0203c7a:	5118                	lw	a4,32(a0)
ffffffffc0203c7c:	e188                	sd	a0,0(a1)
ffffffffc0203c7e:	02058613          	addi	a2,a1,32
ffffffffc0203c82:	e390                	sd	a2,0(a5)
ffffffffc0203c84:	e690                	sd	a2,8(a3)
ffffffffc0203c86:	60a2                	ld	ra,8(sp)
ffffffffc0203c88:	f59c                	sd	a5,40(a1)
ffffffffc0203c8a:	f194                	sd	a3,32(a1)
ffffffffc0203c8c:	2705                	addiw	a4,a4,1
ffffffffc0203c8e:	d118                	sw	a4,32(a0)
ffffffffc0203c90:	0141                	addi	sp,sp,16
ffffffffc0203c92:	8082                	ret
ffffffffc0203c94:	fca691e3          	bne	a3,a0,ffffffffc0203c56 <insert_vma_struct+0x26>
ffffffffc0203c98:	bfd9                	j	ffffffffc0203c6e <insert_vma_struct+0x3e>
ffffffffc0203c9a:	ef5ff0ef          	jal	ffffffffc0203b8e <check_vma_overlap.part.0>
ffffffffc0203c9e:	00009697          	auipc	a3,0x9
ffffffffc0203ca2:	6f268693          	addi	a3,a3,1778 # ffffffffc020d390 <etext+0x1658>
ffffffffc0203ca6:	00008617          	auipc	a2,0x8
ffffffffc0203caa:	4ca60613          	addi	a2,a2,1226 # ffffffffc020c170 <etext+0x438>
ffffffffc0203cae:	07a00593          	li	a1,122
ffffffffc0203cb2:	00009517          	auipc	a0,0x9
ffffffffc0203cb6:	6ce50513          	addi	a0,a0,1742 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203cba:	f90fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203cbe:	00009697          	auipc	a3,0x9
ffffffffc0203cc2:	71268693          	addi	a3,a3,1810 # ffffffffc020d3d0 <etext+0x1698>
ffffffffc0203cc6:	00008617          	auipc	a2,0x8
ffffffffc0203cca:	4aa60613          	addi	a2,a2,1194 # ffffffffc020c170 <etext+0x438>
ffffffffc0203cce:	07300593          	li	a1,115
ffffffffc0203cd2:	00009517          	auipc	a0,0x9
ffffffffc0203cd6:	6ae50513          	addi	a0,a0,1710 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203cda:	f70fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0203cde:	00009697          	auipc	a3,0x9
ffffffffc0203ce2:	6d268693          	addi	a3,a3,1746 # ffffffffc020d3b0 <etext+0x1678>
ffffffffc0203ce6:	00008617          	auipc	a2,0x8
ffffffffc0203cea:	48a60613          	addi	a2,a2,1162 # ffffffffc020c170 <etext+0x438>
ffffffffc0203cee:	07200593          	li	a1,114
ffffffffc0203cf2:	00009517          	auipc	a0,0x9
ffffffffc0203cf6:	68e50513          	addi	a0,a0,1678 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203cfa:	f50fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203cfe <mm_destroy>:
ffffffffc0203cfe:	591c                	lw	a5,48(a0)
ffffffffc0203d00:	1141                	addi	sp,sp,-16
ffffffffc0203d02:	e406                	sd	ra,8(sp)
ffffffffc0203d04:	e022                	sd	s0,0(sp)
ffffffffc0203d06:	e78d                	bnez	a5,ffffffffc0203d30 <mm_destroy+0x32>
ffffffffc0203d08:	842a                	mv	s0,a0
ffffffffc0203d0a:	6508                	ld	a0,8(a0)
ffffffffc0203d0c:	00a40c63          	beq	s0,a0,ffffffffc0203d24 <mm_destroy+0x26>
ffffffffc0203d10:	6118                	ld	a4,0(a0)
ffffffffc0203d12:	651c                	ld	a5,8(a0)
ffffffffc0203d14:	1501                	addi	a0,a0,-32
ffffffffc0203d16:	e71c                	sd	a5,8(a4)
ffffffffc0203d18:	e398                	sd	a4,0(a5)
ffffffffc0203d1a:	d14fe0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0203d1e:	6408                	ld	a0,8(s0)
ffffffffc0203d20:	fea418e3          	bne	s0,a0,ffffffffc0203d10 <mm_destroy+0x12>
ffffffffc0203d24:	8522                	mv	a0,s0
ffffffffc0203d26:	6402                	ld	s0,0(sp)
ffffffffc0203d28:	60a2                	ld	ra,8(sp)
ffffffffc0203d2a:	0141                	addi	sp,sp,16
ffffffffc0203d2c:	d02fe06f          	j	ffffffffc020222e <kfree>
ffffffffc0203d30:	00009697          	auipc	a3,0x9
ffffffffc0203d34:	6c068693          	addi	a3,a3,1728 # ffffffffc020d3f0 <etext+0x16b8>
ffffffffc0203d38:	00008617          	auipc	a2,0x8
ffffffffc0203d3c:	43860613          	addi	a2,a2,1080 # ffffffffc020c170 <etext+0x438>
ffffffffc0203d40:	09e00593          	li	a1,158
ffffffffc0203d44:	00009517          	auipc	a0,0x9
ffffffffc0203d48:	63c50513          	addi	a0,a0,1596 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203d4c:	efefc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203d50 <mm_map>:
ffffffffc0203d50:	6785                	lui	a5,0x1
ffffffffc0203d52:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0203d54:	963e                	add	a2,a2,a5
ffffffffc0203d56:	4785                	li	a5,1
ffffffffc0203d58:	7139                	addi	sp,sp,-64
ffffffffc0203d5a:	962e                	add	a2,a2,a1
ffffffffc0203d5c:	787d                	lui	a6,0xfffff
ffffffffc0203d5e:	07fe                	slli	a5,a5,0x1f
ffffffffc0203d60:	f822                	sd	s0,48(sp)
ffffffffc0203d62:	f426                	sd	s1,40(sp)
ffffffffc0203d64:	01067433          	and	s0,a2,a6
ffffffffc0203d68:	0105f4b3          	and	s1,a1,a6
ffffffffc0203d6c:	0785                	addi	a5,a5,1
ffffffffc0203d6e:	0084b633          	sltu	a2,s1,s0
ffffffffc0203d72:	00f437b3          	sltu	a5,s0,a5
ffffffffc0203d76:	00163613          	seqz	a2,a2
ffffffffc0203d7a:	0017b793          	seqz	a5,a5
ffffffffc0203d7e:	fc06                	sd	ra,56(sp)
ffffffffc0203d80:	8fd1                	or	a5,a5,a2
ffffffffc0203d82:	ebbd                	bnez	a5,ffffffffc0203df8 <mm_map+0xa8>
ffffffffc0203d84:	002007b7          	lui	a5,0x200
ffffffffc0203d88:	06f4e863          	bltu	s1,a5,ffffffffc0203df8 <mm_map+0xa8>
ffffffffc0203d8c:	f04a                	sd	s2,32(sp)
ffffffffc0203d8e:	ec4e                	sd	s3,24(sp)
ffffffffc0203d90:	e852                	sd	s4,16(sp)
ffffffffc0203d92:	892a                	mv	s2,a0
ffffffffc0203d94:	89ba                	mv	s3,a4
ffffffffc0203d96:	8a36                	mv	s4,a3
ffffffffc0203d98:	c135                	beqz	a0,ffffffffc0203dfc <mm_map+0xac>
ffffffffc0203d9a:	85a6                	mv	a1,s1
ffffffffc0203d9c:	e55ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc0203da0:	c501                	beqz	a0,ffffffffc0203da8 <mm_map+0x58>
ffffffffc0203da2:	651c                	ld	a5,8(a0)
ffffffffc0203da4:	0487e763          	bltu	a5,s0,ffffffffc0203df2 <mm_map+0xa2>
ffffffffc0203da8:	03000513          	li	a0,48
ffffffffc0203dac:	bdcfe0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0203db0:	85aa                	mv	a1,a0
ffffffffc0203db2:	5571                	li	a0,-4
ffffffffc0203db4:	c59d                	beqz	a1,ffffffffc0203de2 <mm_map+0x92>
ffffffffc0203db6:	e584                	sd	s1,8(a1)
ffffffffc0203db8:	e980                	sd	s0,16(a1)
ffffffffc0203dba:	0145ac23          	sw	s4,24(a1)
ffffffffc0203dbe:	854a                	mv	a0,s2
ffffffffc0203dc0:	e42e                	sd	a1,8(sp)
ffffffffc0203dc2:	e6fff0ef          	jal	ffffffffc0203c30 <insert_vma_struct>
ffffffffc0203dc6:	65a2                	ld	a1,8(sp)
ffffffffc0203dc8:	00098463          	beqz	s3,ffffffffc0203dd0 <mm_map+0x80>
ffffffffc0203dcc:	00b9b023          	sd	a1,0(s3)
ffffffffc0203dd0:	7902                	ld	s2,32(sp)
ffffffffc0203dd2:	69e2                	ld	s3,24(sp)
ffffffffc0203dd4:	6a42                	ld	s4,16(sp)
ffffffffc0203dd6:	4501                	li	a0,0
ffffffffc0203dd8:	70e2                	ld	ra,56(sp)
ffffffffc0203dda:	7442                	ld	s0,48(sp)
ffffffffc0203ddc:	74a2                	ld	s1,40(sp)
ffffffffc0203dde:	6121                	addi	sp,sp,64
ffffffffc0203de0:	8082                	ret
ffffffffc0203de2:	70e2                	ld	ra,56(sp)
ffffffffc0203de4:	7442                	ld	s0,48(sp)
ffffffffc0203de6:	7902                	ld	s2,32(sp)
ffffffffc0203de8:	69e2                	ld	s3,24(sp)
ffffffffc0203dea:	6a42                	ld	s4,16(sp)
ffffffffc0203dec:	74a2                	ld	s1,40(sp)
ffffffffc0203dee:	6121                	addi	sp,sp,64
ffffffffc0203df0:	8082                	ret
ffffffffc0203df2:	7902                	ld	s2,32(sp)
ffffffffc0203df4:	69e2                	ld	s3,24(sp)
ffffffffc0203df6:	6a42                	ld	s4,16(sp)
ffffffffc0203df8:	5575                	li	a0,-3
ffffffffc0203dfa:	bff9                	j	ffffffffc0203dd8 <mm_map+0x88>
ffffffffc0203dfc:	00009697          	auipc	a3,0x9
ffffffffc0203e00:	60c68693          	addi	a3,a3,1548 # ffffffffc020d408 <etext+0x16d0>
ffffffffc0203e04:	00008617          	auipc	a2,0x8
ffffffffc0203e08:	36c60613          	addi	a2,a2,876 # ffffffffc020c170 <etext+0x438>
ffffffffc0203e0c:	0b300593          	li	a1,179
ffffffffc0203e10:	00009517          	auipc	a0,0x9
ffffffffc0203e14:	57050513          	addi	a0,a0,1392 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203e18:	e32fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203e1c <dup_mmap>:
ffffffffc0203e1c:	7139                	addi	sp,sp,-64
ffffffffc0203e1e:	fc06                	sd	ra,56(sp)
ffffffffc0203e20:	f822                	sd	s0,48(sp)
ffffffffc0203e22:	f426                	sd	s1,40(sp)
ffffffffc0203e24:	f04a                	sd	s2,32(sp)
ffffffffc0203e26:	ec4e                	sd	s3,24(sp)
ffffffffc0203e28:	e852                	sd	s4,16(sp)
ffffffffc0203e2a:	e456                	sd	s5,8(sp)
ffffffffc0203e2c:	c525                	beqz	a0,ffffffffc0203e94 <dup_mmap+0x78>
ffffffffc0203e2e:	892a                	mv	s2,a0
ffffffffc0203e30:	84ae                	mv	s1,a1
ffffffffc0203e32:	842e                	mv	s0,a1
ffffffffc0203e34:	c1a5                	beqz	a1,ffffffffc0203e94 <dup_mmap+0x78>
ffffffffc0203e36:	6000                	ld	s0,0(s0)
ffffffffc0203e38:	04848c63          	beq	s1,s0,ffffffffc0203e90 <dup_mmap+0x74>
ffffffffc0203e3c:	03000513          	li	a0,48
ffffffffc0203e40:	fe843a83          	ld	s5,-24(s0)
ffffffffc0203e44:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203e48:	ff842983          	lw	s3,-8(s0)
ffffffffc0203e4c:	b3cfe0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0203e50:	c515                	beqz	a0,ffffffffc0203e7c <dup_mmap+0x60>
ffffffffc0203e52:	85aa                	mv	a1,a0
ffffffffc0203e54:	01553423          	sd	s5,8(a0)
ffffffffc0203e58:	01453823          	sd	s4,16(a0)
ffffffffc0203e5c:	01352c23          	sw	s3,24(a0)
ffffffffc0203e60:	854a                	mv	a0,s2
ffffffffc0203e62:	dcfff0ef          	jal	ffffffffc0203c30 <insert_vma_struct>
ffffffffc0203e66:	ff043683          	ld	a3,-16(s0)
ffffffffc0203e6a:	fe843603          	ld	a2,-24(s0)
ffffffffc0203e6e:	6c8c                	ld	a1,24(s1)
ffffffffc0203e70:	01893503          	ld	a0,24(s2)
ffffffffc0203e74:	4701                	li	a4,0
ffffffffc0203e76:	9f9ff0ef          	jal	ffffffffc020386e <copy_range>
ffffffffc0203e7a:	dd55                	beqz	a0,ffffffffc0203e36 <dup_mmap+0x1a>
ffffffffc0203e7c:	5571                	li	a0,-4
ffffffffc0203e7e:	70e2                	ld	ra,56(sp)
ffffffffc0203e80:	7442                	ld	s0,48(sp)
ffffffffc0203e82:	74a2                	ld	s1,40(sp)
ffffffffc0203e84:	7902                	ld	s2,32(sp)
ffffffffc0203e86:	69e2                	ld	s3,24(sp)
ffffffffc0203e88:	6a42                	ld	s4,16(sp)
ffffffffc0203e8a:	6aa2                	ld	s5,8(sp)
ffffffffc0203e8c:	6121                	addi	sp,sp,64
ffffffffc0203e8e:	8082                	ret
ffffffffc0203e90:	4501                	li	a0,0
ffffffffc0203e92:	b7f5                	j	ffffffffc0203e7e <dup_mmap+0x62>
ffffffffc0203e94:	00009697          	auipc	a3,0x9
ffffffffc0203e98:	58468693          	addi	a3,a3,1412 # ffffffffc020d418 <etext+0x16e0>
ffffffffc0203e9c:	00008617          	auipc	a2,0x8
ffffffffc0203ea0:	2d460613          	addi	a2,a2,724 # ffffffffc020c170 <etext+0x438>
ffffffffc0203ea4:	0cf00593          	li	a1,207
ffffffffc0203ea8:	00009517          	auipc	a0,0x9
ffffffffc0203eac:	4d850513          	addi	a0,a0,1240 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203eb0:	d9afc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203eb4 <exit_mmap>:
ffffffffc0203eb4:	1101                	addi	sp,sp,-32
ffffffffc0203eb6:	ec06                	sd	ra,24(sp)
ffffffffc0203eb8:	e822                	sd	s0,16(sp)
ffffffffc0203eba:	e426                	sd	s1,8(sp)
ffffffffc0203ebc:	e04a                	sd	s2,0(sp)
ffffffffc0203ebe:	c531                	beqz	a0,ffffffffc0203f0a <exit_mmap+0x56>
ffffffffc0203ec0:	591c                	lw	a5,48(a0)
ffffffffc0203ec2:	84aa                	mv	s1,a0
ffffffffc0203ec4:	e3b9                	bnez	a5,ffffffffc0203f0a <exit_mmap+0x56>
ffffffffc0203ec6:	6500                	ld	s0,8(a0)
ffffffffc0203ec8:	01853903          	ld	s2,24(a0)
ffffffffc0203ecc:	02850663          	beq	a0,s0,ffffffffc0203ef8 <exit_mmap+0x44>
ffffffffc0203ed0:	ff043603          	ld	a2,-16(s0)
ffffffffc0203ed4:	fe843583          	ld	a1,-24(s0)
ffffffffc0203ed8:	854a                	mv	a0,s2
ffffffffc0203eda:	fd0fe0ef          	jal	ffffffffc02026aa <unmap_range>
ffffffffc0203ede:	6400                	ld	s0,8(s0)
ffffffffc0203ee0:	fe8498e3          	bne	s1,s0,ffffffffc0203ed0 <exit_mmap+0x1c>
ffffffffc0203ee4:	6400                	ld	s0,8(s0)
ffffffffc0203ee6:	00848c63          	beq	s1,s0,ffffffffc0203efe <exit_mmap+0x4a>
ffffffffc0203eea:	ff043603          	ld	a2,-16(s0)
ffffffffc0203eee:	fe843583          	ld	a1,-24(s0)
ffffffffc0203ef2:	854a                	mv	a0,s2
ffffffffc0203ef4:	8ebfe0ef          	jal	ffffffffc02027de <exit_range>
ffffffffc0203ef8:	6400                	ld	s0,8(s0)
ffffffffc0203efa:	fe8498e3          	bne	s1,s0,ffffffffc0203eea <exit_mmap+0x36>
ffffffffc0203efe:	60e2                	ld	ra,24(sp)
ffffffffc0203f00:	6442                	ld	s0,16(sp)
ffffffffc0203f02:	64a2                	ld	s1,8(sp)
ffffffffc0203f04:	6902                	ld	s2,0(sp)
ffffffffc0203f06:	6105                	addi	sp,sp,32
ffffffffc0203f08:	8082                	ret
ffffffffc0203f0a:	00009697          	auipc	a3,0x9
ffffffffc0203f0e:	52e68693          	addi	a3,a3,1326 # ffffffffc020d438 <etext+0x1700>
ffffffffc0203f12:	00008617          	auipc	a2,0x8
ffffffffc0203f16:	25e60613          	addi	a2,a2,606 # ffffffffc020c170 <etext+0x438>
ffffffffc0203f1a:	0e800593          	li	a1,232
ffffffffc0203f1e:	00009517          	auipc	a0,0x9
ffffffffc0203f22:	46250513          	addi	a0,a0,1122 # ffffffffc020d380 <etext+0x1648>
ffffffffc0203f26:	d24fc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0203f2a <vmm_init>:
ffffffffc0203f2a:	7179                	addi	sp,sp,-48
ffffffffc0203f2c:	05800513          	li	a0,88
ffffffffc0203f30:	f406                	sd	ra,40(sp)
ffffffffc0203f32:	f022                	sd	s0,32(sp)
ffffffffc0203f34:	ec26                	sd	s1,24(sp)
ffffffffc0203f36:	e84a                	sd	s2,16(sp)
ffffffffc0203f38:	e44e                	sd	s3,8(sp)
ffffffffc0203f3a:	e052                	sd	s4,0(sp)
ffffffffc0203f3c:	a4cfe0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0203f40:	16050f63          	beqz	a0,ffffffffc02040be <vmm_init+0x194>
ffffffffc0203f44:	e508                	sd	a0,8(a0)
ffffffffc0203f46:	e108                	sd	a0,0(a0)
ffffffffc0203f48:	00053823          	sd	zero,16(a0)
ffffffffc0203f4c:	00053c23          	sd	zero,24(a0)
ffffffffc0203f50:	02052023          	sw	zero,32(a0)
ffffffffc0203f54:	02053423          	sd	zero,40(a0)
ffffffffc0203f58:	02052823          	sw	zero,48(a0)
ffffffffc0203f5c:	842a                	mv	s0,a0
ffffffffc0203f5e:	4585                	li	a1,1
ffffffffc0203f60:	03850513          	addi	a0,a0,56
ffffffffc0203f64:	6aa000ef          	jal	ffffffffc020460e <sem_init>
ffffffffc0203f68:	03200493          	li	s1,50
ffffffffc0203f6c:	03000513          	li	a0,48
ffffffffc0203f70:	a18fe0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0203f74:	12050563          	beqz	a0,ffffffffc020409e <vmm_init+0x174>
ffffffffc0203f78:	00248793          	addi	a5,s1,2
ffffffffc0203f7c:	e504                	sd	s1,8(a0)
ffffffffc0203f7e:	00052c23          	sw	zero,24(a0)
ffffffffc0203f82:	e91c                	sd	a5,16(a0)
ffffffffc0203f84:	85aa                	mv	a1,a0
ffffffffc0203f86:	14ed                	addi	s1,s1,-5
ffffffffc0203f88:	8522                	mv	a0,s0
ffffffffc0203f8a:	ca7ff0ef          	jal	ffffffffc0203c30 <insert_vma_struct>
ffffffffc0203f8e:	fcf9                	bnez	s1,ffffffffc0203f6c <vmm_init+0x42>
ffffffffc0203f90:	03700493          	li	s1,55
ffffffffc0203f94:	1f900913          	li	s2,505
ffffffffc0203f98:	03000513          	li	a0,48
ffffffffc0203f9c:	9ecfe0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0203fa0:	12050f63          	beqz	a0,ffffffffc02040de <vmm_init+0x1b4>
ffffffffc0203fa4:	00248793          	addi	a5,s1,2
ffffffffc0203fa8:	e504                	sd	s1,8(a0)
ffffffffc0203faa:	00052c23          	sw	zero,24(a0)
ffffffffc0203fae:	e91c                	sd	a5,16(a0)
ffffffffc0203fb0:	85aa                	mv	a1,a0
ffffffffc0203fb2:	0495                	addi	s1,s1,5
ffffffffc0203fb4:	8522                	mv	a0,s0
ffffffffc0203fb6:	c7bff0ef          	jal	ffffffffc0203c30 <insert_vma_struct>
ffffffffc0203fba:	fd249fe3          	bne	s1,s2,ffffffffc0203f98 <vmm_init+0x6e>
ffffffffc0203fbe:	641c                	ld	a5,8(s0)
ffffffffc0203fc0:	471d                	li	a4,7
ffffffffc0203fc2:	1fb00593          	li	a1,507
ffffffffc0203fc6:	1ef40c63          	beq	s0,a5,ffffffffc02041be <vmm_init+0x294>
ffffffffc0203fca:	fe87b603          	ld	a2,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0203fce:	ffe70693          	addi	a3,a4,-2
ffffffffc0203fd2:	12d61663          	bne	a2,a3,ffffffffc02040fe <vmm_init+0x1d4>
ffffffffc0203fd6:	ff07b683          	ld	a3,-16(a5)
ffffffffc0203fda:	12e69263          	bne	a3,a4,ffffffffc02040fe <vmm_init+0x1d4>
ffffffffc0203fde:	0715                	addi	a4,a4,5
ffffffffc0203fe0:	679c                	ld	a5,8(a5)
ffffffffc0203fe2:	feb712e3          	bne	a4,a1,ffffffffc0203fc6 <vmm_init+0x9c>
ffffffffc0203fe6:	491d                	li	s2,7
ffffffffc0203fe8:	4495                	li	s1,5
ffffffffc0203fea:	85a6                	mv	a1,s1
ffffffffc0203fec:	8522                	mv	a0,s0
ffffffffc0203fee:	c03ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc0203ff2:	8a2a                	mv	s4,a0
ffffffffc0203ff4:	20050563          	beqz	a0,ffffffffc02041fe <vmm_init+0x2d4>
ffffffffc0203ff8:	00148593          	addi	a1,s1,1
ffffffffc0203ffc:	8522                	mv	a0,s0
ffffffffc0203ffe:	bf3ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc0204002:	89aa                	mv	s3,a0
ffffffffc0204004:	1c050d63          	beqz	a0,ffffffffc02041de <vmm_init+0x2b4>
ffffffffc0204008:	85ca                	mv	a1,s2
ffffffffc020400a:	8522                	mv	a0,s0
ffffffffc020400c:	be5ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc0204010:	18051763          	bnez	a0,ffffffffc020419e <vmm_init+0x274>
ffffffffc0204014:	00348593          	addi	a1,s1,3
ffffffffc0204018:	8522                	mv	a0,s0
ffffffffc020401a:	bd7ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc020401e:	16051063          	bnez	a0,ffffffffc020417e <vmm_init+0x254>
ffffffffc0204022:	00448593          	addi	a1,s1,4
ffffffffc0204026:	8522                	mv	a0,s0
ffffffffc0204028:	bc9ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc020402c:	12051963          	bnez	a0,ffffffffc020415e <vmm_init+0x234>
ffffffffc0204030:	008a3783          	ld	a5,8(s4)
ffffffffc0204034:	10979563          	bne	a5,s1,ffffffffc020413e <vmm_init+0x214>
ffffffffc0204038:	010a3783          	ld	a5,16(s4)
ffffffffc020403c:	11279163          	bne	a5,s2,ffffffffc020413e <vmm_init+0x214>
ffffffffc0204040:	0089b783          	ld	a5,8(s3)
ffffffffc0204044:	0c979d63          	bne	a5,s1,ffffffffc020411e <vmm_init+0x1f4>
ffffffffc0204048:	0109b783          	ld	a5,16(s3)
ffffffffc020404c:	0d279963          	bne	a5,s2,ffffffffc020411e <vmm_init+0x1f4>
ffffffffc0204050:	0495                	addi	s1,s1,5
ffffffffc0204052:	1f900793          	li	a5,505
ffffffffc0204056:	0915                	addi	s2,s2,5
ffffffffc0204058:	f8f499e3          	bne	s1,a5,ffffffffc0203fea <vmm_init+0xc0>
ffffffffc020405c:	4491                	li	s1,4
ffffffffc020405e:	597d                	li	s2,-1
ffffffffc0204060:	85a6                	mv	a1,s1
ffffffffc0204062:	8522                	mv	a0,s0
ffffffffc0204064:	b8dff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc0204068:	1a051b63          	bnez	a0,ffffffffc020421e <vmm_init+0x2f4>
ffffffffc020406c:	14fd                	addi	s1,s1,-1
ffffffffc020406e:	ff2499e3          	bne	s1,s2,ffffffffc0204060 <vmm_init+0x136>
ffffffffc0204072:	8522                	mv	a0,s0
ffffffffc0204074:	c8bff0ef          	jal	ffffffffc0203cfe <mm_destroy>
ffffffffc0204078:	00009517          	auipc	a0,0x9
ffffffffc020407c:	53050513          	addi	a0,a0,1328 # ffffffffc020d5a8 <etext+0x1870>
ffffffffc0204080:	926fc0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0204084:	7402                	ld	s0,32(sp)
ffffffffc0204086:	70a2                	ld	ra,40(sp)
ffffffffc0204088:	64e2                	ld	s1,24(sp)
ffffffffc020408a:	6942                	ld	s2,16(sp)
ffffffffc020408c:	69a2                	ld	s3,8(sp)
ffffffffc020408e:	6a02                	ld	s4,0(sp)
ffffffffc0204090:	00009517          	auipc	a0,0x9
ffffffffc0204094:	53850513          	addi	a0,a0,1336 # ffffffffc020d5c8 <etext+0x1890>
ffffffffc0204098:	6145                	addi	sp,sp,48
ffffffffc020409a:	90cfc06f          	j	ffffffffc02001a6 <cprintf>
ffffffffc020409e:	00009697          	auipc	a3,0x9
ffffffffc02040a2:	3ba68693          	addi	a3,a3,954 # ffffffffc020d458 <etext+0x1720>
ffffffffc02040a6:	00008617          	auipc	a2,0x8
ffffffffc02040aa:	0ca60613          	addi	a2,a2,202 # ffffffffc020c170 <etext+0x438>
ffffffffc02040ae:	12c00593          	li	a1,300
ffffffffc02040b2:	00009517          	auipc	a0,0x9
ffffffffc02040b6:	2ce50513          	addi	a0,a0,718 # ffffffffc020d380 <etext+0x1648>
ffffffffc02040ba:	b90fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02040be:	00009697          	auipc	a3,0x9
ffffffffc02040c2:	34a68693          	addi	a3,a3,842 # ffffffffc020d408 <etext+0x16d0>
ffffffffc02040c6:	00008617          	auipc	a2,0x8
ffffffffc02040ca:	0aa60613          	addi	a2,a2,170 # ffffffffc020c170 <etext+0x438>
ffffffffc02040ce:	12400593          	li	a1,292
ffffffffc02040d2:	00009517          	auipc	a0,0x9
ffffffffc02040d6:	2ae50513          	addi	a0,a0,686 # ffffffffc020d380 <etext+0x1648>
ffffffffc02040da:	b70fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02040de:	00009697          	auipc	a3,0x9
ffffffffc02040e2:	37a68693          	addi	a3,a3,890 # ffffffffc020d458 <etext+0x1720>
ffffffffc02040e6:	00008617          	auipc	a2,0x8
ffffffffc02040ea:	08a60613          	addi	a2,a2,138 # ffffffffc020c170 <etext+0x438>
ffffffffc02040ee:	13300593          	li	a1,307
ffffffffc02040f2:	00009517          	auipc	a0,0x9
ffffffffc02040f6:	28e50513          	addi	a0,a0,654 # ffffffffc020d380 <etext+0x1648>
ffffffffc02040fa:	b50fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02040fe:	00009697          	auipc	a3,0x9
ffffffffc0204102:	38268693          	addi	a3,a3,898 # ffffffffc020d480 <etext+0x1748>
ffffffffc0204106:	00008617          	auipc	a2,0x8
ffffffffc020410a:	06a60613          	addi	a2,a2,106 # ffffffffc020c170 <etext+0x438>
ffffffffc020410e:	13d00593          	li	a1,317
ffffffffc0204112:	00009517          	auipc	a0,0x9
ffffffffc0204116:	26e50513          	addi	a0,a0,622 # ffffffffc020d380 <etext+0x1648>
ffffffffc020411a:	b30fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020411e:	00009697          	auipc	a3,0x9
ffffffffc0204122:	41a68693          	addi	a3,a3,1050 # ffffffffc020d538 <etext+0x1800>
ffffffffc0204126:	00008617          	auipc	a2,0x8
ffffffffc020412a:	04a60613          	addi	a2,a2,74 # ffffffffc020c170 <etext+0x438>
ffffffffc020412e:	14f00593          	li	a1,335
ffffffffc0204132:	00009517          	auipc	a0,0x9
ffffffffc0204136:	24e50513          	addi	a0,a0,590 # ffffffffc020d380 <etext+0x1648>
ffffffffc020413a:	b10fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020413e:	00009697          	auipc	a3,0x9
ffffffffc0204142:	3ca68693          	addi	a3,a3,970 # ffffffffc020d508 <etext+0x17d0>
ffffffffc0204146:	00008617          	auipc	a2,0x8
ffffffffc020414a:	02a60613          	addi	a2,a2,42 # ffffffffc020c170 <etext+0x438>
ffffffffc020414e:	14e00593          	li	a1,334
ffffffffc0204152:	00009517          	auipc	a0,0x9
ffffffffc0204156:	22e50513          	addi	a0,a0,558 # ffffffffc020d380 <etext+0x1648>
ffffffffc020415a:	af0fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020415e:	00009697          	auipc	a3,0x9
ffffffffc0204162:	39a68693          	addi	a3,a3,922 # ffffffffc020d4f8 <etext+0x17c0>
ffffffffc0204166:	00008617          	auipc	a2,0x8
ffffffffc020416a:	00a60613          	addi	a2,a2,10 # ffffffffc020c170 <etext+0x438>
ffffffffc020416e:	14c00593          	li	a1,332
ffffffffc0204172:	00009517          	auipc	a0,0x9
ffffffffc0204176:	20e50513          	addi	a0,a0,526 # ffffffffc020d380 <etext+0x1648>
ffffffffc020417a:	ad0fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020417e:	00009697          	auipc	a3,0x9
ffffffffc0204182:	36a68693          	addi	a3,a3,874 # ffffffffc020d4e8 <etext+0x17b0>
ffffffffc0204186:	00008617          	auipc	a2,0x8
ffffffffc020418a:	fea60613          	addi	a2,a2,-22 # ffffffffc020c170 <etext+0x438>
ffffffffc020418e:	14a00593          	li	a1,330
ffffffffc0204192:	00009517          	auipc	a0,0x9
ffffffffc0204196:	1ee50513          	addi	a0,a0,494 # ffffffffc020d380 <etext+0x1648>
ffffffffc020419a:	ab0fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020419e:	00009697          	auipc	a3,0x9
ffffffffc02041a2:	33a68693          	addi	a3,a3,826 # ffffffffc020d4d8 <etext+0x17a0>
ffffffffc02041a6:	00008617          	auipc	a2,0x8
ffffffffc02041aa:	fca60613          	addi	a2,a2,-54 # ffffffffc020c170 <etext+0x438>
ffffffffc02041ae:	14800593          	li	a1,328
ffffffffc02041b2:	00009517          	auipc	a0,0x9
ffffffffc02041b6:	1ce50513          	addi	a0,a0,462 # ffffffffc020d380 <etext+0x1648>
ffffffffc02041ba:	a90fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02041be:	00009697          	auipc	a3,0x9
ffffffffc02041c2:	2aa68693          	addi	a3,a3,682 # ffffffffc020d468 <etext+0x1730>
ffffffffc02041c6:	00008617          	auipc	a2,0x8
ffffffffc02041ca:	faa60613          	addi	a2,a2,-86 # ffffffffc020c170 <etext+0x438>
ffffffffc02041ce:	13b00593          	li	a1,315
ffffffffc02041d2:	00009517          	auipc	a0,0x9
ffffffffc02041d6:	1ae50513          	addi	a0,a0,430 # ffffffffc020d380 <etext+0x1648>
ffffffffc02041da:	a70fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02041de:	00009697          	auipc	a3,0x9
ffffffffc02041e2:	2ea68693          	addi	a3,a3,746 # ffffffffc020d4c8 <etext+0x1790>
ffffffffc02041e6:	00008617          	auipc	a2,0x8
ffffffffc02041ea:	f8a60613          	addi	a2,a2,-118 # ffffffffc020c170 <etext+0x438>
ffffffffc02041ee:	14600593          	li	a1,326
ffffffffc02041f2:	00009517          	auipc	a0,0x9
ffffffffc02041f6:	18e50513          	addi	a0,a0,398 # ffffffffc020d380 <etext+0x1648>
ffffffffc02041fa:	a50fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02041fe:	00009697          	auipc	a3,0x9
ffffffffc0204202:	2ba68693          	addi	a3,a3,698 # ffffffffc020d4b8 <etext+0x1780>
ffffffffc0204206:	00008617          	auipc	a2,0x8
ffffffffc020420a:	f6a60613          	addi	a2,a2,-150 # ffffffffc020c170 <etext+0x438>
ffffffffc020420e:	14400593          	li	a1,324
ffffffffc0204212:	00009517          	auipc	a0,0x9
ffffffffc0204216:	16e50513          	addi	a0,a0,366 # ffffffffc020d380 <etext+0x1648>
ffffffffc020421a:	a30fc0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020421e:	6914                	ld	a3,16(a0)
ffffffffc0204220:	6510                	ld	a2,8(a0)
ffffffffc0204222:	0004859b          	sext.w	a1,s1
ffffffffc0204226:	00009517          	auipc	a0,0x9
ffffffffc020422a:	34250513          	addi	a0,a0,834 # ffffffffc020d568 <etext+0x1830>
ffffffffc020422e:	f79fb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0204232:	00009697          	auipc	a3,0x9
ffffffffc0204236:	35e68693          	addi	a3,a3,862 # ffffffffc020d590 <etext+0x1858>
ffffffffc020423a:	00008617          	auipc	a2,0x8
ffffffffc020423e:	f3660613          	addi	a2,a2,-202 # ffffffffc020c170 <etext+0x438>
ffffffffc0204242:	15900593          	li	a1,345
ffffffffc0204246:	00009517          	auipc	a0,0x9
ffffffffc020424a:	13a50513          	addi	a0,a0,314 # ffffffffc020d380 <etext+0x1648>
ffffffffc020424e:	9fcfc0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204252 <user_mem_check>:
ffffffffc0204252:	7179                	addi	sp,sp,-48
ffffffffc0204254:	f022                	sd	s0,32(sp)
ffffffffc0204256:	f406                	sd	ra,40(sp)
ffffffffc0204258:	842e                	mv	s0,a1
ffffffffc020425a:	c52d                	beqz	a0,ffffffffc02042c4 <user_mem_check+0x72>
ffffffffc020425c:	002007b7          	lui	a5,0x200
ffffffffc0204260:	04f5ed63          	bltu	a1,a5,ffffffffc02042ba <user_mem_check+0x68>
ffffffffc0204264:	ec26                	sd	s1,24(sp)
ffffffffc0204266:	00c584b3          	add	s1,a1,a2
ffffffffc020426a:	0695ff63          	bgeu	a1,s1,ffffffffc02042e8 <user_mem_check+0x96>
ffffffffc020426e:	4785                	li	a5,1
ffffffffc0204270:	07fe                	slli	a5,a5,0x1f
ffffffffc0204272:	0785                	addi	a5,a5,1 # 200001 <_binary_bin_sfs_img_size+0x18ad01>
ffffffffc0204274:	06f4fa63          	bgeu	s1,a5,ffffffffc02042e8 <user_mem_check+0x96>
ffffffffc0204278:	e84a                	sd	s2,16(sp)
ffffffffc020427a:	e44e                	sd	s3,8(sp)
ffffffffc020427c:	8936                	mv	s2,a3
ffffffffc020427e:	89aa                	mv	s3,a0
ffffffffc0204280:	a829                	j	ffffffffc020429a <user_mem_check+0x48>
ffffffffc0204282:	6685                	lui	a3,0x1
ffffffffc0204284:	9736                	add	a4,a4,a3
ffffffffc0204286:	0027f693          	andi	a3,a5,2
ffffffffc020428a:	8ba1                	andi	a5,a5,8
ffffffffc020428c:	c685                	beqz	a3,ffffffffc02042b4 <user_mem_check+0x62>
ffffffffc020428e:	c399                	beqz	a5,ffffffffc0204294 <user_mem_check+0x42>
ffffffffc0204290:	02e46263          	bltu	s0,a4,ffffffffc02042b4 <user_mem_check+0x62>
ffffffffc0204294:	6900                	ld	s0,16(a0)
ffffffffc0204296:	04947b63          	bgeu	s0,s1,ffffffffc02042ec <user_mem_check+0x9a>
ffffffffc020429a:	85a2                	mv	a1,s0
ffffffffc020429c:	854e                	mv	a0,s3
ffffffffc020429e:	953ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc02042a2:	c909                	beqz	a0,ffffffffc02042b4 <user_mem_check+0x62>
ffffffffc02042a4:	6518                	ld	a4,8(a0)
ffffffffc02042a6:	00e46763          	bltu	s0,a4,ffffffffc02042b4 <user_mem_check+0x62>
ffffffffc02042aa:	4d1c                	lw	a5,24(a0)
ffffffffc02042ac:	fc091be3          	bnez	s2,ffffffffc0204282 <user_mem_check+0x30>
ffffffffc02042b0:	8b85                	andi	a5,a5,1
ffffffffc02042b2:	f3ed                	bnez	a5,ffffffffc0204294 <user_mem_check+0x42>
ffffffffc02042b4:	64e2                	ld	s1,24(sp)
ffffffffc02042b6:	6942                	ld	s2,16(sp)
ffffffffc02042b8:	69a2                	ld	s3,8(sp)
ffffffffc02042ba:	4501                	li	a0,0
ffffffffc02042bc:	70a2                	ld	ra,40(sp)
ffffffffc02042be:	7402                	ld	s0,32(sp)
ffffffffc02042c0:	6145                	addi	sp,sp,48
ffffffffc02042c2:	8082                	ret
ffffffffc02042c4:	c02007b7          	lui	a5,0xc0200
ffffffffc02042c8:	fef5eae3          	bltu	a1,a5,ffffffffc02042bc <user_mem_check+0x6a>
ffffffffc02042cc:	c80007b7          	lui	a5,0xc8000
ffffffffc02042d0:	962e                	add	a2,a2,a1
ffffffffc02042d2:	0785                	addi	a5,a5,1 # ffffffffc8000001 <end+0x7d686e9>
ffffffffc02042d4:	00c5b433          	sltu	s0,a1,a2
ffffffffc02042d8:	00f63633          	sltu	a2,a2,a5
ffffffffc02042dc:	70a2                	ld	ra,40(sp)
ffffffffc02042de:	00867533          	and	a0,a2,s0
ffffffffc02042e2:	7402                	ld	s0,32(sp)
ffffffffc02042e4:	6145                	addi	sp,sp,48
ffffffffc02042e6:	8082                	ret
ffffffffc02042e8:	64e2                	ld	s1,24(sp)
ffffffffc02042ea:	bfc1                	j	ffffffffc02042ba <user_mem_check+0x68>
ffffffffc02042ec:	64e2                	ld	s1,24(sp)
ffffffffc02042ee:	6942                	ld	s2,16(sp)
ffffffffc02042f0:	69a2                	ld	s3,8(sp)
ffffffffc02042f2:	4505                	li	a0,1
ffffffffc02042f4:	b7e1                	j	ffffffffc02042bc <user_mem_check+0x6a>

ffffffffc02042f6 <copy_from_user>:
ffffffffc02042f6:	7179                	addi	sp,sp,-48
ffffffffc02042f8:	f022                	sd	s0,32(sp)
ffffffffc02042fa:	8432                	mv	s0,a2
ffffffffc02042fc:	ec26                	sd	s1,24(sp)
ffffffffc02042fe:	8636                	mv	a2,a3
ffffffffc0204300:	84ae                	mv	s1,a1
ffffffffc0204302:	86ba                	mv	a3,a4
ffffffffc0204304:	85a2                	mv	a1,s0
ffffffffc0204306:	f406                	sd	ra,40(sp)
ffffffffc0204308:	e032                	sd	a2,0(sp)
ffffffffc020430a:	f49ff0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc020430e:	87aa                	mv	a5,a0
ffffffffc0204310:	c901                	beqz	a0,ffffffffc0204320 <copy_from_user+0x2a>
ffffffffc0204312:	6602                	ld	a2,0(sp)
ffffffffc0204314:	e42a                	sd	a0,8(sp)
ffffffffc0204316:	85a2                	mv	a1,s0
ffffffffc0204318:	8526                	mv	a0,s1
ffffffffc020431a:	207070ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc020431e:	67a2                	ld	a5,8(sp)
ffffffffc0204320:	70a2                	ld	ra,40(sp)
ffffffffc0204322:	7402                	ld	s0,32(sp)
ffffffffc0204324:	64e2                	ld	s1,24(sp)
ffffffffc0204326:	853e                	mv	a0,a5
ffffffffc0204328:	6145                	addi	sp,sp,48
ffffffffc020432a:	8082                	ret

ffffffffc020432c <copy_to_user>:
ffffffffc020432c:	7179                	addi	sp,sp,-48
ffffffffc020432e:	f022                	sd	s0,32(sp)
ffffffffc0204330:	8436                	mv	s0,a3
ffffffffc0204332:	e84a                	sd	s2,16(sp)
ffffffffc0204334:	4685                	li	a3,1
ffffffffc0204336:	8932                	mv	s2,a2
ffffffffc0204338:	8622                	mv	a2,s0
ffffffffc020433a:	ec26                	sd	s1,24(sp)
ffffffffc020433c:	f406                	sd	ra,40(sp)
ffffffffc020433e:	84ae                	mv	s1,a1
ffffffffc0204340:	f13ff0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc0204344:	87aa                	mv	a5,a0
ffffffffc0204346:	c901                	beqz	a0,ffffffffc0204356 <copy_to_user+0x2a>
ffffffffc0204348:	e42a                	sd	a0,8(sp)
ffffffffc020434a:	8622                	mv	a2,s0
ffffffffc020434c:	85ca                	mv	a1,s2
ffffffffc020434e:	8526                	mv	a0,s1
ffffffffc0204350:	1d1070ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc0204354:	67a2                	ld	a5,8(sp)
ffffffffc0204356:	70a2                	ld	ra,40(sp)
ffffffffc0204358:	7402                	ld	s0,32(sp)
ffffffffc020435a:	64e2                	ld	s1,24(sp)
ffffffffc020435c:	6942                	ld	s2,16(sp)
ffffffffc020435e:	853e                	mv	a0,a5
ffffffffc0204360:	6145                	addi	sp,sp,48
ffffffffc0204362:	8082                	ret

ffffffffc0204364 <copy_string>:
ffffffffc0204364:	6785                	lui	a5,0x1
ffffffffc0204366:	97b2                	add	a5,a5,a2
ffffffffc0204368:	777d                	lui	a4,0xfffff
ffffffffc020436a:	7139                	addi	sp,sp,-64
ffffffffc020436c:	8ff9                	and	a5,a5,a4
ffffffffc020436e:	f822                	sd	s0,48(sp)
ffffffffc0204370:	f426                	sd	s1,40(sp)
ffffffffc0204372:	ec4e                	sd	s3,24(sp)
ffffffffc0204374:	e456                	sd	s5,8(sp)
ffffffffc0204376:	e05a                	sd	s6,0(sp)
ffffffffc0204378:	fc06                	sd	ra,56(sp)
ffffffffc020437a:	f04a                	sd	s2,32(sp)
ffffffffc020437c:	e852                	sd	s4,16(sp)
ffffffffc020437e:	40c78433          	sub	s0,a5,a2
ffffffffc0204382:	84b2                	mv	s1,a2
ffffffffc0204384:	89b6                	mv	s3,a3
ffffffffc0204386:	8aae                	mv	s5,a1
ffffffffc0204388:	8b2a                	mv	s6,a0
ffffffffc020438a:	0086f363          	bgeu	a3,s0,ffffffffc0204390 <copy_string+0x2c>
ffffffffc020438e:	8436                	mv	s0,a3
ffffffffc0204390:	4901                	li	s2,0
ffffffffc0204392:	e82d                	bnez	s0,ffffffffc0204404 <copy_string+0xa0>
ffffffffc0204394:	4681                	li	a3,0
ffffffffc0204396:	8622                	mv	a2,s0
ffffffffc0204398:	85a6                	mv	a1,s1
ffffffffc020439a:	855a                	mv	a0,s6
ffffffffc020439c:	eb7ff0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc02043a0:	8a2a                	mv	s4,a0
ffffffffc02043a2:	c529                	beqz	a0,ffffffffc02043ec <copy_string+0x88>
ffffffffc02043a4:	8556                	mv	a0,s5
ffffffffc02043a6:	8622                	mv	a2,s0
ffffffffc02043a8:	85a6                	mv	a1,s1
ffffffffc02043aa:	177070ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc02043ae:	9aa2                	add	s5,s5,s0
ffffffffc02043b0:	05246c63          	bltu	s0,s2,ffffffffc0204408 <copy_string+0xa4>
ffffffffc02043b4:	03340c63          	beq	s0,s3,ffffffffc02043ec <copy_string+0x88>
ffffffffc02043b8:	408989b3          	sub	s3,s3,s0
ffffffffc02043bc:	6785                	lui	a5,0x1
ffffffffc02043be:	94a2                	add	s1,s1,s0
ffffffffc02043c0:	894e                	mv	s2,s3
ffffffffc02043c2:	0137f363          	bgeu	a5,s3,ffffffffc02043c8 <copy_string+0x64>
ffffffffc02043c6:	893e                	mv	s2,a5
ffffffffc02043c8:	4401                	li	s0,0
ffffffffc02043ca:	a021                	j	ffffffffc02043d2 <copy_string+0x6e>
ffffffffc02043cc:	0405                	addi	s0,s0,1
ffffffffc02043ce:	fd2403e3          	beq	s0,s2,ffffffffc0204394 <copy_string+0x30>
ffffffffc02043d2:	008487b3          	add	a5,s1,s0
ffffffffc02043d6:	0007c783          	lbu	a5,0(a5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02043da:	fbed                	bnez	a5,ffffffffc02043cc <copy_string+0x68>
ffffffffc02043dc:	4681                	li	a3,0
ffffffffc02043de:	8622                	mv	a2,s0
ffffffffc02043e0:	85a6                	mv	a1,s1
ffffffffc02043e2:	855a                	mv	a0,s6
ffffffffc02043e4:	e6fff0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc02043e8:	8a2a                	mv	s4,a0
ffffffffc02043ea:	fd4d                	bnez	a0,ffffffffc02043a4 <copy_string+0x40>
ffffffffc02043ec:	4a01                	li	s4,0
ffffffffc02043ee:	70e2                	ld	ra,56(sp)
ffffffffc02043f0:	7442                	ld	s0,48(sp)
ffffffffc02043f2:	74a2                	ld	s1,40(sp)
ffffffffc02043f4:	7902                	ld	s2,32(sp)
ffffffffc02043f6:	69e2                	ld	s3,24(sp)
ffffffffc02043f8:	6aa2                	ld	s5,8(sp)
ffffffffc02043fa:	6b02                	ld	s6,0(sp)
ffffffffc02043fc:	8552                	mv	a0,s4
ffffffffc02043fe:	6a42                	ld	s4,16(sp)
ffffffffc0204400:	6121                	addi	sp,sp,64
ffffffffc0204402:	8082                	ret
ffffffffc0204404:	8922                	mv	s2,s0
ffffffffc0204406:	b7c9                	j	ffffffffc02043c8 <copy_string+0x64>
ffffffffc0204408:	ff3402e3          	beq	s0,s3,ffffffffc02043ec <copy_string+0x88>
ffffffffc020440c:	000a8023          	sb	zero,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204410:	bff9                	j	ffffffffc02043ee <copy_string+0x8a>

ffffffffc0204412 <do_pgfault>:
ffffffffc0204412:	7179                	addi	sp,sp,-48
ffffffffc0204414:	85b2                	mv	a1,a2
ffffffffc0204416:	ec26                	sd	s1,24(sp)
ffffffffc0204418:	e432                	sd	a2,8(sp)
ffffffffc020441a:	f406                	sd	ra,40(sp)
ffffffffc020441c:	84aa                	mv	s1,a0
ffffffffc020441e:	fd2ff0ef          	jal	ffffffffc0203bf0 <find_vma>
ffffffffc0204422:	6622                	ld	a2,8(sp)
ffffffffc0204424:	c52d                	beqz	a0,ffffffffc020448e <do_pgfault+0x7c>
ffffffffc0204426:	651c                	ld	a5,8(a0)
ffffffffc0204428:	06f66363          	bltu	a2,a5,ffffffffc020448e <do_pgfault+0x7c>
ffffffffc020442c:	4d1c                	lw	a5,24(a0)
ffffffffc020442e:	f022                	sd	s0,32(sp)
ffffffffc0204430:	475d                	li	a4,23
ffffffffc0204432:	0027f693          	andi	a3,a5,2
ffffffffc0204436:	c2b9                	beqz	a3,ffffffffc020447c <do_pgfault+0x6a>
ffffffffc0204438:	0017f413          	andi	s0,a5,1
ffffffffc020443c:	0014141b          	slliw	s0,s0,0x1
ffffffffc0204440:	8b91                	andi	a5,a5,4
ffffffffc0204442:	8c59                	or	s0,s0,a4
ffffffffc0204444:	eb8d                	bnez	a5,ffffffffc0204476 <do_pgfault+0x64>
ffffffffc0204446:	6c88                	ld	a0,24(s1)
ffffffffc0204448:	77fd                	lui	a5,0xfffff
ffffffffc020444a:	00f675b3          	and	a1,a2,a5
ffffffffc020444e:	4605                	li	a2,1
ffffffffc0204450:	e42e                	sd	a1,8(sp)
ffffffffc0204452:	fa7fd0ef          	jal	ffffffffc02023f8 <get_pte>
ffffffffc0204456:	65a2                	ld	a1,8(sp)
ffffffffc0204458:	cd29                	beqz	a0,ffffffffc02044b2 <do_pgfault+0xa0>
ffffffffc020445a:	611c                	ld	a5,0(a0)
ffffffffc020445c:	e3b1                	bnez	a5,ffffffffc02044a0 <do_pgfault+0x8e>
ffffffffc020445e:	6c88                	ld	a0,24(s1)
ffffffffc0204460:	8622                	mv	a2,s0
ffffffffc0204462:	e6eff0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc0204466:	87aa                	mv	a5,a0
ffffffffc0204468:	4501                	li	a0,0
ffffffffc020446a:	cfa9                	beqz	a5,ffffffffc02044c4 <do_pgfault+0xb2>
ffffffffc020446c:	7402                	ld	s0,32(sp)
ffffffffc020446e:	70a2                	ld	ra,40(sp)
ffffffffc0204470:	64e2                	ld	s1,24(sp)
ffffffffc0204472:	6145                	addi	sp,sp,48
ffffffffc0204474:	8082                	ret
ffffffffc0204476:	00846413          	ori	s0,s0,8
ffffffffc020447a:	b7f1                	j	ffffffffc0204446 <do_pgfault+0x34>
ffffffffc020447c:	0017f413          	andi	s0,a5,1
ffffffffc0204480:	4745                	li	a4,17
ffffffffc0204482:	0014141b          	slliw	s0,s0,0x1
ffffffffc0204486:	8b91                	andi	a5,a5,4
ffffffffc0204488:	8c59                	or	s0,s0,a4
ffffffffc020448a:	dfd5                	beqz	a5,ffffffffc0204446 <do_pgfault+0x34>
ffffffffc020448c:	b7ed                	j	ffffffffc0204476 <do_pgfault+0x64>
ffffffffc020448e:	85b2                	mv	a1,a2
ffffffffc0204490:	00009517          	auipc	a0,0x9
ffffffffc0204494:	15050513          	addi	a0,a0,336 # ffffffffc020d5e0 <etext+0x18a8>
ffffffffc0204498:	d0ffb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020449c:	5575                	li	a0,-3
ffffffffc020449e:	bfc1                	j	ffffffffc020446e <do_pgfault+0x5c>
ffffffffc02044a0:	00009517          	auipc	a0,0x9
ffffffffc02044a4:	1b850513          	addi	a0,a0,440 # ffffffffc020d658 <etext+0x1920>
ffffffffc02044a8:	cfffb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02044ac:	5575                	li	a0,-3
ffffffffc02044ae:	7402                	ld	s0,32(sp)
ffffffffc02044b0:	bf7d                	j	ffffffffc020446e <do_pgfault+0x5c>
ffffffffc02044b2:	00009517          	auipc	a0,0x9
ffffffffc02044b6:	15e50513          	addi	a0,a0,350 # ffffffffc020d610 <etext+0x18d8>
ffffffffc02044ba:	cedfb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02044be:	5575                	li	a0,-3
ffffffffc02044c0:	7402                	ld	s0,32(sp)
ffffffffc02044c2:	b775                	j	ffffffffc020446e <do_pgfault+0x5c>
ffffffffc02044c4:	00009517          	auipc	a0,0x9
ffffffffc02044c8:	16c50513          	addi	a0,a0,364 # ffffffffc020d630 <etext+0x18f8>
ffffffffc02044cc:	cdbfb0ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02044d0:	5575                	li	a0,-3
ffffffffc02044d2:	7402                	ld	s0,32(sp)
ffffffffc02044d4:	bf69                	j	ffffffffc020446e <do_pgfault+0x5c>

ffffffffc02044d6 <__down.constprop.0>:
ffffffffc02044d6:	711d                	addi	sp,sp,-96
ffffffffc02044d8:	ec86                	sd	ra,88(sp)
ffffffffc02044da:	100027f3          	csrr	a5,sstatus
ffffffffc02044de:	8b89                	andi	a5,a5,2
ffffffffc02044e0:	eba1                	bnez	a5,ffffffffc0204530 <__down.constprop.0+0x5a>
ffffffffc02044e2:	411c                	lw	a5,0(a0)
ffffffffc02044e4:	00f05863          	blez	a5,ffffffffc02044f4 <__down.constprop.0+0x1e>
ffffffffc02044e8:	37fd                	addiw	a5,a5,-1 # ffffffffffffefff <end+0x3fd676e7>
ffffffffc02044ea:	c11c                	sw	a5,0(a0)
ffffffffc02044ec:	60e6                	ld	ra,88(sp)
ffffffffc02044ee:	4501                	li	a0,0
ffffffffc02044f0:	6125                	addi	sp,sp,96
ffffffffc02044f2:	8082                	ret
ffffffffc02044f4:	0521                	addi	a0,a0,8
ffffffffc02044f6:	082c                	addi	a1,sp,24
ffffffffc02044f8:	10000613          	li	a2,256
ffffffffc02044fc:	e8a2                	sd	s0,80(sp)
ffffffffc02044fe:	e4a6                	sd	s1,72(sp)
ffffffffc0204500:	0820                	addi	s0,sp,24
ffffffffc0204502:	84aa                	mv	s1,a0
ffffffffc0204504:	2d0000ef          	jal	ffffffffc02047d4 <wait_current_set>
ffffffffc0204508:	510030ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc020450c:	100027f3          	csrr	a5,sstatus
ffffffffc0204510:	8b89                	andi	a5,a5,2
ffffffffc0204512:	efa9                	bnez	a5,ffffffffc020456c <__down.constprop.0+0x96>
ffffffffc0204514:	8522                	mv	a0,s0
ffffffffc0204516:	192000ef          	jal	ffffffffc02046a8 <wait_in_queue>
ffffffffc020451a:	e521                	bnez	a0,ffffffffc0204562 <__down.constprop.0+0x8c>
ffffffffc020451c:	5502                	lw	a0,32(sp)
ffffffffc020451e:	10000793          	li	a5,256
ffffffffc0204522:	6446                	ld	s0,80(sp)
ffffffffc0204524:	64a6                	ld	s1,72(sp)
ffffffffc0204526:	fcf503e3          	beq	a0,a5,ffffffffc02044ec <__down.constprop.0+0x16>
ffffffffc020452a:	60e6                	ld	ra,88(sp)
ffffffffc020452c:	6125                	addi	sp,sp,96
ffffffffc020452e:	8082                	ret
ffffffffc0204530:	e42a                	sd	a0,8(sp)
ffffffffc0204532:	f3efc0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0204536:	6522                	ld	a0,8(sp)
ffffffffc0204538:	411c                	lw	a5,0(a0)
ffffffffc020453a:	00f05763          	blez	a5,ffffffffc0204548 <__down.constprop.0+0x72>
ffffffffc020453e:	37fd                	addiw	a5,a5,-1
ffffffffc0204540:	c11c                	sw	a5,0(a0)
ffffffffc0204542:	f28fc0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0204546:	b75d                	j	ffffffffc02044ec <__down.constprop.0+0x16>
ffffffffc0204548:	0521                	addi	a0,a0,8
ffffffffc020454a:	082c                	addi	a1,sp,24
ffffffffc020454c:	10000613          	li	a2,256
ffffffffc0204550:	e8a2                	sd	s0,80(sp)
ffffffffc0204552:	e4a6                	sd	s1,72(sp)
ffffffffc0204554:	0820                	addi	s0,sp,24
ffffffffc0204556:	84aa                	mv	s1,a0
ffffffffc0204558:	27c000ef          	jal	ffffffffc02047d4 <wait_current_set>
ffffffffc020455c:	f0efc0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0204560:	b765                	j	ffffffffc0204508 <__down.constprop.0+0x32>
ffffffffc0204562:	85a2                	mv	a1,s0
ffffffffc0204564:	8526                	mv	a0,s1
ffffffffc0204566:	0e8000ef          	jal	ffffffffc020464e <wait_queue_del>
ffffffffc020456a:	bf4d                	j	ffffffffc020451c <__down.constprop.0+0x46>
ffffffffc020456c:	f04fc0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0204570:	8522                	mv	a0,s0
ffffffffc0204572:	136000ef          	jal	ffffffffc02046a8 <wait_in_queue>
ffffffffc0204576:	e501                	bnez	a0,ffffffffc020457e <__down.constprop.0+0xa8>
ffffffffc0204578:	ef2fc0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020457c:	b745                	j	ffffffffc020451c <__down.constprop.0+0x46>
ffffffffc020457e:	85a2                	mv	a1,s0
ffffffffc0204580:	8526                	mv	a0,s1
ffffffffc0204582:	0cc000ef          	jal	ffffffffc020464e <wait_queue_del>
ffffffffc0204586:	bfcd                	j	ffffffffc0204578 <__down.constprop.0+0xa2>

ffffffffc0204588 <__up.constprop.0>:
ffffffffc0204588:	1101                	addi	sp,sp,-32
ffffffffc020458a:	e426                	sd	s1,8(sp)
ffffffffc020458c:	ec06                	sd	ra,24(sp)
ffffffffc020458e:	e822                	sd	s0,16(sp)
ffffffffc0204590:	e04a                	sd	s2,0(sp)
ffffffffc0204592:	84aa                	mv	s1,a0
ffffffffc0204594:	100027f3          	csrr	a5,sstatus
ffffffffc0204598:	8b89                	andi	a5,a5,2
ffffffffc020459a:	4901                	li	s2,0
ffffffffc020459c:	e7b1                	bnez	a5,ffffffffc02045e8 <__up.constprop.0+0x60>
ffffffffc020459e:	00848413          	addi	s0,s1,8
ffffffffc02045a2:	8522                	mv	a0,s0
ffffffffc02045a4:	0e8000ef          	jal	ffffffffc020468c <wait_queue_first>
ffffffffc02045a8:	cd05                	beqz	a0,ffffffffc02045e0 <__up.constprop.0+0x58>
ffffffffc02045aa:	6118                	ld	a4,0(a0)
ffffffffc02045ac:	10000793          	li	a5,256
ffffffffc02045b0:	0ec72603          	lw	a2,236(a4) # fffffffffffff0ec <end+0x3fd677d4>
ffffffffc02045b4:	02f61e63          	bne	a2,a5,ffffffffc02045f0 <__up.constprop.0+0x68>
ffffffffc02045b8:	85aa                	mv	a1,a0
ffffffffc02045ba:	4685                	li	a3,1
ffffffffc02045bc:	8522                	mv	a0,s0
ffffffffc02045be:	0f8000ef          	jal	ffffffffc02046b6 <wakeup_wait>
ffffffffc02045c2:	00091863          	bnez	s2,ffffffffc02045d2 <__up.constprop.0+0x4a>
ffffffffc02045c6:	60e2                	ld	ra,24(sp)
ffffffffc02045c8:	6442                	ld	s0,16(sp)
ffffffffc02045ca:	64a2                	ld	s1,8(sp)
ffffffffc02045cc:	6902                	ld	s2,0(sp)
ffffffffc02045ce:	6105                	addi	sp,sp,32
ffffffffc02045d0:	8082                	ret
ffffffffc02045d2:	6442                	ld	s0,16(sp)
ffffffffc02045d4:	60e2                	ld	ra,24(sp)
ffffffffc02045d6:	64a2                	ld	s1,8(sp)
ffffffffc02045d8:	6902                	ld	s2,0(sp)
ffffffffc02045da:	6105                	addi	sp,sp,32
ffffffffc02045dc:	e8efc06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc02045e0:	409c                	lw	a5,0(s1)
ffffffffc02045e2:	2785                	addiw	a5,a5,1
ffffffffc02045e4:	c09c                	sw	a5,0(s1)
ffffffffc02045e6:	bff1                	j	ffffffffc02045c2 <__up.constprop.0+0x3a>
ffffffffc02045e8:	e88fc0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02045ec:	4905                	li	s2,1
ffffffffc02045ee:	bf45                	j	ffffffffc020459e <__up.constprop.0+0x16>
ffffffffc02045f0:	00009697          	auipc	a3,0x9
ffffffffc02045f4:	09068693          	addi	a3,a3,144 # ffffffffc020d680 <etext+0x1948>
ffffffffc02045f8:	00008617          	auipc	a2,0x8
ffffffffc02045fc:	b7860613          	addi	a2,a2,-1160 # ffffffffc020c170 <etext+0x438>
ffffffffc0204600:	45e5                	li	a1,25
ffffffffc0204602:	00009517          	auipc	a0,0x9
ffffffffc0204606:	0a650513          	addi	a0,a0,166 # ffffffffc020d6a8 <etext+0x1970>
ffffffffc020460a:	e41fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020460e <sem_init>:
ffffffffc020460e:	c10c                	sw	a1,0(a0)
ffffffffc0204610:	0521                	addi	a0,a0,8
ffffffffc0204612:	a81d                	j	ffffffffc0204648 <wait_queue_init>

ffffffffc0204614 <up>:
ffffffffc0204614:	f75ff06f          	j	ffffffffc0204588 <__up.constprop.0>

ffffffffc0204618 <down>:
ffffffffc0204618:	1141                	addi	sp,sp,-16
ffffffffc020461a:	e406                	sd	ra,8(sp)
ffffffffc020461c:	ebbff0ef          	jal	ffffffffc02044d6 <__down.constprop.0>
ffffffffc0204620:	e501                	bnez	a0,ffffffffc0204628 <down+0x10>
ffffffffc0204622:	60a2                	ld	ra,8(sp)
ffffffffc0204624:	0141                	addi	sp,sp,16
ffffffffc0204626:	8082                	ret
ffffffffc0204628:	00009697          	auipc	a3,0x9
ffffffffc020462c:	09068693          	addi	a3,a3,144 # ffffffffc020d6b8 <etext+0x1980>
ffffffffc0204630:	00008617          	auipc	a2,0x8
ffffffffc0204634:	b4060613          	addi	a2,a2,-1216 # ffffffffc020c170 <etext+0x438>
ffffffffc0204638:	04000593          	li	a1,64
ffffffffc020463c:	00009517          	auipc	a0,0x9
ffffffffc0204640:	06c50513          	addi	a0,a0,108 # ffffffffc020d6a8 <etext+0x1970>
ffffffffc0204644:	e07fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204648 <wait_queue_init>:
ffffffffc0204648:	e508                	sd	a0,8(a0)
ffffffffc020464a:	e108                	sd	a0,0(a0)
ffffffffc020464c:	8082                	ret

ffffffffc020464e <wait_queue_del>:
ffffffffc020464e:	7198                	ld	a4,32(a1)
ffffffffc0204650:	01858793          	addi	a5,a1,24
ffffffffc0204654:	00e78b63          	beq	a5,a4,ffffffffc020466a <wait_queue_del+0x1c>
ffffffffc0204658:	6994                	ld	a3,16(a1)
ffffffffc020465a:	00a69863          	bne	a3,a0,ffffffffc020466a <wait_queue_del+0x1c>
ffffffffc020465e:	6d94                	ld	a3,24(a1)
ffffffffc0204660:	e698                	sd	a4,8(a3)
ffffffffc0204662:	e314                	sd	a3,0(a4)
ffffffffc0204664:	f19c                	sd	a5,32(a1)
ffffffffc0204666:	ed9c                	sd	a5,24(a1)
ffffffffc0204668:	8082                	ret
ffffffffc020466a:	1141                	addi	sp,sp,-16
ffffffffc020466c:	00009697          	auipc	a3,0x9
ffffffffc0204670:	0ac68693          	addi	a3,a3,172 # ffffffffc020d718 <etext+0x19e0>
ffffffffc0204674:	00008617          	auipc	a2,0x8
ffffffffc0204678:	afc60613          	addi	a2,a2,-1284 # ffffffffc020c170 <etext+0x438>
ffffffffc020467c:	45f1                	li	a1,28
ffffffffc020467e:	00009517          	auipc	a0,0x9
ffffffffc0204682:	08250513          	addi	a0,a0,130 # ffffffffc020d700 <etext+0x19c8>
ffffffffc0204686:	e406                	sd	ra,8(sp)
ffffffffc0204688:	dc3fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020468c <wait_queue_first>:
ffffffffc020468c:	651c                	ld	a5,8(a0)
ffffffffc020468e:	00f50563          	beq	a0,a5,ffffffffc0204698 <wait_queue_first+0xc>
ffffffffc0204692:	fe878513          	addi	a0,a5,-24
ffffffffc0204696:	8082                	ret
ffffffffc0204698:	4501                	li	a0,0
ffffffffc020469a:	8082                	ret

ffffffffc020469c <wait_queue_empty>:
ffffffffc020469c:	651c                	ld	a5,8(a0)
ffffffffc020469e:	40a78533          	sub	a0,a5,a0
ffffffffc02046a2:	00153513          	seqz	a0,a0
ffffffffc02046a6:	8082                	ret

ffffffffc02046a8 <wait_in_queue>:
ffffffffc02046a8:	711c                	ld	a5,32(a0)
ffffffffc02046aa:	0561                	addi	a0,a0,24
ffffffffc02046ac:	40a78533          	sub	a0,a5,a0
ffffffffc02046b0:	00a03533          	snez	a0,a0
ffffffffc02046b4:	8082                	ret

ffffffffc02046b6 <wakeup_wait>:
ffffffffc02046b6:	e689                	bnez	a3,ffffffffc02046c0 <wakeup_wait+0xa>
ffffffffc02046b8:	6188                	ld	a0,0(a1)
ffffffffc02046ba:	c590                	sw	a2,8(a1)
ffffffffc02046bc:	2640306f          	j	ffffffffc0207920 <wakeup_proc>
ffffffffc02046c0:	7198                	ld	a4,32(a1)
ffffffffc02046c2:	01858793          	addi	a5,a1,24
ffffffffc02046c6:	00e78e63          	beq	a5,a4,ffffffffc02046e2 <wakeup_wait+0x2c>
ffffffffc02046ca:	6994                	ld	a3,16(a1)
ffffffffc02046cc:	00d51b63          	bne	a0,a3,ffffffffc02046e2 <wakeup_wait+0x2c>
ffffffffc02046d0:	6d94                	ld	a3,24(a1)
ffffffffc02046d2:	6188                	ld	a0,0(a1)
ffffffffc02046d4:	e698                	sd	a4,8(a3)
ffffffffc02046d6:	e314                	sd	a3,0(a4)
ffffffffc02046d8:	f19c                	sd	a5,32(a1)
ffffffffc02046da:	ed9c                	sd	a5,24(a1)
ffffffffc02046dc:	c590                	sw	a2,8(a1)
ffffffffc02046de:	2420306f          	j	ffffffffc0207920 <wakeup_proc>
ffffffffc02046e2:	1141                	addi	sp,sp,-16
ffffffffc02046e4:	00009697          	auipc	a3,0x9
ffffffffc02046e8:	03468693          	addi	a3,a3,52 # ffffffffc020d718 <etext+0x19e0>
ffffffffc02046ec:	00008617          	auipc	a2,0x8
ffffffffc02046f0:	a8460613          	addi	a2,a2,-1404 # ffffffffc020c170 <etext+0x438>
ffffffffc02046f4:	45f1                	li	a1,28
ffffffffc02046f6:	00009517          	auipc	a0,0x9
ffffffffc02046fa:	00a50513          	addi	a0,a0,10 # ffffffffc020d700 <etext+0x19c8>
ffffffffc02046fe:	e406                	sd	ra,8(sp)
ffffffffc0204700:	d4bfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204704 <wakeup_queue>:
ffffffffc0204704:	651c                	ld	a5,8(a0)
ffffffffc0204706:	0aa78763          	beq	a5,a0,ffffffffc02047b4 <wakeup_queue+0xb0>
ffffffffc020470a:	1101                	addi	sp,sp,-32
ffffffffc020470c:	e822                	sd	s0,16(sp)
ffffffffc020470e:	e426                	sd	s1,8(sp)
ffffffffc0204710:	e04a                	sd	s2,0(sp)
ffffffffc0204712:	ec06                	sd	ra,24(sp)
ffffffffc0204714:	892e                	mv	s2,a1
ffffffffc0204716:	84aa                	mv	s1,a0
ffffffffc0204718:	fe878413          	addi	s0,a5,-24
ffffffffc020471c:	ee29                	bnez	a2,ffffffffc0204776 <wakeup_queue+0x72>
ffffffffc020471e:	6008                	ld	a0,0(s0)
ffffffffc0204720:	01242423          	sw	s2,8(s0)
ffffffffc0204724:	1fc030ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc0204728:	701c                	ld	a5,32(s0)
ffffffffc020472a:	01840713          	addi	a4,s0,24
ffffffffc020472e:	02e78463          	beq	a5,a4,ffffffffc0204756 <wakeup_queue+0x52>
ffffffffc0204732:	6818                	ld	a4,16(s0)
ffffffffc0204734:	02e49163          	bne	s1,a4,ffffffffc0204756 <wakeup_queue+0x52>
ffffffffc0204738:	06f48863          	beq	s1,a5,ffffffffc02047a8 <wakeup_queue+0xa4>
ffffffffc020473c:	fe87b503          	ld	a0,-24(a5)
ffffffffc0204740:	ff27a823          	sw	s2,-16(a5)
ffffffffc0204744:	fe878413          	addi	s0,a5,-24
ffffffffc0204748:	1d8030ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc020474c:	701c                	ld	a5,32(s0)
ffffffffc020474e:	01840713          	addi	a4,s0,24
ffffffffc0204752:	fee790e3          	bne	a5,a4,ffffffffc0204732 <wakeup_queue+0x2e>
ffffffffc0204756:	00009697          	auipc	a3,0x9
ffffffffc020475a:	fc268693          	addi	a3,a3,-62 # ffffffffc020d718 <etext+0x19e0>
ffffffffc020475e:	00008617          	auipc	a2,0x8
ffffffffc0204762:	a1260613          	addi	a2,a2,-1518 # ffffffffc020c170 <etext+0x438>
ffffffffc0204766:	02200593          	li	a1,34
ffffffffc020476a:	00009517          	auipc	a0,0x9
ffffffffc020476e:	f9650513          	addi	a0,a0,-106 # ffffffffc020d700 <etext+0x19c8>
ffffffffc0204772:	cd9fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204776:	6798                	ld	a4,8(a5)
ffffffffc0204778:	00e79863          	bne	a5,a4,ffffffffc0204788 <wakeup_queue+0x84>
ffffffffc020477c:	a82d                	j	ffffffffc02047b6 <wakeup_queue+0xb2>
ffffffffc020477e:	6418                	ld	a4,8(s0)
ffffffffc0204780:	87a2                	mv	a5,s0
ffffffffc0204782:	1421                	addi	s0,s0,-24
ffffffffc0204784:	02e78963          	beq	a5,a4,ffffffffc02047b6 <wakeup_queue+0xb2>
ffffffffc0204788:	6814                	ld	a3,16(s0)
ffffffffc020478a:	02d49663          	bne	s1,a3,ffffffffc02047b6 <wakeup_queue+0xb2>
ffffffffc020478e:	6c14                	ld	a3,24(s0)
ffffffffc0204790:	6008                	ld	a0,0(s0)
ffffffffc0204792:	e698                	sd	a4,8(a3)
ffffffffc0204794:	e314                	sd	a3,0(a4)
ffffffffc0204796:	f01c                	sd	a5,32(s0)
ffffffffc0204798:	ec1c                	sd	a5,24(s0)
ffffffffc020479a:	01242423          	sw	s2,8(s0)
ffffffffc020479e:	182030ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc02047a2:	6480                	ld	s0,8(s1)
ffffffffc02047a4:	fc849de3          	bne	s1,s0,ffffffffc020477e <wakeup_queue+0x7a>
ffffffffc02047a8:	60e2                	ld	ra,24(sp)
ffffffffc02047aa:	6442                	ld	s0,16(sp)
ffffffffc02047ac:	64a2                	ld	s1,8(sp)
ffffffffc02047ae:	6902                	ld	s2,0(sp)
ffffffffc02047b0:	6105                	addi	sp,sp,32
ffffffffc02047b2:	8082                	ret
ffffffffc02047b4:	8082                	ret
ffffffffc02047b6:	00009697          	auipc	a3,0x9
ffffffffc02047ba:	f6268693          	addi	a3,a3,-158 # ffffffffc020d718 <etext+0x19e0>
ffffffffc02047be:	00008617          	auipc	a2,0x8
ffffffffc02047c2:	9b260613          	addi	a2,a2,-1614 # ffffffffc020c170 <etext+0x438>
ffffffffc02047c6:	45f1                	li	a1,28
ffffffffc02047c8:	00009517          	auipc	a0,0x9
ffffffffc02047cc:	f3850513          	addi	a0,a0,-200 # ffffffffc020d700 <etext+0x19c8>
ffffffffc02047d0:	c7bfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02047d4 <wait_current_set>:
ffffffffc02047d4:	00093797          	auipc	a5,0x93
ffffffffc02047d8:	0fc7b783          	ld	a5,252(a5) # ffffffffc02978d0 <current>
ffffffffc02047dc:	c39d                	beqz	a5,ffffffffc0204802 <wait_current_set+0x2e>
ffffffffc02047de:	80000737          	lui	a4,0x80000
ffffffffc02047e2:	c598                	sw	a4,8(a1)
ffffffffc02047e4:	01858713          	addi	a4,a1,24
ffffffffc02047e8:	ed98                	sd	a4,24(a1)
ffffffffc02047ea:	e19c                	sd	a5,0(a1)
ffffffffc02047ec:	0ec7a623          	sw	a2,236(a5)
ffffffffc02047f0:	4605                	li	a2,1
ffffffffc02047f2:	6114                	ld	a3,0(a0)
ffffffffc02047f4:	c390                	sw	a2,0(a5)
ffffffffc02047f6:	e988                	sd	a0,16(a1)
ffffffffc02047f8:	e118                	sd	a4,0(a0)
ffffffffc02047fa:	e698                	sd	a4,8(a3)
ffffffffc02047fc:	ed94                	sd	a3,24(a1)
ffffffffc02047fe:	f188                	sd	a0,32(a1)
ffffffffc0204800:	8082                	ret
ffffffffc0204802:	1141                	addi	sp,sp,-16
ffffffffc0204804:	00009697          	auipc	a3,0x9
ffffffffc0204808:	f5468693          	addi	a3,a3,-172 # ffffffffc020d758 <etext+0x1a20>
ffffffffc020480c:	00008617          	auipc	a2,0x8
ffffffffc0204810:	96460613          	addi	a2,a2,-1692 # ffffffffc020c170 <etext+0x438>
ffffffffc0204814:	07400593          	li	a1,116
ffffffffc0204818:	00009517          	auipc	a0,0x9
ffffffffc020481c:	ee850513          	addi	a0,a0,-280 # ffffffffc020d700 <etext+0x19c8>
ffffffffc0204820:	e406                	sd	ra,8(sp)
ffffffffc0204822:	c29fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204826 <get_fd_array.part.0>:
ffffffffc0204826:	1141                	addi	sp,sp,-16
ffffffffc0204828:	00009697          	auipc	a3,0x9
ffffffffc020482c:	f4068693          	addi	a3,a3,-192 # ffffffffc020d768 <etext+0x1a30>
ffffffffc0204830:	00008617          	auipc	a2,0x8
ffffffffc0204834:	94060613          	addi	a2,a2,-1728 # ffffffffc020c170 <etext+0x438>
ffffffffc0204838:	45d1                	li	a1,20
ffffffffc020483a:	00009517          	auipc	a0,0x9
ffffffffc020483e:	f5e50513          	addi	a0,a0,-162 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204842:	e406                	sd	ra,8(sp)
ffffffffc0204844:	c07fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204848 <fd_array_alloc>:
ffffffffc0204848:	00093797          	auipc	a5,0x93
ffffffffc020484c:	0887b783          	ld	a5,136(a5) # ffffffffc02978d0 <current>
ffffffffc0204850:	1141                	addi	sp,sp,-16
ffffffffc0204852:	e406                	sd	ra,8(sp)
ffffffffc0204854:	1487b783          	ld	a5,328(a5)
ffffffffc0204858:	cfb9                	beqz	a5,ffffffffc02048b6 <fd_array_alloc+0x6e>
ffffffffc020485a:	4b98                	lw	a4,16(a5)
ffffffffc020485c:	04e05d63          	blez	a4,ffffffffc02048b6 <fd_array_alloc+0x6e>
ffffffffc0204860:	775d                	lui	a4,0xffff7
ffffffffc0204862:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd5f1c1>
ffffffffc0204866:	679c                	ld	a5,8(a5)
ffffffffc0204868:	02e50763          	beq	a0,a4,ffffffffc0204896 <fd_array_alloc+0x4e>
ffffffffc020486c:	04700713          	li	a4,71
ffffffffc0204870:	04a76163          	bltu	a4,a0,ffffffffc02048b2 <fd_array_alloc+0x6a>
ffffffffc0204874:	00351713          	slli	a4,a0,0x3
ffffffffc0204878:	8f09                	sub	a4,a4,a0
ffffffffc020487a:	070e                	slli	a4,a4,0x3
ffffffffc020487c:	97ba                	add	a5,a5,a4
ffffffffc020487e:	4398                	lw	a4,0(a5)
ffffffffc0204880:	e71d                	bnez	a4,ffffffffc02048ae <fd_array_alloc+0x66>
ffffffffc0204882:	5b88                	lw	a0,48(a5)
ffffffffc0204884:	e91d                	bnez	a0,ffffffffc02048ba <fd_array_alloc+0x72>
ffffffffc0204886:	4705                	li	a4,1
ffffffffc0204888:	0207b423          	sd	zero,40(a5)
ffffffffc020488c:	c398                	sw	a4,0(a5)
ffffffffc020488e:	e19c                	sd	a5,0(a1)
ffffffffc0204890:	60a2                	ld	ra,8(sp)
ffffffffc0204892:	0141                	addi	sp,sp,16
ffffffffc0204894:	8082                	ret
ffffffffc0204896:	7ff78693          	addi	a3,a5,2047
ffffffffc020489a:	7c168693          	addi	a3,a3,1985
ffffffffc020489e:	4398                	lw	a4,0(a5)
ffffffffc02048a0:	d36d                	beqz	a4,ffffffffc0204882 <fd_array_alloc+0x3a>
ffffffffc02048a2:	03878793          	addi	a5,a5,56
ffffffffc02048a6:	fed79ce3          	bne	a5,a3,ffffffffc020489e <fd_array_alloc+0x56>
ffffffffc02048aa:	5529                	li	a0,-22
ffffffffc02048ac:	b7d5                	j	ffffffffc0204890 <fd_array_alloc+0x48>
ffffffffc02048ae:	5545                	li	a0,-15
ffffffffc02048b0:	b7c5                	j	ffffffffc0204890 <fd_array_alloc+0x48>
ffffffffc02048b2:	5575                	li	a0,-3
ffffffffc02048b4:	bff1                	j	ffffffffc0204890 <fd_array_alloc+0x48>
ffffffffc02048b6:	f71ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>
ffffffffc02048ba:	00009697          	auipc	a3,0x9
ffffffffc02048be:	eee68693          	addi	a3,a3,-274 # ffffffffc020d7a8 <etext+0x1a70>
ffffffffc02048c2:	00008617          	auipc	a2,0x8
ffffffffc02048c6:	8ae60613          	addi	a2,a2,-1874 # ffffffffc020c170 <etext+0x438>
ffffffffc02048ca:	03b00593          	li	a1,59
ffffffffc02048ce:	00009517          	auipc	a0,0x9
ffffffffc02048d2:	eca50513          	addi	a0,a0,-310 # ffffffffc020d798 <etext+0x1a60>
ffffffffc02048d6:	b75fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02048da <fd_array_free>:
ffffffffc02048da:	4118                	lw	a4,0(a0)
ffffffffc02048dc:	1101                	addi	sp,sp,-32
ffffffffc02048de:	ec06                	sd	ra,24(sp)
ffffffffc02048e0:	4685                	li	a3,1
ffffffffc02048e2:	ffd77613          	andi	a2,a4,-3
ffffffffc02048e6:	04d61763          	bne	a2,a3,ffffffffc0204934 <fd_array_free+0x5a>
ffffffffc02048ea:	5914                	lw	a3,48(a0)
ffffffffc02048ec:	87aa                	mv	a5,a0
ffffffffc02048ee:	e29d                	bnez	a3,ffffffffc0204914 <fd_array_free+0x3a>
ffffffffc02048f0:	468d                	li	a3,3
ffffffffc02048f2:	00d70763          	beq	a4,a3,ffffffffc0204900 <fd_array_free+0x26>
ffffffffc02048f6:	60e2                	ld	ra,24(sp)
ffffffffc02048f8:	0007a023          	sw	zero,0(a5)
ffffffffc02048fc:	6105                	addi	sp,sp,32
ffffffffc02048fe:	8082                	ret
ffffffffc0204900:	7508                	ld	a0,40(a0)
ffffffffc0204902:	e43e                	sd	a5,8(sp)
ffffffffc0204904:	757030ef          	jal	ffffffffc020885a <vfs_close>
ffffffffc0204908:	67a2                	ld	a5,8(sp)
ffffffffc020490a:	60e2                	ld	ra,24(sp)
ffffffffc020490c:	0007a023          	sw	zero,0(a5)
ffffffffc0204910:	6105                	addi	sp,sp,32
ffffffffc0204912:	8082                	ret
ffffffffc0204914:	00009697          	auipc	a3,0x9
ffffffffc0204918:	e9468693          	addi	a3,a3,-364 # ffffffffc020d7a8 <etext+0x1a70>
ffffffffc020491c:	00008617          	auipc	a2,0x8
ffffffffc0204920:	85460613          	addi	a2,a2,-1964 # ffffffffc020c170 <etext+0x438>
ffffffffc0204924:	04500593          	li	a1,69
ffffffffc0204928:	00009517          	auipc	a0,0x9
ffffffffc020492c:	e7050513          	addi	a0,a0,-400 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204930:	b1bfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204934:	00009697          	auipc	a3,0x9
ffffffffc0204938:	eac68693          	addi	a3,a3,-340 # ffffffffc020d7e0 <etext+0x1aa8>
ffffffffc020493c:	00008617          	auipc	a2,0x8
ffffffffc0204940:	83460613          	addi	a2,a2,-1996 # ffffffffc020c170 <etext+0x438>
ffffffffc0204944:	04400593          	li	a1,68
ffffffffc0204948:	00009517          	auipc	a0,0x9
ffffffffc020494c:	e5050513          	addi	a0,a0,-432 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204950:	afbfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204954 <fd_array_release>:
ffffffffc0204954:	411c                	lw	a5,0(a0)
ffffffffc0204956:	1141                	addi	sp,sp,-16
ffffffffc0204958:	e406                	sd	ra,8(sp)
ffffffffc020495a:	4685                	li	a3,1
ffffffffc020495c:	37f9                	addiw	a5,a5,-2
ffffffffc020495e:	02f6ef63          	bltu	a3,a5,ffffffffc020499c <fd_array_release+0x48>
ffffffffc0204962:	591c                	lw	a5,48(a0)
ffffffffc0204964:	00f05c63          	blez	a5,ffffffffc020497c <fd_array_release+0x28>
ffffffffc0204968:	37fd                	addiw	a5,a5,-1
ffffffffc020496a:	d91c                	sw	a5,48(a0)
ffffffffc020496c:	c781                	beqz	a5,ffffffffc0204974 <fd_array_release+0x20>
ffffffffc020496e:	60a2                	ld	ra,8(sp)
ffffffffc0204970:	0141                	addi	sp,sp,16
ffffffffc0204972:	8082                	ret
ffffffffc0204974:	60a2                	ld	ra,8(sp)
ffffffffc0204976:	0141                	addi	sp,sp,16
ffffffffc0204978:	f63ff06f          	j	ffffffffc02048da <fd_array_free>
ffffffffc020497c:	00009697          	auipc	a3,0x9
ffffffffc0204980:	ed468693          	addi	a3,a3,-300 # ffffffffc020d850 <etext+0x1b18>
ffffffffc0204984:	00007617          	auipc	a2,0x7
ffffffffc0204988:	7ec60613          	addi	a2,a2,2028 # ffffffffc020c170 <etext+0x438>
ffffffffc020498c:	05600593          	li	a1,86
ffffffffc0204990:	00009517          	auipc	a0,0x9
ffffffffc0204994:	e0850513          	addi	a0,a0,-504 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204998:	ab3fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020499c:	00009697          	auipc	a3,0x9
ffffffffc02049a0:	e7c68693          	addi	a3,a3,-388 # ffffffffc020d818 <etext+0x1ae0>
ffffffffc02049a4:	00007617          	auipc	a2,0x7
ffffffffc02049a8:	7cc60613          	addi	a2,a2,1996 # ffffffffc020c170 <etext+0x438>
ffffffffc02049ac:	05500593          	li	a1,85
ffffffffc02049b0:	00009517          	auipc	a0,0x9
ffffffffc02049b4:	de850513          	addi	a0,a0,-536 # ffffffffc020d798 <etext+0x1a60>
ffffffffc02049b8:	a93fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02049bc <fd_array_open.part.0>:
ffffffffc02049bc:	1141                	addi	sp,sp,-16
ffffffffc02049be:	00009697          	auipc	a3,0x9
ffffffffc02049c2:	eaa68693          	addi	a3,a3,-342 # ffffffffc020d868 <etext+0x1b30>
ffffffffc02049c6:	00007617          	auipc	a2,0x7
ffffffffc02049ca:	7aa60613          	addi	a2,a2,1962 # ffffffffc020c170 <etext+0x438>
ffffffffc02049ce:	05f00593          	li	a1,95
ffffffffc02049d2:	00009517          	auipc	a0,0x9
ffffffffc02049d6:	dc650513          	addi	a0,a0,-570 # ffffffffc020d798 <etext+0x1a60>
ffffffffc02049da:	e406                	sd	ra,8(sp)
ffffffffc02049dc:	a6ffb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02049e0 <fd_array_init>:
ffffffffc02049e0:	4781                	li	a5,0
ffffffffc02049e2:	04800713          	li	a4,72
ffffffffc02049e6:	cd1c                	sw	a5,24(a0)
ffffffffc02049e8:	02052823          	sw	zero,48(a0)
ffffffffc02049ec:	00052023          	sw	zero,0(a0)
ffffffffc02049f0:	2785                	addiw	a5,a5,1
ffffffffc02049f2:	03850513          	addi	a0,a0,56
ffffffffc02049f6:	fee798e3          	bne	a5,a4,ffffffffc02049e6 <fd_array_init+0x6>
ffffffffc02049fa:	8082                	ret

ffffffffc02049fc <fd_array_close>:
ffffffffc02049fc:	4114                	lw	a3,0(a0)
ffffffffc02049fe:	1101                	addi	sp,sp,-32
ffffffffc0204a00:	ec06                	sd	ra,24(sp)
ffffffffc0204a02:	4789                	li	a5,2
ffffffffc0204a04:	04f69863          	bne	a3,a5,ffffffffc0204a54 <fd_array_close+0x58>
ffffffffc0204a08:	591c                	lw	a5,48(a0)
ffffffffc0204a0a:	872a                	mv	a4,a0
ffffffffc0204a0c:	02f05463          	blez	a5,ffffffffc0204a34 <fd_array_close+0x38>
ffffffffc0204a10:	37fd                	addiw	a5,a5,-1
ffffffffc0204a12:	468d                	li	a3,3
ffffffffc0204a14:	d91c                	sw	a5,48(a0)
ffffffffc0204a16:	c114                	sw	a3,0(a0)
ffffffffc0204a18:	c781                	beqz	a5,ffffffffc0204a20 <fd_array_close+0x24>
ffffffffc0204a1a:	60e2                	ld	ra,24(sp)
ffffffffc0204a1c:	6105                	addi	sp,sp,32
ffffffffc0204a1e:	8082                	ret
ffffffffc0204a20:	7508                	ld	a0,40(a0)
ffffffffc0204a22:	e43a                	sd	a4,8(sp)
ffffffffc0204a24:	637030ef          	jal	ffffffffc020885a <vfs_close>
ffffffffc0204a28:	6722                	ld	a4,8(sp)
ffffffffc0204a2a:	60e2                	ld	ra,24(sp)
ffffffffc0204a2c:	00072023          	sw	zero,0(a4)
ffffffffc0204a30:	6105                	addi	sp,sp,32
ffffffffc0204a32:	8082                	ret
ffffffffc0204a34:	00009697          	auipc	a3,0x9
ffffffffc0204a38:	e1c68693          	addi	a3,a3,-484 # ffffffffc020d850 <etext+0x1b18>
ffffffffc0204a3c:	00007617          	auipc	a2,0x7
ffffffffc0204a40:	73460613          	addi	a2,a2,1844 # ffffffffc020c170 <etext+0x438>
ffffffffc0204a44:	06800593          	li	a1,104
ffffffffc0204a48:	00009517          	auipc	a0,0x9
ffffffffc0204a4c:	d5050513          	addi	a0,a0,-688 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204a50:	9fbfb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204a54:	00009697          	auipc	a3,0x9
ffffffffc0204a58:	d6c68693          	addi	a3,a3,-660 # ffffffffc020d7c0 <etext+0x1a88>
ffffffffc0204a5c:	00007617          	auipc	a2,0x7
ffffffffc0204a60:	71460613          	addi	a2,a2,1812 # ffffffffc020c170 <etext+0x438>
ffffffffc0204a64:	06700593          	li	a1,103
ffffffffc0204a68:	00009517          	auipc	a0,0x9
ffffffffc0204a6c:	d3050513          	addi	a0,a0,-720 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204a70:	9dbfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204a74 <fd_array_dup>:
ffffffffc0204a74:	4118                	lw	a4,0(a0)
ffffffffc0204a76:	1101                	addi	sp,sp,-32
ffffffffc0204a78:	ec06                	sd	ra,24(sp)
ffffffffc0204a7a:	e822                	sd	s0,16(sp)
ffffffffc0204a7c:	e426                	sd	s1,8(sp)
ffffffffc0204a7e:	e04a                	sd	s2,0(sp)
ffffffffc0204a80:	4785                	li	a5,1
ffffffffc0204a82:	04f71563          	bne	a4,a5,ffffffffc0204acc <fd_array_dup+0x58>
ffffffffc0204a86:	0005a903          	lw	s2,0(a1)
ffffffffc0204a8a:	4789                	li	a5,2
ffffffffc0204a8c:	04f91063          	bne	s2,a5,ffffffffc0204acc <fd_array_dup+0x58>
ffffffffc0204a90:	719c                	ld	a5,32(a1)
ffffffffc0204a92:	7584                	ld	s1,40(a1)
ffffffffc0204a94:	842a                	mv	s0,a0
ffffffffc0204a96:	f11c                	sd	a5,32(a0)
ffffffffc0204a98:	699c                	ld	a5,16(a1)
ffffffffc0204a9a:	6598                	ld	a4,8(a1)
ffffffffc0204a9c:	8526                	mv	a0,s1
ffffffffc0204a9e:	e81c                	sd	a5,16(s0)
ffffffffc0204aa0:	e418                	sd	a4,8(s0)
ffffffffc0204aa2:	4cc030ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc0204aa6:	8526                	mv	a0,s1
ffffffffc0204aa8:	4d0030ef          	jal	ffffffffc0207f78 <inode_open_inc>
ffffffffc0204aac:	401c                	lw	a5,0(s0)
ffffffffc0204aae:	f404                	sd	s1,40(s0)
ffffffffc0204ab0:	17fd                	addi	a5,a5,-1
ffffffffc0204ab2:	ef8d                	bnez	a5,ffffffffc0204aec <fd_array_dup+0x78>
ffffffffc0204ab4:	cc85                	beqz	s1,ffffffffc0204aec <fd_array_dup+0x78>
ffffffffc0204ab6:	581c                	lw	a5,48(s0)
ffffffffc0204ab8:	01242023          	sw	s2,0(s0)
ffffffffc0204abc:	60e2                	ld	ra,24(sp)
ffffffffc0204abe:	2785                	addiw	a5,a5,1
ffffffffc0204ac0:	d81c                	sw	a5,48(s0)
ffffffffc0204ac2:	6442                	ld	s0,16(sp)
ffffffffc0204ac4:	64a2                	ld	s1,8(sp)
ffffffffc0204ac6:	6902                	ld	s2,0(sp)
ffffffffc0204ac8:	6105                	addi	sp,sp,32
ffffffffc0204aca:	8082                	ret
ffffffffc0204acc:	00009697          	auipc	a3,0x9
ffffffffc0204ad0:	dcc68693          	addi	a3,a3,-564 # ffffffffc020d898 <etext+0x1b60>
ffffffffc0204ad4:	00007617          	auipc	a2,0x7
ffffffffc0204ad8:	69c60613          	addi	a2,a2,1692 # ffffffffc020c170 <etext+0x438>
ffffffffc0204adc:	07300593          	li	a1,115
ffffffffc0204ae0:	00009517          	auipc	a0,0x9
ffffffffc0204ae4:	cb850513          	addi	a0,a0,-840 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204ae8:	963fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204aec:	ed1ff0ef          	jal	ffffffffc02049bc <fd_array_open.part.0>

ffffffffc0204af0 <file_testfd>:
ffffffffc0204af0:	04700793          	li	a5,71
ffffffffc0204af4:	04a7e263          	bltu	a5,a0,ffffffffc0204b38 <file_testfd+0x48>
ffffffffc0204af8:	00093797          	auipc	a5,0x93
ffffffffc0204afc:	dd87b783          	ld	a5,-552(a5) # ffffffffc02978d0 <current>
ffffffffc0204b00:	1487b783          	ld	a5,328(a5)
ffffffffc0204b04:	cf85                	beqz	a5,ffffffffc0204b3c <file_testfd+0x4c>
ffffffffc0204b06:	4b98                	lw	a4,16(a5)
ffffffffc0204b08:	02e05a63          	blez	a4,ffffffffc0204b3c <file_testfd+0x4c>
ffffffffc0204b0c:	6798                	ld	a4,8(a5)
ffffffffc0204b0e:	00351793          	slli	a5,a0,0x3
ffffffffc0204b12:	8f89                	sub	a5,a5,a0
ffffffffc0204b14:	078e                	slli	a5,a5,0x3
ffffffffc0204b16:	97ba                	add	a5,a5,a4
ffffffffc0204b18:	4394                	lw	a3,0(a5)
ffffffffc0204b1a:	4709                	li	a4,2
ffffffffc0204b1c:	00e69e63          	bne	a3,a4,ffffffffc0204b38 <file_testfd+0x48>
ffffffffc0204b20:	4f98                	lw	a4,24(a5)
ffffffffc0204b22:	00a71b63          	bne	a4,a0,ffffffffc0204b38 <file_testfd+0x48>
ffffffffc0204b26:	c199                	beqz	a1,ffffffffc0204b2c <file_testfd+0x3c>
ffffffffc0204b28:	6788                	ld	a0,8(a5)
ffffffffc0204b2a:	c901                	beqz	a0,ffffffffc0204b3a <file_testfd+0x4a>
ffffffffc0204b2c:	4505                	li	a0,1
ffffffffc0204b2e:	c611                	beqz	a2,ffffffffc0204b3a <file_testfd+0x4a>
ffffffffc0204b30:	6b88                	ld	a0,16(a5)
ffffffffc0204b32:	00a03533          	snez	a0,a0
ffffffffc0204b36:	8082                	ret
ffffffffc0204b38:	4501                	li	a0,0
ffffffffc0204b3a:	8082                	ret
ffffffffc0204b3c:	1141                	addi	sp,sp,-16
ffffffffc0204b3e:	e406                	sd	ra,8(sp)
ffffffffc0204b40:	ce7ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0204b44 <file_open>:
ffffffffc0204b44:	0035f793          	andi	a5,a1,3
ffffffffc0204b48:	470d                	li	a4,3
ffffffffc0204b4a:	0ee78563          	beq	a5,a4,ffffffffc0204c34 <file_open+0xf0>
ffffffffc0204b4e:	078e                	slli	a5,a5,0x3
ffffffffc0204b50:	0000b717          	auipc	a4,0xb
ffffffffc0204b54:	90870713          	addi	a4,a4,-1784 # ffffffffc020f458 <CSWTCH.79>
ffffffffc0204b58:	0000b697          	auipc	a3,0xb
ffffffffc0204b5c:	91868693          	addi	a3,a3,-1768 # ffffffffc020f470 <CSWTCH.78>
ffffffffc0204b60:	96be                	add	a3,a3,a5
ffffffffc0204b62:	97ba                	add	a5,a5,a4
ffffffffc0204b64:	7159                	addi	sp,sp,-112
ffffffffc0204b66:	639c                	ld	a5,0(a5)
ffffffffc0204b68:	6298                	ld	a4,0(a3)
ffffffffc0204b6a:	eca6                	sd	s1,88(sp)
ffffffffc0204b6c:	84aa                	mv	s1,a0
ffffffffc0204b6e:	755d                	lui	a0,0xffff7
ffffffffc0204b70:	f0a2                	sd	s0,96(sp)
ffffffffc0204b72:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd5f1c1>
ffffffffc0204b76:	842e                	mv	s0,a1
ffffffffc0204b78:	080c                	addi	a1,sp,16
ffffffffc0204b7a:	e8ca                	sd	s2,80(sp)
ffffffffc0204b7c:	e4ce                	sd	s3,72(sp)
ffffffffc0204b7e:	f486                	sd	ra,104(sp)
ffffffffc0204b80:	89be                	mv	s3,a5
ffffffffc0204b82:	893a                	mv	s2,a4
ffffffffc0204b84:	cc5ff0ef          	jal	ffffffffc0204848 <fd_array_alloc>
ffffffffc0204b88:	87aa                	mv	a5,a0
ffffffffc0204b8a:	c909                	beqz	a0,ffffffffc0204b9c <file_open+0x58>
ffffffffc0204b8c:	70a6                	ld	ra,104(sp)
ffffffffc0204b8e:	7406                	ld	s0,96(sp)
ffffffffc0204b90:	64e6                	ld	s1,88(sp)
ffffffffc0204b92:	6946                	ld	s2,80(sp)
ffffffffc0204b94:	69a6                	ld	s3,72(sp)
ffffffffc0204b96:	853e                	mv	a0,a5
ffffffffc0204b98:	6165                	addi	sp,sp,112
ffffffffc0204b9a:	8082                	ret
ffffffffc0204b9c:	8526                	mv	a0,s1
ffffffffc0204b9e:	0830                	addi	a2,sp,24
ffffffffc0204ba0:	85a2                	mv	a1,s0
ffffffffc0204ba2:	2e3030ef          	jal	ffffffffc0208684 <vfs_open>
ffffffffc0204ba6:	6742                	ld	a4,16(sp)
ffffffffc0204ba8:	e141                	bnez	a0,ffffffffc0204c28 <file_open+0xe4>
ffffffffc0204baa:	02073023          	sd	zero,32(a4)
ffffffffc0204bae:	02047593          	andi	a1,s0,32
ffffffffc0204bb2:	c98d                	beqz	a1,ffffffffc0204be4 <file_open+0xa0>
ffffffffc0204bb4:	6562                	ld	a0,24(sp)
ffffffffc0204bb6:	c541                	beqz	a0,ffffffffc0204c3e <file_open+0xfa>
ffffffffc0204bb8:	793c                	ld	a5,112(a0)
ffffffffc0204bba:	c3d1                	beqz	a5,ffffffffc0204c3e <file_open+0xfa>
ffffffffc0204bbc:	779c                	ld	a5,40(a5)
ffffffffc0204bbe:	c3c1                	beqz	a5,ffffffffc0204c3e <file_open+0xfa>
ffffffffc0204bc0:	00009597          	auipc	a1,0x9
ffffffffc0204bc4:	d6058593          	addi	a1,a1,-672 # ffffffffc020d920 <etext+0x1be8>
ffffffffc0204bc8:	e43a                	sd	a4,8(sp)
ffffffffc0204bca:	e02a                	sd	a0,0(sp)
ffffffffc0204bcc:	3b6030ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0204bd0:	6502                	ld	a0,0(sp)
ffffffffc0204bd2:	100c                	addi	a1,sp,32
ffffffffc0204bd4:	793c                	ld	a5,112(a0)
ffffffffc0204bd6:	6562                	ld	a0,24(sp)
ffffffffc0204bd8:	779c                	ld	a5,40(a5)
ffffffffc0204bda:	9782                	jalr	a5
ffffffffc0204bdc:	6722                	ld	a4,8(sp)
ffffffffc0204bde:	e91d                	bnez	a0,ffffffffc0204c14 <file_open+0xd0>
ffffffffc0204be0:	77e2                	ld	a5,56(sp)
ffffffffc0204be2:	f31c                	sd	a5,32(a4)
ffffffffc0204be4:	66e2                	ld	a3,24(sp)
ffffffffc0204be6:	431c                	lw	a5,0(a4)
ffffffffc0204be8:	01273423          	sd	s2,8(a4)
ffffffffc0204bec:	01373823          	sd	s3,16(a4)
ffffffffc0204bf0:	f714                	sd	a3,40(a4)
ffffffffc0204bf2:	17fd                	addi	a5,a5,-1
ffffffffc0204bf4:	e3b9                	bnez	a5,ffffffffc0204c3a <file_open+0xf6>
ffffffffc0204bf6:	c2b1                	beqz	a3,ffffffffc0204c3a <file_open+0xf6>
ffffffffc0204bf8:	5b1c                	lw	a5,48(a4)
ffffffffc0204bfa:	70a6                	ld	ra,104(sp)
ffffffffc0204bfc:	7406                	ld	s0,96(sp)
ffffffffc0204bfe:	2785                	addiw	a5,a5,1
ffffffffc0204c00:	db1c                	sw	a5,48(a4)
ffffffffc0204c02:	4f1c                	lw	a5,24(a4)
ffffffffc0204c04:	4689                	li	a3,2
ffffffffc0204c06:	c314                	sw	a3,0(a4)
ffffffffc0204c08:	64e6                	ld	s1,88(sp)
ffffffffc0204c0a:	6946                	ld	s2,80(sp)
ffffffffc0204c0c:	69a6                	ld	s3,72(sp)
ffffffffc0204c0e:	853e                	mv	a0,a5
ffffffffc0204c10:	6165                	addi	sp,sp,112
ffffffffc0204c12:	8082                	ret
ffffffffc0204c14:	e42a                	sd	a0,8(sp)
ffffffffc0204c16:	6562                	ld	a0,24(sp)
ffffffffc0204c18:	e03a                	sd	a4,0(sp)
ffffffffc0204c1a:	441030ef          	jal	ffffffffc020885a <vfs_close>
ffffffffc0204c1e:	6502                	ld	a0,0(sp)
ffffffffc0204c20:	cbbff0ef          	jal	ffffffffc02048da <fd_array_free>
ffffffffc0204c24:	67a2                	ld	a5,8(sp)
ffffffffc0204c26:	b79d                	j	ffffffffc0204b8c <file_open+0x48>
ffffffffc0204c28:	e02a                	sd	a0,0(sp)
ffffffffc0204c2a:	853a                	mv	a0,a4
ffffffffc0204c2c:	cafff0ef          	jal	ffffffffc02048da <fd_array_free>
ffffffffc0204c30:	6782                	ld	a5,0(sp)
ffffffffc0204c32:	bfa9                	j	ffffffffc0204b8c <file_open+0x48>
ffffffffc0204c34:	57f5                	li	a5,-3
ffffffffc0204c36:	853e                	mv	a0,a5
ffffffffc0204c38:	8082                	ret
ffffffffc0204c3a:	d83ff0ef          	jal	ffffffffc02049bc <fd_array_open.part.0>
ffffffffc0204c3e:	00009697          	auipc	a3,0x9
ffffffffc0204c42:	c9268693          	addi	a3,a3,-878 # ffffffffc020d8d0 <etext+0x1b98>
ffffffffc0204c46:	00007617          	auipc	a2,0x7
ffffffffc0204c4a:	52a60613          	addi	a2,a2,1322 # ffffffffc020c170 <etext+0x438>
ffffffffc0204c4e:	0b500593          	li	a1,181
ffffffffc0204c52:	00009517          	auipc	a0,0x9
ffffffffc0204c56:	b4650513          	addi	a0,a0,-1210 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204c5a:	ff0fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204c5e <file_close>:
ffffffffc0204c5e:	04700793          	li	a5,71
ffffffffc0204c62:	04a7e663          	bltu	a5,a0,ffffffffc0204cae <file_close+0x50>
ffffffffc0204c66:	00093717          	auipc	a4,0x93
ffffffffc0204c6a:	c6a73703          	ld	a4,-918(a4) # ffffffffc02978d0 <current>
ffffffffc0204c6e:	1141                	addi	sp,sp,-16
ffffffffc0204c70:	e406                	sd	ra,8(sp)
ffffffffc0204c72:	14873703          	ld	a4,328(a4)
ffffffffc0204c76:	87aa                	mv	a5,a0
ffffffffc0204c78:	cf0d                	beqz	a4,ffffffffc0204cb2 <file_close+0x54>
ffffffffc0204c7a:	4b14                	lw	a3,16(a4)
ffffffffc0204c7c:	02d05b63          	blez	a3,ffffffffc0204cb2 <file_close+0x54>
ffffffffc0204c80:	6708                	ld	a0,8(a4)
ffffffffc0204c82:	00379713          	slli	a4,a5,0x3
ffffffffc0204c86:	8f1d                	sub	a4,a4,a5
ffffffffc0204c88:	070e                	slli	a4,a4,0x3
ffffffffc0204c8a:	953a                	add	a0,a0,a4
ffffffffc0204c8c:	4114                	lw	a3,0(a0)
ffffffffc0204c8e:	4709                	li	a4,2
ffffffffc0204c90:	00e69b63          	bne	a3,a4,ffffffffc0204ca6 <file_close+0x48>
ffffffffc0204c94:	4d18                	lw	a4,24(a0)
ffffffffc0204c96:	00f71863          	bne	a4,a5,ffffffffc0204ca6 <file_close+0x48>
ffffffffc0204c9a:	d63ff0ef          	jal	ffffffffc02049fc <fd_array_close>
ffffffffc0204c9e:	60a2                	ld	ra,8(sp)
ffffffffc0204ca0:	4501                	li	a0,0
ffffffffc0204ca2:	0141                	addi	sp,sp,16
ffffffffc0204ca4:	8082                	ret
ffffffffc0204ca6:	60a2                	ld	ra,8(sp)
ffffffffc0204ca8:	5575                	li	a0,-3
ffffffffc0204caa:	0141                	addi	sp,sp,16
ffffffffc0204cac:	8082                	ret
ffffffffc0204cae:	5575                	li	a0,-3
ffffffffc0204cb0:	8082                	ret
ffffffffc0204cb2:	b75ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0204cb6 <file_read>:
ffffffffc0204cb6:	711d                	addi	sp,sp,-96
ffffffffc0204cb8:	ec86                	sd	ra,88(sp)
ffffffffc0204cba:	e0ca                	sd	s2,64(sp)
ffffffffc0204cbc:	0006b023          	sd	zero,0(a3)
ffffffffc0204cc0:	04700793          	li	a5,71
ffffffffc0204cc4:	0aa7ec63          	bltu	a5,a0,ffffffffc0204d7c <file_read+0xc6>
ffffffffc0204cc8:	00093797          	auipc	a5,0x93
ffffffffc0204ccc:	c087b783          	ld	a5,-1016(a5) # ffffffffc02978d0 <current>
ffffffffc0204cd0:	e4a6                	sd	s1,72(sp)
ffffffffc0204cd2:	e8a2                	sd	s0,80(sp)
ffffffffc0204cd4:	1487b783          	ld	a5,328(a5)
ffffffffc0204cd8:	fc4e                	sd	s3,56(sp)
ffffffffc0204cda:	84b6                	mv	s1,a3
ffffffffc0204cdc:	c3f1                	beqz	a5,ffffffffc0204da0 <file_read+0xea>
ffffffffc0204cde:	4b98                	lw	a4,16(a5)
ffffffffc0204ce0:	0ce05063          	blez	a4,ffffffffc0204da0 <file_read+0xea>
ffffffffc0204ce4:	6780                	ld	s0,8(a5)
ffffffffc0204ce6:	00351793          	slli	a5,a0,0x3
ffffffffc0204cea:	8f89                	sub	a5,a5,a0
ffffffffc0204cec:	078e                	slli	a5,a5,0x3
ffffffffc0204cee:	943e                	add	s0,s0,a5
ffffffffc0204cf0:	00042983          	lw	s3,0(s0)
ffffffffc0204cf4:	4789                	li	a5,2
ffffffffc0204cf6:	06f99a63          	bne	s3,a5,ffffffffc0204d6a <file_read+0xb4>
ffffffffc0204cfa:	4c1c                	lw	a5,24(s0)
ffffffffc0204cfc:	06a79763          	bne	a5,a0,ffffffffc0204d6a <file_read+0xb4>
ffffffffc0204d00:	641c                	ld	a5,8(s0)
ffffffffc0204d02:	c7a5                	beqz	a5,ffffffffc0204d6a <file_read+0xb4>
ffffffffc0204d04:	581c                	lw	a5,48(s0)
ffffffffc0204d06:	7014                	ld	a3,32(s0)
ffffffffc0204d08:	0808                	addi	a0,sp,16
ffffffffc0204d0a:	2785                	addiw	a5,a5,1
ffffffffc0204d0c:	d81c                	sw	a5,48(s0)
ffffffffc0204d0e:	7a0000ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc0204d12:	892a                	mv	s2,a0
ffffffffc0204d14:	7408                	ld	a0,40(s0)
ffffffffc0204d16:	c52d                	beqz	a0,ffffffffc0204d80 <file_read+0xca>
ffffffffc0204d18:	793c                	ld	a5,112(a0)
ffffffffc0204d1a:	c3bd                	beqz	a5,ffffffffc0204d80 <file_read+0xca>
ffffffffc0204d1c:	6f9c                	ld	a5,24(a5)
ffffffffc0204d1e:	c3ad                	beqz	a5,ffffffffc0204d80 <file_read+0xca>
ffffffffc0204d20:	00009597          	auipc	a1,0x9
ffffffffc0204d24:	c5858593          	addi	a1,a1,-936 # ffffffffc020d978 <etext+0x1c40>
ffffffffc0204d28:	e42a                	sd	a0,8(sp)
ffffffffc0204d2a:	258030ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0204d2e:	6522                	ld	a0,8(sp)
ffffffffc0204d30:	85ca                	mv	a1,s2
ffffffffc0204d32:	793c                	ld	a5,112(a0)
ffffffffc0204d34:	7408                	ld	a0,40(s0)
ffffffffc0204d36:	6f9c                	ld	a5,24(a5)
ffffffffc0204d38:	9782                	jalr	a5
ffffffffc0204d3a:	01093783          	ld	a5,16(s2)
ffffffffc0204d3e:	01893683          	ld	a3,24(s2)
ffffffffc0204d42:	4018                	lw	a4,0(s0)
ffffffffc0204d44:	892a                	mv	s2,a0
ffffffffc0204d46:	8f95                	sub	a5,a5,a3
ffffffffc0204d48:	01371563          	bne	a4,s3,ffffffffc0204d52 <file_read+0x9c>
ffffffffc0204d4c:	7018                	ld	a4,32(s0)
ffffffffc0204d4e:	973e                	add	a4,a4,a5
ffffffffc0204d50:	f018                	sd	a4,32(s0)
ffffffffc0204d52:	e09c                	sd	a5,0(s1)
ffffffffc0204d54:	8522                	mv	a0,s0
ffffffffc0204d56:	bffff0ef          	jal	ffffffffc0204954 <fd_array_release>
ffffffffc0204d5a:	6446                	ld	s0,80(sp)
ffffffffc0204d5c:	64a6                	ld	s1,72(sp)
ffffffffc0204d5e:	79e2                	ld	s3,56(sp)
ffffffffc0204d60:	60e6                	ld	ra,88(sp)
ffffffffc0204d62:	854a                	mv	a0,s2
ffffffffc0204d64:	6906                	ld	s2,64(sp)
ffffffffc0204d66:	6125                	addi	sp,sp,96
ffffffffc0204d68:	8082                	ret
ffffffffc0204d6a:	6446                	ld	s0,80(sp)
ffffffffc0204d6c:	60e6                	ld	ra,88(sp)
ffffffffc0204d6e:	5975                	li	s2,-3
ffffffffc0204d70:	64a6                	ld	s1,72(sp)
ffffffffc0204d72:	79e2                	ld	s3,56(sp)
ffffffffc0204d74:	854a                	mv	a0,s2
ffffffffc0204d76:	6906                	ld	s2,64(sp)
ffffffffc0204d78:	6125                	addi	sp,sp,96
ffffffffc0204d7a:	8082                	ret
ffffffffc0204d7c:	5975                	li	s2,-3
ffffffffc0204d7e:	b7cd                	j	ffffffffc0204d60 <file_read+0xaa>
ffffffffc0204d80:	00009697          	auipc	a3,0x9
ffffffffc0204d84:	ba868693          	addi	a3,a3,-1112 # ffffffffc020d928 <etext+0x1bf0>
ffffffffc0204d88:	00007617          	auipc	a2,0x7
ffffffffc0204d8c:	3e860613          	addi	a2,a2,1000 # ffffffffc020c170 <etext+0x438>
ffffffffc0204d90:	0de00593          	li	a1,222
ffffffffc0204d94:	00009517          	auipc	a0,0x9
ffffffffc0204d98:	a0450513          	addi	a0,a0,-1532 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204d9c:	eaefb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204da0:	a87ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0204da4 <file_write>:
ffffffffc0204da4:	711d                	addi	sp,sp,-96
ffffffffc0204da6:	ec86                	sd	ra,88(sp)
ffffffffc0204da8:	e0ca                	sd	s2,64(sp)
ffffffffc0204daa:	0006b023          	sd	zero,0(a3)
ffffffffc0204dae:	04700793          	li	a5,71
ffffffffc0204db2:	0aa7ec63          	bltu	a5,a0,ffffffffc0204e6a <file_write+0xc6>
ffffffffc0204db6:	00093797          	auipc	a5,0x93
ffffffffc0204dba:	b1a7b783          	ld	a5,-1254(a5) # ffffffffc02978d0 <current>
ffffffffc0204dbe:	e4a6                	sd	s1,72(sp)
ffffffffc0204dc0:	e8a2                	sd	s0,80(sp)
ffffffffc0204dc2:	1487b783          	ld	a5,328(a5)
ffffffffc0204dc6:	fc4e                	sd	s3,56(sp)
ffffffffc0204dc8:	84b6                	mv	s1,a3
ffffffffc0204dca:	c3f1                	beqz	a5,ffffffffc0204e8e <file_write+0xea>
ffffffffc0204dcc:	4b98                	lw	a4,16(a5)
ffffffffc0204dce:	0ce05063          	blez	a4,ffffffffc0204e8e <file_write+0xea>
ffffffffc0204dd2:	6780                	ld	s0,8(a5)
ffffffffc0204dd4:	00351793          	slli	a5,a0,0x3
ffffffffc0204dd8:	8f89                	sub	a5,a5,a0
ffffffffc0204dda:	078e                	slli	a5,a5,0x3
ffffffffc0204ddc:	943e                	add	s0,s0,a5
ffffffffc0204dde:	00042983          	lw	s3,0(s0)
ffffffffc0204de2:	4789                	li	a5,2
ffffffffc0204de4:	06f99a63          	bne	s3,a5,ffffffffc0204e58 <file_write+0xb4>
ffffffffc0204de8:	4c1c                	lw	a5,24(s0)
ffffffffc0204dea:	06a79763          	bne	a5,a0,ffffffffc0204e58 <file_write+0xb4>
ffffffffc0204dee:	681c                	ld	a5,16(s0)
ffffffffc0204df0:	c7a5                	beqz	a5,ffffffffc0204e58 <file_write+0xb4>
ffffffffc0204df2:	581c                	lw	a5,48(s0)
ffffffffc0204df4:	7014                	ld	a3,32(s0)
ffffffffc0204df6:	0808                	addi	a0,sp,16
ffffffffc0204df8:	2785                	addiw	a5,a5,1
ffffffffc0204dfa:	d81c                	sw	a5,48(s0)
ffffffffc0204dfc:	6b2000ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc0204e00:	892a                	mv	s2,a0
ffffffffc0204e02:	7408                	ld	a0,40(s0)
ffffffffc0204e04:	c52d                	beqz	a0,ffffffffc0204e6e <file_write+0xca>
ffffffffc0204e06:	793c                	ld	a5,112(a0)
ffffffffc0204e08:	c3bd                	beqz	a5,ffffffffc0204e6e <file_write+0xca>
ffffffffc0204e0a:	739c                	ld	a5,32(a5)
ffffffffc0204e0c:	c3ad                	beqz	a5,ffffffffc0204e6e <file_write+0xca>
ffffffffc0204e0e:	00009597          	auipc	a1,0x9
ffffffffc0204e12:	bc258593          	addi	a1,a1,-1086 # ffffffffc020d9d0 <etext+0x1c98>
ffffffffc0204e16:	e42a                	sd	a0,8(sp)
ffffffffc0204e18:	16a030ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0204e1c:	6522                	ld	a0,8(sp)
ffffffffc0204e1e:	85ca                	mv	a1,s2
ffffffffc0204e20:	793c                	ld	a5,112(a0)
ffffffffc0204e22:	7408                	ld	a0,40(s0)
ffffffffc0204e24:	739c                	ld	a5,32(a5)
ffffffffc0204e26:	9782                	jalr	a5
ffffffffc0204e28:	01093783          	ld	a5,16(s2)
ffffffffc0204e2c:	01893683          	ld	a3,24(s2)
ffffffffc0204e30:	4018                	lw	a4,0(s0)
ffffffffc0204e32:	892a                	mv	s2,a0
ffffffffc0204e34:	8f95                	sub	a5,a5,a3
ffffffffc0204e36:	01371563          	bne	a4,s3,ffffffffc0204e40 <file_write+0x9c>
ffffffffc0204e3a:	7018                	ld	a4,32(s0)
ffffffffc0204e3c:	973e                	add	a4,a4,a5
ffffffffc0204e3e:	f018                	sd	a4,32(s0)
ffffffffc0204e40:	e09c                	sd	a5,0(s1)
ffffffffc0204e42:	8522                	mv	a0,s0
ffffffffc0204e44:	b11ff0ef          	jal	ffffffffc0204954 <fd_array_release>
ffffffffc0204e48:	6446                	ld	s0,80(sp)
ffffffffc0204e4a:	64a6                	ld	s1,72(sp)
ffffffffc0204e4c:	79e2                	ld	s3,56(sp)
ffffffffc0204e4e:	60e6                	ld	ra,88(sp)
ffffffffc0204e50:	854a                	mv	a0,s2
ffffffffc0204e52:	6906                	ld	s2,64(sp)
ffffffffc0204e54:	6125                	addi	sp,sp,96
ffffffffc0204e56:	8082                	ret
ffffffffc0204e58:	6446                	ld	s0,80(sp)
ffffffffc0204e5a:	60e6                	ld	ra,88(sp)
ffffffffc0204e5c:	5975                	li	s2,-3
ffffffffc0204e5e:	64a6                	ld	s1,72(sp)
ffffffffc0204e60:	79e2                	ld	s3,56(sp)
ffffffffc0204e62:	854a                	mv	a0,s2
ffffffffc0204e64:	6906                	ld	s2,64(sp)
ffffffffc0204e66:	6125                	addi	sp,sp,96
ffffffffc0204e68:	8082                	ret
ffffffffc0204e6a:	5975                	li	s2,-3
ffffffffc0204e6c:	b7cd                	j	ffffffffc0204e4e <file_write+0xaa>
ffffffffc0204e6e:	00009697          	auipc	a3,0x9
ffffffffc0204e72:	b1268693          	addi	a3,a3,-1262 # ffffffffc020d980 <etext+0x1c48>
ffffffffc0204e76:	00007617          	auipc	a2,0x7
ffffffffc0204e7a:	2fa60613          	addi	a2,a2,762 # ffffffffc020c170 <etext+0x438>
ffffffffc0204e7e:	0f800593          	li	a1,248
ffffffffc0204e82:	00009517          	auipc	a0,0x9
ffffffffc0204e86:	91650513          	addi	a0,a0,-1770 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204e8a:	dc0fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204e8e:	999ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0204e92 <file_seek>:
ffffffffc0204e92:	7139                	addi	sp,sp,-64
ffffffffc0204e94:	fc06                	sd	ra,56(sp)
ffffffffc0204e96:	f426                	sd	s1,40(sp)
ffffffffc0204e98:	04700793          	li	a5,71
ffffffffc0204e9c:	0ca7e563          	bltu	a5,a0,ffffffffc0204f66 <file_seek+0xd4>
ffffffffc0204ea0:	00093797          	auipc	a5,0x93
ffffffffc0204ea4:	a307b783          	ld	a5,-1488(a5) # ffffffffc02978d0 <current>
ffffffffc0204ea8:	f822                	sd	s0,48(sp)
ffffffffc0204eaa:	1487b783          	ld	a5,328(a5)
ffffffffc0204eae:	c3e9                	beqz	a5,ffffffffc0204f70 <file_seek+0xde>
ffffffffc0204eb0:	4b98                	lw	a4,16(a5)
ffffffffc0204eb2:	0ae05f63          	blez	a4,ffffffffc0204f70 <file_seek+0xde>
ffffffffc0204eb6:	6780                	ld	s0,8(a5)
ffffffffc0204eb8:	00351793          	slli	a5,a0,0x3
ffffffffc0204ebc:	8f89                	sub	a5,a5,a0
ffffffffc0204ebe:	078e                	slli	a5,a5,0x3
ffffffffc0204ec0:	943e                	add	s0,s0,a5
ffffffffc0204ec2:	4018                	lw	a4,0(s0)
ffffffffc0204ec4:	4789                	li	a5,2
ffffffffc0204ec6:	0af71263          	bne	a4,a5,ffffffffc0204f6a <file_seek+0xd8>
ffffffffc0204eca:	4c1c                	lw	a5,24(s0)
ffffffffc0204ecc:	f04a                	sd	s2,32(sp)
ffffffffc0204ece:	08a79863          	bne	a5,a0,ffffffffc0204f5e <file_seek+0xcc>
ffffffffc0204ed2:	581c                	lw	a5,48(s0)
ffffffffc0204ed4:	4685                	li	a3,1
ffffffffc0204ed6:	892e                	mv	s2,a1
ffffffffc0204ed8:	2785                	addiw	a5,a5,1
ffffffffc0204eda:	d81c                	sw	a5,48(s0)
ffffffffc0204edc:	06d60d63          	beq	a2,a3,ffffffffc0204f56 <file_seek+0xc4>
ffffffffc0204ee0:	04e60463          	beq	a2,a4,ffffffffc0204f28 <file_seek+0x96>
ffffffffc0204ee4:	54f5                	li	s1,-3
ffffffffc0204ee6:	e61d                	bnez	a2,ffffffffc0204f14 <file_seek+0x82>
ffffffffc0204ee8:	7404                	ld	s1,40(s0)
ffffffffc0204eea:	c4d1                	beqz	s1,ffffffffc0204f76 <file_seek+0xe4>
ffffffffc0204eec:	78bc                	ld	a5,112(s1)
ffffffffc0204eee:	c7c1                	beqz	a5,ffffffffc0204f76 <file_seek+0xe4>
ffffffffc0204ef0:	6fbc                	ld	a5,88(a5)
ffffffffc0204ef2:	c3d1                	beqz	a5,ffffffffc0204f76 <file_seek+0xe4>
ffffffffc0204ef4:	8526                	mv	a0,s1
ffffffffc0204ef6:	00009597          	auipc	a1,0x9
ffffffffc0204efa:	b3258593          	addi	a1,a1,-1230 # ffffffffc020da28 <etext+0x1cf0>
ffffffffc0204efe:	084030ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0204f02:	78bc                	ld	a5,112(s1)
ffffffffc0204f04:	7408                	ld	a0,40(s0)
ffffffffc0204f06:	85ca                	mv	a1,s2
ffffffffc0204f08:	6fbc                	ld	a5,88(a5)
ffffffffc0204f0a:	9782                	jalr	a5
ffffffffc0204f0c:	84aa                	mv	s1,a0
ffffffffc0204f0e:	e119                	bnez	a0,ffffffffc0204f14 <file_seek+0x82>
ffffffffc0204f10:	03243023          	sd	s2,32(s0)
ffffffffc0204f14:	8522                	mv	a0,s0
ffffffffc0204f16:	a3fff0ef          	jal	ffffffffc0204954 <fd_array_release>
ffffffffc0204f1a:	7442                	ld	s0,48(sp)
ffffffffc0204f1c:	7902                	ld	s2,32(sp)
ffffffffc0204f1e:	70e2                	ld	ra,56(sp)
ffffffffc0204f20:	8526                	mv	a0,s1
ffffffffc0204f22:	74a2                	ld	s1,40(sp)
ffffffffc0204f24:	6121                	addi	sp,sp,64
ffffffffc0204f26:	8082                	ret
ffffffffc0204f28:	7404                	ld	s1,40(s0)
ffffffffc0204f2a:	c4b5                	beqz	s1,ffffffffc0204f96 <file_seek+0x104>
ffffffffc0204f2c:	78bc                	ld	a5,112(s1)
ffffffffc0204f2e:	c7a5                	beqz	a5,ffffffffc0204f96 <file_seek+0x104>
ffffffffc0204f30:	779c                	ld	a5,40(a5)
ffffffffc0204f32:	c3b5                	beqz	a5,ffffffffc0204f96 <file_seek+0x104>
ffffffffc0204f34:	8526                	mv	a0,s1
ffffffffc0204f36:	00009597          	auipc	a1,0x9
ffffffffc0204f3a:	9ea58593          	addi	a1,a1,-1558 # ffffffffc020d920 <etext+0x1be8>
ffffffffc0204f3e:	044030ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0204f42:	78bc                	ld	a5,112(s1)
ffffffffc0204f44:	7408                	ld	a0,40(s0)
ffffffffc0204f46:	858a                	mv	a1,sp
ffffffffc0204f48:	779c                	ld	a5,40(a5)
ffffffffc0204f4a:	9782                	jalr	a5
ffffffffc0204f4c:	84aa                	mv	s1,a0
ffffffffc0204f4e:	f179                	bnez	a0,ffffffffc0204f14 <file_seek+0x82>
ffffffffc0204f50:	67e2                	ld	a5,24(sp)
ffffffffc0204f52:	993e                	add	s2,s2,a5
ffffffffc0204f54:	bf51                	j	ffffffffc0204ee8 <file_seek+0x56>
ffffffffc0204f56:	701c                	ld	a5,32(s0)
ffffffffc0204f58:	00f58933          	add	s2,a1,a5
ffffffffc0204f5c:	b771                	j	ffffffffc0204ee8 <file_seek+0x56>
ffffffffc0204f5e:	7442                	ld	s0,48(sp)
ffffffffc0204f60:	7902                	ld	s2,32(sp)
ffffffffc0204f62:	54f5                	li	s1,-3
ffffffffc0204f64:	bf6d                	j	ffffffffc0204f1e <file_seek+0x8c>
ffffffffc0204f66:	54f5                	li	s1,-3
ffffffffc0204f68:	bf5d                	j	ffffffffc0204f1e <file_seek+0x8c>
ffffffffc0204f6a:	7442                	ld	s0,48(sp)
ffffffffc0204f6c:	54f5                	li	s1,-3
ffffffffc0204f6e:	bf45                	j	ffffffffc0204f1e <file_seek+0x8c>
ffffffffc0204f70:	f04a                	sd	s2,32(sp)
ffffffffc0204f72:	8b5ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>
ffffffffc0204f76:	00009697          	auipc	a3,0x9
ffffffffc0204f7a:	a6268693          	addi	a3,a3,-1438 # ffffffffc020d9d8 <etext+0x1ca0>
ffffffffc0204f7e:	00007617          	auipc	a2,0x7
ffffffffc0204f82:	1f260613          	addi	a2,a2,498 # ffffffffc020c170 <etext+0x438>
ffffffffc0204f86:	11a00593          	li	a1,282
ffffffffc0204f8a:	00009517          	auipc	a0,0x9
ffffffffc0204f8e:	80e50513          	addi	a0,a0,-2034 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204f92:	cb8fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0204f96:	00009697          	auipc	a3,0x9
ffffffffc0204f9a:	93a68693          	addi	a3,a3,-1734 # ffffffffc020d8d0 <etext+0x1b98>
ffffffffc0204f9e:	00007617          	auipc	a2,0x7
ffffffffc0204fa2:	1d260613          	addi	a2,a2,466 # ffffffffc020c170 <etext+0x438>
ffffffffc0204fa6:	11200593          	li	a1,274
ffffffffc0204faa:	00008517          	auipc	a0,0x8
ffffffffc0204fae:	7ee50513          	addi	a0,a0,2030 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0204fb2:	c98fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0204fb6 <file_fstat>:
ffffffffc0204fb6:	7179                	addi	sp,sp,-48
ffffffffc0204fb8:	f406                	sd	ra,40(sp)
ffffffffc0204fba:	f022                	sd	s0,32(sp)
ffffffffc0204fbc:	04700793          	li	a5,71
ffffffffc0204fc0:	08a7e363          	bltu	a5,a0,ffffffffc0205046 <file_fstat+0x90>
ffffffffc0204fc4:	00093797          	auipc	a5,0x93
ffffffffc0204fc8:	90c7b783          	ld	a5,-1780(a5) # ffffffffc02978d0 <current>
ffffffffc0204fcc:	ec26                	sd	s1,24(sp)
ffffffffc0204fce:	84ae                	mv	s1,a1
ffffffffc0204fd0:	1487b783          	ld	a5,328(a5)
ffffffffc0204fd4:	cbd9                	beqz	a5,ffffffffc020506a <file_fstat+0xb4>
ffffffffc0204fd6:	4b98                	lw	a4,16(a5)
ffffffffc0204fd8:	08e05963          	blez	a4,ffffffffc020506a <file_fstat+0xb4>
ffffffffc0204fdc:	6780                	ld	s0,8(a5)
ffffffffc0204fde:	00351793          	slli	a5,a0,0x3
ffffffffc0204fe2:	8f89                	sub	a5,a5,a0
ffffffffc0204fe4:	078e                	slli	a5,a5,0x3
ffffffffc0204fe6:	943e                	add	s0,s0,a5
ffffffffc0204fe8:	4018                	lw	a4,0(s0)
ffffffffc0204fea:	4789                	li	a5,2
ffffffffc0204fec:	04f71663          	bne	a4,a5,ffffffffc0205038 <file_fstat+0x82>
ffffffffc0204ff0:	4c1c                	lw	a5,24(s0)
ffffffffc0204ff2:	04a79363          	bne	a5,a0,ffffffffc0205038 <file_fstat+0x82>
ffffffffc0204ff6:	581c                	lw	a5,48(s0)
ffffffffc0204ff8:	7408                	ld	a0,40(s0)
ffffffffc0204ffa:	2785                	addiw	a5,a5,1
ffffffffc0204ffc:	d81c                	sw	a5,48(s0)
ffffffffc0204ffe:	c531                	beqz	a0,ffffffffc020504a <file_fstat+0x94>
ffffffffc0205000:	793c                	ld	a5,112(a0)
ffffffffc0205002:	c7a1                	beqz	a5,ffffffffc020504a <file_fstat+0x94>
ffffffffc0205004:	779c                	ld	a5,40(a5)
ffffffffc0205006:	c3b1                	beqz	a5,ffffffffc020504a <file_fstat+0x94>
ffffffffc0205008:	00009597          	auipc	a1,0x9
ffffffffc020500c:	91858593          	addi	a1,a1,-1768 # ffffffffc020d920 <etext+0x1be8>
ffffffffc0205010:	e42a                	sd	a0,8(sp)
ffffffffc0205012:	771020ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0205016:	6522                	ld	a0,8(sp)
ffffffffc0205018:	85a6                	mv	a1,s1
ffffffffc020501a:	793c                	ld	a5,112(a0)
ffffffffc020501c:	7408                	ld	a0,40(s0)
ffffffffc020501e:	779c                	ld	a5,40(a5)
ffffffffc0205020:	9782                	jalr	a5
ffffffffc0205022:	87aa                	mv	a5,a0
ffffffffc0205024:	8522                	mv	a0,s0
ffffffffc0205026:	843e                	mv	s0,a5
ffffffffc0205028:	92dff0ef          	jal	ffffffffc0204954 <fd_array_release>
ffffffffc020502c:	64e2                	ld	s1,24(sp)
ffffffffc020502e:	70a2                	ld	ra,40(sp)
ffffffffc0205030:	8522                	mv	a0,s0
ffffffffc0205032:	7402                	ld	s0,32(sp)
ffffffffc0205034:	6145                	addi	sp,sp,48
ffffffffc0205036:	8082                	ret
ffffffffc0205038:	5475                	li	s0,-3
ffffffffc020503a:	70a2                	ld	ra,40(sp)
ffffffffc020503c:	8522                	mv	a0,s0
ffffffffc020503e:	7402                	ld	s0,32(sp)
ffffffffc0205040:	64e2                	ld	s1,24(sp)
ffffffffc0205042:	6145                	addi	sp,sp,48
ffffffffc0205044:	8082                	ret
ffffffffc0205046:	5475                	li	s0,-3
ffffffffc0205048:	b7dd                	j	ffffffffc020502e <file_fstat+0x78>
ffffffffc020504a:	00009697          	auipc	a3,0x9
ffffffffc020504e:	88668693          	addi	a3,a3,-1914 # ffffffffc020d8d0 <etext+0x1b98>
ffffffffc0205052:	00007617          	auipc	a2,0x7
ffffffffc0205056:	11e60613          	addi	a2,a2,286 # ffffffffc020c170 <etext+0x438>
ffffffffc020505a:	12c00593          	li	a1,300
ffffffffc020505e:	00008517          	auipc	a0,0x8
ffffffffc0205062:	73a50513          	addi	a0,a0,1850 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0205066:	be4fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020506a:	fbcff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc020506e <file_fsync>:
ffffffffc020506e:	1101                	addi	sp,sp,-32
ffffffffc0205070:	ec06                	sd	ra,24(sp)
ffffffffc0205072:	e822                	sd	s0,16(sp)
ffffffffc0205074:	04700793          	li	a5,71
ffffffffc0205078:	06a7e863          	bltu	a5,a0,ffffffffc02050e8 <file_fsync+0x7a>
ffffffffc020507c:	00093797          	auipc	a5,0x93
ffffffffc0205080:	8547b783          	ld	a5,-1964(a5) # ffffffffc02978d0 <current>
ffffffffc0205084:	1487b783          	ld	a5,328(a5)
ffffffffc0205088:	c7d1                	beqz	a5,ffffffffc0205114 <file_fsync+0xa6>
ffffffffc020508a:	4b98                	lw	a4,16(a5)
ffffffffc020508c:	08e05463          	blez	a4,ffffffffc0205114 <file_fsync+0xa6>
ffffffffc0205090:	6780                	ld	s0,8(a5)
ffffffffc0205092:	00351793          	slli	a5,a0,0x3
ffffffffc0205096:	8f89                	sub	a5,a5,a0
ffffffffc0205098:	078e                	slli	a5,a5,0x3
ffffffffc020509a:	943e                	add	s0,s0,a5
ffffffffc020509c:	4018                	lw	a4,0(s0)
ffffffffc020509e:	4789                	li	a5,2
ffffffffc02050a0:	04f71463          	bne	a4,a5,ffffffffc02050e8 <file_fsync+0x7a>
ffffffffc02050a4:	4c1c                	lw	a5,24(s0)
ffffffffc02050a6:	04a79163          	bne	a5,a0,ffffffffc02050e8 <file_fsync+0x7a>
ffffffffc02050aa:	581c                	lw	a5,48(s0)
ffffffffc02050ac:	7408                	ld	a0,40(s0)
ffffffffc02050ae:	2785                	addiw	a5,a5,1
ffffffffc02050b0:	d81c                	sw	a5,48(s0)
ffffffffc02050b2:	c129                	beqz	a0,ffffffffc02050f4 <file_fsync+0x86>
ffffffffc02050b4:	793c                	ld	a5,112(a0)
ffffffffc02050b6:	cf9d                	beqz	a5,ffffffffc02050f4 <file_fsync+0x86>
ffffffffc02050b8:	7b9c                	ld	a5,48(a5)
ffffffffc02050ba:	cf8d                	beqz	a5,ffffffffc02050f4 <file_fsync+0x86>
ffffffffc02050bc:	00009597          	auipc	a1,0x9
ffffffffc02050c0:	9c458593          	addi	a1,a1,-1596 # ffffffffc020da80 <etext+0x1d48>
ffffffffc02050c4:	e42a                	sd	a0,8(sp)
ffffffffc02050c6:	6bd020ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc02050ca:	6522                	ld	a0,8(sp)
ffffffffc02050cc:	793c                	ld	a5,112(a0)
ffffffffc02050ce:	7408                	ld	a0,40(s0)
ffffffffc02050d0:	7b9c                	ld	a5,48(a5)
ffffffffc02050d2:	9782                	jalr	a5
ffffffffc02050d4:	87aa                	mv	a5,a0
ffffffffc02050d6:	8522                	mv	a0,s0
ffffffffc02050d8:	843e                	mv	s0,a5
ffffffffc02050da:	87bff0ef          	jal	ffffffffc0204954 <fd_array_release>
ffffffffc02050de:	60e2                	ld	ra,24(sp)
ffffffffc02050e0:	8522                	mv	a0,s0
ffffffffc02050e2:	6442                	ld	s0,16(sp)
ffffffffc02050e4:	6105                	addi	sp,sp,32
ffffffffc02050e6:	8082                	ret
ffffffffc02050e8:	5475                	li	s0,-3
ffffffffc02050ea:	60e2                	ld	ra,24(sp)
ffffffffc02050ec:	8522                	mv	a0,s0
ffffffffc02050ee:	6442                	ld	s0,16(sp)
ffffffffc02050f0:	6105                	addi	sp,sp,32
ffffffffc02050f2:	8082                	ret
ffffffffc02050f4:	00009697          	auipc	a3,0x9
ffffffffc02050f8:	93c68693          	addi	a3,a3,-1732 # ffffffffc020da30 <etext+0x1cf8>
ffffffffc02050fc:	00007617          	auipc	a2,0x7
ffffffffc0205100:	07460613          	addi	a2,a2,116 # ffffffffc020c170 <etext+0x438>
ffffffffc0205104:	13a00593          	li	a1,314
ffffffffc0205108:	00008517          	auipc	a0,0x8
ffffffffc020510c:	69050513          	addi	a0,a0,1680 # ffffffffc020d798 <etext+0x1a60>
ffffffffc0205110:	b3afb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205114:	f12ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0205118 <file_getdirentry>:
ffffffffc0205118:	715d                	addi	sp,sp,-80
ffffffffc020511a:	e486                	sd	ra,72(sp)
ffffffffc020511c:	f84a                	sd	s2,48(sp)
ffffffffc020511e:	04700793          	li	a5,71
ffffffffc0205122:	0aa7e963          	bltu	a5,a0,ffffffffc02051d4 <file_getdirentry+0xbc>
ffffffffc0205126:	00092797          	auipc	a5,0x92
ffffffffc020512a:	7aa7b783          	ld	a5,1962(a5) # ffffffffc02978d0 <current>
ffffffffc020512e:	fc26                	sd	s1,56(sp)
ffffffffc0205130:	e0a2                	sd	s0,64(sp)
ffffffffc0205132:	1487b783          	ld	a5,328(a5)
ffffffffc0205136:	84ae                	mv	s1,a1
ffffffffc0205138:	c7e1                	beqz	a5,ffffffffc0205200 <file_getdirentry+0xe8>
ffffffffc020513a:	4b98                	lw	a4,16(a5)
ffffffffc020513c:	0ce05263          	blez	a4,ffffffffc0205200 <file_getdirentry+0xe8>
ffffffffc0205140:	6780                	ld	s0,8(a5)
ffffffffc0205142:	00351793          	slli	a5,a0,0x3
ffffffffc0205146:	8f89                	sub	a5,a5,a0
ffffffffc0205148:	078e                	slli	a5,a5,0x3
ffffffffc020514a:	943e                	add	s0,s0,a5
ffffffffc020514c:	4018                	lw	a4,0(s0)
ffffffffc020514e:	4789                	li	a5,2
ffffffffc0205150:	08f71463          	bne	a4,a5,ffffffffc02051d8 <file_getdirentry+0xc0>
ffffffffc0205154:	4c1c                	lw	a5,24(s0)
ffffffffc0205156:	f44e                	sd	s3,40(sp)
ffffffffc0205158:	06a79963          	bne	a5,a0,ffffffffc02051ca <file_getdirentry+0xb2>
ffffffffc020515c:	581c                	lw	a5,48(s0)
ffffffffc020515e:	6194                	ld	a3,0(a1)
ffffffffc0205160:	10000613          	li	a2,256
ffffffffc0205164:	2785                	addiw	a5,a5,1
ffffffffc0205166:	d81c                	sw	a5,48(s0)
ffffffffc0205168:	05a1                	addi	a1,a1,8
ffffffffc020516a:	850a                	mv	a0,sp
ffffffffc020516c:	342000ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc0205170:	02843903          	ld	s2,40(s0)
ffffffffc0205174:	89aa                	mv	s3,a0
ffffffffc0205176:	06090563          	beqz	s2,ffffffffc02051e0 <file_getdirentry+0xc8>
ffffffffc020517a:	07093783          	ld	a5,112(s2)
ffffffffc020517e:	c3ad                	beqz	a5,ffffffffc02051e0 <file_getdirentry+0xc8>
ffffffffc0205180:	63bc                	ld	a5,64(a5)
ffffffffc0205182:	cfb9                	beqz	a5,ffffffffc02051e0 <file_getdirentry+0xc8>
ffffffffc0205184:	854a                	mv	a0,s2
ffffffffc0205186:	00009597          	auipc	a1,0x9
ffffffffc020518a:	95a58593          	addi	a1,a1,-1702 # ffffffffc020dae0 <etext+0x1da8>
ffffffffc020518e:	5f5020ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0205192:	07093783          	ld	a5,112(s2)
ffffffffc0205196:	7408                	ld	a0,40(s0)
ffffffffc0205198:	85ce                	mv	a1,s3
ffffffffc020519a:	63bc                	ld	a5,64(a5)
ffffffffc020519c:	9782                	jalr	a5
ffffffffc020519e:	892a                	mv	s2,a0
ffffffffc02051a0:	cd01                	beqz	a0,ffffffffc02051b8 <file_getdirentry+0xa0>
ffffffffc02051a2:	8522                	mv	a0,s0
ffffffffc02051a4:	fb0ff0ef          	jal	ffffffffc0204954 <fd_array_release>
ffffffffc02051a8:	6406                	ld	s0,64(sp)
ffffffffc02051aa:	74e2                	ld	s1,56(sp)
ffffffffc02051ac:	79a2                	ld	s3,40(sp)
ffffffffc02051ae:	60a6                	ld	ra,72(sp)
ffffffffc02051b0:	854a                	mv	a0,s2
ffffffffc02051b2:	7942                	ld	s2,48(sp)
ffffffffc02051b4:	6161                	addi	sp,sp,80
ffffffffc02051b6:	8082                	ret
ffffffffc02051b8:	609c                	ld	a5,0(s1)
ffffffffc02051ba:	0109b683          	ld	a3,16(s3)
ffffffffc02051be:	0189b703          	ld	a4,24(s3)
ffffffffc02051c2:	97b6                	add	a5,a5,a3
ffffffffc02051c4:	8f99                	sub	a5,a5,a4
ffffffffc02051c6:	e09c                	sd	a5,0(s1)
ffffffffc02051c8:	bfe9                	j	ffffffffc02051a2 <file_getdirentry+0x8a>
ffffffffc02051ca:	6406                	ld	s0,64(sp)
ffffffffc02051cc:	74e2                	ld	s1,56(sp)
ffffffffc02051ce:	79a2                	ld	s3,40(sp)
ffffffffc02051d0:	5975                	li	s2,-3
ffffffffc02051d2:	bff1                	j	ffffffffc02051ae <file_getdirentry+0x96>
ffffffffc02051d4:	5975                	li	s2,-3
ffffffffc02051d6:	bfe1                	j	ffffffffc02051ae <file_getdirentry+0x96>
ffffffffc02051d8:	6406                	ld	s0,64(sp)
ffffffffc02051da:	74e2                	ld	s1,56(sp)
ffffffffc02051dc:	5975                	li	s2,-3
ffffffffc02051de:	bfc1                	j	ffffffffc02051ae <file_getdirentry+0x96>
ffffffffc02051e0:	00009697          	auipc	a3,0x9
ffffffffc02051e4:	8a868693          	addi	a3,a3,-1880 # ffffffffc020da88 <etext+0x1d50>
ffffffffc02051e8:	00007617          	auipc	a2,0x7
ffffffffc02051ec:	f8860613          	addi	a2,a2,-120 # ffffffffc020c170 <etext+0x438>
ffffffffc02051f0:	14a00593          	li	a1,330
ffffffffc02051f4:	00008517          	auipc	a0,0x8
ffffffffc02051f8:	5a450513          	addi	a0,a0,1444 # ffffffffc020d798 <etext+0x1a60>
ffffffffc02051fc:	a4efb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205200:	f44e                	sd	s3,40(sp)
ffffffffc0205202:	e24ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0205206 <file_dup>:
ffffffffc0205206:	04700713          	li	a4,71
ffffffffc020520a:	06a76263          	bltu	a4,a0,ffffffffc020526e <file_dup+0x68>
ffffffffc020520e:	00092717          	auipc	a4,0x92
ffffffffc0205212:	6c273703          	ld	a4,1730(a4) # ffffffffc02978d0 <current>
ffffffffc0205216:	7179                	addi	sp,sp,-48
ffffffffc0205218:	f406                	sd	ra,40(sp)
ffffffffc020521a:	14873703          	ld	a4,328(a4)
ffffffffc020521e:	f022                	sd	s0,32(sp)
ffffffffc0205220:	87aa                	mv	a5,a0
ffffffffc0205222:	852e                	mv	a0,a1
ffffffffc0205224:	c739                	beqz	a4,ffffffffc0205272 <file_dup+0x6c>
ffffffffc0205226:	4b14                	lw	a3,16(a4)
ffffffffc0205228:	04d05563          	blez	a3,ffffffffc0205272 <file_dup+0x6c>
ffffffffc020522c:	6700                	ld	s0,8(a4)
ffffffffc020522e:	00379713          	slli	a4,a5,0x3
ffffffffc0205232:	8f1d                	sub	a4,a4,a5
ffffffffc0205234:	070e                	slli	a4,a4,0x3
ffffffffc0205236:	943a                	add	s0,s0,a4
ffffffffc0205238:	4014                	lw	a3,0(s0)
ffffffffc020523a:	4709                	li	a4,2
ffffffffc020523c:	02e69463          	bne	a3,a4,ffffffffc0205264 <file_dup+0x5e>
ffffffffc0205240:	4c18                	lw	a4,24(s0)
ffffffffc0205242:	02f71163          	bne	a4,a5,ffffffffc0205264 <file_dup+0x5e>
ffffffffc0205246:	082c                	addi	a1,sp,24
ffffffffc0205248:	e00ff0ef          	jal	ffffffffc0204848 <fd_array_alloc>
ffffffffc020524c:	e901                	bnez	a0,ffffffffc020525c <file_dup+0x56>
ffffffffc020524e:	6562                	ld	a0,24(sp)
ffffffffc0205250:	85a2                	mv	a1,s0
ffffffffc0205252:	e42a                	sd	a0,8(sp)
ffffffffc0205254:	821ff0ef          	jal	ffffffffc0204a74 <fd_array_dup>
ffffffffc0205258:	6522                	ld	a0,8(sp)
ffffffffc020525a:	4d08                	lw	a0,24(a0)
ffffffffc020525c:	70a2                	ld	ra,40(sp)
ffffffffc020525e:	7402                	ld	s0,32(sp)
ffffffffc0205260:	6145                	addi	sp,sp,48
ffffffffc0205262:	8082                	ret
ffffffffc0205264:	70a2                	ld	ra,40(sp)
ffffffffc0205266:	7402                	ld	s0,32(sp)
ffffffffc0205268:	5575                	li	a0,-3
ffffffffc020526a:	6145                	addi	sp,sp,48
ffffffffc020526c:	8082                	ret
ffffffffc020526e:	5575                	li	a0,-3
ffffffffc0205270:	8082                	ret
ffffffffc0205272:	db4ff0ef          	jal	ffffffffc0204826 <get_fd_array.part.0>

ffffffffc0205276 <fs_init>:
ffffffffc0205276:	1141                	addi	sp,sp,-16
ffffffffc0205278:	e406                	sd	ra,8(sp)
ffffffffc020527a:	713020ef          	jal	ffffffffc020818c <vfs_init>
ffffffffc020527e:	421030ef          	jal	ffffffffc0208e9e <dev_init>
ffffffffc0205282:	60a2                	ld	ra,8(sp)
ffffffffc0205284:	0141                	addi	sp,sp,16
ffffffffc0205286:	5940406f          	j	ffffffffc020981a <sfs_init>

ffffffffc020528a <fs_cleanup>:
ffffffffc020528a:	17e0306f          	j	ffffffffc0208408 <vfs_cleanup>

ffffffffc020528e <lock_files>:
ffffffffc020528e:	0561                	addi	a0,a0,24
ffffffffc0205290:	b88ff06f          	j	ffffffffc0204618 <down>

ffffffffc0205294 <unlock_files>:
ffffffffc0205294:	0561                	addi	a0,a0,24
ffffffffc0205296:	b7eff06f          	j	ffffffffc0204614 <up>

ffffffffc020529a <files_create>:
ffffffffc020529a:	1141                	addi	sp,sp,-16
ffffffffc020529c:	6505                	lui	a0,0x1
ffffffffc020529e:	e022                	sd	s0,0(sp)
ffffffffc02052a0:	e406                	sd	ra,8(sp)
ffffffffc02052a2:	ee7fc0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc02052a6:	842a                	mv	s0,a0
ffffffffc02052a8:	cd19                	beqz	a0,ffffffffc02052c6 <files_create+0x2c>
ffffffffc02052aa:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02052ae:	e51c                	sd	a5,8(a0)
ffffffffc02052b0:	00053023          	sd	zero,0(a0)
ffffffffc02052b4:	00052823          	sw	zero,16(a0)
ffffffffc02052b8:	4585                	li	a1,1
ffffffffc02052ba:	0561                	addi	a0,a0,24
ffffffffc02052bc:	b52ff0ef          	jal	ffffffffc020460e <sem_init>
ffffffffc02052c0:	6408                	ld	a0,8(s0)
ffffffffc02052c2:	f1eff0ef          	jal	ffffffffc02049e0 <fd_array_init>
ffffffffc02052c6:	60a2                	ld	ra,8(sp)
ffffffffc02052c8:	8522                	mv	a0,s0
ffffffffc02052ca:	6402                	ld	s0,0(sp)
ffffffffc02052cc:	0141                	addi	sp,sp,16
ffffffffc02052ce:	8082                	ret

ffffffffc02052d0 <files_destroy>:
ffffffffc02052d0:	7179                	addi	sp,sp,-48
ffffffffc02052d2:	f406                	sd	ra,40(sp)
ffffffffc02052d4:	f022                	sd	s0,32(sp)
ffffffffc02052d6:	ec26                	sd	s1,24(sp)
ffffffffc02052d8:	e84a                	sd	s2,16(sp)
ffffffffc02052da:	e44e                	sd	s3,8(sp)
ffffffffc02052dc:	c52d                	beqz	a0,ffffffffc0205346 <files_destroy+0x76>
ffffffffc02052de:	491c                	lw	a5,16(a0)
ffffffffc02052e0:	89aa                	mv	s3,a0
ffffffffc02052e2:	e3b5                	bnez	a5,ffffffffc0205346 <files_destroy+0x76>
ffffffffc02052e4:	6108                	ld	a0,0(a0)
ffffffffc02052e6:	c119                	beqz	a0,ffffffffc02052ec <files_destroy+0x1c>
ffffffffc02052e8:	555020ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc02052ec:	0089b403          	ld	s0,8(s3)
ffffffffc02052f0:	4909                	li	s2,2
ffffffffc02052f2:	7ff40493          	addi	s1,s0,2047
ffffffffc02052f6:	7c148493          	addi	s1,s1,1985
ffffffffc02052fa:	401c                	lw	a5,0(s0)
ffffffffc02052fc:	03278063          	beq	a5,s2,ffffffffc020531c <files_destroy+0x4c>
ffffffffc0205300:	e39d                	bnez	a5,ffffffffc0205326 <files_destroy+0x56>
ffffffffc0205302:	03840413          	addi	s0,s0,56
ffffffffc0205306:	fe941ae3          	bne	s0,s1,ffffffffc02052fa <files_destroy+0x2a>
ffffffffc020530a:	7402                	ld	s0,32(sp)
ffffffffc020530c:	70a2                	ld	ra,40(sp)
ffffffffc020530e:	64e2                	ld	s1,24(sp)
ffffffffc0205310:	6942                	ld	s2,16(sp)
ffffffffc0205312:	854e                	mv	a0,s3
ffffffffc0205314:	69a2                	ld	s3,8(sp)
ffffffffc0205316:	6145                	addi	sp,sp,48
ffffffffc0205318:	f17fc06f          	j	ffffffffc020222e <kfree>
ffffffffc020531c:	8522                	mv	a0,s0
ffffffffc020531e:	edeff0ef          	jal	ffffffffc02049fc <fd_array_close>
ffffffffc0205322:	401c                	lw	a5,0(s0)
ffffffffc0205324:	bff1                	j	ffffffffc0205300 <files_destroy+0x30>
ffffffffc0205326:	00009697          	auipc	a3,0x9
ffffffffc020532a:	80a68693          	addi	a3,a3,-2038 # ffffffffc020db30 <etext+0x1df8>
ffffffffc020532e:	00007617          	auipc	a2,0x7
ffffffffc0205332:	e4260613          	addi	a2,a2,-446 # ffffffffc020c170 <etext+0x438>
ffffffffc0205336:	03d00593          	li	a1,61
ffffffffc020533a:	00008517          	auipc	a0,0x8
ffffffffc020533e:	7e650513          	addi	a0,a0,2022 # ffffffffc020db20 <etext+0x1de8>
ffffffffc0205342:	908fb0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205346:	00008697          	auipc	a3,0x8
ffffffffc020534a:	7aa68693          	addi	a3,a3,1962 # ffffffffc020daf0 <etext+0x1db8>
ffffffffc020534e:	00007617          	auipc	a2,0x7
ffffffffc0205352:	e2260613          	addi	a2,a2,-478 # ffffffffc020c170 <etext+0x438>
ffffffffc0205356:	03300593          	li	a1,51
ffffffffc020535a:	00008517          	auipc	a0,0x8
ffffffffc020535e:	7c650513          	addi	a0,a0,1990 # ffffffffc020db20 <etext+0x1de8>
ffffffffc0205362:	8e8fb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205366 <files_closeall>:
ffffffffc0205366:	1101                	addi	sp,sp,-32
ffffffffc0205368:	ec06                	sd	ra,24(sp)
ffffffffc020536a:	e822                	sd	s0,16(sp)
ffffffffc020536c:	e426                	sd	s1,8(sp)
ffffffffc020536e:	e04a                	sd	s2,0(sp)
ffffffffc0205370:	c129                	beqz	a0,ffffffffc02053b2 <files_closeall+0x4c>
ffffffffc0205372:	491c                	lw	a5,16(a0)
ffffffffc0205374:	02f05f63          	blez	a5,ffffffffc02053b2 <files_closeall+0x4c>
ffffffffc0205378:	6500                	ld	s0,8(a0)
ffffffffc020537a:	4909                	li	s2,2
ffffffffc020537c:	7ff40493          	addi	s1,s0,2047
ffffffffc0205380:	7c148493          	addi	s1,s1,1985
ffffffffc0205384:	07040413          	addi	s0,s0,112
ffffffffc0205388:	a029                	j	ffffffffc0205392 <files_closeall+0x2c>
ffffffffc020538a:	03840413          	addi	s0,s0,56
ffffffffc020538e:	00940c63          	beq	s0,s1,ffffffffc02053a6 <files_closeall+0x40>
ffffffffc0205392:	401c                	lw	a5,0(s0)
ffffffffc0205394:	ff279be3          	bne	a5,s2,ffffffffc020538a <files_closeall+0x24>
ffffffffc0205398:	8522                	mv	a0,s0
ffffffffc020539a:	03840413          	addi	s0,s0,56
ffffffffc020539e:	e5eff0ef          	jal	ffffffffc02049fc <fd_array_close>
ffffffffc02053a2:	fe9418e3          	bne	s0,s1,ffffffffc0205392 <files_closeall+0x2c>
ffffffffc02053a6:	60e2                	ld	ra,24(sp)
ffffffffc02053a8:	6442                	ld	s0,16(sp)
ffffffffc02053aa:	64a2                	ld	s1,8(sp)
ffffffffc02053ac:	6902                	ld	s2,0(sp)
ffffffffc02053ae:	6105                	addi	sp,sp,32
ffffffffc02053b0:	8082                	ret
ffffffffc02053b2:	00008697          	auipc	a3,0x8
ffffffffc02053b6:	3b668693          	addi	a3,a3,950 # ffffffffc020d768 <etext+0x1a30>
ffffffffc02053ba:	00007617          	auipc	a2,0x7
ffffffffc02053be:	db660613          	addi	a2,a2,-586 # ffffffffc020c170 <etext+0x438>
ffffffffc02053c2:	04500593          	li	a1,69
ffffffffc02053c6:	00008517          	auipc	a0,0x8
ffffffffc02053ca:	75a50513          	addi	a0,a0,1882 # ffffffffc020db20 <etext+0x1de8>
ffffffffc02053ce:	87cfb0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02053d2 <dup_files>:
ffffffffc02053d2:	7179                	addi	sp,sp,-48
ffffffffc02053d4:	f406                	sd	ra,40(sp)
ffffffffc02053d6:	f022                	sd	s0,32(sp)
ffffffffc02053d8:	ec26                	sd	s1,24(sp)
ffffffffc02053da:	e84a                	sd	s2,16(sp)
ffffffffc02053dc:	e44e                	sd	s3,8(sp)
ffffffffc02053de:	e052                	sd	s4,0(sp)
ffffffffc02053e0:	c52d                	beqz	a0,ffffffffc020544a <dup_files+0x78>
ffffffffc02053e2:	842e                	mv	s0,a1
ffffffffc02053e4:	c1bd                	beqz	a1,ffffffffc020544a <dup_files+0x78>
ffffffffc02053e6:	491c                	lw	a5,16(a0)
ffffffffc02053e8:	84aa                	mv	s1,a0
ffffffffc02053ea:	e3c1                	bnez	a5,ffffffffc020546a <dup_files+0x98>
ffffffffc02053ec:	499c                	lw	a5,16(a1)
ffffffffc02053ee:	06f05e63          	blez	a5,ffffffffc020546a <dup_files+0x98>
ffffffffc02053f2:	6188                	ld	a0,0(a1)
ffffffffc02053f4:	e088                	sd	a0,0(s1)
ffffffffc02053f6:	c119                	beqz	a0,ffffffffc02053fc <dup_files+0x2a>
ffffffffc02053f8:	377020ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc02053fc:	6400                	ld	s0,8(s0)
ffffffffc02053fe:	6484                	ld	s1,8(s1)
ffffffffc0205400:	4989                	li	s3,2
ffffffffc0205402:	7ff40913          	addi	s2,s0,2047
ffffffffc0205406:	7c190913          	addi	s2,s2,1985
ffffffffc020540a:	4a05                	li	s4,1
ffffffffc020540c:	a039                	j	ffffffffc020541a <dup_files+0x48>
ffffffffc020540e:	03840413          	addi	s0,s0,56
ffffffffc0205412:	03848493          	addi	s1,s1,56
ffffffffc0205416:	03240163          	beq	s0,s2,ffffffffc0205438 <dup_files+0x66>
ffffffffc020541a:	401c                	lw	a5,0(s0)
ffffffffc020541c:	ff3799e3          	bne	a5,s3,ffffffffc020540e <dup_files+0x3c>
ffffffffc0205420:	0144a023          	sw	s4,0(s1)
ffffffffc0205424:	85a2                	mv	a1,s0
ffffffffc0205426:	8526                	mv	a0,s1
ffffffffc0205428:	03840413          	addi	s0,s0,56
ffffffffc020542c:	e48ff0ef          	jal	ffffffffc0204a74 <fd_array_dup>
ffffffffc0205430:	03848493          	addi	s1,s1,56
ffffffffc0205434:	ff2413e3          	bne	s0,s2,ffffffffc020541a <dup_files+0x48>
ffffffffc0205438:	70a2                	ld	ra,40(sp)
ffffffffc020543a:	7402                	ld	s0,32(sp)
ffffffffc020543c:	64e2                	ld	s1,24(sp)
ffffffffc020543e:	6942                	ld	s2,16(sp)
ffffffffc0205440:	69a2                	ld	s3,8(sp)
ffffffffc0205442:	6a02                	ld	s4,0(sp)
ffffffffc0205444:	4501                	li	a0,0
ffffffffc0205446:	6145                	addi	sp,sp,48
ffffffffc0205448:	8082                	ret
ffffffffc020544a:	00008697          	auipc	a3,0x8
ffffffffc020544e:	fce68693          	addi	a3,a3,-50 # ffffffffc020d418 <etext+0x16e0>
ffffffffc0205452:	00007617          	auipc	a2,0x7
ffffffffc0205456:	d1e60613          	addi	a2,a2,-738 # ffffffffc020c170 <etext+0x438>
ffffffffc020545a:	05300593          	li	a1,83
ffffffffc020545e:	00008517          	auipc	a0,0x8
ffffffffc0205462:	6c250513          	addi	a0,a0,1730 # ffffffffc020db20 <etext+0x1de8>
ffffffffc0205466:	fe5fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020546a:	00008697          	auipc	a3,0x8
ffffffffc020546e:	6de68693          	addi	a3,a3,1758 # ffffffffc020db48 <etext+0x1e10>
ffffffffc0205472:	00007617          	auipc	a2,0x7
ffffffffc0205476:	cfe60613          	addi	a2,a2,-770 # ffffffffc020c170 <etext+0x438>
ffffffffc020547a:	05400593          	li	a1,84
ffffffffc020547e:	00008517          	auipc	a0,0x8
ffffffffc0205482:	6a250513          	addi	a0,a0,1698 # ffffffffc020db20 <etext+0x1de8>
ffffffffc0205486:	fc5fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020548a <iobuf_skip.part.0>:
ffffffffc020548a:	1141                	addi	sp,sp,-16
ffffffffc020548c:	00008697          	auipc	a3,0x8
ffffffffc0205490:	6ec68693          	addi	a3,a3,1772 # ffffffffc020db78 <etext+0x1e40>
ffffffffc0205494:	00007617          	auipc	a2,0x7
ffffffffc0205498:	cdc60613          	addi	a2,a2,-804 # ffffffffc020c170 <etext+0x438>
ffffffffc020549c:	04a00593          	li	a1,74
ffffffffc02054a0:	00008517          	auipc	a0,0x8
ffffffffc02054a4:	6f050513          	addi	a0,a0,1776 # ffffffffc020db90 <etext+0x1e58>
ffffffffc02054a8:	e406                	sd	ra,8(sp)
ffffffffc02054aa:	fa1fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02054ae <iobuf_init>:
ffffffffc02054ae:	e10c                	sd	a1,0(a0)
ffffffffc02054b0:	e514                	sd	a3,8(a0)
ffffffffc02054b2:	ed10                	sd	a2,24(a0)
ffffffffc02054b4:	e910                	sd	a2,16(a0)
ffffffffc02054b6:	8082                	ret

ffffffffc02054b8 <iobuf_move>:
ffffffffc02054b8:	6d1c                	ld	a5,24(a0)
ffffffffc02054ba:	88aa                	mv	a7,a0
ffffffffc02054bc:	8832                	mv	a6,a2
ffffffffc02054be:	00f67363          	bgeu	a2,a5,ffffffffc02054c4 <iobuf_move+0xc>
ffffffffc02054c2:	87b2                	mv	a5,a2
ffffffffc02054c4:	cfa1                	beqz	a5,ffffffffc020551c <iobuf_move+0x64>
ffffffffc02054c6:	7179                	addi	sp,sp,-48
ffffffffc02054c8:	f406                	sd	ra,40(sp)
ffffffffc02054ca:	0008b503          	ld	a0,0(a7)
ffffffffc02054ce:	cea9                	beqz	a3,ffffffffc0205528 <iobuf_move+0x70>
ffffffffc02054d0:	863e                	mv	a2,a5
ffffffffc02054d2:	ec3a                	sd	a4,24(sp)
ffffffffc02054d4:	e846                	sd	a7,16(sp)
ffffffffc02054d6:	e442                	sd	a6,8(sp)
ffffffffc02054d8:	e03e                	sd	a5,0(sp)
ffffffffc02054da:	009060ef          	jal	ffffffffc020bce2 <memmove>
ffffffffc02054de:	68c2                	ld	a7,16(sp)
ffffffffc02054e0:	6782                	ld	a5,0(sp)
ffffffffc02054e2:	6822                	ld	a6,8(sp)
ffffffffc02054e4:	0188b683          	ld	a3,24(a7)
ffffffffc02054e8:	6762                	ld	a4,24(sp)
ffffffffc02054ea:	04f6e763          	bltu	a3,a5,ffffffffc0205538 <iobuf_move+0x80>
ffffffffc02054ee:	0008b583          	ld	a1,0(a7)
ffffffffc02054f2:	0088b603          	ld	a2,8(a7)
ffffffffc02054f6:	8e9d                	sub	a3,a3,a5
ffffffffc02054f8:	95be                	add	a1,a1,a5
ffffffffc02054fa:	963e                	add	a2,a2,a5
ffffffffc02054fc:	00d8bc23          	sd	a3,24(a7)
ffffffffc0205500:	00b8b023          	sd	a1,0(a7)
ffffffffc0205504:	00c8b423          	sd	a2,8(a7)
ffffffffc0205508:	40f80833          	sub	a6,a6,a5
ffffffffc020550c:	c311                	beqz	a4,ffffffffc0205510 <iobuf_move+0x58>
ffffffffc020550e:	e31c                	sd	a5,0(a4)
ffffffffc0205510:	02081263          	bnez	a6,ffffffffc0205534 <iobuf_move+0x7c>
ffffffffc0205514:	4501                	li	a0,0
ffffffffc0205516:	70a2                	ld	ra,40(sp)
ffffffffc0205518:	6145                	addi	sp,sp,48
ffffffffc020551a:	8082                	ret
ffffffffc020551c:	c311                	beqz	a4,ffffffffc0205520 <iobuf_move+0x68>
ffffffffc020551e:	e31c                	sd	a5,0(a4)
ffffffffc0205520:	00081863          	bnez	a6,ffffffffc0205530 <iobuf_move+0x78>
ffffffffc0205524:	4501                	li	a0,0
ffffffffc0205526:	8082                	ret
ffffffffc0205528:	86ae                	mv	a3,a1
ffffffffc020552a:	85aa                	mv	a1,a0
ffffffffc020552c:	8536                	mv	a0,a3
ffffffffc020552e:	b74d                	j	ffffffffc02054d0 <iobuf_move+0x18>
ffffffffc0205530:	5571                	li	a0,-4
ffffffffc0205532:	8082                	ret
ffffffffc0205534:	5571                	li	a0,-4
ffffffffc0205536:	b7c5                	j	ffffffffc0205516 <iobuf_move+0x5e>
ffffffffc0205538:	f53ff0ef          	jal	ffffffffc020548a <iobuf_skip.part.0>

ffffffffc020553c <iobuf_skip>:
ffffffffc020553c:	6d1c                	ld	a5,24(a0)
ffffffffc020553e:	00b7eb63          	bltu	a5,a1,ffffffffc0205554 <iobuf_skip+0x18>
ffffffffc0205542:	6114                	ld	a3,0(a0)
ffffffffc0205544:	6518                	ld	a4,8(a0)
ffffffffc0205546:	8f8d                	sub	a5,a5,a1
ffffffffc0205548:	96ae                	add	a3,a3,a1
ffffffffc020554a:	972e                	add	a4,a4,a1
ffffffffc020554c:	ed1c                	sd	a5,24(a0)
ffffffffc020554e:	e114                	sd	a3,0(a0)
ffffffffc0205550:	e518                	sd	a4,8(a0)
ffffffffc0205552:	8082                	ret
ffffffffc0205554:	1141                	addi	sp,sp,-16
ffffffffc0205556:	e406                	sd	ra,8(sp)
ffffffffc0205558:	f33ff0ef          	jal	ffffffffc020548a <iobuf_skip.part.0>

ffffffffc020555c <copy_path>:
ffffffffc020555c:	7139                	addi	sp,sp,-64
ffffffffc020555e:	f04a                	sd	s2,32(sp)
ffffffffc0205560:	00092917          	auipc	s2,0x92
ffffffffc0205564:	37090913          	addi	s2,s2,880 # ffffffffc02978d0 <current>
ffffffffc0205568:	00093783          	ld	a5,0(s2)
ffffffffc020556c:	e852                	sd	s4,16(sp)
ffffffffc020556e:	8a2a                	mv	s4,a0
ffffffffc0205570:	6505                	lui	a0,0x1
ffffffffc0205572:	f426                	sd	s1,40(sp)
ffffffffc0205574:	ec4e                	sd	s3,24(sp)
ffffffffc0205576:	fc06                	sd	ra,56(sp)
ffffffffc0205578:	7784                	ld	s1,40(a5)
ffffffffc020557a:	89ae                	mv	s3,a1
ffffffffc020557c:	c0dfc0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0205580:	c92d                	beqz	a0,ffffffffc02055f2 <copy_path+0x96>
ffffffffc0205582:	f822                	sd	s0,48(sp)
ffffffffc0205584:	842a                	mv	s0,a0
ffffffffc0205586:	c0b1                	beqz	s1,ffffffffc02055ca <copy_path+0x6e>
ffffffffc0205588:	03848513          	addi	a0,s1,56
ffffffffc020558c:	88cff0ef          	jal	ffffffffc0204618 <down>
ffffffffc0205590:	00093783          	ld	a5,0(s2)
ffffffffc0205594:	c399                	beqz	a5,ffffffffc020559a <copy_path+0x3e>
ffffffffc0205596:	43dc                	lw	a5,4(a5)
ffffffffc0205598:	c8bc                	sw	a5,80(s1)
ffffffffc020559a:	864e                	mv	a2,s3
ffffffffc020559c:	6685                	lui	a3,0x1
ffffffffc020559e:	85a2                	mv	a1,s0
ffffffffc02055a0:	8526                	mv	a0,s1
ffffffffc02055a2:	dc3fe0ef          	jal	ffffffffc0204364 <copy_string>
ffffffffc02055a6:	cd1d                	beqz	a0,ffffffffc02055e4 <copy_path+0x88>
ffffffffc02055a8:	03848513          	addi	a0,s1,56
ffffffffc02055ac:	868ff0ef          	jal	ffffffffc0204614 <up>
ffffffffc02055b0:	0404a823          	sw	zero,80(s1)
ffffffffc02055b4:	008a3023          	sd	s0,0(s4)
ffffffffc02055b8:	7442                	ld	s0,48(sp)
ffffffffc02055ba:	4501                	li	a0,0
ffffffffc02055bc:	70e2                	ld	ra,56(sp)
ffffffffc02055be:	74a2                	ld	s1,40(sp)
ffffffffc02055c0:	7902                	ld	s2,32(sp)
ffffffffc02055c2:	69e2                	ld	s3,24(sp)
ffffffffc02055c4:	6a42                	ld	s4,16(sp)
ffffffffc02055c6:	6121                	addi	sp,sp,64
ffffffffc02055c8:	8082                	ret
ffffffffc02055ca:	85aa                	mv	a1,a0
ffffffffc02055cc:	864e                	mv	a2,s3
ffffffffc02055ce:	6685                	lui	a3,0x1
ffffffffc02055d0:	4501                	li	a0,0
ffffffffc02055d2:	d93fe0ef          	jal	ffffffffc0204364 <copy_string>
ffffffffc02055d6:	fd79                	bnez	a0,ffffffffc02055b4 <copy_path+0x58>
ffffffffc02055d8:	8522                	mv	a0,s0
ffffffffc02055da:	c55fc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc02055de:	5575                	li	a0,-3
ffffffffc02055e0:	7442                	ld	s0,48(sp)
ffffffffc02055e2:	bfe9                	j	ffffffffc02055bc <copy_path+0x60>
ffffffffc02055e4:	03848513          	addi	a0,s1,56
ffffffffc02055e8:	82cff0ef          	jal	ffffffffc0204614 <up>
ffffffffc02055ec:	0404a823          	sw	zero,80(s1)
ffffffffc02055f0:	b7e5                	j	ffffffffc02055d8 <copy_path+0x7c>
ffffffffc02055f2:	5571                	li	a0,-4
ffffffffc02055f4:	b7e1                	j	ffffffffc02055bc <copy_path+0x60>

ffffffffc02055f6 <sysfile_open>:
ffffffffc02055f6:	7179                	addi	sp,sp,-48
ffffffffc02055f8:	f022                	sd	s0,32(sp)
ffffffffc02055fa:	842e                	mv	s0,a1
ffffffffc02055fc:	85aa                	mv	a1,a0
ffffffffc02055fe:	0828                	addi	a0,sp,24
ffffffffc0205600:	f406                	sd	ra,40(sp)
ffffffffc0205602:	f5bff0ef          	jal	ffffffffc020555c <copy_path>
ffffffffc0205606:	87aa                	mv	a5,a0
ffffffffc0205608:	ed09                	bnez	a0,ffffffffc0205622 <sysfile_open+0x2c>
ffffffffc020560a:	6762                	ld	a4,24(sp)
ffffffffc020560c:	85a2                	mv	a1,s0
ffffffffc020560e:	853a                	mv	a0,a4
ffffffffc0205610:	e43a                	sd	a4,8(sp)
ffffffffc0205612:	d32ff0ef          	jal	ffffffffc0204b44 <file_open>
ffffffffc0205616:	6722                	ld	a4,8(sp)
ffffffffc0205618:	e42a                	sd	a0,8(sp)
ffffffffc020561a:	853a                	mv	a0,a4
ffffffffc020561c:	c13fc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0205620:	67a2                	ld	a5,8(sp)
ffffffffc0205622:	70a2                	ld	ra,40(sp)
ffffffffc0205624:	7402                	ld	s0,32(sp)
ffffffffc0205626:	853e                	mv	a0,a5
ffffffffc0205628:	6145                	addi	sp,sp,48
ffffffffc020562a:	8082                	ret

ffffffffc020562c <sysfile_close>:
ffffffffc020562c:	e32ff06f          	j	ffffffffc0204c5e <file_close>

ffffffffc0205630 <sysfile_read>:
ffffffffc0205630:	7119                	addi	sp,sp,-128
ffffffffc0205632:	f466                	sd	s9,40(sp)
ffffffffc0205634:	fc86                	sd	ra,120(sp)
ffffffffc0205636:	4c81                	li	s9,0
ffffffffc0205638:	e611                	bnez	a2,ffffffffc0205644 <sysfile_read+0x14>
ffffffffc020563a:	70e6                	ld	ra,120(sp)
ffffffffc020563c:	8566                	mv	a0,s9
ffffffffc020563e:	7ca2                	ld	s9,40(sp)
ffffffffc0205640:	6109                	addi	sp,sp,128
ffffffffc0205642:	8082                	ret
ffffffffc0205644:	f862                	sd	s8,48(sp)
ffffffffc0205646:	00092c17          	auipc	s8,0x92
ffffffffc020564a:	28ac0c13          	addi	s8,s8,650 # ffffffffc02978d0 <current>
ffffffffc020564e:	000c3783          	ld	a5,0(s8)
ffffffffc0205652:	f8a2                	sd	s0,112(sp)
ffffffffc0205654:	f0ca                	sd	s2,96(sp)
ffffffffc0205656:	8432                	mv	s0,a2
ffffffffc0205658:	892e                	mv	s2,a1
ffffffffc020565a:	4601                	li	a2,0
ffffffffc020565c:	4585                	li	a1,1
ffffffffc020565e:	f4a6                	sd	s1,104(sp)
ffffffffc0205660:	e8d2                	sd	s4,80(sp)
ffffffffc0205662:	7784                	ld	s1,40(a5)
ffffffffc0205664:	8a2a                	mv	s4,a0
ffffffffc0205666:	c8aff0ef          	jal	ffffffffc0204af0 <file_testfd>
ffffffffc020566a:	c969                	beqz	a0,ffffffffc020573c <sysfile_read+0x10c>
ffffffffc020566c:	6505                	lui	a0,0x1
ffffffffc020566e:	ecce                	sd	s3,88(sp)
ffffffffc0205670:	b19fc0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0205674:	89aa                	mv	s3,a0
ffffffffc0205676:	c971                	beqz	a0,ffffffffc020574a <sysfile_read+0x11a>
ffffffffc0205678:	e4d6                	sd	s5,72(sp)
ffffffffc020567a:	e0da                	sd	s6,64(sp)
ffffffffc020567c:	6a85                	lui	s5,0x1
ffffffffc020567e:	4b01                	li	s6,0
ffffffffc0205680:	09546863          	bltu	s0,s5,ffffffffc0205710 <sysfile_read+0xe0>
ffffffffc0205684:	6785                	lui	a5,0x1
ffffffffc0205686:	863e                	mv	a2,a5
ffffffffc0205688:	0834                	addi	a3,sp,24
ffffffffc020568a:	85ce                	mv	a1,s3
ffffffffc020568c:	8552                	mv	a0,s4
ffffffffc020568e:	ec3e                	sd	a5,24(sp)
ffffffffc0205690:	e26ff0ef          	jal	ffffffffc0204cb6 <file_read>
ffffffffc0205694:	66e2                	ld	a3,24(sp)
ffffffffc0205696:	8caa                	mv	s9,a0
ffffffffc0205698:	e68d                	bnez	a3,ffffffffc02056c2 <sysfile_read+0x92>
ffffffffc020569a:	854e                	mv	a0,s3
ffffffffc020569c:	b93fc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc02056a0:	000b0463          	beqz	s6,ffffffffc02056a8 <sysfile_read+0x78>
ffffffffc02056a4:	000b0c9b          	sext.w	s9,s6
ffffffffc02056a8:	7446                	ld	s0,112(sp)
ffffffffc02056aa:	70e6                	ld	ra,120(sp)
ffffffffc02056ac:	74a6                	ld	s1,104(sp)
ffffffffc02056ae:	7906                	ld	s2,96(sp)
ffffffffc02056b0:	69e6                	ld	s3,88(sp)
ffffffffc02056b2:	6a46                	ld	s4,80(sp)
ffffffffc02056b4:	6aa6                	ld	s5,72(sp)
ffffffffc02056b6:	6b06                	ld	s6,64(sp)
ffffffffc02056b8:	7c42                	ld	s8,48(sp)
ffffffffc02056ba:	8566                	mv	a0,s9
ffffffffc02056bc:	7ca2                	ld	s9,40(sp)
ffffffffc02056be:	6109                	addi	sp,sp,128
ffffffffc02056c0:	8082                	ret
ffffffffc02056c2:	c899                	beqz	s1,ffffffffc02056d8 <sysfile_read+0xa8>
ffffffffc02056c4:	03848513          	addi	a0,s1,56
ffffffffc02056c8:	f51fe0ef          	jal	ffffffffc0204618 <down>
ffffffffc02056cc:	000c3783          	ld	a5,0(s8)
ffffffffc02056d0:	66e2                	ld	a3,24(sp)
ffffffffc02056d2:	c399                	beqz	a5,ffffffffc02056d8 <sysfile_read+0xa8>
ffffffffc02056d4:	43dc                	lw	a5,4(a5)
ffffffffc02056d6:	c8bc                	sw	a5,80(s1)
ffffffffc02056d8:	864e                	mv	a2,s3
ffffffffc02056da:	85ca                	mv	a1,s2
ffffffffc02056dc:	8526                	mv	a0,s1
ffffffffc02056de:	c4ffe0ef          	jal	ffffffffc020432c <copy_to_user>
ffffffffc02056e2:	c915                	beqz	a0,ffffffffc0205716 <sysfile_read+0xe6>
ffffffffc02056e4:	67e2                	ld	a5,24(sp)
ffffffffc02056e6:	06f46a63          	bltu	s0,a5,ffffffffc020575a <sysfile_read+0x12a>
ffffffffc02056ea:	9b3e                	add	s6,s6,a5
ffffffffc02056ec:	c889                	beqz	s1,ffffffffc02056fe <sysfile_read+0xce>
ffffffffc02056ee:	03848513          	addi	a0,s1,56
ffffffffc02056f2:	e43e                	sd	a5,8(sp)
ffffffffc02056f4:	f21fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc02056f8:	67a2                	ld	a5,8(sp)
ffffffffc02056fa:	0404a823          	sw	zero,80(s1)
ffffffffc02056fe:	f80c9ee3          	bnez	s9,ffffffffc020569a <sysfile_read+0x6a>
ffffffffc0205702:	6762                	ld	a4,24(sp)
ffffffffc0205704:	db59                	beqz	a4,ffffffffc020569a <sysfile_read+0x6a>
ffffffffc0205706:	8c1d                	sub	s0,s0,a5
ffffffffc0205708:	d849                	beqz	s0,ffffffffc020569a <sysfile_read+0x6a>
ffffffffc020570a:	993e                	add	s2,s2,a5
ffffffffc020570c:	f7547ce3          	bgeu	s0,s5,ffffffffc0205684 <sysfile_read+0x54>
ffffffffc0205710:	87a2                	mv	a5,s0
ffffffffc0205712:	8622                	mv	a2,s0
ffffffffc0205714:	bf95                	j	ffffffffc0205688 <sysfile_read+0x58>
ffffffffc0205716:	000c8a63          	beqz	s9,ffffffffc020572a <sysfile_read+0xfa>
ffffffffc020571a:	d0c1                	beqz	s1,ffffffffc020569a <sysfile_read+0x6a>
ffffffffc020571c:	03848513          	addi	a0,s1,56
ffffffffc0205720:	ef5fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205724:	0404a823          	sw	zero,80(s1)
ffffffffc0205728:	bf8d                	j	ffffffffc020569a <sysfile_read+0x6a>
ffffffffc020572a:	c499                	beqz	s1,ffffffffc0205738 <sysfile_read+0x108>
ffffffffc020572c:	03848513          	addi	a0,s1,56
ffffffffc0205730:	ee5fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205734:	0404a823          	sw	zero,80(s1)
ffffffffc0205738:	5cf5                	li	s9,-3
ffffffffc020573a:	b785                	j	ffffffffc020569a <sysfile_read+0x6a>
ffffffffc020573c:	7446                	ld	s0,112(sp)
ffffffffc020573e:	74a6                	ld	s1,104(sp)
ffffffffc0205740:	7906                	ld	s2,96(sp)
ffffffffc0205742:	6a46                	ld	s4,80(sp)
ffffffffc0205744:	7c42                	ld	s8,48(sp)
ffffffffc0205746:	5cf5                	li	s9,-3
ffffffffc0205748:	bdcd                	j	ffffffffc020563a <sysfile_read+0xa>
ffffffffc020574a:	7446                	ld	s0,112(sp)
ffffffffc020574c:	74a6                	ld	s1,104(sp)
ffffffffc020574e:	7906                	ld	s2,96(sp)
ffffffffc0205750:	69e6                	ld	s3,88(sp)
ffffffffc0205752:	6a46                	ld	s4,80(sp)
ffffffffc0205754:	7c42                	ld	s8,48(sp)
ffffffffc0205756:	5cf1                	li	s9,-4
ffffffffc0205758:	b5cd                	j	ffffffffc020563a <sysfile_read+0xa>
ffffffffc020575a:	00008697          	auipc	a3,0x8
ffffffffc020575e:	44668693          	addi	a3,a3,1094 # ffffffffc020dba0 <etext+0x1e68>
ffffffffc0205762:	00007617          	auipc	a2,0x7
ffffffffc0205766:	a0e60613          	addi	a2,a2,-1522 # ffffffffc020c170 <etext+0x438>
ffffffffc020576a:	05500593          	li	a1,85
ffffffffc020576e:	00008517          	auipc	a0,0x8
ffffffffc0205772:	44250513          	addi	a0,a0,1090 # ffffffffc020dbb0 <etext+0x1e78>
ffffffffc0205776:	fc5e                	sd	s7,56(sp)
ffffffffc0205778:	cd3fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc020577c <sysfile_write>:
ffffffffc020577c:	e601                	bnez	a2,ffffffffc0205784 <sysfile_write+0x8>
ffffffffc020577e:	4701                	li	a4,0
ffffffffc0205780:	853a                	mv	a0,a4
ffffffffc0205782:	8082                	ret
ffffffffc0205784:	7159                	addi	sp,sp,-112
ffffffffc0205786:	f062                	sd	s8,32(sp)
ffffffffc0205788:	00092c17          	auipc	s8,0x92
ffffffffc020578c:	148c0c13          	addi	s8,s8,328 # ffffffffc02978d0 <current>
ffffffffc0205790:	000c3783          	ld	a5,0(s8)
ffffffffc0205794:	f0a2                	sd	s0,96(sp)
ffffffffc0205796:	eca6                	sd	s1,88(sp)
ffffffffc0205798:	8432                	mv	s0,a2
ffffffffc020579a:	84ae                	mv	s1,a1
ffffffffc020579c:	4605                	li	a2,1
ffffffffc020579e:	4581                	li	a1,0
ffffffffc02057a0:	e8ca                	sd	s2,80(sp)
ffffffffc02057a2:	e0d2                	sd	s4,64(sp)
ffffffffc02057a4:	f486                	sd	ra,104(sp)
ffffffffc02057a6:	0287b903          	ld	s2,40(a5) # 1028 <_binary_bin_swap_img_size-0x6cd8>
ffffffffc02057aa:	8a2a                	mv	s4,a0
ffffffffc02057ac:	b44ff0ef          	jal	ffffffffc0204af0 <file_testfd>
ffffffffc02057b0:	c969                	beqz	a0,ffffffffc0205882 <sysfile_write+0x106>
ffffffffc02057b2:	6505                	lui	a0,0x1
ffffffffc02057b4:	e4ce                	sd	s3,72(sp)
ffffffffc02057b6:	9d3fc0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc02057ba:	89aa                	mv	s3,a0
ffffffffc02057bc:	c569                	beqz	a0,ffffffffc0205886 <sysfile_write+0x10a>
ffffffffc02057be:	fc56                	sd	s5,56(sp)
ffffffffc02057c0:	f45e                	sd	s7,40(sp)
ffffffffc02057c2:	4a81                	li	s5,0
ffffffffc02057c4:	6b85                	lui	s7,0x1
ffffffffc02057c6:	86a2                	mv	a3,s0
ffffffffc02057c8:	008bf363          	bgeu	s7,s0,ffffffffc02057ce <sysfile_write+0x52>
ffffffffc02057cc:	6685                	lui	a3,0x1
ffffffffc02057ce:	ec36                	sd	a3,24(sp)
ffffffffc02057d0:	04090e63          	beqz	s2,ffffffffc020582c <sysfile_write+0xb0>
ffffffffc02057d4:	03890513          	addi	a0,s2,56
ffffffffc02057d8:	e41fe0ef          	jal	ffffffffc0204618 <down>
ffffffffc02057dc:	000c3783          	ld	a5,0(s8)
ffffffffc02057e0:	c781                	beqz	a5,ffffffffc02057e8 <sysfile_write+0x6c>
ffffffffc02057e2:	43dc                	lw	a5,4(a5)
ffffffffc02057e4:	04f92823          	sw	a5,80(s2)
ffffffffc02057e8:	66e2                	ld	a3,24(sp)
ffffffffc02057ea:	4701                	li	a4,0
ffffffffc02057ec:	8626                	mv	a2,s1
ffffffffc02057ee:	85ce                	mv	a1,s3
ffffffffc02057f0:	854a                	mv	a0,s2
ffffffffc02057f2:	b05fe0ef          	jal	ffffffffc02042f6 <copy_from_user>
ffffffffc02057f6:	ed3d                	bnez	a0,ffffffffc0205874 <sysfile_write+0xf8>
ffffffffc02057f8:	03890513          	addi	a0,s2,56
ffffffffc02057fc:	e19fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205800:	04092823          	sw	zero,80(s2)
ffffffffc0205804:	5775                	li	a4,-3
ffffffffc0205806:	854e                	mv	a0,s3
ffffffffc0205808:	e43a                	sd	a4,8(sp)
ffffffffc020580a:	a25fc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc020580e:	6722                	ld	a4,8(sp)
ffffffffc0205810:	040a9c63          	bnez	s5,ffffffffc0205868 <sysfile_write+0xec>
ffffffffc0205814:	69a6                	ld	s3,72(sp)
ffffffffc0205816:	7ae2                	ld	s5,56(sp)
ffffffffc0205818:	7ba2                	ld	s7,40(sp)
ffffffffc020581a:	70a6                	ld	ra,104(sp)
ffffffffc020581c:	7406                	ld	s0,96(sp)
ffffffffc020581e:	64e6                	ld	s1,88(sp)
ffffffffc0205820:	6946                	ld	s2,80(sp)
ffffffffc0205822:	6a06                	ld	s4,64(sp)
ffffffffc0205824:	7c02                	ld	s8,32(sp)
ffffffffc0205826:	853a                	mv	a0,a4
ffffffffc0205828:	6165                	addi	sp,sp,112
ffffffffc020582a:	8082                	ret
ffffffffc020582c:	4701                	li	a4,0
ffffffffc020582e:	8626                	mv	a2,s1
ffffffffc0205830:	85ce                	mv	a1,s3
ffffffffc0205832:	4501                	li	a0,0
ffffffffc0205834:	ac3fe0ef          	jal	ffffffffc02042f6 <copy_from_user>
ffffffffc0205838:	d571                	beqz	a0,ffffffffc0205804 <sysfile_write+0x88>
ffffffffc020583a:	6662                	ld	a2,24(sp)
ffffffffc020583c:	0834                	addi	a3,sp,24
ffffffffc020583e:	85ce                	mv	a1,s3
ffffffffc0205840:	8552                	mv	a0,s4
ffffffffc0205842:	d62ff0ef          	jal	ffffffffc0204da4 <file_write>
ffffffffc0205846:	67e2                	ld	a5,24(sp)
ffffffffc0205848:	872a                	mv	a4,a0
ffffffffc020584a:	dfd5                	beqz	a5,ffffffffc0205806 <sysfile_write+0x8a>
ffffffffc020584c:	04f46063          	bltu	s0,a5,ffffffffc020588c <sysfile_write+0x110>
ffffffffc0205850:	9abe                	add	s5,s5,a5
ffffffffc0205852:	f955                	bnez	a0,ffffffffc0205806 <sysfile_write+0x8a>
ffffffffc0205854:	8c1d                	sub	s0,s0,a5
ffffffffc0205856:	94be                	add	s1,s1,a5
ffffffffc0205858:	f43d                	bnez	s0,ffffffffc02057c6 <sysfile_write+0x4a>
ffffffffc020585a:	854e                	mv	a0,s3
ffffffffc020585c:	e43a                	sd	a4,8(sp)
ffffffffc020585e:	9d1fc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0205862:	6722                	ld	a4,8(sp)
ffffffffc0205864:	fa0a88e3          	beqz	s5,ffffffffc0205814 <sysfile_write+0x98>
ffffffffc0205868:	000a871b          	sext.w	a4,s5
ffffffffc020586c:	69a6                	ld	s3,72(sp)
ffffffffc020586e:	7ae2                	ld	s5,56(sp)
ffffffffc0205870:	7ba2                	ld	s7,40(sp)
ffffffffc0205872:	b765                	j	ffffffffc020581a <sysfile_write+0x9e>
ffffffffc0205874:	03890513          	addi	a0,s2,56
ffffffffc0205878:	d9dfe0ef          	jal	ffffffffc0204614 <up>
ffffffffc020587c:	04092823          	sw	zero,80(s2)
ffffffffc0205880:	bf6d                	j	ffffffffc020583a <sysfile_write+0xbe>
ffffffffc0205882:	5775                	li	a4,-3
ffffffffc0205884:	bf59                	j	ffffffffc020581a <sysfile_write+0x9e>
ffffffffc0205886:	69a6                	ld	s3,72(sp)
ffffffffc0205888:	5771                	li	a4,-4
ffffffffc020588a:	bf41                	j	ffffffffc020581a <sysfile_write+0x9e>
ffffffffc020588c:	00008697          	auipc	a3,0x8
ffffffffc0205890:	31468693          	addi	a3,a3,788 # ffffffffc020dba0 <etext+0x1e68>
ffffffffc0205894:	00007617          	auipc	a2,0x7
ffffffffc0205898:	8dc60613          	addi	a2,a2,-1828 # ffffffffc020c170 <etext+0x438>
ffffffffc020589c:	08a00593          	li	a1,138
ffffffffc02058a0:	00008517          	auipc	a0,0x8
ffffffffc02058a4:	31050513          	addi	a0,a0,784 # ffffffffc020dbb0 <etext+0x1e78>
ffffffffc02058a8:	f85a                	sd	s6,48(sp)
ffffffffc02058aa:	ba1fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc02058ae <sysfile_seek>:
ffffffffc02058ae:	de4ff06f          	j	ffffffffc0204e92 <file_seek>

ffffffffc02058b2 <sysfile_fstat>:
ffffffffc02058b2:	715d                	addi	sp,sp,-80
ffffffffc02058b4:	f84a                	sd	s2,48(sp)
ffffffffc02058b6:	00092917          	auipc	s2,0x92
ffffffffc02058ba:	01a90913          	addi	s2,s2,26 # ffffffffc02978d0 <current>
ffffffffc02058be:	00093783          	ld	a5,0(s2)
ffffffffc02058c2:	f44e                	sd	s3,40(sp)
ffffffffc02058c4:	89ae                	mv	s3,a1
ffffffffc02058c6:	858a                	mv	a1,sp
ffffffffc02058c8:	e0a2                	sd	s0,64(sp)
ffffffffc02058ca:	fc26                	sd	s1,56(sp)
ffffffffc02058cc:	e486                	sd	ra,72(sp)
ffffffffc02058ce:	7784                	ld	s1,40(a5)
ffffffffc02058d0:	ee6ff0ef          	jal	ffffffffc0204fb6 <file_fstat>
ffffffffc02058d4:	842a                	mv	s0,a0
ffffffffc02058d6:	e915                	bnez	a0,ffffffffc020590a <sysfile_fstat+0x58>
ffffffffc02058d8:	c0a9                	beqz	s1,ffffffffc020591a <sysfile_fstat+0x68>
ffffffffc02058da:	03848513          	addi	a0,s1,56
ffffffffc02058de:	d3bfe0ef          	jal	ffffffffc0204618 <down>
ffffffffc02058e2:	00093783          	ld	a5,0(s2)
ffffffffc02058e6:	c399                	beqz	a5,ffffffffc02058ec <sysfile_fstat+0x3a>
ffffffffc02058e8:	43dc                	lw	a5,4(a5)
ffffffffc02058ea:	c8bc                	sw	a5,80(s1)
ffffffffc02058ec:	860a                	mv	a2,sp
ffffffffc02058ee:	85ce                	mv	a1,s3
ffffffffc02058f0:	02000693          	li	a3,32
ffffffffc02058f4:	8526                	mv	a0,s1
ffffffffc02058f6:	a37fe0ef          	jal	ffffffffc020432c <copy_to_user>
ffffffffc02058fa:	e111                	bnez	a0,ffffffffc02058fe <sysfile_fstat+0x4c>
ffffffffc02058fc:	5475                	li	s0,-3
ffffffffc02058fe:	03848513          	addi	a0,s1,56
ffffffffc0205902:	d13fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205906:	0404a823          	sw	zero,80(s1)
ffffffffc020590a:	60a6                	ld	ra,72(sp)
ffffffffc020590c:	8522                	mv	a0,s0
ffffffffc020590e:	6406                	ld	s0,64(sp)
ffffffffc0205910:	74e2                	ld	s1,56(sp)
ffffffffc0205912:	7942                	ld	s2,48(sp)
ffffffffc0205914:	79a2                	ld	s3,40(sp)
ffffffffc0205916:	6161                	addi	sp,sp,80
ffffffffc0205918:	8082                	ret
ffffffffc020591a:	860a                	mv	a2,sp
ffffffffc020591c:	85ce                	mv	a1,s3
ffffffffc020591e:	02000693          	li	a3,32
ffffffffc0205922:	a0bfe0ef          	jal	ffffffffc020432c <copy_to_user>
ffffffffc0205926:	f175                	bnez	a0,ffffffffc020590a <sysfile_fstat+0x58>
ffffffffc0205928:	5475                	li	s0,-3
ffffffffc020592a:	60a6                	ld	ra,72(sp)
ffffffffc020592c:	8522                	mv	a0,s0
ffffffffc020592e:	6406                	ld	s0,64(sp)
ffffffffc0205930:	74e2                	ld	s1,56(sp)
ffffffffc0205932:	7942                	ld	s2,48(sp)
ffffffffc0205934:	79a2                	ld	s3,40(sp)
ffffffffc0205936:	6161                	addi	sp,sp,80
ffffffffc0205938:	8082                	ret

ffffffffc020593a <sysfile_fsync>:
ffffffffc020593a:	f34ff06f          	j	ffffffffc020506e <file_fsync>

ffffffffc020593e <sysfile_getcwd>:
ffffffffc020593e:	c1d5                	beqz	a1,ffffffffc02059e2 <sysfile_getcwd+0xa4>
ffffffffc0205940:	00092717          	auipc	a4,0x92
ffffffffc0205944:	f9073703          	ld	a4,-112(a4) # ffffffffc02978d0 <current>
ffffffffc0205948:	711d                	addi	sp,sp,-96
ffffffffc020594a:	e8a2                	sd	s0,80(sp)
ffffffffc020594c:	7700                	ld	s0,40(a4)
ffffffffc020594e:	e4a6                	sd	s1,72(sp)
ffffffffc0205950:	e0ca                	sd	s2,64(sp)
ffffffffc0205952:	ec86                	sd	ra,88(sp)
ffffffffc0205954:	892a                	mv	s2,a0
ffffffffc0205956:	84ae                	mv	s1,a1
ffffffffc0205958:	c039                	beqz	s0,ffffffffc020599e <sysfile_getcwd+0x60>
ffffffffc020595a:	03840513          	addi	a0,s0,56
ffffffffc020595e:	cbbfe0ef          	jal	ffffffffc0204618 <down>
ffffffffc0205962:	00092797          	auipc	a5,0x92
ffffffffc0205966:	f6e7b783          	ld	a5,-146(a5) # ffffffffc02978d0 <current>
ffffffffc020596a:	c399                	beqz	a5,ffffffffc0205970 <sysfile_getcwd+0x32>
ffffffffc020596c:	43dc                	lw	a5,4(a5)
ffffffffc020596e:	c83c                	sw	a5,80(s0)
ffffffffc0205970:	4685                	li	a3,1
ffffffffc0205972:	8626                	mv	a2,s1
ffffffffc0205974:	85ca                	mv	a1,s2
ffffffffc0205976:	8522                	mv	a0,s0
ffffffffc0205978:	8dbfe0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc020597c:	57f5                	li	a5,-3
ffffffffc020597e:	e921                	bnez	a0,ffffffffc02059ce <sysfile_getcwd+0x90>
ffffffffc0205980:	03840513          	addi	a0,s0,56
ffffffffc0205984:	e43e                	sd	a5,8(sp)
ffffffffc0205986:	c8ffe0ef          	jal	ffffffffc0204614 <up>
ffffffffc020598a:	67a2                	ld	a5,8(sp)
ffffffffc020598c:	04042823          	sw	zero,80(s0)
ffffffffc0205990:	60e6                	ld	ra,88(sp)
ffffffffc0205992:	6446                	ld	s0,80(sp)
ffffffffc0205994:	64a6                	ld	s1,72(sp)
ffffffffc0205996:	6906                	ld	s2,64(sp)
ffffffffc0205998:	853e                	mv	a0,a5
ffffffffc020599a:	6125                	addi	sp,sp,96
ffffffffc020599c:	8082                	ret
ffffffffc020599e:	862e                	mv	a2,a1
ffffffffc02059a0:	4685                	li	a3,1
ffffffffc02059a2:	85aa                	mv	a1,a0
ffffffffc02059a4:	4501                	li	a0,0
ffffffffc02059a6:	8adfe0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc02059aa:	57f5                	li	a5,-3
ffffffffc02059ac:	d175                	beqz	a0,ffffffffc0205990 <sysfile_getcwd+0x52>
ffffffffc02059ae:	8626                	mv	a2,s1
ffffffffc02059b0:	85ca                	mv	a1,s2
ffffffffc02059b2:	4681                	li	a3,0
ffffffffc02059b4:	0808                	addi	a0,sp,16
ffffffffc02059b6:	af9ff0ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc02059ba:	19a030ef          	jal	ffffffffc0208b54 <vfs_getcwd>
ffffffffc02059be:	60e6                	ld	ra,88(sp)
ffffffffc02059c0:	6446                	ld	s0,80(sp)
ffffffffc02059c2:	87aa                	mv	a5,a0
ffffffffc02059c4:	64a6                	ld	s1,72(sp)
ffffffffc02059c6:	6906                	ld	s2,64(sp)
ffffffffc02059c8:	853e                	mv	a0,a5
ffffffffc02059ca:	6125                	addi	sp,sp,96
ffffffffc02059cc:	8082                	ret
ffffffffc02059ce:	8626                	mv	a2,s1
ffffffffc02059d0:	85ca                	mv	a1,s2
ffffffffc02059d2:	4681                	li	a3,0
ffffffffc02059d4:	0808                	addi	a0,sp,16
ffffffffc02059d6:	ad9ff0ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc02059da:	17a030ef          	jal	ffffffffc0208b54 <vfs_getcwd>
ffffffffc02059de:	87aa                	mv	a5,a0
ffffffffc02059e0:	b745                	j	ffffffffc0205980 <sysfile_getcwd+0x42>
ffffffffc02059e2:	57f5                	li	a5,-3
ffffffffc02059e4:	853e                	mv	a0,a5
ffffffffc02059e6:	8082                	ret

ffffffffc02059e8 <sysfile_getdirentry>:
ffffffffc02059e8:	7139                	addi	sp,sp,-64
ffffffffc02059ea:	ec4e                	sd	s3,24(sp)
ffffffffc02059ec:	00092997          	auipc	s3,0x92
ffffffffc02059f0:	ee498993          	addi	s3,s3,-284 # ffffffffc02978d0 <current>
ffffffffc02059f4:	0009b783          	ld	a5,0(s3)
ffffffffc02059f8:	f04a                	sd	s2,32(sp)
ffffffffc02059fa:	892a                	mv	s2,a0
ffffffffc02059fc:	10800513          	li	a0,264
ffffffffc0205a00:	f426                	sd	s1,40(sp)
ffffffffc0205a02:	e852                	sd	s4,16(sp)
ffffffffc0205a04:	fc06                	sd	ra,56(sp)
ffffffffc0205a06:	7784                	ld	s1,40(a5)
ffffffffc0205a08:	8a2e                	mv	s4,a1
ffffffffc0205a0a:	f7efc0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0205a0e:	c179                	beqz	a0,ffffffffc0205ad4 <sysfile_getdirentry+0xec>
ffffffffc0205a10:	f822                	sd	s0,48(sp)
ffffffffc0205a12:	842a                	mv	s0,a0
ffffffffc0205a14:	c8d1                	beqz	s1,ffffffffc0205aa8 <sysfile_getdirentry+0xc0>
ffffffffc0205a16:	03848513          	addi	a0,s1,56
ffffffffc0205a1a:	bfffe0ef          	jal	ffffffffc0204618 <down>
ffffffffc0205a1e:	0009b783          	ld	a5,0(s3)
ffffffffc0205a22:	c399                	beqz	a5,ffffffffc0205a28 <sysfile_getdirentry+0x40>
ffffffffc0205a24:	43dc                	lw	a5,4(a5)
ffffffffc0205a26:	c8bc                	sw	a5,80(s1)
ffffffffc0205a28:	4705                	li	a4,1
ffffffffc0205a2a:	46a1                	li	a3,8
ffffffffc0205a2c:	8652                	mv	a2,s4
ffffffffc0205a2e:	85a2                	mv	a1,s0
ffffffffc0205a30:	8526                	mv	a0,s1
ffffffffc0205a32:	8c5fe0ef          	jal	ffffffffc02042f6 <copy_from_user>
ffffffffc0205a36:	e505                	bnez	a0,ffffffffc0205a5e <sysfile_getdirentry+0x76>
ffffffffc0205a38:	03848513          	addi	a0,s1,56
ffffffffc0205a3c:	bd9fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205a40:	0404a823          	sw	zero,80(s1)
ffffffffc0205a44:	5975                	li	s2,-3
ffffffffc0205a46:	8522                	mv	a0,s0
ffffffffc0205a48:	fe6fc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0205a4c:	7442                	ld	s0,48(sp)
ffffffffc0205a4e:	70e2                	ld	ra,56(sp)
ffffffffc0205a50:	74a2                	ld	s1,40(sp)
ffffffffc0205a52:	69e2                	ld	s3,24(sp)
ffffffffc0205a54:	6a42                	ld	s4,16(sp)
ffffffffc0205a56:	854a                	mv	a0,s2
ffffffffc0205a58:	7902                	ld	s2,32(sp)
ffffffffc0205a5a:	6121                	addi	sp,sp,64
ffffffffc0205a5c:	8082                	ret
ffffffffc0205a5e:	03848513          	addi	a0,s1,56
ffffffffc0205a62:	bb3fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205a66:	854a                	mv	a0,s2
ffffffffc0205a68:	0404a823          	sw	zero,80(s1)
ffffffffc0205a6c:	85a2                	mv	a1,s0
ffffffffc0205a6e:	eaaff0ef          	jal	ffffffffc0205118 <file_getdirentry>
ffffffffc0205a72:	892a                	mv	s2,a0
ffffffffc0205a74:	f969                	bnez	a0,ffffffffc0205a46 <sysfile_getdirentry+0x5e>
ffffffffc0205a76:	03848513          	addi	a0,s1,56
ffffffffc0205a7a:	b9ffe0ef          	jal	ffffffffc0204618 <down>
ffffffffc0205a7e:	0009b783          	ld	a5,0(s3)
ffffffffc0205a82:	c399                	beqz	a5,ffffffffc0205a88 <sysfile_getdirentry+0xa0>
ffffffffc0205a84:	43dc                	lw	a5,4(a5)
ffffffffc0205a86:	c8bc                	sw	a5,80(s1)
ffffffffc0205a88:	85d2                	mv	a1,s4
ffffffffc0205a8a:	10800693          	li	a3,264
ffffffffc0205a8e:	8622                	mv	a2,s0
ffffffffc0205a90:	8526                	mv	a0,s1
ffffffffc0205a92:	89bfe0ef          	jal	ffffffffc020432c <copy_to_user>
ffffffffc0205a96:	e111                	bnez	a0,ffffffffc0205a9a <sysfile_getdirentry+0xb2>
ffffffffc0205a98:	5975                	li	s2,-3
ffffffffc0205a9a:	03848513          	addi	a0,s1,56
ffffffffc0205a9e:	b77fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0205aa2:	0404a823          	sw	zero,80(s1)
ffffffffc0205aa6:	b745                	j	ffffffffc0205a46 <sysfile_getdirentry+0x5e>
ffffffffc0205aa8:	85aa                	mv	a1,a0
ffffffffc0205aaa:	4705                	li	a4,1
ffffffffc0205aac:	46a1                	li	a3,8
ffffffffc0205aae:	8652                	mv	a2,s4
ffffffffc0205ab0:	4501                	li	a0,0
ffffffffc0205ab2:	845fe0ef          	jal	ffffffffc02042f6 <copy_from_user>
ffffffffc0205ab6:	d559                	beqz	a0,ffffffffc0205a44 <sysfile_getdirentry+0x5c>
ffffffffc0205ab8:	854a                	mv	a0,s2
ffffffffc0205aba:	85a2                	mv	a1,s0
ffffffffc0205abc:	e5cff0ef          	jal	ffffffffc0205118 <file_getdirentry>
ffffffffc0205ac0:	892a                	mv	s2,a0
ffffffffc0205ac2:	f151                	bnez	a0,ffffffffc0205a46 <sysfile_getdirentry+0x5e>
ffffffffc0205ac4:	85d2                	mv	a1,s4
ffffffffc0205ac6:	10800693          	li	a3,264
ffffffffc0205aca:	8622                	mv	a2,s0
ffffffffc0205acc:	861fe0ef          	jal	ffffffffc020432c <copy_to_user>
ffffffffc0205ad0:	f93d                	bnez	a0,ffffffffc0205a46 <sysfile_getdirentry+0x5e>
ffffffffc0205ad2:	bf8d                	j	ffffffffc0205a44 <sysfile_getdirentry+0x5c>
ffffffffc0205ad4:	5971                	li	s2,-4
ffffffffc0205ad6:	bfa5                	j	ffffffffc0205a4e <sysfile_getdirentry+0x66>

ffffffffc0205ad8 <sysfile_dup>:
ffffffffc0205ad8:	f2eff06f          	j	ffffffffc0205206 <file_dup>

ffffffffc0205adc <kernel_thread_entry>:
ffffffffc0205adc:	8526                	mv	a0,s1
ffffffffc0205ade:	9402                	jalr	s0
ffffffffc0205ae0:	688000ef          	jal	ffffffffc0206168 <do_exit>

ffffffffc0205ae4 <alloc_proc>:
ffffffffc0205ae4:	1141                	addi	sp,sp,-16
ffffffffc0205ae6:	15000513          	li	a0,336
ffffffffc0205aea:	e022                	sd	s0,0(sp)
ffffffffc0205aec:	e406                	sd	ra,8(sp)
ffffffffc0205aee:	e9afc0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0205af2:	842a                	mv	s0,a0
ffffffffc0205af4:	c141                	beqz	a0,ffffffffc0205b74 <alloc_proc+0x90>
ffffffffc0205af6:	57fd                	li	a5,-1
ffffffffc0205af8:	1782                	slli	a5,a5,0x20
ffffffffc0205afa:	e11c                	sd	a5,0(a0)
ffffffffc0205afc:	00052423          	sw	zero,8(a0)
ffffffffc0205b00:	00053823          	sd	zero,16(a0)
ffffffffc0205b04:	00053c23          	sd	zero,24(a0)
ffffffffc0205b08:	02053023          	sd	zero,32(a0)
ffffffffc0205b0c:	02053423          	sd	zero,40(a0)
ffffffffc0205b10:	07000613          	li	a2,112
ffffffffc0205b14:	4581                	li	a1,0
ffffffffc0205b16:	03050513          	addi	a0,a0,48
ffffffffc0205b1a:	1b6060ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0205b1e:	00092797          	auipc	a5,0x92
ffffffffc0205b22:	d7a7b783          	ld	a5,-646(a5) # ffffffffc0297898 <boot_pgdir_pa>
ffffffffc0205b26:	0a043023          	sd	zero,160(s0)
ffffffffc0205b2a:	0a042823          	sw	zero,176(s0)
ffffffffc0205b2e:	f45c                	sd	a5,168(s0)
ffffffffc0205b30:	0b440513          	addi	a0,s0,180
ffffffffc0205b34:	463d                	li	a2,15
ffffffffc0205b36:	4581                	li	a1,0
ffffffffc0205b38:	198060ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0205b3c:	11040793          	addi	a5,s0,272
ffffffffc0205b40:	0e042623          	sw	zero,236(s0)
ffffffffc0205b44:	0e043c23          	sd	zero,248(s0)
ffffffffc0205b48:	10043023          	sd	zero,256(s0)
ffffffffc0205b4c:	0e043823          	sd	zero,240(s0)
ffffffffc0205b50:	10043423          	sd	zero,264(s0)
ffffffffc0205b54:	12042023          	sw	zero,288(s0)
ffffffffc0205b58:	12043423          	sd	zero,296(s0)
ffffffffc0205b5c:	12043c23          	sd	zero,312(s0)
ffffffffc0205b60:	12043823          	sd	zero,304(s0)
ffffffffc0205b64:	14043023          	sd	zero,320(s0)
ffffffffc0205b68:	14043423          	sd	zero,328(s0)
ffffffffc0205b6c:	10f43c23          	sd	a5,280(s0)
ffffffffc0205b70:	10f43823          	sd	a5,272(s0)
ffffffffc0205b74:	60a2                	ld	ra,8(sp)
ffffffffc0205b76:	8522                	mv	a0,s0
ffffffffc0205b78:	6402                	ld	s0,0(sp)
ffffffffc0205b7a:	0141                	addi	sp,sp,16
ffffffffc0205b7c:	8082                	ret

ffffffffc0205b7e <forkret>:
ffffffffc0205b7e:	00092797          	auipc	a5,0x92
ffffffffc0205b82:	d527b783          	ld	a5,-686(a5) # ffffffffc02978d0 <current>
ffffffffc0205b86:	73c8                	ld	a0,160(a5)
ffffffffc0205b88:	88ffb06f          	j	ffffffffc0201416 <forkrets>

ffffffffc0205b8c <put_pgdir.isra.0>:
ffffffffc0205b8c:	1141                	addi	sp,sp,-16
ffffffffc0205b8e:	e406                	sd	ra,8(sp)
ffffffffc0205b90:	c02007b7          	lui	a5,0xc0200
ffffffffc0205b94:	02f56f63          	bltu	a0,a5,ffffffffc0205bd2 <put_pgdir.isra.0+0x46>
ffffffffc0205b98:	00092797          	auipc	a5,0x92
ffffffffc0205b9c:	d107b783          	ld	a5,-752(a5) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0205ba0:	00092717          	auipc	a4,0x92
ffffffffc0205ba4:	d1073703          	ld	a4,-752(a4) # ffffffffc02978b0 <npage>
ffffffffc0205ba8:	8d1d                	sub	a0,a0,a5
ffffffffc0205baa:	00c55793          	srli	a5,a0,0xc
ffffffffc0205bae:	02e7ff63          	bgeu	a5,a4,ffffffffc0205bec <put_pgdir.isra.0+0x60>
ffffffffc0205bb2:	0000a717          	auipc	a4,0xa
ffffffffc0205bb6:	47673703          	ld	a4,1142(a4) # ffffffffc0210028 <nbase>
ffffffffc0205bba:	00092517          	auipc	a0,0x92
ffffffffc0205bbe:	cfe53503          	ld	a0,-770(a0) # ffffffffc02978b8 <pages>
ffffffffc0205bc2:	60a2                	ld	ra,8(sp)
ffffffffc0205bc4:	8f99                	sub	a5,a5,a4
ffffffffc0205bc6:	079a                	slli	a5,a5,0x6
ffffffffc0205bc8:	4585                	li	a1,1
ffffffffc0205bca:	953e                	add	a0,a0,a5
ffffffffc0205bcc:	0141                	addi	sp,sp,16
ffffffffc0205bce:	fbcfc06f          	j	ffffffffc020238a <free_pages>
ffffffffc0205bd2:	86aa                	mv	a3,a0
ffffffffc0205bd4:	00007617          	auipc	a2,0x7
ffffffffc0205bd8:	0e460613          	addi	a2,a2,228 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc0205bdc:	07700593          	li	a1,119
ffffffffc0205be0:	00007517          	auipc	a0,0x7
ffffffffc0205be4:	05850513          	addi	a0,a0,88 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0205be8:	863fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0205bec:	00007617          	auipc	a2,0x7
ffffffffc0205bf0:	0f460613          	addi	a2,a2,244 # ffffffffc020cce0 <etext+0xfa8>
ffffffffc0205bf4:	06900593          	li	a1,105
ffffffffc0205bf8:	00007517          	auipc	a0,0x7
ffffffffc0205bfc:	04050513          	addi	a0,a0,64 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0205c00:	84bfa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205c04 <setup_pgdir>:
ffffffffc0205c04:	1101                	addi	sp,sp,-32
ffffffffc0205c06:	e426                	sd	s1,8(sp)
ffffffffc0205c08:	84aa                	mv	s1,a0
ffffffffc0205c0a:	4505                	li	a0,1
ffffffffc0205c0c:	ec06                	sd	ra,24(sp)
ffffffffc0205c0e:	f42fc0ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0205c12:	cd29                	beqz	a0,ffffffffc0205c6c <setup_pgdir+0x68>
ffffffffc0205c14:	00092697          	auipc	a3,0x92
ffffffffc0205c18:	ca46b683          	ld	a3,-860(a3) # ffffffffc02978b8 <pages>
ffffffffc0205c1c:	0000a797          	auipc	a5,0xa
ffffffffc0205c20:	40c7b783          	ld	a5,1036(a5) # ffffffffc0210028 <nbase>
ffffffffc0205c24:	00092717          	auipc	a4,0x92
ffffffffc0205c28:	c8c73703          	ld	a4,-884(a4) # ffffffffc02978b0 <npage>
ffffffffc0205c2c:	40d506b3          	sub	a3,a0,a3
ffffffffc0205c30:	8699                	srai	a3,a3,0x6
ffffffffc0205c32:	96be                	add	a3,a3,a5
ffffffffc0205c34:	00c69793          	slli	a5,a3,0xc
ffffffffc0205c38:	e822                	sd	s0,16(sp)
ffffffffc0205c3a:	83b1                	srli	a5,a5,0xc
ffffffffc0205c3c:	06b2                	slli	a3,a3,0xc
ffffffffc0205c3e:	02e7f963          	bgeu	a5,a4,ffffffffc0205c70 <setup_pgdir+0x6c>
ffffffffc0205c42:	00092797          	auipc	a5,0x92
ffffffffc0205c46:	c667b783          	ld	a5,-922(a5) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0205c4a:	00092597          	auipc	a1,0x92
ffffffffc0205c4e:	c565b583          	ld	a1,-938(a1) # ffffffffc02978a0 <boot_pgdir_va>
ffffffffc0205c52:	6605                	lui	a2,0x1
ffffffffc0205c54:	00f68433          	add	s0,a3,a5
ffffffffc0205c58:	8522                	mv	a0,s0
ffffffffc0205c5a:	0c6060ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc0205c5e:	ec80                	sd	s0,24(s1)
ffffffffc0205c60:	6442                	ld	s0,16(sp)
ffffffffc0205c62:	4501                	li	a0,0
ffffffffc0205c64:	60e2                	ld	ra,24(sp)
ffffffffc0205c66:	64a2                	ld	s1,8(sp)
ffffffffc0205c68:	6105                	addi	sp,sp,32
ffffffffc0205c6a:	8082                	ret
ffffffffc0205c6c:	5571                	li	a0,-4
ffffffffc0205c6e:	bfdd                	j	ffffffffc0205c64 <setup_pgdir+0x60>
ffffffffc0205c70:	00007617          	auipc	a2,0x7
ffffffffc0205c74:	fa060613          	addi	a2,a2,-96 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0205c78:	07100593          	li	a1,113
ffffffffc0205c7c:	00007517          	auipc	a0,0x7
ffffffffc0205c80:	fbc50513          	addi	a0,a0,-68 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0205c84:	fc6fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0205c88 <proc_run>:
ffffffffc0205c88:	00092697          	auipc	a3,0x92
ffffffffc0205c8c:	c486b683          	ld	a3,-952(a3) # ffffffffc02978d0 <current>
ffffffffc0205c90:	04a68663          	beq	a3,a0,ffffffffc0205cdc <proc_run+0x54>
ffffffffc0205c94:	1101                	addi	sp,sp,-32
ffffffffc0205c96:	ec06                	sd	ra,24(sp)
ffffffffc0205c98:	100027f3          	csrr	a5,sstatus
ffffffffc0205c9c:	8b89                	andi	a5,a5,2
ffffffffc0205c9e:	4601                	li	a2,0
ffffffffc0205ca0:	ef9d                	bnez	a5,ffffffffc0205cde <proc_run+0x56>
ffffffffc0205ca2:	755c                	ld	a5,168(a0)
ffffffffc0205ca4:	577d                	li	a4,-1
ffffffffc0205ca6:	177e                	slli	a4,a4,0x3f
ffffffffc0205ca8:	83b1                	srli	a5,a5,0xc
ffffffffc0205caa:	e032                	sd	a2,0(sp)
ffffffffc0205cac:	00092597          	auipc	a1,0x92
ffffffffc0205cb0:	c2a5b223          	sd	a0,-988(a1) # ffffffffc02978d0 <current>
ffffffffc0205cb4:	8fd9                	or	a5,a5,a4
ffffffffc0205cb6:	18079073          	csrw	satp,a5
ffffffffc0205cba:	12000073          	sfence.vma
ffffffffc0205cbe:	03050593          	addi	a1,a0,48
ffffffffc0205cc2:	03068513          	addi	a0,a3,48
ffffffffc0205cc6:	572010ef          	jal	ffffffffc0207238 <switch_to>
ffffffffc0205cca:	6602                	ld	a2,0(sp)
ffffffffc0205ccc:	e601                	bnez	a2,ffffffffc0205cd4 <proc_run+0x4c>
ffffffffc0205cce:	60e2                	ld	ra,24(sp)
ffffffffc0205cd0:	6105                	addi	sp,sp,32
ffffffffc0205cd2:	8082                	ret
ffffffffc0205cd4:	60e2                	ld	ra,24(sp)
ffffffffc0205cd6:	6105                	addi	sp,sp,32
ffffffffc0205cd8:	f93fa06f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0205cdc:	8082                	ret
ffffffffc0205cde:	e42a                	sd	a0,8(sp)
ffffffffc0205ce0:	e036                	sd	a3,0(sp)
ffffffffc0205ce2:	f8ffa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0205ce6:	6522                	ld	a0,8(sp)
ffffffffc0205ce8:	6682                	ld	a3,0(sp)
ffffffffc0205cea:	4605                	li	a2,1
ffffffffc0205cec:	bf5d                	j	ffffffffc0205ca2 <proc_run+0x1a>

ffffffffc0205cee <do_fork>:
ffffffffc0205cee:	00092717          	auipc	a4,0x92
ffffffffc0205cf2:	bda72703          	lw	a4,-1062(a4) # ffffffffc02978c8 <nr_process>
ffffffffc0205cf6:	6785                	lui	a5,0x1
ffffffffc0205cf8:	34f75a63          	bge	a4,a5,ffffffffc020604c <do_fork+0x35e>
ffffffffc0205cfc:	7119                	addi	sp,sp,-128
ffffffffc0205cfe:	f8a2                	sd	s0,112(sp)
ffffffffc0205d00:	f4a6                	sd	s1,104(sp)
ffffffffc0205d02:	f0ca                	sd	s2,96(sp)
ffffffffc0205d04:	ecce                	sd	s3,88(sp)
ffffffffc0205d06:	fc86                	sd	ra,120(sp)
ffffffffc0205d08:	892e                	mv	s2,a1
ffffffffc0205d0a:	84b2                	mv	s1,a2
ffffffffc0205d0c:	89aa                	mv	s3,a0
ffffffffc0205d0e:	dd7ff0ef          	jal	ffffffffc0205ae4 <alloc_proc>
ffffffffc0205d12:	842a                	mv	s0,a0
ffffffffc0205d14:	2a050263          	beqz	a0,ffffffffc0205fb8 <do_fork+0x2ca>
ffffffffc0205d18:	f466                	sd	s9,40(sp)
ffffffffc0205d1a:	00092c97          	auipc	s9,0x92
ffffffffc0205d1e:	bb6c8c93          	addi	s9,s9,-1098 # ffffffffc02978d0 <current>
ffffffffc0205d22:	000cb783          	ld	a5,0(s9)
ffffffffc0205d26:	0ec7a703          	lw	a4,236(a5) # 10ec <_binary_bin_swap_img_size-0x6c14>
ffffffffc0205d2a:	f11c                	sd	a5,32(a0)
ffffffffc0205d2c:	3a071163          	bnez	a4,ffffffffc02060ce <do_fork+0x3e0>
ffffffffc0205d30:	4509                	li	a0,2
ffffffffc0205d32:	e1efc0ef          	jal	ffffffffc0202350 <alloc_pages>
ffffffffc0205d36:	26050d63          	beqz	a0,ffffffffc0205fb0 <do_fork+0x2c2>
ffffffffc0205d3a:	e4d6                	sd	s5,72(sp)
ffffffffc0205d3c:	00092a97          	auipc	s5,0x92
ffffffffc0205d40:	b7ca8a93          	addi	s5,s5,-1156 # ffffffffc02978b8 <pages>
ffffffffc0205d44:	000ab783          	ld	a5,0(s5)
ffffffffc0205d48:	e8d2                	sd	s4,80(sp)
ffffffffc0205d4a:	0000aa17          	auipc	s4,0xa
ffffffffc0205d4e:	2dea3a03          	ld	s4,734(s4) # ffffffffc0210028 <nbase>
ffffffffc0205d52:	40f506b3          	sub	a3,a0,a5
ffffffffc0205d56:	e0da                	sd	s6,64(sp)
ffffffffc0205d58:	8699                	srai	a3,a3,0x6
ffffffffc0205d5a:	00092b17          	auipc	s6,0x92
ffffffffc0205d5e:	b56b0b13          	addi	s6,s6,-1194 # ffffffffc02978b0 <npage>
ffffffffc0205d62:	96d2                	add	a3,a3,s4
ffffffffc0205d64:	000b3703          	ld	a4,0(s6)
ffffffffc0205d68:	00c69793          	slli	a5,a3,0xc
ffffffffc0205d6c:	fc5e                	sd	s7,56(sp)
ffffffffc0205d6e:	f862                	sd	s8,48(sp)
ffffffffc0205d70:	83b1                	srli	a5,a5,0xc
ffffffffc0205d72:	06b2                	slli	a3,a3,0xc
ffffffffc0205d74:	38e7f463          	bgeu	a5,a4,ffffffffc02060fc <do_fork+0x40e>
ffffffffc0205d78:	000cb703          	ld	a4,0(s9)
ffffffffc0205d7c:	00092b97          	auipc	s7,0x92
ffffffffc0205d80:	b2cb8b93          	addi	s7,s7,-1236 # ffffffffc02978a8 <va_pa_offset>
ffffffffc0205d84:	000bb783          	ld	a5,0(s7)
ffffffffc0205d88:	02873c03          	ld	s8,40(a4)
ffffffffc0205d8c:	96be                	add	a3,a3,a5
ffffffffc0205d8e:	e814                	sd	a3,16(s0)
ffffffffc0205d90:	020c0a63          	beqz	s8,ffffffffc0205dc4 <do_fork+0xd6>
ffffffffc0205d94:	1009f793          	andi	a5,s3,256
ffffffffc0205d98:	1c078363          	beqz	a5,ffffffffc0205f5e <do_fork+0x270>
ffffffffc0205d9c:	030c2703          	lw	a4,48(s8)
ffffffffc0205da0:	018c3783          	ld	a5,24(s8)
ffffffffc0205da4:	c02006b7          	lui	a3,0xc0200
ffffffffc0205da8:	2705                	addiw	a4,a4,1
ffffffffc0205daa:	02ec2823          	sw	a4,48(s8)
ffffffffc0205dae:	03843423          	sd	s8,40(s0)
ffffffffc0205db2:	2ed7ef63          	bltu	a5,a3,ffffffffc02060b0 <do_fork+0x3c2>
ffffffffc0205db6:	000bb603          	ld	a2,0(s7)
ffffffffc0205dba:	000cb703          	ld	a4,0(s9)
ffffffffc0205dbe:	6814                	ld	a3,16(s0)
ffffffffc0205dc0:	8f91                	sub	a5,a5,a2
ffffffffc0205dc2:	f45c                	sd	a5,168(s0)
ffffffffc0205dc4:	6789                	lui	a5,0x2
ffffffffc0205dc6:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205dca:	96be                	add	a3,a3,a5
ffffffffc0205dcc:	f054                	sd	a3,160(s0)
ffffffffc0205dce:	87b6                	mv	a5,a3
ffffffffc0205dd0:	12048613          	addi	a2,s1,288
ffffffffc0205dd4:	688c                	ld	a1,16(s1)
ffffffffc0205dd6:	0004b803          	ld	a6,0(s1)
ffffffffc0205dda:	6488                	ld	a0,8(s1)
ffffffffc0205ddc:	eb8c                	sd	a1,16(a5)
ffffffffc0205dde:	0107b023          	sd	a6,0(a5)
ffffffffc0205de2:	e788                	sd	a0,8(a5)
ffffffffc0205de4:	6c8c                	ld	a1,24(s1)
ffffffffc0205de6:	02048493          	addi	s1,s1,32
ffffffffc0205dea:	02078793          	addi	a5,a5,32
ffffffffc0205dee:	feb7bc23          	sd	a1,-8(a5)
ffffffffc0205df2:	fec491e3          	bne	s1,a2,ffffffffc0205dd4 <do_fork+0xe6>
ffffffffc0205df6:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
ffffffffc0205dfa:	1c090163          	beqz	s2,ffffffffc0205fbc <do_fork+0x2ce>
ffffffffc0205dfe:	14873483          	ld	s1,328(a4)
ffffffffc0205e02:	00000797          	auipc	a5,0x0
ffffffffc0205e06:	d7c78793          	addi	a5,a5,-644 # ffffffffc0205b7e <forkret>
ffffffffc0205e0a:	0126b823          	sd	s2,16(a3)
ffffffffc0205e0e:	fc14                	sd	a3,56(s0)
ffffffffc0205e10:	f81c                	sd	a5,48(s0)
ffffffffc0205e12:	24048f63          	beqz	s1,ffffffffc0206070 <do_fork+0x382>
ffffffffc0205e16:	03499793          	slli	a5,s3,0x34
ffffffffc0205e1a:	0007cd63          	bltz	a5,ffffffffc0205e34 <do_fork+0x146>
ffffffffc0205e1e:	c7cff0ef          	jal	ffffffffc020529a <files_create>
ffffffffc0205e22:	892a                	mv	s2,a0
ffffffffc0205e24:	20050163          	beqz	a0,ffffffffc0206026 <do_fork+0x338>
ffffffffc0205e28:	85a6                	mv	a1,s1
ffffffffc0205e2a:	da8ff0ef          	jal	ffffffffc02053d2 <dup_files>
ffffffffc0205e2e:	84ca                	mv	s1,s2
ffffffffc0205e30:	1e051863          	bnez	a0,ffffffffc0206020 <do_fork+0x332>
ffffffffc0205e34:	489c                	lw	a5,16(s1)
ffffffffc0205e36:	2785                	addiw	a5,a5,1
ffffffffc0205e38:	c89c                	sw	a5,16(s1)
ffffffffc0205e3a:	14943423          	sd	s1,328(s0)
ffffffffc0205e3e:	100027f3          	csrr	a5,sstatus
ffffffffc0205e42:	8b89                	andi	a5,a5,2
ffffffffc0205e44:	1c079a63          	bnez	a5,ffffffffc0206018 <do_fork+0x32a>
ffffffffc0205e48:	4901                	li	s2,0
ffffffffc0205e4a:	0008c517          	auipc	a0,0x8c
ffffffffc0205e4e:	21252503          	lw	a0,530(a0) # ffffffffc029205c <last_pid.1>
ffffffffc0205e52:	6789                	lui	a5,0x2
ffffffffc0205e54:	2505                	addiw	a0,a0,1
ffffffffc0205e56:	0008c717          	auipc	a4,0x8c
ffffffffc0205e5a:	20a72323          	sw	a0,518(a4) # ffffffffc029205c <last_pid.1>
ffffffffc0205e5e:	16f55163          	bge	a0,a5,ffffffffc0205fc0 <do_fork+0x2d2>
ffffffffc0205e62:	0008c797          	auipc	a5,0x8c
ffffffffc0205e66:	1f67a783          	lw	a5,502(a5) # ffffffffc0292058 <next_safe.0>
ffffffffc0205e6a:	00091497          	auipc	s1,0x91
ffffffffc0205e6e:	95648493          	addi	s1,s1,-1706 # ffffffffc02967c0 <proc_list>
ffffffffc0205e72:	06f54563          	blt	a0,a5,ffffffffc0205edc <do_fork+0x1ee>
ffffffffc0205e76:	00091497          	auipc	s1,0x91
ffffffffc0205e7a:	94a48493          	addi	s1,s1,-1718 # ffffffffc02967c0 <proc_list>
ffffffffc0205e7e:	0084b883          	ld	a7,8(s1)
ffffffffc0205e82:	6789                	lui	a5,0x2
ffffffffc0205e84:	0008c717          	auipc	a4,0x8c
ffffffffc0205e88:	1cf72a23          	sw	a5,468(a4) # ffffffffc0292058 <next_safe.0>
ffffffffc0205e8c:	86aa                	mv	a3,a0
ffffffffc0205e8e:	4581                	li	a1,0
ffffffffc0205e90:	04988063          	beq	a7,s1,ffffffffc0205ed0 <do_fork+0x1e2>
ffffffffc0205e94:	882e                	mv	a6,a1
ffffffffc0205e96:	87c6                	mv	a5,a7
ffffffffc0205e98:	6609                	lui	a2,0x2
ffffffffc0205e9a:	a811                	j	ffffffffc0205eae <do_fork+0x1c0>
ffffffffc0205e9c:	00e6d663          	bge	a3,a4,ffffffffc0205ea8 <do_fork+0x1ba>
ffffffffc0205ea0:	00c75463          	bge	a4,a2,ffffffffc0205ea8 <do_fork+0x1ba>
ffffffffc0205ea4:	863a                	mv	a2,a4
ffffffffc0205ea6:	4805                	li	a6,1
ffffffffc0205ea8:	679c                	ld	a5,8(a5)
ffffffffc0205eaa:	00978d63          	beq	a5,s1,ffffffffc0205ec4 <do_fork+0x1d6>
ffffffffc0205eae:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205eb2:	fed715e3          	bne	a4,a3,ffffffffc0205e9c <do_fork+0x1ae>
ffffffffc0205eb6:	2685                	addiw	a3,a3,1
ffffffffc0205eb8:	10c6dd63          	bge	a3,a2,ffffffffc0205fd2 <do_fork+0x2e4>
ffffffffc0205ebc:	679c                	ld	a5,8(a5)
ffffffffc0205ebe:	4585                	li	a1,1
ffffffffc0205ec0:	fe9797e3          	bne	a5,s1,ffffffffc0205eae <do_fork+0x1c0>
ffffffffc0205ec4:	00080663          	beqz	a6,ffffffffc0205ed0 <do_fork+0x1e2>
ffffffffc0205ec8:	0008c797          	auipc	a5,0x8c
ffffffffc0205ecc:	18c7a823          	sw	a2,400(a5) # ffffffffc0292058 <next_safe.0>
ffffffffc0205ed0:	c591                	beqz	a1,ffffffffc0205edc <do_fork+0x1ee>
ffffffffc0205ed2:	0008c797          	auipc	a5,0x8c
ffffffffc0205ed6:	18d7a523          	sw	a3,394(a5) # ffffffffc029205c <last_pid.1>
ffffffffc0205eda:	8536                	mv	a0,a3
ffffffffc0205edc:	c048                	sw	a0,4(s0)
ffffffffc0205ede:	45a9                	li	a1,10
ffffffffc0205ee0:	0b5050ef          	jal	ffffffffc020b794 <hash32>
ffffffffc0205ee4:	02051793          	slli	a5,a0,0x20
ffffffffc0205ee8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205eec:	0008d797          	auipc	a5,0x8d
ffffffffc0205ef0:	8d478793          	addi	a5,a5,-1836 # ffffffffc02927c0 <hash_list>
ffffffffc0205ef4:	953e                	add	a0,a0,a5
ffffffffc0205ef6:	6518                	ld	a4,8(a0)
ffffffffc0205ef8:	0d840793          	addi	a5,s0,216
ffffffffc0205efc:	6490                	ld	a2,8(s1)
ffffffffc0205efe:	e31c                	sd	a5,0(a4)
ffffffffc0205f00:	e51c                	sd	a5,8(a0)
ffffffffc0205f02:	f078                	sd	a4,224(s0)
ffffffffc0205f04:	0c840793          	addi	a5,s0,200
ffffffffc0205f08:	7018                	ld	a4,32(s0)
ffffffffc0205f0a:	ec68                	sd	a0,216(s0)
ffffffffc0205f0c:	e21c                	sd	a5,0(a2)
ffffffffc0205f0e:	0e043c23          	sd	zero,248(s0)
ffffffffc0205f12:	7b74                	ld	a3,240(a4)
ffffffffc0205f14:	e49c                	sd	a5,8(s1)
ffffffffc0205f16:	e870                	sd	a2,208(s0)
ffffffffc0205f18:	e464                	sd	s1,200(s0)
ffffffffc0205f1a:	10d43023          	sd	a3,256(s0)
ffffffffc0205f1e:	c299                	beqz	a3,ffffffffc0205f24 <do_fork+0x236>
ffffffffc0205f20:	fee0                	sd	s0,248(a3)
ffffffffc0205f22:	7018                	ld	a4,32(s0)
ffffffffc0205f24:	00092797          	auipc	a5,0x92
ffffffffc0205f28:	9a47a783          	lw	a5,-1628(a5) # ffffffffc02978c8 <nr_process>
ffffffffc0205f2c:	fb60                	sd	s0,240(a4)
ffffffffc0205f2e:	2785                	addiw	a5,a5,1
ffffffffc0205f30:	00092717          	auipc	a4,0x92
ffffffffc0205f34:	98f72c23          	sw	a5,-1640(a4) # ffffffffc02978c8 <nr_process>
ffffffffc0205f38:	08091a63          	bnez	s2,ffffffffc0205fcc <do_fork+0x2de>
ffffffffc0205f3c:	8522                	mv	a0,s0
ffffffffc0205f3e:	1e3010ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc0205f42:	4048                	lw	a0,4(s0)
ffffffffc0205f44:	6a46                	ld	s4,80(sp)
ffffffffc0205f46:	6aa6                	ld	s5,72(sp)
ffffffffc0205f48:	6b06                	ld	s6,64(sp)
ffffffffc0205f4a:	7be2                	ld	s7,56(sp)
ffffffffc0205f4c:	7c42                	ld	s8,48(sp)
ffffffffc0205f4e:	7ca2                	ld	s9,40(sp)
ffffffffc0205f50:	70e6                	ld	ra,120(sp)
ffffffffc0205f52:	7446                	ld	s0,112(sp)
ffffffffc0205f54:	74a6                	ld	s1,104(sp)
ffffffffc0205f56:	7906                	ld	s2,96(sp)
ffffffffc0205f58:	69e6                	ld	s3,88(sp)
ffffffffc0205f5a:	6109                	addi	sp,sp,128
ffffffffc0205f5c:	8082                	ret
ffffffffc0205f5e:	f06a                	sd	s10,32(sp)
ffffffffc0205f60:	c53fd0ef          	jal	ffffffffc0203bb2 <mm_create>
ffffffffc0205f64:	8d2a                	mv	s10,a0
ffffffffc0205f66:	0e050563          	beqz	a0,ffffffffc0206050 <do_fork+0x362>
ffffffffc0205f6a:	c9bff0ef          	jal	ffffffffc0205c04 <setup_pgdir>
ffffffffc0205f6e:	c925                	beqz	a0,ffffffffc0205fde <do_fork+0x2f0>
ffffffffc0205f70:	856a                	mv	a0,s10
ffffffffc0205f72:	d8dfd0ef          	jal	ffffffffc0203cfe <mm_destroy>
ffffffffc0205f76:	7d02                	ld	s10,32(sp)
ffffffffc0205f78:	6814                	ld	a3,16(s0)
ffffffffc0205f7a:	c02007b7          	lui	a5,0xc0200
ffffffffc0205f7e:	0cf6eb63          	bltu	a3,a5,ffffffffc0206054 <do_fork+0x366>
ffffffffc0205f82:	000bb783          	ld	a5,0(s7)
ffffffffc0205f86:	000b3703          	ld	a4,0(s6)
ffffffffc0205f8a:	40f687b3          	sub	a5,a3,a5
ffffffffc0205f8e:	83b1                	srli	a5,a5,0xc
ffffffffc0205f90:	10e7f263          	bgeu	a5,a4,ffffffffc0206094 <do_fork+0x3a6>
ffffffffc0205f94:	000ab503          	ld	a0,0(s5)
ffffffffc0205f98:	414787b3          	sub	a5,a5,s4
ffffffffc0205f9c:	079a                	slli	a5,a5,0x6
ffffffffc0205f9e:	953e                	add	a0,a0,a5
ffffffffc0205fa0:	4589                	li	a1,2
ffffffffc0205fa2:	be8fc0ef          	jal	ffffffffc020238a <free_pages>
ffffffffc0205fa6:	6a46                	ld	s4,80(sp)
ffffffffc0205fa8:	6aa6                	ld	s5,72(sp)
ffffffffc0205faa:	6b06                	ld	s6,64(sp)
ffffffffc0205fac:	7be2                	ld	s7,56(sp)
ffffffffc0205fae:	7c42                	ld	s8,48(sp)
ffffffffc0205fb0:	8522                	mv	a0,s0
ffffffffc0205fb2:	a7cfc0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0205fb6:	7ca2                	ld	s9,40(sp)
ffffffffc0205fb8:	5571                	li	a0,-4
ffffffffc0205fba:	bf59                	j	ffffffffc0205f50 <do_fork+0x262>
ffffffffc0205fbc:	8936                	mv	s2,a3
ffffffffc0205fbe:	b581                	j	ffffffffc0205dfe <do_fork+0x110>
ffffffffc0205fc0:	4505                	li	a0,1
ffffffffc0205fc2:	0008c797          	auipc	a5,0x8c
ffffffffc0205fc6:	08a7ad23          	sw	a0,154(a5) # ffffffffc029205c <last_pid.1>
ffffffffc0205fca:	b575                	j	ffffffffc0205e76 <do_fork+0x188>
ffffffffc0205fcc:	c9ffa0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0205fd0:	b7b5                	j	ffffffffc0205f3c <do_fork+0x24e>
ffffffffc0205fd2:	6789                	lui	a5,0x2
ffffffffc0205fd4:	00f6c363          	blt	a3,a5,ffffffffc0205fda <do_fork+0x2ec>
ffffffffc0205fd8:	4685                	li	a3,1
ffffffffc0205fda:	4585                	li	a1,1
ffffffffc0205fdc:	bd55                	j	ffffffffc0205e90 <do_fork+0x1a2>
ffffffffc0205fde:	038c0793          	addi	a5,s8,56
ffffffffc0205fe2:	853e                	mv	a0,a5
ffffffffc0205fe4:	e43e                	sd	a5,8(sp)
ffffffffc0205fe6:	ec6e                	sd	s11,24(sp)
ffffffffc0205fe8:	e30fe0ef          	jal	ffffffffc0204618 <down>
ffffffffc0205fec:	000cb783          	ld	a5,0(s9)
ffffffffc0205ff0:	c781                	beqz	a5,ffffffffc0205ff8 <do_fork+0x30a>
ffffffffc0205ff2:	43dc                	lw	a5,4(a5)
ffffffffc0205ff4:	04fc2823          	sw	a5,80(s8)
ffffffffc0205ff8:	85e2                	mv	a1,s8
ffffffffc0205ffa:	856a                	mv	a0,s10
ffffffffc0205ffc:	e21fd0ef          	jal	ffffffffc0203e1c <dup_mmap>
ffffffffc0206000:	8daa                	mv	s11,a0
ffffffffc0206002:	6522                	ld	a0,8(sp)
ffffffffc0206004:	e10fe0ef          	jal	ffffffffc0204614 <up>
ffffffffc0206008:	040c2823          	sw	zero,80(s8)
ffffffffc020600c:	8c6a                	mv	s8,s10
ffffffffc020600e:	020d9663          	bnez	s11,ffffffffc020603a <do_fork+0x34c>
ffffffffc0206012:	7d02                	ld	s10,32(sp)
ffffffffc0206014:	6de2                	ld	s11,24(sp)
ffffffffc0206016:	b359                	j	ffffffffc0205d9c <do_fork+0xae>
ffffffffc0206018:	c59fa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020601c:	4905                	li	s2,1
ffffffffc020601e:	b535                	j	ffffffffc0205e4a <do_fork+0x15c>
ffffffffc0206020:	854a                	mv	a0,s2
ffffffffc0206022:	aaeff0ef          	jal	ffffffffc02052d0 <files_destroy>
ffffffffc0206026:	14843503          	ld	a0,328(s0)
ffffffffc020602a:	d539                	beqz	a0,ffffffffc0205f78 <do_fork+0x28a>
ffffffffc020602c:	491c                	lw	a5,16(a0)
ffffffffc020602e:	37fd                	addiw	a5,a5,-1 # 1fff <_binary_bin_swap_img_size-0x5d01>
ffffffffc0206030:	c91c                	sw	a5,16(a0)
ffffffffc0206032:	f3b9                	bnez	a5,ffffffffc0205f78 <do_fork+0x28a>
ffffffffc0206034:	a9cff0ef          	jal	ffffffffc02052d0 <files_destroy>
ffffffffc0206038:	b781                	j	ffffffffc0205f78 <do_fork+0x28a>
ffffffffc020603a:	856a                	mv	a0,s10
ffffffffc020603c:	e79fd0ef          	jal	ffffffffc0203eb4 <exit_mmap>
ffffffffc0206040:	018d3503          	ld	a0,24(s10) # fffffffffff80018 <end+0x3fce8700>
ffffffffc0206044:	b49ff0ef          	jal	ffffffffc0205b8c <put_pgdir.isra.0>
ffffffffc0206048:	6de2                	ld	s11,24(sp)
ffffffffc020604a:	b71d                	j	ffffffffc0205f70 <do_fork+0x282>
ffffffffc020604c:	556d                	li	a0,-5
ffffffffc020604e:	8082                	ret
ffffffffc0206050:	7d02                	ld	s10,32(sp)
ffffffffc0206052:	b71d                	j	ffffffffc0205f78 <do_fork+0x28a>
ffffffffc0206054:	00007617          	auipc	a2,0x7
ffffffffc0206058:	c6460613          	addi	a2,a2,-924 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc020605c:	07700593          	li	a1,119
ffffffffc0206060:	00007517          	auipc	a0,0x7
ffffffffc0206064:	bd850513          	addi	a0,a0,-1064 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0206068:	f06a                	sd	s10,32(sp)
ffffffffc020606a:	ec6e                	sd	s11,24(sp)
ffffffffc020606c:	bdefa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206070:	00008697          	auipc	a3,0x8
ffffffffc0206074:	b9068693          	addi	a3,a3,-1136 # ffffffffc020dc00 <etext+0x1ec8>
ffffffffc0206078:	00006617          	auipc	a2,0x6
ffffffffc020607c:	0f860613          	addi	a2,a2,248 # ffffffffc020c170 <etext+0x438>
ffffffffc0206080:	1bd00593          	li	a1,445
ffffffffc0206084:	00008517          	auipc	a0,0x8
ffffffffc0206088:	b6450513          	addi	a0,a0,-1180 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc020608c:	f06a                	sd	s10,32(sp)
ffffffffc020608e:	ec6e                	sd	s11,24(sp)
ffffffffc0206090:	bbafa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206094:	00007617          	auipc	a2,0x7
ffffffffc0206098:	c4c60613          	addi	a2,a2,-948 # ffffffffc020cce0 <etext+0xfa8>
ffffffffc020609c:	06900593          	li	a1,105
ffffffffc02060a0:	00007517          	auipc	a0,0x7
ffffffffc02060a4:	b9850513          	addi	a0,a0,-1128 # ffffffffc020cc38 <etext+0xf00>
ffffffffc02060a8:	f06a                	sd	s10,32(sp)
ffffffffc02060aa:	ec6e                	sd	s11,24(sp)
ffffffffc02060ac:	b9efa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02060b0:	86be                	mv	a3,a5
ffffffffc02060b2:	00007617          	auipc	a2,0x7
ffffffffc02060b6:	c0660613          	addi	a2,a2,-1018 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc02060ba:	19d00593          	li	a1,413
ffffffffc02060be:	00008517          	auipc	a0,0x8
ffffffffc02060c2:	b2a50513          	addi	a0,a0,-1238 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02060c6:	f06a                	sd	s10,32(sp)
ffffffffc02060c8:	ec6e                	sd	s11,24(sp)
ffffffffc02060ca:	b80fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02060ce:	00008697          	auipc	a3,0x8
ffffffffc02060d2:	afa68693          	addi	a3,a3,-1286 # ffffffffc020dbc8 <etext+0x1e90>
ffffffffc02060d6:	00006617          	auipc	a2,0x6
ffffffffc02060da:	09a60613          	addi	a2,a2,154 # ffffffffc020c170 <etext+0x438>
ffffffffc02060de:	22100593          	li	a1,545
ffffffffc02060e2:	00008517          	auipc	a0,0x8
ffffffffc02060e6:	b0650513          	addi	a0,a0,-1274 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02060ea:	e8d2                	sd	s4,80(sp)
ffffffffc02060ec:	e4d6                	sd	s5,72(sp)
ffffffffc02060ee:	e0da                	sd	s6,64(sp)
ffffffffc02060f0:	fc5e                	sd	s7,56(sp)
ffffffffc02060f2:	f862                	sd	s8,48(sp)
ffffffffc02060f4:	f06a                	sd	s10,32(sp)
ffffffffc02060f6:	ec6e                	sd	s11,24(sp)
ffffffffc02060f8:	b52fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02060fc:	00007617          	auipc	a2,0x7
ffffffffc0206100:	b1460613          	addi	a2,a2,-1260 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0206104:	07100593          	li	a1,113
ffffffffc0206108:	00007517          	auipc	a0,0x7
ffffffffc020610c:	b3050513          	addi	a0,a0,-1232 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0206110:	f06a                	sd	s10,32(sp)
ffffffffc0206112:	ec6e                	sd	s11,24(sp)
ffffffffc0206114:	b36fa0ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206118 <kernel_thread>:
ffffffffc0206118:	7129                	addi	sp,sp,-320
ffffffffc020611a:	fa22                	sd	s0,304(sp)
ffffffffc020611c:	f626                	sd	s1,296(sp)
ffffffffc020611e:	f24a                	sd	s2,288(sp)
ffffffffc0206120:	842a                	mv	s0,a0
ffffffffc0206122:	84ae                	mv	s1,a1
ffffffffc0206124:	8932                	mv	s2,a2
ffffffffc0206126:	850a                	mv	a0,sp
ffffffffc0206128:	12000613          	li	a2,288
ffffffffc020612c:	4581                	li	a1,0
ffffffffc020612e:	fe06                	sd	ra,312(sp)
ffffffffc0206130:	3a1050ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0206134:	e0a2                	sd	s0,64(sp)
ffffffffc0206136:	e4a6                	sd	s1,72(sp)
ffffffffc0206138:	100027f3          	csrr	a5,sstatus
ffffffffc020613c:	edd7f793          	andi	a5,a5,-291
ffffffffc0206140:	1207e793          	ori	a5,a5,288
ffffffffc0206144:	860a                	mv	a2,sp
ffffffffc0206146:	10096513          	ori	a0,s2,256
ffffffffc020614a:	00000717          	auipc	a4,0x0
ffffffffc020614e:	99270713          	addi	a4,a4,-1646 # ffffffffc0205adc <kernel_thread_entry>
ffffffffc0206152:	4581                	li	a1,0
ffffffffc0206154:	e23e                	sd	a5,256(sp)
ffffffffc0206156:	e63a                	sd	a4,264(sp)
ffffffffc0206158:	b97ff0ef          	jal	ffffffffc0205cee <do_fork>
ffffffffc020615c:	70f2                	ld	ra,312(sp)
ffffffffc020615e:	7452                	ld	s0,304(sp)
ffffffffc0206160:	74b2                	ld	s1,296(sp)
ffffffffc0206162:	7912                	ld	s2,288(sp)
ffffffffc0206164:	6131                	addi	sp,sp,320
ffffffffc0206166:	8082                	ret

ffffffffc0206168 <do_exit>:
ffffffffc0206168:	7179                	addi	sp,sp,-48
ffffffffc020616a:	f022                	sd	s0,32(sp)
ffffffffc020616c:	00091417          	auipc	s0,0x91
ffffffffc0206170:	76440413          	addi	s0,s0,1892 # ffffffffc02978d0 <current>
ffffffffc0206174:	601c                	ld	a5,0(s0)
ffffffffc0206176:	00091717          	auipc	a4,0x91
ffffffffc020617a:	76a73703          	ld	a4,1898(a4) # ffffffffc02978e0 <idleproc>
ffffffffc020617e:	f406                	sd	ra,40(sp)
ffffffffc0206180:	ec26                	sd	s1,24(sp)
ffffffffc0206182:	0ee78763          	beq	a5,a4,ffffffffc0206270 <do_exit+0x108>
ffffffffc0206186:	00091497          	auipc	s1,0x91
ffffffffc020618a:	75248493          	addi	s1,s1,1874 # ffffffffc02978d8 <initproc>
ffffffffc020618e:	6098                	ld	a4,0(s1)
ffffffffc0206190:	e84a                	sd	s2,16(sp)
ffffffffc0206192:	10e78863          	beq	a5,a4,ffffffffc02062a2 <do_exit+0x13a>
ffffffffc0206196:	7798                	ld	a4,40(a5)
ffffffffc0206198:	892a                	mv	s2,a0
ffffffffc020619a:	cb0d                	beqz	a4,ffffffffc02061cc <do_exit+0x64>
ffffffffc020619c:	00091797          	auipc	a5,0x91
ffffffffc02061a0:	6fc7b783          	ld	a5,1788(a5) # ffffffffc0297898 <boot_pgdir_pa>
ffffffffc02061a4:	56fd                	li	a3,-1
ffffffffc02061a6:	16fe                	slli	a3,a3,0x3f
ffffffffc02061a8:	83b1                	srli	a5,a5,0xc
ffffffffc02061aa:	8fd5                	or	a5,a5,a3
ffffffffc02061ac:	18079073          	csrw	satp,a5
ffffffffc02061b0:	5b1c                	lw	a5,48(a4)
ffffffffc02061b2:	37fd                	addiw	a5,a5,-1
ffffffffc02061b4:	db1c                	sw	a5,48(a4)
ffffffffc02061b6:	cbf1                	beqz	a5,ffffffffc020628a <do_exit+0x122>
ffffffffc02061b8:	601c                	ld	a5,0(s0)
ffffffffc02061ba:	1487b503          	ld	a0,328(a5)
ffffffffc02061be:	0207b423          	sd	zero,40(a5)
ffffffffc02061c2:	c509                	beqz	a0,ffffffffc02061cc <do_exit+0x64>
ffffffffc02061c4:	491c                	lw	a5,16(a0)
ffffffffc02061c6:	37fd                	addiw	a5,a5,-1
ffffffffc02061c8:	c91c                	sw	a5,16(a0)
ffffffffc02061ca:	c3c5                	beqz	a5,ffffffffc020626a <do_exit+0x102>
ffffffffc02061cc:	601c                	ld	a5,0(s0)
ffffffffc02061ce:	470d                	li	a4,3
ffffffffc02061d0:	0f27a423          	sw	s2,232(a5)
ffffffffc02061d4:	c398                	sw	a4,0(a5)
ffffffffc02061d6:	100027f3          	csrr	a5,sstatus
ffffffffc02061da:	8b89                	andi	a5,a5,2
ffffffffc02061dc:	4901                	li	s2,0
ffffffffc02061de:	0c079e63          	bnez	a5,ffffffffc02062ba <do_exit+0x152>
ffffffffc02061e2:	6018                	ld	a4,0(s0)
ffffffffc02061e4:	800007b7          	lui	a5,0x80000
ffffffffc02061e8:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02061ea:	7308                	ld	a0,32(a4)
ffffffffc02061ec:	0ec52703          	lw	a4,236(a0)
ffffffffc02061f0:	0cf70963          	beq	a4,a5,ffffffffc02062c2 <do_exit+0x15a>
ffffffffc02061f4:	6018                	ld	a4,0(s0)
ffffffffc02061f6:	7b7c                	ld	a5,240(a4)
ffffffffc02061f8:	c7a1                	beqz	a5,ffffffffc0206240 <do_exit+0xd8>
ffffffffc02061fa:	800005b7          	lui	a1,0x80000
ffffffffc02061fe:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc0206200:	460d                	li	a2,3
ffffffffc0206202:	a021                	j	ffffffffc020620a <do_exit+0xa2>
ffffffffc0206204:	6018                	ld	a4,0(s0)
ffffffffc0206206:	7b7c                	ld	a5,240(a4)
ffffffffc0206208:	cf85                	beqz	a5,ffffffffc0206240 <do_exit+0xd8>
ffffffffc020620a:	1007b683          	ld	a3,256(a5)
ffffffffc020620e:	6088                	ld	a0,0(s1)
ffffffffc0206210:	fb74                	sd	a3,240(a4)
ffffffffc0206212:	0e07bc23          	sd	zero,248(a5)
ffffffffc0206216:	7978                	ld	a4,240(a0)
ffffffffc0206218:	10e7b023          	sd	a4,256(a5)
ffffffffc020621c:	c311                	beqz	a4,ffffffffc0206220 <do_exit+0xb8>
ffffffffc020621e:	ff7c                	sd	a5,248(a4)
ffffffffc0206220:	4398                	lw	a4,0(a5)
ffffffffc0206222:	f388                	sd	a0,32(a5)
ffffffffc0206224:	f97c                	sd	a5,240(a0)
ffffffffc0206226:	fcc71fe3          	bne	a4,a2,ffffffffc0206204 <do_exit+0x9c>
ffffffffc020622a:	0ec52783          	lw	a5,236(a0)
ffffffffc020622e:	fcb79be3          	bne	a5,a1,ffffffffc0206204 <do_exit+0x9c>
ffffffffc0206232:	6ee010ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc0206236:	800005b7          	lui	a1,0x80000
ffffffffc020623a:	0585                	addi	a1,a1,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc020623c:	460d                	li	a2,3
ffffffffc020623e:	b7d9                	j	ffffffffc0206204 <do_exit+0x9c>
ffffffffc0206240:	02091263          	bnez	s2,ffffffffc0206264 <do_exit+0xfc>
ffffffffc0206244:	7d4010ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc0206248:	601c                	ld	a5,0(s0)
ffffffffc020624a:	00008617          	auipc	a2,0x8
ffffffffc020624e:	9ee60613          	addi	a2,a2,-1554 # ffffffffc020dc38 <etext+0x1f00>
ffffffffc0206252:	29000593          	li	a1,656
ffffffffc0206256:	43d4                	lw	a3,4(a5)
ffffffffc0206258:	00008517          	auipc	a0,0x8
ffffffffc020625c:	99050513          	addi	a0,a0,-1648 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206260:	9eafa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206264:	a07fa0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0206268:	bff1                	j	ffffffffc0206244 <do_exit+0xdc>
ffffffffc020626a:	866ff0ef          	jal	ffffffffc02052d0 <files_destroy>
ffffffffc020626e:	bfb9                	j	ffffffffc02061cc <do_exit+0x64>
ffffffffc0206270:	00008617          	auipc	a2,0x8
ffffffffc0206274:	9a860613          	addi	a2,a2,-1624 # ffffffffc020dc18 <etext+0x1ee0>
ffffffffc0206278:	25b00593          	li	a1,603
ffffffffc020627c:	00008517          	auipc	a0,0x8
ffffffffc0206280:	96c50513          	addi	a0,a0,-1684 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206284:	e84a                	sd	s2,16(sp)
ffffffffc0206286:	9c4fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc020628a:	853a                	mv	a0,a4
ffffffffc020628c:	e43a                	sd	a4,8(sp)
ffffffffc020628e:	c27fd0ef          	jal	ffffffffc0203eb4 <exit_mmap>
ffffffffc0206292:	6722                	ld	a4,8(sp)
ffffffffc0206294:	6f08                	ld	a0,24(a4)
ffffffffc0206296:	8f7ff0ef          	jal	ffffffffc0205b8c <put_pgdir.isra.0>
ffffffffc020629a:	6522                	ld	a0,8(sp)
ffffffffc020629c:	a63fd0ef          	jal	ffffffffc0203cfe <mm_destroy>
ffffffffc02062a0:	bf21                	j	ffffffffc02061b8 <do_exit+0x50>
ffffffffc02062a2:	00008617          	auipc	a2,0x8
ffffffffc02062a6:	98660613          	addi	a2,a2,-1658 # ffffffffc020dc28 <etext+0x1ef0>
ffffffffc02062aa:	25f00593          	li	a1,607
ffffffffc02062ae:	00008517          	auipc	a0,0x8
ffffffffc02062b2:	93a50513          	addi	a0,a0,-1734 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02062b6:	994fa0ef          	jal	ffffffffc020044a <__panic>
ffffffffc02062ba:	9b7fa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02062be:	4905                	li	s2,1
ffffffffc02062c0:	b70d                	j	ffffffffc02061e2 <do_exit+0x7a>
ffffffffc02062c2:	65e010ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc02062c6:	b73d                	j	ffffffffc02061f4 <do_exit+0x8c>

ffffffffc02062c8 <do_wait.part.0>:
ffffffffc02062c8:	7179                	addi	sp,sp,-48
ffffffffc02062ca:	ec26                	sd	s1,24(sp)
ffffffffc02062cc:	e84a                	sd	s2,16(sp)
ffffffffc02062ce:	e44e                	sd	s3,8(sp)
ffffffffc02062d0:	f406                	sd	ra,40(sp)
ffffffffc02062d2:	f022                	sd	s0,32(sp)
ffffffffc02062d4:	84aa                	mv	s1,a0
ffffffffc02062d6:	892e                	mv	s2,a1
ffffffffc02062d8:	00091997          	auipc	s3,0x91
ffffffffc02062dc:	5f898993          	addi	s3,s3,1528 # ffffffffc02978d0 <current>
ffffffffc02062e0:	cd19                	beqz	a0,ffffffffc02062fe <do_wait.part.0+0x36>
ffffffffc02062e2:	6789                	lui	a5,0x2
ffffffffc02062e4:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc02062e6:	fff5071b          	addiw	a4,a0,-1
ffffffffc02062ea:	12e7f563          	bgeu	a5,a4,ffffffffc0206414 <do_wait.part.0+0x14c>
ffffffffc02062ee:	70a2                	ld	ra,40(sp)
ffffffffc02062f0:	7402                	ld	s0,32(sp)
ffffffffc02062f2:	64e2                	ld	s1,24(sp)
ffffffffc02062f4:	6942                	ld	s2,16(sp)
ffffffffc02062f6:	69a2                	ld	s3,8(sp)
ffffffffc02062f8:	5579                	li	a0,-2
ffffffffc02062fa:	6145                	addi	sp,sp,48
ffffffffc02062fc:	8082                	ret
ffffffffc02062fe:	0009b703          	ld	a4,0(s3)
ffffffffc0206302:	7b60                	ld	s0,240(a4)
ffffffffc0206304:	d46d                	beqz	s0,ffffffffc02062ee <do_wait.part.0+0x26>
ffffffffc0206306:	468d                	li	a3,3
ffffffffc0206308:	a021                	j	ffffffffc0206310 <do_wait.part.0+0x48>
ffffffffc020630a:	10043403          	ld	s0,256(s0)
ffffffffc020630e:	c075                	beqz	s0,ffffffffc02063f2 <do_wait.part.0+0x12a>
ffffffffc0206310:	401c                	lw	a5,0(s0)
ffffffffc0206312:	fed79ce3          	bne	a5,a3,ffffffffc020630a <do_wait.part.0+0x42>
ffffffffc0206316:	00091797          	auipc	a5,0x91
ffffffffc020631a:	5ca7b783          	ld	a5,1482(a5) # ffffffffc02978e0 <idleproc>
ffffffffc020631e:	14878263          	beq	a5,s0,ffffffffc0206462 <do_wait.part.0+0x19a>
ffffffffc0206322:	00091797          	auipc	a5,0x91
ffffffffc0206326:	5b67b783          	ld	a5,1462(a5) # ffffffffc02978d8 <initproc>
ffffffffc020632a:	12f40c63          	beq	s0,a5,ffffffffc0206462 <do_wait.part.0+0x19a>
ffffffffc020632e:	00090663          	beqz	s2,ffffffffc020633a <do_wait.part.0+0x72>
ffffffffc0206332:	0e842783          	lw	a5,232(s0)
ffffffffc0206336:	00f92023          	sw	a5,0(s2)
ffffffffc020633a:	100027f3          	csrr	a5,sstatus
ffffffffc020633e:	8b89                	andi	a5,a5,2
ffffffffc0206340:	4601                	li	a2,0
ffffffffc0206342:	10079963          	bnez	a5,ffffffffc0206454 <do_wait.part.0+0x18c>
ffffffffc0206346:	6c74                	ld	a3,216(s0)
ffffffffc0206348:	7078                	ld	a4,224(s0)
ffffffffc020634a:	10043783          	ld	a5,256(s0)
ffffffffc020634e:	e698                	sd	a4,8(a3)
ffffffffc0206350:	e314                	sd	a3,0(a4)
ffffffffc0206352:	6474                	ld	a3,200(s0)
ffffffffc0206354:	6878                	ld	a4,208(s0)
ffffffffc0206356:	e698                	sd	a4,8(a3)
ffffffffc0206358:	e314                	sd	a3,0(a4)
ffffffffc020635a:	c789                	beqz	a5,ffffffffc0206364 <do_wait.part.0+0x9c>
ffffffffc020635c:	7c78                	ld	a4,248(s0)
ffffffffc020635e:	fff8                	sd	a4,248(a5)
ffffffffc0206360:	10043783          	ld	a5,256(s0)
ffffffffc0206364:	7c78                	ld	a4,248(s0)
ffffffffc0206366:	c36d                	beqz	a4,ffffffffc0206448 <do_wait.part.0+0x180>
ffffffffc0206368:	10f73023          	sd	a5,256(a4)
ffffffffc020636c:	00091797          	auipc	a5,0x91
ffffffffc0206370:	55c7a783          	lw	a5,1372(a5) # ffffffffc02978c8 <nr_process>
ffffffffc0206374:	37fd                	addiw	a5,a5,-1
ffffffffc0206376:	00091717          	auipc	a4,0x91
ffffffffc020637a:	54f72923          	sw	a5,1362(a4) # ffffffffc02978c8 <nr_process>
ffffffffc020637e:	e271                	bnez	a2,ffffffffc0206442 <do_wait.part.0+0x17a>
ffffffffc0206380:	6814                	ld	a3,16(s0)
ffffffffc0206382:	c02007b7          	lui	a5,0xc0200
ffffffffc0206386:	10f6e663          	bltu	a3,a5,ffffffffc0206492 <do_wait.part.0+0x1ca>
ffffffffc020638a:	00091717          	auipc	a4,0x91
ffffffffc020638e:	51e73703          	ld	a4,1310(a4) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0206392:	00091797          	auipc	a5,0x91
ffffffffc0206396:	51e7b783          	ld	a5,1310(a5) # ffffffffc02978b0 <npage>
ffffffffc020639a:	8e99                	sub	a3,a3,a4
ffffffffc020639c:	82b1                	srli	a3,a3,0xc
ffffffffc020639e:	0cf6fe63          	bgeu	a3,a5,ffffffffc020647a <do_wait.part.0+0x1b2>
ffffffffc02063a2:	0000a797          	auipc	a5,0xa
ffffffffc02063a6:	c867b783          	ld	a5,-890(a5) # ffffffffc0210028 <nbase>
ffffffffc02063aa:	00091517          	auipc	a0,0x91
ffffffffc02063ae:	50e53503          	ld	a0,1294(a0) # ffffffffc02978b8 <pages>
ffffffffc02063b2:	4589                	li	a1,2
ffffffffc02063b4:	8e9d                	sub	a3,a3,a5
ffffffffc02063b6:	069a                	slli	a3,a3,0x6
ffffffffc02063b8:	9536                	add	a0,a0,a3
ffffffffc02063ba:	fd1fb0ef          	jal	ffffffffc020238a <free_pages>
ffffffffc02063be:	8522                	mv	a0,s0
ffffffffc02063c0:	e6ffb0ef          	jal	ffffffffc020222e <kfree>
ffffffffc02063c4:	70a2                	ld	ra,40(sp)
ffffffffc02063c6:	7402                	ld	s0,32(sp)
ffffffffc02063c8:	64e2                	ld	s1,24(sp)
ffffffffc02063ca:	6942                	ld	s2,16(sp)
ffffffffc02063cc:	69a2                	ld	s3,8(sp)
ffffffffc02063ce:	4501                	li	a0,0
ffffffffc02063d0:	6145                	addi	sp,sp,48
ffffffffc02063d2:	8082                	ret
ffffffffc02063d4:	00091997          	auipc	s3,0x91
ffffffffc02063d8:	4fc98993          	addi	s3,s3,1276 # ffffffffc02978d0 <current>
ffffffffc02063dc:	0009b703          	ld	a4,0(s3)
ffffffffc02063e0:	f487b683          	ld	a3,-184(a5)
ffffffffc02063e4:	f0e695e3          	bne	a3,a4,ffffffffc02062ee <do_wait.part.0+0x26>
ffffffffc02063e8:	f287a603          	lw	a2,-216(a5)
ffffffffc02063ec:	468d                	li	a3,3
ffffffffc02063ee:	06d60063          	beq	a2,a3,ffffffffc020644e <do_wait.part.0+0x186>
ffffffffc02063f2:	800007b7          	lui	a5,0x80000
ffffffffc02063f6:	0785                	addi	a5,a5,1 # ffffffff80000001 <_binary_bin_sfs_img_size+0xffffffff7ff8ad01>
ffffffffc02063f8:	4685                	li	a3,1
ffffffffc02063fa:	0ef72623          	sw	a5,236(a4)
ffffffffc02063fe:	c314                	sw	a3,0(a4)
ffffffffc0206400:	618010ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc0206404:	0009b783          	ld	a5,0(s3)
ffffffffc0206408:	0b07a783          	lw	a5,176(a5)
ffffffffc020640c:	8b85                	andi	a5,a5,1
ffffffffc020640e:	e7b9                	bnez	a5,ffffffffc020645c <do_wait.part.0+0x194>
ffffffffc0206410:	ee0487e3          	beqz	s1,ffffffffc02062fe <do_wait.part.0+0x36>
ffffffffc0206414:	45a9                	li	a1,10
ffffffffc0206416:	8526                	mv	a0,s1
ffffffffc0206418:	37c050ef          	jal	ffffffffc020b794 <hash32>
ffffffffc020641c:	02051793          	slli	a5,a0,0x20
ffffffffc0206420:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206424:	0008c797          	auipc	a5,0x8c
ffffffffc0206428:	39c78793          	addi	a5,a5,924 # ffffffffc02927c0 <hash_list>
ffffffffc020642c:	953e                	add	a0,a0,a5
ffffffffc020642e:	87aa                	mv	a5,a0
ffffffffc0206430:	a029                	j	ffffffffc020643a <do_wait.part.0+0x172>
ffffffffc0206432:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206436:	f8970fe3          	beq	a4,s1,ffffffffc02063d4 <do_wait.part.0+0x10c>
ffffffffc020643a:	679c                	ld	a5,8(a5)
ffffffffc020643c:	fef51be3          	bne	a0,a5,ffffffffc0206432 <do_wait.part.0+0x16a>
ffffffffc0206440:	b57d                	j	ffffffffc02062ee <do_wait.part.0+0x26>
ffffffffc0206442:	829fa0ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0206446:	bf2d                	j	ffffffffc0206380 <do_wait.part.0+0xb8>
ffffffffc0206448:	7018                	ld	a4,32(s0)
ffffffffc020644a:	fb7c                	sd	a5,240(a4)
ffffffffc020644c:	b705                	j	ffffffffc020636c <do_wait.part.0+0xa4>
ffffffffc020644e:	f2878413          	addi	s0,a5,-216
ffffffffc0206452:	b5d1                	j	ffffffffc0206316 <do_wait.part.0+0x4e>
ffffffffc0206454:	81dfa0ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0206458:	4605                	li	a2,1
ffffffffc020645a:	b5f5                	j	ffffffffc0206346 <do_wait.part.0+0x7e>
ffffffffc020645c:	555d                	li	a0,-9
ffffffffc020645e:	d0bff0ef          	jal	ffffffffc0206168 <do_exit>
ffffffffc0206462:	00007617          	auipc	a2,0x7
ffffffffc0206466:	7f660613          	addi	a2,a2,2038 # ffffffffc020dc58 <etext+0x1f20>
ffffffffc020646a:	40f00593          	li	a1,1039
ffffffffc020646e:	00007517          	auipc	a0,0x7
ffffffffc0206472:	77a50513          	addi	a0,a0,1914 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206476:	fd5f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020647a:	00007617          	auipc	a2,0x7
ffffffffc020647e:	86660613          	addi	a2,a2,-1946 # ffffffffc020cce0 <etext+0xfa8>
ffffffffc0206482:	06900593          	li	a1,105
ffffffffc0206486:	00006517          	auipc	a0,0x6
ffffffffc020648a:	7b250513          	addi	a0,a0,1970 # ffffffffc020cc38 <etext+0xf00>
ffffffffc020648e:	fbdf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206492:	00007617          	auipc	a2,0x7
ffffffffc0206496:	82660613          	addi	a2,a2,-2010 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc020649a:	07700593          	li	a1,119
ffffffffc020649e:	00006517          	auipc	a0,0x6
ffffffffc02064a2:	79a50513          	addi	a0,a0,1946 # ffffffffc020cc38 <etext+0xf00>
ffffffffc02064a6:	fa5f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02064aa <init_main>:
ffffffffc02064aa:	1141                	addi	sp,sp,-16
ffffffffc02064ac:	00007517          	auipc	a0,0x7
ffffffffc02064b0:	7cc50513          	addi	a0,a0,1996 # ffffffffc020dc78 <etext+0x1f40>
ffffffffc02064b4:	e406                	sd	ra,8(sp)
ffffffffc02064b6:	4ef010ef          	jal	ffffffffc02081a4 <vfs_set_bootfs>
ffffffffc02064ba:	e179                	bnez	a0,ffffffffc0206580 <init_main+0xd6>
ffffffffc02064bc:	f07fb0ef          	jal	ffffffffc02023c2 <nr_free_pages>
ffffffffc02064c0:	cc5fb0ef          	jal	ffffffffc0202184 <kallocated>
ffffffffc02064c4:	4601                	li	a2,0
ffffffffc02064c6:	4581                	li	a1,0
ffffffffc02064c8:	00001517          	auipc	a0,0x1
ffffffffc02064cc:	97850513          	addi	a0,a0,-1672 # ffffffffc0206e40 <user_main>
ffffffffc02064d0:	c49ff0ef          	jal	ffffffffc0206118 <kernel_thread>
ffffffffc02064d4:	00a04563          	bgtz	a0,ffffffffc02064de <init_main+0x34>
ffffffffc02064d8:	a841                	j	ffffffffc0206568 <init_main+0xbe>
ffffffffc02064da:	53e010ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc02064de:	4581                	li	a1,0
ffffffffc02064e0:	4501                	li	a0,0
ffffffffc02064e2:	de7ff0ef          	jal	ffffffffc02062c8 <do_wait.part.0>
ffffffffc02064e6:	d975                	beqz	a0,ffffffffc02064da <init_main+0x30>
ffffffffc02064e8:	da3fe0ef          	jal	ffffffffc020528a <fs_cleanup>
ffffffffc02064ec:	00007517          	auipc	a0,0x7
ffffffffc02064f0:	7d450513          	addi	a0,a0,2004 # ffffffffc020dcc0 <etext+0x1f88>
ffffffffc02064f4:	cb3f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02064f8:	00091797          	auipc	a5,0x91
ffffffffc02064fc:	3e07b783          	ld	a5,992(a5) # ffffffffc02978d8 <initproc>
ffffffffc0206500:	7bf8                	ld	a4,240(a5)
ffffffffc0206502:	e339                	bnez	a4,ffffffffc0206548 <init_main+0x9e>
ffffffffc0206504:	7ff8                	ld	a4,248(a5)
ffffffffc0206506:	e329                	bnez	a4,ffffffffc0206548 <init_main+0x9e>
ffffffffc0206508:	1007b703          	ld	a4,256(a5)
ffffffffc020650c:	ef15                	bnez	a4,ffffffffc0206548 <init_main+0x9e>
ffffffffc020650e:	00091697          	auipc	a3,0x91
ffffffffc0206512:	3ba6a683          	lw	a3,954(a3) # ffffffffc02978c8 <nr_process>
ffffffffc0206516:	4709                	li	a4,2
ffffffffc0206518:	0ce69163          	bne	a3,a4,ffffffffc02065da <init_main+0x130>
ffffffffc020651c:	00090717          	auipc	a4,0x90
ffffffffc0206520:	2a470713          	addi	a4,a4,676 # ffffffffc02967c0 <proc_list>
ffffffffc0206524:	6714                	ld	a3,8(a4)
ffffffffc0206526:	0c878793          	addi	a5,a5,200
ffffffffc020652a:	08d79863          	bne	a5,a3,ffffffffc02065ba <init_main+0x110>
ffffffffc020652e:	6318                	ld	a4,0(a4)
ffffffffc0206530:	06e79563          	bne	a5,a4,ffffffffc020659a <init_main+0xf0>
ffffffffc0206534:	00008517          	auipc	a0,0x8
ffffffffc0206538:	87450513          	addi	a0,a0,-1932 # ffffffffc020dda8 <etext+0x2070>
ffffffffc020653c:	c6bf90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206540:	60a2                	ld	ra,8(sp)
ffffffffc0206542:	4501                	li	a0,0
ffffffffc0206544:	0141                	addi	sp,sp,16
ffffffffc0206546:	8082                	ret
ffffffffc0206548:	00007697          	auipc	a3,0x7
ffffffffc020654c:	7a068693          	addi	a3,a3,1952 # ffffffffc020dce8 <etext+0x1fb0>
ffffffffc0206550:	00006617          	auipc	a2,0x6
ffffffffc0206554:	c2060613          	addi	a2,a2,-992 # ffffffffc020c170 <etext+0x438>
ffffffffc0206558:	48500593          	li	a1,1157
ffffffffc020655c:	00007517          	auipc	a0,0x7
ffffffffc0206560:	68c50513          	addi	a0,a0,1676 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206564:	ee7f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206568:	00007617          	auipc	a2,0x7
ffffffffc020656c:	73860613          	addi	a2,a2,1848 # ffffffffc020dca0 <etext+0x1f68>
ffffffffc0206570:	47800593          	li	a1,1144
ffffffffc0206574:	00007517          	auipc	a0,0x7
ffffffffc0206578:	67450513          	addi	a0,a0,1652 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc020657c:	ecff90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206580:	86aa                	mv	a3,a0
ffffffffc0206582:	00007617          	auipc	a2,0x7
ffffffffc0206586:	6fe60613          	addi	a2,a2,1790 # ffffffffc020dc80 <etext+0x1f48>
ffffffffc020658a:	47000593          	li	a1,1136
ffffffffc020658e:	00007517          	auipc	a0,0x7
ffffffffc0206592:	65a50513          	addi	a0,a0,1626 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206596:	eb5f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020659a:	00007697          	auipc	a3,0x7
ffffffffc020659e:	7de68693          	addi	a3,a3,2014 # ffffffffc020dd78 <etext+0x2040>
ffffffffc02065a2:	00006617          	auipc	a2,0x6
ffffffffc02065a6:	bce60613          	addi	a2,a2,-1074 # ffffffffc020c170 <etext+0x438>
ffffffffc02065aa:	48800593          	li	a1,1160
ffffffffc02065ae:	00007517          	auipc	a0,0x7
ffffffffc02065b2:	63a50513          	addi	a0,a0,1594 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02065b6:	e95f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02065ba:	00007697          	auipc	a3,0x7
ffffffffc02065be:	78e68693          	addi	a3,a3,1934 # ffffffffc020dd48 <etext+0x2010>
ffffffffc02065c2:	00006617          	auipc	a2,0x6
ffffffffc02065c6:	bae60613          	addi	a2,a2,-1106 # ffffffffc020c170 <etext+0x438>
ffffffffc02065ca:	48700593          	li	a1,1159
ffffffffc02065ce:	00007517          	auipc	a0,0x7
ffffffffc02065d2:	61a50513          	addi	a0,a0,1562 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02065d6:	e75f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02065da:	00007697          	auipc	a3,0x7
ffffffffc02065de:	75e68693          	addi	a3,a3,1886 # ffffffffc020dd38 <etext+0x2000>
ffffffffc02065e2:	00006617          	auipc	a2,0x6
ffffffffc02065e6:	b8e60613          	addi	a2,a2,-1138 # ffffffffc020c170 <etext+0x438>
ffffffffc02065ea:	48600593          	li	a1,1158
ffffffffc02065ee:	00007517          	auipc	a0,0x7
ffffffffc02065f2:	5fa50513          	addi	a0,a0,1530 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02065f6:	e55f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc02065fa <do_execve>:
ffffffffc02065fa:	db010113          	addi	sp,sp,-592
ffffffffc02065fe:	21613823          	sd	s6,528(sp)
ffffffffc0206602:	24113423          	sd	ra,584(sp)
ffffffffc0206606:	f7ee                	sd	s11,488(sp)
ffffffffc0206608:	fff58b1b          	addiw	s6,a1,-1
ffffffffc020660c:	47fd                	li	a5,31
ffffffffc020660e:	5f67ea63          	bltu	a5,s6,ffffffffc0206c02 <do_execve+0x608>
ffffffffc0206612:	23213823          	sd	s2,560(sp)
ffffffffc0206616:	00091917          	auipc	s2,0x91
ffffffffc020661a:	2ba90913          	addi	s2,s2,698 # ffffffffc02978d0 <current>
ffffffffc020661e:	00093783          	ld	a5,0(s2)
ffffffffc0206622:	21513c23          	sd	s5,536(sp)
ffffffffc0206626:	24813023          	sd	s0,576(sp)
ffffffffc020662a:	0287ba83          	ld	s5,40(a5)
ffffffffc020662e:	22913c23          	sd	s1,568(sp)
ffffffffc0206632:	21813023          	sd	s8,512(sp)
ffffffffc0206636:	84aa                	mv	s1,a0
ffffffffc0206638:	8c32                	mv	s8,a2
ffffffffc020663a:	842e                	mv	s0,a1
ffffffffc020663c:	08a8                	addi	a0,sp,88
ffffffffc020663e:	4641                	li	a2,16
ffffffffc0206640:	4581                	li	a1,0
ffffffffc0206642:	68e050ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0206646:	000a8c63          	beqz	s5,ffffffffc020665e <do_execve+0x64>
ffffffffc020664a:	038a8513          	addi	a0,s5,56
ffffffffc020664e:	fcbfd0ef          	jal	ffffffffc0204618 <down>
ffffffffc0206652:	00093783          	ld	a5,0(s2)
ffffffffc0206656:	c781                	beqz	a5,ffffffffc020665e <do_execve+0x64>
ffffffffc0206658:	43dc                	lw	a5,4(a5)
ffffffffc020665a:	04faa823          	sw	a5,80(s5)
ffffffffc020665e:	1c048963          	beqz	s1,ffffffffc0206830 <do_execve+0x236>
ffffffffc0206662:	8626                	mv	a2,s1
ffffffffc0206664:	46c1                	li	a3,16
ffffffffc0206666:	08ac                	addi	a1,sp,88
ffffffffc0206668:	8556                	mv	a0,s5
ffffffffc020666a:	cfbfd0ef          	jal	ffffffffc0204364 <copy_string>
ffffffffc020666e:	56050863          	beqz	a0,ffffffffc0206bde <do_execve+0x5e4>
ffffffffc0206672:	23413023          	sd	s4,544(sp)
ffffffffc0206676:	fbea                	sd	s10,496(sp)
ffffffffc0206678:	00341d13          	slli	s10,s0,0x3
ffffffffc020667c:	866a                	mv	a2,s10
ffffffffc020667e:	4681                	li	a3,0
ffffffffc0206680:	85e2                	mv	a1,s8
ffffffffc0206682:	8556                	mv	a0,s5
ffffffffc0206684:	8a62                	mv	s4,s8
ffffffffc0206686:	bcdfd0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc020668a:	6a050963          	beqz	a0,ffffffffc0206d3c <do_execve+0x742>
ffffffffc020668e:	23313423          	sd	s3,552(sp)
ffffffffc0206692:	21713423          	sd	s7,520(sp)
ffffffffc0206696:	4981                	li	s3,0
ffffffffc0206698:	0e010b93          	addi	s7,sp,224
ffffffffc020669c:	6505                	lui	a0,0x1
ffffffffc020669e:	aebfb0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc02066a2:	84aa                	mv	s1,a0
ffffffffc02066a4:	10050863          	beqz	a0,ffffffffc02067b4 <do_execve+0x1ba>
ffffffffc02066a8:	000a3603          	ld	a2,0(s4)
ffffffffc02066ac:	85aa                	mv	a1,a0
ffffffffc02066ae:	6685                	lui	a3,0x1
ffffffffc02066b0:	8556                	mv	a0,s5
ffffffffc02066b2:	cb3fd0ef          	jal	ffffffffc0204364 <copy_string>
ffffffffc02066b6:	16050863          	beqz	a0,ffffffffc0206826 <do_execve+0x22c>
ffffffffc02066ba:	009bb023          	sd	s1,0(s7)
ffffffffc02066be:	2985                	addiw	s3,s3,1
ffffffffc02066c0:	0ba1                	addi	s7,s7,8
ffffffffc02066c2:	0a21                	addi	s4,s4,8
ffffffffc02066c4:	fd341ce3          	bne	s0,s3,ffffffffc020669c <do_execve+0xa2>
ffffffffc02066c8:	ffe6                	sd	s9,504(sp)
ffffffffc02066ca:	000c3483          	ld	s1,0(s8)
ffffffffc02066ce:	0a0a8663          	beqz	s5,ffffffffc020677a <do_execve+0x180>
ffffffffc02066d2:	038a8513          	addi	a0,s5,56
ffffffffc02066d6:	f3ffd0ef          	jal	ffffffffc0204614 <up>
ffffffffc02066da:	00093783          	ld	a5,0(s2)
ffffffffc02066de:	040aa823          	sw	zero,80(s5)
ffffffffc02066e2:	1487b503          	ld	a0,328(a5)
ffffffffc02066e6:	c81fe0ef          	jal	ffffffffc0205366 <files_closeall>
ffffffffc02066ea:	8526                	mv	a0,s1
ffffffffc02066ec:	4581                	li	a1,0
ffffffffc02066ee:	f09fe0ef          	jal	ffffffffc02055f6 <sysfile_open>
ffffffffc02066f2:	8a2a                	mv	s4,a0
ffffffffc02066f4:	6c054463          	bltz	a0,ffffffffc0206dbc <do_execve+0x7c2>
ffffffffc02066f8:	00091797          	auipc	a5,0x91
ffffffffc02066fc:	1a07b783          	ld	a5,416(a5) # ffffffffc0297898 <boot_pgdir_pa>
ffffffffc0206700:	577d                	li	a4,-1
ffffffffc0206702:	177e                	slli	a4,a4,0x3f
ffffffffc0206704:	83b1                	srli	a5,a5,0xc
ffffffffc0206706:	8fd9                	or	a5,a5,a4
ffffffffc0206708:	18079073          	csrw	satp,a5
ffffffffc020670c:	030aa783          	lw	a5,48(s5)
ffffffffc0206710:	37fd                	addiw	a5,a5,-1
ffffffffc0206712:	02faa823          	sw	a5,48(s5)
ffffffffc0206716:	14078f63          	beqz	a5,ffffffffc0206874 <do_execve+0x27a>
ffffffffc020671a:	00093783          	ld	a5,0(s2)
ffffffffc020671e:	0207b423          	sd	zero,40(a5)
ffffffffc0206722:	c90fd0ef          	jal	ffffffffc0203bb2 <mm_create>
ffffffffc0206726:	89aa                	mv	s3,a0
ffffffffc0206728:	5df1                	li	s11,-4
ffffffffc020672a:	c505                	beqz	a0,ffffffffc0206752 <do_execve+0x158>
ffffffffc020672c:	cd8ff0ef          	jal	ffffffffc0205c04 <setup_pgdir>
ffffffffc0206730:	5df1                	li	s11,-4
ffffffffc0206732:	ed09                	bnez	a0,ffffffffc020674c <do_execve+0x152>
ffffffffc0206734:	4601                	li	a2,0
ffffffffc0206736:	4581                	li	a1,0
ffffffffc0206738:	8552                	mv	a0,s4
ffffffffc020673a:	974ff0ef          	jal	ffffffffc02058ae <sysfile_seek>
ffffffffc020673e:	8daa                	mv	s11,a0
ffffffffc0206740:	10050963          	beqz	a0,ffffffffc0206852 <do_execve+0x258>
ffffffffc0206744:	0189b503          	ld	a0,24(s3)
ffffffffc0206748:	c44ff0ef          	jal	ffffffffc0205b8c <put_pgdir.isra.0>
ffffffffc020674c:	854e                	mv	a0,s3
ffffffffc020674e:	db0fd0ef          	jal	ffffffffc0203cfe <mm_destroy>
ffffffffc0206752:	0d010913          	addi	s2,sp,208
ffffffffc0206756:	020b1713          	slli	a4,s6,0x20
ffffffffc020675a:	01d75793          	srli	a5,a4,0x1d
ffffffffc020675e:	996a                	add	s2,s2,s10
ffffffffc0206760:	09a0                	addi	s0,sp,216
ffffffffc0206762:	40f90933          	sub	s2,s2,a5
ffffffffc0206766:	946a                	add	s0,s0,s10
ffffffffc0206768:	6008                	ld	a0,0(s0)
ffffffffc020676a:	1461                	addi	s0,s0,-8
ffffffffc020676c:	ac3fb0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0206770:	ff241ce3          	bne	s0,s2,ffffffffc0206768 <do_execve+0x16e>
ffffffffc0206774:	856e                	mv	a0,s11
ffffffffc0206776:	9f3ff0ef          	jal	ffffffffc0206168 <do_exit>
ffffffffc020677a:	00093783          	ld	a5,0(s2)
ffffffffc020677e:	1487b503          	ld	a0,328(a5)
ffffffffc0206782:	be5fe0ef          	jal	ffffffffc0205366 <files_closeall>
ffffffffc0206786:	8526                	mv	a0,s1
ffffffffc0206788:	4581                	li	a1,0
ffffffffc020678a:	e6dfe0ef          	jal	ffffffffc02055f6 <sysfile_open>
ffffffffc020678e:	8a2a                	mv	s4,a0
ffffffffc0206790:	0a054f63          	bltz	a0,ffffffffc020684e <do_execve+0x254>
ffffffffc0206794:	00093783          	ld	a5,0(s2)
ffffffffc0206798:	779c                	ld	a5,40(a5)
ffffffffc020679a:	d7c1                	beqz	a5,ffffffffc0206722 <do_execve+0x128>
ffffffffc020679c:	00007617          	auipc	a2,0x7
ffffffffc02067a0:	63c60613          	addi	a2,a2,1596 # ffffffffc020ddd8 <etext+0x20a0>
ffffffffc02067a4:	2aa00593          	li	a1,682
ffffffffc02067a8:	00007517          	auipc	a0,0x7
ffffffffc02067ac:	44050513          	addi	a0,a0,1088 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02067b0:	c9bf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02067b4:	5df1                	li	s11,-4
ffffffffc02067b6:	02098663          	beqz	s3,ffffffffc02067e2 <do_execve+0x1e8>
ffffffffc02067ba:	00399793          	slli	a5,s3,0x3
ffffffffc02067be:	39fd                	addiw	s3,s3,-1
ffffffffc02067c0:	0d010913          	addi	s2,sp,208
ffffffffc02067c4:	02099713          	slli	a4,s3,0x20
ffffffffc02067c8:	01d75993          	srli	s3,a4,0x1d
ffffffffc02067cc:	993e                	add	s2,s2,a5
ffffffffc02067ce:	09a0                	addi	s0,sp,216
ffffffffc02067d0:	41390933          	sub	s2,s2,s3
ffffffffc02067d4:	943e                	add	s0,s0,a5
ffffffffc02067d6:	6008                	ld	a0,0(s0)
ffffffffc02067d8:	1461                	addi	s0,s0,-8
ffffffffc02067da:	a55fb0ef          	jal	ffffffffc020222e <kfree>
ffffffffc02067de:	ff241ce3          	bne	s0,s2,ffffffffc02067d6 <do_execve+0x1dc>
ffffffffc02067e2:	22813983          	ld	s3,552(sp)
ffffffffc02067e6:	20813b83          	ld	s7,520(sp)
ffffffffc02067ea:	000a8863          	beqz	s5,ffffffffc02067fa <do_execve+0x200>
ffffffffc02067ee:	038a8513          	addi	a0,s5,56
ffffffffc02067f2:	e23fd0ef          	jal	ffffffffc0204614 <up>
ffffffffc02067f6:	040aa823          	sw	zero,80(s5)
ffffffffc02067fa:	24013403          	ld	s0,576(sp)
ffffffffc02067fe:	23813483          	ld	s1,568(sp)
ffffffffc0206802:	23013903          	ld	s2,560(sp)
ffffffffc0206806:	22013a03          	ld	s4,544(sp)
ffffffffc020680a:	21813a83          	ld	s5,536(sp)
ffffffffc020680e:	20013c03          	ld	s8,512(sp)
ffffffffc0206812:	7d5e                	ld	s10,496(sp)
ffffffffc0206814:	24813083          	ld	ra,584(sp)
ffffffffc0206818:	21013b03          	ld	s6,528(sp)
ffffffffc020681c:	856e                	mv	a0,s11
ffffffffc020681e:	7dbe                	ld	s11,488(sp)
ffffffffc0206820:	25010113          	addi	sp,sp,592
ffffffffc0206824:	8082                	ret
ffffffffc0206826:	8526                	mv	a0,s1
ffffffffc0206828:	a07fb0ef          	jal	ffffffffc020222e <kfree>
ffffffffc020682c:	5df5                	li	s11,-3
ffffffffc020682e:	b761                	j	ffffffffc02067b6 <do_execve+0x1bc>
ffffffffc0206830:	00093783          	ld	a5,0(s2)
ffffffffc0206834:	00007617          	auipc	a2,0x7
ffffffffc0206838:	59460613          	addi	a2,a2,1428 # ffffffffc020ddc8 <etext+0x2090>
ffffffffc020683c:	45c1                	li	a1,16
ffffffffc020683e:	43d4                	lw	a3,4(a5)
ffffffffc0206840:	08a8                	addi	a0,sp,88
ffffffffc0206842:	23413023          	sd	s4,544(sp)
ffffffffc0206846:	fbea                	sd	s10,496(sp)
ffffffffc0206848:	386050ef          	jal	ffffffffc020bbce <snprintf>
ffffffffc020684c:	b535                	j	ffffffffc0206678 <do_execve+0x7e>
ffffffffc020684e:	8daa                	mv	s11,a0
ffffffffc0206850:	b709                	j	ffffffffc0206752 <do_execve+0x158>
ffffffffc0206852:	04000613          	li	a2,64
ffffffffc0206856:	110c                	addi	a1,sp,160
ffffffffc0206858:	8552                	mv	a0,s4
ffffffffc020685a:	dd7fe0ef          	jal	ffffffffc0205630 <sysfile_read>
ffffffffc020685e:	04000793          	li	a5,64
ffffffffc0206862:	02f50463          	beq	a0,a5,ffffffffc020688a <do_execve+0x290>
ffffffffc0206866:	84aa                	mv	s1,a0
ffffffffc0206868:	00054363          	bltz	a0,ffffffffc020686e <do_execve+0x274>
ffffffffc020686c:	54fd                	li	s1,-1
ffffffffc020686e:	00048d9b          	sext.w	s11,s1
ffffffffc0206872:	bdc9                	j	ffffffffc0206744 <do_execve+0x14a>
ffffffffc0206874:	8556                	mv	a0,s5
ffffffffc0206876:	e3efd0ef          	jal	ffffffffc0203eb4 <exit_mmap>
ffffffffc020687a:	018ab503          	ld	a0,24(s5)
ffffffffc020687e:	b0eff0ef          	jal	ffffffffc0205b8c <put_pgdir.isra.0>
ffffffffc0206882:	8556                	mv	a0,s5
ffffffffc0206884:	c7afd0ef          	jal	ffffffffc0203cfe <mm_destroy>
ffffffffc0206888:	bd49                	j	ffffffffc020671a <do_execve+0x120>
ffffffffc020688a:	570a                	lw	a4,160(sp)
ffffffffc020688c:	464c47b7          	lui	a5,0x464c4
ffffffffc0206890:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc0206894:	32f71163          	bne	a4,a5,ffffffffc0206bb6 <do_execve+0x5bc>
ffffffffc0206898:	0d815783          	lhu	a5,216(sp)
ffffffffc020689c:	cba5                	beqz	a5,ffffffffc020690c <do_execve+0x312>
ffffffffc020689e:	f402                	sd	zero,40(sp)
ffffffffc02068a0:	4a81                	li	s5,0
ffffffffc02068a2:	e082                	sd	zero,64(sp)
ffffffffc02068a4:	f06a                	sd	s10,32(sp)
ffffffffc02068a6:	e452                	sd	s4,8(sp)
ffffffffc02068a8:	e4a2                	sd	s0,72(sp)
ffffffffc02068aa:	658e                	ld	a1,192(sp)
ffffffffc02068ac:	6422                	ld	s0,8(sp)
ffffffffc02068ae:	77a2                	ld	a5,40(sp)
ffffffffc02068b0:	4601                	li	a2,0
ffffffffc02068b2:	8522                	mv	a0,s0
ffffffffc02068b4:	95be                	add	a1,a1,a5
ffffffffc02068b6:	ff9fe0ef          	jal	ffffffffc02058ae <sysfile_seek>
ffffffffc02068ba:	20051763          	bnez	a0,ffffffffc0206ac8 <do_execve+0x4ce>
ffffffffc02068be:	03800613          	li	a2,56
ffffffffc02068c2:	10ac                	addi	a1,sp,104
ffffffffc02068c4:	8522                	mv	a0,s0
ffffffffc02068c6:	d6bfe0ef          	jal	ffffffffc0205630 <sysfile_read>
ffffffffc02068ca:	03800793          	li	a5,56
ffffffffc02068ce:	00f50d63          	beq	a0,a5,ffffffffc02068e8 <do_execve+0x2ee>
ffffffffc02068d2:	7d02                	ld	s10,32(sp)
ffffffffc02068d4:	84aa                	mv	s1,a0
ffffffffc02068d6:	00054363          	bltz	a0,ffffffffc02068dc <do_execve+0x2e2>
ffffffffc02068da:	54fd                	li	s1,-1
ffffffffc02068dc:	00048d9b          	sext.w	s11,s1
ffffffffc02068e0:	854e                	mv	a0,s3
ffffffffc02068e2:	dd2fd0ef          	jal	ffffffffc0203eb4 <exit_mmap>
ffffffffc02068e6:	bdb9                	j	ffffffffc0206744 <do_execve+0x14a>
ffffffffc02068e8:	57a6                	lw	a5,104(sp)
ffffffffc02068ea:	4705                	li	a4,1
ffffffffc02068ec:	1ee78163          	beq	a5,a4,ffffffffc0206ace <do_execve+0x4d4>
ffffffffc02068f0:	6706                	ld	a4,64(sp)
ffffffffc02068f2:	76a2                	ld	a3,40(sp)
ffffffffc02068f4:	0d815783          	lhu	a5,216(sp)
ffffffffc02068f8:	2705                	addiw	a4,a4,1
ffffffffc02068fa:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc02068fe:	e0ba                	sd	a4,64(sp)
ffffffffc0206900:	f436                	sd	a3,40(sp)
ffffffffc0206902:	faf764e3          	bltu	a4,a5,ffffffffc02068aa <do_execve+0x2b0>
ffffffffc0206906:	7d02                	ld	s10,32(sp)
ffffffffc0206908:	6a22                	ld	s4,8(sp)
ffffffffc020690a:	6426                	ld	s0,72(sp)
ffffffffc020690c:	8552                	mv	a0,s4
ffffffffc020690e:	d1ffe0ef          	jal	ffffffffc020562c <sysfile_close>
ffffffffc0206912:	854e                	mv	a0,s3
ffffffffc0206914:	4701                	li	a4,0
ffffffffc0206916:	46ad                	li	a3,11
ffffffffc0206918:	00100637          	lui	a2,0x100
ffffffffc020691c:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0206920:	c30fd0ef          	jal	ffffffffc0203d50 <mm_map>
ffffffffc0206924:	8daa                	mv	s11,a0
ffffffffc0206926:	fd4d                	bnez	a0,ffffffffc02068e0 <do_execve+0x2e6>
ffffffffc0206928:	0189b503          	ld	a0,24(s3)
ffffffffc020692c:	467d                	li	a2,31
ffffffffc020692e:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc0206932:	99efd0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc0206936:	4e050563          	beqz	a0,ffffffffc0206e20 <do_execve+0x826>
ffffffffc020693a:	0189b503          	ld	a0,24(s3)
ffffffffc020693e:	467d                	li	a2,31
ffffffffc0206940:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc0206944:	98cfd0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc0206948:	4a050c63          	beqz	a0,ffffffffc0206e00 <do_execve+0x806>
ffffffffc020694c:	0189b503          	ld	a0,24(s3)
ffffffffc0206950:	467d                	li	a2,31
ffffffffc0206952:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc0206956:	97afd0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc020695a:	48050363          	beqz	a0,ffffffffc0206de0 <do_execve+0x7e6>
ffffffffc020695e:	0189b503          	ld	a0,24(s3)
ffffffffc0206962:	467d                	li	a2,31
ffffffffc0206964:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc0206968:	968fd0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc020696c:	44050a63          	beqz	a0,ffffffffc0206dc0 <do_execve+0x7c6>
ffffffffc0206970:	0309a783          	lw	a5,48(s3)
ffffffffc0206974:	00093603          	ld	a2,0(s2)
ffffffffc0206978:	0189b683          	ld	a3,24(s3)
ffffffffc020697c:	2785                	addiw	a5,a5,1
ffffffffc020697e:	02f9a823          	sw	a5,48(s3)
ffffffffc0206982:	03363423          	sd	s3,40(a2) # 100028 <_binary_bin_sfs_img_size+0x8ad28>
ffffffffc0206986:	c02007b7          	lui	a5,0xc0200
ffffffffc020698a:	40f6e063          	bltu	a3,a5,ffffffffc0206d8a <do_execve+0x790>
ffffffffc020698e:	00091797          	auipc	a5,0x91
ffffffffc0206992:	f1a7b783          	ld	a5,-230(a5) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0206996:	577d                	li	a4,-1
ffffffffc0206998:	177e                	slli	a4,a4,0x3f
ffffffffc020699a:	8e9d                	sub	a3,a3,a5
ffffffffc020699c:	00c6d793          	srli	a5,a3,0xc
ffffffffc02069a0:	f654                	sd	a3,168(a2)
ffffffffc02069a2:	8fd9                	or	a5,a5,a4
ffffffffc02069a4:	18079073          	csrw	satp,a5
ffffffffc02069a8:	4a01                	li	s4,0
ffffffffc02069aa:	0e010a93          	addi	s5,sp,224
ffffffffc02069ae:	4981                	li	s3,0
ffffffffc02069b0:	000ab503          	ld	a0,0(s5)
ffffffffc02069b4:	6585                	lui	a1,0x1
ffffffffc02069b6:	2985                	addiw	s3,s3,1
ffffffffc02069b8:	27c050ef          	jal	ffffffffc020bc34 <strnlen>
ffffffffc02069bc:	00150793          	addi	a5,a0,1
ffffffffc02069c0:	0aa1                	addi	s5,s5,8
ffffffffc02069c2:	01478a3b          	addw	s4,a5,s4
ffffffffc02069c6:	fe89e5e3          	bltu	s3,s0,ffffffffc02069b0 <do_execve+0x3b6>
ffffffffc02069ca:	100009b7          	lui	s3,0x10000
ffffffffc02069ce:	003a5a1b          	srliw	s4,s4,0x3
ffffffffc02069d2:	19fd                	addi	s3,s3,-1 # fffffff <_binary_bin_sfs_img_size+0xff8acff>
ffffffffc02069d4:	414989b3          	sub	s3,s3,s4
ffffffffc02069d8:	098e                	slli	s3,s3,0x3
ffffffffc02069da:	119c                	addi	a5,sp,224
ffffffffc02069dc:	41a98ab3          	sub	s5,s3,s10
ffffffffc02069e0:	40fa8c33          	sub	s8,s5,a5
ffffffffc02069e4:	8a3e                	mv	s4,a5
ffffffffc02069e6:	4c81                	li	s9,0
ffffffffc02069e8:	4b81                	li	s7,0
ffffffffc02069ea:	000a3483          	ld	s1,0(s4)
ffffffffc02069ee:	020b9513          	slli	a0,s7,0x20
ffffffffc02069f2:	9101                	srli	a0,a0,0x20
ffffffffc02069f4:	85a6                	mv	a1,s1
ffffffffc02069f6:	954e                	add	a0,a0,s3
ffffffffc02069f8:	258050ef          	jal	ffffffffc020bc50 <strcpy>
ffffffffc02069fc:	014c07b3          	add	a5,s8,s4
ffffffffc0206a00:	872a                	mv	a4,a0
ffffffffc0206a02:	e398                	sd	a4,0(a5)
ffffffffc0206a04:	8526                	mv	a0,s1
ffffffffc0206a06:	6585                	lui	a1,0x1
ffffffffc0206a08:	22c050ef          	jal	ffffffffc020bc34 <strnlen>
ffffffffc0206a0c:	00150793          	addi	a5,a0,1
ffffffffc0206a10:	2c85                	addiw	s9,s9,1
ffffffffc0206a12:	0a21                	addi	s4,s4,8
ffffffffc0206a14:	01778bbb          	addw	s7,a5,s7
ffffffffc0206a18:	fc8ce9e3          	bltu	s9,s0,ffffffffc02069ea <do_execve+0x3f0>
ffffffffc0206a1c:	00093783          	ld	a5,0(s2)
ffffffffc0206a20:	fe8aae23          	sw	s0,-4(s5)
ffffffffc0206a24:	12000613          	li	a2,288
ffffffffc0206a28:	0a07ba03          	ld	s4,160(a5)
ffffffffc0206a2c:	4581                	li	a1,0
ffffffffc0206a2e:	1af1                	addi	s5,s5,-4
ffffffffc0206a30:	100a3403          	ld	s0,256(s4)
ffffffffc0206a34:	8552                	mv	a0,s4
ffffffffc0206a36:	29a050ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0206a3a:	776a                	ld	a4,184(sp)
ffffffffc0206a3c:	edf47793          	andi	a5,s0,-289
ffffffffc0206a40:	0d010993          	addi	s3,sp,208
ffffffffc0206a44:	020b1613          	slli	a2,s6,0x20
ffffffffc0206a48:	0207e793          	ori	a5,a5,32
ffffffffc0206a4c:	ff8afa93          	andi	s5,s5,-8
ffffffffc0206a50:	01d65693          	srli	a3,a2,0x1d
ffffffffc0206a54:	99ea                	add	s3,s3,s10
ffffffffc0206a56:	09a0                	addi	s0,sp,216
ffffffffc0206a58:	10fa3023          	sd	a5,256(s4)
ffffffffc0206a5c:	015a3823          	sd	s5,16(s4)
ffffffffc0206a60:	40d989b3          	sub	s3,s3,a3
ffffffffc0206a64:	946a                	add	s0,s0,s10
ffffffffc0206a66:	10ea3423          	sd	a4,264(s4)
ffffffffc0206a6a:	6008                	ld	a0,0(s0)
ffffffffc0206a6c:	1461                	addi	s0,s0,-8
ffffffffc0206a6e:	fc0fb0ef          	jal	ffffffffc020222e <kfree>
ffffffffc0206a72:	ff341ce3          	bne	s0,s3,ffffffffc0206a6a <do_execve+0x470>
ffffffffc0206a76:	00093403          	ld	s0,0(s2)
ffffffffc0206a7a:	4641                	li	a2,16
ffffffffc0206a7c:	4581                	li	a1,0
ffffffffc0206a7e:	0b440413          	addi	s0,s0,180
ffffffffc0206a82:	8522                	mv	a0,s0
ffffffffc0206a84:	24c050ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0206a88:	08ac                	addi	a1,sp,88
ffffffffc0206a8a:	8522                	mv	a0,s0
ffffffffc0206a8c:	463d                	li	a2,15
ffffffffc0206a8e:	292050ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc0206a92:	24813083          	ld	ra,584(sp)
ffffffffc0206a96:	24013403          	ld	s0,576(sp)
ffffffffc0206a9a:	23813483          	ld	s1,568(sp)
ffffffffc0206a9e:	23013903          	ld	s2,560(sp)
ffffffffc0206aa2:	22813983          	ld	s3,552(sp)
ffffffffc0206aa6:	22013a03          	ld	s4,544(sp)
ffffffffc0206aaa:	21813a83          	ld	s5,536(sp)
ffffffffc0206aae:	20813b83          	ld	s7,520(sp)
ffffffffc0206ab2:	20013c03          	ld	s8,512(sp)
ffffffffc0206ab6:	7cfe                	ld	s9,504(sp)
ffffffffc0206ab8:	7d5e                	ld	s10,496(sp)
ffffffffc0206aba:	21013b03          	ld	s6,528(sp)
ffffffffc0206abe:	856e                	mv	a0,s11
ffffffffc0206ac0:	7dbe                	ld	s11,488(sp)
ffffffffc0206ac2:	25010113          	addi	sp,sp,592
ffffffffc0206ac6:	8082                	ret
ffffffffc0206ac8:	7d02                	ld	s10,32(sp)
ffffffffc0206aca:	8daa                	mv	s11,a0
ffffffffc0206acc:	bd11                	j	ffffffffc02068e0 <do_execve+0x2e6>
ffffffffc0206ace:	664a                	ld	a2,144(sp)
ffffffffc0206ad0:	67aa                	ld	a5,136(sp)
ffffffffc0206ad2:	26f66c63          	bltu	a2,a5,ffffffffc0206d4a <do_execve+0x750>
ffffffffc0206ad6:	57b6                	lw	a5,108(sp)
ffffffffc0206ad8:	0027971b          	slliw	a4,a5,0x2
ffffffffc0206adc:	0027f693          	andi	a3,a5,2
ffffffffc0206ae0:	8b11                	andi	a4,a4,4
ffffffffc0206ae2:	8b91                	andi	a5,a5,4
ffffffffc0206ae4:	caf9                	beqz	a3,ffffffffc0206bba <do_execve+0x5c0>
ffffffffc0206ae6:	24079463          	bnez	a5,ffffffffc0206d2e <do_execve+0x734>
ffffffffc0206aea:	47dd                	li	a5,23
ffffffffc0206aec:	00276693          	ori	a3,a4,2
ffffffffc0206af0:	ec3e                	sd	a5,24(sp)
ffffffffc0206af2:	c709                	beqz	a4,ffffffffc0206afc <do_execve+0x502>
ffffffffc0206af4:	67e2                	ld	a5,24(sp)
ffffffffc0206af6:	0087e793          	ori	a5,a5,8
ffffffffc0206afa:	ec3e                	sd	a5,24(sp)
ffffffffc0206afc:	75e6                	ld	a1,120(sp)
ffffffffc0206afe:	4701                	li	a4,0
ffffffffc0206b00:	854e                	mv	a0,s3
ffffffffc0206b02:	a4efd0ef          	jal	ffffffffc0203d50 <mm_map>
ffffffffc0206b06:	f169                	bnez	a0,ffffffffc0206ac8 <do_execve+0x4ce>
ffffffffc0206b08:	74e6                	ld	s1,120(sp)
ffffffffc0206b0a:	662a                	ld	a2,136(sp)
ffffffffc0206b0c:	77fd                	lui	a5,0xfffff
ffffffffc0206b0e:	00f4fa33          	and	s4,s1,a5
ffffffffc0206b12:	00c48c33          	add	s8,s1,a2
ffffffffc0206b16:	2384f763          	bgeu	s1,s8,ffffffffc0206d44 <do_execve+0x74a>
ffffffffc0206b1a:	577d                	li	a4,-1
ffffffffc0206b1c:	7bc6                	ld	s7,112(sp)
ffffffffc0206b1e:	00c75793          	srli	a5,a4,0xc
ffffffffc0206b22:	f83e                	sd	a5,48(sp)
ffffffffc0206b24:	00091d97          	auipc	s11,0x91
ffffffffc0206b28:	d94d8d93          	addi	s11,s11,-620 # ffffffffc02978b8 <pages>
ffffffffc0206b2c:	00009c97          	auipc	s9,0x9
ffffffffc0206b30:	4fcc8c93          	addi	s9,s9,1276 # ffffffffc0210028 <nbase>
ffffffffc0206b34:	fc5a                	sd	s6,56(sp)
ffffffffc0206b36:	e84e                	sd	s3,16(sp)
ffffffffc0206b38:	67c2                	ld	a5,16(sp)
ffffffffc0206b3a:	6662                	ld	a2,24(sp)
ffffffffc0206b3c:	85d2                	mv	a1,s4
ffffffffc0206b3e:	6f88                	ld	a0,24(a5)
ffffffffc0206b40:	f91fc0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc0206b44:	8d2a                	mv	s10,a0
ffffffffc0206b46:	c161                	beqz	a0,ffffffffc0206c06 <do_execve+0x60c>
ffffffffc0206b48:	6785                	lui	a5,0x1
ffffffffc0206b4a:	00fa0b33          	add	s6,s4,a5
ffffffffc0206b4e:	409c09b3          	sub	s3,s8,s1
ffffffffc0206b52:	016c6463          	bltu	s8,s6,ffffffffc0206b5a <do_execve+0x560>
ffffffffc0206b56:	409b09b3          	sub	s3,s6,s1
ffffffffc0206b5a:	000db403          	ld	s0,0(s11)
ffffffffc0206b5e:	000cb583          	ld	a1,0(s9)
ffffffffc0206b62:	77c2                	ld	a5,48(sp)
ffffffffc0206b64:	408d0433          	sub	s0,s10,s0
ffffffffc0206b68:	8419                	srai	s0,s0,0x6
ffffffffc0206b6a:	00091617          	auipc	a2,0x91
ffffffffc0206b6e:	d4663603          	ld	a2,-698(a2) # ffffffffc02978b0 <npage>
ffffffffc0206b72:	942e                	add	s0,s0,a1
ffffffffc0206b74:	00f475b3          	and	a1,s0,a5
ffffffffc0206b78:	0432                	slli	s0,s0,0xc
ffffffffc0206b7a:	22c5f463          	bgeu	a1,a2,ffffffffc0206da2 <do_execve+0x7a8>
ffffffffc0206b7e:	6522                	ld	a0,8(sp)
ffffffffc0206b80:	4601                	li	a2,0
ffffffffc0206b82:	85de                	mv	a1,s7
ffffffffc0206b84:	00091a97          	auipc	s5,0x91
ffffffffc0206b88:	d24aba83          	ld	s5,-732(s5) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0206b8c:	d23fe0ef          	jal	ffffffffc02058ae <sysfile_seek>
ffffffffc0206b90:	e131                	bnez	a0,ffffffffc0206bd4 <do_execve+0x5da>
ffffffffc0206b92:	6522                	ld	a0,8(sp)
ffffffffc0206b94:	9aa2                	add	s5,s5,s0
ffffffffc0206b96:	414485b3          	sub	a1,s1,s4
ffffffffc0206b9a:	95d6                	add	a1,a1,s5
ffffffffc0206b9c:	864e                	mv	a2,s3
ffffffffc0206b9e:	a93fe0ef          	jal	ffffffffc0205630 <sysfile_read>
ffffffffc0206ba2:	02a98363          	beq	s3,a0,ffffffffc0206bc8 <do_execve+0x5ce>
ffffffffc0206ba6:	7d02                	ld	s10,32(sp)
ffffffffc0206ba8:	7b62                	ld	s6,56(sp)
ffffffffc0206baa:	69c2                	ld	s3,16(sp)
ffffffffc0206bac:	84aa                	mv	s1,a0
ffffffffc0206bae:	d20547e3          	bltz	a0,ffffffffc02068dc <do_execve+0x2e2>
ffffffffc0206bb2:	54fd                	li	s1,-1
ffffffffc0206bb4:	b325                	j	ffffffffc02068dc <do_execve+0x2e2>
ffffffffc0206bb6:	5de1                	li	s11,-8
ffffffffc0206bb8:	b671                	j	ffffffffc0206744 <do_execve+0x14a>
ffffffffc0206bba:	16078663          	beqz	a5,ffffffffc0206d26 <do_execve+0x72c>
ffffffffc0206bbe:	47cd                	li	a5,19
ffffffffc0206bc0:	00176693          	ori	a3,a4,1
ffffffffc0206bc4:	ec3e                	sd	a5,24(sp)
ffffffffc0206bc6:	b735                	j	ffffffffc0206af2 <do_execve+0x4f8>
ffffffffc0206bc8:	94ce                	add	s1,s1,s3
ffffffffc0206bca:	9bce                	add	s7,s7,s3
ffffffffc0206bcc:	0584f263          	bgeu	s1,s8,ffffffffc0206c10 <do_execve+0x616>
ffffffffc0206bd0:	8a5a                	mv	s4,s6
ffffffffc0206bd2:	b79d                	j	ffffffffc0206b38 <do_execve+0x53e>
ffffffffc0206bd4:	7d02                	ld	s10,32(sp)
ffffffffc0206bd6:	7b62                	ld	s6,56(sp)
ffffffffc0206bd8:	69c2                	ld	s3,16(sp)
ffffffffc0206bda:	8daa                	mv	s11,a0
ffffffffc0206bdc:	b311                	j	ffffffffc02068e0 <do_execve+0x2e6>
ffffffffc0206bde:	000a8863          	beqz	s5,ffffffffc0206bee <do_execve+0x5f4>
ffffffffc0206be2:	038a8513          	addi	a0,s5,56
ffffffffc0206be6:	a2ffd0ef          	jal	ffffffffc0204614 <up>
ffffffffc0206bea:	040aa823          	sw	zero,80(s5)
ffffffffc0206bee:	24013403          	ld	s0,576(sp)
ffffffffc0206bf2:	23813483          	ld	s1,568(sp)
ffffffffc0206bf6:	23013903          	ld	s2,560(sp)
ffffffffc0206bfa:	21813a83          	ld	s5,536(sp)
ffffffffc0206bfe:	20013c03          	ld	s8,512(sp)
ffffffffc0206c02:	5df5                	li	s11,-3
ffffffffc0206c04:	b901                	j	ffffffffc0206814 <do_execve+0x21a>
ffffffffc0206c06:	7d02                	ld	s10,32(sp)
ffffffffc0206c08:	7b62                	ld	s6,56(sp)
ffffffffc0206c0a:	69c2                	ld	s3,16(sp)
ffffffffc0206c0c:	5df1                	li	s11,-4
ffffffffc0206c0e:	b9c9                	j	ffffffffc02068e0 <do_execve+0x2e6>
ffffffffc0206c10:	8aea                	mv	s5,s10
ffffffffc0206c12:	69c2                	ld	s3,16(sp)
ffffffffc0206c14:	8d5a                	mv	s10,s6
ffffffffc0206c16:	7866                	ld	a6,120(sp)
ffffffffc0206c18:	7b62                	ld	s6,56(sp)
ffffffffc0206c1a:	66ca                	ld	a3,144(sp)
ffffffffc0206c1c:	00d80433          	add	s0,a6,a3
ffffffffc0206c20:	07a4f863          	bgeu	s1,s10,ffffffffc0206c90 <do_execve+0x696>
ffffffffc0206c24:	cc9406e3          	beq	s0,s1,ffffffffc02068f0 <do_execve+0x2f6>
ffffffffc0206c28:	40940a33          	sub	s4,s0,s1
ffffffffc0206c2c:	01a46463          	bltu	s0,s10,ffffffffc0206c34 <do_execve+0x63a>
ffffffffc0206c30:	409d0a33          	sub	s4,s10,s1
ffffffffc0206c34:	00091697          	auipc	a3,0x91
ffffffffc0206c38:	c846b683          	ld	a3,-892(a3) # ffffffffc02978b8 <pages>
ffffffffc0206c3c:	00009617          	auipc	a2,0x9
ffffffffc0206c40:	3ec63603          	ld	a2,1004(a2) # ffffffffc0210028 <nbase>
ffffffffc0206c44:	00091597          	auipc	a1,0x91
ffffffffc0206c48:	c6c5b583          	ld	a1,-916(a1) # ffffffffc02978b0 <npage>
ffffffffc0206c4c:	40da86b3          	sub	a3,s5,a3
ffffffffc0206c50:	8699                	srai	a3,a3,0x6
ffffffffc0206c52:	96b2                	add	a3,a3,a2
ffffffffc0206c54:	00c69613          	slli	a2,a3,0xc
ffffffffc0206c58:	8231                	srli	a2,a2,0xc
ffffffffc0206c5a:	06b2                	slli	a3,a3,0xc
ffffffffc0206c5c:	0eb67b63          	bgeu	a2,a1,ffffffffc0206d52 <do_execve+0x758>
ffffffffc0206c60:	00091617          	auipc	a2,0x91
ffffffffc0206c64:	c4863603          	ld	a2,-952(a2) # ffffffffc02978a8 <va_pa_offset>
ffffffffc0206c68:	6505                	lui	a0,0x1
ffffffffc0206c6a:	9526                	add	a0,a0,s1
ffffffffc0206c6c:	96b2                	add	a3,a3,a2
ffffffffc0206c6e:	41a50533          	sub	a0,a0,s10
ffffffffc0206c72:	9536                	add	a0,a0,a3
ffffffffc0206c74:	8652                	mv	a2,s4
ffffffffc0206c76:	4581                	li	a1,0
ffffffffc0206c78:	058050ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0206c7c:	94d2                	add	s1,s1,s4
ffffffffc0206c7e:	01a436b3          	sltu	a3,s0,s10
ffffffffc0206c82:	01a47463          	bgeu	s0,s10,ffffffffc0206c8a <do_execve+0x690>
ffffffffc0206c86:	c69405e3          	beq	s0,s1,ffffffffc02068f0 <do_execve+0x2f6>
ffffffffc0206c8a:	e2e5                	bnez	a3,ffffffffc0206d6a <do_execve+0x770>
ffffffffc0206c8c:	0da49f63          	bne	s1,s10,ffffffffc0206d6a <do_execve+0x770>
ffffffffc0206c90:	c684f0e3          	bgeu	s1,s0,ffffffffc02068f0 <do_execve+0x2f6>
ffffffffc0206c94:	57fd                	li	a5,-1
ffffffffc0206c96:	83b1                	srli	a5,a5,0xc
ffffffffc0206c98:	e83e                	sd	a5,16(sp)
ffffffffc0206c9a:	00091c97          	auipc	s9,0x91
ffffffffc0206c9e:	c1ec8c93          	addi	s9,s9,-994 # ffffffffc02978b8 <pages>
ffffffffc0206ca2:	00009c17          	auipc	s8,0x9
ffffffffc0206ca6:	386c0c13          	addi	s8,s8,902 # ffffffffc0210028 <nbase>
ffffffffc0206caa:	00091b97          	auipc	s7,0x91
ffffffffc0206cae:	c06b8b93          	addi	s7,s7,-1018 # ffffffffc02978b0 <npage>
ffffffffc0206cb2:	00091d97          	auipc	s11,0x91
ffffffffc0206cb6:	bf6d8d93          	addi	s11,s11,-1034 # ffffffffc02978a8 <va_pa_offset>
ffffffffc0206cba:	f85a                	sd	s6,48(sp)
ffffffffc0206cbc:	a889                	j	ffffffffc0206d0e <do_execve+0x714>
ffffffffc0206cbe:	6785                	lui	a5,0x1
ffffffffc0206cc0:	00fd0a33          	add	s4,s10,a5
ffffffffc0206cc4:	40940b33          	sub	s6,s0,s1
ffffffffc0206cc8:	01446463          	bltu	s0,s4,ffffffffc0206cd0 <do_execve+0x6d6>
ffffffffc0206ccc:	409a0b33          	sub	s6,s4,s1
ffffffffc0206cd0:	000cb783          	ld	a5,0(s9)
ffffffffc0206cd4:	000c3583          	ld	a1,0(s8)
ffffffffc0206cd8:	6742                	ld	a4,16(sp)
ffffffffc0206cda:	40fa87b3          	sub	a5,s5,a5
ffffffffc0206cde:	8799                	srai	a5,a5,0x6
ffffffffc0206ce0:	000bb683          	ld	a3,0(s7)
ffffffffc0206ce4:	97ae                	add	a5,a5,a1
ffffffffc0206ce6:	00e7f5b3          	and	a1,a5,a4
ffffffffc0206cea:	07b2                	slli	a5,a5,0xc
ffffffffc0206cec:	06d5f263          	bgeu	a1,a3,ffffffffc0206d50 <do_execve+0x756>
ffffffffc0206cf0:	000db683          	ld	a3,0(s11)
ffffffffc0206cf4:	41a48d33          	sub	s10,s1,s10
ffffffffc0206cf8:	865a                	mv	a2,s6
ffffffffc0206cfa:	97b6                	add	a5,a5,a3
ffffffffc0206cfc:	01a78533          	add	a0,a5,s10
ffffffffc0206d00:	4581                	li	a1,0
ffffffffc0206d02:	94da                	add	s1,s1,s6
ffffffffc0206d04:	7cd040ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0206d08:	0284f863          	bgeu	s1,s0,ffffffffc0206d38 <do_execve+0x73e>
ffffffffc0206d0c:	8d52                	mv	s10,s4
ffffffffc0206d0e:	0189b503          	ld	a0,24(s3)
ffffffffc0206d12:	6662                	ld	a2,24(sp)
ffffffffc0206d14:	85ea                	mv	a1,s10
ffffffffc0206d16:	dbbfc0ef          	jal	ffffffffc0203ad0 <pgdir_alloc_page>
ffffffffc0206d1a:	8aaa                	mv	s5,a0
ffffffffc0206d1c:	f14d                	bnez	a0,ffffffffc0206cbe <do_execve+0x6c4>
ffffffffc0206d1e:	7d02                	ld	s10,32(sp)
ffffffffc0206d20:	7b42                	ld	s6,48(sp)
ffffffffc0206d22:	5df1                	li	s11,-4
ffffffffc0206d24:	be75                	j	ffffffffc02068e0 <do_execve+0x2e6>
ffffffffc0206d26:	47c5                	li	a5,17
ffffffffc0206d28:	86ba                	mv	a3,a4
ffffffffc0206d2a:	ec3e                	sd	a5,24(sp)
ffffffffc0206d2c:	b3d9                	j	ffffffffc0206af2 <do_execve+0x4f8>
ffffffffc0206d2e:	47dd                	li	a5,23
ffffffffc0206d30:	00376693          	ori	a3,a4,3
ffffffffc0206d34:	ec3e                	sd	a5,24(sp)
ffffffffc0206d36:	bb75                	j	ffffffffc0206af2 <do_execve+0x4f8>
ffffffffc0206d38:	7b42                	ld	s6,48(sp)
ffffffffc0206d3a:	be5d                	j	ffffffffc02068f0 <do_execve+0x2f6>
ffffffffc0206d3c:	5df5                	li	s11,-3
ffffffffc0206d3e:	aa0a98e3          	bnez	s5,ffffffffc02067ee <do_execve+0x1f4>
ffffffffc0206d42:	bc65                	j	ffffffffc02067fa <do_execve+0x200>
ffffffffc0206d44:	8d52                	mv	s10,s4
ffffffffc0206d46:	8826                	mv	a6,s1
ffffffffc0206d48:	bdc9                	j	ffffffffc0206c1a <do_execve+0x620>
ffffffffc0206d4a:	7d02                	ld	s10,32(sp)
ffffffffc0206d4c:	5de1                	li	s11,-8
ffffffffc0206d4e:	be49                	j	ffffffffc02068e0 <do_execve+0x2e6>
ffffffffc0206d50:	86be                	mv	a3,a5
ffffffffc0206d52:	00006617          	auipc	a2,0x6
ffffffffc0206d56:	ebe60613          	addi	a2,a2,-322 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0206d5a:	07100593          	li	a1,113
ffffffffc0206d5e:	00006517          	auipc	a0,0x6
ffffffffc0206d62:	eda50513          	addi	a0,a0,-294 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0206d66:	ee4f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206d6a:	00007697          	auipc	a3,0x7
ffffffffc0206d6e:	09668693          	addi	a3,a3,150 # ffffffffc020de00 <etext+0x20c8>
ffffffffc0206d72:	00005617          	auipc	a2,0x5
ffffffffc0206d76:	3fe60613          	addi	a2,a2,1022 # ffffffffc020c170 <etext+0x438>
ffffffffc0206d7a:	30f00593          	li	a1,783
ffffffffc0206d7e:	00007517          	auipc	a0,0x7
ffffffffc0206d82:	e6a50513          	addi	a0,a0,-406 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206d86:	ec4f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206d8a:	00006617          	auipc	a2,0x6
ffffffffc0206d8e:	f2e60613          	addi	a2,a2,-210 # ffffffffc020ccb8 <etext+0xf80>
ffffffffc0206d92:	32f00593          	li	a1,815
ffffffffc0206d96:	00007517          	auipc	a0,0x7
ffffffffc0206d9a:	e5250513          	addi	a0,a0,-430 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206d9e:	eacf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206da2:	86a2                	mv	a3,s0
ffffffffc0206da4:	00006617          	auipc	a2,0x6
ffffffffc0206da8:	e6c60613          	addi	a2,a2,-404 # ffffffffc020cc10 <etext+0xed8>
ffffffffc0206dac:	07100593          	li	a1,113
ffffffffc0206db0:	00006517          	auipc	a0,0x6
ffffffffc0206db4:	e8850513          	addi	a0,a0,-376 # ffffffffc020cc38 <etext+0xf00>
ffffffffc0206db8:	e92f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206dbc:	8daa                	mv	s11,a0
ffffffffc0206dbe:	ba51                	j	ffffffffc0206752 <do_execve+0x158>
ffffffffc0206dc0:	00007697          	auipc	a3,0x7
ffffffffc0206dc4:	15868693          	addi	a3,a3,344 # ffffffffc020df18 <etext+0x21e0>
ffffffffc0206dc8:	00005617          	auipc	a2,0x5
ffffffffc0206dcc:	3a860613          	addi	a2,a2,936 # ffffffffc020c170 <etext+0x438>
ffffffffc0206dd0:	32a00593          	li	a1,810
ffffffffc0206dd4:	00007517          	auipc	a0,0x7
ffffffffc0206dd8:	e1450513          	addi	a0,a0,-492 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206ddc:	e6ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206de0:	00007697          	auipc	a3,0x7
ffffffffc0206de4:	0f068693          	addi	a3,a3,240 # ffffffffc020ded0 <etext+0x2198>
ffffffffc0206de8:	00005617          	auipc	a2,0x5
ffffffffc0206dec:	38860613          	addi	a2,a2,904 # ffffffffc020c170 <etext+0x438>
ffffffffc0206df0:	32900593          	li	a1,809
ffffffffc0206df4:	00007517          	auipc	a0,0x7
ffffffffc0206df8:	df450513          	addi	a0,a0,-524 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206dfc:	e4ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206e00:	00007697          	auipc	a3,0x7
ffffffffc0206e04:	08868693          	addi	a3,a3,136 # ffffffffc020de88 <etext+0x2150>
ffffffffc0206e08:	00005617          	auipc	a2,0x5
ffffffffc0206e0c:	36860613          	addi	a2,a2,872 # ffffffffc020c170 <etext+0x438>
ffffffffc0206e10:	32800593          	li	a1,808
ffffffffc0206e14:	00007517          	auipc	a0,0x7
ffffffffc0206e18:	dd450513          	addi	a0,a0,-556 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206e1c:	e2ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206e20:	00007697          	auipc	a3,0x7
ffffffffc0206e24:	02068693          	addi	a3,a3,32 # ffffffffc020de40 <etext+0x2108>
ffffffffc0206e28:	00005617          	auipc	a2,0x5
ffffffffc0206e2c:	34860613          	addi	a2,a2,840 # ffffffffc020c170 <etext+0x438>
ffffffffc0206e30:	32700593          	li	a1,807
ffffffffc0206e34:	00007517          	auipc	a0,0x7
ffffffffc0206e38:	db450513          	addi	a0,a0,-588 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206e3c:	e0ef90ef          	jal	ffffffffc020044a <__panic>

ffffffffc0206e40 <user_main>:
ffffffffc0206e40:	7179                	addi	sp,sp,-48
ffffffffc0206e42:	e84a                	sd	s2,16(sp)
ffffffffc0206e44:	00091917          	auipc	s2,0x91
ffffffffc0206e48:	a8c90913          	addi	s2,s2,-1396 # ffffffffc02978d0 <current>
ffffffffc0206e4c:	00093783          	ld	a5,0(s2)
ffffffffc0206e50:	00007617          	auipc	a2,0x7
ffffffffc0206e54:	11060613          	addi	a2,a2,272 # ffffffffc020df60 <etext+0x2228>
ffffffffc0206e58:	00007517          	auipc	a0,0x7
ffffffffc0206e5c:	11050513          	addi	a0,a0,272 # ffffffffc020df68 <etext+0x2230>
ffffffffc0206e60:	43cc                	lw	a1,4(a5)
ffffffffc0206e62:	f406                	sd	ra,40(sp)
ffffffffc0206e64:	f022                	sd	s0,32(sp)
ffffffffc0206e66:	ec26                	sd	s1,24(sp)
ffffffffc0206e68:	e402                	sd	zero,8(sp)
ffffffffc0206e6a:	e032                	sd	a2,0(sp)
ffffffffc0206e6c:	b3af90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0206e70:	6782                	ld	a5,0(sp)
ffffffffc0206e72:	cfb9                	beqz	a5,ffffffffc0206ed0 <user_main+0x90>
ffffffffc0206e74:	003c                	addi	a5,sp,8
ffffffffc0206e76:	4401                	li	s0,0
ffffffffc0206e78:	6398                	ld	a4,0(a5)
ffffffffc0206e7a:	07a1                	addi	a5,a5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc0206e7c:	0405                	addi	s0,s0,1
ffffffffc0206e7e:	ff6d                	bnez	a4,ffffffffc0206e78 <user_main+0x38>
ffffffffc0206e80:	00093703          	ld	a4,0(s2)
ffffffffc0206e84:	6789                	lui	a5,0x2
ffffffffc0206e86:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206e8a:	6b04                	ld	s1,16(a4)
ffffffffc0206e8c:	734c                	ld	a1,160(a4)
ffffffffc0206e8e:	12000613          	li	a2,288
ffffffffc0206e92:	94be                	add	s1,s1,a5
ffffffffc0206e94:	8526                	mv	a0,s1
ffffffffc0206e96:	68b040ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc0206e9a:	00093783          	ld	a5,0(s2)
ffffffffc0206e9e:	0004059b          	sext.w	a1,s0
ffffffffc0206ea2:	860a                	mv	a2,sp
ffffffffc0206ea4:	f3c4                	sd	s1,160(a5)
ffffffffc0206ea6:	00007517          	auipc	a0,0x7
ffffffffc0206eaa:	0ba50513          	addi	a0,a0,186 # ffffffffc020df60 <etext+0x2228>
ffffffffc0206eae:	f4cff0ef          	jal	ffffffffc02065fa <do_execve>
ffffffffc0206eb2:	8126                	mv	sp,s1
ffffffffc0206eb4:	d08fa06f          	j	ffffffffc02013bc <__trapret>
ffffffffc0206eb8:	00007617          	auipc	a2,0x7
ffffffffc0206ebc:	0d860613          	addi	a2,a2,216 # ffffffffc020df90 <etext+0x2258>
ffffffffc0206ec0:	46600593          	li	a1,1126
ffffffffc0206ec4:	00007517          	auipc	a0,0x7
ffffffffc0206ec8:	d2450513          	addi	a0,a0,-732 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0206ecc:	d7ef90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0206ed0:	4401                	li	s0,0
ffffffffc0206ed2:	b77d                	j	ffffffffc0206e80 <user_main+0x40>

ffffffffc0206ed4 <do_yield>:
ffffffffc0206ed4:	00091797          	auipc	a5,0x91
ffffffffc0206ed8:	9fc7b783          	ld	a5,-1540(a5) # ffffffffc02978d0 <current>
ffffffffc0206edc:	4705                	li	a4,1
ffffffffc0206ede:	4501                	li	a0,0
ffffffffc0206ee0:	ef98                	sd	a4,24(a5)
ffffffffc0206ee2:	8082                	ret

ffffffffc0206ee4 <do_wait>:
ffffffffc0206ee4:	c59d                	beqz	a1,ffffffffc0206f12 <do_wait+0x2e>
ffffffffc0206ee6:	1101                	addi	sp,sp,-32
ffffffffc0206ee8:	e02a                	sd	a0,0(sp)
ffffffffc0206eea:	00091517          	auipc	a0,0x91
ffffffffc0206eee:	9e653503          	ld	a0,-1562(a0) # ffffffffc02978d0 <current>
ffffffffc0206ef2:	4685                	li	a3,1
ffffffffc0206ef4:	4611                	li	a2,4
ffffffffc0206ef6:	7508                	ld	a0,40(a0)
ffffffffc0206ef8:	ec06                	sd	ra,24(sp)
ffffffffc0206efa:	e42e                	sd	a1,8(sp)
ffffffffc0206efc:	b56fd0ef          	jal	ffffffffc0204252 <user_mem_check>
ffffffffc0206f00:	6702                	ld	a4,0(sp)
ffffffffc0206f02:	67a2                	ld	a5,8(sp)
ffffffffc0206f04:	c909                	beqz	a0,ffffffffc0206f16 <do_wait+0x32>
ffffffffc0206f06:	60e2                	ld	ra,24(sp)
ffffffffc0206f08:	85be                	mv	a1,a5
ffffffffc0206f0a:	853a                	mv	a0,a4
ffffffffc0206f0c:	6105                	addi	sp,sp,32
ffffffffc0206f0e:	bbaff06f          	j	ffffffffc02062c8 <do_wait.part.0>
ffffffffc0206f12:	bb6ff06f          	j	ffffffffc02062c8 <do_wait.part.0>
ffffffffc0206f16:	60e2                	ld	ra,24(sp)
ffffffffc0206f18:	5575                	li	a0,-3
ffffffffc0206f1a:	6105                	addi	sp,sp,32
ffffffffc0206f1c:	8082                	ret

ffffffffc0206f1e <do_kill>:
ffffffffc0206f1e:	6789                	lui	a5,0x2
ffffffffc0206f20:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206f24:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0206f26:	06e7e463          	bltu	a5,a4,ffffffffc0206f8e <do_kill+0x70>
ffffffffc0206f2a:	1101                	addi	sp,sp,-32
ffffffffc0206f2c:	45a9                	li	a1,10
ffffffffc0206f2e:	ec06                	sd	ra,24(sp)
ffffffffc0206f30:	e42a                	sd	a0,8(sp)
ffffffffc0206f32:	063040ef          	jal	ffffffffc020b794 <hash32>
ffffffffc0206f36:	02051793          	slli	a5,a0,0x20
ffffffffc0206f3a:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206f3e:	0008c797          	auipc	a5,0x8c
ffffffffc0206f42:	88278793          	addi	a5,a5,-1918 # ffffffffc02927c0 <hash_list>
ffffffffc0206f46:	96be                	add	a3,a3,a5
ffffffffc0206f48:	6622                	ld	a2,8(sp)
ffffffffc0206f4a:	8536                	mv	a0,a3
ffffffffc0206f4c:	a029                	j	ffffffffc0206f56 <do_kill+0x38>
ffffffffc0206f4e:	f2c52703          	lw	a4,-212(a0)
ffffffffc0206f52:	00c70963          	beq	a4,a2,ffffffffc0206f64 <do_kill+0x46>
ffffffffc0206f56:	6508                	ld	a0,8(a0)
ffffffffc0206f58:	fea69be3          	bne	a3,a0,ffffffffc0206f4e <do_kill+0x30>
ffffffffc0206f5c:	60e2                	ld	ra,24(sp)
ffffffffc0206f5e:	5575                	li	a0,-3
ffffffffc0206f60:	6105                	addi	sp,sp,32
ffffffffc0206f62:	8082                	ret
ffffffffc0206f64:	fd852703          	lw	a4,-40(a0)
ffffffffc0206f68:	00177693          	andi	a3,a4,1
ffffffffc0206f6c:	e29d                	bnez	a3,ffffffffc0206f92 <do_kill+0x74>
ffffffffc0206f6e:	4954                	lw	a3,20(a0)
ffffffffc0206f70:	00176713          	ori	a4,a4,1
ffffffffc0206f74:	fce52c23          	sw	a4,-40(a0)
ffffffffc0206f78:	0006c663          	bltz	a3,ffffffffc0206f84 <do_kill+0x66>
ffffffffc0206f7c:	4501                	li	a0,0
ffffffffc0206f7e:	60e2                	ld	ra,24(sp)
ffffffffc0206f80:	6105                	addi	sp,sp,32
ffffffffc0206f82:	8082                	ret
ffffffffc0206f84:	f2850513          	addi	a0,a0,-216
ffffffffc0206f88:	199000ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc0206f8c:	bfc5                	j	ffffffffc0206f7c <do_kill+0x5e>
ffffffffc0206f8e:	5575                	li	a0,-3
ffffffffc0206f90:	8082                	ret
ffffffffc0206f92:	555d                	li	a0,-9
ffffffffc0206f94:	b7ed                	j	ffffffffc0206f7e <do_kill+0x60>

ffffffffc0206f96 <proc_init>:
ffffffffc0206f96:	1101                	addi	sp,sp,-32
ffffffffc0206f98:	e426                	sd	s1,8(sp)
ffffffffc0206f9a:	00090797          	auipc	a5,0x90
ffffffffc0206f9e:	82678793          	addi	a5,a5,-2010 # ffffffffc02967c0 <proc_list>
ffffffffc0206fa2:	ec06                	sd	ra,24(sp)
ffffffffc0206fa4:	e822                	sd	s0,16(sp)
ffffffffc0206fa6:	e04a                	sd	s2,0(sp)
ffffffffc0206fa8:	0008c497          	auipc	s1,0x8c
ffffffffc0206fac:	81848493          	addi	s1,s1,-2024 # ffffffffc02927c0 <hash_list>
ffffffffc0206fb0:	e79c                	sd	a5,8(a5)
ffffffffc0206fb2:	e39c                	sd	a5,0(a5)
ffffffffc0206fb4:	00090717          	auipc	a4,0x90
ffffffffc0206fb8:	80c70713          	addi	a4,a4,-2036 # ffffffffc02967c0 <proc_list>
ffffffffc0206fbc:	87a6                	mv	a5,s1
ffffffffc0206fbe:	e79c                	sd	a5,8(a5)
ffffffffc0206fc0:	e39c                	sd	a5,0(a5)
ffffffffc0206fc2:	07c1                	addi	a5,a5,16
ffffffffc0206fc4:	fee79de3          	bne	a5,a4,ffffffffc0206fbe <proc_init+0x28>
ffffffffc0206fc8:	b1dfe0ef          	jal	ffffffffc0205ae4 <alloc_proc>
ffffffffc0206fcc:	00091917          	auipc	s2,0x91
ffffffffc0206fd0:	91490913          	addi	s2,s2,-1772 # ffffffffc02978e0 <idleproc>
ffffffffc0206fd4:	00a93023          	sd	a0,0(s2)
ffffffffc0206fd8:	842a                	mv	s0,a0
ffffffffc0206fda:	12050c63          	beqz	a0,ffffffffc0207112 <proc_init+0x17c>
ffffffffc0206fde:	4689                	li	a3,2
ffffffffc0206fe0:	0000b717          	auipc	a4,0xb
ffffffffc0206fe4:	02070713          	addi	a4,a4,32 # ffffffffc0212000 <bootstack>
ffffffffc0206fe8:	4785                	li	a5,1
ffffffffc0206fea:	e114                	sd	a3,0(a0)
ffffffffc0206fec:	e918                	sd	a4,16(a0)
ffffffffc0206fee:	ed1c                	sd	a5,24(a0)
ffffffffc0206ff0:	aaafe0ef          	jal	ffffffffc020529a <files_create>
ffffffffc0206ff4:	14a43423          	sd	a0,328(s0)
ffffffffc0206ff8:	10050163          	beqz	a0,ffffffffc02070fa <proc_init+0x164>
ffffffffc0206ffc:	00093403          	ld	s0,0(s2)
ffffffffc0207000:	4641                	li	a2,16
ffffffffc0207002:	4581                	li	a1,0
ffffffffc0207004:	14843703          	ld	a4,328(s0)
ffffffffc0207008:	0b440413          	addi	s0,s0,180
ffffffffc020700c:	8522                	mv	a0,s0
ffffffffc020700e:	4b1c                	lw	a5,16(a4)
ffffffffc0207010:	2785                	addiw	a5,a5,1
ffffffffc0207012:	cb1c                	sw	a5,16(a4)
ffffffffc0207014:	4bd040ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0207018:	8522                	mv	a0,s0
ffffffffc020701a:	463d                	li	a2,15
ffffffffc020701c:	00007597          	auipc	a1,0x7
ffffffffc0207020:	fd458593          	addi	a1,a1,-44 # ffffffffc020dff0 <etext+0x22b8>
ffffffffc0207024:	4fd040ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc0207028:	00091797          	auipc	a5,0x91
ffffffffc020702c:	8a07a783          	lw	a5,-1888(a5) # ffffffffc02978c8 <nr_process>
ffffffffc0207030:	00093703          	ld	a4,0(s2)
ffffffffc0207034:	4601                	li	a2,0
ffffffffc0207036:	2785                	addiw	a5,a5,1
ffffffffc0207038:	4581                	li	a1,0
ffffffffc020703a:	fffff517          	auipc	a0,0xfffff
ffffffffc020703e:	47050513          	addi	a0,a0,1136 # ffffffffc02064aa <init_main>
ffffffffc0207042:	00091697          	auipc	a3,0x91
ffffffffc0207046:	88e6b723          	sd	a4,-1906(a3) # ffffffffc02978d0 <current>
ffffffffc020704a:	00091717          	auipc	a4,0x91
ffffffffc020704e:	86f72f23          	sw	a5,-1922(a4) # ffffffffc02978c8 <nr_process>
ffffffffc0207052:	8c6ff0ef          	jal	ffffffffc0206118 <kernel_thread>
ffffffffc0207056:	842a                	mv	s0,a0
ffffffffc0207058:	08a05563          	blez	a0,ffffffffc02070e2 <proc_init+0x14c>
ffffffffc020705c:	6789                	lui	a5,0x2
ffffffffc020705e:	17f9                	addi	a5,a5,-2 # 1ffe <_binary_bin_swap_img_size-0x5d02>
ffffffffc0207060:	fff5071b          	addiw	a4,a0,-1
ffffffffc0207064:	02e7e463          	bltu	a5,a4,ffffffffc020708c <proc_init+0xf6>
ffffffffc0207068:	45a9                	li	a1,10
ffffffffc020706a:	72a040ef          	jal	ffffffffc020b794 <hash32>
ffffffffc020706e:	02051713          	slli	a4,a0,0x20
ffffffffc0207072:	01c75793          	srli	a5,a4,0x1c
ffffffffc0207076:	00f486b3          	add	a3,s1,a5
ffffffffc020707a:	87b6                	mv	a5,a3
ffffffffc020707c:	a029                	j	ffffffffc0207086 <proc_init+0xf0>
ffffffffc020707e:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0207082:	04870d63          	beq	a4,s0,ffffffffc02070dc <proc_init+0x146>
ffffffffc0207086:	679c                	ld	a5,8(a5)
ffffffffc0207088:	fef69be3          	bne	a3,a5,ffffffffc020707e <proc_init+0xe8>
ffffffffc020708c:	4781                	li	a5,0
ffffffffc020708e:	0b478413          	addi	s0,a5,180
ffffffffc0207092:	4641                	li	a2,16
ffffffffc0207094:	4581                	li	a1,0
ffffffffc0207096:	8522                	mv	a0,s0
ffffffffc0207098:	00091717          	auipc	a4,0x91
ffffffffc020709c:	84f73023          	sd	a5,-1984(a4) # ffffffffc02978d8 <initproc>
ffffffffc02070a0:	431040ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc02070a4:	8522                	mv	a0,s0
ffffffffc02070a6:	463d                	li	a2,15
ffffffffc02070a8:	00007597          	auipc	a1,0x7
ffffffffc02070ac:	f7058593          	addi	a1,a1,-144 # ffffffffc020e018 <etext+0x22e0>
ffffffffc02070b0:	471040ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc02070b4:	00093783          	ld	a5,0(s2)
ffffffffc02070b8:	cbc9                	beqz	a5,ffffffffc020714a <proc_init+0x1b4>
ffffffffc02070ba:	43dc                	lw	a5,4(a5)
ffffffffc02070bc:	e7d9                	bnez	a5,ffffffffc020714a <proc_init+0x1b4>
ffffffffc02070be:	00091797          	auipc	a5,0x91
ffffffffc02070c2:	81a7b783          	ld	a5,-2022(a5) # ffffffffc02978d8 <initproc>
ffffffffc02070c6:	c3b5                	beqz	a5,ffffffffc020712a <proc_init+0x194>
ffffffffc02070c8:	43d8                	lw	a4,4(a5)
ffffffffc02070ca:	4785                	li	a5,1
ffffffffc02070cc:	04f71f63          	bne	a4,a5,ffffffffc020712a <proc_init+0x194>
ffffffffc02070d0:	60e2                	ld	ra,24(sp)
ffffffffc02070d2:	6442                	ld	s0,16(sp)
ffffffffc02070d4:	64a2                	ld	s1,8(sp)
ffffffffc02070d6:	6902                	ld	s2,0(sp)
ffffffffc02070d8:	6105                	addi	sp,sp,32
ffffffffc02070da:	8082                	ret
ffffffffc02070dc:	f2878793          	addi	a5,a5,-216
ffffffffc02070e0:	b77d                	j	ffffffffc020708e <proc_init+0xf8>
ffffffffc02070e2:	00007617          	auipc	a2,0x7
ffffffffc02070e6:	f1660613          	addi	a2,a2,-234 # ffffffffc020dff8 <etext+0x22c0>
ffffffffc02070ea:	4b200593          	li	a1,1202
ffffffffc02070ee:	00007517          	auipc	a0,0x7
ffffffffc02070f2:	afa50513          	addi	a0,a0,-1286 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc02070f6:	b54f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc02070fa:	00007617          	auipc	a2,0x7
ffffffffc02070fe:	ece60613          	addi	a2,a2,-306 # ffffffffc020dfc8 <etext+0x2290>
ffffffffc0207102:	4a600593          	li	a1,1190
ffffffffc0207106:	00007517          	auipc	a0,0x7
ffffffffc020710a:	ae250513          	addi	a0,a0,-1310 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc020710e:	b3cf90ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207112:	00007617          	auipc	a2,0x7
ffffffffc0207116:	e9e60613          	addi	a2,a2,-354 # ffffffffc020dfb0 <etext+0x2278>
ffffffffc020711a:	49c00593          	li	a1,1180
ffffffffc020711e:	00007517          	auipc	a0,0x7
ffffffffc0207122:	aca50513          	addi	a0,a0,-1334 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0207126:	b24f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020712a:	00007697          	auipc	a3,0x7
ffffffffc020712e:	f1e68693          	addi	a3,a3,-226 # ffffffffc020e048 <etext+0x2310>
ffffffffc0207132:	00005617          	auipc	a2,0x5
ffffffffc0207136:	03e60613          	addi	a2,a2,62 # ffffffffc020c170 <etext+0x438>
ffffffffc020713a:	4b900593          	li	a1,1209
ffffffffc020713e:	00007517          	auipc	a0,0x7
ffffffffc0207142:	aaa50513          	addi	a0,a0,-1366 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0207146:	b04f90ef          	jal	ffffffffc020044a <__panic>
ffffffffc020714a:	00007697          	auipc	a3,0x7
ffffffffc020714e:	ed668693          	addi	a3,a3,-298 # ffffffffc020e020 <etext+0x22e8>
ffffffffc0207152:	00005617          	auipc	a2,0x5
ffffffffc0207156:	01e60613          	addi	a2,a2,30 # ffffffffc020c170 <etext+0x438>
ffffffffc020715a:	4b800593          	li	a1,1208
ffffffffc020715e:	00007517          	auipc	a0,0x7
ffffffffc0207162:	a8a50513          	addi	a0,a0,-1398 # ffffffffc020dbe8 <etext+0x1eb0>
ffffffffc0207166:	ae4f90ef          	jal	ffffffffc020044a <__panic>

ffffffffc020716a <cpu_idle>:
ffffffffc020716a:	1141                	addi	sp,sp,-16
ffffffffc020716c:	e022                	sd	s0,0(sp)
ffffffffc020716e:	e406                	sd	ra,8(sp)
ffffffffc0207170:	00090417          	auipc	s0,0x90
ffffffffc0207174:	76040413          	addi	s0,s0,1888 # ffffffffc02978d0 <current>
ffffffffc0207178:	6018                	ld	a4,0(s0)
ffffffffc020717a:	6f1c                	ld	a5,24(a4)
ffffffffc020717c:	dffd                	beqz	a5,ffffffffc020717a <cpu_idle+0x10>
ffffffffc020717e:	09b000ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc0207182:	bfdd                	j	ffffffffc0207178 <cpu_idle+0xe>

ffffffffc0207184 <lab6_set_priority>:
ffffffffc0207184:	1101                	addi	sp,sp,-32
ffffffffc0207186:	85aa                	mv	a1,a0
ffffffffc0207188:	e42a                	sd	a0,8(sp)
ffffffffc020718a:	00007517          	auipc	a0,0x7
ffffffffc020718e:	ee650513          	addi	a0,a0,-282 # ffffffffc020e070 <etext+0x2338>
ffffffffc0207192:	ec06                	sd	ra,24(sp)
ffffffffc0207194:	812f90ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0207198:	65a2                	ld	a1,8(sp)
ffffffffc020719a:	00090717          	auipc	a4,0x90
ffffffffc020719e:	73673703          	ld	a4,1846(a4) # ffffffffc02978d0 <current>
ffffffffc02071a2:	4785                	li	a5,1
ffffffffc02071a4:	c191                	beqz	a1,ffffffffc02071a8 <lab6_set_priority+0x24>
ffffffffc02071a6:	87ae                	mv	a5,a1
ffffffffc02071a8:	60e2                	ld	ra,24(sp)
ffffffffc02071aa:	14f72223          	sw	a5,324(a4)
ffffffffc02071ae:	6105                	addi	sp,sp,32
ffffffffc02071b0:	8082                	ret

ffffffffc02071b2 <do_sleep>:
ffffffffc02071b2:	c531                	beqz	a0,ffffffffc02071fe <do_sleep+0x4c>
ffffffffc02071b4:	7139                	addi	sp,sp,-64
ffffffffc02071b6:	fc06                	sd	ra,56(sp)
ffffffffc02071b8:	f822                	sd	s0,48(sp)
ffffffffc02071ba:	100027f3          	csrr	a5,sstatus
ffffffffc02071be:	8b89                	andi	a5,a5,2
ffffffffc02071c0:	e3a9                	bnez	a5,ffffffffc0207202 <do_sleep+0x50>
ffffffffc02071c2:	00090797          	auipc	a5,0x90
ffffffffc02071c6:	70e7b783          	ld	a5,1806(a5) # ffffffffc02978d0 <current>
ffffffffc02071ca:	1014                	addi	a3,sp,32
ffffffffc02071cc:	80000737          	lui	a4,0x80000
ffffffffc02071d0:	c82a                	sw	a0,16(sp)
ffffffffc02071d2:	f436                	sd	a3,40(sp)
ffffffffc02071d4:	f036                	sd	a3,32(sp)
ffffffffc02071d6:	ec3e                	sd	a5,24(sp)
ffffffffc02071d8:	4685                	li	a3,1
ffffffffc02071da:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc02071dc:	0808                	addi	a0,sp,16
ffffffffc02071de:	c394                	sw	a3,0(a5)
ffffffffc02071e0:	0ee7a623          	sw	a4,236(a5)
ffffffffc02071e4:	842a                	mv	s0,a0
ffffffffc02071e6:	0e9000ef          	jal	ffffffffc0207ace <add_timer>
ffffffffc02071ea:	02f000ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc02071ee:	8522                	mv	a0,s0
ffffffffc02071f0:	1a5000ef          	jal	ffffffffc0207b94 <del_timer>
ffffffffc02071f4:	70e2                	ld	ra,56(sp)
ffffffffc02071f6:	7442                	ld	s0,48(sp)
ffffffffc02071f8:	4501                	li	a0,0
ffffffffc02071fa:	6121                	addi	sp,sp,64
ffffffffc02071fc:	8082                	ret
ffffffffc02071fe:	4501                	li	a0,0
ffffffffc0207200:	8082                	ret
ffffffffc0207202:	e42a                	sd	a0,8(sp)
ffffffffc0207204:	a6df90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207208:	00090797          	auipc	a5,0x90
ffffffffc020720c:	6c87b783          	ld	a5,1736(a5) # ffffffffc02978d0 <current>
ffffffffc0207210:	6522                	ld	a0,8(sp)
ffffffffc0207212:	1014                	addi	a3,sp,32
ffffffffc0207214:	80000737          	lui	a4,0x80000
ffffffffc0207218:	c82a                	sw	a0,16(sp)
ffffffffc020721a:	f436                	sd	a3,40(sp)
ffffffffc020721c:	f036                	sd	a3,32(sp)
ffffffffc020721e:	ec3e                	sd	a5,24(sp)
ffffffffc0207220:	4685                	li	a3,1
ffffffffc0207222:	0709                	addi	a4,a4,2 # ffffffff80000002 <_binary_bin_sfs_img_size+0xffffffff7ff8ad02>
ffffffffc0207224:	0808                	addi	a0,sp,16
ffffffffc0207226:	c394                	sw	a3,0(a5)
ffffffffc0207228:	0ee7a623          	sw	a4,236(a5)
ffffffffc020722c:	842a                	mv	s0,a0
ffffffffc020722e:	0a1000ef          	jal	ffffffffc0207ace <add_timer>
ffffffffc0207232:	a39f90ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0207236:	bf55                	j	ffffffffc02071ea <do_sleep+0x38>

ffffffffc0207238 <switch_to>:
ffffffffc0207238:	00153023          	sd	ra,0(a0)
ffffffffc020723c:	00253423          	sd	sp,8(a0)
ffffffffc0207240:	e900                	sd	s0,16(a0)
ffffffffc0207242:	ed04                	sd	s1,24(a0)
ffffffffc0207244:	03253023          	sd	s2,32(a0)
ffffffffc0207248:	03353423          	sd	s3,40(a0)
ffffffffc020724c:	03453823          	sd	s4,48(a0)
ffffffffc0207250:	03553c23          	sd	s5,56(a0)
ffffffffc0207254:	05653023          	sd	s6,64(a0)
ffffffffc0207258:	05753423          	sd	s7,72(a0)
ffffffffc020725c:	05853823          	sd	s8,80(a0)
ffffffffc0207260:	05953c23          	sd	s9,88(a0)
ffffffffc0207264:	07a53023          	sd	s10,96(a0)
ffffffffc0207268:	07b53423          	sd	s11,104(a0)
ffffffffc020726c:	0005b083          	ld	ra,0(a1)
ffffffffc0207270:	0085b103          	ld	sp,8(a1)
ffffffffc0207274:	6980                	ld	s0,16(a1)
ffffffffc0207276:	6d84                	ld	s1,24(a1)
ffffffffc0207278:	0205b903          	ld	s2,32(a1)
ffffffffc020727c:	0285b983          	ld	s3,40(a1)
ffffffffc0207280:	0305ba03          	ld	s4,48(a1)
ffffffffc0207284:	0385ba83          	ld	s5,56(a1)
ffffffffc0207288:	0405bb03          	ld	s6,64(a1)
ffffffffc020728c:	0485bb83          	ld	s7,72(a1)
ffffffffc0207290:	0505bc03          	ld	s8,80(a1)
ffffffffc0207294:	0585bc83          	ld	s9,88(a1)
ffffffffc0207298:	0605bd03          	ld	s10,96(a1)
ffffffffc020729c:	0685bd83          	ld	s11,104(a1)
ffffffffc02072a0:	8082                	ret

ffffffffc02072a2 <stride_init>:
ffffffffc02072a2:	e508                	sd	a0,8(a0)
ffffffffc02072a4:	e108                	sd	a0,0(a0)
ffffffffc02072a6:	00053c23          	sd	zero,24(a0)
ffffffffc02072aa:	00052823          	sw	zero,16(a0)
ffffffffc02072ae:	8082                	ret

ffffffffc02072b0 <stride_pick_next>:
ffffffffc02072b0:	6d1c                	ld	a5,24(a0)
ffffffffc02072b2:	cb8d                	beqz	a5,ffffffffc02072e4 <stride_pick_next+0x34>
ffffffffc02072b4:	4fd8                	lw	a4,28(a5)
ffffffffc02072b6:	ed878513          	addi	a0,a5,-296
ffffffffc02072ba:	86ba                	mv	a3,a4
ffffffffc02072bc:	cb11                	beqz	a4,ffffffffc02072d0 <stride_pick_next+0x20>
ffffffffc02072be:	80000737          	lui	a4,0x80000
ffffffffc02072c2:	377d                	addiw	a4,a4,-1 # 7fffffff <_binary_bin_sfs_img_size+0x7ff8acff>
ffffffffc02072c4:	02d7573b          	divuw	a4,a4,a3
ffffffffc02072c8:	4f94                	lw	a3,24(a5)
ffffffffc02072ca:	9f35                	addw	a4,a4,a3
ffffffffc02072cc:	cf98                	sw	a4,24(a5)
ffffffffc02072ce:	8082                	ret
ffffffffc02072d0:	80000737          	lui	a4,0x80000
ffffffffc02072d4:	4685                	li	a3,1
ffffffffc02072d6:	377d                	addiw	a4,a4,-1 # 7fffffff <_binary_bin_sfs_img_size+0x7ff8acff>
ffffffffc02072d8:	02d7573b          	divuw	a4,a4,a3
ffffffffc02072dc:	4f94                	lw	a3,24(a5)
ffffffffc02072de:	9f35                	addw	a4,a4,a3
ffffffffc02072e0:	cf98                	sw	a4,24(a5)
ffffffffc02072e2:	8082                	ret
ffffffffc02072e4:	00090517          	auipc	a0,0x90
ffffffffc02072e8:	5fc53503          	ld	a0,1532(a0) # ffffffffc02978e0 <idleproc>
ffffffffc02072ec:	8082                	ret

ffffffffc02072ee <stride_proc_tick>:
ffffffffc02072ee:	00090797          	auipc	a5,0x90
ffffffffc02072f2:	5f27b783          	ld	a5,1522(a5) # ffffffffc02978e0 <idleproc>
ffffffffc02072f6:	00b78d63          	beq	a5,a1,ffffffffc0207310 <stride_proc_tick+0x22>
ffffffffc02072fa:	c999                	beqz	a1,ffffffffc0207310 <stride_proc_tick+0x22>
ffffffffc02072fc:	1205a783          	lw	a5,288(a1)
ffffffffc0207300:	00f05563          	blez	a5,ffffffffc020730a <stride_proc_tick+0x1c>
ffffffffc0207304:	37fd                	addiw	a5,a5,-1
ffffffffc0207306:	12f5a023          	sw	a5,288(a1)
ffffffffc020730a:	e399                	bnez	a5,ffffffffc0207310 <stride_proc_tick+0x22>
ffffffffc020730c:	4785                	li	a5,1
ffffffffc020730e:	ed9c                	sd	a5,24(a1)
ffffffffc0207310:	8082                	ret

ffffffffc0207312 <skew_heap_merge.constprop.0>:
ffffffffc0207312:	87ae                	mv	a5,a1
ffffffffc0207314:	1c050963          	beqz	a0,ffffffffc02074e6 <skew_heap_merge.constprop.0+0x1d4>
ffffffffc0207318:	862a                	mv	a2,a0
ffffffffc020731a:	1c058863          	beqz	a1,ffffffffc02074ea <skew_heap_merge.constprop.0+0x1d8>
ffffffffc020731e:	4d14                	lw	a3,24(a0)
ffffffffc0207320:	4d98                	lw	a4,24(a1)
ffffffffc0207322:	7139                	addi	sp,sp,-64
ffffffffc0207324:	fc06                	sd	ra,56(sp)
ffffffffc0207326:	40e6883b          	subw	a6,a3,a4
ffffffffc020732a:	06084d63          	bltz	a6,ffffffffc02073a4 <skew_heap_merge.constprop.0+0x92>
ffffffffc020732e:	6998                	ld	a4,16(a1)
ffffffffc0207330:	0085b883          	ld	a7,8(a1)
ffffffffc0207334:	10070d63          	beqz	a4,ffffffffc020744e <skew_heap_merge.constprop.0+0x13c>
ffffffffc0207338:	4f0c                	lw	a1,24(a4)
ffffffffc020733a:	40b6883b          	subw	a6,a3,a1
ffffffffc020733e:	0c084663          	bltz	a6,ffffffffc020740a <skew_heap_merge.constprop.0+0xf8>
ffffffffc0207342:	01073803          	ld	a6,16(a4)
ffffffffc0207346:	00873303          	ld	t1,8(a4)
ffffffffc020734a:	04080163          	beqz	a6,ffffffffc020738c <skew_heap_merge.constprop.0+0x7a>
ffffffffc020734e:	01882583          	lw	a1,24(a6) # fffffffffffff018 <end+0x3fd67700>
ffffffffc0207352:	f43e                	sd	a5,40(sp)
ffffffffc0207354:	f01a                	sd	t1,32(sp)
ffffffffc0207356:	9e8d                	subw	a3,a3,a1
ffffffffc0207358:	ec3a                	sd	a4,24(sp)
ffffffffc020735a:	e846                	sd	a7,16(sp)
ffffffffc020735c:	1606c263          	bltz	a3,ffffffffc02074c0 <skew_heap_merge.constprop.0+0x1ae>
ffffffffc0207360:	00883683          	ld	a3,8(a6)
ffffffffc0207364:	01083583          	ld	a1,16(a6)
ffffffffc0207368:	e442                	sd	a6,8(sp)
ffffffffc020736a:	e036                	sd	a3,0(sp)
ffffffffc020736c:	fa7ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207370:	6822                	ld	a6,8(sp)
ffffffffc0207372:	6682                	ld	a3,0(sp)
ffffffffc0207374:	68c2                	ld	a7,16(sp)
ffffffffc0207376:	00a83423          	sd	a0,8(a6)
ffffffffc020737a:	00d83823          	sd	a3,16(a6)
ffffffffc020737e:	6762                	ld	a4,24(sp)
ffffffffc0207380:	7302                	ld	t1,32(sp)
ffffffffc0207382:	77a2                	ld	a5,40(sp)
ffffffffc0207384:	c119                	beqz	a0,ffffffffc020738a <skew_heap_merge.constprop.0+0x78>
ffffffffc0207386:	01053023          	sd	a6,0(a0)
ffffffffc020738a:	8642                	mv	a2,a6
ffffffffc020738c:	e710                	sd	a2,8(a4)
ffffffffc020738e:	00673823          	sd	t1,16(a4)
ffffffffc0207392:	e218                	sd	a4,0(a2)
ffffffffc0207394:	70e2                	ld	ra,56(sp)
ffffffffc0207396:	e798                	sd	a4,8(a5)
ffffffffc0207398:	0117b823          	sd	a7,16(a5)
ffffffffc020739c:	e31c                	sd	a5,0(a4)
ffffffffc020739e:	853e                	mv	a0,a5
ffffffffc02073a0:	6121                	addi	sp,sp,64
ffffffffc02073a2:	8082                	ret
ffffffffc02073a4:	6914                	ld	a3,16(a0)
ffffffffc02073a6:	00853803          	ld	a6,8(a0)
ffffffffc02073aa:	caa1                	beqz	a3,ffffffffc02073fa <skew_heap_merge.constprop.0+0xe8>
ffffffffc02073ac:	4e88                	lw	a0,24(a3)
ffffffffc02073ae:	40e5073b          	subw	a4,a0,a4
ffffffffc02073b2:	0a074063          	bltz	a4,ffffffffc0207452 <skew_heap_merge.constprop.0+0x140>
ffffffffc02073b6:	6998                	ld	a4,16(a1)
ffffffffc02073b8:	0085b883          	ld	a7,8(a1)
ffffffffc02073bc:	cb1d                	beqz	a4,ffffffffc02073f2 <skew_heap_merge.constprop.0+0xe0>
ffffffffc02073be:	4f0c                	lw	a1,24(a4)
ffffffffc02073c0:	f43e                	sd	a5,40(sp)
ffffffffc02073c2:	f032                	sd	a2,32(sp)
ffffffffc02073c4:	9d0d                	subw	a0,a0,a1
ffffffffc02073c6:	ec46                	sd	a7,24(sp)
ffffffffc02073c8:	e842                	sd	a6,16(sp)
ffffffffc02073ca:	0c054963          	bltz	a0,ffffffffc020749c <skew_heap_merge.constprop.0+0x18a>
ffffffffc02073ce:	6b0c                	ld	a1,16(a4)
ffffffffc02073d0:	8536                	mv	a0,a3
ffffffffc02073d2:	6714                	ld	a3,8(a4)
ffffffffc02073d4:	e43a                	sd	a4,8(sp)
ffffffffc02073d6:	e036                	sd	a3,0(sp)
ffffffffc02073d8:	f3bff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc02073dc:	6722                	ld	a4,8(sp)
ffffffffc02073de:	6682                	ld	a3,0(sp)
ffffffffc02073e0:	6842                	ld	a6,16(sp)
ffffffffc02073e2:	e708                	sd	a0,8(a4)
ffffffffc02073e4:	eb14                	sd	a3,16(a4)
ffffffffc02073e6:	68e2                	ld	a7,24(sp)
ffffffffc02073e8:	7602                	ld	a2,32(sp)
ffffffffc02073ea:	77a2                	ld	a5,40(sp)
ffffffffc02073ec:	c111                	beqz	a0,ffffffffc02073f0 <skew_heap_merge.constprop.0+0xde>
ffffffffc02073ee:	e118                	sd	a4,0(a0)
ffffffffc02073f0:	86ba                	mv	a3,a4
ffffffffc02073f2:	e794                	sd	a3,8(a5)
ffffffffc02073f4:	0117b823          	sd	a7,16(a5)
ffffffffc02073f8:	e29c                	sd	a5,0(a3)
ffffffffc02073fa:	70e2                	ld	ra,56(sp)
ffffffffc02073fc:	e61c                	sd	a5,8(a2)
ffffffffc02073fe:	01063823          	sd	a6,16(a2)
ffffffffc0207402:	e390                	sd	a2,0(a5)
ffffffffc0207404:	8532                	mv	a0,a2
ffffffffc0207406:	6121                	addi	sp,sp,64
ffffffffc0207408:	8082                	ret
ffffffffc020740a:	6914                	ld	a3,16(a0)
ffffffffc020740c:	00853803          	ld	a6,8(a0)
ffffffffc0207410:	ca9d                	beqz	a3,ffffffffc0207446 <skew_heap_merge.constprop.0+0x134>
ffffffffc0207412:	4e88                	lw	a0,24(a3)
ffffffffc0207414:	f43e                	sd	a5,40(sp)
ffffffffc0207416:	f032                	sd	a2,32(sp)
ffffffffc0207418:	40b505bb          	subw	a1,a0,a1
ffffffffc020741c:	ec42                	sd	a6,24(sp)
ffffffffc020741e:	e846                	sd	a7,16(sp)
ffffffffc0207420:	0405cb63          	bltz	a1,ffffffffc0207476 <skew_heap_merge.constprop.0+0x164>
ffffffffc0207424:	6b0c                	ld	a1,16(a4)
ffffffffc0207426:	8536                	mv	a0,a3
ffffffffc0207428:	6714                	ld	a3,8(a4)
ffffffffc020742a:	e43a                	sd	a4,8(sp)
ffffffffc020742c:	e036                	sd	a3,0(sp)
ffffffffc020742e:	ee5ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207432:	6722                	ld	a4,8(sp)
ffffffffc0207434:	6682                	ld	a3,0(sp)
ffffffffc0207436:	68c2                	ld	a7,16(sp)
ffffffffc0207438:	e708                	sd	a0,8(a4)
ffffffffc020743a:	eb14                	sd	a3,16(a4)
ffffffffc020743c:	6862                	ld	a6,24(sp)
ffffffffc020743e:	7602                	ld	a2,32(sp)
ffffffffc0207440:	77a2                	ld	a5,40(sp)
ffffffffc0207442:	c111                	beqz	a0,ffffffffc0207446 <skew_heap_merge.constprop.0+0x134>
ffffffffc0207444:	e118                	sd	a4,0(a0)
ffffffffc0207446:	e618                	sd	a4,8(a2)
ffffffffc0207448:	01063823          	sd	a6,16(a2)
ffffffffc020744c:	e310                	sd	a2,0(a4)
ffffffffc020744e:	8732                	mv	a4,a2
ffffffffc0207450:	b791                	j	ffffffffc0207394 <skew_heap_merge.constprop.0+0x82>
ffffffffc0207452:	669c                	ld	a5,8(a3)
ffffffffc0207454:	6a88                	ld	a0,16(a3)
ffffffffc0207456:	ec32                	sd	a2,24(sp)
ffffffffc0207458:	e842                	sd	a6,16(sp)
ffffffffc020745a:	e436                	sd	a3,8(sp)
ffffffffc020745c:	e03e                	sd	a5,0(sp)
ffffffffc020745e:	eb5ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207462:	66a2                	ld	a3,8(sp)
ffffffffc0207464:	6782                	ld	a5,0(sp)
ffffffffc0207466:	6842                	ld	a6,16(sp)
ffffffffc0207468:	e688                	sd	a0,8(a3)
ffffffffc020746a:	ea9c                	sd	a5,16(a3)
ffffffffc020746c:	6662                	ld	a2,24(sp)
ffffffffc020746e:	c111                	beqz	a0,ffffffffc0207472 <skew_heap_merge.constprop.0+0x160>
ffffffffc0207470:	e114                	sd	a3,0(a0)
ffffffffc0207472:	87b6                	mv	a5,a3
ffffffffc0207474:	b759                	j	ffffffffc02073fa <skew_heap_merge.constprop.0+0xe8>
ffffffffc0207476:	6a88                	ld	a0,16(a3)
ffffffffc0207478:	85ba                	mv	a1,a4
ffffffffc020747a:	6698                	ld	a4,8(a3)
ffffffffc020747c:	e436                	sd	a3,8(sp)
ffffffffc020747e:	e03a                	sd	a4,0(sp)
ffffffffc0207480:	e93ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207484:	66a2                	ld	a3,8(sp)
ffffffffc0207486:	6702                	ld	a4,0(sp)
ffffffffc0207488:	68c2                	ld	a7,16(sp)
ffffffffc020748a:	e688                	sd	a0,8(a3)
ffffffffc020748c:	ea98                	sd	a4,16(a3)
ffffffffc020748e:	6862                	ld	a6,24(sp)
ffffffffc0207490:	7602                	ld	a2,32(sp)
ffffffffc0207492:	77a2                	ld	a5,40(sp)
ffffffffc0207494:	c111                	beqz	a0,ffffffffc0207498 <skew_heap_merge.constprop.0+0x186>
ffffffffc0207496:	e114                	sd	a3,0(a0)
ffffffffc0207498:	8736                	mv	a4,a3
ffffffffc020749a:	b775                	j	ffffffffc0207446 <skew_heap_merge.constprop.0+0x134>
ffffffffc020749c:	6a88                	ld	a0,16(a3)
ffffffffc020749e:	85ba                	mv	a1,a4
ffffffffc02074a0:	6698                	ld	a4,8(a3)
ffffffffc02074a2:	e436                	sd	a3,8(sp)
ffffffffc02074a4:	e03a                	sd	a4,0(sp)
ffffffffc02074a6:	e6dff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc02074aa:	66a2                	ld	a3,8(sp)
ffffffffc02074ac:	6702                	ld	a4,0(sp)
ffffffffc02074ae:	6842                	ld	a6,16(sp)
ffffffffc02074b0:	e688                	sd	a0,8(a3)
ffffffffc02074b2:	ea98                	sd	a4,16(a3)
ffffffffc02074b4:	68e2                	ld	a7,24(sp)
ffffffffc02074b6:	7602                	ld	a2,32(sp)
ffffffffc02074b8:	77a2                	ld	a5,40(sp)
ffffffffc02074ba:	dd05                	beqz	a0,ffffffffc02073f2 <skew_heap_merge.constprop.0+0xe0>
ffffffffc02074bc:	e114                	sd	a3,0(a0)
ffffffffc02074be:	bf15                	j	ffffffffc02073f2 <skew_heap_merge.constprop.0+0xe0>
ffffffffc02074c0:	6614                	ld	a3,8(a2)
ffffffffc02074c2:	6908                	ld	a0,16(a0)
ffffffffc02074c4:	85c2                	mv	a1,a6
ffffffffc02074c6:	e432                	sd	a2,8(sp)
ffffffffc02074c8:	e036                	sd	a3,0(sp)
ffffffffc02074ca:	e49ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc02074ce:	6622                	ld	a2,8(sp)
ffffffffc02074d0:	6682                	ld	a3,0(sp)
ffffffffc02074d2:	68c2                	ld	a7,16(sp)
ffffffffc02074d4:	e608                	sd	a0,8(a2)
ffffffffc02074d6:	ea14                	sd	a3,16(a2)
ffffffffc02074d8:	6762                	ld	a4,24(sp)
ffffffffc02074da:	7302                	ld	t1,32(sp)
ffffffffc02074dc:	77a2                	ld	a5,40(sp)
ffffffffc02074de:	ea0507e3          	beqz	a0,ffffffffc020738c <skew_heap_merge.constprop.0+0x7a>
ffffffffc02074e2:	e110                	sd	a2,0(a0)
ffffffffc02074e4:	b565                	j	ffffffffc020738c <skew_heap_merge.constprop.0+0x7a>
ffffffffc02074e6:	852e                	mv	a0,a1
ffffffffc02074e8:	8082                	ret
ffffffffc02074ea:	8082                	ret

ffffffffc02074ec <stride_dequeue>:
ffffffffc02074ec:	711d                	addi	sp,sp,-96
ffffffffc02074ee:	ec86                	sd	ra,88(sp)
ffffffffc02074f0:	2c058a63          	beqz	a1,ffffffffc02077c4 <stride_dequeue+0x2d8>
ffffffffc02074f4:	86aa                	mv	a3,a0
ffffffffc02074f6:	2c050763          	beqz	a0,ffffffffc02077c4 <stride_dequeue+0x2d8>
ffffffffc02074fa:	1305b603          	ld	a2,304(a1)
ffffffffc02074fe:	01853303          	ld	t1,24(a0)
ffffffffc0207502:	1285b803          	ld	a6,296(a1)
ffffffffc0207506:	1385b783          	ld	a5,312(a1)
ffffffffc020750a:	872e                	mv	a4,a1
ffffffffc020750c:	16060263          	beqz	a2,ffffffffc0207670 <stride_dequeue+0x184>
ffffffffc0207510:	14078963          	beqz	a5,ffffffffc0207662 <stride_dequeue+0x176>
ffffffffc0207514:	4e0c                	lw	a1,24(a2)
ffffffffc0207516:	4f88                	lw	a0,24(a5)
ffffffffc0207518:	40a588bb          	subw	a7,a1,a0
ffffffffc020751c:	0a08cf63          	bltz	a7,ffffffffc02075da <stride_dequeue+0xee>
ffffffffc0207520:	0107b883          	ld	a7,16(a5)
ffffffffc0207524:	0087be83          	ld	t4,8(a5)
ffffffffc0207528:	1a088b63          	beqz	a7,ffffffffc02076de <stride_dequeue+0x1f2>
ffffffffc020752c:	0188a503          	lw	a0,24(a7)
ffffffffc0207530:	40a58e3b          	subw	t3,a1,a0
ffffffffc0207534:	140e4263          	bltz	t3,ffffffffc0207678 <stride_dequeue+0x18c>
ffffffffc0207538:	0108be03          	ld	t3,16(a7)
ffffffffc020753c:	0088bf03          	ld	t5,8(a7)
ffffffffc0207540:	040e0a63          	beqz	t3,ffffffffc0207594 <stride_dequeue+0xa8>
ffffffffc0207544:	018e2503          	lw	a0,24(t3)
ffffffffc0207548:	e4ba                	sd	a4,72(sp)
ffffffffc020754a:	e0b6                	sd	a3,64(sp)
ffffffffc020754c:	9d89                	subw	a1,a1,a0
ffffffffc020754e:	fc3e                	sd	a5,56(sp)
ffffffffc0207550:	f87a                	sd	t5,48(sp)
ffffffffc0207552:	f446                	sd	a7,40(sp)
ffffffffc0207554:	f076                	sd	t4,32(sp)
ffffffffc0207556:	ec42                	sd	a6,24(sp)
ffffffffc0207558:	e81a                	sd	t1,16(sp)
ffffffffc020755a:	2205cc63          	bltz	a1,ffffffffc0207792 <stride_dequeue+0x2a6>
ffffffffc020755e:	010e3583          	ld	a1,16(t3)
ffffffffc0207562:	8532                	mv	a0,a2
ffffffffc0207564:	008e3603          	ld	a2,8(t3)
ffffffffc0207568:	e472                	sd	t3,8(sp)
ffffffffc020756a:	e032                	sd	a2,0(sp)
ffffffffc020756c:	da7ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207570:	6e22                	ld	t3,8(sp)
ffffffffc0207572:	6602                	ld	a2,0(sp)
ffffffffc0207574:	6342                	ld	t1,16(sp)
ffffffffc0207576:	00ae3423          	sd	a0,8(t3)
ffffffffc020757a:	00ce3823          	sd	a2,16(t3)
ffffffffc020757e:	6862                	ld	a6,24(sp)
ffffffffc0207580:	7e82                	ld	t4,32(sp)
ffffffffc0207582:	78a2                	ld	a7,40(sp)
ffffffffc0207584:	7f42                	ld	t5,48(sp)
ffffffffc0207586:	77e2                	ld	a5,56(sp)
ffffffffc0207588:	6686                	ld	a3,64(sp)
ffffffffc020758a:	6726                	ld	a4,72(sp)
ffffffffc020758c:	c119                	beqz	a0,ffffffffc0207592 <stride_dequeue+0xa6>
ffffffffc020758e:	01c53023          	sd	t3,0(a0)
ffffffffc0207592:	8672                	mv	a2,t3
ffffffffc0207594:	00c8b423          	sd	a2,8(a7)
ffffffffc0207598:	01e8b823          	sd	t5,16(a7)
ffffffffc020759c:	01163023          	sd	a7,0(a2)
ffffffffc02075a0:	0117b423          	sd	a7,8(a5)
ffffffffc02075a4:	01d7b823          	sd	t4,16(a5)
ffffffffc02075a8:	00f8b023          	sd	a5,0(a7)
ffffffffc02075ac:	0107b023          	sd	a6,0(a5)
ffffffffc02075b0:	00080b63          	beqz	a6,ffffffffc02075c6 <stride_dequeue+0xda>
ffffffffc02075b4:	00883583          	ld	a1,8(a6)
ffffffffc02075b8:	12870613          	addi	a2,a4,296
ffffffffc02075bc:	0ac58763          	beq	a1,a2,ffffffffc020766a <stride_dequeue+0x17e>
ffffffffc02075c0:	00f83823          	sd	a5,16(a6)
ffffffffc02075c4:	879a                	mv	a5,t1
ffffffffc02075c6:	4a90                	lw	a2,16(a3)
ffffffffc02075c8:	ee9c                	sd	a5,24(a3)
ffffffffc02075ca:	60e6                	ld	ra,88(sp)
ffffffffc02075cc:	10073423          	sd	zero,264(a4)
ffffffffc02075d0:	fff6079b          	addiw	a5,a2,-1
ffffffffc02075d4:	ca9c                	sw	a5,16(a3)
ffffffffc02075d6:	6125                	addi	sp,sp,96
ffffffffc02075d8:	8082                	ret
ffffffffc02075da:	01063883          	ld	a7,16(a2)
ffffffffc02075de:	00863e83          	ld	t4,8(a2)
ffffffffc02075e2:	06088c63          	beqz	a7,ffffffffc020765a <stride_dequeue+0x16e>
ffffffffc02075e6:	0188a583          	lw	a1,24(a7)
ffffffffc02075ea:	40a5853b          	subw	a0,a1,a0
ffffffffc02075ee:	0e054a63          	bltz	a0,ffffffffc02076e2 <stride_dequeue+0x1f6>
ffffffffc02075f2:	0107be03          	ld	t3,16(a5)
ffffffffc02075f6:	0087bf03          	ld	t5,8(a5)
ffffffffc02075fa:	040e0a63          	beqz	t3,ffffffffc020764e <stride_dequeue+0x162>
ffffffffc02075fe:	018e2503          	lw	a0,24(t3)
ffffffffc0207602:	e4ba                	sd	a4,72(sp)
ffffffffc0207604:	e0b6                	sd	a3,64(sp)
ffffffffc0207606:	9d89                	subw	a1,a1,a0
ffffffffc0207608:	fc3e                	sd	a5,56(sp)
ffffffffc020760a:	f87a                	sd	t5,48(sp)
ffffffffc020760c:	f476                	sd	t4,40(sp)
ffffffffc020760e:	f032                	sd	a2,32(sp)
ffffffffc0207610:	ec42                	sd	a6,24(sp)
ffffffffc0207612:	e81a                	sd	t1,16(sp)
ffffffffc0207614:	1405c363          	bltz	a1,ffffffffc020775a <stride_dequeue+0x26e>
ffffffffc0207618:	010e3583          	ld	a1,16(t3)
ffffffffc020761c:	8546                	mv	a0,a7
ffffffffc020761e:	008e3883          	ld	a7,8(t3)
ffffffffc0207622:	e472                	sd	t3,8(sp)
ffffffffc0207624:	e046                	sd	a7,0(sp)
ffffffffc0207626:	cedff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc020762a:	6e22                	ld	t3,8(sp)
ffffffffc020762c:	6882                	ld	a7,0(sp)
ffffffffc020762e:	6342                	ld	t1,16(sp)
ffffffffc0207630:	00ae3423          	sd	a0,8(t3)
ffffffffc0207634:	011e3823          	sd	a7,16(t3)
ffffffffc0207638:	6862                	ld	a6,24(sp)
ffffffffc020763a:	7602                	ld	a2,32(sp)
ffffffffc020763c:	7ea2                	ld	t4,40(sp)
ffffffffc020763e:	7f42                	ld	t5,48(sp)
ffffffffc0207640:	77e2                	ld	a5,56(sp)
ffffffffc0207642:	6686                	ld	a3,64(sp)
ffffffffc0207644:	6726                	ld	a4,72(sp)
ffffffffc0207646:	c119                	beqz	a0,ffffffffc020764c <stride_dequeue+0x160>
ffffffffc0207648:	01c53023          	sd	t3,0(a0)
ffffffffc020764c:	88f2                	mv	a7,t3
ffffffffc020764e:	0117b423          	sd	a7,8(a5)
ffffffffc0207652:	01e7b823          	sd	t5,16(a5)
ffffffffc0207656:	00f8b023          	sd	a5,0(a7)
ffffffffc020765a:	e61c                	sd	a5,8(a2)
ffffffffc020765c:	01d63823          	sd	t4,16(a2)
ffffffffc0207660:	e390                	sd	a2,0(a5)
ffffffffc0207662:	87b2                	mv	a5,a2
ffffffffc0207664:	0107b023          	sd	a6,0(a5)
ffffffffc0207668:	b7a1                	j	ffffffffc02075b0 <stride_dequeue+0xc4>
ffffffffc020766a:	00f83423          	sd	a5,8(a6)
ffffffffc020766e:	bf99                	j	ffffffffc02075c4 <stride_dequeue+0xd8>
ffffffffc0207670:	d3a1                	beqz	a5,ffffffffc02075b0 <stride_dequeue+0xc4>
ffffffffc0207672:	0107b023          	sd	a6,0(a5)
ffffffffc0207676:	bf2d                	j	ffffffffc02075b0 <stride_dequeue+0xc4>
ffffffffc0207678:	01063e03          	ld	t3,16(a2)
ffffffffc020767c:	00863f03          	ld	t5,8(a2)
ffffffffc0207680:	040e0963          	beqz	t3,ffffffffc02076d2 <stride_dequeue+0x1e6>
ffffffffc0207684:	018e2583          	lw	a1,24(t3)
ffffffffc0207688:	e4ba                	sd	a4,72(sp)
ffffffffc020768a:	e0b6                	sd	a3,64(sp)
ffffffffc020768c:	9d89                	subw	a1,a1,a0
ffffffffc020768e:	fc3e                	sd	a5,56(sp)
ffffffffc0207690:	f87a                	sd	t5,48(sp)
ffffffffc0207692:	f476                	sd	t4,40(sp)
ffffffffc0207694:	f032                	sd	a2,32(sp)
ffffffffc0207696:	ec42                	sd	a6,24(sp)
ffffffffc0207698:	e81a                	sd	t1,16(sp)
ffffffffc020769a:	0805c463          	bltz	a1,ffffffffc0207722 <stride_dequeue+0x236>
ffffffffc020769e:	0108b583          	ld	a1,16(a7)
ffffffffc02076a2:	8572                	mv	a0,t3
ffffffffc02076a4:	0088be03          	ld	t3,8(a7)
ffffffffc02076a8:	e446                	sd	a7,8(sp)
ffffffffc02076aa:	e072                	sd	t3,0(sp)
ffffffffc02076ac:	c67ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc02076b0:	68a2                	ld	a7,8(sp)
ffffffffc02076b2:	6e02                	ld	t3,0(sp)
ffffffffc02076b4:	6342                	ld	t1,16(sp)
ffffffffc02076b6:	00a8b423          	sd	a0,8(a7)
ffffffffc02076ba:	01c8b823          	sd	t3,16(a7)
ffffffffc02076be:	6862                	ld	a6,24(sp)
ffffffffc02076c0:	7602                	ld	a2,32(sp)
ffffffffc02076c2:	7ea2                	ld	t4,40(sp)
ffffffffc02076c4:	7f42                	ld	t5,48(sp)
ffffffffc02076c6:	77e2                	ld	a5,56(sp)
ffffffffc02076c8:	6686                	ld	a3,64(sp)
ffffffffc02076ca:	6726                	ld	a4,72(sp)
ffffffffc02076cc:	c119                	beqz	a0,ffffffffc02076d2 <stride_dequeue+0x1e6>
ffffffffc02076ce:	01153023          	sd	a7,0(a0)
ffffffffc02076d2:	01163423          	sd	a7,8(a2)
ffffffffc02076d6:	01e63823          	sd	t5,16(a2)
ffffffffc02076da:	00c8b023          	sd	a2,0(a7)
ffffffffc02076de:	88b2                	mv	a7,a2
ffffffffc02076e0:	b5c1                	j	ffffffffc02075a0 <stride_dequeue+0xb4>
ffffffffc02076e2:	0108b503          	ld	a0,16(a7)
ffffffffc02076e6:	85be                	mv	a1,a5
ffffffffc02076e8:	0088b783          	ld	a5,8(a7)
ffffffffc02076ec:	fc3a                	sd	a4,56(sp)
ffffffffc02076ee:	f836                	sd	a3,48(sp)
ffffffffc02076f0:	f476                	sd	t4,40(sp)
ffffffffc02076f2:	f032                	sd	a2,32(sp)
ffffffffc02076f4:	ec42                	sd	a6,24(sp)
ffffffffc02076f6:	e81a                	sd	t1,16(sp)
ffffffffc02076f8:	e446                	sd	a7,8(sp)
ffffffffc02076fa:	e03e                	sd	a5,0(sp)
ffffffffc02076fc:	c17ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207700:	68a2                	ld	a7,8(sp)
ffffffffc0207702:	6782                	ld	a5,0(sp)
ffffffffc0207704:	6342                	ld	t1,16(sp)
ffffffffc0207706:	00a8b423          	sd	a0,8(a7)
ffffffffc020770a:	00f8b823          	sd	a5,16(a7)
ffffffffc020770e:	6862                	ld	a6,24(sp)
ffffffffc0207710:	7602                	ld	a2,32(sp)
ffffffffc0207712:	7ea2                	ld	t4,40(sp)
ffffffffc0207714:	76c2                	ld	a3,48(sp)
ffffffffc0207716:	7762                	ld	a4,56(sp)
ffffffffc0207718:	c119                	beqz	a0,ffffffffc020771e <stride_dequeue+0x232>
ffffffffc020771a:	01153023          	sd	a7,0(a0)
ffffffffc020771e:	87c6                	mv	a5,a7
ffffffffc0207720:	bf2d                	j	ffffffffc020765a <stride_dequeue+0x16e>
ffffffffc0207722:	010e3503          	ld	a0,16(t3)
ffffffffc0207726:	85c6                	mv	a1,a7
ffffffffc0207728:	008e3883          	ld	a7,8(t3)
ffffffffc020772c:	e472                	sd	t3,8(sp)
ffffffffc020772e:	e046                	sd	a7,0(sp)
ffffffffc0207730:	be3ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207734:	6e22                	ld	t3,8(sp)
ffffffffc0207736:	6882                	ld	a7,0(sp)
ffffffffc0207738:	6342                	ld	t1,16(sp)
ffffffffc020773a:	00ae3423          	sd	a0,8(t3)
ffffffffc020773e:	011e3823          	sd	a7,16(t3)
ffffffffc0207742:	6862                	ld	a6,24(sp)
ffffffffc0207744:	7602                	ld	a2,32(sp)
ffffffffc0207746:	7ea2                	ld	t4,40(sp)
ffffffffc0207748:	7f42                	ld	t5,48(sp)
ffffffffc020774a:	77e2                	ld	a5,56(sp)
ffffffffc020774c:	6686                	ld	a3,64(sp)
ffffffffc020774e:	6726                	ld	a4,72(sp)
ffffffffc0207750:	c119                	beqz	a0,ffffffffc0207756 <stride_dequeue+0x26a>
ffffffffc0207752:	01c53023          	sd	t3,0(a0)
ffffffffc0207756:	88f2                	mv	a7,t3
ffffffffc0207758:	bfad                	j	ffffffffc02076d2 <stride_dequeue+0x1e6>
ffffffffc020775a:	0108b503          	ld	a0,16(a7)
ffffffffc020775e:	85f2                	mv	a1,t3
ffffffffc0207760:	0088be03          	ld	t3,8(a7)
ffffffffc0207764:	e446                	sd	a7,8(sp)
ffffffffc0207766:	e072                	sd	t3,0(sp)
ffffffffc0207768:	babff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc020776c:	68a2                	ld	a7,8(sp)
ffffffffc020776e:	6e02                	ld	t3,0(sp)
ffffffffc0207770:	6342                	ld	t1,16(sp)
ffffffffc0207772:	00a8b423          	sd	a0,8(a7)
ffffffffc0207776:	01c8b823          	sd	t3,16(a7)
ffffffffc020777a:	6862                	ld	a6,24(sp)
ffffffffc020777c:	7602                	ld	a2,32(sp)
ffffffffc020777e:	7ea2                	ld	t4,40(sp)
ffffffffc0207780:	7f42                	ld	t5,48(sp)
ffffffffc0207782:	77e2                	ld	a5,56(sp)
ffffffffc0207784:	6686                	ld	a3,64(sp)
ffffffffc0207786:	6726                	ld	a4,72(sp)
ffffffffc0207788:	ec0503e3          	beqz	a0,ffffffffc020764e <stride_dequeue+0x162>
ffffffffc020778c:	01153023          	sd	a7,0(a0)
ffffffffc0207790:	bd7d                	j	ffffffffc020764e <stride_dequeue+0x162>
ffffffffc0207792:	6a08                	ld	a0,16(a2)
ffffffffc0207794:	85f2                	mv	a1,t3
ffffffffc0207796:	00863e03          	ld	t3,8(a2)
ffffffffc020779a:	e432                	sd	a2,8(sp)
ffffffffc020779c:	e072                	sd	t3,0(sp)
ffffffffc020779e:	b75ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc02077a2:	6622                	ld	a2,8(sp)
ffffffffc02077a4:	6e02                	ld	t3,0(sp)
ffffffffc02077a6:	6342                	ld	t1,16(sp)
ffffffffc02077a8:	e608                	sd	a0,8(a2)
ffffffffc02077aa:	01c63823          	sd	t3,16(a2)
ffffffffc02077ae:	6862                	ld	a6,24(sp)
ffffffffc02077b0:	7e82                	ld	t4,32(sp)
ffffffffc02077b2:	78a2                	ld	a7,40(sp)
ffffffffc02077b4:	7f42                	ld	t5,48(sp)
ffffffffc02077b6:	77e2                	ld	a5,56(sp)
ffffffffc02077b8:	6686                	ld	a3,64(sp)
ffffffffc02077ba:	6726                	ld	a4,72(sp)
ffffffffc02077bc:	dc050ce3          	beqz	a0,ffffffffc0207594 <stride_dequeue+0xa8>
ffffffffc02077c0:	e110                	sd	a2,0(a0)
ffffffffc02077c2:	bbc9                	j	ffffffffc0207594 <stride_dequeue+0xa8>
ffffffffc02077c4:	00007697          	auipc	a3,0x7
ffffffffc02077c8:	8c468693          	addi	a3,a3,-1852 # ffffffffc020e088 <etext+0x2350>
ffffffffc02077cc:	00005617          	auipc	a2,0x5
ffffffffc02077d0:	9a460613          	addi	a2,a2,-1628 # ffffffffc020c170 <etext+0x438>
ffffffffc02077d4:	07800593          	li	a1,120
ffffffffc02077d8:	00007517          	auipc	a0,0x7
ffffffffc02077dc:	8c050513          	addi	a0,a0,-1856 # ffffffffc020e098 <etext+0x2360>
ffffffffc02077e0:	c6bf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02077e4 <stride_enqueue>:
ffffffffc02077e4:	715d                	addi	sp,sp,-80
ffffffffc02077e6:	e486                	sd	ra,72(sp)
ffffffffc02077e8:	c1f1                	beqz	a1,ffffffffc02078ac <stride_enqueue+0xc8>
ffffffffc02077ea:	872a                	mv	a4,a0
ffffffffc02077ec:	c161                	beqz	a0,ffffffffc02078ac <stride_enqueue+0xc8>
ffffffffc02077ee:	6d14                	ld	a3,24(a0)
ffffffffc02077f0:	87ae                	mv	a5,a1
ffffffffc02077f2:	1205b423          	sd	zero,296(a1)
ffffffffc02077f6:	1205bc23          	sd	zero,312(a1)
ffffffffc02077fa:	1205b823          	sd	zero,304(a1)
ffffffffc02077fe:	1407a803          	lw	a6,320(a5)
ffffffffc0207802:	12858593          	addi	a1,a1,296
ffffffffc0207806:	ca89                	beqz	a3,ffffffffc0207818 <stride_enqueue+0x34>
ffffffffc0207808:	4e90                	lw	a2,24(a3)
ffffffffc020780a:	4106063b          	subw	a2,a2,a6
ffffffffc020780e:	04064463          	bltz	a2,ffffffffc0207856 <stride_enqueue+0x72>
ffffffffc0207812:	12d7b823          	sd	a3,304(a5)
ffffffffc0207816:	e28c                	sd	a1,0(a3)
ffffffffc0207818:	86ae                	mv	a3,a1
ffffffffc020781a:	00090617          	auipc	a2,0x90
ffffffffc020781e:	0c663603          	ld	a2,198(a2) # ffffffffc02978e0 <idleproc>
ffffffffc0207822:	ef14                	sd	a3,24(a4)
ffffffffc0207824:	00f60563          	beq	a2,a5,ffffffffc020782e <stride_enqueue+0x4a>
ffffffffc0207828:	4b50                	lw	a2,20(a4)
ffffffffc020782a:	12c7a023          	sw	a2,288(a5)
ffffffffc020782e:	1447a603          	lw	a2,324(a5)
ffffffffc0207832:	e601                	bnez	a2,ffffffffc020783a <stride_enqueue+0x56>
ffffffffc0207834:	4605                	li	a2,1
ffffffffc0207836:	14c7a223          	sw	a2,324(a5)
ffffffffc020783a:	00081563          	bnez	a6,ffffffffc0207844 <stride_enqueue+0x60>
ffffffffc020783e:	4e94                	lw	a3,24(a3)
ffffffffc0207840:	14d7a023          	sw	a3,320(a5)
ffffffffc0207844:	4b14                	lw	a3,16(a4)
ffffffffc0207846:	60a6                	ld	ra,72(sp)
ffffffffc0207848:	10e7b423          	sd	a4,264(a5)
ffffffffc020784c:	0016879b          	addiw	a5,a3,1
ffffffffc0207850:	cb1c                	sw	a5,16(a4)
ffffffffc0207852:	6161                	addi	sp,sp,80
ffffffffc0207854:	8082                	ret
ffffffffc0207856:	6a90                	ld	a2,16(a3)
ffffffffc0207858:	0086b883          	ld	a7,8(a3)
ffffffffc020785c:	ca09                	beqz	a2,ffffffffc020786e <stride_enqueue+0x8a>
ffffffffc020785e:	4e08                	lw	a0,24(a2)
ffffffffc0207860:	4105053b          	subw	a0,a0,a6
ffffffffc0207864:	00054b63          	bltz	a0,ffffffffc020787a <stride_enqueue+0x96>
ffffffffc0207868:	12c7b823          	sd	a2,304(a5)
ffffffffc020786c:	e20c                	sd	a1,0(a2)
ffffffffc020786e:	862e                	mv	a2,a1
ffffffffc0207870:	e690                	sd	a2,8(a3)
ffffffffc0207872:	0116b823          	sd	a7,16(a3)
ffffffffc0207876:	e214                	sd	a3,0(a2)
ffffffffc0207878:	b74d                	j	ffffffffc020781a <stride_enqueue+0x36>
ffffffffc020787a:	00863303          	ld	t1,8(a2)
ffffffffc020787e:	6a08                	ld	a0,16(a2)
ffffffffc0207880:	fc3e                	sd	a5,56(sp)
ffffffffc0207882:	f83a                	sd	a4,48(sp)
ffffffffc0207884:	f442                	sd	a6,40(sp)
ffffffffc0207886:	f046                	sd	a7,32(sp)
ffffffffc0207888:	ec36                	sd	a3,24(sp)
ffffffffc020788a:	e832                	sd	a2,16(sp)
ffffffffc020788c:	e41a                	sd	t1,8(sp)
ffffffffc020788e:	a85ff0ef          	jal	ffffffffc0207312 <skew_heap_merge.constprop.0>
ffffffffc0207892:	6642                	ld	a2,16(sp)
ffffffffc0207894:	6322                	ld	t1,8(sp)
ffffffffc0207896:	66e2                	ld	a3,24(sp)
ffffffffc0207898:	e608                	sd	a0,8(a2)
ffffffffc020789a:	00663823          	sd	t1,16(a2)
ffffffffc020789e:	7882                	ld	a7,32(sp)
ffffffffc02078a0:	7822                	ld	a6,40(sp)
ffffffffc02078a2:	7742                	ld	a4,48(sp)
ffffffffc02078a4:	77e2                	ld	a5,56(sp)
ffffffffc02078a6:	d569                	beqz	a0,ffffffffc0207870 <stride_enqueue+0x8c>
ffffffffc02078a8:	e110                	sd	a2,0(a0)
ffffffffc02078aa:	b7d9                	j	ffffffffc0207870 <stride_enqueue+0x8c>
ffffffffc02078ac:	00006697          	auipc	a3,0x6
ffffffffc02078b0:	7dc68693          	addi	a3,a3,2012 # ffffffffc020e088 <etext+0x2350>
ffffffffc02078b4:	00005617          	auipc	a2,0x5
ffffffffc02078b8:	8bc60613          	addi	a2,a2,-1860 # ffffffffc020c170 <etext+0x438>
ffffffffc02078bc:	05100593          	li	a1,81
ffffffffc02078c0:	00006517          	auipc	a0,0x6
ffffffffc02078c4:	7d850513          	addi	a0,a0,2008 # ffffffffc020e098 <etext+0x2360>
ffffffffc02078c8:	b83f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02078cc <sched_init>:
ffffffffc02078cc:	0008a797          	auipc	a5,0x8a
ffffffffc02078d0:	75478793          	addi	a5,a5,1876 # ffffffffc0292020 <stride_sched_class>
ffffffffc02078d4:	1141                	addi	sp,sp,-16
ffffffffc02078d6:	6794                	ld	a3,8(a5)
ffffffffc02078d8:	00090717          	auipc	a4,0x90
ffffffffc02078dc:	00f73c23          	sd	a5,24(a4) # ffffffffc02978f0 <sched_class>
ffffffffc02078e0:	e406                	sd	ra,8(sp)
ffffffffc02078e2:	0008f797          	auipc	a5,0x8f
ffffffffc02078e6:	f0e78793          	addi	a5,a5,-242 # ffffffffc02967f0 <timer_list>
ffffffffc02078ea:	0008f717          	auipc	a4,0x8f
ffffffffc02078ee:	ee670713          	addi	a4,a4,-282 # ffffffffc02967d0 <__rq>
ffffffffc02078f2:	4615                	li	a2,5
ffffffffc02078f4:	e79c                	sd	a5,8(a5)
ffffffffc02078f6:	e39c                	sd	a5,0(a5)
ffffffffc02078f8:	853a                	mv	a0,a4
ffffffffc02078fa:	cb50                	sw	a2,20(a4)
ffffffffc02078fc:	00090797          	auipc	a5,0x90
ffffffffc0207900:	fee7b623          	sd	a4,-20(a5) # ffffffffc02978e8 <rq>
ffffffffc0207904:	9682                	jalr	a3
ffffffffc0207906:	00090797          	auipc	a5,0x90
ffffffffc020790a:	fea7b783          	ld	a5,-22(a5) # ffffffffc02978f0 <sched_class>
ffffffffc020790e:	60a2                	ld	ra,8(sp)
ffffffffc0207910:	00006517          	auipc	a0,0x6
ffffffffc0207914:	7c850513          	addi	a0,a0,1992 # ffffffffc020e0d8 <etext+0x23a0>
ffffffffc0207918:	638c                	ld	a1,0(a5)
ffffffffc020791a:	0141                	addi	sp,sp,16
ffffffffc020791c:	88bf806f          	j	ffffffffc02001a6 <cprintf>

ffffffffc0207920 <wakeup_proc>:
ffffffffc0207920:	4118                	lw	a4,0(a0)
ffffffffc0207922:	1101                	addi	sp,sp,-32
ffffffffc0207924:	ec06                	sd	ra,24(sp)
ffffffffc0207926:	478d                	li	a5,3
ffffffffc0207928:	0cf70863          	beq	a4,a5,ffffffffc02079f8 <wakeup_proc+0xd8>
ffffffffc020792c:	85aa                	mv	a1,a0
ffffffffc020792e:	100027f3          	csrr	a5,sstatus
ffffffffc0207932:	8b89                	andi	a5,a5,2
ffffffffc0207934:	e3b1                	bnez	a5,ffffffffc0207978 <wakeup_proc+0x58>
ffffffffc0207936:	4789                	li	a5,2
ffffffffc0207938:	08f70563          	beq	a4,a5,ffffffffc02079c2 <wakeup_proc+0xa2>
ffffffffc020793c:	00090717          	auipc	a4,0x90
ffffffffc0207940:	f9473703          	ld	a4,-108(a4) # ffffffffc02978d0 <current>
ffffffffc0207944:	0e052623          	sw	zero,236(a0)
ffffffffc0207948:	c11c                	sw	a5,0(a0)
ffffffffc020794a:	02e50463          	beq	a0,a4,ffffffffc0207972 <wakeup_proc+0x52>
ffffffffc020794e:	00090797          	auipc	a5,0x90
ffffffffc0207952:	f927b783          	ld	a5,-110(a5) # ffffffffc02978e0 <idleproc>
ffffffffc0207956:	00f50e63          	beq	a0,a5,ffffffffc0207972 <wakeup_proc+0x52>
ffffffffc020795a:	00090797          	auipc	a5,0x90
ffffffffc020795e:	f967b783          	ld	a5,-106(a5) # ffffffffc02978f0 <sched_class>
ffffffffc0207962:	60e2                	ld	ra,24(sp)
ffffffffc0207964:	00090517          	auipc	a0,0x90
ffffffffc0207968:	f8453503          	ld	a0,-124(a0) # ffffffffc02978e8 <rq>
ffffffffc020796c:	6b9c                	ld	a5,16(a5)
ffffffffc020796e:	6105                	addi	sp,sp,32
ffffffffc0207970:	8782                	jr	a5
ffffffffc0207972:	60e2                	ld	ra,24(sp)
ffffffffc0207974:	6105                	addi	sp,sp,32
ffffffffc0207976:	8082                	ret
ffffffffc0207978:	e42a                	sd	a0,8(sp)
ffffffffc020797a:	af6f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020797e:	65a2                	ld	a1,8(sp)
ffffffffc0207980:	4789                	li	a5,2
ffffffffc0207982:	4198                	lw	a4,0(a1)
ffffffffc0207984:	04f70d63          	beq	a4,a5,ffffffffc02079de <wakeup_proc+0xbe>
ffffffffc0207988:	00090717          	auipc	a4,0x90
ffffffffc020798c:	f4873703          	ld	a4,-184(a4) # ffffffffc02978d0 <current>
ffffffffc0207990:	0e05a623          	sw	zero,236(a1)
ffffffffc0207994:	c19c                	sw	a5,0(a1)
ffffffffc0207996:	02e58263          	beq	a1,a4,ffffffffc02079ba <wakeup_proc+0x9a>
ffffffffc020799a:	00090797          	auipc	a5,0x90
ffffffffc020799e:	f467b783          	ld	a5,-186(a5) # ffffffffc02978e0 <idleproc>
ffffffffc02079a2:	00f58c63          	beq	a1,a5,ffffffffc02079ba <wakeup_proc+0x9a>
ffffffffc02079a6:	00090797          	auipc	a5,0x90
ffffffffc02079aa:	f4a7b783          	ld	a5,-182(a5) # ffffffffc02978f0 <sched_class>
ffffffffc02079ae:	00090517          	auipc	a0,0x90
ffffffffc02079b2:	f3a53503          	ld	a0,-198(a0) # ffffffffc02978e8 <rq>
ffffffffc02079b6:	6b9c                	ld	a5,16(a5)
ffffffffc02079b8:	9782                	jalr	a5
ffffffffc02079ba:	60e2                	ld	ra,24(sp)
ffffffffc02079bc:	6105                	addi	sp,sp,32
ffffffffc02079be:	aacf906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc02079c2:	60e2                	ld	ra,24(sp)
ffffffffc02079c4:	00006617          	auipc	a2,0x6
ffffffffc02079c8:	76460613          	addi	a2,a2,1892 # ffffffffc020e128 <etext+0x23f0>
ffffffffc02079cc:	05200593          	li	a1,82
ffffffffc02079d0:	00006517          	auipc	a0,0x6
ffffffffc02079d4:	74050513          	addi	a0,a0,1856 # ffffffffc020e110 <etext+0x23d8>
ffffffffc02079d8:	6105                	addi	sp,sp,32
ffffffffc02079da:	adbf806f          	j	ffffffffc02004b4 <__warn>
ffffffffc02079de:	00006617          	auipc	a2,0x6
ffffffffc02079e2:	74a60613          	addi	a2,a2,1866 # ffffffffc020e128 <etext+0x23f0>
ffffffffc02079e6:	05200593          	li	a1,82
ffffffffc02079ea:	00006517          	auipc	a0,0x6
ffffffffc02079ee:	72650513          	addi	a0,a0,1830 # ffffffffc020e110 <etext+0x23d8>
ffffffffc02079f2:	ac3f80ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc02079f6:	b7d1                	j	ffffffffc02079ba <wakeup_proc+0x9a>
ffffffffc02079f8:	00006697          	auipc	a3,0x6
ffffffffc02079fc:	6f868693          	addi	a3,a3,1784 # ffffffffc020e0f0 <etext+0x23b8>
ffffffffc0207a00:	00004617          	auipc	a2,0x4
ffffffffc0207a04:	77060613          	addi	a2,a2,1904 # ffffffffc020c170 <etext+0x438>
ffffffffc0207a08:	04300593          	li	a1,67
ffffffffc0207a0c:	00006517          	auipc	a0,0x6
ffffffffc0207a10:	70450513          	addi	a0,a0,1796 # ffffffffc020e110 <etext+0x23d8>
ffffffffc0207a14:	a37f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207a18 <schedule>:
ffffffffc0207a18:	7139                	addi	sp,sp,-64
ffffffffc0207a1a:	fc06                	sd	ra,56(sp)
ffffffffc0207a1c:	f822                	sd	s0,48(sp)
ffffffffc0207a1e:	f426                	sd	s1,40(sp)
ffffffffc0207a20:	f04a                	sd	s2,32(sp)
ffffffffc0207a22:	ec4e                	sd	s3,24(sp)
ffffffffc0207a24:	100027f3          	csrr	a5,sstatus
ffffffffc0207a28:	8b89                	andi	a5,a5,2
ffffffffc0207a2a:	4981                	li	s3,0
ffffffffc0207a2c:	efc9                	bnez	a5,ffffffffc0207ac6 <schedule+0xae>
ffffffffc0207a2e:	00090417          	auipc	s0,0x90
ffffffffc0207a32:	ea240413          	addi	s0,s0,-350 # ffffffffc02978d0 <current>
ffffffffc0207a36:	600c                	ld	a1,0(s0)
ffffffffc0207a38:	4789                	li	a5,2
ffffffffc0207a3a:	00090497          	auipc	s1,0x90
ffffffffc0207a3e:	eae48493          	addi	s1,s1,-338 # ffffffffc02978e8 <rq>
ffffffffc0207a42:	4198                	lw	a4,0(a1)
ffffffffc0207a44:	0005bc23          	sd	zero,24(a1)
ffffffffc0207a48:	00090917          	auipc	s2,0x90
ffffffffc0207a4c:	ea890913          	addi	s2,s2,-344 # ffffffffc02978f0 <sched_class>
ffffffffc0207a50:	04f70f63          	beq	a4,a5,ffffffffc0207aae <schedule+0x96>
ffffffffc0207a54:	00093783          	ld	a5,0(s2)
ffffffffc0207a58:	6088                	ld	a0,0(s1)
ffffffffc0207a5a:	739c                	ld	a5,32(a5)
ffffffffc0207a5c:	9782                	jalr	a5
ffffffffc0207a5e:	85aa                	mv	a1,a0
ffffffffc0207a60:	c131                	beqz	a0,ffffffffc0207aa4 <schedule+0x8c>
ffffffffc0207a62:	00093783          	ld	a5,0(s2)
ffffffffc0207a66:	6088                	ld	a0,0(s1)
ffffffffc0207a68:	e42e                	sd	a1,8(sp)
ffffffffc0207a6a:	6f9c                	ld	a5,24(a5)
ffffffffc0207a6c:	9782                	jalr	a5
ffffffffc0207a6e:	65a2                	ld	a1,8(sp)
ffffffffc0207a70:	459c                	lw	a5,8(a1)
ffffffffc0207a72:	6018                	ld	a4,0(s0)
ffffffffc0207a74:	2785                	addiw	a5,a5,1
ffffffffc0207a76:	c59c                	sw	a5,8(a1)
ffffffffc0207a78:	00b70563          	beq	a4,a1,ffffffffc0207a82 <schedule+0x6a>
ffffffffc0207a7c:	852e                	mv	a0,a1
ffffffffc0207a7e:	a0afe0ef          	jal	ffffffffc0205c88 <proc_run>
ffffffffc0207a82:	00099963          	bnez	s3,ffffffffc0207a94 <schedule+0x7c>
ffffffffc0207a86:	70e2                	ld	ra,56(sp)
ffffffffc0207a88:	7442                	ld	s0,48(sp)
ffffffffc0207a8a:	74a2                	ld	s1,40(sp)
ffffffffc0207a8c:	7902                	ld	s2,32(sp)
ffffffffc0207a8e:	69e2                	ld	s3,24(sp)
ffffffffc0207a90:	6121                	addi	sp,sp,64
ffffffffc0207a92:	8082                	ret
ffffffffc0207a94:	7442                	ld	s0,48(sp)
ffffffffc0207a96:	70e2                	ld	ra,56(sp)
ffffffffc0207a98:	74a2                	ld	s1,40(sp)
ffffffffc0207a9a:	7902                	ld	s2,32(sp)
ffffffffc0207a9c:	69e2                	ld	s3,24(sp)
ffffffffc0207a9e:	6121                	addi	sp,sp,64
ffffffffc0207aa0:	9caf906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207aa4:	00090597          	auipc	a1,0x90
ffffffffc0207aa8:	e3c5b583          	ld	a1,-452(a1) # ffffffffc02978e0 <idleproc>
ffffffffc0207aac:	b7d1                	j	ffffffffc0207a70 <schedule+0x58>
ffffffffc0207aae:	00090797          	auipc	a5,0x90
ffffffffc0207ab2:	e327b783          	ld	a5,-462(a5) # ffffffffc02978e0 <idleproc>
ffffffffc0207ab6:	f8f58fe3          	beq	a1,a5,ffffffffc0207a54 <schedule+0x3c>
ffffffffc0207aba:	00093783          	ld	a5,0(s2)
ffffffffc0207abe:	6088                	ld	a0,0(s1)
ffffffffc0207ac0:	6b9c                	ld	a5,16(a5)
ffffffffc0207ac2:	9782                	jalr	a5
ffffffffc0207ac4:	bf41                	j	ffffffffc0207a54 <schedule+0x3c>
ffffffffc0207ac6:	9aaf90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207aca:	4985                	li	s3,1
ffffffffc0207acc:	b78d                	j	ffffffffc0207a2e <schedule+0x16>

ffffffffc0207ace <add_timer>:
ffffffffc0207ace:	1101                	addi	sp,sp,-32
ffffffffc0207ad0:	ec06                	sd	ra,24(sp)
ffffffffc0207ad2:	100027f3          	csrr	a5,sstatus
ffffffffc0207ad6:	8b89                	andi	a5,a5,2
ffffffffc0207ad8:	4801                	li	a6,0
ffffffffc0207ada:	e7bd                	bnez	a5,ffffffffc0207b48 <add_timer+0x7a>
ffffffffc0207adc:	4118                	lw	a4,0(a0)
ffffffffc0207ade:	cb3d                	beqz	a4,ffffffffc0207b54 <add_timer+0x86>
ffffffffc0207ae0:	651c                	ld	a5,8(a0)
ffffffffc0207ae2:	cbad                	beqz	a5,ffffffffc0207b54 <add_timer+0x86>
ffffffffc0207ae4:	6d1c                	ld	a5,24(a0)
ffffffffc0207ae6:	01050593          	addi	a1,a0,16
ffffffffc0207aea:	08f59563          	bne	a1,a5,ffffffffc0207b74 <add_timer+0xa6>
ffffffffc0207aee:	0008f617          	auipc	a2,0x8f
ffffffffc0207af2:	d0260613          	addi	a2,a2,-766 # ffffffffc02967f0 <timer_list>
ffffffffc0207af6:	661c                	ld	a5,8(a2)
ffffffffc0207af8:	00c79863          	bne	a5,a2,ffffffffc0207b08 <add_timer+0x3a>
ffffffffc0207afc:	a805                	j	ffffffffc0207b2c <add_timer+0x5e>
ffffffffc0207afe:	679c                	ld	a5,8(a5)
ffffffffc0207b00:	9f15                	subw	a4,a4,a3
ffffffffc0207b02:	c118                	sw	a4,0(a0)
ffffffffc0207b04:	02c78463          	beq	a5,a2,ffffffffc0207b2c <add_timer+0x5e>
ffffffffc0207b08:	ff07a683          	lw	a3,-16(a5)
ffffffffc0207b0c:	fed779e3          	bgeu	a4,a3,ffffffffc0207afe <add_timer+0x30>
ffffffffc0207b10:	9e99                	subw	a3,a3,a4
ffffffffc0207b12:	6398                	ld	a4,0(a5)
ffffffffc0207b14:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207b18:	e38c                	sd	a1,0(a5)
ffffffffc0207b1a:	e70c                	sd	a1,8(a4)
ffffffffc0207b1c:	e918                	sd	a4,16(a0)
ffffffffc0207b1e:	ed1c                	sd	a5,24(a0)
ffffffffc0207b20:	02080163          	beqz	a6,ffffffffc0207b42 <add_timer+0x74>
ffffffffc0207b24:	60e2                	ld	ra,24(sp)
ffffffffc0207b26:	6105                	addi	sp,sp,32
ffffffffc0207b28:	942f906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207b2c:	0008f797          	auipc	a5,0x8f
ffffffffc0207b30:	cc478793          	addi	a5,a5,-828 # ffffffffc02967f0 <timer_list>
ffffffffc0207b34:	6398                	ld	a4,0(a5)
ffffffffc0207b36:	e38c                	sd	a1,0(a5)
ffffffffc0207b38:	e70c                	sd	a1,8(a4)
ffffffffc0207b3a:	e918                	sd	a4,16(a0)
ffffffffc0207b3c:	ed1c                	sd	a5,24(a0)
ffffffffc0207b3e:	fe0813e3          	bnez	a6,ffffffffc0207b24 <add_timer+0x56>
ffffffffc0207b42:	60e2                	ld	ra,24(sp)
ffffffffc0207b44:	6105                	addi	sp,sp,32
ffffffffc0207b46:	8082                	ret
ffffffffc0207b48:	e42a                	sd	a0,8(sp)
ffffffffc0207b4a:	926f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207b4e:	6522                	ld	a0,8(sp)
ffffffffc0207b50:	4805                	li	a6,1
ffffffffc0207b52:	b769                	j	ffffffffc0207adc <add_timer+0xe>
ffffffffc0207b54:	00006697          	auipc	a3,0x6
ffffffffc0207b58:	5f468693          	addi	a3,a3,1524 # ffffffffc020e148 <etext+0x2410>
ffffffffc0207b5c:	00004617          	auipc	a2,0x4
ffffffffc0207b60:	61460613          	addi	a2,a2,1556 # ffffffffc020c170 <etext+0x438>
ffffffffc0207b64:	07a00593          	li	a1,122
ffffffffc0207b68:	00006517          	auipc	a0,0x6
ffffffffc0207b6c:	5a850513          	addi	a0,a0,1448 # ffffffffc020e110 <etext+0x23d8>
ffffffffc0207b70:	8dbf80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207b74:	00006697          	auipc	a3,0x6
ffffffffc0207b78:	60468693          	addi	a3,a3,1540 # ffffffffc020e178 <etext+0x2440>
ffffffffc0207b7c:	00004617          	auipc	a2,0x4
ffffffffc0207b80:	5f460613          	addi	a2,a2,1524 # ffffffffc020c170 <etext+0x438>
ffffffffc0207b84:	07b00593          	li	a1,123
ffffffffc0207b88:	00006517          	auipc	a0,0x6
ffffffffc0207b8c:	58850513          	addi	a0,a0,1416 # ffffffffc020e110 <etext+0x23d8>
ffffffffc0207b90:	8bbf80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207b94 <del_timer>:
ffffffffc0207b94:	100027f3          	csrr	a5,sstatus
ffffffffc0207b98:	8b89                	andi	a5,a5,2
ffffffffc0207b9a:	ef95                	bnez	a5,ffffffffc0207bd6 <del_timer+0x42>
ffffffffc0207b9c:	6d1c                	ld	a5,24(a0)
ffffffffc0207b9e:	01050713          	addi	a4,a0,16
ffffffffc0207ba2:	4601                	li	a2,0
ffffffffc0207ba4:	02f70863          	beq	a4,a5,ffffffffc0207bd4 <del_timer+0x40>
ffffffffc0207ba8:	0008f597          	auipc	a1,0x8f
ffffffffc0207bac:	c4858593          	addi	a1,a1,-952 # ffffffffc02967f0 <timer_list>
ffffffffc0207bb0:	4114                	lw	a3,0(a0)
ffffffffc0207bb2:	00b78863          	beq	a5,a1,ffffffffc0207bc2 <del_timer+0x2e>
ffffffffc0207bb6:	c691                	beqz	a3,ffffffffc0207bc2 <del_timer+0x2e>
ffffffffc0207bb8:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207bbc:	9ead                	addw	a3,a3,a1
ffffffffc0207bbe:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207bc2:	6914                	ld	a3,16(a0)
ffffffffc0207bc4:	e69c                	sd	a5,8(a3)
ffffffffc0207bc6:	e394                	sd	a3,0(a5)
ffffffffc0207bc8:	ed18                	sd	a4,24(a0)
ffffffffc0207bca:	e918                	sd	a4,16(a0)
ffffffffc0207bcc:	e211                	bnez	a2,ffffffffc0207bd0 <del_timer+0x3c>
ffffffffc0207bce:	8082                	ret
ffffffffc0207bd0:	89af906f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207bd4:	8082                	ret
ffffffffc0207bd6:	1101                	addi	sp,sp,-32
ffffffffc0207bd8:	e42a                	sd	a0,8(sp)
ffffffffc0207bda:	ec06                	sd	ra,24(sp)
ffffffffc0207bdc:	894f90ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207be0:	6522                	ld	a0,8(sp)
ffffffffc0207be2:	4605                	li	a2,1
ffffffffc0207be4:	6d1c                	ld	a5,24(a0)
ffffffffc0207be6:	01050713          	addi	a4,a0,16
ffffffffc0207bea:	02f70863          	beq	a4,a5,ffffffffc0207c1a <del_timer+0x86>
ffffffffc0207bee:	0008f597          	auipc	a1,0x8f
ffffffffc0207bf2:	c0258593          	addi	a1,a1,-1022 # ffffffffc02967f0 <timer_list>
ffffffffc0207bf6:	4114                	lw	a3,0(a0)
ffffffffc0207bf8:	00b78863          	beq	a5,a1,ffffffffc0207c08 <del_timer+0x74>
ffffffffc0207bfc:	c691                	beqz	a3,ffffffffc0207c08 <del_timer+0x74>
ffffffffc0207bfe:	ff07a583          	lw	a1,-16(a5)
ffffffffc0207c02:	9ead                	addw	a3,a3,a1
ffffffffc0207c04:	fed7a823          	sw	a3,-16(a5)
ffffffffc0207c08:	6914                	ld	a3,16(a0)
ffffffffc0207c0a:	e69c                	sd	a5,8(a3)
ffffffffc0207c0c:	e394                	sd	a3,0(a5)
ffffffffc0207c0e:	ed18                	sd	a4,24(a0)
ffffffffc0207c10:	e918                	sd	a4,16(a0)
ffffffffc0207c12:	e601                	bnez	a2,ffffffffc0207c1a <del_timer+0x86>
ffffffffc0207c14:	60e2                	ld	ra,24(sp)
ffffffffc0207c16:	6105                	addi	sp,sp,32
ffffffffc0207c18:	8082                	ret
ffffffffc0207c1a:	60e2                	ld	ra,24(sp)
ffffffffc0207c1c:	6105                	addi	sp,sp,32
ffffffffc0207c1e:	84cf906f          	j	ffffffffc0200c6a <intr_enable>

ffffffffc0207c22 <run_timer_list>:
ffffffffc0207c22:	7179                	addi	sp,sp,-48
ffffffffc0207c24:	f406                	sd	ra,40(sp)
ffffffffc0207c26:	f022                	sd	s0,32(sp)
ffffffffc0207c28:	e44e                	sd	s3,8(sp)
ffffffffc0207c2a:	e052                	sd	s4,0(sp)
ffffffffc0207c2c:	100027f3          	csrr	a5,sstatus
ffffffffc0207c30:	8b89                	andi	a5,a5,2
ffffffffc0207c32:	0e079b63          	bnez	a5,ffffffffc0207d28 <run_timer_list+0x106>
ffffffffc0207c36:	0008f997          	auipc	s3,0x8f
ffffffffc0207c3a:	bba98993          	addi	s3,s3,-1094 # ffffffffc02967f0 <timer_list>
ffffffffc0207c3e:	0089b403          	ld	s0,8(s3)
ffffffffc0207c42:	4a01                	li	s4,0
ffffffffc0207c44:	0d340463          	beq	s0,s3,ffffffffc0207d0c <run_timer_list+0xea>
ffffffffc0207c48:	ff042783          	lw	a5,-16(s0)
ffffffffc0207c4c:	12078763          	beqz	a5,ffffffffc0207d7a <run_timer_list+0x158>
ffffffffc0207c50:	e84a                	sd	s2,16(sp)
ffffffffc0207c52:	37fd                	addiw	a5,a5,-1
ffffffffc0207c54:	fef42823          	sw	a5,-16(s0)
ffffffffc0207c58:	ff040913          	addi	s2,s0,-16
ffffffffc0207c5c:	efb1                	bnez	a5,ffffffffc0207cb8 <run_timer_list+0x96>
ffffffffc0207c5e:	ec26                	sd	s1,24(sp)
ffffffffc0207c60:	a005                	j	ffffffffc0207c80 <run_timer_list+0x5e>
ffffffffc0207c62:	0e07dc63          	bgez	a5,ffffffffc0207d5a <run_timer_list+0x138>
ffffffffc0207c66:	8526                	mv	a0,s1
ffffffffc0207c68:	cb9ff0ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc0207c6c:	854a                	mv	a0,s2
ffffffffc0207c6e:	f27ff0ef          	jal	ffffffffc0207b94 <del_timer>
ffffffffc0207c72:	05340263          	beq	s0,s3,ffffffffc0207cb6 <run_timer_list+0x94>
ffffffffc0207c76:	ff042783          	lw	a5,-16(s0)
ffffffffc0207c7a:	ff040913          	addi	s2,s0,-16
ffffffffc0207c7e:	ef85                	bnez	a5,ffffffffc0207cb6 <run_timer_list+0x94>
ffffffffc0207c80:	00893483          	ld	s1,8(s2)
ffffffffc0207c84:	6400                	ld	s0,8(s0)
ffffffffc0207c86:	0ec4a783          	lw	a5,236(s1)
ffffffffc0207c8a:	ffe1                	bnez	a5,ffffffffc0207c62 <run_timer_list+0x40>
ffffffffc0207c8c:	40d4                	lw	a3,4(s1)
ffffffffc0207c8e:	00006617          	auipc	a2,0x6
ffffffffc0207c92:	55260613          	addi	a2,a2,1362 # ffffffffc020e1e0 <etext+0x24a8>
ffffffffc0207c96:	0ba00593          	li	a1,186
ffffffffc0207c9a:	00006517          	auipc	a0,0x6
ffffffffc0207c9e:	47650513          	addi	a0,a0,1142 # ffffffffc020e110 <etext+0x23d8>
ffffffffc0207ca2:	813f80ef          	jal	ffffffffc02004b4 <__warn>
ffffffffc0207ca6:	8526                	mv	a0,s1
ffffffffc0207ca8:	c79ff0ef          	jal	ffffffffc0207920 <wakeup_proc>
ffffffffc0207cac:	854a                	mv	a0,s2
ffffffffc0207cae:	ee7ff0ef          	jal	ffffffffc0207b94 <del_timer>
ffffffffc0207cb2:	fd3412e3          	bne	s0,s3,ffffffffc0207c76 <run_timer_list+0x54>
ffffffffc0207cb6:	64e2                	ld	s1,24(sp)
ffffffffc0207cb8:	00090597          	auipc	a1,0x90
ffffffffc0207cbc:	c185b583          	ld	a1,-1000(a1) # ffffffffc02978d0 <current>
ffffffffc0207cc0:	cd85                	beqz	a1,ffffffffc0207cf8 <run_timer_list+0xd6>
ffffffffc0207cc2:	00090797          	auipc	a5,0x90
ffffffffc0207cc6:	c1e7b783          	ld	a5,-994(a5) # ffffffffc02978e0 <idleproc>
ffffffffc0207cca:	02f58563          	beq	a1,a5,ffffffffc0207cf4 <run_timer_list+0xd2>
ffffffffc0207cce:	6942                	ld	s2,16(sp)
ffffffffc0207cd0:	00090797          	auipc	a5,0x90
ffffffffc0207cd4:	c207b783          	ld	a5,-992(a5) # ffffffffc02978f0 <sched_class>
ffffffffc0207cd8:	00090517          	auipc	a0,0x90
ffffffffc0207cdc:	c1053503          	ld	a0,-1008(a0) # ffffffffc02978e8 <rq>
ffffffffc0207ce0:	779c                	ld	a5,40(a5)
ffffffffc0207ce2:	9782                	jalr	a5
ffffffffc0207ce4:	000a1d63          	bnez	s4,ffffffffc0207cfe <run_timer_list+0xdc>
ffffffffc0207ce8:	70a2                	ld	ra,40(sp)
ffffffffc0207cea:	7402                	ld	s0,32(sp)
ffffffffc0207cec:	69a2                	ld	s3,8(sp)
ffffffffc0207cee:	6a02                	ld	s4,0(sp)
ffffffffc0207cf0:	6145                	addi	sp,sp,48
ffffffffc0207cf2:	8082                	ret
ffffffffc0207cf4:	4785                	li	a5,1
ffffffffc0207cf6:	ed9c                	sd	a5,24(a1)
ffffffffc0207cf8:	6942                	ld	s2,16(sp)
ffffffffc0207cfa:	fe0a07e3          	beqz	s4,ffffffffc0207ce8 <run_timer_list+0xc6>
ffffffffc0207cfe:	7402                	ld	s0,32(sp)
ffffffffc0207d00:	70a2                	ld	ra,40(sp)
ffffffffc0207d02:	69a2                	ld	s3,8(sp)
ffffffffc0207d04:	6a02                	ld	s4,0(sp)
ffffffffc0207d06:	6145                	addi	sp,sp,48
ffffffffc0207d08:	f63f806f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc0207d0c:	00090597          	auipc	a1,0x90
ffffffffc0207d10:	bc45b583          	ld	a1,-1084(a1) # ffffffffc02978d0 <current>
ffffffffc0207d14:	d9f1                	beqz	a1,ffffffffc0207ce8 <run_timer_list+0xc6>
ffffffffc0207d16:	00090797          	auipc	a5,0x90
ffffffffc0207d1a:	bca7b783          	ld	a5,-1078(a5) # ffffffffc02978e0 <idleproc>
ffffffffc0207d1e:	fab799e3          	bne	a5,a1,ffffffffc0207cd0 <run_timer_list+0xae>
ffffffffc0207d22:	4705                	li	a4,1
ffffffffc0207d24:	ef98                	sd	a4,24(a5)
ffffffffc0207d26:	b7c9                	j	ffffffffc0207ce8 <run_timer_list+0xc6>
ffffffffc0207d28:	0008f997          	auipc	s3,0x8f
ffffffffc0207d2c:	ac898993          	addi	s3,s3,-1336 # ffffffffc02967f0 <timer_list>
ffffffffc0207d30:	f41f80ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0207d34:	0089b403          	ld	s0,8(s3)
ffffffffc0207d38:	4a05                	li	s4,1
ffffffffc0207d3a:	f13417e3          	bne	s0,s3,ffffffffc0207c48 <run_timer_list+0x26>
ffffffffc0207d3e:	00090597          	auipc	a1,0x90
ffffffffc0207d42:	b925b583          	ld	a1,-1134(a1) # ffffffffc02978d0 <current>
ffffffffc0207d46:	ddc5                	beqz	a1,ffffffffc0207cfe <run_timer_list+0xdc>
ffffffffc0207d48:	00090797          	auipc	a5,0x90
ffffffffc0207d4c:	b987b783          	ld	a5,-1128(a5) # ffffffffc02978e0 <idleproc>
ffffffffc0207d50:	f8f590e3          	bne	a1,a5,ffffffffc0207cd0 <run_timer_list+0xae>
ffffffffc0207d54:	0145bc23          	sd	s4,24(a1)
ffffffffc0207d58:	b75d                	j	ffffffffc0207cfe <run_timer_list+0xdc>
ffffffffc0207d5a:	00006697          	auipc	a3,0x6
ffffffffc0207d5e:	45e68693          	addi	a3,a3,1118 # ffffffffc020e1b8 <etext+0x2480>
ffffffffc0207d62:	00004617          	auipc	a2,0x4
ffffffffc0207d66:	40e60613          	addi	a2,a2,1038 # ffffffffc020c170 <etext+0x438>
ffffffffc0207d6a:	0b600593          	li	a1,182
ffffffffc0207d6e:	00006517          	auipc	a0,0x6
ffffffffc0207d72:	3a250513          	addi	a0,a0,930 # ffffffffc020e110 <etext+0x23d8>
ffffffffc0207d76:	ed4f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207d7a:	00006697          	auipc	a3,0x6
ffffffffc0207d7e:	42668693          	addi	a3,a3,1062 # ffffffffc020e1a0 <etext+0x2468>
ffffffffc0207d82:	00004617          	auipc	a2,0x4
ffffffffc0207d86:	3ee60613          	addi	a2,a2,1006 # ffffffffc020c170 <etext+0x438>
ffffffffc0207d8a:	0ae00593          	li	a1,174
ffffffffc0207d8e:	00006517          	auipc	a0,0x6
ffffffffc0207d92:	38250513          	addi	a0,a0,898 # ffffffffc020e110 <etext+0x23d8>
ffffffffc0207d96:	ec26                	sd	s1,24(sp)
ffffffffc0207d98:	e84a                	sd	s2,16(sp)
ffffffffc0207d9a:	eb0f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207d9e <sys_getpid>:
ffffffffc0207d9e:	00090797          	auipc	a5,0x90
ffffffffc0207da2:	b327b783          	ld	a5,-1230(a5) # ffffffffc02978d0 <current>
ffffffffc0207da6:	43c8                	lw	a0,4(a5)
ffffffffc0207da8:	8082                	ret

ffffffffc0207daa <sys_pgdir>:
ffffffffc0207daa:	4501                	li	a0,0
ffffffffc0207dac:	8082                	ret

ffffffffc0207dae <sys_gettime>:
ffffffffc0207dae:	00090797          	auipc	a5,0x90
ffffffffc0207db2:	ac27b783          	ld	a5,-1342(a5) # ffffffffc0297870 <ticks>
ffffffffc0207db6:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207dba:	9d3d                	addw	a0,a0,a5
ffffffffc0207dbc:	0015151b          	slliw	a0,a0,0x1
ffffffffc0207dc0:	8082                	ret

ffffffffc0207dc2 <sys_lab6_set_priority>:
ffffffffc0207dc2:	4108                	lw	a0,0(a0)
ffffffffc0207dc4:	1141                	addi	sp,sp,-16
ffffffffc0207dc6:	e406                	sd	ra,8(sp)
ffffffffc0207dc8:	bbcff0ef          	jal	ffffffffc0207184 <lab6_set_priority>
ffffffffc0207dcc:	60a2                	ld	ra,8(sp)
ffffffffc0207dce:	4501                	li	a0,0
ffffffffc0207dd0:	0141                	addi	sp,sp,16
ffffffffc0207dd2:	8082                	ret

ffffffffc0207dd4 <sys_dup>:
ffffffffc0207dd4:	450c                	lw	a1,8(a0)
ffffffffc0207dd6:	4108                	lw	a0,0(a0)
ffffffffc0207dd8:	d01fd06f          	j	ffffffffc0205ad8 <sysfile_dup>

ffffffffc0207ddc <sys_getdirentry>:
ffffffffc0207ddc:	650c                	ld	a1,8(a0)
ffffffffc0207dde:	4108                	lw	a0,0(a0)
ffffffffc0207de0:	c09fd06f          	j	ffffffffc02059e8 <sysfile_getdirentry>

ffffffffc0207de4 <sys_getcwd>:
ffffffffc0207de4:	650c                	ld	a1,8(a0)
ffffffffc0207de6:	6108                	ld	a0,0(a0)
ffffffffc0207de8:	b57fd06f          	j	ffffffffc020593e <sysfile_getcwd>

ffffffffc0207dec <sys_fsync>:
ffffffffc0207dec:	4108                	lw	a0,0(a0)
ffffffffc0207dee:	b4dfd06f          	j	ffffffffc020593a <sysfile_fsync>

ffffffffc0207df2 <sys_fstat>:
ffffffffc0207df2:	650c                	ld	a1,8(a0)
ffffffffc0207df4:	4108                	lw	a0,0(a0)
ffffffffc0207df6:	abdfd06f          	j	ffffffffc02058b2 <sysfile_fstat>

ffffffffc0207dfa <sys_seek>:
ffffffffc0207dfa:	4910                	lw	a2,16(a0)
ffffffffc0207dfc:	650c                	ld	a1,8(a0)
ffffffffc0207dfe:	4108                	lw	a0,0(a0)
ffffffffc0207e00:	aaffd06f          	j	ffffffffc02058ae <sysfile_seek>

ffffffffc0207e04 <sys_write>:
ffffffffc0207e04:	6910                	ld	a2,16(a0)
ffffffffc0207e06:	650c                	ld	a1,8(a0)
ffffffffc0207e08:	4108                	lw	a0,0(a0)
ffffffffc0207e0a:	973fd06f          	j	ffffffffc020577c <sysfile_write>

ffffffffc0207e0e <sys_read>:
ffffffffc0207e0e:	6910                	ld	a2,16(a0)
ffffffffc0207e10:	650c                	ld	a1,8(a0)
ffffffffc0207e12:	4108                	lw	a0,0(a0)
ffffffffc0207e14:	81dfd06f          	j	ffffffffc0205630 <sysfile_read>

ffffffffc0207e18 <sys_close>:
ffffffffc0207e18:	4108                	lw	a0,0(a0)
ffffffffc0207e1a:	813fd06f          	j	ffffffffc020562c <sysfile_close>

ffffffffc0207e1e <sys_open>:
ffffffffc0207e1e:	450c                	lw	a1,8(a0)
ffffffffc0207e20:	6108                	ld	a0,0(a0)
ffffffffc0207e22:	fd4fd06f          	j	ffffffffc02055f6 <sysfile_open>

ffffffffc0207e26 <sys_putc>:
ffffffffc0207e26:	4108                	lw	a0,0(a0)
ffffffffc0207e28:	1141                	addi	sp,sp,-16
ffffffffc0207e2a:	e406                	sd	ra,8(sp)
ffffffffc0207e2c:	bb4f80ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc0207e30:	60a2                	ld	ra,8(sp)
ffffffffc0207e32:	4501                	li	a0,0
ffffffffc0207e34:	0141                	addi	sp,sp,16
ffffffffc0207e36:	8082                	ret

ffffffffc0207e38 <sys_kill>:
ffffffffc0207e38:	4108                	lw	a0,0(a0)
ffffffffc0207e3a:	8e4ff06f          	j	ffffffffc0206f1e <do_kill>

ffffffffc0207e3e <sys_sleep>:
ffffffffc0207e3e:	4108                	lw	a0,0(a0)
ffffffffc0207e40:	b72ff06f          	j	ffffffffc02071b2 <do_sleep>

ffffffffc0207e44 <sys_yield>:
ffffffffc0207e44:	890ff06f          	j	ffffffffc0206ed4 <do_yield>

ffffffffc0207e48 <sys_exec>:
ffffffffc0207e48:	6910                	ld	a2,16(a0)
ffffffffc0207e4a:	450c                	lw	a1,8(a0)
ffffffffc0207e4c:	6108                	ld	a0,0(a0)
ffffffffc0207e4e:	facfe06f          	j	ffffffffc02065fa <do_execve>

ffffffffc0207e52 <sys_wait>:
ffffffffc0207e52:	650c                	ld	a1,8(a0)
ffffffffc0207e54:	4108                	lw	a0,0(a0)
ffffffffc0207e56:	88eff06f          	j	ffffffffc0206ee4 <do_wait>

ffffffffc0207e5a <sys_fork>:
ffffffffc0207e5a:	00090797          	auipc	a5,0x90
ffffffffc0207e5e:	a767b783          	ld	a5,-1418(a5) # ffffffffc02978d0 <current>
ffffffffc0207e62:	4501                	li	a0,0
ffffffffc0207e64:	73d0                	ld	a2,160(a5)
ffffffffc0207e66:	6a0c                	ld	a1,16(a2)
ffffffffc0207e68:	e87fd06f          	j	ffffffffc0205cee <do_fork>

ffffffffc0207e6c <sys_exit>:
ffffffffc0207e6c:	4108                	lw	a0,0(a0)
ffffffffc0207e6e:	afafe06f          	j	ffffffffc0206168 <do_exit>

ffffffffc0207e72 <syscall>:
ffffffffc0207e72:	00090697          	auipc	a3,0x90
ffffffffc0207e76:	a5e6b683          	ld	a3,-1442(a3) # ffffffffc02978d0 <current>
ffffffffc0207e7a:	715d                	addi	sp,sp,-80
ffffffffc0207e7c:	e0a2                	sd	s0,64(sp)
ffffffffc0207e7e:	72c0                	ld	s0,160(a3)
ffffffffc0207e80:	e486                	sd	ra,72(sp)
ffffffffc0207e82:	0ff00793          	li	a5,255
ffffffffc0207e86:	4834                	lw	a3,80(s0)
ffffffffc0207e88:	02d7ec63          	bltu	a5,a3,ffffffffc0207ec0 <syscall+0x4e>
ffffffffc0207e8c:	00007797          	auipc	a5,0x7
ffffffffc0207e90:	5fc78793          	addi	a5,a5,1532 # ffffffffc020f488 <syscalls>
ffffffffc0207e94:	00369613          	slli	a2,a3,0x3
ffffffffc0207e98:	97b2                	add	a5,a5,a2
ffffffffc0207e9a:	639c                	ld	a5,0(a5)
ffffffffc0207e9c:	c395                	beqz	a5,ffffffffc0207ec0 <syscall+0x4e>
ffffffffc0207e9e:	7028                	ld	a0,96(s0)
ffffffffc0207ea0:	742c                	ld	a1,104(s0)
ffffffffc0207ea2:	7830                	ld	a2,112(s0)
ffffffffc0207ea4:	7c34                	ld	a3,120(s0)
ffffffffc0207ea6:	6c38                	ld	a4,88(s0)
ffffffffc0207ea8:	f02a                	sd	a0,32(sp)
ffffffffc0207eaa:	f42e                	sd	a1,40(sp)
ffffffffc0207eac:	f832                	sd	a2,48(sp)
ffffffffc0207eae:	fc36                	sd	a3,56(sp)
ffffffffc0207eb0:	ec3a                	sd	a4,24(sp)
ffffffffc0207eb2:	0828                	addi	a0,sp,24
ffffffffc0207eb4:	9782                	jalr	a5
ffffffffc0207eb6:	60a6                	ld	ra,72(sp)
ffffffffc0207eb8:	e828                	sd	a0,80(s0)
ffffffffc0207eba:	6406                	ld	s0,64(sp)
ffffffffc0207ebc:	6161                	addi	sp,sp,80
ffffffffc0207ebe:	8082                	ret
ffffffffc0207ec0:	8522                	mv	a0,s0
ffffffffc0207ec2:	e436                	sd	a3,8(sp)
ffffffffc0207ec4:	8c0f90ef          	jal	ffffffffc0200f84 <print_trapframe>
ffffffffc0207ec8:	00090797          	auipc	a5,0x90
ffffffffc0207ecc:	a087b783          	ld	a5,-1528(a5) # ffffffffc02978d0 <current>
ffffffffc0207ed0:	66a2                	ld	a3,8(sp)
ffffffffc0207ed2:	00006617          	auipc	a2,0x6
ffffffffc0207ed6:	32e60613          	addi	a2,a2,814 # ffffffffc020e200 <etext+0x24c8>
ffffffffc0207eda:	43d8                	lw	a4,4(a5)
ffffffffc0207edc:	0d800593          	li	a1,216
ffffffffc0207ee0:	0b478793          	addi	a5,a5,180
ffffffffc0207ee4:	00006517          	auipc	a0,0x6
ffffffffc0207ee8:	34c50513          	addi	a0,a0,844 # ffffffffc020e230 <etext+0x24f8>
ffffffffc0207eec:	d5ef80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207ef0 <__alloc_inode>:
ffffffffc0207ef0:	1141                	addi	sp,sp,-16
ffffffffc0207ef2:	e022                	sd	s0,0(sp)
ffffffffc0207ef4:	842a                	mv	s0,a0
ffffffffc0207ef6:	07800513          	li	a0,120
ffffffffc0207efa:	e406                	sd	ra,8(sp)
ffffffffc0207efc:	a8cfa0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0207f00:	c111                	beqz	a0,ffffffffc0207f04 <__alloc_inode+0x14>
ffffffffc0207f02:	cd20                	sw	s0,88(a0)
ffffffffc0207f04:	60a2                	ld	ra,8(sp)
ffffffffc0207f06:	6402                	ld	s0,0(sp)
ffffffffc0207f08:	0141                	addi	sp,sp,16
ffffffffc0207f0a:	8082                	ret

ffffffffc0207f0c <inode_init>:
ffffffffc0207f0c:	4785                	li	a5,1
ffffffffc0207f0e:	06052023          	sw	zero,96(a0)
ffffffffc0207f12:	f92c                	sd	a1,112(a0)
ffffffffc0207f14:	f530                	sd	a2,104(a0)
ffffffffc0207f16:	cd7c                	sw	a5,92(a0)
ffffffffc0207f18:	8082                	ret

ffffffffc0207f1a <inode_kill>:
ffffffffc0207f1a:	4d78                	lw	a4,92(a0)
ffffffffc0207f1c:	1141                	addi	sp,sp,-16
ffffffffc0207f1e:	e406                	sd	ra,8(sp)
ffffffffc0207f20:	e719                	bnez	a4,ffffffffc0207f2e <inode_kill+0x14>
ffffffffc0207f22:	513c                	lw	a5,96(a0)
ffffffffc0207f24:	e78d                	bnez	a5,ffffffffc0207f4e <inode_kill+0x34>
ffffffffc0207f26:	60a2                	ld	ra,8(sp)
ffffffffc0207f28:	0141                	addi	sp,sp,16
ffffffffc0207f2a:	b04fa06f          	j	ffffffffc020222e <kfree>
ffffffffc0207f2e:	00006697          	auipc	a3,0x6
ffffffffc0207f32:	31a68693          	addi	a3,a3,794 # ffffffffc020e248 <etext+0x2510>
ffffffffc0207f36:	00004617          	auipc	a2,0x4
ffffffffc0207f3a:	23a60613          	addi	a2,a2,570 # ffffffffc020c170 <etext+0x438>
ffffffffc0207f3e:	02900593          	li	a1,41
ffffffffc0207f42:	00006517          	auipc	a0,0x6
ffffffffc0207f46:	32650513          	addi	a0,a0,806 # ffffffffc020e268 <etext+0x2530>
ffffffffc0207f4a:	d00f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207f4e:	00006697          	auipc	a3,0x6
ffffffffc0207f52:	33268693          	addi	a3,a3,818 # ffffffffc020e280 <etext+0x2548>
ffffffffc0207f56:	00004617          	auipc	a2,0x4
ffffffffc0207f5a:	21a60613          	addi	a2,a2,538 # ffffffffc020c170 <etext+0x438>
ffffffffc0207f5e:	02a00593          	li	a1,42
ffffffffc0207f62:	00006517          	auipc	a0,0x6
ffffffffc0207f66:	30650513          	addi	a0,a0,774 # ffffffffc020e268 <etext+0x2530>
ffffffffc0207f6a:	ce0f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc0207f6e <inode_ref_inc>:
ffffffffc0207f6e:	4d7c                	lw	a5,92(a0)
ffffffffc0207f70:	2785                	addiw	a5,a5,1
ffffffffc0207f72:	cd7c                	sw	a5,92(a0)
ffffffffc0207f74:	853e                	mv	a0,a5
ffffffffc0207f76:	8082                	ret

ffffffffc0207f78 <inode_open_inc>:
ffffffffc0207f78:	513c                	lw	a5,96(a0)
ffffffffc0207f7a:	2785                	addiw	a5,a5,1
ffffffffc0207f7c:	d13c                	sw	a5,96(a0)
ffffffffc0207f7e:	853e                	mv	a0,a5
ffffffffc0207f80:	8082                	ret

ffffffffc0207f82 <inode_check>:
ffffffffc0207f82:	1141                	addi	sp,sp,-16
ffffffffc0207f84:	e406                	sd	ra,8(sp)
ffffffffc0207f86:	c91d                	beqz	a0,ffffffffc0207fbc <inode_check+0x3a>
ffffffffc0207f88:	793c                	ld	a5,112(a0)
ffffffffc0207f8a:	cb8d                	beqz	a5,ffffffffc0207fbc <inode_check+0x3a>
ffffffffc0207f8c:	6398                	ld	a4,0(a5)
ffffffffc0207f8e:	4625d7b7          	lui	a5,0x4625d
ffffffffc0207f92:	0786                	slli	a5,a5,0x1
ffffffffc0207f94:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0207f98:	08f71263          	bne	a4,a5,ffffffffc020801c <inode_check+0x9a>
ffffffffc0207f9c:	4d74                	lw	a3,92(a0)
ffffffffc0207f9e:	5138                	lw	a4,96(a0)
ffffffffc0207fa0:	04e6ce63          	blt	a3,a4,ffffffffc0207ffc <inode_check+0x7a>
ffffffffc0207fa4:	01f7579b          	srliw	a5,a4,0x1f
ffffffffc0207fa8:	ebb1                	bnez	a5,ffffffffc0207ffc <inode_check+0x7a>
ffffffffc0207faa:	67c1                	lui	a5,0x10
ffffffffc0207fac:	17fd                	addi	a5,a5,-1 # ffff <_binary_bin_swap_img_size+0x82ff>
ffffffffc0207fae:	02d7c763          	blt	a5,a3,ffffffffc0207fdc <inode_check+0x5a>
ffffffffc0207fb2:	02e7c563          	blt	a5,a4,ffffffffc0207fdc <inode_check+0x5a>
ffffffffc0207fb6:	60a2                	ld	ra,8(sp)
ffffffffc0207fb8:	0141                	addi	sp,sp,16
ffffffffc0207fba:	8082                	ret
ffffffffc0207fbc:	00006697          	auipc	a3,0x6
ffffffffc0207fc0:	2e468693          	addi	a3,a3,740 # ffffffffc020e2a0 <etext+0x2568>
ffffffffc0207fc4:	00004617          	auipc	a2,0x4
ffffffffc0207fc8:	1ac60613          	addi	a2,a2,428 # ffffffffc020c170 <etext+0x438>
ffffffffc0207fcc:	06e00593          	li	a1,110
ffffffffc0207fd0:	00006517          	auipc	a0,0x6
ffffffffc0207fd4:	29850513          	addi	a0,a0,664 # ffffffffc020e268 <etext+0x2530>
ffffffffc0207fd8:	c72f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207fdc:	00006697          	auipc	a3,0x6
ffffffffc0207fe0:	34468693          	addi	a3,a3,836 # ffffffffc020e320 <etext+0x25e8>
ffffffffc0207fe4:	00004617          	auipc	a2,0x4
ffffffffc0207fe8:	18c60613          	addi	a2,a2,396 # ffffffffc020c170 <etext+0x438>
ffffffffc0207fec:	07200593          	li	a1,114
ffffffffc0207ff0:	00006517          	auipc	a0,0x6
ffffffffc0207ff4:	27850513          	addi	a0,a0,632 # ffffffffc020e268 <etext+0x2530>
ffffffffc0207ff8:	c52f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc0207ffc:	00006697          	auipc	a3,0x6
ffffffffc0208000:	2f468693          	addi	a3,a3,756 # ffffffffc020e2f0 <etext+0x25b8>
ffffffffc0208004:	00004617          	auipc	a2,0x4
ffffffffc0208008:	16c60613          	addi	a2,a2,364 # ffffffffc020c170 <etext+0x438>
ffffffffc020800c:	07100593          	li	a1,113
ffffffffc0208010:	00006517          	auipc	a0,0x6
ffffffffc0208014:	25850513          	addi	a0,a0,600 # ffffffffc020e268 <etext+0x2530>
ffffffffc0208018:	c32f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020801c:	00006697          	auipc	a3,0x6
ffffffffc0208020:	2ac68693          	addi	a3,a3,684 # ffffffffc020e2c8 <etext+0x2590>
ffffffffc0208024:	00004617          	auipc	a2,0x4
ffffffffc0208028:	14c60613          	addi	a2,a2,332 # ffffffffc020c170 <etext+0x438>
ffffffffc020802c:	06f00593          	li	a1,111
ffffffffc0208030:	00006517          	auipc	a0,0x6
ffffffffc0208034:	23850513          	addi	a0,a0,568 # ffffffffc020e268 <etext+0x2530>
ffffffffc0208038:	c12f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020803c <inode_ref_dec>:
ffffffffc020803c:	4d7c                	lw	a5,92(a0)
ffffffffc020803e:	7179                	addi	sp,sp,-48
ffffffffc0208040:	f406                	sd	ra,40(sp)
ffffffffc0208042:	06f05b63          	blez	a5,ffffffffc02080b8 <inode_ref_dec+0x7c>
ffffffffc0208046:	37fd                	addiw	a5,a5,-1
ffffffffc0208048:	cd7c                	sw	a5,92(a0)
ffffffffc020804a:	e795                	bnez	a5,ffffffffc0208076 <inode_ref_dec+0x3a>
ffffffffc020804c:	7934                	ld	a3,112(a0)
ffffffffc020804e:	c6a9                	beqz	a3,ffffffffc0208098 <inode_ref_dec+0x5c>
ffffffffc0208050:	66b4                	ld	a3,72(a3)
ffffffffc0208052:	c2b9                	beqz	a3,ffffffffc0208098 <inode_ref_dec+0x5c>
ffffffffc0208054:	00006597          	auipc	a1,0x6
ffffffffc0208058:	37c58593          	addi	a1,a1,892 # ffffffffc020e3d0 <etext+0x2698>
ffffffffc020805c:	e83e                	sd	a5,16(sp)
ffffffffc020805e:	ec2a                	sd	a0,24(sp)
ffffffffc0208060:	e436                	sd	a3,8(sp)
ffffffffc0208062:	f21ff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208066:	6562                	ld	a0,24(sp)
ffffffffc0208068:	66a2                	ld	a3,8(sp)
ffffffffc020806a:	9682                	jalr	a3
ffffffffc020806c:	00f50713          	addi	a4,a0,15
ffffffffc0208070:	67c2                	ld	a5,16(sp)
ffffffffc0208072:	c311                	beqz	a4,ffffffffc0208076 <inode_ref_dec+0x3a>
ffffffffc0208074:	e509                	bnez	a0,ffffffffc020807e <inode_ref_dec+0x42>
ffffffffc0208076:	70a2                	ld	ra,40(sp)
ffffffffc0208078:	853e                	mv	a0,a5
ffffffffc020807a:	6145                	addi	sp,sp,48
ffffffffc020807c:	8082                	ret
ffffffffc020807e:	85aa                	mv	a1,a0
ffffffffc0208080:	00006517          	auipc	a0,0x6
ffffffffc0208084:	35850513          	addi	a0,a0,856 # ffffffffc020e3d8 <etext+0x26a0>
ffffffffc0208088:	e43e                	sd	a5,8(sp)
ffffffffc020808a:	91cf80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc020808e:	67a2                	ld	a5,8(sp)
ffffffffc0208090:	70a2                	ld	ra,40(sp)
ffffffffc0208092:	853e                	mv	a0,a5
ffffffffc0208094:	6145                	addi	sp,sp,48
ffffffffc0208096:	8082                	ret
ffffffffc0208098:	00006697          	auipc	a3,0x6
ffffffffc020809c:	2e868693          	addi	a3,a3,744 # ffffffffc020e380 <etext+0x2648>
ffffffffc02080a0:	00004617          	auipc	a2,0x4
ffffffffc02080a4:	0d060613          	addi	a2,a2,208 # ffffffffc020c170 <etext+0x438>
ffffffffc02080a8:	04400593          	li	a1,68
ffffffffc02080ac:	00006517          	auipc	a0,0x6
ffffffffc02080b0:	1bc50513          	addi	a0,a0,444 # ffffffffc020e268 <etext+0x2530>
ffffffffc02080b4:	b96f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02080b8:	00006697          	auipc	a3,0x6
ffffffffc02080bc:	2a868693          	addi	a3,a3,680 # ffffffffc020e360 <etext+0x2628>
ffffffffc02080c0:	00004617          	auipc	a2,0x4
ffffffffc02080c4:	0b060613          	addi	a2,a2,176 # ffffffffc020c170 <etext+0x438>
ffffffffc02080c8:	03f00593          	li	a1,63
ffffffffc02080cc:	00006517          	auipc	a0,0x6
ffffffffc02080d0:	19c50513          	addi	a0,a0,412 # ffffffffc020e268 <etext+0x2530>
ffffffffc02080d4:	b76f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02080d8 <inode_open_dec>:
ffffffffc02080d8:	513c                	lw	a5,96(a0)
ffffffffc02080da:	7179                	addi	sp,sp,-48
ffffffffc02080dc:	f406                	sd	ra,40(sp)
ffffffffc02080de:	06f05863          	blez	a5,ffffffffc020814e <inode_open_dec+0x76>
ffffffffc02080e2:	37fd                	addiw	a5,a5,-1
ffffffffc02080e4:	d13c                	sw	a5,96(a0)
ffffffffc02080e6:	e39d                	bnez	a5,ffffffffc020810c <inode_open_dec+0x34>
ffffffffc02080e8:	7934                	ld	a3,112(a0)
ffffffffc02080ea:	c2b1                	beqz	a3,ffffffffc020812e <inode_open_dec+0x56>
ffffffffc02080ec:	6a94                	ld	a3,16(a3)
ffffffffc02080ee:	c2a1                	beqz	a3,ffffffffc020812e <inode_open_dec+0x56>
ffffffffc02080f0:	00006597          	auipc	a1,0x6
ffffffffc02080f4:	37858593          	addi	a1,a1,888 # ffffffffc020e468 <etext+0x2730>
ffffffffc02080f8:	e83e                	sd	a5,16(sp)
ffffffffc02080fa:	ec2a                	sd	a0,24(sp)
ffffffffc02080fc:	e436                	sd	a3,8(sp)
ffffffffc02080fe:	e85ff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208102:	6562                	ld	a0,24(sp)
ffffffffc0208104:	66a2                	ld	a3,8(sp)
ffffffffc0208106:	9682                	jalr	a3
ffffffffc0208108:	67c2                	ld	a5,16(sp)
ffffffffc020810a:	e509                	bnez	a0,ffffffffc0208114 <inode_open_dec+0x3c>
ffffffffc020810c:	70a2                	ld	ra,40(sp)
ffffffffc020810e:	853e                	mv	a0,a5
ffffffffc0208110:	6145                	addi	sp,sp,48
ffffffffc0208112:	8082                	ret
ffffffffc0208114:	85aa                	mv	a1,a0
ffffffffc0208116:	00006517          	auipc	a0,0x6
ffffffffc020811a:	35a50513          	addi	a0,a0,858 # ffffffffc020e470 <etext+0x2738>
ffffffffc020811e:	e43e                	sd	a5,8(sp)
ffffffffc0208120:	886f80ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0208124:	67a2                	ld	a5,8(sp)
ffffffffc0208126:	70a2                	ld	ra,40(sp)
ffffffffc0208128:	853e                	mv	a0,a5
ffffffffc020812a:	6145                	addi	sp,sp,48
ffffffffc020812c:	8082                	ret
ffffffffc020812e:	00006697          	auipc	a3,0x6
ffffffffc0208132:	2ea68693          	addi	a3,a3,746 # ffffffffc020e418 <etext+0x26e0>
ffffffffc0208136:	00004617          	auipc	a2,0x4
ffffffffc020813a:	03a60613          	addi	a2,a2,58 # ffffffffc020c170 <etext+0x438>
ffffffffc020813e:	06100593          	li	a1,97
ffffffffc0208142:	00006517          	auipc	a0,0x6
ffffffffc0208146:	12650513          	addi	a0,a0,294 # ffffffffc020e268 <etext+0x2530>
ffffffffc020814a:	b00f80ef          	jal	ffffffffc020044a <__panic>
ffffffffc020814e:	00006697          	auipc	a3,0x6
ffffffffc0208152:	2aa68693          	addi	a3,a3,682 # ffffffffc020e3f8 <etext+0x26c0>
ffffffffc0208156:	00004617          	auipc	a2,0x4
ffffffffc020815a:	01a60613          	addi	a2,a2,26 # ffffffffc020c170 <etext+0x438>
ffffffffc020815e:	05c00593          	li	a1,92
ffffffffc0208162:	00006517          	auipc	a0,0x6
ffffffffc0208166:	10650513          	addi	a0,a0,262 # ffffffffc020e268 <etext+0x2530>
ffffffffc020816a:	ae0f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc020816e <__alloc_fs>:
ffffffffc020816e:	1141                	addi	sp,sp,-16
ffffffffc0208170:	e022                	sd	s0,0(sp)
ffffffffc0208172:	842a                	mv	s0,a0
ffffffffc0208174:	0d800513          	li	a0,216
ffffffffc0208178:	e406                	sd	ra,8(sp)
ffffffffc020817a:	80efa0ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020817e:	c119                	beqz	a0,ffffffffc0208184 <__alloc_fs+0x16>
ffffffffc0208180:	0a852823          	sw	s0,176(a0)
ffffffffc0208184:	60a2                	ld	ra,8(sp)
ffffffffc0208186:	6402                	ld	s0,0(sp)
ffffffffc0208188:	0141                	addi	sp,sp,16
ffffffffc020818a:	8082                	ret

ffffffffc020818c <vfs_init>:
ffffffffc020818c:	1141                	addi	sp,sp,-16
ffffffffc020818e:	4585                	li	a1,1
ffffffffc0208190:	0008e517          	auipc	a0,0x8e
ffffffffc0208194:	67050513          	addi	a0,a0,1648 # ffffffffc0296800 <bootfs_sem>
ffffffffc0208198:	e406                	sd	ra,8(sp)
ffffffffc020819a:	c74fc0ef          	jal	ffffffffc020460e <sem_init>
ffffffffc020819e:	60a2                	ld	ra,8(sp)
ffffffffc02081a0:	0141                	addi	sp,sp,16
ffffffffc02081a2:	a4b1                	j	ffffffffc02083ee <vfs_devlist_init>

ffffffffc02081a4 <vfs_set_bootfs>:
ffffffffc02081a4:	7179                	addi	sp,sp,-48
ffffffffc02081a6:	f022                	sd	s0,32(sp)
ffffffffc02081a8:	f406                	sd	ra,40(sp)
ffffffffc02081aa:	ec02                	sd	zero,24(sp)
ffffffffc02081ac:	842a                	mv	s0,a0
ffffffffc02081ae:	c515                	beqz	a0,ffffffffc02081da <vfs_set_bootfs+0x36>
ffffffffc02081b0:	03a00593          	li	a1,58
ffffffffc02081b4:	30b030ef          	jal	ffffffffc020bcbe <strchr>
ffffffffc02081b8:	c125                	beqz	a0,ffffffffc0208218 <vfs_set_bootfs+0x74>
ffffffffc02081ba:	00154783          	lbu	a5,1(a0)
ffffffffc02081be:	efa9                	bnez	a5,ffffffffc0208218 <vfs_set_bootfs+0x74>
ffffffffc02081c0:	8522                	mv	a0,s0
ffffffffc02081c2:	163000ef          	jal	ffffffffc0208b24 <vfs_chdir>
ffffffffc02081c6:	c509                	beqz	a0,ffffffffc02081d0 <vfs_set_bootfs+0x2c>
ffffffffc02081c8:	70a2                	ld	ra,40(sp)
ffffffffc02081ca:	7402                	ld	s0,32(sp)
ffffffffc02081cc:	6145                	addi	sp,sp,48
ffffffffc02081ce:	8082                	ret
ffffffffc02081d0:	0828                	addi	a0,sp,24
ffffffffc02081d2:	05f000ef          	jal	ffffffffc0208a30 <vfs_get_curdir>
ffffffffc02081d6:	f96d                	bnez	a0,ffffffffc02081c8 <vfs_set_bootfs+0x24>
ffffffffc02081d8:	6462                	ld	s0,24(sp)
ffffffffc02081da:	0008e517          	auipc	a0,0x8e
ffffffffc02081de:	62650513          	addi	a0,a0,1574 # ffffffffc0296800 <bootfs_sem>
ffffffffc02081e2:	c36fc0ef          	jal	ffffffffc0204618 <down>
ffffffffc02081e6:	0008f797          	auipc	a5,0x8f
ffffffffc02081ea:	7127b783          	ld	a5,1810(a5) # ffffffffc02978f8 <bootfs_node>
ffffffffc02081ee:	0008e517          	auipc	a0,0x8e
ffffffffc02081f2:	61250513          	addi	a0,a0,1554 # ffffffffc0296800 <bootfs_sem>
ffffffffc02081f6:	0008f717          	auipc	a4,0x8f
ffffffffc02081fa:	70873123          	sd	s0,1794(a4) # ffffffffc02978f8 <bootfs_node>
ffffffffc02081fe:	e43e                	sd	a5,8(sp)
ffffffffc0208200:	c14fc0ef          	jal	ffffffffc0204614 <up>
ffffffffc0208204:	67a2                	ld	a5,8(sp)
ffffffffc0208206:	c781                	beqz	a5,ffffffffc020820e <vfs_set_bootfs+0x6a>
ffffffffc0208208:	853e                	mv	a0,a5
ffffffffc020820a:	e33ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020820e:	70a2                	ld	ra,40(sp)
ffffffffc0208210:	7402                	ld	s0,32(sp)
ffffffffc0208212:	4501                	li	a0,0
ffffffffc0208214:	6145                	addi	sp,sp,48
ffffffffc0208216:	8082                	ret
ffffffffc0208218:	5575                	li	a0,-3
ffffffffc020821a:	b77d                	j	ffffffffc02081c8 <vfs_set_bootfs+0x24>

ffffffffc020821c <vfs_get_bootfs>:
ffffffffc020821c:	1101                	addi	sp,sp,-32
ffffffffc020821e:	e426                	sd	s1,8(sp)
ffffffffc0208220:	0008f497          	auipc	s1,0x8f
ffffffffc0208224:	6d848493          	addi	s1,s1,1752 # ffffffffc02978f8 <bootfs_node>
ffffffffc0208228:	609c                	ld	a5,0(s1)
ffffffffc020822a:	ec06                	sd	ra,24(sp)
ffffffffc020822c:	c3b1                	beqz	a5,ffffffffc0208270 <vfs_get_bootfs+0x54>
ffffffffc020822e:	e822                	sd	s0,16(sp)
ffffffffc0208230:	842a                	mv	s0,a0
ffffffffc0208232:	0008e517          	auipc	a0,0x8e
ffffffffc0208236:	5ce50513          	addi	a0,a0,1486 # ffffffffc0296800 <bootfs_sem>
ffffffffc020823a:	bdefc0ef          	jal	ffffffffc0204618 <down>
ffffffffc020823e:	6084                	ld	s1,0(s1)
ffffffffc0208240:	c08d                	beqz	s1,ffffffffc0208262 <vfs_get_bootfs+0x46>
ffffffffc0208242:	8526                	mv	a0,s1
ffffffffc0208244:	d2bff0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc0208248:	0008e517          	auipc	a0,0x8e
ffffffffc020824c:	5b850513          	addi	a0,a0,1464 # ffffffffc0296800 <bootfs_sem>
ffffffffc0208250:	bc4fc0ef          	jal	ffffffffc0204614 <up>
ffffffffc0208254:	60e2                	ld	ra,24(sp)
ffffffffc0208256:	e004                	sd	s1,0(s0)
ffffffffc0208258:	6442                	ld	s0,16(sp)
ffffffffc020825a:	64a2                	ld	s1,8(sp)
ffffffffc020825c:	4501                	li	a0,0
ffffffffc020825e:	6105                	addi	sp,sp,32
ffffffffc0208260:	8082                	ret
ffffffffc0208262:	0008e517          	auipc	a0,0x8e
ffffffffc0208266:	59e50513          	addi	a0,a0,1438 # ffffffffc0296800 <bootfs_sem>
ffffffffc020826a:	baafc0ef          	jal	ffffffffc0204614 <up>
ffffffffc020826e:	6442                	ld	s0,16(sp)
ffffffffc0208270:	60e2                	ld	ra,24(sp)
ffffffffc0208272:	64a2                	ld	s1,8(sp)
ffffffffc0208274:	5541                	li	a0,-16
ffffffffc0208276:	6105                	addi	sp,sp,32
ffffffffc0208278:	8082                	ret

ffffffffc020827a <vfs_do_add>:
ffffffffc020827a:	7139                	addi	sp,sp,-64
ffffffffc020827c:	fc06                	sd	ra,56(sp)
ffffffffc020827e:	f822                	sd	s0,48(sp)
ffffffffc0208280:	e852                	sd	s4,16(sp)
ffffffffc0208282:	e456                	sd	s5,8(sp)
ffffffffc0208284:	e05a                	sd	s6,0(sp)
ffffffffc0208286:	10050f63          	beqz	a0,ffffffffc02083a4 <vfs_do_add+0x12a>
ffffffffc020828a:	00d5e7b3          	or	a5,a1,a3
ffffffffc020828e:	842a                	mv	s0,a0
ffffffffc0208290:	8a2e                	mv	s4,a1
ffffffffc0208292:	8b32                	mv	s6,a2
ffffffffc0208294:	8ab6                	mv	s5,a3
ffffffffc0208296:	cb89                	beqz	a5,ffffffffc02082a8 <vfs_do_add+0x2e>
ffffffffc0208298:	0e058363          	beqz	a1,ffffffffc020837e <vfs_do_add+0x104>
ffffffffc020829c:	4db8                	lw	a4,88(a1)
ffffffffc020829e:	6785                	lui	a5,0x1
ffffffffc02082a0:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02082a4:	0cf71d63          	bne	a4,a5,ffffffffc020837e <vfs_do_add+0x104>
ffffffffc02082a8:	8522                	mv	a0,s0
ffffffffc02082aa:	173030ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc02082ae:	47fd                	li	a5,31
ffffffffc02082b0:	0ca7e263          	bltu	a5,a0,ffffffffc0208374 <vfs_do_add+0xfa>
ffffffffc02082b4:	8522                	mv	a0,s0
ffffffffc02082b6:	f426                	sd	s1,40(sp)
ffffffffc02082b8:	f3bf70ef          	jal	ffffffffc02001f2 <strdup>
ffffffffc02082bc:	84aa                	mv	s1,a0
ffffffffc02082be:	cd4d                	beqz	a0,ffffffffc0208378 <vfs_do_add+0xfe>
ffffffffc02082c0:	03000513          	li	a0,48
ffffffffc02082c4:	ec4e                	sd	s3,24(sp)
ffffffffc02082c6:	ec3f90ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc02082ca:	89aa                	mv	s3,a0
ffffffffc02082cc:	c935                	beqz	a0,ffffffffc0208340 <vfs_do_add+0xc6>
ffffffffc02082ce:	f04a                	sd	s2,32(sp)
ffffffffc02082d0:	0008e517          	auipc	a0,0x8e
ffffffffc02082d4:	54850513          	addi	a0,a0,1352 # ffffffffc0296818 <vdev_list_sem>
ffffffffc02082d8:	0008e917          	auipc	s2,0x8e
ffffffffc02082dc:	55890913          	addi	s2,s2,1368 # ffffffffc0296830 <vdev_list>
ffffffffc02082e0:	b38fc0ef          	jal	ffffffffc0204618 <down>
ffffffffc02082e4:	844a                	mv	s0,s2
ffffffffc02082e6:	a039                	j	ffffffffc02082f4 <vfs_do_add+0x7a>
ffffffffc02082e8:	fe043503          	ld	a0,-32(s0)
ffffffffc02082ec:	85a6                	mv	a1,s1
ffffffffc02082ee:	175030ef          	jal	ffffffffc020bc62 <strcmp>
ffffffffc02082f2:	c52d                	beqz	a0,ffffffffc020835c <vfs_do_add+0xe2>
ffffffffc02082f4:	6400                	ld	s0,8(s0)
ffffffffc02082f6:	ff2419e3          	bne	s0,s2,ffffffffc02082e8 <vfs_do_add+0x6e>
ffffffffc02082fa:	6418                	ld	a4,8(s0)
ffffffffc02082fc:	02098793          	addi	a5,s3,32
ffffffffc0208300:	0099b023          	sd	s1,0(s3)
ffffffffc0208304:	0149b423          	sd	s4,8(s3)
ffffffffc0208308:	0159bc23          	sd	s5,24(s3)
ffffffffc020830c:	0169b823          	sd	s6,16(s3)
ffffffffc0208310:	e31c                	sd	a5,0(a4)
ffffffffc0208312:	0289b023          	sd	s0,32(s3)
ffffffffc0208316:	02e9b423          	sd	a4,40(s3)
ffffffffc020831a:	0008e517          	auipc	a0,0x8e
ffffffffc020831e:	4fe50513          	addi	a0,a0,1278 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208322:	e41c                	sd	a5,8(s0)
ffffffffc0208324:	af0fc0ef          	jal	ffffffffc0204614 <up>
ffffffffc0208328:	74a2                	ld	s1,40(sp)
ffffffffc020832a:	7902                	ld	s2,32(sp)
ffffffffc020832c:	69e2                	ld	s3,24(sp)
ffffffffc020832e:	4401                	li	s0,0
ffffffffc0208330:	70e2                	ld	ra,56(sp)
ffffffffc0208332:	8522                	mv	a0,s0
ffffffffc0208334:	7442                	ld	s0,48(sp)
ffffffffc0208336:	6a42                	ld	s4,16(sp)
ffffffffc0208338:	6aa2                	ld	s5,8(sp)
ffffffffc020833a:	6b02                	ld	s6,0(sp)
ffffffffc020833c:	6121                	addi	sp,sp,64
ffffffffc020833e:	8082                	ret
ffffffffc0208340:	5471                	li	s0,-4
ffffffffc0208342:	8526                	mv	a0,s1
ffffffffc0208344:	eebf90ef          	jal	ffffffffc020222e <kfree>
ffffffffc0208348:	70e2                	ld	ra,56(sp)
ffffffffc020834a:	8522                	mv	a0,s0
ffffffffc020834c:	7442                	ld	s0,48(sp)
ffffffffc020834e:	74a2                	ld	s1,40(sp)
ffffffffc0208350:	69e2                	ld	s3,24(sp)
ffffffffc0208352:	6a42                	ld	s4,16(sp)
ffffffffc0208354:	6aa2                	ld	s5,8(sp)
ffffffffc0208356:	6b02                	ld	s6,0(sp)
ffffffffc0208358:	6121                	addi	sp,sp,64
ffffffffc020835a:	8082                	ret
ffffffffc020835c:	0008e517          	auipc	a0,0x8e
ffffffffc0208360:	4bc50513          	addi	a0,a0,1212 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208364:	ab0fc0ef          	jal	ffffffffc0204614 <up>
ffffffffc0208368:	854e                	mv	a0,s3
ffffffffc020836a:	ec5f90ef          	jal	ffffffffc020222e <kfree>
ffffffffc020836e:	5425                	li	s0,-23
ffffffffc0208370:	7902                	ld	s2,32(sp)
ffffffffc0208372:	bfc1                	j	ffffffffc0208342 <vfs_do_add+0xc8>
ffffffffc0208374:	5451                	li	s0,-12
ffffffffc0208376:	bf6d                	j	ffffffffc0208330 <vfs_do_add+0xb6>
ffffffffc0208378:	74a2                	ld	s1,40(sp)
ffffffffc020837a:	5471                	li	s0,-4
ffffffffc020837c:	bf55                	j	ffffffffc0208330 <vfs_do_add+0xb6>
ffffffffc020837e:	00006697          	auipc	a3,0x6
ffffffffc0208382:	13a68693          	addi	a3,a3,314 # ffffffffc020e4b8 <etext+0x2780>
ffffffffc0208386:	00004617          	auipc	a2,0x4
ffffffffc020838a:	dea60613          	addi	a2,a2,-534 # ffffffffc020c170 <etext+0x438>
ffffffffc020838e:	08f00593          	li	a1,143
ffffffffc0208392:	00006517          	auipc	a0,0x6
ffffffffc0208396:	10e50513          	addi	a0,a0,270 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc020839a:	f426                	sd	s1,40(sp)
ffffffffc020839c:	f04a                	sd	s2,32(sp)
ffffffffc020839e:	ec4e                	sd	s3,24(sp)
ffffffffc02083a0:	8aaf80ef          	jal	ffffffffc020044a <__panic>
ffffffffc02083a4:	00006697          	auipc	a3,0x6
ffffffffc02083a8:	0ec68693          	addi	a3,a3,236 # ffffffffc020e490 <etext+0x2758>
ffffffffc02083ac:	00004617          	auipc	a2,0x4
ffffffffc02083b0:	dc460613          	addi	a2,a2,-572 # ffffffffc020c170 <etext+0x438>
ffffffffc02083b4:	08e00593          	li	a1,142
ffffffffc02083b8:	00006517          	auipc	a0,0x6
ffffffffc02083bc:	0e850513          	addi	a0,a0,232 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc02083c0:	f426                	sd	s1,40(sp)
ffffffffc02083c2:	f04a                	sd	s2,32(sp)
ffffffffc02083c4:	ec4e                	sd	s3,24(sp)
ffffffffc02083c6:	884f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02083ca <find_mount.part.0>:
ffffffffc02083ca:	1141                	addi	sp,sp,-16
ffffffffc02083cc:	00006697          	auipc	a3,0x6
ffffffffc02083d0:	0c468693          	addi	a3,a3,196 # ffffffffc020e490 <etext+0x2758>
ffffffffc02083d4:	00004617          	auipc	a2,0x4
ffffffffc02083d8:	d9c60613          	addi	a2,a2,-612 # ffffffffc020c170 <etext+0x438>
ffffffffc02083dc:	0cd00593          	li	a1,205
ffffffffc02083e0:	00006517          	auipc	a0,0x6
ffffffffc02083e4:	0c050513          	addi	a0,a0,192 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc02083e8:	e406                	sd	ra,8(sp)
ffffffffc02083ea:	860f80ef          	jal	ffffffffc020044a <__panic>

ffffffffc02083ee <vfs_devlist_init>:
ffffffffc02083ee:	0008e797          	auipc	a5,0x8e
ffffffffc02083f2:	44278793          	addi	a5,a5,1090 # ffffffffc0296830 <vdev_list>
ffffffffc02083f6:	4585                	li	a1,1
ffffffffc02083f8:	0008e517          	auipc	a0,0x8e
ffffffffc02083fc:	42050513          	addi	a0,a0,1056 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208400:	e79c                	sd	a5,8(a5)
ffffffffc0208402:	e39c                	sd	a5,0(a5)
ffffffffc0208404:	a0afc06f          	j	ffffffffc020460e <sem_init>

ffffffffc0208408 <vfs_cleanup>:
ffffffffc0208408:	1101                	addi	sp,sp,-32
ffffffffc020840a:	e426                	sd	s1,8(sp)
ffffffffc020840c:	0008e497          	auipc	s1,0x8e
ffffffffc0208410:	42448493          	addi	s1,s1,1060 # ffffffffc0296830 <vdev_list>
ffffffffc0208414:	649c                	ld	a5,8(s1)
ffffffffc0208416:	ec06                	sd	ra,24(sp)
ffffffffc0208418:	02978f63          	beq	a5,s1,ffffffffc0208456 <vfs_cleanup+0x4e>
ffffffffc020841c:	0008e517          	auipc	a0,0x8e
ffffffffc0208420:	3fc50513          	addi	a0,a0,1020 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208424:	e822                	sd	s0,16(sp)
ffffffffc0208426:	9f2fc0ef          	jal	ffffffffc0204618 <down>
ffffffffc020842a:	6480                	ld	s0,8(s1)
ffffffffc020842c:	00940b63          	beq	s0,s1,ffffffffc0208442 <vfs_cleanup+0x3a>
ffffffffc0208430:	ff043783          	ld	a5,-16(s0)
ffffffffc0208434:	853e                	mv	a0,a5
ffffffffc0208436:	c399                	beqz	a5,ffffffffc020843c <vfs_cleanup+0x34>
ffffffffc0208438:	6bfc                	ld	a5,208(a5)
ffffffffc020843a:	9782                	jalr	a5
ffffffffc020843c:	6400                	ld	s0,8(s0)
ffffffffc020843e:	fe9419e3          	bne	s0,s1,ffffffffc0208430 <vfs_cleanup+0x28>
ffffffffc0208442:	6442                	ld	s0,16(sp)
ffffffffc0208444:	60e2                	ld	ra,24(sp)
ffffffffc0208446:	64a2                	ld	s1,8(sp)
ffffffffc0208448:	0008e517          	auipc	a0,0x8e
ffffffffc020844c:	3d050513          	addi	a0,a0,976 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208450:	6105                	addi	sp,sp,32
ffffffffc0208452:	9c2fc06f          	j	ffffffffc0204614 <up>
ffffffffc0208456:	60e2                	ld	ra,24(sp)
ffffffffc0208458:	64a2                	ld	s1,8(sp)
ffffffffc020845a:	6105                	addi	sp,sp,32
ffffffffc020845c:	8082                	ret

ffffffffc020845e <vfs_get_root>:
ffffffffc020845e:	7179                	addi	sp,sp,-48
ffffffffc0208460:	f406                	sd	ra,40(sp)
ffffffffc0208462:	c949                	beqz	a0,ffffffffc02084f4 <vfs_get_root+0x96>
ffffffffc0208464:	e84a                	sd	s2,16(sp)
ffffffffc0208466:	0008e917          	auipc	s2,0x8e
ffffffffc020846a:	3ca90913          	addi	s2,s2,970 # ffffffffc0296830 <vdev_list>
ffffffffc020846e:	00893783          	ld	a5,8(s2)
ffffffffc0208472:	ec26                	sd	s1,24(sp)
ffffffffc0208474:	07278e63          	beq	a5,s2,ffffffffc02084f0 <vfs_get_root+0x92>
ffffffffc0208478:	e44e                	sd	s3,8(sp)
ffffffffc020847a:	89aa                	mv	s3,a0
ffffffffc020847c:	0008e517          	auipc	a0,0x8e
ffffffffc0208480:	39c50513          	addi	a0,a0,924 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208484:	f022                	sd	s0,32(sp)
ffffffffc0208486:	e052                	sd	s4,0(sp)
ffffffffc0208488:	844a                	mv	s0,s2
ffffffffc020848a:	8a2e                	mv	s4,a1
ffffffffc020848c:	98cfc0ef          	jal	ffffffffc0204618 <down>
ffffffffc0208490:	a801                	j	ffffffffc02084a0 <vfs_get_root+0x42>
ffffffffc0208492:	fe043583          	ld	a1,-32(s0)
ffffffffc0208496:	854e                	mv	a0,s3
ffffffffc0208498:	7ca030ef          	jal	ffffffffc020bc62 <strcmp>
ffffffffc020849c:	84aa                	mv	s1,a0
ffffffffc020849e:	c505                	beqz	a0,ffffffffc02084c6 <vfs_get_root+0x68>
ffffffffc02084a0:	6400                	ld	s0,8(s0)
ffffffffc02084a2:	ff2418e3          	bne	s0,s2,ffffffffc0208492 <vfs_get_root+0x34>
ffffffffc02084a6:	54cd                	li	s1,-13
ffffffffc02084a8:	0008e517          	auipc	a0,0x8e
ffffffffc02084ac:	37050513          	addi	a0,a0,880 # ffffffffc0296818 <vdev_list_sem>
ffffffffc02084b0:	964fc0ef          	jal	ffffffffc0204614 <up>
ffffffffc02084b4:	7402                	ld	s0,32(sp)
ffffffffc02084b6:	69a2                	ld	s3,8(sp)
ffffffffc02084b8:	6a02                	ld	s4,0(sp)
ffffffffc02084ba:	70a2                	ld	ra,40(sp)
ffffffffc02084bc:	6942                	ld	s2,16(sp)
ffffffffc02084be:	8526                	mv	a0,s1
ffffffffc02084c0:	64e2                	ld	s1,24(sp)
ffffffffc02084c2:	6145                	addi	sp,sp,48
ffffffffc02084c4:	8082                	ret
ffffffffc02084c6:	ff043503          	ld	a0,-16(s0)
ffffffffc02084ca:	c519                	beqz	a0,ffffffffc02084d8 <vfs_get_root+0x7a>
ffffffffc02084cc:	617c                	ld	a5,192(a0)
ffffffffc02084ce:	9782                	jalr	a5
ffffffffc02084d0:	c519                	beqz	a0,ffffffffc02084de <vfs_get_root+0x80>
ffffffffc02084d2:	00aa3023          	sd	a0,0(s4)
ffffffffc02084d6:	bfc9                	j	ffffffffc02084a8 <vfs_get_root+0x4a>
ffffffffc02084d8:	ff843783          	ld	a5,-8(s0)
ffffffffc02084dc:	c399                	beqz	a5,ffffffffc02084e2 <vfs_get_root+0x84>
ffffffffc02084de:	54c9                	li	s1,-14
ffffffffc02084e0:	b7e1                	j	ffffffffc02084a8 <vfs_get_root+0x4a>
ffffffffc02084e2:	fe843503          	ld	a0,-24(s0)
ffffffffc02084e6:	a89ff0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc02084ea:	fe843503          	ld	a0,-24(s0)
ffffffffc02084ee:	b7cd                	j	ffffffffc02084d0 <vfs_get_root+0x72>
ffffffffc02084f0:	54cd                	li	s1,-13
ffffffffc02084f2:	b7e1                	j	ffffffffc02084ba <vfs_get_root+0x5c>
ffffffffc02084f4:	00006697          	auipc	a3,0x6
ffffffffc02084f8:	f9c68693          	addi	a3,a3,-100 # ffffffffc020e490 <etext+0x2758>
ffffffffc02084fc:	00004617          	auipc	a2,0x4
ffffffffc0208500:	c7460613          	addi	a2,a2,-908 # ffffffffc020c170 <etext+0x438>
ffffffffc0208504:	04500593          	li	a1,69
ffffffffc0208508:	00006517          	auipc	a0,0x6
ffffffffc020850c:	f9850513          	addi	a0,a0,-104 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc0208510:	f022                	sd	s0,32(sp)
ffffffffc0208512:	ec26                	sd	s1,24(sp)
ffffffffc0208514:	e84a                	sd	s2,16(sp)
ffffffffc0208516:	e44e                	sd	s3,8(sp)
ffffffffc0208518:	e052                	sd	s4,0(sp)
ffffffffc020851a:	f31f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020851e <vfs_get_devname>:
ffffffffc020851e:	0008e697          	auipc	a3,0x8e
ffffffffc0208522:	31268693          	addi	a3,a3,786 # ffffffffc0296830 <vdev_list>
ffffffffc0208526:	87b6                	mv	a5,a3
ffffffffc0208528:	e511                	bnez	a0,ffffffffc0208534 <vfs_get_devname+0x16>
ffffffffc020852a:	a829                	j	ffffffffc0208544 <vfs_get_devname+0x26>
ffffffffc020852c:	ff07b703          	ld	a4,-16(a5)
ffffffffc0208530:	00a70763          	beq	a4,a0,ffffffffc020853e <vfs_get_devname+0x20>
ffffffffc0208534:	679c                	ld	a5,8(a5)
ffffffffc0208536:	fed79be3          	bne	a5,a3,ffffffffc020852c <vfs_get_devname+0xe>
ffffffffc020853a:	4501                	li	a0,0
ffffffffc020853c:	8082                	ret
ffffffffc020853e:	fe07b503          	ld	a0,-32(a5)
ffffffffc0208542:	8082                	ret
ffffffffc0208544:	1141                	addi	sp,sp,-16
ffffffffc0208546:	00006697          	auipc	a3,0x6
ffffffffc020854a:	fd268693          	addi	a3,a3,-46 # ffffffffc020e518 <etext+0x27e0>
ffffffffc020854e:	00004617          	auipc	a2,0x4
ffffffffc0208552:	c2260613          	addi	a2,a2,-990 # ffffffffc020c170 <etext+0x438>
ffffffffc0208556:	06a00593          	li	a1,106
ffffffffc020855a:	00006517          	auipc	a0,0x6
ffffffffc020855e:	f4650513          	addi	a0,a0,-186 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc0208562:	e406                	sd	ra,8(sp)
ffffffffc0208564:	ee7f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208568 <vfs_add_dev>:
ffffffffc0208568:	86b2                	mv	a3,a2
ffffffffc020856a:	4601                	li	a2,0
ffffffffc020856c:	d0fff06f          	j	ffffffffc020827a <vfs_do_add>

ffffffffc0208570 <vfs_mount>:
ffffffffc0208570:	7179                	addi	sp,sp,-48
ffffffffc0208572:	e84a                	sd	s2,16(sp)
ffffffffc0208574:	892a                	mv	s2,a0
ffffffffc0208576:	0008e517          	auipc	a0,0x8e
ffffffffc020857a:	2a250513          	addi	a0,a0,674 # ffffffffc0296818 <vdev_list_sem>
ffffffffc020857e:	e44e                	sd	s3,8(sp)
ffffffffc0208580:	f406                	sd	ra,40(sp)
ffffffffc0208582:	f022                	sd	s0,32(sp)
ffffffffc0208584:	ec26                	sd	s1,24(sp)
ffffffffc0208586:	89ae                	mv	s3,a1
ffffffffc0208588:	890fc0ef          	jal	ffffffffc0204618 <down>
ffffffffc020858c:	0c090a63          	beqz	s2,ffffffffc0208660 <vfs_mount+0xf0>
ffffffffc0208590:	0008e497          	auipc	s1,0x8e
ffffffffc0208594:	2a048493          	addi	s1,s1,672 # ffffffffc0296830 <vdev_list>
ffffffffc0208598:	6480                	ld	s0,8(s1)
ffffffffc020859a:	00941663          	bne	s0,s1,ffffffffc02085a6 <vfs_mount+0x36>
ffffffffc020859e:	a8ad                	j	ffffffffc0208618 <vfs_mount+0xa8>
ffffffffc02085a0:	6400                	ld	s0,8(s0)
ffffffffc02085a2:	06940b63          	beq	s0,s1,ffffffffc0208618 <vfs_mount+0xa8>
ffffffffc02085a6:	ff843783          	ld	a5,-8(s0)
ffffffffc02085aa:	dbfd                	beqz	a5,ffffffffc02085a0 <vfs_mount+0x30>
ffffffffc02085ac:	fe043503          	ld	a0,-32(s0)
ffffffffc02085b0:	85ca                	mv	a1,s2
ffffffffc02085b2:	6b0030ef          	jal	ffffffffc020bc62 <strcmp>
ffffffffc02085b6:	f56d                	bnez	a0,ffffffffc02085a0 <vfs_mount+0x30>
ffffffffc02085b8:	ff043783          	ld	a5,-16(s0)
ffffffffc02085bc:	e3a5                	bnez	a5,ffffffffc020861c <vfs_mount+0xac>
ffffffffc02085be:	fe043783          	ld	a5,-32(s0)
ffffffffc02085c2:	cfbd                	beqz	a5,ffffffffc0208640 <vfs_mount+0xd0>
ffffffffc02085c4:	ff843783          	ld	a5,-8(s0)
ffffffffc02085c8:	cfa5                	beqz	a5,ffffffffc0208640 <vfs_mount+0xd0>
ffffffffc02085ca:	fe843503          	ld	a0,-24(s0)
ffffffffc02085ce:	c929                	beqz	a0,ffffffffc0208620 <vfs_mount+0xb0>
ffffffffc02085d0:	4d38                	lw	a4,88(a0)
ffffffffc02085d2:	6785                	lui	a5,0x1
ffffffffc02085d4:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02085d8:	04f71463          	bne	a4,a5,ffffffffc0208620 <vfs_mount+0xb0>
ffffffffc02085dc:	ff040593          	addi	a1,s0,-16
ffffffffc02085e0:	9982                	jalr	s3
ffffffffc02085e2:	84aa                	mv	s1,a0
ffffffffc02085e4:	ed01                	bnez	a0,ffffffffc02085fc <vfs_mount+0x8c>
ffffffffc02085e6:	ff043783          	ld	a5,-16(s0)
ffffffffc02085ea:	cfad                	beqz	a5,ffffffffc0208664 <vfs_mount+0xf4>
ffffffffc02085ec:	fe043583          	ld	a1,-32(s0)
ffffffffc02085f0:	00006517          	auipc	a0,0x6
ffffffffc02085f4:	fb850513          	addi	a0,a0,-72 # ffffffffc020e5a8 <etext+0x2870>
ffffffffc02085f8:	baff70ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02085fc:	0008e517          	auipc	a0,0x8e
ffffffffc0208600:	21c50513          	addi	a0,a0,540 # ffffffffc0296818 <vdev_list_sem>
ffffffffc0208604:	810fc0ef          	jal	ffffffffc0204614 <up>
ffffffffc0208608:	70a2                	ld	ra,40(sp)
ffffffffc020860a:	7402                	ld	s0,32(sp)
ffffffffc020860c:	6942                	ld	s2,16(sp)
ffffffffc020860e:	69a2                	ld	s3,8(sp)
ffffffffc0208610:	8526                	mv	a0,s1
ffffffffc0208612:	64e2                	ld	s1,24(sp)
ffffffffc0208614:	6145                	addi	sp,sp,48
ffffffffc0208616:	8082                	ret
ffffffffc0208618:	54cd                	li	s1,-13
ffffffffc020861a:	b7cd                	j	ffffffffc02085fc <vfs_mount+0x8c>
ffffffffc020861c:	54c5                	li	s1,-15
ffffffffc020861e:	bff9                	j	ffffffffc02085fc <vfs_mount+0x8c>
ffffffffc0208620:	00006697          	auipc	a3,0x6
ffffffffc0208624:	f3868693          	addi	a3,a3,-200 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208628:	00004617          	auipc	a2,0x4
ffffffffc020862c:	b4860613          	addi	a2,a2,-1208 # ffffffffc020c170 <etext+0x438>
ffffffffc0208630:	0ed00593          	li	a1,237
ffffffffc0208634:	00006517          	auipc	a0,0x6
ffffffffc0208638:	e6c50513          	addi	a0,a0,-404 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc020863c:	e0ff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208640:	00006697          	auipc	a3,0x6
ffffffffc0208644:	ee868693          	addi	a3,a3,-280 # ffffffffc020e528 <etext+0x27f0>
ffffffffc0208648:	00004617          	auipc	a2,0x4
ffffffffc020864c:	b2860613          	addi	a2,a2,-1240 # ffffffffc020c170 <etext+0x438>
ffffffffc0208650:	0eb00593          	li	a1,235
ffffffffc0208654:	00006517          	auipc	a0,0x6
ffffffffc0208658:	e4c50513          	addi	a0,a0,-436 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc020865c:	deff70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208660:	d6bff0ef          	jal	ffffffffc02083ca <find_mount.part.0>
ffffffffc0208664:	00006697          	auipc	a3,0x6
ffffffffc0208668:	f2c68693          	addi	a3,a3,-212 # ffffffffc020e590 <etext+0x2858>
ffffffffc020866c:	00004617          	auipc	a2,0x4
ffffffffc0208670:	b0460613          	addi	a2,a2,-1276 # ffffffffc020c170 <etext+0x438>
ffffffffc0208674:	0ef00593          	li	a1,239
ffffffffc0208678:	00006517          	auipc	a0,0x6
ffffffffc020867c:	e2850513          	addi	a0,a0,-472 # ffffffffc020e4a0 <etext+0x2768>
ffffffffc0208680:	dcbf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208684 <vfs_open>:
ffffffffc0208684:	7159                	addi	sp,sp,-112
ffffffffc0208686:	f486                	sd	ra,104(sp)
ffffffffc0208688:	e0d2                	sd	s4,64(sp)
ffffffffc020868a:	0035f793          	andi	a5,a1,3
ffffffffc020868e:	10078363          	beqz	a5,ffffffffc0208794 <vfs_open+0x110>
ffffffffc0208692:	470d                	li	a4,3
ffffffffc0208694:	12e78163          	beq	a5,a4,ffffffffc02087b6 <vfs_open+0x132>
ffffffffc0208698:	f0a2                	sd	s0,96(sp)
ffffffffc020869a:	eca6                	sd	s1,88(sp)
ffffffffc020869c:	e8ca                	sd	s2,80(sp)
ffffffffc020869e:	e4ce                	sd	s3,72(sp)
ffffffffc02086a0:	fc56                	sd	s5,56(sp)
ffffffffc02086a2:	f85a                	sd	s6,48(sp)
ffffffffc02086a4:	0105fa13          	andi	s4,a1,16
ffffffffc02086a8:	842e                	mv	s0,a1
ffffffffc02086aa:	00447793          	andi	a5,s0,4
ffffffffc02086ae:	8b32                	mv	s6,a2
ffffffffc02086b0:	082c                	addi	a1,sp,24
ffffffffc02086b2:	00345613          	srli	a2,s0,0x3
ffffffffc02086b6:	8abe                	mv	s5,a5
ffffffffc02086b8:	0027d493          	srli	s1,a5,0x2
ffffffffc02086bc:	892a                	mv	s2,a0
ffffffffc02086be:	00167993          	andi	s3,a2,1
ffffffffc02086c2:	2ba000ef          	jal	ffffffffc020897c <vfs_lookup>
ffffffffc02086c6:	87aa                	mv	a5,a0
ffffffffc02086c8:	c175                	beqz	a0,ffffffffc02087ac <vfs_open+0x128>
ffffffffc02086ca:	01050713          	addi	a4,a0,16
ffffffffc02086ce:	eb45                	bnez	a4,ffffffffc020877e <vfs_open+0xfa>
ffffffffc02086d0:	c4dd                	beqz	s1,ffffffffc020877e <vfs_open+0xfa>
ffffffffc02086d2:	854a                	mv	a0,s2
ffffffffc02086d4:	1010                	addi	a2,sp,32
ffffffffc02086d6:	102c                	addi	a1,sp,40
ffffffffc02086d8:	32e000ef          	jal	ffffffffc0208a06 <vfs_lookup_parent>
ffffffffc02086dc:	87aa                	mv	a5,a0
ffffffffc02086de:	e145                	bnez	a0,ffffffffc020877e <vfs_open+0xfa>
ffffffffc02086e0:	7522                	ld	a0,40(sp)
ffffffffc02086e2:	14050c63          	beqz	a0,ffffffffc020883a <vfs_open+0x1b6>
ffffffffc02086e6:	793c                	ld	a5,112(a0)
ffffffffc02086e8:	14078963          	beqz	a5,ffffffffc020883a <vfs_open+0x1b6>
ffffffffc02086ec:	77bc                	ld	a5,104(a5)
ffffffffc02086ee:	14078663          	beqz	a5,ffffffffc020883a <vfs_open+0x1b6>
ffffffffc02086f2:	00006597          	auipc	a1,0x6
ffffffffc02086f6:	f2e58593          	addi	a1,a1,-210 # ffffffffc020e620 <etext+0x28e8>
ffffffffc02086fa:	e42a                	sd	a0,8(sp)
ffffffffc02086fc:	887ff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208700:	6522                	ld	a0,8(sp)
ffffffffc0208702:	7582                	ld	a1,32(sp)
ffffffffc0208704:	0834                	addi	a3,sp,24
ffffffffc0208706:	793c                	ld	a5,112(a0)
ffffffffc0208708:	7522                	ld	a0,40(sp)
ffffffffc020870a:	864e                	mv	a2,s3
ffffffffc020870c:	77bc                	ld	a5,104(a5)
ffffffffc020870e:	9782                	jalr	a5
ffffffffc0208710:	6562                	ld	a0,24(sp)
ffffffffc0208712:	10050463          	beqz	a0,ffffffffc020881a <vfs_open+0x196>
ffffffffc0208716:	793c                	ld	a5,112(a0)
ffffffffc0208718:	c3e9                	beqz	a5,ffffffffc02087da <vfs_open+0x156>
ffffffffc020871a:	679c                	ld	a5,8(a5)
ffffffffc020871c:	cfdd                	beqz	a5,ffffffffc02087da <vfs_open+0x156>
ffffffffc020871e:	00006597          	auipc	a1,0x6
ffffffffc0208722:	f6a58593          	addi	a1,a1,-150 # ffffffffc020e688 <etext+0x2950>
ffffffffc0208726:	e42a                	sd	a0,8(sp)
ffffffffc0208728:	85bff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc020872c:	6522                	ld	a0,8(sp)
ffffffffc020872e:	85a2                	mv	a1,s0
ffffffffc0208730:	793c                	ld	a5,112(a0)
ffffffffc0208732:	6562                	ld	a0,24(sp)
ffffffffc0208734:	679c                	ld	a5,8(a5)
ffffffffc0208736:	9782                	jalr	a5
ffffffffc0208738:	87aa                	mv	a5,a0
ffffffffc020873a:	e43e                	sd	a5,8(sp)
ffffffffc020873c:	6562                	ld	a0,24(sp)
ffffffffc020873e:	e3d1                	bnez	a5,ffffffffc02087c2 <vfs_open+0x13e>
ffffffffc0208740:	839ff0ef          	jal	ffffffffc0207f78 <inode_open_inc>
ffffffffc0208744:	014ae733          	or	a4,s5,s4
ffffffffc0208748:	67a2                	ld	a5,8(sp)
ffffffffc020874a:	c71d                	beqz	a4,ffffffffc0208778 <vfs_open+0xf4>
ffffffffc020874c:	6462                	ld	s0,24(sp)
ffffffffc020874e:	c455                	beqz	s0,ffffffffc02087fa <vfs_open+0x176>
ffffffffc0208750:	7838                	ld	a4,112(s0)
ffffffffc0208752:	c745                	beqz	a4,ffffffffc02087fa <vfs_open+0x176>
ffffffffc0208754:	7338                	ld	a4,96(a4)
ffffffffc0208756:	c355                	beqz	a4,ffffffffc02087fa <vfs_open+0x176>
ffffffffc0208758:	8522                	mv	a0,s0
ffffffffc020875a:	00006597          	auipc	a1,0x6
ffffffffc020875e:	f8e58593          	addi	a1,a1,-114 # ffffffffc020e6e8 <etext+0x29b0>
ffffffffc0208762:	e43e                	sd	a5,8(sp)
ffffffffc0208764:	81fff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208768:	7838                	ld	a4,112(s0)
ffffffffc020876a:	6562                	ld	a0,24(sp)
ffffffffc020876c:	4581                	li	a1,0
ffffffffc020876e:	7338                	ld	a4,96(a4)
ffffffffc0208770:	9702                	jalr	a4
ffffffffc0208772:	67a2                	ld	a5,8(sp)
ffffffffc0208774:	842a                	mv	s0,a0
ffffffffc0208776:	e931                	bnez	a0,ffffffffc02087ca <vfs_open+0x146>
ffffffffc0208778:	6762                	ld	a4,24(sp)
ffffffffc020877a:	00eb3023          	sd	a4,0(s6)
ffffffffc020877e:	7406                	ld	s0,96(sp)
ffffffffc0208780:	64e6                	ld	s1,88(sp)
ffffffffc0208782:	6946                	ld	s2,80(sp)
ffffffffc0208784:	69a6                	ld	s3,72(sp)
ffffffffc0208786:	7ae2                	ld	s5,56(sp)
ffffffffc0208788:	7b42                	ld	s6,48(sp)
ffffffffc020878a:	70a6                	ld	ra,104(sp)
ffffffffc020878c:	6a06                	ld	s4,64(sp)
ffffffffc020878e:	853e                	mv	a0,a5
ffffffffc0208790:	6165                	addi	sp,sp,112
ffffffffc0208792:	8082                	ret
ffffffffc0208794:	0105f713          	andi	a4,a1,16
ffffffffc0208798:	8a3a                	mv	s4,a4
ffffffffc020879a:	57f5                	li	a5,-3
ffffffffc020879c:	f77d                	bnez	a4,ffffffffc020878a <vfs_open+0x106>
ffffffffc020879e:	f0a2                	sd	s0,96(sp)
ffffffffc02087a0:	eca6                	sd	s1,88(sp)
ffffffffc02087a2:	e8ca                	sd	s2,80(sp)
ffffffffc02087a4:	e4ce                	sd	s3,72(sp)
ffffffffc02087a6:	fc56                	sd	s5,56(sp)
ffffffffc02087a8:	f85a                	sd	s6,48(sp)
ffffffffc02087aa:	bdfd                	j	ffffffffc02086a8 <vfs_open+0x24>
ffffffffc02087ac:	f60982e3          	beqz	s3,ffffffffc0208710 <vfs_open+0x8c>
ffffffffc02087b0:	d0a5                	beqz	s1,ffffffffc0208710 <vfs_open+0x8c>
ffffffffc02087b2:	57a5                	li	a5,-23
ffffffffc02087b4:	b7e9                	j	ffffffffc020877e <vfs_open+0xfa>
ffffffffc02087b6:	70a6                	ld	ra,104(sp)
ffffffffc02087b8:	57f5                	li	a5,-3
ffffffffc02087ba:	6a06                	ld	s4,64(sp)
ffffffffc02087bc:	853e                	mv	a0,a5
ffffffffc02087be:	6165                	addi	sp,sp,112
ffffffffc02087c0:	8082                	ret
ffffffffc02087c2:	87bff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc02087c6:	67a2                	ld	a5,8(sp)
ffffffffc02087c8:	bf5d                	j	ffffffffc020877e <vfs_open+0xfa>
ffffffffc02087ca:	6562                	ld	a0,24(sp)
ffffffffc02087cc:	90dff0ef          	jal	ffffffffc02080d8 <inode_open_dec>
ffffffffc02087d0:	6562                	ld	a0,24(sp)
ffffffffc02087d2:	86bff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc02087d6:	87a2                	mv	a5,s0
ffffffffc02087d8:	b75d                	j	ffffffffc020877e <vfs_open+0xfa>
ffffffffc02087da:	00006697          	auipc	a3,0x6
ffffffffc02087de:	e5e68693          	addi	a3,a3,-418 # ffffffffc020e638 <etext+0x2900>
ffffffffc02087e2:	00004617          	auipc	a2,0x4
ffffffffc02087e6:	98e60613          	addi	a2,a2,-1650 # ffffffffc020c170 <etext+0x438>
ffffffffc02087ea:	03300593          	li	a1,51
ffffffffc02087ee:	00006517          	auipc	a0,0x6
ffffffffc02087f2:	e1a50513          	addi	a0,a0,-486 # ffffffffc020e608 <etext+0x28d0>
ffffffffc02087f6:	c55f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02087fa:	00006697          	auipc	a3,0x6
ffffffffc02087fe:	e9668693          	addi	a3,a3,-362 # ffffffffc020e690 <etext+0x2958>
ffffffffc0208802:	00004617          	auipc	a2,0x4
ffffffffc0208806:	96e60613          	addi	a2,a2,-1682 # ffffffffc020c170 <etext+0x438>
ffffffffc020880a:	03a00593          	li	a1,58
ffffffffc020880e:	00006517          	auipc	a0,0x6
ffffffffc0208812:	dfa50513          	addi	a0,a0,-518 # ffffffffc020e608 <etext+0x28d0>
ffffffffc0208816:	c35f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020881a:	00006697          	auipc	a3,0x6
ffffffffc020881e:	e0e68693          	addi	a3,a3,-498 # ffffffffc020e628 <etext+0x28f0>
ffffffffc0208822:	00004617          	auipc	a2,0x4
ffffffffc0208826:	94e60613          	addi	a2,a2,-1714 # ffffffffc020c170 <etext+0x438>
ffffffffc020882a:	03100593          	li	a1,49
ffffffffc020882e:	00006517          	auipc	a0,0x6
ffffffffc0208832:	dda50513          	addi	a0,a0,-550 # ffffffffc020e608 <etext+0x28d0>
ffffffffc0208836:	c15f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020883a:	00006697          	auipc	a3,0x6
ffffffffc020883e:	d7e68693          	addi	a3,a3,-642 # ffffffffc020e5b8 <etext+0x2880>
ffffffffc0208842:	00004617          	auipc	a2,0x4
ffffffffc0208846:	92e60613          	addi	a2,a2,-1746 # ffffffffc020c170 <etext+0x438>
ffffffffc020884a:	02c00593          	li	a1,44
ffffffffc020884e:	00006517          	auipc	a0,0x6
ffffffffc0208852:	dba50513          	addi	a0,a0,-582 # ffffffffc020e608 <etext+0x28d0>
ffffffffc0208856:	bf5f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020885a <vfs_close>:
ffffffffc020885a:	1141                	addi	sp,sp,-16
ffffffffc020885c:	e406                	sd	ra,8(sp)
ffffffffc020885e:	e022                	sd	s0,0(sp)
ffffffffc0208860:	842a                	mv	s0,a0
ffffffffc0208862:	877ff0ef          	jal	ffffffffc02080d8 <inode_open_dec>
ffffffffc0208866:	8522                	mv	a0,s0
ffffffffc0208868:	fd4ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020886c:	60a2                	ld	ra,8(sp)
ffffffffc020886e:	6402                	ld	s0,0(sp)
ffffffffc0208870:	4501                	li	a0,0
ffffffffc0208872:	0141                	addi	sp,sp,16
ffffffffc0208874:	8082                	ret

ffffffffc0208876 <get_device>:
ffffffffc0208876:	00054e03          	lbu	t3,0(a0)
ffffffffc020887a:	020e0463          	beqz	t3,ffffffffc02088a2 <get_device+0x2c>
ffffffffc020887e:	00150693          	addi	a3,a0,1
ffffffffc0208882:	8736                	mv	a4,a3
ffffffffc0208884:	87f2                	mv	a5,t3
ffffffffc0208886:	4801                	li	a6,0
ffffffffc0208888:	03a00893          	li	a7,58
ffffffffc020888c:	02f00313          	li	t1,47
ffffffffc0208890:	01178c63          	beq	a5,a7,ffffffffc02088a8 <get_device+0x32>
ffffffffc0208894:	02678e63          	beq	a5,t1,ffffffffc02088d0 <get_device+0x5a>
ffffffffc0208898:	00074783          	lbu	a5,0(a4)
ffffffffc020889c:	0705                	addi	a4,a4,1
ffffffffc020889e:	2805                	addiw	a6,a6,1
ffffffffc02088a0:	fbe5                	bnez	a5,ffffffffc0208890 <get_device+0x1a>
ffffffffc02088a2:	e188                	sd	a0,0(a1)
ffffffffc02088a4:	8532                	mv	a0,a2
ffffffffc02088a6:	a269                	j	ffffffffc0208a30 <vfs_get_curdir>
ffffffffc02088a8:	02080663          	beqz	a6,ffffffffc02088d4 <get_device+0x5e>
ffffffffc02088ac:	01050733          	add	a4,a0,a6
ffffffffc02088b0:	010687b3          	add	a5,a3,a6
ffffffffc02088b4:	00070023          	sb	zero,0(a4)
ffffffffc02088b8:	02f00813          	li	a6,47
ffffffffc02088bc:	86be                	mv	a3,a5
ffffffffc02088be:	0007c703          	lbu	a4,0(a5)
ffffffffc02088c2:	0785                	addi	a5,a5,1
ffffffffc02088c4:	ff070ce3          	beq	a4,a6,ffffffffc02088bc <get_device+0x46>
ffffffffc02088c8:	e194                	sd	a3,0(a1)
ffffffffc02088ca:	85b2                	mv	a1,a2
ffffffffc02088cc:	b93ff06f          	j	ffffffffc020845e <vfs_get_root>
ffffffffc02088d0:	fc0819e3          	bnez	a6,ffffffffc02088a2 <get_device+0x2c>
ffffffffc02088d4:	7139                	addi	sp,sp,-64
ffffffffc02088d6:	f822                	sd	s0,48(sp)
ffffffffc02088d8:	f426                	sd	s1,40(sp)
ffffffffc02088da:	fc06                	sd	ra,56(sp)
ffffffffc02088dc:	02f00793          	li	a5,47
ffffffffc02088e0:	8432                	mv	s0,a2
ffffffffc02088e2:	84ae                	mv	s1,a1
ffffffffc02088e4:	04fe0563          	beq	t3,a5,ffffffffc020892e <get_device+0xb8>
ffffffffc02088e8:	03a00793          	li	a5,58
ffffffffc02088ec:	06fe1863          	bne	t3,a5,ffffffffc020895c <get_device+0xe6>
ffffffffc02088f0:	0828                	addi	a0,sp,24
ffffffffc02088f2:	e436                	sd	a3,8(sp)
ffffffffc02088f4:	13c000ef          	jal	ffffffffc0208a30 <vfs_get_curdir>
ffffffffc02088f8:	e515                	bnez	a0,ffffffffc0208924 <get_device+0xae>
ffffffffc02088fa:	67e2                	ld	a5,24(sp)
ffffffffc02088fc:	77a8                	ld	a0,104(a5)
ffffffffc02088fe:	cd1d                	beqz	a0,ffffffffc020893c <get_device+0xc6>
ffffffffc0208900:	617c                	ld	a5,192(a0)
ffffffffc0208902:	9782                	jalr	a5
ffffffffc0208904:	87aa                	mv	a5,a0
ffffffffc0208906:	6562                	ld	a0,24(sp)
ffffffffc0208908:	e01c                	sd	a5,0(s0)
ffffffffc020890a:	f32ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020890e:	66a2                	ld	a3,8(sp)
ffffffffc0208910:	02f00713          	li	a4,47
ffffffffc0208914:	a011                	j	ffffffffc0208918 <get_device+0xa2>
ffffffffc0208916:	0685                	addi	a3,a3,1
ffffffffc0208918:	0006c783          	lbu	a5,0(a3)
ffffffffc020891c:	fee78de3          	beq	a5,a4,ffffffffc0208916 <get_device+0xa0>
ffffffffc0208920:	e094                	sd	a3,0(s1)
ffffffffc0208922:	4501                	li	a0,0
ffffffffc0208924:	70e2                	ld	ra,56(sp)
ffffffffc0208926:	7442                	ld	s0,48(sp)
ffffffffc0208928:	74a2                	ld	s1,40(sp)
ffffffffc020892a:	6121                	addi	sp,sp,64
ffffffffc020892c:	8082                	ret
ffffffffc020892e:	8532                	mv	a0,a2
ffffffffc0208930:	e436                	sd	a3,8(sp)
ffffffffc0208932:	8ebff0ef          	jal	ffffffffc020821c <vfs_get_bootfs>
ffffffffc0208936:	66a2                	ld	a3,8(sp)
ffffffffc0208938:	dd61                	beqz	a0,ffffffffc0208910 <get_device+0x9a>
ffffffffc020893a:	b7ed                	j	ffffffffc0208924 <get_device+0xae>
ffffffffc020893c:	00006697          	auipc	a3,0x6
ffffffffc0208940:	de468693          	addi	a3,a3,-540 # ffffffffc020e720 <etext+0x29e8>
ffffffffc0208944:	00004617          	auipc	a2,0x4
ffffffffc0208948:	82c60613          	addi	a2,a2,-2004 # ffffffffc020c170 <etext+0x438>
ffffffffc020894c:	03900593          	li	a1,57
ffffffffc0208950:	00006517          	auipc	a0,0x6
ffffffffc0208954:	db850513          	addi	a0,a0,-584 # ffffffffc020e708 <etext+0x29d0>
ffffffffc0208958:	af3f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020895c:	00006697          	auipc	a3,0x6
ffffffffc0208960:	d9c68693          	addi	a3,a3,-612 # ffffffffc020e6f8 <etext+0x29c0>
ffffffffc0208964:	00004617          	auipc	a2,0x4
ffffffffc0208968:	80c60613          	addi	a2,a2,-2036 # ffffffffc020c170 <etext+0x438>
ffffffffc020896c:	03300593          	li	a1,51
ffffffffc0208970:	00006517          	auipc	a0,0x6
ffffffffc0208974:	d9850513          	addi	a0,a0,-616 # ffffffffc020e708 <etext+0x29d0>
ffffffffc0208978:	ad3f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc020897c <vfs_lookup>:
ffffffffc020897c:	7139                	addi	sp,sp,-64
ffffffffc020897e:	f822                	sd	s0,48(sp)
ffffffffc0208980:	1030                	addi	a2,sp,40
ffffffffc0208982:	842e                	mv	s0,a1
ffffffffc0208984:	082c                	addi	a1,sp,24
ffffffffc0208986:	fc06                	sd	ra,56(sp)
ffffffffc0208988:	ec2a                	sd	a0,24(sp)
ffffffffc020898a:	eedff0ef          	jal	ffffffffc0208876 <get_device>
ffffffffc020898e:	87aa                	mv	a5,a0
ffffffffc0208990:	e121                	bnez	a0,ffffffffc02089d0 <vfs_lookup+0x54>
ffffffffc0208992:	6762                	ld	a4,24(sp)
ffffffffc0208994:	7522                	ld	a0,40(sp)
ffffffffc0208996:	00074683          	lbu	a3,0(a4)
ffffffffc020899a:	c2a1                	beqz	a3,ffffffffc02089da <vfs_lookup+0x5e>
ffffffffc020899c:	c529                	beqz	a0,ffffffffc02089e6 <vfs_lookup+0x6a>
ffffffffc020899e:	793c                	ld	a5,112(a0)
ffffffffc02089a0:	c3b9                	beqz	a5,ffffffffc02089e6 <vfs_lookup+0x6a>
ffffffffc02089a2:	7bbc                	ld	a5,112(a5)
ffffffffc02089a4:	c3a9                	beqz	a5,ffffffffc02089e6 <vfs_lookup+0x6a>
ffffffffc02089a6:	00006597          	auipc	a1,0x6
ffffffffc02089aa:	de258593          	addi	a1,a1,-542 # ffffffffc020e788 <etext+0x2a50>
ffffffffc02089ae:	e83a                	sd	a4,16(sp)
ffffffffc02089b0:	e42a                	sd	a0,8(sp)
ffffffffc02089b2:	dd0ff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc02089b6:	6522                	ld	a0,8(sp)
ffffffffc02089b8:	65c2                	ld	a1,16(sp)
ffffffffc02089ba:	8622                	mv	a2,s0
ffffffffc02089bc:	793c                	ld	a5,112(a0)
ffffffffc02089be:	7522                	ld	a0,40(sp)
ffffffffc02089c0:	7bbc                	ld	a5,112(a5)
ffffffffc02089c2:	9782                	jalr	a5
ffffffffc02089c4:	87aa                	mv	a5,a0
ffffffffc02089c6:	7522                	ld	a0,40(sp)
ffffffffc02089c8:	e43e                	sd	a5,8(sp)
ffffffffc02089ca:	e72ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc02089ce:	67a2                	ld	a5,8(sp)
ffffffffc02089d0:	70e2                	ld	ra,56(sp)
ffffffffc02089d2:	7442                	ld	s0,48(sp)
ffffffffc02089d4:	853e                	mv	a0,a5
ffffffffc02089d6:	6121                	addi	sp,sp,64
ffffffffc02089d8:	8082                	ret
ffffffffc02089da:	e008                	sd	a0,0(s0)
ffffffffc02089dc:	70e2                	ld	ra,56(sp)
ffffffffc02089de:	7442                	ld	s0,48(sp)
ffffffffc02089e0:	853e                	mv	a0,a5
ffffffffc02089e2:	6121                	addi	sp,sp,64
ffffffffc02089e4:	8082                	ret
ffffffffc02089e6:	00006697          	auipc	a3,0x6
ffffffffc02089ea:	d5268693          	addi	a3,a3,-686 # ffffffffc020e738 <etext+0x2a00>
ffffffffc02089ee:	00003617          	auipc	a2,0x3
ffffffffc02089f2:	78260613          	addi	a2,a2,1922 # ffffffffc020c170 <etext+0x438>
ffffffffc02089f6:	04f00593          	li	a1,79
ffffffffc02089fa:	00006517          	auipc	a0,0x6
ffffffffc02089fe:	d0e50513          	addi	a0,a0,-754 # ffffffffc020e708 <etext+0x29d0>
ffffffffc0208a02:	a49f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208a06 <vfs_lookup_parent>:
ffffffffc0208a06:	7139                	addi	sp,sp,-64
ffffffffc0208a08:	f822                	sd	s0,48(sp)
ffffffffc0208a0a:	f426                	sd	s1,40(sp)
ffffffffc0208a0c:	8432                	mv	s0,a2
ffffffffc0208a0e:	84ae                	mv	s1,a1
ffffffffc0208a10:	0830                	addi	a2,sp,24
ffffffffc0208a12:	002c                	addi	a1,sp,8
ffffffffc0208a14:	fc06                	sd	ra,56(sp)
ffffffffc0208a16:	e42a                	sd	a0,8(sp)
ffffffffc0208a18:	e5fff0ef          	jal	ffffffffc0208876 <get_device>
ffffffffc0208a1c:	e509                	bnez	a0,ffffffffc0208a26 <vfs_lookup_parent+0x20>
ffffffffc0208a1e:	6722                	ld	a4,8(sp)
ffffffffc0208a20:	67e2                	ld	a5,24(sp)
ffffffffc0208a22:	e018                	sd	a4,0(s0)
ffffffffc0208a24:	e09c                	sd	a5,0(s1)
ffffffffc0208a26:	70e2                	ld	ra,56(sp)
ffffffffc0208a28:	7442                	ld	s0,48(sp)
ffffffffc0208a2a:	74a2                	ld	s1,40(sp)
ffffffffc0208a2c:	6121                	addi	sp,sp,64
ffffffffc0208a2e:	8082                	ret

ffffffffc0208a30 <vfs_get_curdir>:
ffffffffc0208a30:	0008f797          	auipc	a5,0x8f
ffffffffc0208a34:	ea07b783          	ld	a5,-352(a5) # ffffffffc02978d0 <current>
ffffffffc0208a38:	1101                	addi	sp,sp,-32
ffffffffc0208a3a:	e822                	sd	s0,16(sp)
ffffffffc0208a3c:	1487b783          	ld	a5,328(a5)
ffffffffc0208a40:	ec06                	sd	ra,24(sp)
ffffffffc0208a42:	6380                	ld	s0,0(a5)
ffffffffc0208a44:	cc09                	beqz	s0,ffffffffc0208a5e <vfs_get_curdir+0x2e>
ffffffffc0208a46:	e426                	sd	s1,8(sp)
ffffffffc0208a48:	84aa                	mv	s1,a0
ffffffffc0208a4a:	8522                	mv	a0,s0
ffffffffc0208a4c:	d22ff0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc0208a50:	e080                	sd	s0,0(s1)
ffffffffc0208a52:	64a2                	ld	s1,8(sp)
ffffffffc0208a54:	4501                	li	a0,0
ffffffffc0208a56:	60e2                	ld	ra,24(sp)
ffffffffc0208a58:	6442                	ld	s0,16(sp)
ffffffffc0208a5a:	6105                	addi	sp,sp,32
ffffffffc0208a5c:	8082                	ret
ffffffffc0208a5e:	5541                	li	a0,-16
ffffffffc0208a60:	bfdd                	j	ffffffffc0208a56 <vfs_get_curdir+0x26>

ffffffffc0208a62 <vfs_set_curdir>:
ffffffffc0208a62:	7139                	addi	sp,sp,-64
ffffffffc0208a64:	f04a                	sd	s2,32(sp)
ffffffffc0208a66:	0008f917          	auipc	s2,0x8f
ffffffffc0208a6a:	e6a90913          	addi	s2,s2,-406 # ffffffffc02978d0 <current>
ffffffffc0208a6e:	00093783          	ld	a5,0(s2)
ffffffffc0208a72:	f822                	sd	s0,48(sp)
ffffffffc0208a74:	842a                	mv	s0,a0
ffffffffc0208a76:	1487b503          	ld	a0,328(a5)
ffffffffc0208a7a:	fc06                	sd	ra,56(sp)
ffffffffc0208a7c:	f426                	sd	s1,40(sp)
ffffffffc0208a7e:	811fc0ef          	jal	ffffffffc020528e <lock_files>
ffffffffc0208a82:	00093783          	ld	a5,0(s2)
ffffffffc0208a86:	1487b503          	ld	a0,328(a5)
ffffffffc0208a8a:	611c                	ld	a5,0(a0)
ffffffffc0208a8c:	06f40a63          	beq	s0,a5,ffffffffc0208b00 <vfs_set_curdir+0x9e>
ffffffffc0208a90:	c02d                	beqz	s0,ffffffffc0208af2 <vfs_set_curdir+0x90>
ffffffffc0208a92:	7838                	ld	a4,112(s0)
ffffffffc0208a94:	cb25                	beqz	a4,ffffffffc0208b04 <vfs_set_curdir+0xa2>
ffffffffc0208a96:	6b38                	ld	a4,80(a4)
ffffffffc0208a98:	c735                	beqz	a4,ffffffffc0208b04 <vfs_set_curdir+0xa2>
ffffffffc0208a9a:	00006597          	auipc	a1,0x6
ffffffffc0208a9e:	d5e58593          	addi	a1,a1,-674 # ffffffffc020e7f8 <etext+0x2ac0>
ffffffffc0208aa2:	8522                	mv	a0,s0
ffffffffc0208aa4:	e43e                	sd	a5,8(sp)
ffffffffc0208aa6:	cdcff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208aaa:	7838                	ld	a4,112(s0)
ffffffffc0208aac:	086c                	addi	a1,sp,28
ffffffffc0208aae:	8522                	mv	a0,s0
ffffffffc0208ab0:	6b38                	ld	a4,80(a4)
ffffffffc0208ab2:	9702                	jalr	a4
ffffffffc0208ab4:	84aa                	mv	s1,a0
ffffffffc0208ab6:	e909                	bnez	a0,ffffffffc0208ac8 <vfs_set_curdir+0x66>
ffffffffc0208ab8:	4772                	lw	a4,28(sp)
ffffffffc0208aba:	4609                	li	a2,2
ffffffffc0208abc:	54b9                	li	s1,-18
ffffffffc0208abe:	40c75693          	srai	a3,a4,0xc
ffffffffc0208ac2:	8a9d                	andi	a3,a3,7
ffffffffc0208ac4:	00c68f63          	beq	a3,a2,ffffffffc0208ae2 <vfs_set_curdir+0x80>
ffffffffc0208ac8:	00093783          	ld	a5,0(s2)
ffffffffc0208acc:	1487b503          	ld	a0,328(a5)
ffffffffc0208ad0:	fc4fc0ef          	jal	ffffffffc0205294 <unlock_files>
ffffffffc0208ad4:	70e2                	ld	ra,56(sp)
ffffffffc0208ad6:	7442                	ld	s0,48(sp)
ffffffffc0208ad8:	7902                	ld	s2,32(sp)
ffffffffc0208ada:	8526                	mv	a0,s1
ffffffffc0208adc:	74a2                	ld	s1,40(sp)
ffffffffc0208ade:	6121                	addi	sp,sp,64
ffffffffc0208ae0:	8082                	ret
ffffffffc0208ae2:	8522                	mv	a0,s0
ffffffffc0208ae4:	c8aff0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc0208ae8:	00093703          	ld	a4,0(s2)
ffffffffc0208aec:	67a2                	ld	a5,8(sp)
ffffffffc0208aee:	14873503          	ld	a0,328(a4)
ffffffffc0208af2:	e100                	sd	s0,0(a0)
ffffffffc0208af4:	4481                	li	s1,0
ffffffffc0208af6:	dfe9                	beqz	a5,ffffffffc0208ad0 <vfs_set_curdir+0x6e>
ffffffffc0208af8:	853e                	mv	a0,a5
ffffffffc0208afa:	d42ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc0208afe:	b7e9                	j	ffffffffc0208ac8 <vfs_set_curdir+0x66>
ffffffffc0208b00:	4481                	li	s1,0
ffffffffc0208b02:	b7f9                	j	ffffffffc0208ad0 <vfs_set_curdir+0x6e>
ffffffffc0208b04:	00006697          	auipc	a3,0x6
ffffffffc0208b08:	c8c68693          	addi	a3,a3,-884 # ffffffffc020e790 <etext+0x2a58>
ffffffffc0208b0c:	00003617          	auipc	a2,0x3
ffffffffc0208b10:	66460613          	addi	a2,a2,1636 # ffffffffc020c170 <etext+0x438>
ffffffffc0208b14:	04300593          	li	a1,67
ffffffffc0208b18:	00006517          	auipc	a0,0x6
ffffffffc0208b1c:	cc850513          	addi	a0,a0,-824 # ffffffffc020e7e0 <etext+0x2aa8>
ffffffffc0208b20:	92bf70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208b24 <vfs_chdir>:
ffffffffc0208b24:	7179                	addi	sp,sp,-48
ffffffffc0208b26:	082c                	addi	a1,sp,24
ffffffffc0208b28:	f406                	sd	ra,40(sp)
ffffffffc0208b2a:	e53ff0ef          	jal	ffffffffc020897c <vfs_lookup>
ffffffffc0208b2e:	87aa                	mv	a5,a0
ffffffffc0208b30:	c509                	beqz	a0,ffffffffc0208b3a <vfs_chdir+0x16>
ffffffffc0208b32:	70a2                	ld	ra,40(sp)
ffffffffc0208b34:	853e                	mv	a0,a5
ffffffffc0208b36:	6145                	addi	sp,sp,48
ffffffffc0208b38:	8082                	ret
ffffffffc0208b3a:	6562                	ld	a0,24(sp)
ffffffffc0208b3c:	f27ff0ef          	jal	ffffffffc0208a62 <vfs_set_curdir>
ffffffffc0208b40:	87aa                	mv	a5,a0
ffffffffc0208b42:	6562                	ld	a0,24(sp)
ffffffffc0208b44:	e43e                	sd	a5,8(sp)
ffffffffc0208b46:	cf6ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc0208b4a:	67a2                	ld	a5,8(sp)
ffffffffc0208b4c:	70a2                	ld	ra,40(sp)
ffffffffc0208b4e:	853e                	mv	a0,a5
ffffffffc0208b50:	6145                	addi	sp,sp,48
ffffffffc0208b52:	8082                	ret

ffffffffc0208b54 <vfs_getcwd>:
ffffffffc0208b54:	0008f797          	auipc	a5,0x8f
ffffffffc0208b58:	d7c7b783          	ld	a5,-644(a5) # ffffffffc02978d0 <current>
ffffffffc0208b5c:	7179                	addi	sp,sp,-48
ffffffffc0208b5e:	ec26                	sd	s1,24(sp)
ffffffffc0208b60:	1487b783          	ld	a5,328(a5)
ffffffffc0208b64:	f406                	sd	ra,40(sp)
ffffffffc0208b66:	f022                	sd	s0,32(sp)
ffffffffc0208b68:	6384                	ld	s1,0(a5)
ffffffffc0208b6a:	c0c1                	beqz	s1,ffffffffc0208bea <vfs_getcwd+0x96>
ffffffffc0208b6c:	e84a                	sd	s2,16(sp)
ffffffffc0208b6e:	892a                	mv	s2,a0
ffffffffc0208b70:	8526                	mv	a0,s1
ffffffffc0208b72:	bfcff0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc0208b76:	74a8                	ld	a0,104(s1)
ffffffffc0208b78:	c93d                	beqz	a0,ffffffffc0208bee <vfs_getcwd+0x9a>
ffffffffc0208b7a:	9a5ff0ef          	jal	ffffffffc020851e <vfs_get_devname>
ffffffffc0208b7e:	842a                	mv	s0,a0
ffffffffc0208b80:	09c030ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc0208b84:	862a                	mv	a2,a0
ffffffffc0208b86:	85a2                	mv	a1,s0
ffffffffc0208b88:	854a                	mv	a0,s2
ffffffffc0208b8a:	4701                	li	a4,0
ffffffffc0208b8c:	4685                	li	a3,1
ffffffffc0208b8e:	92bfc0ef          	jal	ffffffffc02054b8 <iobuf_move>
ffffffffc0208b92:	842a                	mv	s0,a0
ffffffffc0208b94:	c919                	beqz	a0,ffffffffc0208baa <vfs_getcwd+0x56>
ffffffffc0208b96:	8526                	mv	a0,s1
ffffffffc0208b98:	ca4ff0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc0208b9c:	6942                	ld	s2,16(sp)
ffffffffc0208b9e:	70a2                	ld	ra,40(sp)
ffffffffc0208ba0:	8522                	mv	a0,s0
ffffffffc0208ba2:	7402                	ld	s0,32(sp)
ffffffffc0208ba4:	64e2                	ld	s1,24(sp)
ffffffffc0208ba6:	6145                	addi	sp,sp,48
ffffffffc0208ba8:	8082                	ret
ffffffffc0208baa:	4685                	li	a3,1
ffffffffc0208bac:	03a00793          	li	a5,58
ffffffffc0208bb0:	8636                	mv	a2,a3
ffffffffc0208bb2:	4701                	li	a4,0
ffffffffc0208bb4:	00f10593          	addi	a1,sp,15
ffffffffc0208bb8:	854a                	mv	a0,s2
ffffffffc0208bba:	00f107a3          	sb	a5,15(sp)
ffffffffc0208bbe:	8fbfc0ef          	jal	ffffffffc02054b8 <iobuf_move>
ffffffffc0208bc2:	842a                	mv	s0,a0
ffffffffc0208bc4:	f969                	bnez	a0,ffffffffc0208b96 <vfs_getcwd+0x42>
ffffffffc0208bc6:	78bc                	ld	a5,112(s1)
ffffffffc0208bc8:	c3b9                	beqz	a5,ffffffffc0208c0e <vfs_getcwd+0xba>
ffffffffc0208bca:	7f9c                	ld	a5,56(a5)
ffffffffc0208bcc:	c3a9                	beqz	a5,ffffffffc0208c0e <vfs_getcwd+0xba>
ffffffffc0208bce:	00006597          	auipc	a1,0x6
ffffffffc0208bd2:	c8a58593          	addi	a1,a1,-886 # ffffffffc020e858 <etext+0x2b20>
ffffffffc0208bd6:	8526                	mv	a0,s1
ffffffffc0208bd8:	baaff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208bdc:	78bc                	ld	a5,112(s1)
ffffffffc0208bde:	85ca                	mv	a1,s2
ffffffffc0208be0:	8526                	mv	a0,s1
ffffffffc0208be2:	7f9c                	ld	a5,56(a5)
ffffffffc0208be4:	9782                	jalr	a5
ffffffffc0208be6:	842a                	mv	s0,a0
ffffffffc0208be8:	b77d                	j	ffffffffc0208b96 <vfs_getcwd+0x42>
ffffffffc0208bea:	5441                	li	s0,-16
ffffffffc0208bec:	bf4d                	j	ffffffffc0208b9e <vfs_getcwd+0x4a>
ffffffffc0208bee:	00006697          	auipc	a3,0x6
ffffffffc0208bf2:	b3268693          	addi	a3,a3,-1230 # ffffffffc020e720 <etext+0x29e8>
ffffffffc0208bf6:	00003617          	auipc	a2,0x3
ffffffffc0208bfa:	57a60613          	addi	a2,a2,1402 # ffffffffc020c170 <etext+0x438>
ffffffffc0208bfe:	06e00593          	li	a1,110
ffffffffc0208c02:	00006517          	auipc	a0,0x6
ffffffffc0208c06:	bde50513          	addi	a0,a0,-1058 # ffffffffc020e7e0 <etext+0x2aa8>
ffffffffc0208c0a:	841f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208c0e:	00006697          	auipc	a3,0x6
ffffffffc0208c12:	bf268693          	addi	a3,a3,-1038 # ffffffffc020e800 <etext+0x2ac8>
ffffffffc0208c16:	00003617          	auipc	a2,0x3
ffffffffc0208c1a:	55a60613          	addi	a2,a2,1370 # ffffffffc020c170 <etext+0x438>
ffffffffc0208c1e:	07800593          	li	a1,120
ffffffffc0208c22:	00006517          	auipc	a0,0x6
ffffffffc0208c26:	bbe50513          	addi	a0,a0,-1090 # ffffffffc020e7e0 <etext+0x2aa8>
ffffffffc0208c2a:	821f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208c2e <dev_lookup>:
ffffffffc0208c2e:	0005c703          	lbu	a4,0(a1)
ffffffffc0208c32:	ef11                	bnez	a4,ffffffffc0208c4e <dev_lookup+0x20>
ffffffffc0208c34:	1101                	addi	sp,sp,-32
ffffffffc0208c36:	ec06                	sd	ra,24(sp)
ffffffffc0208c38:	e032                	sd	a2,0(sp)
ffffffffc0208c3a:	e42a                	sd	a0,8(sp)
ffffffffc0208c3c:	b32ff0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc0208c40:	6602                	ld	a2,0(sp)
ffffffffc0208c42:	67a2                	ld	a5,8(sp)
ffffffffc0208c44:	60e2                	ld	ra,24(sp)
ffffffffc0208c46:	4501                	li	a0,0
ffffffffc0208c48:	e21c                	sd	a5,0(a2)
ffffffffc0208c4a:	6105                	addi	sp,sp,32
ffffffffc0208c4c:	8082                	ret
ffffffffc0208c4e:	5541                	li	a0,-16
ffffffffc0208c50:	8082                	ret

ffffffffc0208c52 <dev_fstat>:
ffffffffc0208c52:	1101                	addi	sp,sp,-32
ffffffffc0208c54:	e822                	sd	s0,16(sp)
ffffffffc0208c56:	e426                	sd	s1,8(sp)
ffffffffc0208c58:	842a                	mv	s0,a0
ffffffffc0208c5a:	84ae                	mv	s1,a1
ffffffffc0208c5c:	852e                	mv	a0,a1
ffffffffc0208c5e:	02000613          	li	a2,32
ffffffffc0208c62:	4581                	li	a1,0
ffffffffc0208c64:	ec06                	sd	ra,24(sp)
ffffffffc0208c66:	06a030ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0208c6a:	c429                	beqz	s0,ffffffffc0208cb4 <dev_fstat+0x62>
ffffffffc0208c6c:	783c                	ld	a5,112(s0)
ffffffffc0208c6e:	c3b9                	beqz	a5,ffffffffc0208cb4 <dev_fstat+0x62>
ffffffffc0208c70:	6bbc                	ld	a5,80(a5)
ffffffffc0208c72:	c3a9                	beqz	a5,ffffffffc0208cb4 <dev_fstat+0x62>
ffffffffc0208c74:	00006597          	auipc	a1,0x6
ffffffffc0208c78:	b8458593          	addi	a1,a1,-1148 # ffffffffc020e7f8 <etext+0x2ac0>
ffffffffc0208c7c:	8522                	mv	a0,s0
ffffffffc0208c7e:	b04ff0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0208c82:	783c                	ld	a5,112(s0)
ffffffffc0208c84:	85a6                	mv	a1,s1
ffffffffc0208c86:	8522                	mv	a0,s0
ffffffffc0208c88:	6bbc                	ld	a5,80(a5)
ffffffffc0208c8a:	9782                	jalr	a5
ffffffffc0208c8c:	ed19                	bnez	a0,ffffffffc0208caa <dev_fstat+0x58>
ffffffffc0208c8e:	4c38                	lw	a4,88(s0)
ffffffffc0208c90:	6785                	lui	a5,0x1
ffffffffc0208c92:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c96:	02f71f63          	bne	a4,a5,ffffffffc0208cd4 <dev_fstat+0x82>
ffffffffc0208c9a:	6018                	ld	a4,0(s0)
ffffffffc0208c9c:	641c                	ld	a5,8(s0)
ffffffffc0208c9e:	4685                	li	a3,1
ffffffffc0208ca0:	e898                	sd	a4,16(s1)
ffffffffc0208ca2:	02e787b3          	mul	a5,a5,a4
ffffffffc0208ca6:	e494                	sd	a3,8(s1)
ffffffffc0208ca8:	ec9c                	sd	a5,24(s1)
ffffffffc0208caa:	60e2                	ld	ra,24(sp)
ffffffffc0208cac:	6442                	ld	s0,16(sp)
ffffffffc0208cae:	64a2                	ld	s1,8(sp)
ffffffffc0208cb0:	6105                	addi	sp,sp,32
ffffffffc0208cb2:	8082                	ret
ffffffffc0208cb4:	00006697          	auipc	a3,0x6
ffffffffc0208cb8:	adc68693          	addi	a3,a3,-1316 # ffffffffc020e790 <etext+0x2a58>
ffffffffc0208cbc:	00003617          	auipc	a2,0x3
ffffffffc0208cc0:	4b460613          	addi	a2,a2,1204 # ffffffffc020c170 <etext+0x438>
ffffffffc0208cc4:	04200593          	li	a1,66
ffffffffc0208cc8:	00006517          	auipc	a0,0x6
ffffffffc0208ccc:	ba050513          	addi	a0,a0,-1120 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208cd0:	f7af70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0208cd4:	00006697          	auipc	a3,0x6
ffffffffc0208cd8:	88468693          	addi	a3,a3,-1916 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208cdc:	00003617          	auipc	a2,0x3
ffffffffc0208ce0:	49460613          	addi	a2,a2,1172 # ffffffffc020c170 <etext+0x438>
ffffffffc0208ce4:	04500593          	li	a1,69
ffffffffc0208ce8:	00006517          	auipc	a0,0x6
ffffffffc0208cec:	b8050513          	addi	a0,a0,-1152 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208cf0:	f5af70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208cf4 <dev_ioctl>:
ffffffffc0208cf4:	c909                	beqz	a0,ffffffffc0208d06 <dev_ioctl+0x12>
ffffffffc0208cf6:	4d34                	lw	a3,88(a0)
ffffffffc0208cf8:	6705                	lui	a4,0x1
ffffffffc0208cfa:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208cfe:	00e69463          	bne	a3,a4,ffffffffc0208d06 <dev_ioctl+0x12>
ffffffffc0208d02:	751c                	ld	a5,40(a0)
ffffffffc0208d04:	8782                	jr	a5
ffffffffc0208d06:	1141                	addi	sp,sp,-16
ffffffffc0208d08:	00006697          	auipc	a3,0x6
ffffffffc0208d0c:	85068693          	addi	a3,a3,-1968 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208d10:	00003617          	auipc	a2,0x3
ffffffffc0208d14:	46060613          	addi	a2,a2,1120 # ffffffffc020c170 <etext+0x438>
ffffffffc0208d18:	03500593          	li	a1,53
ffffffffc0208d1c:	00006517          	auipc	a0,0x6
ffffffffc0208d20:	b4c50513          	addi	a0,a0,-1204 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208d24:	e406                	sd	ra,8(sp)
ffffffffc0208d26:	f24f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208d2a <dev_tryseek>:
ffffffffc0208d2a:	c51d                	beqz	a0,ffffffffc0208d58 <dev_tryseek+0x2e>
ffffffffc0208d2c:	4d38                	lw	a4,88(a0)
ffffffffc0208d2e:	6785                	lui	a5,0x1
ffffffffc0208d30:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d34:	02f71263          	bne	a4,a5,ffffffffc0208d58 <dev_tryseek+0x2e>
ffffffffc0208d38:	611c                	ld	a5,0(a0)
ffffffffc0208d3a:	cf89                	beqz	a5,ffffffffc0208d54 <dev_tryseek+0x2a>
ffffffffc0208d3c:	6518                	ld	a4,8(a0)
ffffffffc0208d3e:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208d42:	ea89                	bnez	a3,ffffffffc0208d54 <dev_tryseek+0x2a>
ffffffffc0208d44:	0005c863          	bltz	a1,ffffffffc0208d54 <dev_tryseek+0x2a>
ffffffffc0208d48:	02e787b3          	mul	a5,a5,a4
ffffffffc0208d4c:	4501                	li	a0,0
ffffffffc0208d4e:	00f5f363          	bgeu	a1,a5,ffffffffc0208d54 <dev_tryseek+0x2a>
ffffffffc0208d52:	8082                	ret
ffffffffc0208d54:	5575                	li	a0,-3
ffffffffc0208d56:	8082                	ret
ffffffffc0208d58:	1141                	addi	sp,sp,-16
ffffffffc0208d5a:	00005697          	auipc	a3,0x5
ffffffffc0208d5e:	7fe68693          	addi	a3,a3,2046 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208d62:	00003617          	auipc	a2,0x3
ffffffffc0208d66:	40e60613          	addi	a2,a2,1038 # ffffffffc020c170 <etext+0x438>
ffffffffc0208d6a:	05f00593          	li	a1,95
ffffffffc0208d6e:	00006517          	auipc	a0,0x6
ffffffffc0208d72:	afa50513          	addi	a0,a0,-1286 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208d76:	e406                	sd	ra,8(sp)
ffffffffc0208d78:	ed2f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208d7c <dev_gettype>:
ffffffffc0208d7c:	cd11                	beqz	a0,ffffffffc0208d98 <dev_gettype+0x1c>
ffffffffc0208d7e:	4d38                	lw	a4,88(a0)
ffffffffc0208d80:	6785                	lui	a5,0x1
ffffffffc0208d82:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d86:	00f71963          	bne	a4,a5,ffffffffc0208d98 <dev_gettype+0x1c>
ffffffffc0208d8a:	6118                	ld	a4,0(a0)
ffffffffc0208d8c:	6791                	lui	a5,0x4
ffffffffc0208d8e:	c311                	beqz	a4,ffffffffc0208d92 <dev_gettype+0x16>
ffffffffc0208d90:	6795                	lui	a5,0x5
ffffffffc0208d92:	c19c                	sw	a5,0(a1)
ffffffffc0208d94:	4501                	li	a0,0
ffffffffc0208d96:	8082                	ret
ffffffffc0208d98:	1141                	addi	sp,sp,-16
ffffffffc0208d9a:	00005697          	auipc	a3,0x5
ffffffffc0208d9e:	7be68693          	addi	a3,a3,1982 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208da2:	00003617          	auipc	a2,0x3
ffffffffc0208da6:	3ce60613          	addi	a2,a2,974 # ffffffffc020c170 <etext+0x438>
ffffffffc0208daa:	05300593          	li	a1,83
ffffffffc0208dae:	00006517          	auipc	a0,0x6
ffffffffc0208db2:	aba50513          	addi	a0,a0,-1350 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208db6:	e406                	sd	ra,8(sp)
ffffffffc0208db8:	e92f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208dbc <dev_write>:
ffffffffc0208dbc:	c911                	beqz	a0,ffffffffc0208dd0 <dev_write+0x14>
ffffffffc0208dbe:	4d34                	lw	a3,88(a0)
ffffffffc0208dc0:	6705                	lui	a4,0x1
ffffffffc0208dc2:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208dc6:	00e69563          	bne	a3,a4,ffffffffc0208dd0 <dev_write+0x14>
ffffffffc0208dca:	711c                	ld	a5,32(a0)
ffffffffc0208dcc:	4605                	li	a2,1
ffffffffc0208dce:	8782                	jr	a5
ffffffffc0208dd0:	1141                	addi	sp,sp,-16
ffffffffc0208dd2:	00005697          	auipc	a3,0x5
ffffffffc0208dd6:	78668693          	addi	a3,a3,1926 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208dda:	00003617          	auipc	a2,0x3
ffffffffc0208dde:	39660613          	addi	a2,a2,918 # ffffffffc020c170 <etext+0x438>
ffffffffc0208de2:	02c00593          	li	a1,44
ffffffffc0208de6:	00006517          	auipc	a0,0x6
ffffffffc0208dea:	a8250513          	addi	a0,a0,-1406 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208dee:	e406                	sd	ra,8(sp)
ffffffffc0208df0:	e5af70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208df4 <dev_read>:
ffffffffc0208df4:	c911                	beqz	a0,ffffffffc0208e08 <dev_read+0x14>
ffffffffc0208df6:	4d34                	lw	a3,88(a0)
ffffffffc0208df8:	6705                	lui	a4,0x1
ffffffffc0208dfa:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208dfe:	00e69563          	bne	a3,a4,ffffffffc0208e08 <dev_read+0x14>
ffffffffc0208e02:	711c                	ld	a5,32(a0)
ffffffffc0208e04:	4601                	li	a2,0
ffffffffc0208e06:	8782                	jr	a5
ffffffffc0208e08:	1141                	addi	sp,sp,-16
ffffffffc0208e0a:	00005697          	auipc	a3,0x5
ffffffffc0208e0e:	74e68693          	addi	a3,a3,1870 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208e12:	00003617          	auipc	a2,0x3
ffffffffc0208e16:	35e60613          	addi	a2,a2,862 # ffffffffc020c170 <etext+0x438>
ffffffffc0208e1a:	02300593          	li	a1,35
ffffffffc0208e1e:	00006517          	auipc	a0,0x6
ffffffffc0208e22:	a4a50513          	addi	a0,a0,-1462 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208e26:	e406                	sd	ra,8(sp)
ffffffffc0208e28:	e22f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e2c <dev_close>:
ffffffffc0208e2c:	c909                	beqz	a0,ffffffffc0208e3e <dev_close+0x12>
ffffffffc0208e2e:	4d34                	lw	a3,88(a0)
ffffffffc0208e30:	6705                	lui	a4,0x1
ffffffffc0208e32:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e36:	00e69463          	bne	a3,a4,ffffffffc0208e3e <dev_close+0x12>
ffffffffc0208e3a:	6d1c                	ld	a5,24(a0)
ffffffffc0208e3c:	8782                	jr	a5
ffffffffc0208e3e:	1141                	addi	sp,sp,-16
ffffffffc0208e40:	00005697          	auipc	a3,0x5
ffffffffc0208e44:	71868693          	addi	a3,a3,1816 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208e48:	00003617          	auipc	a2,0x3
ffffffffc0208e4c:	32860613          	addi	a2,a2,808 # ffffffffc020c170 <etext+0x438>
ffffffffc0208e50:	45e9                	li	a1,26
ffffffffc0208e52:	00006517          	auipc	a0,0x6
ffffffffc0208e56:	a1650513          	addi	a0,a0,-1514 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208e5a:	e406                	sd	ra,8(sp)
ffffffffc0208e5c:	deef70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e60 <dev_open>:
ffffffffc0208e60:	03c5f793          	andi	a5,a1,60
ffffffffc0208e64:	eb91                	bnez	a5,ffffffffc0208e78 <dev_open+0x18>
ffffffffc0208e66:	c919                	beqz	a0,ffffffffc0208e7c <dev_open+0x1c>
ffffffffc0208e68:	4d34                	lw	a3,88(a0)
ffffffffc0208e6a:	6785                	lui	a5,0x1
ffffffffc0208e6c:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e70:	00f69663          	bne	a3,a5,ffffffffc0208e7c <dev_open+0x1c>
ffffffffc0208e74:	691c                	ld	a5,16(a0)
ffffffffc0208e76:	8782                	jr	a5
ffffffffc0208e78:	5575                	li	a0,-3
ffffffffc0208e7a:	8082                	ret
ffffffffc0208e7c:	1141                	addi	sp,sp,-16
ffffffffc0208e7e:	00005697          	auipc	a3,0x5
ffffffffc0208e82:	6da68693          	addi	a3,a3,1754 # ffffffffc020e558 <etext+0x2820>
ffffffffc0208e86:	00003617          	auipc	a2,0x3
ffffffffc0208e8a:	2ea60613          	addi	a2,a2,746 # ffffffffc020c170 <etext+0x438>
ffffffffc0208e8e:	45c5                	li	a1,17
ffffffffc0208e90:	00006517          	auipc	a0,0x6
ffffffffc0208e94:	9d850513          	addi	a0,a0,-1576 # ffffffffc020e868 <etext+0x2b30>
ffffffffc0208e98:	e406                	sd	ra,8(sp)
ffffffffc0208e9a:	db0f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc0208e9e <dev_init>:
ffffffffc0208e9e:	1141                	addi	sp,sp,-16
ffffffffc0208ea0:	e406                	sd	ra,8(sp)
ffffffffc0208ea2:	544000ef          	jal	ffffffffc02093e6 <dev_init_stdin>
ffffffffc0208ea6:	65c000ef          	jal	ffffffffc0209502 <dev_init_stdout>
ffffffffc0208eaa:	60a2                	ld	ra,8(sp)
ffffffffc0208eac:	0141                	addi	sp,sp,16
ffffffffc0208eae:	ac01                	j	ffffffffc02090be <dev_init_disk0>

ffffffffc0208eb0 <dev_create_inode>:
ffffffffc0208eb0:	6505                	lui	a0,0x1
ffffffffc0208eb2:	1101                	addi	sp,sp,-32
ffffffffc0208eb4:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208eb8:	ec06                	sd	ra,24(sp)
ffffffffc0208eba:	836ff0ef          	jal	ffffffffc0207ef0 <__alloc_inode>
ffffffffc0208ebe:	87aa                	mv	a5,a0
ffffffffc0208ec0:	c911                	beqz	a0,ffffffffc0208ed4 <dev_create_inode+0x24>
ffffffffc0208ec2:	4601                	li	a2,0
ffffffffc0208ec4:	00007597          	auipc	a1,0x7
ffffffffc0208ec8:	dc458593          	addi	a1,a1,-572 # ffffffffc020fc88 <dev_node_ops>
ffffffffc0208ecc:	e42a                	sd	a0,8(sp)
ffffffffc0208ece:	83eff0ef          	jal	ffffffffc0207f0c <inode_init>
ffffffffc0208ed2:	67a2                	ld	a5,8(sp)
ffffffffc0208ed4:	60e2                	ld	ra,24(sp)
ffffffffc0208ed6:	853e                	mv	a0,a5
ffffffffc0208ed8:	6105                	addi	sp,sp,32
ffffffffc0208eda:	8082                	ret

ffffffffc0208edc <disk0_open>:
ffffffffc0208edc:	4501                	li	a0,0
ffffffffc0208ede:	8082                	ret

ffffffffc0208ee0 <disk0_close>:
ffffffffc0208ee0:	4501                	li	a0,0
ffffffffc0208ee2:	8082                	ret

ffffffffc0208ee4 <disk0_ioctl>:
ffffffffc0208ee4:	5531                	li	a0,-20
ffffffffc0208ee6:	8082                	ret

ffffffffc0208ee8 <disk0_io>:
ffffffffc0208ee8:	711d                	addi	sp,sp,-96
ffffffffc0208eea:	6594                	ld	a3,8(a1)
ffffffffc0208eec:	e8a2                	sd	s0,80(sp)
ffffffffc0208eee:	6d80                	ld	s0,24(a1)
ffffffffc0208ef0:	6785                	lui	a5,0x1
ffffffffc0208ef2:	17fd                	addi	a5,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208ef4:	0086e733          	or	a4,a3,s0
ffffffffc0208ef8:	ec86                	sd	ra,88(sp)
ffffffffc0208efa:	8f7d                	and	a4,a4,a5
ffffffffc0208efc:	14071663          	bnez	a4,ffffffffc0209048 <disk0_io+0x160>
ffffffffc0208f00:	e0ca                	sd	s2,64(sp)
ffffffffc0208f02:	43f6d913          	srai	s2,a3,0x3f
ffffffffc0208f06:	00f97933          	and	s2,s2,a5
ffffffffc0208f0a:	9936                	add	s2,s2,a3
ffffffffc0208f0c:	40c95913          	srai	s2,s2,0xc
ffffffffc0208f10:	00c45793          	srli	a5,s0,0xc
ffffffffc0208f14:	0127873b          	addw	a4,a5,s2
ffffffffc0208f18:	6114                	ld	a3,0(a0)
ffffffffc0208f1a:	1702                	slli	a4,a4,0x20
ffffffffc0208f1c:	9301                	srli	a4,a4,0x20
ffffffffc0208f1e:	2901                	sext.w	s2,s2
ffffffffc0208f20:	2781                	sext.w	a5,a5
ffffffffc0208f22:	12e6e063          	bltu	a3,a4,ffffffffc0209042 <disk0_io+0x15a>
ffffffffc0208f26:	e799                	bnez	a5,ffffffffc0208f34 <disk0_io+0x4c>
ffffffffc0208f28:	6906                	ld	s2,64(sp)
ffffffffc0208f2a:	4501                	li	a0,0
ffffffffc0208f2c:	60e6                	ld	ra,88(sp)
ffffffffc0208f2e:	6446                	ld	s0,80(sp)
ffffffffc0208f30:	6125                	addi	sp,sp,96
ffffffffc0208f32:	8082                	ret
ffffffffc0208f34:	0008e517          	auipc	a0,0x8e
ffffffffc0208f38:	90c50513          	addi	a0,a0,-1780 # ffffffffc0296840 <disk0_sem>
ffffffffc0208f3c:	e4a6                	sd	s1,72(sp)
ffffffffc0208f3e:	f852                	sd	s4,48(sp)
ffffffffc0208f40:	f456                	sd	s5,40(sp)
ffffffffc0208f42:	84b2                	mv	s1,a2
ffffffffc0208f44:	8aae                	mv	s5,a1
ffffffffc0208f46:	0008fa17          	auipc	s4,0x8f
ffffffffc0208f4a:	9baa0a13          	addi	s4,s4,-1606 # ffffffffc0297900 <disk0_buffer>
ffffffffc0208f4e:	ecafb0ef          	jal	ffffffffc0204618 <down>
ffffffffc0208f52:	000a3603          	ld	a2,0(s4)
ffffffffc0208f56:	e8ad                	bnez	s1,ffffffffc0208fc8 <disk0_io+0xe0>
ffffffffc0208f58:	e862                	sd	s8,16(sp)
ffffffffc0208f5a:	fc4e                	sd	s3,56(sp)
ffffffffc0208f5c:	ec5e                	sd	s7,24(sp)
ffffffffc0208f5e:	6c11                	lui	s8,0x4
ffffffffc0208f60:	a029                	j	ffffffffc0208f6a <disk0_io+0x82>
ffffffffc0208f62:	000a3603          	ld	a2,0(s4)
ffffffffc0208f66:	0129893b          	addw	s2,s3,s2
ffffffffc0208f6a:	84a2                	mv	s1,s0
ffffffffc0208f6c:	008c7363          	bgeu	s8,s0,ffffffffc0208f72 <disk0_io+0x8a>
ffffffffc0208f70:	6491                	lui	s1,0x4
ffffffffc0208f72:	00c4d993          	srli	s3,s1,0xc
ffffffffc0208f76:	2981                	sext.w	s3,s3
ffffffffc0208f78:	00399b9b          	slliw	s7,s3,0x3
ffffffffc0208f7c:	020b9693          	slli	a3,s7,0x20
ffffffffc0208f80:	9281                	srli	a3,a3,0x20
ffffffffc0208f82:	0039159b          	slliw	a1,s2,0x3
ffffffffc0208f86:	4509                	li	a0,2
ffffffffc0208f88:	baff70ef          	jal	ffffffffc0200b36 <ide_read_secs>
ffffffffc0208f8c:	e16d                	bnez	a0,ffffffffc020906e <disk0_io+0x186>
ffffffffc0208f8e:	000a3583          	ld	a1,0(s4)
ffffffffc0208f92:	0038                	addi	a4,sp,8
ffffffffc0208f94:	4685                	li	a3,1
ffffffffc0208f96:	8626                	mv	a2,s1
ffffffffc0208f98:	8556                	mv	a0,s5
ffffffffc0208f9a:	d1efc0ef          	jal	ffffffffc02054b8 <iobuf_move>
ffffffffc0208f9e:	67a2                	ld	a5,8(sp)
ffffffffc0208fa0:	0a979663          	bne	a5,s1,ffffffffc020904c <disk0_io+0x164>
ffffffffc0208fa4:	03449793          	slli	a5,s1,0x34
ffffffffc0208fa8:	e3d5                	bnez	a5,ffffffffc020904c <disk0_io+0x164>
ffffffffc0208faa:	8c05                	sub	s0,s0,s1
ffffffffc0208fac:	f85d                	bnez	s0,ffffffffc0208f62 <disk0_io+0x7a>
ffffffffc0208fae:	79e2                	ld	s3,56(sp)
ffffffffc0208fb0:	6be2                	ld	s7,24(sp)
ffffffffc0208fb2:	6c42                	ld	s8,16(sp)
ffffffffc0208fb4:	0008e517          	auipc	a0,0x8e
ffffffffc0208fb8:	88c50513          	addi	a0,a0,-1908 # ffffffffc0296840 <disk0_sem>
ffffffffc0208fbc:	e58fb0ef          	jal	ffffffffc0204614 <up>
ffffffffc0208fc0:	64a6                	ld	s1,72(sp)
ffffffffc0208fc2:	7a42                	ld	s4,48(sp)
ffffffffc0208fc4:	7aa2                	ld	s5,40(sp)
ffffffffc0208fc6:	b78d                	j	ffffffffc0208f28 <disk0_io+0x40>
ffffffffc0208fc8:	f05a                	sd	s6,32(sp)
ffffffffc0208fca:	a029                	j	ffffffffc0208fd4 <disk0_io+0xec>
ffffffffc0208fcc:	000a3603          	ld	a2,0(s4)
ffffffffc0208fd0:	0124893b          	addw	s2,s1,s2
ffffffffc0208fd4:	85b2                	mv	a1,a2
ffffffffc0208fd6:	0038                	addi	a4,sp,8
ffffffffc0208fd8:	4681                	li	a3,0
ffffffffc0208fda:	6611                	lui	a2,0x4
ffffffffc0208fdc:	8556                	mv	a0,s5
ffffffffc0208fde:	cdafc0ef          	jal	ffffffffc02054b8 <iobuf_move>
ffffffffc0208fe2:	67a2                	ld	a5,8(sp)
ffffffffc0208fe4:	fff78713          	addi	a4,a5,-1
ffffffffc0208fe8:	02877a63          	bgeu	a4,s0,ffffffffc020901c <disk0_io+0x134>
ffffffffc0208fec:	03479713          	slli	a4,a5,0x34
ffffffffc0208ff0:	e715                	bnez	a4,ffffffffc020901c <disk0_io+0x134>
ffffffffc0208ff2:	83b1                	srli	a5,a5,0xc
ffffffffc0208ff4:	0007849b          	sext.w	s1,a5
ffffffffc0208ff8:	00349b1b          	slliw	s6,s1,0x3
ffffffffc0208ffc:	000a3603          	ld	a2,0(s4)
ffffffffc0209000:	020b1693          	slli	a3,s6,0x20
ffffffffc0209004:	9281                	srli	a3,a3,0x20
ffffffffc0209006:	0039159b          	slliw	a1,s2,0x3
ffffffffc020900a:	4509                	li	a0,2
ffffffffc020900c:	bc5f70ef          	jal	ffffffffc0200bd0 <ide_write_secs>
ffffffffc0209010:	e151                	bnez	a0,ffffffffc0209094 <disk0_io+0x1ac>
ffffffffc0209012:	67a2                	ld	a5,8(sp)
ffffffffc0209014:	8c1d                	sub	s0,s0,a5
ffffffffc0209016:	f85d                	bnez	s0,ffffffffc0208fcc <disk0_io+0xe4>
ffffffffc0209018:	7b02                	ld	s6,32(sp)
ffffffffc020901a:	bf69                	j	ffffffffc0208fb4 <disk0_io+0xcc>
ffffffffc020901c:	00006697          	auipc	a3,0x6
ffffffffc0209020:	86468693          	addi	a3,a3,-1948 # ffffffffc020e880 <etext+0x2b48>
ffffffffc0209024:	00003617          	auipc	a2,0x3
ffffffffc0209028:	14c60613          	addi	a2,a2,332 # ffffffffc020c170 <etext+0x438>
ffffffffc020902c:	05700593          	li	a1,87
ffffffffc0209030:	00006517          	auipc	a0,0x6
ffffffffc0209034:	89050513          	addi	a0,a0,-1904 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc0209038:	fc4e                	sd	s3,56(sp)
ffffffffc020903a:	ec5e                	sd	s7,24(sp)
ffffffffc020903c:	e862                	sd	s8,16(sp)
ffffffffc020903e:	c0cf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209042:	6906                	ld	s2,64(sp)
ffffffffc0209044:	5575                	li	a0,-3
ffffffffc0209046:	b5dd                	j	ffffffffc0208f2c <disk0_io+0x44>
ffffffffc0209048:	5575                	li	a0,-3
ffffffffc020904a:	b5cd                	j	ffffffffc0208f2c <disk0_io+0x44>
ffffffffc020904c:	00006697          	auipc	a3,0x6
ffffffffc0209050:	92c68693          	addi	a3,a3,-1748 # ffffffffc020e978 <etext+0x2c40>
ffffffffc0209054:	00003617          	auipc	a2,0x3
ffffffffc0209058:	11c60613          	addi	a2,a2,284 # ffffffffc020c170 <etext+0x438>
ffffffffc020905c:	06200593          	li	a1,98
ffffffffc0209060:	00006517          	auipc	a0,0x6
ffffffffc0209064:	86050513          	addi	a0,a0,-1952 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc0209068:	f05a                	sd	s6,32(sp)
ffffffffc020906a:	be0f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020906e:	88aa                	mv	a7,a0
ffffffffc0209070:	885e                	mv	a6,s7
ffffffffc0209072:	87ce                	mv	a5,s3
ffffffffc0209074:	0039171b          	slliw	a4,s2,0x3
ffffffffc0209078:	86ca                	mv	a3,s2
ffffffffc020907a:	00006617          	auipc	a2,0x6
ffffffffc020907e:	8b660613          	addi	a2,a2,-1866 # ffffffffc020e930 <etext+0x2bf8>
ffffffffc0209082:	02d00593          	li	a1,45
ffffffffc0209086:	00006517          	auipc	a0,0x6
ffffffffc020908a:	83a50513          	addi	a0,a0,-1990 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc020908e:	f05a                	sd	s6,32(sp)
ffffffffc0209090:	bbaf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209094:	88aa                	mv	a7,a0
ffffffffc0209096:	885a                	mv	a6,s6
ffffffffc0209098:	87a6                	mv	a5,s1
ffffffffc020909a:	0039171b          	slliw	a4,s2,0x3
ffffffffc020909e:	86ca                	mv	a3,s2
ffffffffc02090a0:	00006617          	auipc	a2,0x6
ffffffffc02090a4:	84060613          	addi	a2,a2,-1984 # ffffffffc020e8e0 <etext+0x2ba8>
ffffffffc02090a8:	03700593          	li	a1,55
ffffffffc02090ac:	00006517          	auipc	a0,0x6
ffffffffc02090b0:	81450513          	addi	a0,a0,-2028 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc02090b4:	fc4e                	sd	s3,56(sp)
ffffffffc02090b6:	ec5e                	sd	s7,24(sp)
ffffffffc02090b8:	e862                	sd	s8,16(sp)
ffffffffc02090ba:	b90f70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02090be <dev_init_disk0>:
ffffffffc02090be:	1101                	addi	sp,sp,-32
ffffffffc02090c0:	ec06                	sd	ra,24(sp)
ffffffffc02090c2:	e822                	sd	s0,16(sp)
ffffffffc02090c4:	e426                	sd	s1,8(sp)
ffffffffc02090c6:	debff0ef          	jal	ffffffffc0208eb0 <dev_create_inode>
ffffffffc02090ca:	c541                	beqz	a0,ffffffffc0209152 <dev_init_disk0+0x94>
ffffffffc02090cc:	4d38                	lw	a4,88(a0)
ffffffffc02090ce:	6785                	lui	a5,0x1
ffffffffc02090d0:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02090d4:	842a                	mv	s0,a0
ffffffffc02090d6:	6485                	lui	s1,0x1
ffffffffc02090d8:	0cf71e63          	bne	a4,a5,ffffffffc02091b4 <dev_init_disk0+0xf6>
ffffffffc02090dc:	4509                	li	a0,2
ffffffffc02090de:	a0df70ef          	jal	ffffffffc0200aea <ide_device_valid>
ffffffffc02090e2:	cd4d                	beqz	a0,ffffffffc020919c <dev_init_disk0+0xde>
ffffffffc02090e4:	4509                	li	a0,2
ffffffffc02090e6:	a29f70ef          	jal	ffffffffc0200b0e <ide_device_size>
ffffffffc02090ea:	00000797          	auipc	a5,0x0
ffffffffc02090ee:	dfa78793          	addi	a5,a5,-518 # ffffffffc0208ee4 <disk0_ioctl>
ffffffffc02090f2:	00000617          	auipc	a2,0x0
ffffffffc02090f6:	dea60613          	addi	a2,a2,-534 # ffffffffc0208edc <disk0_open>
ffffffffc02090fa:	00000697          	auipc	a3,0x0
ffffffffc02090fe:	de668693          	addi	a3,a3,-538 # ffffffffc0208ee0 <disk0_close>
ffffffffc0209102:	00000717          	auipc	a4,0x0
ffffffffc0209106:	de670713          	addi	a4,a4,-538 # ffffffffc0208ee8 <disk0_io>
ffffffffc020910a:	810d                	srli	a0,a0,0x3
ffffffffc020910c:	f41c                	sd	a5,40(s0)
ffffffffc020910e:	e008                	sd	a0,0(s0)
ffffffffc0209110:	e810                	sd	a2,16(s0)
ffffffffc0209112:	ec14                	sd	a3,24(s0)
ffffffffc0209114:	f018                	sd	a4,32(s0)
ffffffffc0209116:	4585                	li	a1,1
ffffffffc0209118:	0008d517          	auipc	a0,0x8d
ffffffffc020911c:	72850513          	addi	a0,a0,1832 # ffffffffc0296840 <disk0_sem>
ffffffffc0209120:	e404                	sd	s1,8(s0)
ffffffffc0209122:	cecfb0ef          	jal	ffffffffc020460e <sem_init>
ffffffffc0209126:	6511                	lui	a0,0x4
ffffffffc0209128:	860f90ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020912c:	0008e797          	auipc	a5,0x8e
ffffffffc0209130:	7ca7ba23          	sd	a0,2004(a5) # ffffffffc0297900 <disk0_buffer>
ffffffffc0209134:	c921                	beqz	a0,ffffffffc0209184 <dev_init_disk0+0xc6>
ffffffffc0209136:	85a2                	mv	a1,s0
ffffffffc0209138:	4605                	li	a2,1
ffffffffc020913a:	00006517          	auipc	a0,0x6
ffffffffc020913e:	8ce50513          	addi	a0,a0,-1842 # ffffffffc020ea08 <etext+0x2cd0>
ffffffffc0209142:	c26ff0ef          	jal	ffffffffc0208568 <vfs_add_dev>
ffffffffc0209146:	e115                	bnez	a0,ffffffffc020916a <dev_init_disk0+0xac>
ffffffffc0209148:	60e2                	ld	ra,24(sp)
ffffffffc020914a:	6442                	ld	s0,16(sp)
ffffffffc020914c:	64a2                	ld	s1,8(sp)
ffffffffc020914e:	6105                	addi	sp,sp,32
ffffffffc0209150:	8082                	ret
ffffffffc0209152:	00006617          	auipc	a2,0x6
ffffffffc0209156:	85660613          	addi	a2,a2,-1962 # ffffffffc020e9a8 <etext+0x2c70>
ffffffffc020915a:	08700593          	li	a1,135
ffffffffc020915e:	00005517          	auipc	a0,0x5
ffffffffc0209162:	76250513          	addi	a0,a0,1890 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc0209166:	ae4f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020916a:	86aa                	mv	a3,a0
ffffffffc020916c:	00006617          	auipc	a2,0x6
ffffffffc0209170:	8a460613          	addi	a2,a2,-1884 # ffffffffc020ea10 <etext+0x2cd8>
ffffffffc0209174:	08d00593          	li	a1,141
ffffffffc0209178:	00005517          	auipc	a0,0x5
ffffffffc020917c:	74850513          	addi	a0,a0,1864 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc0209180:	acaf70ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209184:	00006617          	auipc	a2,0x6
ffffffffc0209188:	86460613          	addi	a2,a2,-1948 # ffffffffc020e9e8 <etext+0x2cb0>
ffffffffc020918c:	07f00593          	li	a1,127
ffffffffc0209190:	00005517          	auipc	a0,0x5
ffffffffc0209194:	73050513          	addi	a0,a0,1840 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc0209198:	ab2f70ef          	jal	ffffffffc020044a <__panic>
ffffffffc020919c:	00006617          	auipc	a2,0x6
ffffffffc02091a0:	82c60613          	addi	a2,a2,-2004 # ffffffffc020e9c8 <etext+0x2c90>
ffffffffc02091a4:	07300593          	li	a1,115
ffffffffc02091a8:	00005517          	auipc	a0,0x5
ffffffffc02091ac:	71850513          	addi	a0,a0,1816 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc02091b0:	a9af70ef          	jal	ffffffffc020044a <__panic>
ffffffffc02091b4:	00005697          	auipc	a3,0x5
ffffffffc02091b8:	3a468693          	addi	a3,a3,932 # ffffffffc020e558 <etext+0x2820>
ffffffffc02091bc:	00003617          	auipc	a2,0x3
ffffffffc02091c0:	fb460613          	addi	a2,a2,-76 # ffffffffc020c170 <etext+0x438>
ffffffffc02091c4:	08900593          	li	a1,137
ffffffffc02091c8:	00005517          	auipc	a0,0x5
ffffffffc02091cc:	6f850513          	addi	a0,a0,1784 # ffffffffc020e8c0 <etext+0x2b88>
ffffffffc02091d0:	a7af70ef          	jal	ffffffffc020044a <__panic>

ffffffffc02091d4 <stdin_open>:
ffffffffc02091d4:	e199                	bnez	a1,ffffffffc02091da <stdin_open+0x6>
ffffffffc02091d6:	4501                	li	a0,0
ffffffffc02091d8:	8082                	ret
ffffffffc02091da:	5575                	li	a0,-3
ffffffffc02091dc:	8082                	ret

ffffffffc02091de <stdin_close>:
ffffffffc02091de:	4501                	li	a0,0
ffffffffc02091e0:	8082                	ret

ffffffffc02091e2 <stdin_ioctl>:
ffffffffc02091e2:	5575                	li	a0,-3
ffffffffc02091e4:	8082                	ret

ffffffffc02091e6 <stdin_io>:
ffffffffc02091e6:	14061f63          	bnez	a2,ffffffffc0209344 <stdin_io+0x15e>
ffffffffc02091ea:	7175                	addi	sp,sp,-144
ffffffffc02091ec:	ecd6                	sd	s5,88(sp)
ffffffffc02091ee:	e8da                	sd	s6,80(sp)
ffffffffc02091f0:	e4de                	sd	s7,72(sp)
ffffffffc02091f2:	0185bb03          	ld	s6,24(a1)
ffffffffc02091f6:	0005bb83          	ld	s7,0(a1)
ffffffffc02091fa:	e506                	sd	ra,136(sp)
ffffffffc02091fc:	e122                	sd	s0,128(sp)
ffffffffc02091fe:	8aae                	mv	s5,a1
ffffffffc0209200:	100027f3          	csrr	a5,sstatus
ffffffffc0209204:	8b89                	andi	a5,a5,2
ffffffffc0209206:	12079663          	bnez	a5,ffffffffc0209332 <stdin_io+0x14c>
ffffffffc020920a:	4401                	li	s0,0
ffffffffc020920c:	120b0a63          	beqz	s6,ffffffffc0209340 <stdin_io+0x15a>
ffffffffc0209210:	f8ca                	sd	s2,112(sp)
ffffffffc0209212:	0008e917          	auipc	s2,0x8e
ffffffffc0209216:	6fe90913          	addi	s2,s2,1790 # ffffffffc0297910 <p_rpos>
ffffffffc020921a:	00093783          	ld	a5,0(s2)
ffffffffc020921e:	fca6                	sd	s1,120(sp)
ffffffffc0209220:	6705                	lui	a4,0x1
ffffffffc0209222:	800004b7          	lui	s1,0x80000
ffffffffc0209226:	f4ce                	sd	s3,104(sp)
ffffffffc0209228:	f0d2                	sd	s4,96(sp)
ffffffffc020922a:	e0e2                	sd	s8,64(sp)
ffffffffc020922c:	0491                	addi	s1,s1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc020922e:	fff70c13          	addi	s8,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209232:	4a01                	li	s4,0
ffffffffc0209234:	0008e997          	auipc	s3,0x8e
ffffffffc0209238:	6d498993          	addi	s3,s3,1748 # ffffffffc0297908 <p_wpos>
ffffffffc020923c:	0009b703          	ld	a4,0(s3)
ffffffffc0209240:	02e7d763          	bge	a5,a4,ffffffffc020926e <stdin_io+0x88>
ffffffffc0209244:	a045                	j	ffffffffc02092e4 <stdin_io+0xfe>
ffffffffc0209246:	fd2fe0ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc020924a:	100027f3          	csrr	a5,sstatus
ffffffffc020924e:	8b89                	andi	a5,a5,2
ffffffffc0209250:	4401                	li	s0,0
ffffffffc0209252:	e3b1                	bnez	a5,ffffffffc0209296 <stdin_io+0xb0>
ffffffffc0209254:	0828                	addi	a0,sp,24
ffffffffc0209256:	c52fb0ef          	jal	ffffffffc02046a8 <wait_in_queue>
ffffffffc020925a:	e529                	bnez	a0,ffffffffc02092a4 <stdin_io+0xbe>
ffffffffc020925c:	5782                	lw	a5,32(sp)
ffffffffc020925e:	04979d63          	bne	a5,s1,ffffffffc02092b8 <stdin_io+0xd2>
ffffffffc0209262:	00093783          	ld	a5,0(s2)
ffffffffc0209266:	0009b703          	ld	a4,0(s3)
ffffffffc020926a:	06e7cd63          	blt	a5,a4,ffffffffc02092e4 <stdin_io+0xfe>
ffffffffc020926e:	80000637          	lui	a2,0x80000
ffffffffc0209272:	0611                	addi	a2,a2,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc0209274:	082c                	addi	a1,sp,24
ffffffffc0209276:	0008d517          	auipc	a0,0x8d
ffffffffc020927a:	5e250513          	addi	a0,a0,1506 # ffffffffc0296858 <__wait_queue>
ffffffffc020927e:	d56fb0ef          	jal	ffffffffc02047d4 <wait_current_set>
ffffffffc0209282:	d071                	beqz	s0,ffffffffc0209246 <stdin_io+0x60>
ffffffffc0209284:	9e7f70ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0209288:	f90fe0ef          	jal	ffffffffc0207a18 <schedule>
ffffffffc020928c:	100027f3          	csrr	a5,sstatus
ffffffffc0209290:	8b89                	andi	a5,a5,2
ffffffffc0209292:	4401                	li	s0,0
ffffffffc0209294:	d3e1                	beqz	a5,ffffffffc0209254 <stdin_io+0x6e>
ffffffffc0209296:	9dbf70ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc020929a:	0828                	addi	a0,sp,24
ffffffffc020929c:	4405                	li	s0,1
ffffffffc020929e:	c0afb0ef          	jal	ffffffffc02046a8 <wait_in_queue>
ffffffffc02092a2:	dd4d                	beqz	a0,ffffffffc020925c <stdin_io+0x76>
ffffffffc02092a4:	082c                	addi	a1,sp,24
ffffffffc02092a6:	0008d517          	auipc	a0,0x8d
ffffffffc02092aa:	5b250513          	addi	a0,a0,1458 # ffffffffc0296858 <__wait_queue>
ffffffffc02092ae:	ba0fb0ef          	jal	ffffffffc020464e <wait_queue_del>
ffffffffc02092b2:	5782                	lw	a5,32(sp)
ffffffffc02092b4:	fa9787e3          	beq	a5,s1,ffffffffc0209262 <stdin_io+0x7c>
ffffffffc02092b8:	000a051b          	sext.w	a0,s4
ffffffffc02092bc:	e42d                	bnez	s0,ffffffffc0209326 <stdin_io+0x140>
ffffffffc02092be:	c519                	beqz	a0,ffffffffc02092cc <stdin_io+0xe6>
ffffffffc02092c0:	018ab783          	ld	a5,24(s5)
ffffffffc02092c4:	414787b3          	sub	a5,a5,s4
ffffffffc02092c8:	00fabc23          	sd	a5,24(s5)
ffffffffc02092cc:	74e6                	ld	s1,120(sp)
ffffffffc02092ce:	7946                	ld	s2,112(sp)
ffffffffc02092d0:	79a6                	ld	s3,104(sp)
ffffffffc02092d2:	7a06                	ld	s4,96(sp)
ffffffffc02092d4:	6c06                	ld	s8,64(sp)
ffffffffc02092d6:	60aa                	ld	ra,136(sp)
ffffffffc02092d8:	640a                	ld	s0,128(sp)
ffffffffc02092da:	6ae6                	ld	s5,88(sp)
ffffffffc02092dc:	6b46                	ld	s6,80(sp)
ffffffffc02092de:	6ba6                	ld	s7,72(sp)
ffffffffc02092e0:	6149                	addi	sp,sp,144
ffffffffc02092e2:	8082                	ret
ffffffffc02092e4:	43f7d693          	srai	a3,a5,0x3f
ffffffffc02092e8:	92d1                	srli	a3,a3,0x34
ffffffffc02092ea:	00d78733          	add	a4,a5,a3
ffffffffc02092ee:	01877733          	and	a4,a4,s8
ffffffffc02092f2:	8f15                	sub	a4,a4,a3
ffffffffc02092f4:	0008d697          	auipc	a3,0x8d
ffffffffc02092f8:	57468693          	addi	a3,a3,1396 # ffffffffc0296868 <stdin_buffer>
ffffffffc02092fc:	9736                	add	a4,a4,a3
ffffffffc02092fe:	00074683          	lbu	a3,0(a4)
ffffffffc0209302:	0785                	addi	a5,a5,1
ffffffffc0209304:	014b8733          	add	a4,s7,s4
ffffffffc0209308:	001a051b          	addiw	a0,s4,1
ffffffffc020930c:	00f93023          	sd	a5,0(s2)
ffffffffc0209310:	00d70023          	sb	a3,0(a4)
ffffffffc0209314:	0a05                	addi	s4,s4,1
ffffffffc0209316:	f36a63e3          	bltu	s4,s6,ffffffffc020923c <stdin_io+0x56>
ffffffffc020931a:	d05d                	beqz	s0,ffffffffc02092c0 <stdin_io+0xda>
ffffffffc020931c:	e42a                	sd	a0,8(sp)
ffffffffc020931e:	94df70ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0209322:	6522                	ld	a0,8(sp)
ffffffffc0209324:	bf71                	j	ffffffffc02092c0 <stdin_io+0xda>
ffffffffc0209326:	e42a                	sd	a0,8(sp)
ffffffffc0209328:	943f70ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc020932c:	6522                	ld	a0,8(sp)
ffffffffc020932e:	f949                	bnez	a0,ffffffffc02092c0 <stdin_io+0xda>
ffffffffc0209330:	bf71                	j	ffffffffc02092cc <stdin_io+0xe6>
ffffffffc0209332:	93ff70ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc0209336:	4405                	li	s0,1
ffffffffc0209338:	ec0b1ce3          	bnez	s6,ffffffffc0209210 <stdin_io+0x2a>
ffffffffc020933c:	92ff70ef          	jal	ffffffffc0200c6a <intr_enable>
ffffffffc0209340:	4501                	li	a0,0
ffffffffc0209342:	bf51                	j	ffffffffc02092d6 <stdin_io+0xf0>
ffffffffc0209344:	5575                	li	a0,-3
ffffffffc0209346:	8082                	ret

ffffffffc0209348 <dev_stdin_write>:
ffffffffc0209348:	e111                	bnez	a0,ffffffffc020934c <dev_stdin_write+0x4>
ffffffffc020934a:	8082                	ret
ffffffffc020934c:	1101                	addi	sp,sp,-32
ffffffffc020934e:	ec06                	sd	ra,24(sp)
ffffffffc0209350:	e822                	sd	s0,16(sp)
ffffffffc0209352:	100027f3          	csrr	a5,sstatus
ffffffffc0209356:	8b89                	andi	a5,a5,2
ffffffffc0209358:	4401                	li	s0,0
ffffffffc020935a:	e3c1                	bnez	a5,ffffffffc02093da <dev_stdin_write+0x92>
ffffffffc020935c:	0008e717          	auipc	a4,0x8e
ffffffffc0209360:	5ac73703          	ld	a4,1452(a4) # ffffffffc0297908 <p_wpos>
ffffffffc0209364:	6585                	lui	a1,0x1
ffffffffc0209366:	fff58613          	addi	a2,a1,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020936a:	43f75693          	srai	a3,a4,0x3f
ffffffffc020936e:	92d1                	srli	a3,a3,0x34
ffffffffc0209370:	00d707b3          	add	a5,a4,a3
ffffffffc0209374:	8ff1                	and	a5,a5,a2
ffffffffc0209376:	0008e617          	auipc	a2,0x8e
ffffffffc020937a:	59a63603          	ld	a2,1434(a2) # ffffffffc0297910 <p_rpos>
ffffffffc020937e:	8f95                	sub	a5,a5,a3
ffffffffc0209380:	0008d697          	auipc	a3,0x8d
ffffffffc0209384:	4e868693          	addi	a3,a3,1256 # ffffffffc0296868 <stdin_buffer>
ffffffffc0209388:	97b6                	add	a5,a5,a3
ffffffffc020938a:	00a78023          	sb	a0,0(a5)
ffffffffc020938e:	40c707b3          	sub	a5,a4,a2
ffffffffc0209392:	00b7d763          	bge	a5,a1,ffffffffc02093a0 <dev_stdin_write+0x58>
ffffffffc0209396:	0705                	addi	a4,a4,1
ffffffffc0209398:	0008e797          	auipc	a5,0x8e
ffffffffc020939c:	56e7b823          	sd	a4,1392(a5) # ffffffffc0297908 <p_wpos>
ffffffffc02093a0:	0008d517          	auipc	a0,0x8d
ffffffffc02093a4:	4b850513          	addi	a0,a0,1208 # ffffffffc0296858 <__wait_queue>
ffffffffc02093a8:	af4fb0ef          	jal	ffffffffc020469c <wait_queue_empty>
ffffffffc02093ac:	c919                	beqz	a0,ffffffffc02093c2 <dev_stdin_write+0x7a>
ffffffffc02093ae:	e409                	bnez	s0,ffffffffc02093b8 <dev_stdin_write+0x70>
ffffffffc02093b0:	60e2                	ld	ra,24(sp)
ffffffffc02093b2:	6442                	ld	s0,16(sp)
ffffffffc02093b4:	6105                	addi	sp,sp,32
ffffffffc02093b6:	8082                	ret
ffffffffc02093b8:	6442                	ld	s0,16(sp)
ffffffffc02093ba:	60e2                	ld	ra,24(sp)
ffffffffc02093bc:	6105                	addi	sp,sp,32
ffffffffc02093be:	8adf706f          	j	ffffffffc0200c6a <intr_enable>
ffffffffc02093c2:	800005b7          	lui	a1,0x80000
ffffffffc02093c6:	0591                	addi	a1,a1,4 # ffffffff80000004 <_binary_bin_sfs_img_size+0xffffffff7ff8ad04>
ffffffffc02093c8:	4605                	li	a2,1
ffffffffc02093ca:	0008d517          	auipc	a0,0x8d
ffffffffc02093ce:	48e50513          	addi	a0,a0,1166 # ffffffffc0296858 <__wait_queue>
ffffffffc02093d2:	b32fb0ef          	jal	ffffffffc0204704 <wakeup_queue>
ffffffffc02093d6:	dc69                	beqz	s0,ffffffffc02093b0 <dev_stdin_write+0x68>
ffffffffc02093d8:	b7c5                	j	ffffffffc02093b8 <dev_stdin_write+0x70>
ffffffffc02093da:	e42a                	sd	a0,8(sp)
ffffffffc02093dc:	895f70ef          	jal	ffffffffc0200c70 <intr_disable>
ffffffffc02093e0:	6522                	ld	a0,8(sp)
ffffffffc02093e2:	4405                	li	s0,1
ffffffffc02093e4:	bfa5                	j	ffffffffc020935c <dev_stdin_write+0x14>

ffffffffc02093e6 <dev_init_stdin>:
ffffffffc02093e6:	1101                	addi	sp,sp,-32
ffffffffc02093e8:	ec06                	sd	ra,24(sp)
ffffffffc02093ea:	ac7ff0ef          	jal	ffffffffc0208eb0 <dev_create_inode>
ffffffffc02093ee:	c935                	beqz	a0,ffffffffc0209462 <dev_init_stdin+0x7c>
ffffffffc02093f0:	4d38                	lw	a4,88(a0)
ffffffffc02093f2:	6785                	lui	a5,0x1
ffffffffc02093f4:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02093f8:	08f71e63          	bne	a4,a5,ffffffffc0209494 <dev_init_stdin+0xae>
ffffffffc02093fc:	4785                	li	a5,1
ffffffffc02093fe:	e51c                	sd	a5,8(a0)
ffffffffc0209400:	00000797          	auipc	a5,0x0
ffffffffc0209404:	dd478793          	addi	a5,a5,-556 # ffffffffc02091d4 <stdin_open>
ffffffffc0209408:	e91c                	sd	a5,16(a0)
ffffffffc020940a:	00000797          	auipc	a5,0x0
ffffffffc020940e:	dd478793          	addi	a5,a5,-556 # ffffffffc02091de <stdin_close>
ffffffffc0209412:	ed1c                	sd	a5,24(a0)
ffffffffc0209414:	00000797          	auipc	a5,0x0
ffffffffc0209418:	dd278793          	addi	a5,a5,-558 # ffffffffc02091e6 <stdin_io>
ffffffffc020941c:	f11c                	sd	a5,32(a0)
ffffffffc020941e:	00000797          	auipc	a5,0x0
ffffffffc0209422:	dc478793          	addi	a5,a5,-572 # ffffffffc02091e2 <stdin_ioctl>
ffffffffc0209426:	f51c                	sd	a5,40(a0)
ffffffffc0209428:	00053023          	sd	zero,0(a0)
ffffffffc020942c:	e42a                	sd	a0,8(sp)
ffffffffc020942e:	0008d517          	auipc	a0,0x8d
ffffffffc0209432:	42a50513          	addi	a0,a0,1066 # ffffffffc0296858 <__wait_queue>
ffffffffc0209436:	0008e797          	auipc	a5,0x8e
ffffffffc020943a:	4c07b923          	sd	zero,1234(a5) # ffffffffc0297908 <p_wpos>
ffffffffc020943e:	0008e797          	auipc	a5,0x8e
ffffffffc0209442:	4c07b923          	sd	zero,1234(a5) # ffffffffc0297910 <p_rpos>
ffffffffc0209446:	a02fb0ef          	jal	ffffffffc0204648 <wait_queue_init>
ffffffffc020944a:	65a2                	ld	a1,8(sp)
ffffffffc020944c:	4601                	li	a2,0
ffffffffc020944e:	00005517          	auipc	a0,0x5
ffffffffc0209452:	62250513          	addi	a0,a0,1570 # ffffffffc020ea70 <etext+0x2d38>
ffffffffc0209456:	912ff0ef          	jal	ffffffffc0208568 <vfs_add_dev>
ffffffffc020945a:	e105                	bnez	a0,ffffffffc020947a <dev_init_stdin+0x94>
ffffffffc020945c:	60e2                	ld	ra,24(sp)
ffffffffc020945e:	6105                	addi	sp,sp,32
ffffffffc0209460:	8082                	ret
ffffffffc0209462:	00005617          	auipc	a2,0x5
ffffffffc0209466:	5ce60613          	addi	a2,a2,1486 # ffffffffc020ea30 <etext+0x2cf8>
ffffffffc020946a:	07500593          	li	a1,117
ffffffffc020946e:	00005517          	auipc	a0,0x5
ffffffffc0209472:	5e250513          	addi	a0,a0,1506 # ffffffffc020ea50 <etext+0x2d18>
ffffffffc0209476:	fd5f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020947a:	86aa                	mv	a3,a0
ffffffffc020947c:	00005617          	auipc	a2,0x5
ffffffffc0209480:	5fc60613          	addi	a2,a2,1532 # ffffffffc020ea78 <etext+0x2d40>
ffffffffc0209484:	07b00593          	li	a1,123
ffffffffc0209488:	00005517          	auipc	a0,0x5
ffffffffc020948c:	5c850513          	addi	a0,a0,1480 # ffffffffc020ea50 <etext+0x2d18>
ffffffffc0209490:	fbbf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209494:	00005697          	auipc	a3,0x5
ffffffffc0209498:	0c468693          	addi	a3,a3,196 # ffffffffc020e558 <etext+0x2820>
ffffffffc020949c:	00003617          	auipc	a2,0x3
ffffffffc02094a0:	cd460613          	addi	a2,a2,-812 # ffffffffc020c170 <etext+0x438>
ffffffffc02094a4:	07700593          	li	a1,119
ffffffffc02094a8:	00005517          	auipc	a0,0x5
ffffffffc02094ac:	5a850513          	addi	a0,a0,1448 # ffffffffc020ea50 <etext+0x2d18>
ffffffffc02094b0:	f9bf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02094b4 <stdout_open>:
ffffffffc02094b4:	4785                	li	a5,1
ffffffffc02094b6:	00f59463          	bne	a1,a5,ffffffffc02094be <stdout_open+0xa>
ffffffffc02094ba:	4501                	li	a0,0
ffffffffc02094bc:	8082                	ret
ffffffffc02094be:	5575                	li	a0,-3
ffffffffc02094c0:	8082                	ret

ffffffffc02094c2 <stdout_close>:
ffffffffc02094c2:	4501                	li	a0,0
ffffffffc02094c4:	8082                	ret

ffffffffc02094c6 <stdout_ioctl>:
ffffffffc02094c6:	5575                	li	a0,-3
ffffffffc02094c8:	8082                	ret

ffffffffc02094ca <stdout_io>:
ffffffffc02094ca:	ca15                	beqz	a2,ffffffffc02094fe <stdout_io+0x34>
ffffffffc02094cc:	6d9c                	ld	a5,24(a1)
ffffffffc02094ce:	c795                	beqz	a5,ffffffffc02094fa <stdout_io+0x30>
ffffffffc02094d0:	1101                	addi	sp,sp,-32
ffffffffc02094d2:	e822                	sd	s0,16(sp)
ffffffffc02094d4:	6180                	ld	s0,0(a1)
ffffffffc02094d6:	e426                	sd	s1,8(sp)
ffffffffc02094d8:	ec06                	sd	ra,24(sp)
ffffffffc02094da:	84ae                	mv	s1,a1
ffffffffc02094dc:	00044503          	lbu	a0,0(s0)
ffffffffc02094e0:	0405                	addi	s0,s0,1
ffffffffc02094e2:	cfff60ef          	jal	ffffffffc02001e0 <cputchar>
ffffffffc02094e6:	6c9c                	ld	a5,24(s1)
ffffffffc02094e8:	17fd                	addi	a5,a5,-1
ffffffffc02094ea:	ec9c                	sd	a5,24(s1)
ffffffffc02094ec:	fbe5                	bnez	a5,ffffffffc02094dc <stdout_io+0x12>
ffffffffc02094ee:	60e2                	ld	ra,24(sp)
ffffffffc02094f0:	6442                	ld	s0,16(sp)
ffffffffc02094f2:	64a2                	ld	s1,8(sp)
ffffffffc02094f4:	4501                	li	a0,0
ffffffffc02094f6:	6105                	addi	sp,sp,32
ffffffffc02094f8:	8082                	ret
ffffffffc02094fa:	4501                	li	a0,0
ffffffffc02094fc:	8082                	ret
ffffffffc02094fe:	5575                	li	a0,-3
ffffffffc0209500:	8082                	ret

ffffffffc0209502 <dev_init_stdout>:
ffffffffc0209502:	1141                	addi	sp,sp,-16
ffffffffc0209504:	e406                	sd	ra,8(sp)
ffffffffc0209506:	9abff0ef          	jal	ffffffffc0208eb0 <dev_create_inode>
ffffffffc020950a:	c939                	beqz	a0,ffffffffc0209560 <dev_init_stdout+0x5e>
ffffffffc020950c:	4d38                	lw	a4,88(a0)
ffffffffc020950e:	6785                	lui	a5,0x1
ffffffffc0209510:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0209514:	06f71f63          	bne	a4,a5,ffffffffc0209592 <dev_init_stdout+0x90>
ffffffffc0209518:	4785                	li	a5,1
ffffffffc020951a:	e51c                	sd	a5,8(a0)
ffffffffc020951c:	00000797          	auipc	a5,0x0
ffffffffc0209520:	f9878793          	addi	a5,a5,-104 # ffffffffc02094b4 <stdout_open>
ffffffffc0209524:	e91c                	sd	a5,16(a0)
ffffffffc0209526:	00000797          	auipc	a5,0x0
ffffffffc020952a:	f9c78793          	addi	a5,a5,-100 # ffffffffc02094c2 <stdout_close>
ffffffffc020952e:	ed1c                	sd	a5,24(a0)
ffffffffc0209530:	00000797          	auipc	a5,0x0
ffffffffc0209534:	f9a78793          	addi	a5,a5,-102 # ffffffffc02094ca <stdout_io>
ffffffffc0209538:	f11c                	sd	a5,32(a0)
ffffffffc020953a:	00000797          	auipc	a5,0x0
ffffffffc020953e:	f8c78793          	addi	a5,a5,-116 # ffffffffc02094c6 <stdout_ioctl>
ffffffffc0209542:	f51c                	sd	a5,40(a0)
ffffffffc0209544:	00053023          	sd	zero,0(a0)
ffffffffc0209548:	85aa                	mv	a1,a0
ffffffffc020954a:	4601                	li	a2,0
ffffffffc020954c:	00005517          	auipc	a0,0x5
ffffffffc0209550:	58c50513          	addi	a0,a0,1420 # ffffffffc020ead8 <etext+0x2da0>
ffffffffc0209554:	814ff0ef          	jal	ffffffffc0208568 <vfs_add_dev>
ffffffffc0209558:	e105                	bnez	a0,ffffffffc0209578 <dev_init_stdout+0x76>
ffffffffc020955a:	60a2                	ld	ra,8(sp)
ffffffffc020955c:	0141                	addi	sp,sp,16
ffffffffc020955e:	8082                	ret
ffffffffc0209560:	00005617          	auipc	a2,0x5
ffffffffc0209564:	53860613          	addi	a2,a2,1336 # ffffffffc020ea98 <etext+0x2d60>
ffffffffc0209568:	03700593          	li	a1,55
ffffffffc020956c:	00005517          	auipc	a0,0x5
ffffffffc0209570:	54c50513          	addi	a0,a0,1356 # ffffffffc020eab8 <etext+0x2d80>
ffffffffc0209574:	ed7f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209578:	86aa                	mv	a3,a0
ffffffffc020957a:	00005617          	auipc	a2,0x5
ffffffffc020957e:	56660613          	addi	a2,a2,1382 # ffffffffc020eae0 <etext+0x2da8>
ffffffffc0209582:	03d00593          	li	a1,61
ffffffffc0209586:	00005517          	auipc	a0,0x5
ffffffffc020958a:	53250513          	addi	a0,a0,1330 # ffffffffc020eab8 <etext+0x2d80>
ffffffffc020958e:	ebdf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209592:	00005697          	auipc	a3,0x5
ffffffffc0209596:	fc668693          	addi	a3,a3,-58 # ffffffffc020e558 <etext+0x2820>
ffffffffc020959a:	00003617          	auipc	a2,0x3
ffffffffc020959e:	bd660613          	addi	a2,a2,-1066 # ffffffffc020c170 <etext+0x438>
ffffffffc02095a2:	03900593          	li	a1,57
ffffffffc02095a6:	00005517          	auipc	a0,0x5
ffffffffc02095aa:	51250513          	addi	a0,a0,1298 # ffffffffc020eab8 <etext+0x2d80>
ffffffffc02095ae:	e9df60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02095b2 <bitmap_translate.part.0>:
ffffffffc02095b2:	1141                	addi	sp,sp,-16
ffffffffc02095b4:	00005697          	auipc	a3,0x5
ffffffffc02095b8:	54c68693          	addi	a3,a3,1356 # ffffffffc020eb00 <etext+0x2dc8>
ffffffffc02095bc:	00003617          	auipc	a2,0x3
ffffffffc02095c0:	bb460613          	addi	a2,a2,-1100 # ffffffffc020c170 <etext+0x438>
ffffffffc02095c4:	04c00593          	li	a1,76
ffffffffc02095c8:	00005517          	auipc	a0,0x5
ffffffffc02095cc:	55050513          	addi	a0,a0,1360 # ffffffffc020eb18 <etext+0x2de0>
ffffffffc02095d0:	e406                	sd	ra,8(sp)
ffffffffc02095d2:	e79f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02095d6 <bitmap_create>:
ffffffffc02095d6:	7139                	addi	sp,sp,-64
ffffffffc02095d8:	fc06                	sd	ra,56(sp)
ffffffffc02095da:	f822                	sd	s0,48(sp)
ffffffffc02095dc:	f426                	sd	s1,40(sp)
ffffffffc02095de:	c179                	beqz	a0,ffffffffc02096a4 <bitmap_create+0xce>
ffffffffc02095e0:	842a                	mv	s0,a0
ffffffffc02095e2:	4541                	li	a0,16
ffffffffc02095e4:	ba5f80ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc02095e8:	84aa                	mv	s1,a0
ffffffffc02095ea:	c555                	beqz	a0,ffffffffc0209696 <bitmap_create+0xc0>
ffffffffc02095ec:	e852                	sd	s4,16(sp)
ffffffffc02095ee:	02041a13          	slli	s4,s0,0x20
ffffffffc02095f2:	020a5a13          	srli	s4,s4,0x20
ffffffffc02095f6:	f04a                	sd	s2,32(sp)
ffffffffc02095f8:	01fa0913          	addi	s2,s4,31
ffffffffc02095fc:	ec4e                	sd	s3,24(sp)
ffffffffc02095fe:	00595993          	srli	s3,s2,0x5
ffffffffc0209602:	00299613          	slli	a2,s3,0x2
ffffffffc0209606:	8532                	mv	a0,a2
ffffffffc0209608:	e432                	sd	a2,8(sp)
ffffffffc020960a:	b7ff80ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020960e:	6622                	ld	a2,8(sp)
ffffffffc0209610:	cd2d                	beqz	a0,ffffffffc020968a <bitmap_create+0xb4>
ffffffffc0209612:	c080                	sw	s0,0(s1)
ffffffffc0209614:	0134a223          	sw	s3,4(s1)
ffffffffc0209618:	0ff00593          	li	a1,255
ffffffffc020961c:	6b4020ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0209620:	4785                	li	a5,1
ffffffffc0209622:	1796                	slli	a5,a5,0x25
ffffffffc0209624:	1781                	addi	a5,a5,-32
ffffffffc0209626:	e488                	sd	a0,8(s1)
ffffffffc0209628:	00f97933          	and	s2,s2,a5
ffffffffc020962c:	052a0663          	beq	s4,s2,ffffffffc0209678 <bitmap_create+0xa2>
ffffffffc0209630:	39fd                	addiw	s3,s3,-1
ffffffffc0209632:	0054571b          	srliw	a4,s0,0x5
ffffffffc0209636:	0b371963          	bne	a4,s3,ffffffffc02096e8 <bitmap_create+0x112>
ffffffffc020963a:	0057179b          	slliw	a5,a4,0x5
ffffffffc020963e:	40f407bb          	subw	a5,s0,a5
ffffffffc0209642:	fff7861b          	addiw	a2,a5,-1
ffffffffc0209646:	46f9                	li	a3,30
ffffffffc0209648:	08c6e063          	bltu	a3,a2,ffffffffc02096c8 <bitmap_create+0xf2>
ffffffffc020964c:	070a                	slli	a4,a4,0x2
ffffffffc020964e:	953a                	add	a0,a0,a4
ffffffffc0209650:	4118                	lw	a4,0(a0)
ffffffffc0209652:	4585                	li	a1,1
ffffffffc0209654:	02000613          	li	a2,32
ffffffffc0209658:	00f596bb          	sllw	a3,a1,a5
ffffffffc020965c:	2785                	addiw	a5,a5,1
ffffffffc020965e:	8f35                	xor	a4,a4,a3
ffffffffc0209660:	fec79ce3          	bne	a5,a2,ffffffffc0209658 <bitmap_create+0x82>
ffffffffc0209664:	7442                	ld	s0,48(sp)
ffffffffc0209666:	70e2                	ld	ra,56(sp)
ffffffffc0209668:	c118                	sw	a4,0(a0)
ffffffffc020966a:	7902                	ld	s2,32(sp)
ffffffffc020966c:	69e2                	ld	s3,24(sp)
ffffffffc020966e:	6a42                	ld	s4,16(sp)
ffffffffc0209670:	8526                	mv	a0,s1
ffffffffc0209672:	74a2                	ld	s1,40(sp)
ffffffffc0209674:	6121                	addi	sp,sp,64
ffffffffc0209676:	8082                	ret
ffffffffc0209678:	7442                	ld	s0,48(sp)
ffffffffc020967a:	70e2                	ld	ra,56(sp)
ffffffffc020967c:	7902                	ld	s2,32(sp)
ffffffffc020967e:	69e2                	ld	s3,24(sp)
ffffffffc0209680:	6a42                	ld	s4,16(sp)
ffffffffc0209682:	8526                	mv	a0,s1
ffffffffc0209684:	74a2                	ld	s1,40(sp)
ffffffffc0209686:	6121                	addi	sp,sp,64
ffffffffc0209688:	8082                	ret
ffffffffc020968a:	8526                	mv	a0,s1
ffffffffc020968c:	ba3f80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209690:	7902                	ld	s2,32(sp)
ffffffffc0209692:	69e2                	ld	s3,24(sp)
ffffffffc0209694:	6a42                	ld	s4,16(sp)
ffffffffc0209696:	7442                	ld	s0,48(sp)
ffffffffc0209698:	70e2                	ld	ra,56(sp)
ffffffffc020969a:	4481                	li	s1,0
ffffffffc020969c:	8526                	mv	a0,s1
ffffffffc020969e:	74a2                	ld	s1,40(sp)
ffffffffc02096a0:	6121                	addi	sp,sp,64
ffffffffc02096a2:	8082                	ret
ffffffffc02096a4:	00005697          	auipc	a3,0x5
ffffffffc02096a8:	48c68693          	addi	a3,a3,1164 # ffffffffc020eb30 <etext+0x2df8>
ffffffffc02096ac:	00003617          	auipc	a2,0x3
ffffffffc02096b0:	ac460613          	addi	a2,a2,-1340 # ffffffffc020c170 <etext+0x438>
ffffffffc02096b4:	45d5                	li	a1,21
ffffffffc02096b6:	00005517          	auipc	a0,0x5
ffffffffc02096ba:	46250513          	addi	a0,a0,1122 # ffffffffc020eb18 <etext+0x2de0>
ffffffffc02096be:	f04a                	sd	s2,32(sp)
ffffffffc02096c0:	ec4e                	sd	s3,24(sp)
ffffffffc02096c2:	e852                	sd	s4,16(sp)
ffffffffc02096c4:	d87f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02096c8:	00005697          	auipc	a3,0x5
ffffffffc02096cc:	4a868693          	addi	a3,a3,1192 # ffffffffc020eb70 <etext+0x2e38>
ffffffffc02096d0:	00003617          	auipc	a2,0x3
ffffffffc02096d4:	aa060613          	addi	a2,a2,-1376 # ffffffffc020c170 <etext+0x438>
ffffffffc02096d8:	02b00593          	li	a1,43
ffffffffc02096dc:	00005517          	auipc	a0,0x5
ffffffffc02096e0:	43c50513          	addi	a0,a0,1084 # ffffffffc020eb18 <etext+0x2de0>
ffffffffc02096e4:	d67f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02096e8:	00005697          	auipc	a3,0x5
ffffffffc02096ec:	47068693          	addi	a3,a3,1136 # ffffffffc020eb58 <etext+0x2e20>
ffffffffc02096f0:	00003617          	auipc	a2,0x3
ffffffffc02096f4:	a8060613          	addi	a2,a2,-1408 # ffffffffc020c170 <etext+0x438>
ffffffffc02096f8:	02a00593          	li	a1,42
ffffffffc02096fc:	00005517          	auipc	a0,0x5
ffffffffc0209700:	41c50513          	addi	a0,a0,1052 # ffffffffc020eb18 <etext+0x2de0>
ffffffffc0209704:	d47f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209708 <bitmap_alloc>:
ffffffffc0209708:	4150                	lw	a2,4(a0)
ffffffffc020970a:	c229                	beqz	a2,ffffffffc020974c <bitmap_alloc+0x44>
ffffffffc020970c:	6518                	ld	a4,8(a0)
ffffffffc020970e:	4781                	li	a5,0
ffffffffc0209710:	a029                	j	ffffffffc020971a <bitmap_alloc+0x12>
ffffffffc0209712:	2785                	addiw	a5,a5,1
ffffffffc0209714:	0711                	addi	a4,a4,4
ffffffffc0209716:	02f60b63          	beq	a2,a5,ffffffffc020974c <bitmap_alloc+0x44>
ffffffffc020971a:	4314                	lw	a3,0(a4)
ffffffffc020971c:	dafd                	beqz	a3,ffffffffc0209712 <bitmap_alloc+0xa>
ffffffffc020971e:	0016f613          	andi	a2,a3,1
ffffffffc0209722:	ea29                	bnez	a2,ffffffffc0209774 <bitmap_alloc+0x6c>
ffffffffc0209724:	02000893          	li	a7,32
ffffffffc0209728:	4305                	li	t1,1
ffffffffc020972a:	2605                	addiw	a2,a2,1
ffffffffc020972c:	03160263          	beq	a2,a7,ffffffffc0209750 <bitmap_alloc+0x48>
ffffffffc0209730:	00c3153b          	sllw	a0,t1,a2
ffffffffc0209734:	00a6f833          	and	a6,a3,a0
ffffffffc0209738:	fe0809e3          	beqz	a6,ffffffffc020972a <bitmap_alloc+0x22>
ffffffffc020973c:	8ea9                	xor	a3,a3,a0
ffffffffc020973e:	0057979b          	slliw	a5,a5,0x5
ffffffffc0209742:	c314                	sw	a3,0(a4)
ffffffffc0209744:	9fb1                	addw	a5,a5,a2
ffffffffc0209746:	c19c                	sw	a5,0(a1)
ffffffffc0209748:	4501                	li	a0,0
ffffffffc020974a:	8082                	ret
ffffffffc020974c:	5571                	li	a0,-4
ffffffffc020974e:	8082                	ret
ffffffffc0209750:	1141                	addi	sp,sp,-16
ffffffffc0209752:	00005697          	auipc	a3,0x5
ffffffffc0209756:	44668693          	addi	a3,a3,1094 # ffffffffc020eb98 <etext+0x2e60>
ffffffffc020975a:	00003617          	auipc	a2,0x3
ffffffffc020975e:	a1660613          	addi	a2,a2,-1514 # ffffffffc020c170 <etext+0x438>
ffffffffc0209762:	04300593          	li	a1,67
ffffffffc0209766:	00005517          	auipc	a0,0x5
ffffffffc020976a:	3b250513          	addi	a0,a0,946 # ffffffffc020eb18 <etext+0x2de0>
ffffffffc020976e:	e406                	sd	ra,8(sp)
ffffffffc0209770:	cdbf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209774:	8532                	mv	a0,a2
ffffffffc0209776:	4601                	li	a2,0
ffffffffc0209778:	b7d1                	j	ffffffffc020973c <bitmap_alloc+0x34>

ffffffffc020977a <bitmap_test>:
ffffffffc020977a:	411c                	lw	a5,0(a0)
ffffffffc020977c:	00f5ff63          	bgeu	a1,a5,ffffffffc020979a <bitmap_test+0x20>
ffffffffc0209780:	651c                	ld	a5,8(a0)
ffffffffc0209782:	0055d71b          	srliw	a4,a1,0x5
ffffffffc0209786:	070a                	slli	a4,a4,0x2
ffffffffc0209788:	97ba                	add	a5,a5,a4
ffffffffc020978a:	439c                	lw	a5,0(a5)
ffffffffc020978c:	4505                	li	a0,1
ffffffffc020978e:	00b5153b          	sllw	a0,a0,a1
ffffffffc0209792:	8d7d                	and	a0,a0,a5
ffffffffc0209794:	1502                	slli	a0,a0,0x20
ffffffffc0209796:	9101                	srli	a0,a0,0x20
ffffffffc0209798:	8082                	ret
ffffffffc020979a:	1141                	addi	sp,sp,-16
ffffffffc020979c:	e406                	sd	ra,8(sp)
ffffffffc020979e:	e15ff0ef          	jal	ffffffffc02095b2 <bitmap_translate.part.0>

ffffffffc02097a2 <bitmap_free>:
ffffffffc02097a2:	411c                	lw	a5,0(a0)
ffffffffc02097a4:	1141                	addi	sp,sp,-16
ffffffffc02097a6:	e406                	sd	ra,8(sp)
ffffffffc02097a8:	02f5f363          	bgeu	a1,a5,ffffffffc02097ce <bitmap_free+0x2c>
ffffffffc02097ac:	651c                	ld	a5,8(a0)
ffffffffc02097ae:	0055d71b          	srliw	a4,a1,0x5
ffffffffc02097b2:	070a                	slli	a4,a4,0x2
ffffffffc02097b4:	97ba                	add	a5,a5,a4
ffffffffc02097b6:	4394                	lw	a3,0(a5)
ffffffffc02097b8:	4705                	li	a4,1
ffffffffc02097ba:	00b715bb          	sllw	a1,a4,a1
ffffffffc02097be:	00b6f733          	and	a4,a3,a1
ffffffffc02097c2:	eb01                	bnez	a4,ffffffffc02097d2 <bitmap_free+0x30>
ffffffffc02097c4:	60a2                	ld	ra,8(sp)
ffffffffc02097c6:	8ecd                	or	a3,a3,a1
ffffffffc02097c8:	c394                	sw	a3,0(a5)
ffffffffc02097ca:	0141                	addi	sp,sp,16
ffffffffc02097cc:	8082                	ret
ffffffffc02097ce:	de5ff0ef          	jal	ffffffffc02095b2 <bitmap_translate.part.0>
ffffffffc02097d2:	00005697          	auipc	a3,0x5
ffffffffc02097d6:	3ce68693          	addi	a3,a3,974 # ffffffffc020eba0 <etext+0x2e68>
ffffffffc02097da:	00003617          	auipc	a2,0x3
ffffffffc02097de:	99660613          	addi	a2,a2,-1642 # ffffffffc020c170 <etext+0x438>
ffffffffc02097e2:	05f00593          	li	a1,95
ffffffffc02097e6:	00005517          	auipc	a0,0x5
ffffffffc02097ea:	33250513          	addi	a0,a0,818 # ffffffffc020eb18 <etext+0x2de0>
ffffffffc02097ee:	c5df60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02097f2 <bitmap_destroy>:
ffffffffc02097f2:	1141                	addi	sp,sp,-16
ffffffffc02097f4:	e022                	sd	s0,0(sp)
ffffffffc02097f6:	842a                	mv	s0,a0
ffffffffc02097f8:	6508                	ld	a0,8(a0)
ffffffffc02097fa:	e406                	sd	ra,8(sp)
ffffffffc02097fc:	a33f80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209800:	8522                	mv	a0,s0
ffffffffc0209802:	6402                	ld	s0,0(sp)
ffffffffc0209804:	60a2                	ld	ra,8(sp)
ffffffffc0209806:	0141                	addi	sp,sp,16
ffffffffc0209808:	a27f806f          	j	ffffffffc020222e <kfree>

ffffffffc020980c <bitmap_getdata>:
ffffffffc020980c:	c589                	beqz	a1,ffffffffc0209816 <bitmap_getdata+0xa>
ffffffffc020980e:	00456783          	lwu	a5,4(a0)
ffffffffc0209812:	078a                	slli	a5,a5,0x2
ffffffffc0209814:	e19c                	sd	a5,0(a1)
ffffffffc0209816:	6508                	ld	a0,8(a0)
ffffffffc0209818:	8082                	ret

ffffffffc020981a <sfs_init>:
ffffffffc020981a:	1141                	addi	sp,sp,-16
ffffffffc020981c:	00005517          	auipc	a0,0x5
ffffffffc0209820:	1ec50513          	addi	a0,a0,492 # ffffffffc020ea08 <etext+0x2cd0>
ffffffffc0209824:	e406                	sd	ra,8(sp)
ffffffffc0209826:	576000ef          	jal	ffffffffc0209d9c <sfs_mount>
ffffffffc020982a:	e501                	bnez	a0,ffffffffc0209832 <sfs_init+0x18>
ffffffffc020982c:	60a2                	ld	ra,8(sp)
ffffffffc020982e:	0141                	addi	sp,sp,16
ffffffffc0209830:	8082                	ret
ffffffffc0209832:	86aa                	mv	a3,a0
ffffffffc0209834:	00005617          	auipc	a2,0x5
ffffffffc0209838:	37c60613          	addi	a2,a2,892 # ffffffffc020ebb0 <etext+0x2e78>
ffffffffc020983c:	45c1                	li	a1,16
ffffffffc020983e:	00005517          	auipc	a0,0x5
ffffffffc0209842:	39250513          	addi	a0,a0,914 # ffffffffc020ebd0 <etext+0x2e98>
ffffffffc0209846:	c05f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020984a <sfs_unmount>:
ffffffffc020984a:	1141                	addi	sp,sp,-16
ffffffffc020984c:	e406                	sd	ra,8(sp)
ffffffffc020984e:	e022                	sd	s0,0(sp)
ffffffffc0209850:	cd1d                	beqz	a0,ffffffffc020988e <sfs_unmount+0x44>
ffffffffc0209852:	0b052783          	lw	a5,176(a0)
ffffffffc0209856:	842a                	mv	s0,a0
ffffffffc0209858:	eb9d                	bnez	a5,ffffffffc020988e <sfs_unmount+0x44>
ffffffffc020985a:	7158                	ld	a4,160(a0)
ffffffffc020985c:	09850793          	addi	a5,a0,152
ffffffffc0209860:	02f71563          	bne	a4,a5,ffffffffc020988a <sfs_unmount+0x40>
ffffffffc0209864:	613c                	ld	a5,64(a0)
ffffffffc0209866:	e7a1                	bnez	a5,ffffffffc02098ae <sfs_unmount+0x64>
ffffffffc0209868:	7d08                	ld	a0,56(a0)
ffffffffc020986a:	f89ff0ef          	jal	ffffffffc02097f2 <bitmap_destroy>
ffffffffc020986e:	6428                	ld	a0,72(s0)
ffffffffc0209870:	9bff80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209874:	7448                	ld	a0,168(s0)
ffffffffc0209876:	9b9f80ef          	jal	ffffffffc020222e <kfree>
ffffffffc020987a:	8522                	mv	a0,s0
ffffffffc020987c:	9b3f80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209880:	4501                	li	a0,0
ffffffffc0209882:	60a2                	ld	ra,8(sp)
ffffffffc0209884:	6402                	ld	s0,0(sp)
ffffffffc0209886:	0141                	addi	sp,sp,16
ffffffffc0209888:	8082                	ret
ffffffffc020988a:	5545                	li	a0,-15
ffffffffc020988c:	bfdd                	j	ffffffffc0209882 <sfs_unmount+0x38>
ffffffffc020988e:	00005697          	auipc	a3,0x5
ffffffffc0209892:	35a68693          	addi	a3,a3,858 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc0209896:	00003617          	auipc	a2,0x3
ffffffffc020989a:	8da60613          	addi	a2,a2,-1830 # ffffffffc020c170 <etext+0x438>
ffffffffc020989e:	04100593          	li	a1,65
ffffffffc02098a2:	00005517          	auipc	a0,0x5
ffffffffc02098a6:	37650513          	addi	a0,a0,886 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc02098aa:	ba1f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc02098ae:	00005697          	auipc	a3,0x5
ffffffffc02098b2:	38268693          	addi	a3,a3,898 # ffffffffc020ec30 <etext+0x2ef8>
ffffffffc02098b6:	00003617          	auipc	a2,0x3
ffffffffc02098ba:	8ba60613          	addi	a2,a2,-1862 # ffffffffc020c170 <etext+0x438>
ffffffffc02098be:	04500593          	li	a1,69
ffffffffc02098c2:	00005517          	auipc	a0,0x5
ffffffffc02098c6:	35650513          	addi	a0,a0,854 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc02098ca:	b81f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc02098ce <sfs_cleanup>:
ffffffffc02098ce:	1101                	addi	sp,sp,-32
ffffffffc02098d0:	ec06                	sd	ra,24(sp)
ffffffffc02098d2:	e426                	sd	s1,8(sp)
ffffffffc02098d4:	c13d                	beqz	a0,ffffffffc020993a <sfs_cleanup+0x6c>
ffffffffc02098d6:	0b052783          	lw	a5,176(a0)
ffffffffc02098da:	84aa                	mv	s1,a0
ffffffffc02098dc:	efb9                	bnez	a5,ffffffffc020993a <sfs_cleanup+0x6c>
ffffffffc02098de:	4158                	lw	a4,4(a0)
ffffffffc02098e0:	4514                	lw	a3,8(a0)
ffffffffc02098e2:	00c50593          	addi	a1,a0,12
ffffffffc02098e6:	00005517          	auipc	a0,0x5
ffffffffc02098ea:	36250513          	addi	a0,a0,866 # ffffffffc020ec48 <etext+0x2f10>
ffffffffc02098ee:	40d7063b          	subw	a2,a4,a3
ffffffffc02098f2:	e822                	sd	s0,16(sp)
ffffffffc02098f4:	8b3f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc02098f8:	02000413          	li	s0,32
ffffffffc02098fc:	a019                	j	ffffffffc0209902 <sfs_cleanup+0x34>
ffffffffc02098fe:	347d                	addiw	s0,s0,-1
ffffffffc0209900:	c811                	beqz	s0,ffffffffc0209914 <sfs_cleanup+0x46>
ffffffffc0209902:	7cdc                	ld	a5,184(s1)
ffffffffc0209904:	8526                	mv	a0,s1
ffffffffc0209906:	9782                	jalr	a5
ffffffffc0209908:	f97d                	bnez	a0,ffffffffc02098fe <sfs_cleanup+0x30>
ffffffffc020990a:	6442                	ld	s0,16(sp)
ffffffffc020990c:	60e2                	ld	ra,24(sp)
ffffffffc020990e:	64a2                	ld	s1,8(sp)
ffffffffc0209910:	6105                	addi	sp,sp,32
ffffffffc0209912:	8082                	ret
ffffffffc0209914:	6442                	ld	s0,16(sp)
ffffffffc0209916:	60e2                	ld	ra,24(sp)
ffffffffc0209918:	00c48693          	addi	a3,s1,12
ffffffffc020991c:	64a2                	ld	s1,8(sp)
ffffffffc020991e:	872a                	mv	a4,a0
ffffffffc0209920:	00005617          	auipc	a2,0x5
ffffffffc0209924:	34860613          	addi	a2,a2,840 # ffffffffc020ec68 <etext+0x2f30>
ffffffffc0209928:	05f00593          	li	a1,95
ffffffffc020992c:	00005517          	auipc	a0,0x5
ffffffffc0209930:	2ec50513          	addi	a0,a0,748 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209934:	6105                	addi	sp,sp,32
ffffffffc0209936:	b7ff606f          	j	ffffffffc02004b4 <__warn>
ffffffffc020993a:	00005697          	auipc	a3,0x5
ffffffffc020993e:	2ae68693          	addi	a3,a3,686 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc0209942:	00003617          	auipc	a2,0x3
ffffffffc0209946:	82e60613          	addi	a2,a2,-2002 # ffffffffc020c170 <etext+0x438>
ffffffffc020994a:	05400593          	li	a1,84
ffffffffc020994e:	00005517          	auipc	a0,0x5
ffffffffc0209952:	2ca50513          	addi	a0,a0,714 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209956:	e822                	sd	s0,16(sp)
ffffffffc0209958:	e04a                	sd	s2,0(sp)
ffffffffc020995a:	af1f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020995e <sfs_sync>:
ffffffffc020995e:	7179                	addi	sp,sp,-48
ffffffffc0209960:	f406                	sd	ra,40(sp)
ffffffffc0209962:	e44e                	sd	s3,8(sp)
ffffffffc0209964:	c94d                	beqz	a0,ffffffffc0209a16 <sfs_sync+0xb8>
ffffffffc0209966:	0b052783          	lw	a5,176(a0)
ffffffffc020996a:	89aa                	mv	s3,a0
ffffffffc020996c:	e7cd                	bnez	a5,ffffffffc0209a16 <sfs_sync+0xb8>
ffffffffc020996e:	f022                	sd	s0,32(sp)
ffffffffc0209970:	e84a                	sd	s2,16(sp)
ffffffffc0209972:	603010ef          	jal	ffffffffc020b774 <lock_sfs_fs>
ffffffffc0209976:	0a09b403          	ld	s0,160(s3)
ffffffffc020997a:	09898913          	addi	s2,s3,152
ffffffffc020997e:	02890663          	beq	s2,s0,ffffffffc02099aa <sfs_sync+0x4c>
ffffffffc0209982:	7c1c                	ld	a5,56(s0)
ffffffffc0209984:	cbad                	beqz	a5,ffffffffc02099f6 <sfs_sync+0x98>
ffffffffc0209986:	7b9c                	ld	a5,48(a5)
ffffffffc0209988:	c7bd                	beqz	a5,ffffffffc02099f6 <sfs_sync+0x98>
ffffffffc020998a:	fc840513          	addi	a0,s0,-56
ffffffffc020998e:	00004597          	auipc	a1,0x4
ffffffffc0209992:	0f258593          	addi	a1,a1,242 # ffffffffc020da80 <etext+0x1d48>
ffffffffc0209996:	decfe0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc020999a:	7c1c                	ld	a5,56(s0)
ffffffffc020999c:	fc840513          	addi	a0,s0,-56
ffffffffc02099a0:	7b9c                	ld	a5,48(a5)
ffffffffc02099a2:	9782                	jalr	a5
ffffffffc02099a4:	6400                	ld	s0,8(s0)
ffffffffc02099a6:	fc891ee3          	bne	s2,s0,ffffffffc0209982 <sfs_sync+0x24>
ffffffffc02099aa:	854e                	mv	a0,s3
ffffffffc02099ac:	5d9010ef          	jal	ffffffffc020b784 <unlock_sfs_fs>
ffffffffc02099b0:	0409b783          	ld	a5,64(s3)
ffffffffc02099b4:	4501                	li	a0,0
ffffffffc02099b6:	e799                	bnez	a5,ffffffffc02099c4 <sfs_sync+0x66>
ffffffffc02099b8:	7402                	ld	s0,32(sp)
ffffffffc02099ba:	70a2                	ld	ra,40(sp)
ffffffffc02099bc:	6942                	ld	s2,16(sp)
ffffffffc02099be:	69a2                	ld	s3,8(sp)
ffffffffc02099c0:	6145                	addi	sp,sp,48
ffffffffc02099c2:	8082                	ret
ffffffffc02099c4:	0409b023          	sd	zero,64(s3)
ffffffffc02099c8:	854e                	mv	a0,s3
ffffffffc02099ca:	48b010ef          	jal	ffffffffc020b654 <sfs_sync_super>
ffffffffc02099ce:	c911                	beqz	a0,ffffffffc02099e2 <sfs_sync+0x84>
ffffffffc02099d0:	7402                	ld	s0,32(sp)
ffffffffc02099d2:	70a2                	ld	ra,40(sp)
ffffffffc02099d4:	4785                	li	a5,1
ffffffffc02099d6:	04f9b023          	sd	a5,64(s3)
ffffffffc02099da:	6942                	ld	s2,16(sp)
ffffffffc02099dc:	69a2                	ld	s3,8(sp)
ffffffffc02099de:	6145                	addi	sp,sp,48
ffffffffc02099e0:	8082                	ret
ffffffffc02099e2:	854e                	mv	a0,s3
ffffffffc02099e4:	4b7010ef          	jal	ffffffffc020b69a <sfs_sync_freemap>
ffffffffc02099e8:	f565                	bnez	a0,ffffffffc02099d0 <sfs_sync+0x72>
ffffffffc02099ea:	7402                	ld	s0,32(sp)
ffffffffc02099ec:	70a2                	ld	ra,40(sp)
ffffffffc02099ee:	6942                	ld	s2,16(sp)
ffffffffc02099f0:	69a2                	ld	s3,8(sp)
ffffffffc02099f2:	6145                	addi	sp,sp,48
ffffffffc02099f4:	8082                	ret
ffffffffc02099f6:	00004697          	auipc	a3,0x4
ffffffffc02099fa:	03a68693          	addi	a3,a3,58 # ffffffffc020da30 <etext+0x1cf8>
ffffffffc02099fe:	00002617          	auipc	a2,0x2
ffffffffc0209a02:	77260613          	addi	a2,a2,1906 # ffffffffc020c170 <etext+0x438>
ffffffffc0209a06:	45ed                	li	a1,27
ffffffffc0209a08:	00005517          	auipc	a0,0x5
ffffffffc0209a0c:	21050513          	addi	a0,a0,528 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209a10:	ec26                	sd	s1,24(sp)
ffffffffc0209a12:	a39f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209a16:	00005697          	auipc	a3,0x5
ffffffffc0209a1a:	1d268693          	addi	a3,a3,466 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc0209a1e:	00002617          	auipc	a2,0x2
ffffffffc0209a22:	75260613          	addi	a2,a2,1874 # ffffffffc020c170 <etext+0x438>
ffffffffc0209a26:	45d5                	li	a1,21
ffffffffc0209a28:	00005517          	auipc	a0,0x5
ffffffffc0209a2c:	1f050513          	addi	a0,a0,496 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209a30:	f022                	sd	s0,32(sp)
ffffffffc0209a32:	ec26                	sd	s1,24(sp)
ffffffffc0209a34:	e84a                	sd	s2,16(sp)
ffffffffc0209a36:	a15f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209a3a <sfs_get_root>:
ffffffffc0209a3a:	1101                	addi	sp,sp,-32
ffffffffc0209a3c:	ec06                	sd	ra,24(sp)
ffffffffc0209a3e:	cd09                	beqz	a0,ffffffffc0209a58 <sfs_get_root+0x1e>
ffffffffc0209a40:	0b052783          	lw	a5,176(a0)
ffffffffc0209a44:	eb91                	bnez	a5,ffffffffc0209a58 <sfs_get_root+0x1e>
ffffffffc0209a46:	4605                	li	a2,1
ffffffffc0209a48:	002c                	addi	a1,sp,8
ffffffffc0209a4a:	368010ef          	jal	ffffffffc020adb2 <sfs_load_inode>
ffffffffc0209a4e:	e50d                	bnez	a0,ffffffffc0209a78 <sfs_get_root+0x3e>
ffffffffc0209a50:	60e2                	ld	ra,24(sp)
ffffffffc0209a52:	6522                	ld	a0,8(sp)
ffffffffc0209a54:	6105                	addi	sp,sp,32
ffffffffc0209a56:	8082                	ret
ffffffffc0209a58:	00005697          	auipc	a3,0x5
ffffffffc0209a5c:	19068693          	addi	a3,a3,400 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc0209a60:	00002617          	auipc	a2,0x2
ffffffffc0209a64:	71060613          	addi	a2,a2,1808 # ffffffffc020c170 <etext+0x438>
ffffffffc0209a68:	03600593          	li	a1,54
ffffffffc0209a6c:	00005517          	auipc	a0,0x5
ffffffffc0209a70:	1ac50513          	addi	a0,a0,428 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209a74:	9d7f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209a78:	86aa                	mv	a3,a0
ffffffffc0209a7a:	00005617          	auipc	a2,0x5
ffffffffc0209a7e:	20e60613          	addi	a2,a2,526 # ffffffffc020ec88 <etext+0x2f50>
ffffffffc0209a82:	03700593          	li	a1,55
ffffffffc0209a86:	00005517          	auipc	a0,0x5
ffffffffc0209a8a:	19250513          	addi	a0,a0,402 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209a8e:	9bdf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209a92 <sfs_do_mount>:
ffffffffc0209a92:	7171                	addi	sp,sp,-176
ffffffffc0209a94:	e54e                	sd	s3,136(sp)
ffffffffc0209a96:	00853983          	ld	s3,8(a0)
ffffffffc0209a9a:	f506                	sd	ra,168(sp)
ffffffffc0209a9c:	6785                	lui	a5,0x1
ffffffffc0209a9e:	26f99a63          	bne	s3,a5,ffffffffc0209d12 <sfs_do_mount+0x280>
ffffffffc0209aa2:	ed26                	sd	s1,152(sp)
ffffffffc0209aa4:	84aa                	mv	s1,a0
ffffffffc0209aa6:	4501                	li	a0,0
ffffffffc0209aa8:	f122                	sd	s0,160(sp)
ffffffffc0209aaa:	f4de                	sd	s7,104(sp)
ffffffffc0209aac:	8bae                	mv	s7,a1
ffffffffc0209aae:	ec0fe0ef          	jal	ffffffffc020816e <__alloc_fs>
ffffffffc0209ab2:	842a                	mv	s0,a0
ffffffffc0209ab4:	26050663          	beqz	a0,ffffffffc0209d20 <sfs_do_mount+0x28e>
ffffffffc0209ab8:	e152                	sd	s4,128(sp)
ffffffffc0209aba:	0b052a03          	lw	s4,176(a0)
ffffffffc0209abe:	e94a                	sd	s2,144(sp)
ffffffffc0209ac0:	280a1763          	bnez	s4,ffffffffc0209d4e <sfs_do_mount+0x2bc>
ffffffffc0209ac4:	f904                	sd	s1,48(a0)
ffffffffc0209ac6:	854e                	mv	a0,s3
ffffffffc0209ac8:	ec0f80ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0209acc:	e428                	sd	a0,72(s0)
ffffffffc0209ace:	892a                	mv	s2,a0
ffffffffc0209ad0:	16050863          	beqz	a0,ffffffffc0209c40 <sfs_do_mount+0x1ae>
ffffffffc0209ad4:	864e                	mv	a2,s3
ffffffffc0209ad6:	4681                	li	a3,0
ffffffffc0209ad8:	85ca                	mv	a1,s2
ffffffffc0209ada:	1008                	addi	a0,sp,32
ffffffffc0209adc:	9d3fb0ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc0209ae0:	709c                	ld	a5,32(s1)
ffffffffc0209ae2:	85aa                	mv	a1,a0
ffffffffc0209ae4:	4601                	li	a2,0
ffffffffc0209ae6:	8526                	mv	a0,s1
ffffffffc0209ae8:	9782                	jalr	a5
ffffffffc0209aea:	89aa                	mv	s3,a0
ffffffffc0209aec:	12051a63          	bnez	a0,ffffffffc0209c20 <sfs_do_mount+0x18e>
ffffffffc0209af0:	00092583          	lw	a1,0(s2)
ffffffffc0209af4:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc0209af8:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc0209afc:	14c59d63          	bne	a1,a2,ffffffffc0209c56 <sfs_do_mount+0x1c4>
ffffffffc0209b00:	00492783          	lw	a5,4(s2)
ffffffffc0209b04:	6090                	ld	a2,0(s1)
ffffffffc0209b06:	02079713          	slli	a4,a5,0x20
ffffffffc0209b0a:	9301                	srli	a4,a4,0x20
ffffffffc0209b0c:	12e66c63          	bltu	a2,a4,ffffffffc0209c44 <sfs_do_mount+0x1b2>
ffffffffc0209b10:	e4ee                	sd	s11,72(sp)
ffffffffc0209b12:	01892503          	lw	a0,24(s2)
ffffffffc0209b16:	00892e03          	lw	t3,8(s2)
ffffffffc0209b1a:	00c92303          	lw	t1,12(s2)
ffffffffc0209b1e:	01092883          	lw	a7,16(s2)
ffffffffc0209b22:	01492803          	lw	a6,20(s2)
ffffffffc0209b26:	01c92603          	lw	a2,28(s2)
ffffffffc0209b2a:	02092683          	lw	a3,32(s2)
ffffffffc0209b2e:	02492703          	lw	a4,36(s2)
ffffffffc0209b32:	020905a3          	sb	zero,43(s2)
ffffffffc0209b36:	cc08                	sw	a0,24(s0)
ffffffffc0209b38:	01c42423          	sw	t3,8(s0)
ffffffffc0209b3c:	00642623          	sw	t1,12(s0)
ffffffffc0209b40:	01142823          	sw	a7,16(s0)
ffffffffc0209b44:	01042a23          	sw	a6,20(s0)
ffffffffc0209b48:	cc50                	sw	a2,28(s0)
ffffffffc0209b4a:	d014                	sw	a3,32(s0)
ffffffffc0209b4c:	d058                	sw	a4,36(s0)
ffffffffc0209b4e:	c00c                	sw	a1,0(s0)
ffffffffc0209b50:	c05c                	sw	a5,4(s0)
ffffffffc0209b52:	02892783          	lw	a5,40(s2)
ffffffffc0209b56:	6511                	lui	a0,0x4
ffffffffc0209b58:	d41c                	sw	a5,40(s0)
ffffffffc0209b5a:	e2ef80ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc0209b5e:	f448                	sd	a0,168(s0)
ffffffffc0209b60:	87aa                	mv	a5,a0
ffffffffc0209b62:	8daa                	mv	s11,a0
ffffffffc0209b64:	1a050963          	beqz	a0,ffffffffc0209d16 <sfs_do_mount+0x284>
ffffffffc0209b68:	6711                	lui	a4,0x4
ffffffffc0209b6a:	fcd6                	sd	s5,120(sp)
ffffffffc0209b6c:	ece6                	sd	s9,88(sp)
ffffffffc0209b6e:	e8ea                	sd	s10,80(sp)
ffffffffc0209b70:	972a                	add	a4,a4,a0
ffffffffc0209b72:	e79c                	sd	a5,8(a5)
ffffffffc0209b74:	e39c                	sd	a5,0(a5)
ffffffffc0209b76:	07c1                	addi	a5,a5,16 # 1010 <_binary_bin_swap_img_size-0x6cf0>
ffffffffc0209b78:	fee79de3          	bne	a5,a4,ffffffffc0209b72 <sfs_do_mount+0xe0>
ffffffffc0209b7c:	00496783          	lwu	a5,4(s2)
ffffffffc0209b80:	6721                	lui	a4,0x8
ffffffffc0209b82:	fff70a93          	addi	s5,a4,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc0209b86:	97d6                	add	a5,a5,s5
ffffffffc0209b88:	7761                	lui	a4,0xffff8
ffffffffc0209b8a:	8ff9                	and	a5,a5,a4
ffffffffc0209b8c:	0007851b          	sext.w	a0,a5
ffffffffc0209b90:	00078c9b          	sext.w	s9,a5
ffffffffc0209b94:	a43ff0ef          	jal	ffffffffc02095d6 <bitmap_create>
ffffffffc0209b98:	fc08                	sd	a0,56(s0)
ffffffffc0209b9a:	8d2a                	mv	s10,a0
ffffffffc0209b9c:	16050963          	beqz	a0,ffffffffc0209d0e <sfs_do_mount+0x27c>
ffffffffc0209ba0:	00492783          	lw	a5,4(s2)
ffffffffc0209ba4:	082c                	addi	a1,sp,24
ffffffffc0209ba6:	e43e                	sd	a5,8(sp)
ffffffffc0209ba8:	c65ff0ef          	jal	ffffffffc020980c <bitmap_getdata>
ffffffffc0209bac:	16050f63          	beqz	a0,ffffffffc0209d2a <sfs_do_mount+0x298>
ffffffffc0209bb0:	00816783          	lwu	a5,8(sp)
ffffffffc0209bb4:	66e2                	ld	a3,24(sp)
ffffffffc0209bb6:	97d6                	add	a5,a5,s5
ffffffffc0209bb8:	83bd                	srli	a5,a5,0xf
ffffffffc0209bba:	00c7971b          	slliw	a4,a5,0xc
ffffffffc0209bbe:	1702                	slli	a4,a4,0x20
ffffffffc0209bc0:	9301                	srli	a4,a4,0x20
ffffffffc0209bc2:	16d71463          	bne	a4,a3,ffffffffc0209d2a <sfs_do_mount+0x298>
ffffffffc0209bc6:	f0e2                	sd	s8,96(sp)
ffffffffc0209bc8:	00c79713          	slli	a4,a5,0xc
ffffffffc0209bcc:	00e50c33          	add	s8,a0,a4
ffffffffc0209bd0:	8aaa                	mv	s5,a0
ffffffffc0209bd2:	cbd9                	beqz	a5,ffffffffc0209c68 <sfs_do_mount+0x1d6>
ffffffffc0209bd4:	6789                	lui	a5,0x2
ffffffffc0209bd6:	f8da                	sd	s6,112(sp)
ffffffffc0209bd8:	40a78b3b          	subw	s6,a5,a0
ffffffffc0209bdc:	a029                	j	ffffffffc0209be6 <sfs_do_mount+0x154>
ffffffffc0209bde:	6785                	lui	a5,0x1
ffffffffc0209be0:	9abe                	add	s5,s5,a5
ffffffffc0209be2:	098a8263          	beq	s5,s8,ffffffffc0209c66 <sfs_do_mount+0x1d4>
ffffffffc0209be6:	015b06bb          	addw	a3,s6,s5
ffffffffc0209bea:	1682                	slli	a3,a3,0x20
ffffffffc0209bec:	6605                	lui	a2,0x1
ffffffffc0209bee:	85d6                	mv	a1,s5
ffffffffc0209bf0:	9281                	srli	a3,a3,0x20
ffffffffc0209bf2:	1008                	addi	a0,sp,32
ffffffffc0209bf4:	8bbfb0ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc0209bf8:	709c                	ld	a5,32(s1)
ffffffffc0209bfa:	85aa                	mv	a1,a0
ffffffffc0209bfc:	4601                	li	a2,0
ffffffffc0209bfe:	8526                	mv	a0,s1
ffffffffc0209c00:	9782                	jalr	a5
ffffffffc0209c02:	dd71                	beqz	a0,ffffffffc0209bde <sfs_do_mount+0x14c>
ffffffffc0209c04:	e42a                	sd	a0,8(sp)
ffffffffc0209c06:	856a                	mv	a0,s10
ffffffffc0209c08:	bebff0ef          	jal	ffffffffc02097f2 <bitmap_destroy>
ffffffffc0209c0c:	69a2                	ld	s3,8(sp)
ffffffffc0209c0e:	7b46                	ld	s6,112(sp)
ffffffffc0209c10:	7c06                	ld	s8,96(sp)
ffffffffc0209c12:	856e                	mv	a0,s11
ffffffffc0209c14:	e1af80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209c18:	7ae6                	ld	s5,120(sp)
ffffffffc0209c1a:	6ce6                	ld	s9,88(sp)
ffffffffc0209c1c:	6d46                	ld	s10,80(sp)
ffffffffc0209c1e:	6da6                	ld	s11,72(sp)
ffffffffc0209c20:	854a                	mv	a0,s2
ffffffffc0209c22:	e0cf80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209c26:	8522                	mv	a0,s0
ffffffffc0209c28:	e06f80ef          	jal	ffffffffc020222e <kfree>
ffffffffc0209c2c:	740a                	ld	s0,160(sp)
ffffffffc0209c2e:	64ea                	ld	s1,152(sp)
ffffffffc0209c30:	694a                	ld	s2,144(sp)
ffffffffc0209c32:	6a0a                	ld	s4,128(sp)
ffffffffc0209c34:	7ba6                	ld	s7,104(sp)
ffffffffc0209c36:	70aa                	ld	ra,168(sp)
ffffffffc0209c38:	854e                	mv	a0,s3
ffffffffc0209c3a:	69aa                	ld	s3,136(sp)
ffffffffc0209c3c:	614d                	addi	sp,sp,176
ffffffffc0209c3e:	8082                	ret
ffffffffc0209c40:	59f1                	li	s3,-4
ffffffffc0209c42:	b7d5                	j	ffffffffc0209c26 <sfs_do_mount+0x194>
ffffffffc0209c44:	85be                	mv	a1,a5
ffffffffc0209c46:	00005517          	auipc	a0,0x5
ffffffffc0209c4a:	09a50513          	addi	a0,a0,154 # ffffffffc020ece0 <etext+0x2fa8>
ffffffffc0209c4e:	d58f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209c52:	59f5                	li	s3,-3
ffffffffc0209c54:	b7f1                	j	ffffffffc0209c20 <sfs_do_mount+0x18e>
ffffffffc0209c56:	00005517          	auipc	a0,0x5
ffffffffc0209c5a:	05250513          	addi	a0,a0,82 # ffffffffc020eca8 <etext+0x2f70>
ffffffffc0209c5e:	d48f60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209c62:	59f5                	li	s3,-3
ffffffffc0209c64:	bf75                	j	ffffffffc0209c20 <sfs_do_mount+0x18e>
ffffffffc0209c66:	7b46                	ld	s6,112(sp)
ffffffffc0209c68:	00442903          	lw	s2,4(s0)
ffffffffc0209c6c:	0a0c8863          	beqz	s9,ffffffffc0209d1c <sfs_do_mount+0x28a>
ffffffffc0209c70:	4481                	li	s1,0
ffffffffc0209c72:	85a6                	mv	a1,s1
ffffffffc0209c74:	856a                	mv	a0,s10
ffffffffc0209c76:	b05ff0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc0209c7a:	c111                	beqz	a0,ffffffffc0209c7e <sfs_do_mount+0x1ec>
ffffffffc0209c7c:	2a05                	addiw	s4,s4,1
ffffffffc0209c7e:	2485                	addiw	s1,s1,1
ffffffffc0209c80:	fe9c99e3          	bne	s9,s1,ffffffffc0209c72 <sfs_do_mount+0x1e0>
ffffffffc0209c84:	441c                	lw	a5,8(s0)
ffffffffc0209c86:	0f479a63          	bne	a5,s4,ffffffffc0209d7a <sfs_do_mount+0x2e8>
ffffffffc0209c8a:	05040513          	addi	a0,s0,80
ffffffffc0209c8e:	04043023          	sd	zero,64(s0)
ffffffffc0209c92:	4585                	li	a1,1
ffffffffc0209c94:	97bfa0ef          	jal	ffffffffc020460e <sem_init>
ffffffffc0209c98:	06840513          	addi	a0,s0,104
ffffffffc0209c9c:	4585                	li	a1,1
ffffffffc0209c9e:	971fa0ef          	jal	ffffffffc020460e <sem_init>
ffffffffc0209ca2:	08040513          	addi	a0,s0,128
ffffffffc0209ca6:	4585                	li	a1,1
ffffffffc0209ca8:	967fa0ef          	jal	ffffffffc020460e <sem_init>
ffffffffc0209cac:	09840793          	addi	a5,s0,152
ffffffffc0209cb0:	4149063b          	subw	a2,s2,s4
ffffffffc0209cb4:	f05c                	sd	a5,160(s0)
ffffffffc0209cb6:	ec5c                	sd	a5,152(s0)
ffffffffc0209cb8:	874a                	mv	a4,s2
ffffffffc0209cba:	86d2                	mv	a3,s4
ffffffffc0209cbc:	00c40593          	addi	a1,s0,12
ffffffffc0209cc0:	00005517          	auipc	a0,0x5
ffffffffc0209cc4:	0b050513          	addi	a0,a0,176 # ffffffffc020ed70 <etext+0x3038>
ffffffffc0209cc8:	cdef60ef          	jal	ffffffffc02001a6 <cprintf>
ffffffffc0209ccc:	00000617          	auipc	a2,0x0
ffffffffc0209cd0:	c9260613          	addi	a2,a2,-878 # ffffffffc020995e <sfs_sync>
ffffffffc0209cd4:	00000697          	auipc	a3,0x0
ffffffffc0209cd8:	d6668693          	addi	a3,a3,-666 # ffffffffc0209a3a <sfs_get_root>
ffffffffc0209cdc:	00000717          	auipc	a4,0x0
ffffffffc0209ce0:	b6e70713          	addi	a4,a4,-1170 # ffffffffc020984a <sfs_unmount>
ffffffffc0209ce4:	00000797          	auipc	a5,0x0
ffffffffc0209ce8:	bea78793          	addi	a5,a5,-1046 # ffffffffc02098ce <sfs_cleanup>
ffffffffc0209cec:	fc50                	sd	a2,184(s0)
ffffffffc0209cee:	e074                	sd	a3,192(s0)
ffffffffc0209cf0:	e478                	sd	a4,200(s0)
ffffffffc0209cf2:	e87c                	sd	a5,208(s0)
ffffffffc0209cf4:	008bb023          	sd	s0,0(s7)
ffffffffc0209cf8:	64ea                	ld	s1,152(sp)
ffffffffc0209cfa:	740a                	ld	s0,160(sp)
ffffffffc0209cfc:	694a                	ld	s2,144(sp)
ffffffffc0209cfe:	6a0a                	ld	s4,128(sp)
ffffffffc0209d00:	7ae6                	ld	s5,120(sp)
ffffffffc0209d02:	7ba6                	ld	s7,104(sp)
ffffffffc0209d04:	7c06                	ld	s8,96(sp)
ffffffffc0209d06:	6ce6                	ld	s9,88(sp)
ffffffffc0209d08:	6d46                	ld	s10,80(sp)
ffffffffc0209d0a:	6da6                	ld	s11,72(sp)
ffffffffc0209d0c:	b72d                	j	ffffffffc0209c36 <sfs_do_mount+0x1a4>
ffffffffc0209d0e:	59f1                	li	s3,-4
ffffffffc0209d10:	b709                	j	ffffffffc0209c12 <sfs_do_mount+0x180>
ffffffffc0209d12:	59c9                	li	s3,-14
ffffffffc0209d14:	b70d                	j	ffffffffc0209c36 <sfs_do_mount+0x1a4>
ffffffffc0209d16:	6da6                	ld	s11,72(sp)
ffffffffc0209d18:	59f1                	li	s3,-4
ffffffffc0209d1a:	b719                	j	ffffffffc0209c20 <sfs_do_mount+0x18e>
ffffffffc0209d1c:	4a01                	li	s4,0
ffffffffc0209d1e:	b79d                	j	ffffffffc0209c84 <sfs_do_mount+0x1f2>
ffffffffc0209d20:	740a                	ld	s0,160(sp)
ffffffffc0209d22:	64ea                	ld	s1,152(sp)
ffffffffc0209d24:	7ba6                	ld	s7,104(sp)
ffffffffc0209d26:	59f1                	li	s3,-4
ffffffffc0209d28:	b739                	j	ffffffffc0209c36 <sfs_do_mount+0x1a4>
ffffffffc0209d2a:	00005697          	auipc	a3,0x5
ffffffffc0209d2e:	fe668693          	addi	a3,a3,-26 # ffffffffc020ed10 <etext+0x2fd8>
ffffffffc0209d32:	00002617          	auipc	a2,0x2
ffffffffc0209d36:	43e60613          	addi	a2,a2,1086 # ffffffffc020c170 <etext+0x438>
ffffffffc0209d3a:	08300593          	li	a1,131
ffffffffc0209d3e:	00005517          	auipc	a0,0x5
ffffffffc0209d42:	eda50513          	addi	a0,a0,-294 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209d46:	f8da                	sd	s6,112(sp)
ffffffffc0209d48:	f0e2                	sd	s8,96(sp)
ffffffffc0209d4a:	f00f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209d4e:	00005697          	auipc	a3,0x5
ffffffffc0209d52:	e9a68693          	addi	a3,a3,-358 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc0209d56:	00002617          	auipc	a2,0x2
ffffffffc0209d5a:	41a60613          	addi	a2,a2,1050 # ffffffffc020c170 <etext+0x438>
ffffffffc0209d5e:	0a300593          	li	a1,163
ffffffffc0209d62:	00005517          	auipc	a0,0x5
ffffffffc0209d66:	eb650513          	addi	a0,a0,-330 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209d6a:	fcd6                	sd	s5,120(sp)
ffffffffc0209d6c:	f8da                	sd	s6,112(sp)
ffffffffc0209d6e:	f0e2                	sd	s8,96(sp)
ffffffffc0209d70:	ece6                	sd	s9,88(sp)
ffffffffc0209d72:	e8ea                	sd	s10,80(sp)
ffffffffc0209d74:	e4ee                	sd	s11,72(sp)
ffffffffc0209d76:	ed4f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209d7a:	00005697          	auipc	a3,0x5
ffffffffc0209d7e:	fc668693          	addi	a3,a3,-58 # ffffffffc020ed40 <etext+0x3008>
ffffffffc0209d82:	00002617          	auipc	a2,0x2
ffffffffc0209d86:	3ee60613          	addi	a2,a2,1006 # ffffffffc020c170 <etext+0x438>
ffffffffc0209d8a:	0e000593          	li	a1,224
ffffffffc0209d8e:	00005517          	auipc	a0,0x5
ffffffffc0209d92:	e8a50513          	addi	a0,a0,-374 # ffffffffc020ec18 <etext+0x2ee0>
ffffffffc0209d96:	f8da                	sd	s6,112(sp)
ffffffffc0209d98:	eb2f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209d9c <sfs_mount>:
ffffffffc0209d9c:	00000597          	auipc	a1,0x0
ffffffffc0209da0:	cf658593          	addi	a1,a1,-778 # ffffffffc0209a92 <sfs_do_mount>
ffffffffc0209da4:	fccfe06f          	j	ffffffffc0208570 <vfs_mount>

ffffffffc0209da8 <sfs_opendir>:
ffffffffc0209da8:	0235f593          	andi	a1,a1,35
ffffffffc0209dac:	e199                	bnez	a1,ffffffffc0209db2 <sfs_opendir+0xa>
ffffffffc0209dae:	4501                	li	a0,0
ffffffffc0209db0:	8082                	ret
ffffffffc0209db2:	553d                	li	a0,-17
ffffffffc0209db4:	8082                	ret

ffffffffc0209db6 <sfs_openfile>:
ffffffffc0209db6:	4501                	li	a0,0
ffffffffc0209db8:	8082                	ret

ffffffffc0209dba <sfs_gettype>:
ffffffffc0209dba:	1141                	addi	sp,sp,-16
ffffffffc0209dbc:	e406                	sd	ra,8(sp)
ffffffffc0209dbe:	c529                	beqz	a0,ffffffffc0209e08 <sfs_gettype+0x4e>
ffffffffc0209dc0:	4d38                	lw	a4,88(a0)
ffffffffc0209dc2:	6785                	lui	a5,0x1
ffffffffc0209dc4:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209dc8:	04f71063          	bne	a4,a5,ffffffffc0209e08 <sfs_gettype+0x4e>
ffffffffc0209dcc:	6118                	ld	a4,0(a0)
ffffffffc0209dce:	4789                	li	a5,2
ffffffffc0209dd0:	00475683          	lhu	a3,4(a4)
ffffffffc0209dd4:	02f68463          	beq	a3,a5,ffffffffc0209dfc <sfs_gettype+0x42>
ffffffffc0209dd8:	478d                	li	a5,3
ffffffffc0209dda:	00f68b63          	beq	a3,a5,ffffffffc0209df0 <sfs_gettype+0x36>
ffffffffc0209dde:	4705                	li	a4,1
ffffffffc0209de0:	6785                	lui	a5,0x1
ffffffffc0209de2:	04e69363          	bne	a3,a4,ffffffffc0209e28 <sfs_gettype+0x6e>
ffffffffc0209de6:	60a2                	ld	ra,8(sp)
ffffffffc0209de8:	c19c                	sw	a5,0(a1)
ffffffffc0209dea:	4501                	li	a0,0
ffffffffc0209dec:	0141                	addi	sp,sp,16
ffffffffc0209dee:	8082                	ret
ffffffffc0209df0:	60a2                	ld	ra,8(sp)
ffffffffc0209df2:	678d                	lui	a5,0x3
ffffffffc0209df4:	c19c                	sw	a5,0(a1)
ffffffffc0209df6:	4501                	li	a0,0
ffffffffc0209df8:	0141                	addi	sp,sp,16
ffffffffc0209dfa:	8082                	ret
ffffffffc0209dfc:	60a2                	ld	ra,8(sp)
ffffffffc0209dfe:	6789                	lui	a5,0x2
ffffffffc0209e00:	c19c                	sw	a5,0(a1)
ffffffffc0209e02:	4501                	li	a0,0
ffffffffc0209e04:	0141                	addi	sp,sp,16
ffffffffc0209e06:	8082                	ret
ffffffffc0209e08:	00005697          	auipc	a3,0x5
ffffffffc0209e0c:	f8868693          	addi	a3,a3,-120 # ffffffffc020ed90 <etext+0x3058>
ffffffffc0209e10:	00002617          	auipc	a2,0x2
ffffffffc0209e14:	36060613          	addi	a2,a2,864 # ffffffffc020c170 <etext+0x438>
ffffffffc0209e18:	38600593          	li	a1,902
ffffffffc0209e1c:	00005517          	auipc	a0,0x5
ffffffffc0209e20:	fac50513          	addi	a0,a0,-84 # ffffffffc020edc8 <etext+0x3090>
ffffffffc0209e24:	e26f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209e28:	00005617          	auipc	a2,0x5
ffffffffc0209e2c:	fb860613          	addi	a2,a2,-72 # ffffffffc020ede0 <etext+0x30a8>
ffffffffc0209e30:	39200593          	li	a1,914
ffffffffc0209e34:	00005517          	auipc	a0,0x5
ffffffffc0209e38:	f9450513          	addi	a0,a0,-108 # ffffffffc020edc8 <etext+0x3090>
ffffffffc0209e3c:	e0ef60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209e40 <sfs_fsync>:
ffffffffc0209e40:	7530                	ld	a2,104(a0)
ffffffffc0209e42:	7179                	addi	sp,sp,-48
ffffffffc0209e44:	f406                	sd	ra,40(sp)
ffffffffc0209e46:	ca2d                	beqz	a2,ffffffffc0209eb8 <sfs_fsync+0x78>
ffffffffc0209e48:	0b062703          	lw	a4,176(a2)
ffffffffc0209e4c:	e735                	bnez	a4,ffffffffc0209eb8 <sfs_fsync+0x78>
ffffffffc0209e4e:	4d34                	lw	a3,88(a0)
ffffffffc0209e50:	6705                	lui	a4,0x1
ffffffffc0209e52:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209e56:	08e69263          	bne	a3,a4,ffffffffc0209eda <sfs_fsync+0x9a>
ffffffffc0209e5a:	6914                	ld	a3,16(a0)
ffffffffc0209e5c:	4701                	li	a4,0
ffffffffc0209e5e:	e689                	bnez	a3,ffffffffc0209e68 <sfs_fsync+0x28>
ffffffffc0209e60:	70a2                	ld	ra,40(sp)
ffffffffc0209e62:	853a                	mv	a0,a4
ffffffffc0209e64:	6145                	addi	sp,sp,48
ffffffffc0209e66:	8082                	ret
ffffffffc0209e68:	f022                	sd	s0,32(sp)
ffffffffc0209e6a:	e42a                	sd	a0,8(sp)
ffffffffc0209e6c:	02050413          	addi	s0,a0,32
ffffffffc0209e70:	02050513          	addi	a0,a0,32
ffffffffc0209e74:	ec3a                	sd	a4,24(sp)
ffffffffc0209e76:	e832                	sd	a2,16(sp)
ffffffffc0209e78:	fa0fa0ef          	jal	ffffffffc0204618 <down>
ffffffffc0209e7c:	67a2                	ld	a5,8(sp)
ffffffffc0209e7e:	6762                	ld	a4,24(sp)
ffffffffc0209e80:	6b94                	ld	a3,16(a5)
ffffffffc0209e82:	ea99                	bnez	a3,ffffffffc0209e98 <sfs_fsync+0x58>
ffffffffc0209e84:	8522                	mv	a0,s0
ffffffffc0209e86:	e43a                	sd	a4,8(sp)
ffffffffc0209e88:	f8cfa0ef          	jal	ffffffffc0204614 <up>
ffffffffc0209e8c:	6722                	ld	a4,8(sp)
ffffffffc0209e8e:	7402                	ld	s0,32(sp)
ffffffffc0209e90:	70a2                	ld	ra,40(sp)
ffffffffc0209e92:	853a                	mv	a0,a4
ffffffffc0209e94:	6145                	addi	sp,sp,48
ffffffffc0209e96:	8082                	ret
ffffffffc0209e98:	4794                	lw	a3,8(a5)
ffffffffc0209e9a:	638c                	ld	a1,0(a5)
ffffffffc0209e9c:	6542                	ld	a0,16(sp)
ffffffffc0209e9e:	4701                	li	a4,0
ffffffffc0209ea0:	0007b823          	sd	zero,16(a5) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc0209ea4:	04000613          	li	a2,64
ffffffffc0209ea8:	718010ef          	jal	ffffffffc020b5c0 <sfs_wbuf>
ffffffffc0209eac:	872a                	mv	a4,a0
ffffffffc0209eae:	d979                	beqz	a0,ffffffffc0209e84 <sfs_fsync+0x44>
ffffffffc0209eb0:	67a2                	ld	a5,8(sp)
ffffffffc0209eb2:	4685                	li	a3,1
ffffffffc0209eb4:	eb94                	sd	a3,16(a5)
ffffffffc0209eb6:	b7f9                	j	ffffffffc0209e84 <sfs_fsync+0x44>
ffffffffc0209eb8:	00005697          	auipc	a3,0x5
ffffffffc0209ebc:	d3068693          	addi	a3,a3,-720 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc0209ec0:	00002617          	auipc	a2,0x2
ffffffffc0209ec4:	2b060613          	addi	a2,a2,688 # ffffffffc020c170 <etext+0x438>
ffffffffc0209ec8:	2ca00593          	li	a1,714
ffffffffc0209ecc:	00005517          	auipc	a0,0x5
ffffffffc0209ed0:	efc50513          	addi	a0,a0,-260 # ffffffffc020edc8 <etext+0x3090>
ffffffffc0209ed4:	f022                	sd	s0,32(sp)
ffffffffc0209ed6:	d74f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209eda:	00005697          	auipc	a3,0x5
ffffffffc0209ede:	eb668693          	addi	a3,a3,-330 # ffffffffc020ed90 <etext+0x3058>
ffffffffc0209ee2:	00002617          	auipc	a2,0x2
ffffffffc0209ee6:	28e60613          	addi	a2,a2,654 # ffffffffc020c170 <etext+0x438>
ffffffffc0209eea:	2cb00593          	li	a1,715
ffffffffc0209eee:	00005517          	auipc	a0,0x5
ffffffffc0209ef2:	eda50513          	addi	a0,a0,-294 # ffffffffc020edc8 <etext+0x3090>
ffffffffc0209ef6:	f022                	sd	s0,32(sp)
ffffffffc0209ef8:	d52f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209efc <sfs_fstat>:
ffffffffc0209efc:	1101                	addi	sp,sp,-32
ffffffffc0209efe:	e822                	sd	s0,16(sp)
ffffffffc0209f00:	e426                	sd	s1,8(sp)
ffffffffc0209f02:	842a                	mv	s0,a0
ffffffffc0209f04:	84ae                	mv	s1,a1
ffffffffc0209f06:	852e                	mv	a0,a1
ffffffffc0209f08:	02000613          	li	a2,32
ffffffffc0209f0c:	4581                	li	a1,0
ffffffffc0209f0e:	ec06                	sd	ra,24(sp)
ffffffffc0209f10:	5c1010ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc0209f14:	c439                	beqz	s0,ffffffffc0209f62 <sfs_fstat+0x66>
ffffffffc0209f16:	783c                	ld	a5,112(s0)
ffffffffc0209f18:	c7a9                	beqz	a5,ffffffffc0209f62 <sfs_fstat+0x66>
ffffffffc0209f1a:	6bbc                	ld	a5,80(a5)
ffffffffc0209f1c:	c3b9                	beqz	a5,ffffffffc0209f62 <sfs_fstat+0x66>
ffffffffc0209f1e:	00005597          	auipc	a1,0x5
ffffffffc0209f22:	8da58593          	addi	a1,a1,-1830 # ffffffffc020e7f8 <etext+0x2ac0>
ffffffffc0209f26:	8522                	mv	a0,s0
ffffffffc0209f28:	85afe0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0209f2c:	783c                	ld	a5,112(s0)
ffffffffc0209f2e:	85a6                	mv	a1,s1
ffffffffc0209f30:	8522                	mv	a0,s0
ffffffffc0209f32:	6bbc                	ld	a5,80(a5)
ffffffffc0209f34:	9782                	jalr	a5
ffffffffc0209f36:	e10d                	bnez	a0,ffffffffc0209f58 <sfs_fstat+0x5c>
ffffffffc0209f38:	4c38                	lw	a4,88(s0)
ffffffffc0209f3a:	6785                	lui	a5,0x1
ffffffffc0209f3c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209f40:	04f71163          	bne	a4,a5,ffffffffc0209f82 <sfs_fstat+0x86>
ffffffffc0209f44:	601c                	ld	a5,0(s0)
ffffffffc0209f46:	0067d683          	lhu	a3,6(a5)
ffffffffc0209f4a:	0087e703          	lwu	a4,8(a5)
ffffffffc0209f4e:	0007e783          	lwu	a5,0(a5)
ffffffffc0209f52:	e494                	sd	a3,8(s1)
ffffffffc0209f54:	e898                	sd	a4,16(s1)
ffffffffc0209f56:	ec9c                	sd	a5,24(s1)
ffffffffc0209f58:	60e2                	ld	ra,24(sp)
ffffffffc0209f5a:	6442                	ld	s0,16(sp)
ffffffffc0209f5c:	64a2                	ld	s1,8(sp)
ffffffffc0209f5e:	6105                	addi	sp,sp,32
ffffffffc0209f60:	8082                	ret
ffffffffc0209f62:	00005697          	auipc	a3,0x5
ffffffffc0209f66:	82e68693          	addi	a3,a3,-2002 # ffffffffc020e790 <etext+0x2a58>
ffffffffc0209f6a:	00002617          	auipc	a2,0x2
ffffffffc0209f6e:	20660613          	addi	a2,a2,518 # ffffffffc020c170 <etext+0x438>
ffffffffc0209f72:	2bb00593          	li	a1,699
ffffffffc0209f76:	00005517          	auipc	a0,0x5
ffffffffc0209f7a:	e5250513          	addi	a0,a0,-430 # ffffffffc020edc8 <etext+0x3090>
ffffffffc0209f7e:	cccf60ef          	jal	ffffffffc020044a <__panic>
ffffffffc0209f82:	00005697          	auipc	a3,0x5
ffffffffc0209f86:	e0e68693          	addi	a3,a3,-498 # ffffffffc020ed90 <etext+0x3058>
ffffffffc0209f8a:	00002617          	auipc	a2,0x2
ffffffffc0209f8e:	1e660613          	addi	a2,a2,486 # ffffffffc020c170 <etext+0x438>
ffffffffc0209f92:	2be00593          	li	a1,702
ffffffffc0209f96:	00005517          	auipc	a0,0x5
ffffffffc0209f9a:	e3250513          	addi	a0,a0,-462 # ffffffffc020edc8 <etext+0x3090>
ffffffffc0209f9e:	cacf60ef          	jal	ffffffffc020044a <__panic>

ffffffffc0209fa2 <sfs_tryseek>:
ffffffffc0209fa2:	08000737          	lui	a4,0x8000
ffffffffc0209fa6:	04e5f863          	bgeu	a1,a4,ffffffffc0209ff6 <sfs_tryseek+0x54>
ffffffffc0209faa:	1101                	addi	sp,sp,-32
ffffffffc0209fac:	ec06                	sd	ra,24(sp)
ffffffffc0209fae:	c531                	beqz	a0,ffffffffc0209ffa <sfs_tryseek+0x58>
ffffffffc0209fb0:	4d30                	lw	a2,88(a0)
ffffffffc0209fb2:	6685                	lui	a3,0x1
ffffffffc0209fb4:	23568693          	addi	a3,a3,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209fb8:	04d61163          	bne	a2,a3,ffffffffc0209ffa <sfs_tryseek+0x58>
ffffffffc0209fbc:	6114                	ld	a3,0(a0)
ffffffffc0209fbe:	0006e683          	lwu	a3,0(a3)
ffffffffc0209fc2:	02b6d663          	bge	a3,a1,ffffffffc0209fee <sfs_tryseek+0x4c>
ffffffffc0209fc6:	7934                	ld	a3,112(a0)
ffffffffc0209fc8:	caa9                	beqz	a3,ffffffffc020a01a <sfs_tryseek+0x78>
ffffffffc0209fca:	72b4                	ld	a3,96(a3)
ffffffffc0209fcc:	c6b9                	beqz	a3,ffffffffc020a01a <sfs_tryseek+0x78>
ffffffffc0209fce:	e02e                	sd	a1,0(sp)
ffffffffc0209fd0:	00004597          	auipc	a1,0x4
ffffffffc0209fd4:	71858593          	addi	a1,a1,1816 # ffffffffc020e6e8 <etext+0x29b0>
ffffffffc0209fd8:	e42a                	sd	a0,8(sp)
ffffffffc0209fda:	fa9fd0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc0209fde:	67a2                	ld	a5,8(sp)
ffffffffc0209fe0:	6582                	ld	a1,0(sp)
ffffffffc0209fe2:	60e2                	ld	ra,24(sp)
ffffffffc0209fe4:	7bb4                	ld	a3,112(a5)
ffffffffc0209fe6:	853e                	mv	a0,a5
ffffffffc0209fe8:	72bc                	ld	a5,96(a3)
ffffffffc0209fea:	6105                	addi	sp,sp,32
ffffffffc0209fec:	8782                	jr	a5
ffffffffc0209fee:	60e2                	ld	ra,24(sp)
ffffffffc0209ff0:	4501                	li	a0,0
ffffffffc0209ff2:	6105                	addi	sp,sp,32
ffffffffc0209ff4:	8082                	ret
ffffffffc0209ff6:	5575                	li	a0,-3
ffffffffc0209ff8:	8082                	ret
ffffffffc0209ffa:	00005697          	auipc	a3,0x5
ffffffffc0209ffe:	d9668693          	addi	a3,a3,-618 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020a002:	00002617          	auipc	a2,0x2
ffffffffc020a006:	16e60613          	addi	a2,a2,366 # ffffffffc020c170 <etext+0x438>
ffffffffc020a00a:	39d00593          	li	a1,925
ffffffffc020a00e:	00005517          	auipc	a0,0x5
ffffffffc020a012:	dba50513          	addi	a0,a0,-582 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a016:	c34f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a01a:	00004697          	auipc	a3,0x4
ffffffffc020a01e:	67668693          	addi	a3,a3,1654 # ffffffffc020e690 <etext+0x2958>
ffffffffc020a022:	00002617          	auipc	a2,0x2
ffffffffc020a026:	14e60613          	addi	a2,a2,334 # ffffffffc020c170 <etext+0x438>
ffffffffc020a02a:	39f00593          	li	a1,927
ffffffffc020a02e:	00005517          	auipc	a0,0x5
ffffffffc020a032:	d9a50513          	addi	a0,a0,-614 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a036:	c14f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a03a <sfs_close>:
ffffffffc020a03a:	1141                	addi	sp,sp,-16
ffffffffc020a03c:	e406                	sd	ra,8(sp)
ffffffffc020a03e:	e022                	sd	s0,0(sp)
ffffffffc020a040:	c11d                	beqz	a0,ffffffffc020a066 <sfs_close+0x2c>
ffffffffc020a042:	793c                	ld	a5,112(a0)
ffffffffc020a044:	842a                	mv	s0,a0
ffffffffc020a046:	c385                	beqz	a5,ffffffffc020a066 <sfs_close+0x2c>
ffffffffc020a048:	7b9c                	ld	a5,48(a5)
ffffffffc020a04a:	cf91                	beqz	a5,ffffffffc020a066 <sfs_close+0x2c>
ffffffffc020a04c:	00004597          	auipc	a1,0x4
ffffffffc020a050:	a3458593          	addi	a1,a1,-1484 # ffffffffc020da80 <etext+0x1d48>
ffffffffc020a054:	f2ffd0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc020a058:	783c                	ld	a5,112(s0)
ffffffffc020a05a:	8522                	mv	a0,s0
ffffffffc020a05c:	6402                	ld	s0,0(sp)
ffffffffc020a05e:	60a2                	ld	ra,8(sp)
ffffffffc020a060:	7b9c                	ld	a5,48(a5)
ffffffffc020a062:	0141                	addi	sp,sp,16
ffffffffc020a064:	8782                	jr	a5
ffffffffc020a066:	00004697          	auipc	a3,0x4
ffffffffc020a06a:	9ca68693          	addi	a3,a3,-1590 # ffffffffc020da30 <etext+0x1cf8>
ffffffffc020a06e:	00002617          	auipc	a2,0x2
ffffffffc020a072:	10260613          	addi	a2,a2,258 # ffffffffc020c170 <etext+0x438>
ffffffffc020a076:	21c00593          	li	a1,540
ffffffffc020a07a:	00005517          	auipc	a0,0x5
ffffffffc020a07e:	d4e50513          	addi	a0,a0,-690 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a082:	bc8f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a086 <sfs_io.part.0>:
ffffffffc020a086:	1141                	addi	sp,sp,-16
ffffffffc020a088:	00005697          	auipc	a3,0x5
ffffffffc020a08c:	d0868693          	addi	a3,a3,-760 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020a090:	00002617          	auipc	a2,0x2
ffffffffc020a094:	0e060613          	addi	a2,a2,224 # ffffffffc020c170 <etext+0x438>
ffffffffc020a098:	29a00593          	li	a1,666
ffffffffc020a09c:	00005517          	auipc	a0,0x5
ffffffffc020a0a0:	d2c50513          	addi	a0,a0,-724 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a0a4:	e406                	sd	ra,8(sp)
ffffffffc020a0a6:	ba4f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a0aa <sfs_block_free>:
ffffffffc020a0aa:	1101                	addi	sp,sp,-32
ffffffffc020a0ac:	e822                	sd	s0,16(sp)
ffffffffc020a0ae:	e426                	sd	s1,8(sp)
ffffffffc020a0b0:	ec06                	sd	ra,24(sp)
ffffffffc020a0b2:	84ae                	mv	s1,a1
ffffffffc020a0b4:	842a                	mv	s0,a0
ffffffffc020a0b6:	c595                	beqz	a1,ffffffffc020a0e2 <sfs_block_free+0x38>
ffffffffc020a0b8:	415c                	lw	a5,4(a0)
ffffffffc020a0ba:	02f5f463          	bgeu	a1,a5,ffffffffc020a0e2 <sfs_block_free+0x38>
ffffffffc020a0be:	7d08                	ld	a0,56(a0)
ffffffffc020a0c0:	ebaff0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020a0c4:	ed0d                	bnez	a0,ffffffffc020a0fe <sfs_block_free+0x54>
ffffffffc020a0c6:	7c08                	ld	a0,56(s0)
ffffffffc020a0c8:	85a6                	mv	a1,s1
ffffffffc020a0ca:	ed8ff0ef          	jal	ffffffffc02097a2 <bitmap_free>
ffffffffc020a0ce:	441c                	lw	a5,8(s0)
ffffffffc020a0d0:	4705                	li	a4,1
ffffffffc020a0d2:	60e2                	ld	ra,24(sp)
ffffffffc020a0d4:	2785                	addiw	a5,a5,1
ffffffffc020a0d6:	e038                	sd	a4,64(s0)
ffffffffc020a0d8:	c41c                	sw	a5,8(s0)
ffffffffc020a0da:	6442                	ld	s0,16(sp)
ffffffffc020a0dc:	64a2                	ld	s1,8(sp)
ffffffffc020a0de:	6105                	addi	sp,sp,32
ffffffffc020a0e0:	8082                	ret
ffffffffc020a0e2:	4054                	lw	a3,4(s0)
ffffffffc020a0e4:	8726                	mv	a4,s1
ffffffffc020a0e6:	00005617          	auipc	a2,0x5
ffffffffc020a0ea:	d1260613          	addi	a2,a2,-750 # ffffffffc020edf8 <etext+0x30c0>
ffffffffc020a0ee:	05300593          	li	a1,83
ffffffffc020a0f2:	00005517          	auipc	a0,0x5
ffffffffc020a0f6:	cd650513          	addi	a0,a0,-810 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a0fa:	b50f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a0fe:	00005697          	auipc	a3,0x5
ffffffffc020a102:	d3268693          	addi	a3,a3,-718 # ffffffffc020ee30 <etext+0x30f8>
ffffffffc020a106:	00002617          	auipc	a2,0x2
ffffffffc020a10a:	06a60613          	addi	a2,a2,106 # ffffffffc020c170 <etext+0x438>
ffffffffc020a10e:	06a00593          	li	a1,106
ffffffffc020a112:	00005517          	auipc	a0,0x5
ffffffffc020a116:	cb650513          	addi	a0,a0,-842 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a11a:	b30f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a11e <sfs_reclaim>:
ffffffffc020a11e:	1101                	addi	sp,sp,-32
ffffffffc020a120:	e426                	sd	s1,8(sp)
ffffffffc020a122:	7524                	ld	s1,104(a0)
ffffffffc020a124:	ec06                	sd	ra,24(sp)
ffffffffc020a126:	e822                	sd	s0,16(sp)
ffffffffc020a128:	e04a                	sd	s2,0(sp)
ffffffffc020a12a:	0e048963          	beqz	s1,ffffffffc020a21c <sfs_reclaim+0xfe>
ffffffffc020a12e:	0b04a783          	lw	a5,176(s1)
ffffffffc020a132:	0e079563          	bnez	a5,ffffffffc020a21c <sfs_reclaim+0xfe>
ffffffffc020a136:	4d38                	lw	a4,88(a0)
ffffffffc020a138:	6785                	lui	a5,0x1
ffffffffc020a13a:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a13e:	842a                	mv	s0,a0
ffffffffc020a140:	10f71e63          	bne	a4,a5,ffffffffc020a25c <sfs_reclaim+0x13e>
ffffffffc020a144:	8526                	mv	a0,s1
ffffffffc020a146:	62e010ef          	jal	ffffffffc020b774 <lock_sfs_fs>
ffffffffc020a14a:	4c1c                	lw	a5,24(s0)
ffffffffc020a14c:	0ef05863          	blez	a5,ffffffffc020a23c <sfs_reclaim+0x11e>
ffffffffc020a150:	37fd                	addiw	a5,a5,-1
ffffffffc020a152:	cc1c                	sw	a5,24(s0)
ffffffffc020a154:	ebd9                	bnez	a5,ffffffffc020a1ea <sfs_reclaim+0xcc>
ffffffffc020a156:	05c42903          	lw	s2,92(s0)
ffffffffc020a15a:	08091863          	bnez	s2,ffffffffc020a1ea <sfs_reclaim+0xcc>
ffffffffc020a15e:	601c                	ld	a5,0(s0)
ffffffffc020a160:	0067d783          	lhu	a5,6(a5)
ffffffffc020a164:	e785                	bnez	a5,ffffffffc020a18c <sfs_reclaim+0x6e>
ffffffffc020a166:	783c                	ld	a5,112(s0)
ffffffffc020a168:	10078a63          	beqz	a5,ffffffffc020a27c <sfs_reclaim+0x15e>
ffffffffc020a16c:	73bc                	ld	a5,96(a5)
ffffffffc020a16e:	10078763          	beqz	a5,ffffffffc020a27c <sfs_reclaim+0x15e>
ffffffffc020a172:	00004597          	auipc	a1,0x4
ffffffffc020a176:	57658593          	addi	a1,a1,1398 # ffffffffc020e6e8 <etext+0x29b0>
ffffffffc020a17a:	8522                	mv	a0,s0
ffffffffc020a17c:	e07fd0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc020a180:	783c                	ld	a5,112(s0)
ffffffffc020a182:	8522                	mv	a0,s0
ffffffffc020a184:	4581                	li	a1,0
ffffffffc020a186:	73bc                	ld	a5,96(a5)
ffffffffc020a188:	9782                	jalr	a5
ffffffffc020a18a:	e559                	bnez	a0,ffffffffc020a218 <sfs_reclaim+0xfa>
ffffffffc020a18c:	681c                	ld	a5,16(s0)
ffffffffc020a18e:	c39d                	beqz	a5,ffffffffc020a1b4 <sfs_reclaim+0x96>
ffffffffc020a190:	783c                	ld	a5,112(s0)
ffffffffc020a192:	10078563          	beqz	a5,ffffffffc020a29c <sfs_reclaim+0x17e>
ffffffffc020a196:	7b9c                	ld	a5,48(a5)
ffffffffc020a198:	10078263          	beqz	a5,ffffffffc020a29c <sfs_reclaim+0x17e>
ffffffffc020a19c:	8522                	mv	a0,s0
ffffffffc020a19e:	00004597          	auipc	a1,0x4
ffffffffc020a1a2:	8e258593          	addi	a1,a1,-1822 # ffffffffc020da80 <etext+0x1d48>
ffffffffc020a1a6:	dddfd0ef          	jal	ffffffffc0207f82 <inode_check>
ffffffffc020a1aa:	783c                	ld	a5,112(s0)
ffffffffc020a1ac:	8522                	mv	a0,s0
ffffffffc020a1ae:	7b9c                	ld	a5,48(a5)
ffffffffc020a1b0:	9782                	jalr	a5
ffffffffc020a1b2:	e13d                	bnez	a0,ffffffffc020a218 <sfs_reclaim+0xfa>
ffffffffc020a1b4:	7c18                	ld	a4,56(s0)
ffffffffc020a1b6:	603c                	ld	a5,64(s0)
ffffffffc020a1b8:	8526                	mv	a0,s1
ffffffffc020a1ba:	e71c                	sd	a5,8(a4)
ffffffffc020a1bc:	e398                	sd	a4,0(a5)
ffffffffc020a1be:	6438                	ld	a4,72(s0)
ffffffffc020a1c0:	683c                	ld	a5,80(s0)
ffffffffc020a1c2:	e71c                	sd	a5,8(a4)
ffffffffc020a1c4:	e398                	sd	a4,0(a5)
ffffffffc020a1c6:	5be010ef          	jal	ffffffffc020b784 <unlock_sfs_fs>
ffffffffc020a1ca:	6008                	ld	a0,0(s0)
ffffffffc020a1cc:	00655783          	lhu	a5,6(a0)
ffffffffc020a1d0:	cb85                	beqz	a5,ffffffffc020a200 <sfs_reclaim+0xe2>
ffffffffc020a1d2:	85cf80ef          	jal	ffffffffc020222e <kfree>
ffffffffc020a1d6:	8522                	mv	a0,s0
ffffffffc020a1d8:	d43fd0ef          	jal	ffffffffc0207f1a <inode_kill>
ffffffffc020a1dc:	60e2                	ld	ra,24(sp)
ffffffffc020a1de:	6442                	ld	s0,16(sp)
ffffffffc020a1e0:	64a2                	ld	s1,8(sp)
ffffffffc020a1e2:	854a                	mv	a0,s2
ffffffffc020a1e4:	6902                	ld	s2,0(sp)
ffffffffc020a1e6:	6105                	addi	sp,sp,32
ffffffffc020a1e8:	8082                	ret
ffffffffc020a1ea:	5945                	li	s2,-15
ffffffffc020a1ec:	8526                	mv	a0,s1
ffffffffc020a1ee:	596010ef          	jal	ffffffffc020b784 <unlock_sfs_fs>
ffffffffc020a1f2:	60e2                	ld	ra,24(sp)
ffffffffc020a1f4:	6442                	ld	s0,16(sp)
ffffffffc020a1f6:	64a2                	ld	s1,8(sp)
ffffffffc020a1f8:	854a                	mv	a0,s2
ffffffffc020a1fa:	6902                	ld	s2,0(sp)
ffffffffc020a1fc:	6105                	addi	sp,sp,32
ffffffffc020a1fe:	8082                	ret
ffffffffc020a200:	440c                	lw	a1,8(s0)
ffffffffc020a202:	8526                	mv	a0,s1
ffffffffc020a204:	ea7ff0ef          	jal	ffffffffc020a0aa <sfs_block_free>
ffffffffc020a208:	6008                	ld	a0,0(s0)
ffffffffc020a20a:	5d4c                	lw	a1,60(a0)
ffffffffc020a20c:	d1f9                	beqz	a1,ffffffffc020a1d2 <sfs_reclaim+0xb4>
ffffffffc020a20e:	8526                	mv	a0,s1
ffffffffc020a210:	e9bff0ef          	jal	ffffffffc020a0aa <sfs_block_free>
ffffffffc020a214:	6008                	ld	a0,0(s0)
ffffffffc020a216:	bf75                	j	ffffffffc020a1d2 <sfs_reclaim+0xb4>
ffffffffc020a218:	892a                	mv	s2,a0
ffffffffc020a21a:	bfc9                	j	ffffffffc020a1ec <sfs_reclaim+0xce>
ffffffffc020a21c:	00005697          	auipc	a3,0x5
ffffffffc020a220:	9cc68693          	addi	a3,a3,-1588 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020a224:	00002617          	auipc	a2,0x2
ffffffffc020a228:	f4c60613          	addi	a2,a2,-180 # ffffffffc020c170 <etext+0x438>
ffffffffc020a22c:	35b00593          	li	a1,859
ffffffffc020a230:	00005517          	auipc	a0,0x5
ffffffffc020a234:	b9850513          	addi	a0,a0,-1128 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a238:	a12f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a23c:	00005697          	auipc	a3,0x5
ffffffffc020a240:	c1468693          	addi	a3,a3,-1004 # ffffffffc020ee50 <etext+0x3118>
ffffffffc020a244:	00002617          	auipc	a2,0x2
ffffffffc020a248:	f2c60613          	addi	a2,a2,-212 # ffffffffc020c170 <etext+0x438>
ffffffffc020a24c:	36100593          	li	a1,865
ffffffffc020a250:	00005517          	auipc	a0,0x5
ffffffffc020a254:	b7850513          	addi	a0,a0,-1160 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a258:	9f2f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a25c:	00005697          	auipc	a3,0x5
ffffffffc020a260:	b3468693          	addi	a3,a3,-1228 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020a264:	00002617          	auipc	a2,0x2
ffffffffc020a268:	f0c60613          	addi	a2,a2,-244 # ffffffffc020c170 <etext+0x438>
ffffffffc020a26c:	35c00593          	li	a1,860
ffffffffc020a270:	00005517          	auipc	a0,0x5
ffffffffc020a274:	b5850513          	addi	a0,a0,-1192 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a278:	9d2f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a27c:	00004697          	auipc	a3,0x4
ffffffffc020a280:	41468693          	addi	a3,a3,1044 # ffffffffc020e690 <etext+0x2958>
ffffffffc020a284:	00002617          	auipc	a2,0x2
ffffffffc020a288:	eec60613          	addi	a2,a2,-276 # ffffffffc020c170 <etext+0x438>
ffffffffc020a28c:	36600593          	li	a1,870
ffffffffc020a290:	00005517          	auipc	a0,0x5
ffffffffc020a294:	b3850513          	addi	a0,a0,-1224 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a298:	9b2f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a29c:	00003697          	auipc	a3,0x3
ffffffffc020a2a0:	79468693          	addi	a3,a3,1940 # ffffffffc020da30 <etext+0x1cf8>
ffffffffc020a2a4:	00002617          	auipc	a2,0x2
ffffffffc020a2a8:	ecc60613          	addi	a2,a2,-308 # ffffffffc020c170 <etext+0x438>
ffffffffc020a2ac:	36b00593          	li	a1,875
ffffffffc020a2b0:	00005517          	auipc	a0,0x5
ffffffffc020a2b4:	b1850513          	addi	a0,a0,-1256 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a2b8:	992f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a2bc <sfs_block_alloc>:
ffffffffc020a2bc:	1101                	addi	sp,sp,-32
ffffffffc020a2be:	e822                	sd	s0,16(sp)
ffffffffc020a2c0:	842a                	mv	s0,a0
ffffffffc020a2c2:	7d08                	ld	a0,56(a0)
ffffffffc020a2c4:	e426                	sd	s1,8(sp)
ffffffffc020a2c6:	ec06                	sd	ra,24(sp)
ffffffffc020a2c8:	84ae                	mv	s1,a1
ffffffffc020a2ca:	c3eff0ef          	jal	ffffffffc0209708 <bitmap_alloc>
ffffffffc020a2ce:	e90d                	bnez	a0,ffffffffc020a300 <sfs_block_alloc+0x44>
ffffffffc020a2d0:	441c                	lw	a5,8(s0)
ffffffffc020a2d2:	cbb5                	beqz	a5,ffffffffc020a346 <sfs_block_alloc+0x8a>
ffffffffc020a2d4:	37fd                	addiw	a5,a5,-1
ffffffffc020a2d6:	c41c                	sw	a5,8(s0)
ffffffffc020a2d8:	408c                	lw	a1,0(s1)
ffffffffc020a2da:	4605                	li	a2,1
ffffffffc020a2dc:	e030                	sd	a2,64(s0)
ffffffffc020a2de:	c595                	beqz	a1,ffffffffc020a30a <sfs_block_alloc+0x4e>
ffffffffc020a2e0:	405c                	lw	a5,4(s0)
ffffffffc020a2e2:	02f5f463          	bgeu	a1,a5,ffffffffc020a30a <sfs_block_alloc+0x4e>
ffffffffc020a2e6:	7c08                	ld	a0,56(s0)
ffffffffc020a2e8:	c92ff0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020a2ec:	4605                	li	a2,1
ffffffffc020a2ee:	ed05                	bnez	a0,ffffffffc020a326 <sfs_block_alloc+0x6a>
ffffffffc020a2f0:	8522                	mv	a0,s0
ffffffffc020a2f2:	6442                	ld	s0,16(sp)
ffffffffc020a2f4:	408c                	lw	a1,0(s1)
ffffffffc020a2f6:	60e2                	ld	ra,24(sp)
ffffffffc020a2f8:	64a2                	ld	s1,8(sp)
ffffffffc020a2fa:	6105                	addi	sp,sp,32
ffffffffc020a2fc:	4180106f          	j	ffffffffc020b714 <sfs_clear_block>
ffffffffc020a300:	60e2                	ld	ra,24(sp)
ffffffffc020a302:	6442                	ld	s0,16(sp)
ffffffffc020a304:	64a2                	ld	s1,8(sp)
ffffffffc020a306:	6105                	addi	sp,sp,32
ffffffffc020a308:	8082                	ret
ffffffffc020a30a:	4054                	lw	a3,4(s0)
ffffffffc020a30c:	872e                	mv	a4,a1
ffffffffc020a30e:	00005617          	auipc	a2,0x5
ffffffffc020a312:	aea60613          	addi	a2,a2,-1302 # ffffffffc020edf8 <etext+0x30c0>
ffffffffc020a316:	05300593          	li	a1,83
ffffffffc020a31a:	00005517          	auipc	a0,0x5
ffffffffc020a31e:	aae50513          	addi	a0,a0,-1362 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a322:	928f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a326:	00005697          	auipc	a3,0x5
ffffffffc020a32a:	b6268693          	addi	a3,a3,-1182 # ffffffffc020ee88 <etext+0x3150>
ffffffffc020a32e:	00002617          	auipc	a2,0x2
ffffffffc020a332:	e4260613          	addi	a2,a2,-446 # ffffffffc020c170 <etext+0x438>
ffffffffc020a336:	06100593          	li	a1,97
ffffffffc020a33a:	00005517          	auipc	a0,0x5
ffffffffc020a33e:	a8e50513          	addi	a0,a0,-1394 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a342:	908f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a346:	00005697          	auipc	a3,0x5
ffffffffc020a34a:	b2268693          	addi	a3,a3,-1246 # ffffffffc020ee68 <etext+0x3130>
ffffffffc020a34e:	00002617          	auipc	a2,0x2
ffffffffc020a352:	e2260613          	addi	a2,a2,-478 # ffffffffc020c170 <etext+0x438>
ffffffffc020a356:	05f00593          	li	a1,95
ffffffffc020a35a:	00005517          	auipc	a0,0x5
ffffffffc020a35e:	a6e50513          	addi	a0,a0,-1426 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a362:	8e8f60ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a366 <sfs_bmap_load_nolock>:
ffffffffc020a366:	711d                	addi	sp,sp,-96
ffffffffc020a368:	e4a6                	sd	s1,72(sp)
ffffffffc020a36a:	6184                	ld	s1,0(a1)
ffffffffc020a36c:	e0ca                	sd	s2,64(sp)
ffffffffc020a36e:	ec86                	sd	ra,88(sp)
ffffffffc020a370:	0084a903          	lw	s2,8(s1)
ffffffffc020a374:	e8a2                	sd	s0,80(sp)
ffffffffc020a376:	fc4e                	sd	s3,56(sp)
ffffffffc020a378:	f852                	sd	s4,48(sp)
ffffffffc020a37a:	1ac96663          	bltu	s2,a2,ffffffffc020a526 <sfs_bmap_load_nolock+0x1c0>
ffffffffc020a37e:	47ad                	li	a5,11
ffffffffc020a380:	882e                	mv	a6,a1
ffffffffc020a382:	8432                	mv	s0,a2
ffffffffc020a384:	8a36                	mv	s4,a3
ffffffffc020a386:	89aa                	mv	s3,a0
ffffffffc020a388:	04c7f963          	bgeu	a5,a2,ffffffffc020a3da <sfs_bmap_load_nolock+0x74>
ffffffffc020a38c:	ff46079b          	addiw	a5,a2,-12
ffffffffc020a390:	3ff00713          	li	a4,1023
ffffffffc020a394:	f456                	sd	s5,40(sp)
ffffffffc020a396:	1af76a63          	bltu	a4,a5,ffffffffc020a54a <sfs_bmap_load_nolock+0x1e4>
ffffffffc020a39a:	03c4a883          	lw	a7,60(s1)
ffffffffc020a39e:	02079713          	slli	a4,a5,0x20
ffffffffc020a3a2:	01e75793          	srli	a5,a4,0x1e
ffffffffc020a3a6:	ce02                	sw	zero,28(sp)
ffffffffc020a3a8:	cc46                	sw	a7,24(sp)
ffffffffc020a3aa:	8abe                	mv	s5,a5
ffffffffc020a3ac:	12089063          	bnez	a7,ffffffffc020a4cc <sfs_bmap_load_nolock+0x166>
ffffffffc020a3b0:	08c90c63          	beq	s2,a2,ffffffffc020a448 <sfs_bmap_load_nolock+0xe2>
ffffffffc020a3b4:	7aa2                	ld	s5,40(sp)
ffffffffc020a3b6:	4581                	li	a1,0
ffffffffc020a3b8:	0049a683          	lw	a3,4(s3)
ffffffffc020a3bc:	f456                	sd	s5,40(sp)
ffffffffc020a3be:	f05a                	sd	s6,32(sp)
ffffffffc020a3c0:	872e                	mv	a4,a1
ffffffffc020a3c2:	00005617          	auipc	a2,0x5
ffffffffc020a3c6:	a3660613          	addi	a2,a2,-1482 # ffffffffc020edf8 <etext+0x30c0>
ffffffffc020a3ca:	05300593          	li	a1,83
ffffffffc020a3ce:	00005517          	auipc	a0,0x5
ffffffffc020a3d2:	9fa50513          	addi	a0,a0,-1542 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a3d6:	874f60ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a3da:	02061793          	slli	a5,a2,0x20
ffffffffc020a3de:	01e7d713          	srli	a4,a5,0x1e
ffffffffc020a3e2:	9726                	add	a4,a4,s1
ffffffffc020a3e4:	474c                	lw	a1,12(a4)
ffffffffc020a3e6:	ca2e                	sw	a1,20(sp)
ffffffffc020a3e8:	e581                	bnez	a1,ffffffffc020a3f0 <sfs_bmap_load_nolock+0x8a>
ffffffffc020a3ea:	0cc90063          	beq	s2,a2,ffffffffc020a4aa <sfs_bmap_load_nolock+0x144>
ffffffffc020a3ee:	d5e1                	beqz	a1,ffffffffc020a3b6 <sfs_bmap_load_nolock+0x50>
ffffffffc020a3f0:	0049a683          	lw	a3,4(s3)
ffffffffc020a3f4:	16d5f863          	bgeu	a1,a3,ffffffffc020a564 <sfs_bmap_load_nolock+0x1fe>
ffffffffc020a3f8:	0389b503          	ld	a0,56(s3)
ffffffffc020a3fc:	b7eff0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020a400:	18051763          	bnez	a0,ffffffffc020a58e <sfs_bmap_load_nolock+0x228>
ffffffffc020a404:	45d2                	lw	a1,20(sp)
ffffffffc020a406:	0049a783          	lw	a5,4(s3)
ffffffffc020a40a:	d5d5                	beqz	a1,ffffffffc020a3b6 <sfs_bmap_load_nolock+0x50>
ffffffffc020a40c:	faf5f6e3          	bgeu	a1,a5,ffffffffc020a3b8 <sfs_bmap_load_nolock+0x52>
ffffffffc020a410:	0389b503          	ld	a0,56(s3)
ffffffffc020a414:	e02e                	sd	a1,0(sp)
ffffffffc020a416:	b64ff0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020a41a:	6582                	ld	a1,0(sp)
ffffffffc020a41c:	14051763          	bnez	a0,ffffffffc020a56a <sfs_bmap_load_nolock+0x204>
ffffffffc020a420:	02890063          	beq	s2,s0,ffffffffc020a440 <sfs_bmap_load_nolock+0xda>
ffffffffc020a424:	000a0463          	beqz	s4,ffffffffc020a42c <sfs_bmap_load_nolock+0xc6>
ffffffffc020a428:	00ba2023          	sw	a1,0(s4)
ffffffffc020a42c:	4781                	li	a5,0
ffffffffc020a42e:	6446                	ld	s0,80(sp)
ffffffffc020a430:	60e6                	ld	ra,88(sp)
ffffffffc020a432:	79e2                	ld	s3,56(sp)
ffffffffc020a434:	7a42                	ld	s4,48(sp)
ffffffffc020a436:	64a6                	ld	s1,72(sp)
ffffffffc020a438:	6906                	ld	s2,64(sp)
ffffffffc020a43a:	853e                	mv	a0,a5
ffffffffc020a43c:	6125                	addi	sp,sp,96
ffffffffc020a43e:	8082                	ret
ffffffffc020a440:	449c                	lw	a5,8(s1)
ffffffffc020a442:	2785                	addiw	a5,a5,1
ffffffffc020a444:	c49c                	sw	a5,8(s1)
ffffffffc020a446:	bff9                	j	ffffffffc020a424 <sfs_bmap_load_nolock+0xbe>
ffffffffc020a448:	082c                	addi	a1,sp,24
ffffffffc020a44a:	e046                	sd	a7,0(sp)
ffffffffc020a44c:	e442                	sd	a6,8(sp)
ffffffffc020a44e:	e6fff0ef          	jal	ffffffffc020a2bc <sfs_block_alloc>
ffffffffc020a452:	87aa                	mv	a5,a0
ffffffffc020a454:	ed5d                	bnez	a0,ffffffffc020a512 <sfs_bmap_load_nolock+0x1ac>
ffffffffc020a456:	6882                	ld	a7,0(sp)
ffffffffc020a458:	6822                	ld	a6,8(sp)
ffffffffc020a45a:	f05a                	sd	s6,32(sp)
ffffffffc020a45c:	01c10b13          	addi	s6,sp,28
ffffffffc020a460:	85da                	mv	a1,s6
ffffffffc020a462:	854e                	mv	a0,s3
ffffffffc020a464:	e046                	sd	a7,0(sp)
ffffffffc020a466:	e442                	sd	a6,8(sp)
ffffffffc020a468:	e55ff0ef          	jal	ffffffffc020a2bc <sfs_block_alloc>
ffffffffc020a46c:	6882                	ld	a7,0(sp)
ffffffffc020a46e:	87aa                	mv	a5,a0
ffffffffc020a470:	e959                	bnez	a0,ffffffffc020a506 <sfs_bmap_load_nolock+0x1a0>
ffffffffc020a472:	46e2                	lw	a3,24(sp)
ffffffffc020a474:	85da                	mv	a1,s6
ffffffffc020a476:	8756                	mv	a4,s5
ffffffffc020a478:	4611                	li	a2,4
ffffffffc020a47a:	854e                	mv	a0,s3
ffffffffc020a47c:	e046                	sd	a7,0(sp)
ffffffffc020a47e:	142010ef          	jal	ffffffffc020b5c0 <sfs_wbuf>
ffffffffc020a482:	45f2                	lw	a1,28(sp)
ffffffffc020a484:	6882                	ld	a7,0(sp)
ffffffffc020a486:	e92d                	bnez	a0,ffffffffc020a4f8 <sfs_bmap_load_nolock+0x192>
ffffffffc020a488:	5cd8                	lw	a4,60(s1)
ffffffffc020a48a:	47e2                	lw	a5,24(sp)
ffffffffc020a48c:	6822                	ld	a6,8(sp)
ffffffffc020a48e:	ca2e                	sw	a1,20(sp)
ffffffffc020a490:	00f70863          	beq	a4,a5,ffffffffc020a4a0 <sfs_bmap_load_nolock+0x13a>
ffffffffc020a494:	10071f63          	bnez	a4,ffffffffc020a5b2 <sfs_bmap_load_nolock+0x24c>
ffffffffc020a498:	dcdc                	sw	a5,60(s1)
ffffffffc020a49a:	4785                	li	a5,1
ffffffffc020a49c:	00f83823          	sd	a5,16(a6)
ffffffffc020a4a0:	7aa2                	ld	s5,40(sp)
ffffffffc020a4a2:	7b02                	ld	s6,32(sp)
ffffffffc020a4a4:	f00589e3          	beqz	a1,ffffffffc020a3b6 <sfs_bmap_load_nolock+0x50>
ffffffffc020a4a8:	b7a1                	j	ffffffffc020a3f0 <sfs_bmap_load_nolock+0x8a>
ffffffffc020a4aa:	084c                	addi	a1,sp,20
ffffffffc020a4ac:	e03a                	sd	a4,0(sp)
ffffffffc020a4ae:	e442                	sd	a6,8(sp)
ffffffffc020a4b0:	e0dff0ef          	jal	ffffffffc020a2bc <sfs_block_alloc>
ffffffffc020a4b4:	87aa                	mv	a5,a0
ffffffffc020a4b6:	fd25                	bnez	a0,ffffffffc020a42e <sfs_bmap_load_nolock+0xc8>
ffffffffc020a4b8:	45d2                	lw	a1,20(sp)
ffffffffc020a4ba:	6702                	ld	a4,0(sp)
ffffffffc020a4bc:	6822                	ld	a6,8(sp)
ffffffffc020a4be:	4785                	li	a5,1
ffffffffc020a4c0:	c74c                	sw	a1,12(a4)
ffffffffc020a4c2:	00f83823          	sd	a5,16(a6)
ffffffffc020a4c6:	ee0588e3          	beqz	a1,ffffffffc020a3b6 <sfs_bmap_load_nolock+0x50>
ffffffffc020a4ca:	b71d                	j	ffffffffc020a3f0 <sfs_bmap_load_nolock+0x8a>
ffffffffc020a4cc:	e02e                	sd	a1,0(sp)
ffffffffc020a4ce:	873e                	mv	a4,a5
ffffffffc020a4d0:	086c                	addi	a1,sp,28
ffffffffc020a4d2:	86c6                	mv	a3,a7
ffffffffc020a4d4:	4611                	li	a2,4
ffffffffc020a4d6:	f05a                	sd	s6,32(sp)
ffffffffc020a4d8:	e446                	sd	a7,8(sp)
ffffffffc020a4da:	066010ef          	jal	ffffffffc020b540 <sfs_rbuf>
ffffffffc020a4de:	01c10b13          	addi	s6,sp,28
ffffffffc020a4e2:	87aa                	mv	a5,a0
ffffffffc020a4e4:	e505                	bnez	a0,ffffffffc020a50c <sfs_bmap_load_nolock+0x1a6>
ffffffffc020a4e6:	45f2                	lw	a1,28(sp)
ffffffffc020a4e8:	6802                	ld	a6,0(sp)
ffffffffc020a4ea:	00891463          	bne	s2,s0,ffffffffc020a4f2 <sfs_bmap_load_nolock+0x18c>
ffffffffc020a4ee:	68a2                	ld	a7,8(sp)
ffffffffc020a4f0:	d9a5                	beqz	a1,ffffffffc020a460 <sfs_bmap_load_nolock+0xfa>
ffffffffc020a4f2:	5cd8                	lw	a4,60(s1)
ffffffffc020a4f4:	47e2                	lw	a5,24(sp)
ffffffffc020a4f6:	bf61                	j	ffffffffc020a48e <sfs_bmap_load_nolock+0x128>
ffffffffc020a4f8:	e42a                	sd	a0,8(sp)
ffffffffc020a4fa:	854e                	mv	a0,s3
ffffffffc020a4fc:	e046                	sd	a7,0(sp)
ffffffffc020a4fe:	badff0ef          	jal	ffffffffc020a0aa <sfs_block_free>
ffffffffc020a502:	6882                	ld	a7,0(sp)
ffffffffc020a504:	67a2                	ld	a5,8(sp)
ffffffffc020a506:	45e2                	lw	a1,24(sp)
ffffffffc020a508:	00b89763          	bne	a7,a1,ffffffffc020a516 <sfs_bmap_load_nolock+0x1b0>
ffffffffc020a50c:	7aa2                	ld	s5,40(sp)
ffffffffc020a50e:	7b02                	ld	s6,32(sp)
ffffffffc020a510:	bf39                	j	ffffffffc020a42e <sfs_bmap_load_nolock+0xc8>
ffffffffc020a512:	7aa2                	ld	s5,40(sp)
ffffffffc020a514:	bf29                	j	ffffffffc020a42e <sfs_bmap_load_nolock+0xc8>
ffffffffc020a516:	854e                	mv	a0,s3
ffffffffc020a518:	e03e                	sd	a5,0(sp)
ffffffffc020a51a:	b91ff0ef          	jal	ffffffffc020a0aa <sfs_block_free>
ffffffffc020a51e:	6782                	ld	a5,0(sp)
ffffffffc020a520:	7aa2                	ld	s5,40(sp)
ffffffffc020a522:	7b02                	ld	s6,32(sp)
ffffffffc020a524:	b729                	j	ffffffffc020a42e <sfs_bmap_load_nolock+0xc8>
ffffffffc020a526:	00005697          	auipc	a3,0x5
ffffffffc020a52a:	98a68693          	addi	a3,a3,-1654 # ffffffffc020eeb0 <etext+0x3178>
ffffffffc020a52e:	00002617          	auipc	a2,0x2
ffffffffc020a532:	c4260613          	addi	a2,a2,-958 # ffffffffc020c170 <etext+0x438>
ffffffffc020a536:	16400593          	li	a1,356
ffffffffc020a53a:	00005517          	auipc	a0,0x5
ffffffffc020a53e:	88e50513          	addi	a0,a0,-1906 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a542:	f456                	sd	s5,40(sp)
ffffffffc020a544:	f05a                	sd	s6,32(sp)
ffffffffc020a546:	f05f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a54a:	00005617          	auipc	a2,0x5
ffffffffc020a54e:	99660613          	addi	a2,a2,-1642 # ffffffffc020eee0 <etext+0x31a8>
ffffffffc020a552:	11e00593          	li	a1,286
ffffffffc020a556:	00005517          	auipc	a0,0x5
ffffffffc020a55a:	87250513          	addi	a0,a0,-1934 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a55e:	f05a                	sd	s6,32(sp)
ffffffffc020a560:	eebf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a564:	f456                	sd	s5,40(sp)
ffffffffc020a566:	f05a                	sd	s6,32(sp)
ffffffffc020a568:	bda1                	j	ffffffffc020a3c0 <sfs_bmap_load_nolock+0x5a>
ffffffffc020a56a:	00005697          	auipc	a3,0x5
ffffffffc020a56e:	8c668693          	addi	a3,a3,-1850 # ffffffffc020ee30 <etext+0x30f8>
ffffffffc020a572:	00002617          	auipc	a2,0x2
ffffffffc020a576:	bfe60613          	addi	a2,a2,-1026 # ffffffffc020c170 <etext+0x438>
ffffffffc020a57a:	16b00593          	li	a1,363
ffffffffc020a57e:	00005517          	auipc	a0,0x5
ffffffffc020a582:	84a50513          	addi	a0,a0,-1974 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a586:	f456                	sd	s5,40(sp)
ffffffffc020a588:	f05a                	sd	s6,32(sp)
ffffffffc020a58a:	ec1f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a58e:	00005697          	auipc	a3,0x5
ffffffffc020a592:	98268693          	addi	a3,a3,-1662 # ffffffffc020ef10 <etext+0x31d8>
ffffffffc020a596:	00002617          	auipc	a2,0x2
ffffffffc020a59a:	bda60613          	addi	a2,a2,-1062 # ffffffffc020c170 <etext+0x438>
ffffffffc020a59e:	12100593          	li	a1,289
ffffffffc020a5a2:	00005517          	auipc	a0,0x5
ffffffffc020a5a6:	82650513          	addi	a0,a0,-2010 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a5aa:	f456                	sd	s5,40(sp)
ffffffffc020a5ac:	f05a                	sd	s6,32(sp)
ffffffffc020a5ae:	e9df50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a5b2:	00005697          	auipc	a3,0x5
ffffffffc020a5b6:	91668693          	addi	a3,a3,-1770 # ffffffffc020eec8 <etext+0x3190>
ffffffffc020a5ba:	00002617          	auipc	a2,0x2
ffffffffc020a5be:	bb660613          	addi	a2,a2,-1098 # ffffffffc020c170 <etext+0x438>
ffffffffc020a5c2:	11800593          	li	a1,280
ffffffffc020a5c6:	00005517          	auipc	a0,0x5
ffffffffc020a5ca:	80250513          	addi	a0,a0,-2046 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a5ce:	e7df50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a5d2 <sfs_io_nolock>:
ffffffffc020a5d2:	7175                	addi	sp,sp,-144
ffffffffc020a5d4:	f8ca                	sd	s2,112(sp)
ffffffffc020a5d6:	892e                	mv	s2,a1
ffffffffc020a5d8:	618c                	ld	a1,0(a1)
ffffffffc020a5da:	e506                	sd	ra,136(sp)
ffffffffc020a5dc:	4809                	li	a6,2
ffffffffc020a5de:	0045d883          	lhu	a7,4(a1)
ffffffffc020a5e2:	e122                	sd	s0,128(sp)
ffffffffc020a5e4:	fca6                	sd	s1,120(sp)
ffffffffc020a5e6:	1d088a63          	beq	a7,a6,ffffffffc020a7ba <sfs_io_nolock+0x1e8>
ffffffffc020a5ea:	00073803          	ld	a6,0(a4) # 8000000 <_binary_bin_sfs_img_size+0x7f8ad00>
ffffffffc020a5ee:	84ba                	mv	s1,a4
ffffffffc020a5f0:	0004b023          	sd	zero,0(s1)
ffffffffc020a5f4:	08000737          	lui	a4,0x8000
ffffffffc020a5f8:	8436                	mv	s0,a3
ffffffffc020a5fa:	9836                	add	a6,a6,a3
ffffffffc020a5fc:	8336                	mv	t1,a3
ffffffffc020a5fe:	1ae6fc63          	bgeu	a3,a4,ffffffffc020a7b6 <sfs_io_nolock+0x1e4>
ffffffffc020a602:	1ad84a63          	blt	a6,a3,ffffffffc020a7b6 <sfs_io_nolock+0x1e4>
ffffffffc020a606:	f4ce                	sd	s3,104(sp)
ffffffffc020a608:	89aa                	mv	s3,a0
ffffffffc020a60a:	4501                	li	a0,0
ffffffffc020a60c:	13068d63          	beq	a3,a6,ffffffffc020a746 <sfs_io_nolock+0x174>
ffffffffc020a610:	f0d2                	sd	s4,96(sp)
ffffffffc020a612:	e8da                	sd	s6,80(sp)
ffffffffc020a614:	e4de                	sd	s7,72(sp)
ffffffffc020a616:	8a32                	mv	s4,a2
ffffffffc020a618:	01077363          	bgeu	a4,a6,ffffffffc020a61e <sfs_io_nolock+0x4c>
ffffffffc020a61c:	883a                	mv	a6,a4
ffffffffc020a61e:	cfd5                	beqz	a5,ffffffffc020a6da <sfs_io_nolock+0x108>
ffffffffc020a620:	ecd6                	sd	s5,88(sp)
ffffffffc020a622:	00001b97          	auipc	s7,0x1
ffffffffc020a626:	ebcb8b93          	addi	s7,s7,-324 # ffffffffc020b4de <sfs_wblock>
ffffffffc020a62a:	00001b17          	auipc	s6,0x1
ffffffffc020a62e:	f96b0b13          	addi	s6,s6,-106 # ffffffffc020b5c0 <sfs_wbuf>
ffffffffc020a632:	6605                	lui	a2,0x1
ffffffffc020a634:	40c45693          	srai	a3,s0,0xc
ffffffffc020a638:	fff60713          	addi	a4,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020a63c:	40c85793          	srai	a5,a6,0xc
ffffffffc020a640:	9f95                	subw	a5,a5,a3
ffffffffc020a642:	8f61                	and	a4,a4,s0
ffffffffc020a644:	00068a9b          	sext.w	s5,a3
ffffffffc020a648:	8e3e                	mv	t3,a5
ffffffffc020a64a:	cb4d                	beqz	a4,ffffffffc020a6fc <sfs_io_nolock+0x12a>
ffffffffc020a64c:	40880e33          	sub	t3,a6,s0
ffffffffc020a650:	10079263          	bnez	a5,ffffffffc020a754 <sfs_io_nolock+0x182>
ffffffffc020a654:	1874                	addi	a3,sp,60
ffffffffc020a656:	8656                	mv	a2,s5
ffffffffc020a658:	85ca                	mv	a1,s2
ffffffffc020a65a:	854e                	mv	a0,s3
ffffffffc020a65c:	e41a                	sd	t1,8(sp)
ffffffffc020a65e:	f43e                	sd	a5,40(sp)
ffffffffc020a660:	ec3a                	sd	a4,24(sp)
ffffffffc020a662:	f042                	sd	a6,32(sp)
ffffffffc020a664:	e872                	sd	t3,16(sp)
ffffffffc020a666:	d01ff0ef          	jal	ffffffffc020a366 <sfs_bmap_load_nolock>
ffffffffc020a66a:	6322                	ld	t1,8(sp)
ffffffffc020a66c:	4881                	li	a7,0
ffffffffc020a66e:	ed0d                	bnez	a0,ffffffffc020a6a8 <sfs_io_nolock+0xd6>
ffffffffc020a670:	56f2                	lw	a3,60(sp)
ffffffffc020a672:	6762                	ld	a4,24(sp)
ffffffffc020a674:	6642                	ld	a2,16(sp)
ffffffffc020a676:	85d2                	mv	a1,s4
ffffffffc020a678:	854e                	mv	a0,s3
ffffffffc020a67a:	9b02                	jalr	s6
ffffffffc020a67c:	6322                	ld	t1,8(sp)
ffffffffc020a67e:	4881                	li	a7,0
ffffffffc020a680:	e505                	bnez	a0,ffffffffc020a6a8 <sfs_io_nolock+0xd6>
ffffffffc020a682:	77a2                	ld	a5,40(sp)
ffffffffc020a684:	68c2                	ld	a7,16(sp)
ffffffffc020a686:	7802                	ld	a6,32(sp)
ffffffffc020a688:	10078a63          	beqz	a5,ffffffffc020a79c <sfs_io_nolock+0x1ca>
ffffffffc020a68c:	fff78e1b          	addiw	t3,a5,-1
ffffffffc020a690:	9a46                	add	s4,s4,a7
ffffffffc020a692:	2a85                	addiw	s5,s5,1
ffffffffc020a694:	060e1763          	bnez	t3,ffffffffc020a702 <sfs_io_nolock+0x130>
ffffffffc020a698:	1852                	slli	a6,a6,0x34
ffffffffc020a69a:	03485793          	srli	a5,a6,0x34
ffffffffc020a69e:	0c081863          	bnez	a6,ffffffffc020a76e <sfs_io_nolock+0x19c>
ffffffffc020a6a2:	01140333          	add	t1,s0,a7
ffffffffc020a6a6:	4501                	li	a0,0
ffffffffc020a6a8:	00093783          	ld	a5,0(s2)
ffffffffc020a6ac:	0114b023          	sd	a7,0(s1)
ffffffffc020a6b0:	0007e703          	lwu	a4,0(a5)
ffffffffc020a6b4:	00677863          	bgeu	a4,t1,ffffffffc020a6c4 <sfs_io_nolock+0xf2>
ffffffffc020a6b8:	0114043b          	addw	s0,s0,a7
ffffffffc020a6bc:	c380                	sw	s0,0(a5)
ffffffffc020a6be:	4785                	li	a5,1
ffffffffc020a6c0:	00f93823          	sd	a5,16(s2)
ffffffffc020a6c4:	79a6                	ld	s3,104(sp)
ffffffffc020a6c6:	7a06                	ld	s4,96(sp)
ffffffffc020a6c8:	6ae6                	ld	s5,88(sp)
ffffffffc020a6ca:	6b46                	ld	s6,80(sp)
ffffffffc020a6cc:	6ba6                	ld	s7,72(sp)
ffffffffc020a6ce:	640a                	ld	s0,128(sp)
ffffffffc020a6d0:	60aa                	ld	ra,136(sp)
ffffffffc020a6d2:	74e6                	ld	s1,120(sp)
ffffffffc020a6d4:	7946                	ld	s2,112(sp)
ffffffffc020a6d6:	6149                	addi	sp,sp,144
ffffffffc020a6d8:	8082                	ret
ffffffffc020a6da:	0005e783          	lwu	a5,0(a1)
ffffffffc020a6de:	4501                	li	a0,0
ffffffffc020a6e0:	0cf45163          	bge	s0,a5,ffffffffc020a7a2 <sfs_io_nolock+0x1d0>
ffffffffc020a6e4:	ecd6                	sd	s5,88(sp)
ffffffffc020a6e6:	0707ca63          	blt	a5,a6,ffffffffc020a75a <sfs_io_nolock+0x188>
ffffffffc020a6ea:	00001b97          	auipc	s7,0x1
ffffffffc020a6ee:	d92b8b93          	addi	s7,s7,-622 # ffffffffc020b47c <sfs_rblock>
ffffffffc020a6f2:	00001b17          	auipc	s6,0x1
ffffffffc020a6f6:	e4eb0b13          	addi	s6,s6,-434 # ffffffffc020b540 <sfs_rbuf>
ffffffffc020a6fa:	bf25                	j	ffffffffc020a632 <sfs_io_nolock+0x60>
ffffffffc020a6fc:	4881                	li	a7,0
ffffffffc020a6fe:	f80e0de3          	beqz	t3,ffffffffc020a698 <sfs_io_nolock+0xc6>
ffffffffc020a702:	1874                	addi	a3,sp,60
ffffffffc020a704:	8656                	mv	a2,s5
ffffffffc020a706:	85ca                	mv	a1,s2
ffffffffc020a708:	854e                	mv	a0,s3
ffffffffc020a70a:	ec72                	sd	t3,24(sp)
ffffffffc020a70c:	e846                	sd	a7,16(sp)
ffffffffc020a70e:	e442                	sd	a6,8(sp)
ffffffffc020a710:	c57ff0ef          	jal	ffffffffc020a366 <sfs_bmap_load_nolock>
ffffffffc020a714:	6822                	ld	a6,8(sp)
ffffffffc020a716:	68c2                	ld	a7,16(sp)
ffffffffc020a718:	6e62                	ld	t3,24(sp)
ffffffffc020a71a:	e149                	bnez	a0,ffffffffc020a79c <sfs_io_nolock+0x1ca>
ffffffffc020a71c:	5672                	lw	a2,60(sp)
ffffffffc020a71e:	86f2                	mv	a3,t3
ffffffffc020a720:	85d2                	mv	a1,s4
ffffffffc020a722:	854e                	mv	a0,s3
ffffffffc020a724:	ec46                	sd	a7,24(sp)
ffffffffc020a726:	e842                	sd	a6,16(sp)
ffffffffc020a728:	e472                	sd	t3,8(sp)
ffffffffc020a72a:	9b82                	jalr	s7
ffffffffc020a72c:	6e22                	ld	t3,8(sp)
ffffffffc020a72e:	6842                	ld	a6,16(sp)
ffffffffc020a730:	68e2                	ld	a7,24(sp)
ffffffffc020a732:	e52d                	bnez	a0,ffffffffc020a79c <sfs_io_nolock+0x1ca>
ffffffffc020a734:	00ce179b          	slliw	a5,t3,0xc
ffffffffc020a738:	1782                	slli	a5,a5,0x20
ffffffffc020a73a:	9381                	srli	a5,a5,0x20
ffffffffc020a73c:	01ca8abb          	addw	s5,s5,t3
ffffffffc020a740:	98be                	add	a7,a7,a5
ffffffffc020a742:	9a3e                	add	s4,s4,a5
ffffffffc020a744:	bf91                	j	ffffffffc020a698 <sfs_io_nolock+0xc6>
ffffffffc020a746:	640a                	ld	s0,128(sp)
ffffffffc020a748:	60aa                	ld	ra,136(sp)
ffffffffc020a74a:	79a6                	ld	s3,104(sp)
ffffffffc020a74c:	74e6                	ld	s1,120(sp)
ffffffffc020a74e:	7946                	ld	s2,112(sp)
ffffffffc020a750:	6149                	addi	sp,sp,144
ffffffffc020a752:	8082                	ret
ffffffffc020a754:	40e60e33          	sub	t3,a2,a4
ffffffffc020a758:	bdf5                	j	ffffffffc020a654 <sfs_io_nolock+0x82>
ffffffffc020a75a:	883e                	mv	a6,a5
ffffffffc020a75c:	00001b97          	auipc	s7,0x1
ffffffffc020a760:	d20b8b93          	addi	s7,s7,-736 # ffffffffc020b47c <sfs_rblock>
ffffffffc020a764:	00001b17          	auipc	s6,0x1
ffffffffc020a768:	ddcb0b13          	addi	s6,s6,-548 # ffffffffc020b540 <sfs_rbuf>
ffffffffc020a76c:	b5d9                	j	ffffffffc020a632 <sfs_io_nolock+0x60>
ffffffffc020a76e:	8656                	mv	a2,s5
ffffffffc020a770:	1874                	addi	a3,sp,60
ffffffffc020a772:	85ca                	mv	a1,s2
ffffffffc020a774:	854e                	mv	a0,s3
ffffffffc020a776:	e846                	sd	a7,16(sp)
ffffffffc020a778:	e43e                	sd	a5,8(sp)
ffffffffc020a77a:	bedff0ef          	jal	ffffffffc020a366 <sfs_bmap_load_nolock>
ffffffffc020a77e:	67a2                	ld	a5,8(sp)
ffffffffc020a780:	68c2                	ld	a7,16(sp)
ffffffffc020a782:	ed09                	bnez	a0,ffffffffc020a79c <sfs_io_nolock+0x1ca>
ffffffffc020a784:	56f2                	lw	a3,60(sp)
ffffffffc020a786:	863e                	mv	a2,a5
ffffffffc020a788:	85d2                	mv	a1,s4
ffffffffc020a78a:	854e                	mv	a0,s3
ffffffffc020a78c:	4701                	li	a4,0
ffffffffc020a78e:	e846                	sd	a7,16(sp)
ffffffffc020a790:	e43e                	sd	a5,8(sp)
ffffffffc020a792:	9b02                	jalr	s6
ffffffffc020a794:	67a2                	ld	a5,8(sp)
ffffffffc020a796:	68c2                	ld	a7,16(sp)
ffffffffc020a798:	e111                	bnez	a0,ffffffffc020a79c <sfs_io_nolock+0x1ca>
ffffffffc020a79a:	98be                	add	a7,a7,a5
ffffffffc020a79c:	01140333          	add	t1,s0,a7
ffffffffc020a7a0:	b721                	j	ffffffffc020a6a8 <sfs_io_nolock+0xd6>
ffffffffc020a7a2:	640a                	ld	s0,128(sp)
ffffffffc020a7a4:	60aa                	ld	ra,136(sp)
ffffffffc020a7a6:	79a6                	ld	s3,104(sp)
ffffffffc020a7a8:	7a06                	ld	s4,96(sp)
ffffffffc020a7aa:	6b46                	ld	s6,80(sp)
ffffffffc020a7ac:	6ba6                	ld	s7,72(sp)
ffffffffc020a7ae:	74e6                	ld	s1,120(sp)
ffffffffc020a7b0:	7946                	ld	s2,112(sp)
ffffffffc020a7b2:	6149                	addi	sp,sp,144
ffffffffc020a7b4:	8082                	ret
ffffffffc020a7b6:	5575                	li	a0,-3
ffffffffc020a7b8:	bf19                	j	ffffffffc020a6ce <sfs_io_nolock+0xfc>
ffffffffc020a7ba:	00004697          	auipc	a3,0x4
ffffffffc020a7be:	77e68693          	addi	a3,a3,1918 # ffffffffc020ef38 <etext+0x3200>
ffffffffc020a7c2:	00002617          	auipc	a2,0x2
ffffffffc020a7c6:	9ae60613          	addi	a2,a2,-1618 # ffffffffc020c170 <etext+0x438>
ffffffffc020a7ca:	22b00593          	li	a1,555
ffffffffc020a7ce:	00004517          	auipc	a0,0x4
ffffffffc020a7d2:	5fa50513          	addi	a0,a0,1530 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a7d6:	f4ce                	sd	s3,104(sp)
ffffffffc020a7d8:	f0d2                	sd	s4,96(sp)
ffffffffc020a7da:	ecd6                	sd	s5,88(sp)
ffffffffc020a7dc:	e8da                	sd	s6,80(sp)
ffffffffc020a7de:	e4de                	sd	s7,72(sp)
ffffffffc020a7e0:	c6bf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a7e4 <sfs_read>:
ffffffffc020a7e4:	7139                	addi	sp,sp,-64
ffffffffc020a7e6:	f04a                	sd	s2,32(sp)
ffffffffc020a7e8:	06853903          	ld	s2,104(a0)
ffffffffc020a7ec:	fc06                	sd	ra,56(sp)
ffffffffc020a7ee:	f822                	sd	s0,48(sp)
ffffffffc020a7f0:	f426                	sd	s1,40(sp)
ffffffffc020a7f2:	ec4e                	sd	s3,24(sp)
ffffffffc020a7f4:	04090e63          	beqz	s2,ffffffffc020a850 <sfs_read+0x6c>
ffffffffc020a7f8:	0b092783          	lw	a5,176(s2)
ffffffffc020a7fc:	ebb1                	bnez	a5,ffffffffc020a850 <sfs_read+0x6c>
ffffffffc020a7fe:	4d38                	lw	a4,88(a0)
ffffffffc020a800:	6785                	lui	a5,0x1
ffffffffc020a802:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a806:	842a                	mv	s0,a0
ffffffffc020a808:	06f71463          	bne	a4,a5,ffffffffc020a870 <sfs_read+0x8c>
ffffffffc020a80c:	02050993          	addi	s3,a0,32
ffffffffc020a810:	854e                	mv	a0,s3
ffffffffc020a812:	84ae                	mv	s1,a1
ffffffffc020a814:	e05f90ef          	jal	ffffffffc0204618 <down>
ffffffffc020a818:	6c9c                	ld	a5,24(s1)
ffffffffc020a81a:	6494                	ld	a3,8(s1)
ffffffffc020a81c:	6090                	ld	a2,0(s1)
ffffffffc020a81e:	85a2                	mv	a1,s0
ffffffffc020a820:	e43e                	sd	a5,8(sp)
ffffffffc020a822:	854a                	mv	a0,s2
ffffffffc020a824:	0038                	addi	a4,sp,8
ffffffffc020a826:	4781                	li	a5,0
ffffffffc020a828:	dabff0ef          	jal	ffffffffc020a5d2 <sfs_io_nolock>
ffffffffc020a82c:	65a2                	ld	a1,8(sp)
ffffffffc020a82e:	842a                	mv	s0,a0
ffffffffc020a830:	ed81                	bnez	a1,ffffffffc020a848 <sfs_read+0x64>
ffffffffc020a832:	854e                	mv	a0,s3
ffffffffc020a834:	de1f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020a838:	70e2                	ld	ra,56(sp)
ffffffffc020a83a:	8522                	mv	a0,s0
ffffffffc020a83c:	7442                	ld	s0,48(sp)
ffffffffc020a83e:	74a2                	ld	s1,40(sp)
ffffffffc020a840:	7902                	ld	s2,32(sp)
ffffffffc020a842:	69e2                	ld	s3,24(sp)
ffffffffc020a844:	6121                	addi	sp,sp,64
ffffffffc020a846:	8082                	ret
ffffffffc020a848:	8526                	mv	a0,s1
ffffffffc020a84a:	cf3fa0ef          	jal	ffffffffc020553c <iobuf_skip>
ffffffffc020a84e:	b7d5                	j	ffffffffc020a832 <sfs_read+0x4e>
ffffffffc020a850:	00004697          	auipc	a3,0x4
ffffffffc020a854:	39868693          	addi	a3,a3,920 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020a858:	00002617          	auipc	a2,0x2
ffffffffc020a85c:	91860613          	addi	a2,a2,-1768 # ffffffffc020c170 <etext+0x438>
ffffffffc020a860:	29900593          	li	a1,665
ffffffffc020a864:	00004517          	auipc	a0,0x4
ffffffffc020a868:	56450513          	addi	a0,a0,1380 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a86c:	bdff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a870:	817ff0ef          	jal	ffffffffc020a086 <sfs_io.part.0>

ffffffffc020a874 <sfs_write>:
ffffffffc020a874:	7139                	addi	sp,sp,-64
ffffffffc020a876:	f04a                	sd	s2,32(sp)
ffffffffc020a878:	06853903          	ld	s2,104(a0)
ffffffffc020a87c:	fc06                	sd	ra,56(sp)
ffffffffc020a87e:	f822                	sd	s0,48(sp)
ffffffffc020a880:	f426                	sd	s1,40(sp)
ffffffffc020a882:	ec4e                	sd	s3,24(sp)
ffffffffc020a884:	04090e63          	beqz	s2,ffffffffc020a8e0 <sfs_write+0x6c>
ffffffffc020a888:	0b092783          	lw	a5,176(s2)
ffffffffc020a88c:	ebb1                	bnez	a5,ffffffffc020a8e0 <sfs_write+0x6c>
ffffffffc020a88e:	4d38                	lw	a4,88(a0)
ffffffffc020a890:	6785                	lui	a5,0x1
ffffffffc020a892:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a896:	842a                	mv	s0,a0
ffffffffc020a898:	06f71463          	bne	a4,a5,ffffffffc020a900 <sfs_write+0x8c>
ffffffffc020a89c:	02050993          	addi	s3,a0,32
ffffffffc020a8a0:	854e                	mv	a0,s3
ffffffffc020a8a2:	84ae                	mv	s1,a1
ffffffffc020a8a4:	d75f90ef          	jal	ffffffffc0204618 <down>
ffffffffc020a8a8:	6c9c                	ld	a5,24(s1)
ffffffffc020a8aa:	6494                	ld	a3,8(s1)
ffffffffc020a8ac:	6090                	ld	a2,0(s1)
ffffffffc020a8ae:	85a2                	mv	a1,s0
ffffffffc020a8b0:	e43e                	sd	a5,8(sp)
ffffffffc020a8b2:	854a                	mv	a0,s2
ffffffffc020a8b4:	0038                	addi	a4,sp,8
ffffffffc020a8b6:	4785                	li	a5,1
ffffffffc020a8b8:	d1bff0ef          	jal	ffffffffc020a5d2 <sfs_io_nolock>
ffffffffc020a8bc:	65a2                	ld	a1,8(sp)
ffffffffc020a8be:	842a                	mv	s0,a0
ffffffffc020a8c0:	ed81                	bnez	a1,ffffffffc020a8d8 <sfs_write+0x64>
ffffffffc020a8c2:	854e                	mv	a0,s3
ffffffffc020a8c4:	d51f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020a8c8:	70e2                	ld	ra,56(sp)
ffffffffc020a8ca:	8522                	mv	a0,s0
ffffffffc020a8cc:	7442                	ld	s0,48(sp)
ffffffffc020a8ce:	74a2                	ld	s1,40(sp)
ffffffffc020a8d0:	7902                	ld	s2,32(sp)
ffffffffc020a8d2:	69e2                	ld	s3,24(sp)
ffffffffc020a8d4:	6121                	addi	sp,sp,64
ffffffffc020a8d6:	8082                	ret
ffffffffc020a8d8:	8526                	mv	a0,s1
ffffffffc020a8da:	c63fa0ef          	jal	ffffffffc020553c <iobuf_skip>
ffffffffc020a8de:	b7d5                	j	ffffffffc020a8c2 <sfs_write+0x4e>
ffffffffc020a8e0:	00004697          	auipc	a3,0x4
ffffffffc020a8e4:	30868693          	addi	a3,a3,776 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020a8e8:	00002617          	auipc	a2,0x2
ffffffffc020a8ec:	88860613          	addi	a2,a2,-1912 # ffffffffc020c170 <etext+0x438>
ffffffffc020a8f0:	29900593          	li	a1,665
ffffffffc020a8f4:	00004517          	auipc	a0,0x4
ffffffffc020a8f8:	4d450513          	addi	a0,a0,1236 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a8fc:	b4ff50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a900:	f86ff0ef          	jal	ffffffffc020a086 <sfs_io.part.0>

ffffffffc020a904 <sfs_dirent_read_nolock>:
ffffffffc020a904:	619c                	ld	a5,0(a1)
ffffffffc020a906:	7139                	addi	sp,sp,-64
ffffffffc020a908:	f426                	sd	s1,40(sp)
ffffffffc020a90a:	84b6                	mv	s1,a3
ffffffffc020a90c:	0047d683          	lhu	a3,4(a5)
ffffffffc020a910:	fc06                	sd	ra,56(sp)
ffffffffc020a912:	f822                	sd	s0,48(sp)
ffffffffc020a914:	4709                	li	a4,2
ffffffffc020a916:	04e69963          	bne	a3,a4,ffffffffc020a968 <sfs_dirent_read_nolock+0x64>
ffffffffc020a91a:	479c                	lw	a5,8(a5)
ffffffffc020a91c:	04f67663          	bgeu	a2,a5,ffffffffc020a968 <sfs_dirent_read_nolock+0x64>
ffffffffc020a920:	0874                	addi	a3,sp,28
ffffffffc020a922:	842a                	mv	s0,a0
ffffffffc020a924:	a43ff0ef          	jal	ffffffffc020a366 <sfs_bmap_load_nolock>
ffffffffc020a928:	c511                	beqz	a0,ffffffffc020a934 <sfs_dirent_read_nolock+0x30>
ffffffffc020a92a:	70e2                	ld	ra,56(sp)
ffffffffc020a92c:	7442                	ld	s0,48(sp)
ffffffffc020a92e:	74a2                	ld	s1,40(sp)
ffffffffc020a930:	6121                	addi	sp,sp,64
ffffffffc020a932:	8082                	ret
ffffffffc020a934:	45f2                	lw	a1,28(sp)
ffffffffc020a936:	c9a9                	beqz	a1,ffffffffc020a988 <sfs_dirent_read_nolock+0x84>
ffffffffc020a938:	405c                	lw	a5,4(s0)
ffffffffc020a93a:	04f5f763          	bgeu	a1,a5,ffffffffc020a988 <sfs_dirent_read_nolock+0x84>
ffffffffc020a93e:	7c08                	ld	a0,56(s0)
ffffffffc020a940:	e42e                	sd	a1,8(sp)
ffffffffc020a942:	e39fe0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020a946:	ed39                	bnez	a0,ffffffffc020a9a4 <sfs_dirent_read_nolock+0xa0>
ffffffffc020a948:	66a2                	ld	a3,8(sp)
ffffffffc020a94a:	8522                	mv	a0,s0
ffffffffc020a94c:	4701                	li	a4,0
ffffffffc020a94e:	10400613          	li	a2,260
ffffffffc020a952:	85a6                	mv	a1,s1
ffffffffc020a954:	3ed000ef          	jal	ffffffffc020b540 <sfs_rbuf>
ffffffffc020a958:	f969                	bnez	a0,ffffffffc020a92a <sfs_dirent_read_nolock+0x26>
ffffffffc020a95a:	100481a3          	sb	zero,259(s1)
ffffffffc020a95e:	70e2                	ld	ra,56(sp)
ffffffffc020a960:	7442                	ld	s0,48(sp)
ffffffffc020a962:	74a2                	ld	s1,40(sp)
ffffffffc020a964:	6121                	addi	sp,sp,64
ffffffffc020a966:	8082                	ret
ffffffffc020a968:	00004697          	auipc	a3,0x4
ffffffffc020a96c:	5f068693          	addi	a3,a3,1520 # ffffffffc020ef58 <etext+0x3220>
ffffffffc020a970:	00002617          	auipc	a2,0x2
ffffffffc020a974:	80060613          	addi	a2,a2,-2048 # ffffffffc020c170 <etext+0x438>
ffffffffc020a978:	18e00593          	li	a1,398
ffffffffc020a97c:	00004517          	auipc	a0,0x4
ffffffffc020a980:	44c50513          	addi	a0,a0,1100 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a984:	ac7f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a988:	4054                	lw	a3,4(s0)
ffffffffc020a98a:	872e                	mv	a4,a1
ffffffffc020a98c:	00004617          	auipc	a2,0x4
ffffffffc020a990:	46c60613          	addi	a2,a2,1132 # ffffffffc020edf8 <etext+0x30c0>
ffffffffc020a994:	05300593          	li	a1,83
ffffffffc020a998:	00004517          	auipc	a0,0x4
ffffffffc020a99c:	43050513          	addi	a0,a0,1072 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a9a0:	aabf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020a9a4:	00004697          	auipc	a3,0x4
ffffffffc020a9a8:	48c68693          	addi	a3,a3,1164 # ffffffffc020ee30 <etext+0x30f8>
ffffffffc020a9ac:	00001617          	auipc	a2,0x1
ffffffffc020a9b0:	7c460613          	addi	a2,a2,1988 # ffffffffc020c170 <etext+0x438>
ffffffffc020a9b4:	19500593          	li	a1,405
ffffffffc020a9b8:	00004517          	auipc	a0,0x4
ffffffffc020a9bc:	41050513          	addi	a0,a0,1040 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020a9c0:	a8bf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020a9c4 <sfs_getdirentry>:
ffffffffc020a9c4:	715d                	addi	sp,sp,-80
ffffffffc020a9c6:	f052                	sd	s4,32(sp)
ffffffffc020a9c8:	8a2a                	mv	s4,a0
ffffffffc020a9ca:	10400513          	li	a0,260
ffffffffc020a9ce:	e85a                	sd	s6,16(sp)
ffffffffc020a9d0:	e486                	sd	ra,72(sp)
ffffffffc020a9d2:	e0a2                	sd	s0,64(sp)
ffffffffc020a9d4:	8b2e                	mv	s6,a1
ffffffffc020a9d6:	fb2f70ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020a9da:	0e050963          	beqz	a0,ffffffffc020aacc <sfs_getdirentry+0x108>
ffffffffc020a9de:	ec56                	sd	s5,24(sp)
ffffffffc020a9e0:	068a3a83          	ld	s5,104(s4)
ffffffffc020a9e4:	0e0a8663          	beqz	s5,ffffffffc020aad0 <sfs_getdirentry+0x10c>
ffffffffc020a9e8:	0b0aa783          	lw	a5,176(s5)
ffffffffc020a9ec:	0e079263          	bnez	a5,ffffffffc020aad0 <sfs_getdirentry+0x10c>
ffffffffc020a9f0:	058a2703          	lw	a4,88(s4)
ffffffffc020a9f4:	6785                	lui	a5,0x1
ffffffffc020a9f6:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a9fa:	10f71063          	bne	a4,a5,ffffffffc020aafa <sfs_getdirentry+0x136>
ffffffffc020a9fe:	f44e                	sd	s3,40(sp)
ffffffffc020aa00:	57fd                	li	a5,-1
ffffffffc020aa02:	008b3983          	ld	s3,8(s6)
ffffffffc020aa06:	17fe                	slli	a5,a5,0x3f
ffffffffc020aa08:	0ff78793          	addi	a5,a5,255
ffffffffc020aa0c:	00f9f7b3          	and	a5,s3,a5
ffffffffc020aa10:	e3d5                	bnez	a5,ffffffffc020aab4 <sfs_getdirentry+0xf0>
ffffffffc020aa12:	000a3783          	ld	a5,0(s4)
ffffffffc020aa16:	0089d993          	srli	s3,s3,0x8
ffffffffc020aa1a:	2981                	sext.w	s3,s3
ffffffffc020aa1c:	479c                	lw	a5,8(a5)
ffffffffc020aa1e:	0b37e163          	bltu	a5,s3,ffffffffc020aac0 <sfs_getdirentry+0xfc>
ffffffffc020aa22:	f84a                	sd	s2,48(sp)
ffffffffc020aa24:	892a                	mv	s2,a0
ffffffffc020aa26:	020a0513          	addi	a0,s4,32
ffffffffc020aa2a:	e45e                	sd	s7,8(sp)
ffffffffc020aa2c:	bedf90ef          	jal	ffffffffc0204618 <down>
ffffffffc020aa30:	000a3783          	ld	a5,0(s4)
ffffffffc020aa34:	0087ab83          	lw	s7,8(a5)
ffffffffc020aa38:	07705c63          	blez	s7,ffffffffc020aab0 <sfs_getdirentry+0xec>
ffffffffc020aa3c:	fc26                	sd	s1,56(sp)
ffffffffc020aa3e:	4481                	li	s1,0
ffffffffc020aa40:	a811                	j	ffffffffc020aa54 <sfs_getdirentry+0x90>
ffffffffc020aa42:	00092783          	lw	a5,0(s2)
ffffffffc020aa46:	c781                	beqz	a5,ffffffffc020aa4e <sfs_getdirentry+0x8a>
ffffffffc020aa48:	02098463          	beqz	s3,ffffffffc020aa70 <sfs_getdirentry+0xac>
ffffffffc020aa4c:	39fd                	addiw	s3,s3,-1
ffffffffc020aa4e:	2485                	addiw	s1,s1,1
ffffffffc020aa50:	049b8d63          	beq	s7,s1,ffffffffc020aaaa <sfs_getdirentry+0xe6>
ffffffffc020aa54:	86ca                	mv	a3,s2
ffffffffc020aa56:	8626                	mv	a2,s1
ffffffffc020aa58:	85d2                	mv	a1,s4
ffffffffc020aa5a:	8556                	mv	a0,s5
ffffffffc020aa5c:	ea9ff0ef          	jal	ffffffffc020a904 <sfs_dirent_read_nolock>
ffffffffc020aa60:	842a                	mv	s0,a0
ffffffffc020aa62:	d165                	beqz	a0,ffffffffc020aa42 <sfs_getdirentry+0x7e>
ffffffffc020aa64:	74e2                	ld	s1,56(sp)
ffffffffc020aa66:	020a0513          	addi	a0,s4,32
ffffffffc020aa6a:	babf90ef          	jal	ffffffffc0204614 <up>
ffffffffc020aa6e:	a005                	j	ffffffffc020aa8e <sfs_getdirentry+0xca>
ffffffffc020aa70:	020a0513          	addi	a0,s4,32
ffffffffc020aa74:	ba1f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020aa78:	855a                	mv	a0,s6
ffffffffc020aa7a:	00490593          	addi	a1,s2,4
ffffffffc020aa7e:	4701                	li	a4,0
ffffffffc020aa80:	4685                	li	a3,1
ffffffffc020aa82:	10000613          	li	a2,256
ffffffffc020aa86:	a33fa0ef          	jal	ffffffffc02054b8 <iobuf_move>
ffffffffc020aa8a:	74e2                	ld	s1,56(sp)
ffffffffc020aa8c:	842a                	mv	s0,a0
ffffffffc020aa8e:	854a                	mv	a0,s2
ffffffffc020aa90:	f9ef70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020aa94:	7942                	ld	s2,48(sp)
ffffffffc020aa96:	79a2                	ld	s3,40(sp)
ffffffffc020aa98:	6ae2                	ld	s5,24(sp)
ffffffffc020aa9a:	6ba2                	ld	s7,8(sp)
ffffffffc020aa9c:	60a6                	ld	ra,72(sp)
ffffffffc020aa9e:	8522                	mv	a0,s0
ffffffffc020aaa0:	6406                	ld	s0,64(sp)
ffffffffc020aaa2:	7a02                	ld	s4,32(sp)
ffffffffc020aaa4:	6b42                	ld	s6,16(sp)
ffffffffc020aaa6:	6161                	addi	sp,sp,80
ffffffffc020aaa8:	8082                	ret
ffffffffc020aaaa:	74e2                	ld	s1,56(sp)
ffffffffc020aaac:	5441                	li	s0,-16
ffffffffc020aaae:	bf65                	j	ffffffffc020aa66 <sfs_getdirentry+0xa2>
ffffffffc020aab0:	5441                	li	s0,-16
ffffffffc020aab2:	bf55                	j	ffffffffc020aa66 <sfs_getdirentry+0xa2>
ffffffffc020aab4:	f7af70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020aab8:	5475                	li	s0,-3
ffffffffc020aaba:	79a2                	ld	s3,40(sp)
ffffffffc020aabc:	6ae2                	ld	s5,24(sp)
ffffffffc020aabe:	bff9                	j	ffffffffc020aa9c <sfs_getdirentry+0xd8>
ffffffffc020aac0:	f6ef70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020aac4:	5441                	li	s0,-16
ffffffffc020aac6:	79a2                	ld	s3,40(sp)
ffffffffc020aac8:	6ae2                	ld	s5,24(sp)
ffffffffc020aaca:	bfc9                	j	ffffffffc020aa9c <sfs_getdirentry+0xd8>
ffffffffc020aacc:	5471                	li	s0,-4
ffffffffc020aace:	b7f9                	j	ffffffffc020aa9c <sfs_getdirentry+0xd8>
ffffffffc020aad0:	00004697          	auipc	a3,0x4
ffffffffc020aad4:	11868693          	addi	a3,a3,280 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020aad8:	00001617          	auipc	a2,0x1
ffffffffc020aadc:	69860613          	addi	a2,a2,1688 # ffffffffc020c170 <etext+0x438>
ffffffffc020aae0:	33d00593          	li	a1,829
ffffffffc020aae4:	00004517          	auipc	a0,0x4
ffffffffc020aae8:	2e450513          	addi	a0,a0,740 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020aaec:	fc26                	sd	s1,56(sp)
ffffffffc020aaee:	f84a                	sd	s2,48(sp)
ffffffffc020aaf0:	f44e                	sd	s3,40(sp)
ffffffffc020aaf2:	e45e                	sd	s7,8(sp)
ffffffffc020aaf4:	e062                	sd	s8,0(sp)
ffffffffc020aaf6:	955f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020aafa:	00004697          	auipc	a3,0x4
ffffffffc020aafe:	29668693          	addi	a3,a3,662 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020ab02:	00001617          	auipc	a2,0x1
ffffffffc020ab06:	66e60613          	addi	a2,a2,1646 # ffffffffc020c170 <etext+0x438>
ffffffffc020ab0a:	33e00593          	li	a1,830
ffffffffc020ab0e:	00004517          	auipc	a0,0x4
ffffffffc020ab12:	2ba50513          	addi	a0,a0,698 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020ab16:	fc26                	sd	s1,56(sp)
ffffffffc020ab18:	f84a                	sd	s2,48(sp)
ffffffffc020ab1a:	f44e                	sd	s3,40(sp)
ffffffffc020ab1c:	e45e                	sd	s7,8(sp)
ffffffffc020ab1e:	e062                	sd	s8,0(sp)
ffffffffc020ab20:	92bf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020ab24 <sfs_truncfile>:
ffffffffc020ab24:	080007b7          	lui	a5,0x8000
ffffffffc020ab28:	1ab7eb63          	bltu	a5,a1,ffffffffc020acde <sfs_truncfile+0x1ba>
ffffffffc020ab2c:	7159                	addi	sp,sp,-112
ffffffffc020ab2e:	e0d2                	sd	s4,64(sp)
ffffffffc020ab30:	06853a03          	ld	s4,104(a0)
ffffffffc020ab34:	e8ca                	sd	s2,80(sp)
ffffffffc020ab36:	e4ce                	sd	s3,72(sp)
ffffffffc020ab38:	f486                	sd	ra,104(sp)
ffffffffc020ab3a:	f0a2                	sd	s0,96(sp)
ffffffffc020ab3c:	fc56                	sd	s5,56(sp)
ffffffffc020ab3e:	892a                	mv	s2,a0
ffffffffc020ab40:	89ae                	mv	s3,a1
ffffffffc020ab42:	1a0a0163          	beqz	s4,ffffffffc020ace4 <sfs_truncfile+0x1c0>
ffffffffc020ab46:	0b0a2783          	lw	a5,176(s4)
ffffffffc020ab4a:	18079d63          	bnez	a5,ffffffffc020ace4 <sfs_truncfile+0x1c0>
ffffffffc020ab4e:	4d38                	lw	a4,88(a0)
ffffffffc020ab50:	6785                	lui	a5,0x1
ffffffffc020ab52:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ab56:	6405                	lui	s0,0x1
ffffffffc020ab58:	1cf71963          	bne	a4,a5,ffffffffc020ad2a <sfs_truncfile+0x206>
ffffffffc020ab5c:	00053a83          	ld	s5,0(a0)
ffffffffc020ab60:	147d                	addi	s0,s0,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020ab62:	942e                	add	s0,s0,a1
ffffffffc020ab64:	000ae783          	lwu	a5,0(s5)
ffffffffc020ab68:	8031                	srli	s0,s0,0xc
ffffffffc020ab6a:	2401                	sext.w	s0,s0
ffffffffc020ab6c:	02b79063          	bne	a5,a1,ffffffffc020ab8c <sfs_truncfile+0x68>
ffffffffc020ab70:	008aa703          	lw	a4,8(s5)
ffffffffc020ab74:	4781                	li	a5,0
ffffffffc020ab76:	1c871c63          	bne	a4,s0,ffffffffc020ad4e <sfs_truncfile+0x22a>
ffffffffc020ab7a:	70a6                	ld	ra,104(sp)
ffffffffc020ab7c:	7406                	ld	s0,96(sp)
ffffffffc020ab7e:	6946                	ld	s2,80(sp)
ffffffffc020ab80:	69a6                	ld	s3,72(sp)
ffffffffc020ab82:	6a06                	ld	s4,64(sp)
ffffffffc020ab84:	7ae2                	ld	s5,56(sp)
ffffffffc020ab86:	853e                	mv	a0,a5
ffffffffc020ab88:	6165                	addi	sp,sp,112
ffffffffc020ab8a:	8082                	ret
ffffffffc020ab8c:	02050513          	addi	a0,a0,32
ffffffffc020ab90:	eca6                	sd	s1,88(sp)
ffffffffc020ab92:	a87f90ef          	jal	ffffffffc0204618 <down>
ffffffffc020ab96:	008aa483          	lw	s1,8(s5)
ffffffffc020ab9a:	0c84e363          	bltu	s1,s0,ffffffffc020ac60 <sfs_truncfile+0x13c>
ffffffffc020ab9e:	0c947e63          	bgeu	s0,s1,ffffffffc020ac7a <sfs_truncfile+0x156>
ffffffffc020aba2:	48ad                	li	a7,11
ffffffffc020aba4:	4305                	li	t1,1
ffffffffc020aba6:	a895                	j	ffffffffc020ac1a <sfs_truncfile+0xf6>
ffffffffc020aba8:	37cd                	addiw	a5,a5,-13
ffffffffc020abaa:	3ff00693          	li	a3,1023
ffffffffc020abae:	04f6ef63          	bltu	a3,a5,ffffffffc020ac0c <sfs_truncfile+0xe8>
ffffffffc020abb2:	03c82683          	lw	a3,60(a6)
ffffffffc020abb6:	cab9                	beqz	a3,ffffffffc020ac0c <sfs_truncfile+0xe8>
ffffffffc020abb8:	004a2603          	lw	a2,4(s4)
ffffffffc020abbc:	1ac6fb63          	bgeu	a3,a2,ffffffffc020ad72 <sfs_truncfile+0x24e>
ffffffffc020abc0:	038a3503          	ld	a0,56(s4)
ffffffffc020abc4:	85b6                	mv	a1,a3
ffffffffc020abc6:	e436                	sd	a3,8(sp)
ffffffffc020abc8:	e842                	sd	a6,16(sp)
ffffffffc020abca:	ec3e                	sd	a5,24(sp)
ffffffffc020abcc:	baffe0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020abd0:	66a2                	ld	a3,8(sp)
ffffffffc020abd2:	6842                	ld	a6,16(sp)
ffffffffc020abd4:	67e2                	ld	a5,24(sp)
ffffffffc020abd6:	1a051d63          	bnez	a0,ffffffffc020ad90 <sfs_truncfile+0x26c>
ffffffffc020abda:	02079613          	slli	a2,a5,0x20
ffffffffc020abde:	01e65713          	srli	a4,a2,0x1e
ffffffffc020abe2:	102c                	addi	a1,sp,40
ffffffffc020abe4:	4611                	li	a2,4
ffffffffc020abe6:	8552                	mv	a0,s4
ffffffffc020abe8:	ec42                	sd	a6,24(sp)
ffffffffc020abea:	e83a                	sd	a4,16(sp)
ffffffffc020abec:	e436                	sd	a3,8(sp)
ffffffffc020abee:	d602                	sw	zero,44(sp)
ffffffffc020abf0:	151000ef          	jal	ffffffffc020b540 <sfs_rbuf>
ffffffffc020abf4:	87aa                	mv	a5,a0
ffffffffc020abf6:	e941                	bnez	a0,ffffffffc020ac86 <sfs_truncfile+0x162>
ffffffffc020abf8:	57a2                	lw	a5,40(sp)
ffffffffc020abfa:	66a2                	ld	a3,8(sp)
ffffffffc020abfc:	6742                	ld	a4,16(sp)
ffffffffc020abfe:	6862                	ld	a6,24(sp)
ffffffffc020ac00:	48ad                	li	a7,11
ffffffffc020ac02:	4305                	li	t1,1
ffffffffc020ac04:	ebd5                	bnez	a5,ffffffffc020acb8 <sfs_truncfile+0x194>
ffffffffc020ac06:	00882703          	lw	a4,8(a6)
ffffffffc020ac0a:	377d                	addiw	a4,a4,-1 # 7ffffff <_binary_bin_sfs_img_size+0x7f8acff>
ffffffffc020ac0c:	00e82423          	sw	a4,8(a6)
ffffffffc020ac10:	00693823          	sd	t1,16(s2)
ffffffffc020ac14:	34fd                	addiw	s1,s1,-1
ffffffffc020ac16:	04940e63          	beq	s0,s1,ffffffffc020ac72 <sfs_truncfile+0x14e>
ffffffffc020ac1a:	00093803          	ld	a6,0(s2)
ffffffffc020ac1e:	00882783          	lw	a5,8(a6)
ffffffffc020ac22:	0e078363          	beqz	a5,ffffffffc020ad08 <sfs_truncfile+0x1e4>
ffffffffc020ac26:	fff7871b          	addiw	a4,a5,-1
ffffffffc020ac2a:	f6e8efe3          	bltu	a7,a4,ffffffffc020aba8 <sfs_truncfile+0x84>
ffffffffc020ac2e:	02071693          	slli	a3,a4,0x20
ffffffffc020ac32:	01e6d793          	srli	a5,a3,0x1e
ffffffffc020ac36:	97c2                	add	a5,a5,a6
ffffffffc020ac38:	47cc                	lw	a1,12(a5)
ffffffffc020ac3a:	d9e9                	beqz	a1,ffffffffc020ac0c <sfs_truncfile+0xe8>
ffffffffc020ac3c:	8552                	mv	a0,s4
ffffffffc020ac3e:	e83e                	sd	a5,16(sp)
ffffffffc020ac40:	e442                	sd	a6,8(sp)
ffffffffc020ac42:	c68ff0ef          	jal	ffffffffc020a0aa <sfs_block_free>
ffffffffc020ac46:	67c2                	ld	a5,16(sp)
ffffffffc020ac48:	6822                	ld	a6,8(sp)
ffffffffc020ac4a:	48ad                	li	a7,11
ffffffffc020ac4c:	0007a623          	sw	zero,12(a5)
ffffffffc020ac50:	00882703          	lw	a4,8(a6)
ffffffffc020ac54:	4305                	li	t1,1
ffffffffc020ac56:	377d                	addiw	a4,a4,-1
ffffffffc020ac58:	bf55                	j	ffffffffc020ac0c <sfs_truncfile+0xe8>
ffffffffc020ac5a:	2485                	addiw	s1,s1,1
ffffffffc020ac5c:	00940b63          	beq	s0,s1,ffffffffc020ac72 <sfs_truncfile+0x14e>
ffffffffc020ac60:	4681                	li	a3,0
ffffffffc020ac62:	8626                	mv	a2,s1
ffffffffc020ac64:	85ca                	mv	a1,s2
ffffffffc020ac66:	8552                	mv	a0,s4
ffffffffc020ac68:	efeff0ef          	jal	ffffffffc020a366 <sfs_bmap_load_nolock>
ffffffffc020ac6c:	87aa                	mv	a5,a0
ffffffffc020ac6e:	d575                	beqz	a0,ffffffffc020ac5a <sfs_truncfile+0x136>
ffffffffc020ac70:	a819                	j	ffffffffc020ac86 <sfs_truncfile+0x162>
ffffffffc020ac72:	008aa783          	lw	a5,8(s5)
ffffffffc020ac76:	02879063          	bne	a5,s0,ffffffffc020ac96 <sfs_truncfile+0x172>
ffffffffc020ac7a:	4785                	li	a5,1
ffffffffc020ac7c:	013aa023          	sw	s3,0(s5)
ffffffffc020ac80:	00f93823          	sd	a5,16(s2)
ffffffffc020ac84:	4781                	li	a5,0
ffffffffc020ac86:	02090513          	addi	a0,s2,32
ffffffffc020ac8a:	e43e                	sd	a5,8(sp)
ffffffffc020ac8c:	989f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020ac90:	67a2                	ld	a5,8(sp)
ffffffffc020ac92:	64e6                	ld	s1,88(sp)
ffffffffc020ac94:	b5dd                	j	ffffffffc020ab7a <sfs_truncfile+0x56>
ffffffffc020ac96:	00004697          	auipc	a3,0x4
ffffffffc020ac9a:	37a68693          	addi	a3,a3,890 # ffffffffc020f010 <etext+0x32d8>
ffffffffc020ac9e:	00001617          	auipc	a2,0x1
ffffffffc020aca2:	4d260613          	addi	a2,a2,1234 # ffffffffc020c170 <etext+0x438>
ffffffffc020aca6:	3cd00593          	li	a1,973
ffffffffc020acaa:	00004517          	auipc	a0,0x4
ffffffffc020acae:	11e50513          	addi	a0,a0,286 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020acb2:	f85a                	sd	s6,48(sp)
ffffffffc020acb4:	f96f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020acb8:	4611                	li	a2,4
ffffffffc020acba:	106c                	addi	a1,sp,44
ffffffffc020acbc:	8552                	mv	a0,s4
ffffffffc020acbe:	e442                	sd	a6,8(sp)
ffffffffc020acc0:	101000ef          	jal	ffffffffc020b5c0 <sfs_wbuf>
ffffffffc020acc4:	87aa                	mv	a5,a0
ffffffffc020acc6:	f161                	bnez	a0,ffffffffc020ac86 <sfs_truncfile+0x162>
ffffffffc020acc8:	55a2                	lw	a1,40(sp)
ffffffffc020acca:	8552                	mv	a0,s4
ffffffffc020accc:	bdeff0ef          	jal	ffffffffc020a0aa <sfs_block_free>
ffffffffc020acd0:	6822                	ld	a6,8(sp)
ffffffffc020acd2:	4305                	li	t1,1
ffffffffc020acd4:	48ad                	li	a7,11
ffffffffc020acd6:	00882703          	lw	a4,8(a6)
ffffffffc020acda:	377d                	addiw	a4,a4,-1
ffffffffc020acdc:	bf05                	j	ffffffffc020ac0c <sfs_truncfile+0xe8>
ffffffffc020acde:	57f5                	li	a5,-3
ffffffffc020ace0:	853e                	mv	a0,a5
ffffffffc020ace2:	8082                	ret
ffffffffc020ace4:	00004697          	auipc	a3,0x4
ffffffffc020ace8:	f0468693          	addi	a3,a3,-252 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020acec:	00001617          	auipc	a2,0x1
ffffffffc020acf0:	48460613          	addi	a2,a2,1156 # ffffffffc020c170 <etext+0x438>
ffffffffc020acf4:	3ac00593          	li	a1,940
ffffffffc020acf8:	00004517          	auipc	a0,0x4
ffffffffc020acfc:	0d050513          	addi	a0,a0,208 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020ad00:	eca6                	sd	s1,88(sp)
ffffffffc020ad02:	f85a                	sd	s6,48(sp)
ffffffffc020ad04:	f46f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad08:	00004697          	auipc	a3,0x4
ffffffffc020ad0c:	2b868693          	addi	a3,a3,696 # ffffffffc020efc0 <etext+0x3288>
ffffffffc020ad10:	00001617          	auipc	a2,0x1
ffffffffc020ad14:	46060613          	addi	a2,a2,1120 # ffffffffc020c170 <etext+0x438>
ffffffffc020ad18:	17b00593          	li	a1,379
ffffffffc020ad1c:	00004517          	auipc	a0,0x4
ffffffffc020ad20:	0ac50513          	addi	a0,a0,172 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020ad24:	f85a                	sd	s6,48(sp)
ffffffffc020ad26:	f24f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad2a:	00004697          	auipc	a3,0x4
ffffffffc020ad2e:	06668693          	addi	a3,a3,102 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020ad32:	00001617          	auipc	a2,0x1
ffffffffc020ad36:	43e60613          	addi	a2,a2,1086 # ffffffffc020c170 <etext+0x438>
ffffffffc020ad3a:	3ad00593          	li	a1,941
ffffffffc020ad3e:	00004517          	auipc	a0,0x4
ffffffffc020ad42:	08a50513          	addi	a0,a0,138 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020ad46:	eca6                	sd	s1,88(sp)
ffffffffc020ad48:	f85a                	sd	s6,48(sp)
ffffffffc020ad4a:	f00f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad4e:	00004697          	auipc	a3,0x4
ffffffffc020ad52:	25a68693          	addi	a3,a3,602 # ffffffffc020efa8 <etext+0x3270>
ffffffffc020ad56:	00001617          	auipc	a2,0x1
ffffffffc020ad5a:	41a60613          	addi	a2,a2,1050 # ffffffffc020c170 <etext+0x438>
ffffffffc020ad5e:	3b400593          	li	a1,948
ffffffffc020ad62:	00004517          	auipc	a0,0x4
ffffffffc020ad66:	06650513          	addi	a0,a0,102 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020ad6a:	eca6                	sd	s1,88(sp)
ffffffffc020ad6c:	f85a                	sd	s6,48(sp)
ffffffffc020ad6e:	edcf50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad72:	8736                	mv	a4,a3
ffffffffc020ad74:	05300593          	li	a1,83
ffffffffc020ad78:	86b2                	mv	a3,a2
ffffffffc020ad7a:	00004517          	auipc	a0,0x4
ffffffffc020ad7e:	04e50513          	addi	a0,a0,78 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020ad82:	00004617          	auipc	a2,0x4
ffffffffc020ad86:	07660613          	addi	a2,a2,118 # ffffffffc020edf8 <etext+0x30c0>
ffffffffc020ad8a:	f85a                	sd	s6,48(sp)
ffffffffc020ad8c:	ebef50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020ad90:	00004697          	auipc	a3,0x4
ffffffffc020ad94:	24868693          	addi	a3,a3,584 # ffffffffc020efd8 <etext+0x32a0>
ffffffffc020ad98:	00001617          	auipc	a2,0x1
ffffffffc020ad9c:	3d860613          	addi	a2,a2,984 # ffffffffc020c170 <etext+0x438>
ffffffffc020ada0:	12b00593          	li	a1,299
ffffffffc020ada4:	00004517          	auipc	a0,0x4
ffffffffc020ada8:	02450513          	addi	a0,a0,36 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020adac:	f85a                	sd	s6,48(sp)
ffffffffc020adae:	e9cf50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020adb2 <sfs_load_inode>:
ffffffffc020adb2:	7139                	addi	sp,sp,-64
ffffffffc020adb4:	fc06                	sd	ra,56(sp)
ffffffffc020adb6:	f822                	sd	s0,48(sp)
ffffffffc020adb8:	f426                	sd	s1,40(sp)
ffffffffc020adba:	f04a                	sd	s2,32(sp)
ffffffffc020adbc:	84b2                	mv	s1,a2
ffffffffc020adbe:	892a                	mv	s2,a0
ffffffffc020adc0:	ec4e                	sd	s3,24(sp)
ffffffffc020adc2:	89ae                	mv	s3,a1
ffffffffc020adc4:	1b1000ef          	jal	ffffffffc020b774 <lock_sfs_fs>
ffffffffc020adc8:	8526                	mv	a0,s1
ffffffffc020adca:	45a9                	li	a1,10
ffffffffc020adcc:	0a893403          	ld	s0,168(s2)
ffffffffc020add0:	1c5000ef          	jal	ffffffffc020b794 <hash32>
ffffffffc020add4:	02051793          	slli	a5,a0,0x20
ffffffffc020add8:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020addc:	00a406b3          	add	a3,s0,a0
ffffffffc020ade0:	87b6                	mv	a5,a3
ffffffffc020ade2:	a029                	j	ffffffffc020adec <sfs_load_inode+0x3a>
ffffffffc020ade4:	fc07a703          	lw	a4,-64(a5)
ffffffffc020ade8:	10970563          	beq	a4,s1,ffffffffc020aef2 <sfs_load_inode+0x140>
ffffffffc020adec:	679c                	ld	a5,8(a5)
ffffffffc020adee:	fef69be3          	bne	a3,a5,ffffffffc020ade4 <sfs_load_inode+0x32>
ffffffffc020adf2:	04000513          	li	a0,64
ffffffffc020adf6:	b92f70ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020adfa:	87aa                	mv	a5,a0
ffffffffc020adfc:	10050b63          	beqz	a0,ffffffffc020af12 <sfs_load_inode+0x160>
ffffffffc020ae00:	14048f63          	beqz	s1,ffffffffc020af5e <sfs_load_inode+0x1ac>
ffffffffc020ae04:	00492703          	lw	a4,4(s2)
ffffffffc020ae08:	14e4fb63          	bgeu	s1,a4,ffffffffc020af5e <sfs_load_inode+0x1ac>
ffffffffc020ae0c:	03893503          	ld	a0,56(s2)
ffffffffc020ae10:	85a6                	mv	a1,s1
ffffffffc020ae12:	e43e                	sd	a5,8(sp)
ffffffffc020ae14:	967fe0ef          	jal	ffffffffc020977a <bitmap_test>
ffffffffc020ae18:	16051263          	bnez	a0,ffffffffc020af7c <sfs_load_inode+0x1ca>
ffffffffc020ae1c:	65a2                	ld	a1,8(sp)
ffffffffc020ae1e:	4701                	li	a4,0
ffffffffc020ae20:	86a6                	mv	a3,s1
ffffffffc020ae22:	04000613          	li	a2,64
ffffffffc020ae26:	854a                	mv	a0,s2
ffffffffc020ae28:	718000ef          	jal	ffffffffc020b540 <sfs_rbuf>
ffffffffc020ae2c:	67a2                	ld	a5,8(sp)
ffffffffc020ae2e:	842a                	mv	s0,a0
ffffffffc020ae30:	0e051e63          	bnez	a0,ffffffffc020af2c <sfs_load_inode+0x17a>
ffffffffc020ae34:	0067d703          	lhu	a4,6(a5)
ffffffffc020ae38:	10070363          	beqz	a4,ffffffffc020af3e <sfs_load_inode+0x18c>
ffffffffc020ae3c:	6505                	lui	a0,0x1
ffffffffc020ae3e:	23550513          	addi	a0,a0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ae42:	e43e                	sd	a5,8(sp)
ffffffffc020ae44:	8acfd0ef          	jal	ffffffffc0207ef0 <__alloc_inode>
ffffffffc020ae48:	67a2                	ld	a5,8(sp)
ffffffffc020ae4a:	842a                	mv	s0,a0
ffffffffc020ae4c:	cd79                	beqz	a0,ffffffffc020af2a <sfs_load_inode+0x178>
ffffffffc020ae4e:	0047d683          	lhu	a3,4(a5)
ffffffffc020ae52:	4705                	li	a4,1
ffffffffc020ae54:	0ee68063          	beq	a3,a4,ffffffffc020af34 <sfs_load_inode+0x182>
ffffffffc020ae58:	4709                	li	a4,2
ffffffffc020ae5a:	00005597          	auipc	a1,0x5
ffffffffc020ae5e:	f2e58593          	addi	a1,a1,-210 # ffffffffc020fd88 <sfs_node_dirops>
ffffffffc020ae62:	16e69d63          	bne	a3,a4,ffffffffc020afdc <sfs_load_inode+0x22a>
ffffffffc020ae66:	864a                	mv	a2,s2
ffffffffc020ae68:	8522                	mv	a0,s0
ffffffffc020ae6a:	e43e                	sd	a5,8(sp)
ffffffffc020ae6c:	8a0fd0ef          	jal	ffffffffc0207f0c <inode_init>
ffffffffc020ae70:	4c34                	lw	a3,88(s0)
ffffffffc020ae72:	6705                	lui	a4,0x1
ffffffffc020ae74:	23570713          	addi	a4,a4,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020ae78:	67a2                	ld	a5,8(sp)
ffffffffc020ae7a:	14e69163          	bne	a3,a4,ffffffffc020afbc <sfs_load_inode+0x20a>
ffffffffc020ae7e:	4585                	li	a1,1
ffffffffc020ae80:	e01c                	sd	a5,0(s0)
ffffffffc020ae82:	c404                	sw	s1,8(s0)
ffffffffc020ae84:	00043823          	sd	zero,16(s0)
ffffffffc020ae88:	cc0c                	sw	a1,24(s0)
ffffffffc020ae8a:	02040513          	addi	a0,s0,32
ffffffffc020ae8e:	e436                	sd	a3,8(sp)
ffffffffc020ae90:	f7ef90ef          	jal	ffffffffc020460e <sem_init>
ffffffffc020ae94:	4c3c                	lw	a5,88(s0)
ffffffffc020ae96:	66a2                	ld	a3,8(sp)
ffffffffc020ae98:	10d79263          	bne	a5,a3,ffffffffc020af9c <sfs_load_inode+0x1ea>
ffffffffc020ae9c:	0a093703          	ld	a4,160(s2)
ffffffffc020aea0:	03840793          	addi	a5,s0,56
ffffffffc020aea4:	4408                	lw	a0,8(s0)
ffffffffc020aea6:	e31c                	sd	a5,0(a4)
ffffffffc020aea8:	0af93023          	sd	a5,160(s2)
ffffffffc020aeac:	09890793          	addi	a5,s2,152
ffffffffc020aeb0:	e038                	sd	a4,64(s0)
ffffffffc020aeb2:	fc1c                	sd	a5,56(s0)
ffffffffc020aeb4:	45a9                	li	a1,10
ffffffffc020aeb6:	0a893483          	ld	s1,168(s2)
ffffffffc020aeba:	0db000ef          	jal	ffffffffc020b794 <hash32>
ffffffffc020aebe:	02051713          	slli	a4,a0,0x20
ffffffffc020aec2:	01c75793          	srli	a5,a4,0x1c
ffffffffc020aec6:	97a6                	add	a5,a5,s1
ffffffffc020aec8:	6798                	ld	a4,8(a5)
ffffffffc020aeca:	04840693          	addi	a3,s0,72
ffffffffc020aece:	e314                	sd	a3,0(a4)
ffffffffc020aed0:	e794                	sd	a3,8(a5)
ffffffffc020aed2:	e838                	sd	a4,80(s0)
ffffffffc020aed4:	e43c                	sd	a5,72(s0)
ffffffffc020aed6:	854a                	mv	a0,s2
ffffffffc020aed8:	0ad000ef          	jal	ffffffffc020b784 <unlock_sfs_fs>
ffffffffc020aedc:	0089b023          	sd	s0,0(s3)
ffffffffc020aee0:	4401                	li	s0,0
ffffffffc020aee2:	70e2                	ld	ra,56(sp)
ffffffffc020aee4:	8522                	mv	a0,s0
ffffffffc020aee6:	7442                	ld	s0,48(sp)
ffffffffc020aee8:	74a2                	ld	s1,40(sp)
ffffffffc020aeea:	7902                	ld	s2,32(sp)
ffffffffc020aeec:	69e2                	ld	s3,24(sp)
ffffffffc020aeee:	6121                	addi	sp,sp,64
ffffffffc020aef0:	8082                	ret
ffffffffc020aef2:	fb878413          	addi	s0,a5,-72
ffffffffc020aef6:	8522                	mv	a0,s0
ffffffffc020aef8:	e43e                	sd	a5,8(sp)
ffffffffc020aefa:	874fd0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc020aefe:	4705                	li	a4,1
ffffffffc020af00:	67a2                	ld	a5,8(sp)
ffffffffc020af02:	fce51ae3          	bne	a0,a4,ffffffffc020aed6 <sfs_load_inode+0x124>
ffffffffc020af06:	fd07a703          	lw	a4,-48(a5)
ffffffffc020af0a:	2705                	addiw	a4,a4,1
ffffffffc020af0c:	fce7a823          	sw	a4,-48(a5)
ffffffffc020af10:	b7d9                	j	ffffffffc020aed6 <sfs_load_inode+0x124>
ffffffffc020af12:	5471                	li	s0,-4
ffffffffc020af14:	854a                	mv	a0,s2
ffffffffc020af16:	06f000ef          	jal	ffffffffc020b784 <unlock_sfs_fs>
ffffffffc020af1a:	70e2                	ld	ra,56(sp)
ffffffffc020af1c:	8522                	mv	a0,s0
ffffffffc020af1e:	7442                	ld	s0,48(sp)
ffffffffc020af20:	74a2                	ld	s1,40(sp)
ffffffffc020af22:	7902                	ld	s2,32(sp)
ffffffffc020af24:	69e2                	ld	s3,24(sp)
ffffffffc020af26:	6121                	addi	sp,sp,64
ffffffffc020af28:	8082                	ret
ffffffffc020af2a:	5471                	li	s0,-4
ffffffffc020af2c:	853e                	mv	a0,a5
ffffffffc020af2e:	b00f70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020af32:	b7cd                	j	ffffffffc020af14 <sfs_load_inode+0x162>
ffffffffc020af34:	00005597          	auipc	a1,0x5
ffffffffc020af38:	dd458593          	addi	a1,a1,-556 # ffffffffc020fd08 <sfs_node_fileops>
ffffffffc020af3c:	b72d                	j	ffffffffc020ae66 <sfs_load_inode+0xb4>
ffffffffc020af3e:	00004697          	auipc	a3,0x4
ffffffffc020af42:	0ea68693          	addi	a3,a3,234 # ffffffffc020f028 <etext+0x32f0>
ffffffffc020af46:	00001617          	auipc	a2,0x1
ffffffffc020af4a:	22a60613          	addi	a2,a2,554 # ffffffffc020c170 <etext+0x438>
ffffffffc020af4e:	0ad00593          	li	a1,173
ffffffffc020af52:	00004517          	auipc	a0,0x4
ffffffffc020af56:	e7650513          	addi	a0,a0,-394 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020af5a:	cf0f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020af5e:	00492683          	lw	a3,4(s2)
ffffffffc020af62:	8726                	mv	a4,s1
ffffffffc020af64:	00004617          	auipc	a2,0x4
ffffffffc020af68:	e9460613          	addi	a2,a2,-364 # ffffffffc020edf8 <etext+0x30c0>
ffffffffc020af6c:	05300593          	li	a1,83
ffffffffc020af70:	00004517          	auipc	a0,0x4
ffffffffc020af74:	e5850513          	addi	a0,a0,-424 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020af78:	cd2f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020af7c:	00004697          	auipc	a3,0x4
ffffffffc020af80:	eb468693          	addi	a3,a3,-332 # ffffffffc020ee30 <etext+0x30f8>
ffffffffc020af84:	00001617          	auipc	a2,0x1
ffffffffc020af88:	1ec60613          	addi	a2,a2,492 # ffffffffc020c170 <etext+0x438>
ffffffffc020af8c:	0a800593          	li	a1,168
ffffffffc020af90:	00004517          	auipc	a0,0x4
ffffffffc020af94:	e3850513          	addi	a0,a0,-456 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020af98:	cb2f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020af9c:	00004697          	auipc	a3,0x4
ffffffffc020afa0:	df468693          	addi	a3,a3,-524 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020afa4:	00001617          	auipc	a2,0x1
ffffffffc020afa8:	1cc60613          	addi	a2,a2,460 # ffffffffc020c170 <etext+0x438>
ffffffffc020afac:	0b100593          	li	a1,177
ffffffffc020afb0:	00004517          	auipc	a0,0x4
ffffffffc020afb4:	e1850513          	addi	a0,a0,-488 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020afb8:	c92f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020afbc:	00004697          	auipc	a3,0x4
ffffffffc020afc0:	dd468693          	addi	a3,a3,-556 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020afc4:	00001617          	auipc	a2,0x1
ffffffffc020afc8:	1ac60613          	addi	a2,a2,428 # ffffffffc020c170 <etext+0x438>
ffffffffc020afcc:	07700593          	li	a1,119
ffffffffc020afd0:	00004517          	auipc	a0,0x4
ffffffffc020afd4:	df850513          	addi	a0,a0,-520 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020afd8:	c72f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020afdc:	00004617          	auipc	a2,0x4
ffffffffc020afe0:	e0460613          	addi	a2,a2,-508 # ffffffffc020ede0 <etext+0x30a8>
ffffffffc020afe4:	02e00593          	li	a1,46
ffffffffc020afe8:	00004517          	auipc	a0,0x4
ffffffffc020afec:	de050513          	addi	a0,a0,-544 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020aff0:	c5af50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020aff4 <sfs_lookup_once.constprop.0>:
ffffffffc020aff4:	711d                	addi	sp,sp,-96
ffffffffc020aff6:	f852                	sd	s4,48(sp)
ffffffffc020aff8:	8a2a                	mv	s4,a0
ffffffffc020affa:	02058513          	addi	a0,a1,32
ffffffffc020affe:	ec86                	sd	ra,88(sp)
ffffffffc020b000:	e0ca                	sd	s2,64(sp)
ffffffffc020b002:	f456                	sd	s5,40(sp)
ffffffffc020b004:	e862                	sd	s8,16(sp)
ffffffffc020b006:	8ab2                	mv	s5,a2
ffffffffc020b008:	892e                	mv	s2,a1
ffffffffc020b00a:	8c36                	mv	s8,a3
ffffffffc020b00c:	e0cf90ef          	jal	ffffffffc0204618 <down>
ffffffffc020b010:	8556                	mv	a0,s5
ffffffffc020b012:	40b000ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc020b016:	0ff00793          	li	a5,255
ffffffffc020b01a:	0aa7e963          	bltu	a5,a0,ffffffffc020b0cc <sfs_lookup_once.constprop.0+0xd8>
ffffffffc020b01e:	10400513          	li	a0,260
ffffffffc020b022:	e4a6                	sd	s1,72(sp)
ffffffffc020b024:	964f70ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020b028:	84aa                	mv	s1,a0
ffffffffc020b02a:	c959                	beqz	a0,ffffffffc020b0c0 <sfs_lookup_once.constprop.0+0xcc>
ffffffffc020b02c:	00093783          	ld	a5,0(s2)
ffffffffc020b030:	fc4e                	sd	s3,56(sp)
ffffffffc020b032:	0087a983          	lw	s3,8(a5)
ffffffffc020b036:	05305d63          	blez	s3,ffffffffc020b090 <sfs_lookup_once.constprop.0+0x9c>
ffffffffc020b03a:	e8a2                	sd	s0,80(sp)
ffffffffc020b03c:	4401                	li	s0,0
ffffffffc020b03e:	a821                	j	ffffffffc020b056 <sfs_lookup_once.constprop.0+0x62>
ffffffffc020b040:	409c                	lw	a5,0(s1)
ffffffffc020b042:	c799                	beqz	a5,ffffffffc020b050 <sfs_lookup_once.constprop.0+0x5c>
ffffffffc020b044:	00448593          	addi	a1,s1,4
ffffffffc020b048:	8556                	mv	a0,s5
ffffffffc020b04a:	419000ef          	jal	ffffffffc020bc62 <strcmp>
ffffffffc020b04e:	c139                	beqz	a0,ffffffffc020b094 <sfs_lookup_once.constprop.0+0xa0>
ffffffffc020b050:	2405                	addiw	s0,s0,1
ffffffffc020b052:	02898e63          	beq	s3,s0,ffffffffc020b08e <sfs_lookup_once.constprop.0+0x9a>
ffffffffc020b056:	86a6                	mv	a3,s1
ffffffffc020b058:	8622                	mv	a2,s0
ffffffffc020b05a:	85ca                	mv	a1,s2
ffffffffc020b05c:	8552                	mv	a0,s4
ffffffffc020b05e:	8a7ff0ef          	jal	ffffffffc020a904 <sfs_dirent_read_nolock>
ffffffffc020b062:	87aa                	mv	a5,a0
ffffffffc020b064:	dd71                	beqz	a0,ffffffffc020b040 <sfs_lookup_once.constprop.0+0x4c>
ffffffffc020b066:	6446                	ld	s0,80(sp)
ffffffffc020b068:	8526                	mv	a0,s1
ffffffffc020b06a:	e43e                	sd	a5,8(sp)
ffffffffc020b06c:	9c2f70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020b070:	02090513          	addi	a0,s2,32
ffffffffc020b074:	da0f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020b078:	67a2                	ld	a5,8(sp)
ffffffffc020b07a:	79e2                	ld	s3,56(sp)
ffffffffc020b07c:	60e6                	ld	ra,88(sp)
ffffffffc020b07e:	64a6                	ld	s1,72(sp)
ffffffffc020b080:	6906                	ld	s2,64(sp)
ffffffffc020b082:	7a42                	ld	s4,48(sp)
ffffffffc020b084:	7aa2                	ld	s5,40(sp)
ffffffffc020b086:	6c42                	ld	s8,16(sp)
ffffffffc020b088:	853e                	mv	a0,a5
ffffffffc020b08a:	6125                	addi	sp,sp,96
ffffffffc020b08c:	8082                	ret
ffffffffc020b08e:	6446                	ld	s0,80(sp)
ffffffffc020b090:	57c1                	li	a5,-16
ffffffffc020b092:	bfd9                	j	ffffffffc020b068 <sfs_lookup_once.constprop.0+0x74>
ffffffffc020b094:	8526                	mv	a0,s1
ffffffffc020b096:	4080                	lw	s0,0(s1)
ffffffffc020b098:	996f70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020b09c:	02090513          	addi	a0,s2,32
ffffffffc020b0a0:	d74f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020b0a4:	8622                	mv	a2,s0
ffffffffc020b0a6:	6446                	ld	s0,80(sp)
ffffffffc020b0a8:	64a6                	ld	s1,72(sp)
ffffffffc020b0aa:	79e2                	ld	s3,56(sp)
ffffffffc020b0ac:	60e6                	ld	ra,88(sp)
ffffffffc020b0ae:	6906                	ld	s2,64(sp)
ffffffffc020b0b0:	7aa2                	ld	s5,40(sp)
ffffffffc020b0b2:	85e2                	mv	a1,s8
ffffffffc020b0b4:	8552                	mv	a0,s4
ffffffffc020b0b6:	6c42                	ld	s8,16(sp)
ffffffffc020b0b8:	7a42                	ld	s4,48(sp)
ffffffffc020b0ba:	6125                	addi	sp,sp,96
ffffffffc020b0bc:	cf7ff06f          	j	ffffffffc020adb2 <sfs_load_inode>
ffffffffc020b0c0:	02090513          	addi	a0,s2,32
ffffffffc020b0c4:	d50f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020b0c8:	57f1                	li	a5,-4
ffffffffc020b0ca:	bf4d                	j	ffffffffc020b07c <sfs_lookup_once.constprop.0+0x88>
ffffffffc020b0cc:	00004697          	auipc	a3,0x4
ffffffffc020b0d0:	f7468693          	addi	a3,a3,-140 # ffffffffc020f040 <etext+0x3308>
ffffffffc020b0d4:	00001617          	auipc	a2,0x1
ffffffffc020b0d8:	09c60613          	addi	a2,a2,156 # ffffffffc020c170 <etext+0x438>
ffffffffc020b0dc:	1ba00593          	li	a1,442
ffffffffc020b0e0:	00004517          	auipc	a0,0x4
ffffffffc020b0e4:	ce850513          	addi	a0,a0,-792 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b0e8:	e8a2                	sd	s0,80(sp)
ffffffffc020b0ea:	e4a6                	sd	s1,72(sp)
ffffffffc020b0ec:	fc4e                	sd	s3,56(sp)
ffffffffc020b0ee:	f05a                	sd	s6,32(sp)
ffffffffc020b0f0:	ec5e                	sd	s7,24(sp)
ffffffffc020b0f2:	b58f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b0f6 <sfs_namefile>:
ffffffffc020b0f6:	6d9c                	ld	a5,24(a1)
ffffffffc020b0f8:	7175                	addi	sp,sp,-144
ffffffffc020b0fa:	f86a                	sd	s10,48(sp)
ffffffffc020b0fc:	e506                	sd	ra,136(sp)
ffffffffc020b0fe:	f46e                	sd	s11,40(sp)
ffffffffc020b100:	4d09                	li	s10,2
ffffffffc020b102:	1afd7763          	bgeu	s10,a5,ffffffffc020b2b0 <sfs_namefile+0x1ba>
ffffffffc020b106:	f4ce                	sd	s3,104(sp)
ffffffffc020b108:	89aa                	mv	s3,a0
ffffffffc020b10a:	10400513          	li	a0,260
ffffffffc020b10e:	fca6                	sd	s1,120(sp)
ffffffffc020b110:	e42e                	sd	a1,8(sp)
ffffffffc020b112:	876f70ef          	jal	ffffffffc0202188 <kmalloc>
ffffffffc020b116:	84aa                	mv	s1,a0
ffffffffc020b118:	18050a63          	beqz	a0,ffffffffc020b2ac <sfs_namefile+0x1b6>
ffffffffc020b11c:	f0d2                	sd	s4,96(sp)
ffffffffc020b11e:	0689ba03          	ld	s4,104(s3)
ffffffffc020b122:	1e0a0c63          	beqz	s4,ffffffffc020b31a <sfs_namefile+0x224>
ffffffffc020b126:	0b0a2783          	lw	a5,176(s4)
ffffffffc020b12a:	1e079863          	bnez	a5,ffffffffc020b31a <sfs_namefile+0x224>
ffffffffc020b12e:	0589a703          	lw	a4,88(s3)
ffffffffc020b132:	6785                	lui	a5,0x1
ffffffffc020b134:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020b138:	e03a                	sd	a4,0(sp)
ffffffffc020b13a:	e122                	sd	s0,128(sp)
ffffffffc020b13c:	f8ca                	sd	s2,112(sp)
ffffffffc020b13e:	ecd6                	sd	s5,88(sp)
ffffffffc020b140:	e8da                	sd	s6,80(sp)
ffffffffc020b142:	e4de                	sd	s7,72(sp)
ffffffffc020b144:	e0e2                	sd	s8,64(sp)
ffffffffc020b146:	1af71963          	bne	a4,a5,ffffffffc020b2f8 <sfs_namefile+0x202>
ffffffffc020b14a:	6722                	ld	a4,8(sp)
ffffffffc020b14c:	854e                	mv	a0,s3
ffffffffc020b14e:	8b4e                	mv	s6,s3
ffffffffc020b150:	6f1c                	ld	a5,24(a4)
ffffffffc020b152:	00073a83          	ld	s5,0(a4)
ffffffffc020b156:	ffe78c13          	addi	s8,a5,-2
ffffffffc020b15a:	9abe                	add	s5,s5,a5
ffffffffc020b15c:	e13fc0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc020b160:	0834                	addi	a3,sp,24
ffffffffc020b162:	00004617          	auipc	a2,0x4
ffffffffc020b166:	f0660613          	addi	a2,a2,-250 # ffffffffc020f068 <etext+0x3330>
ffffffffc020b16a:	85da                	mv	a1,s6
ffffffffc020b16c:	8552                	mv	a0,s4
ffffffffc020b16e:	e87ff0ef          	jal	ffffffffc020aff4 <sfs_lookup_once.constprop.0>
ffffffffc020b172:	8daa                	mv	s11,a0
ffffffffc020b174:	e94d                	bnez	a0,ffffffffc020b226 <sfs_namefile+0x130>
ffffffffc020b176:	854e                	mv	a0,s3
ffffffffc020b178:	008b2903          	lw	s2,8(s6)
ffffffffc020b17c:	ec1fc0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020b180:	6462                	ld	s0,24(sp)
ffffffffc020b182:	0f340563          	beq	s0,s3,ffffffffc020b26c <sfs_namefile+0x176>
ffffffffc020b186:	14040863          	beqz	s0,ffffffffc020b2d6 <sfs_namefile+0x1e0>
ffffffffc020b18a:	4c38                	lw	a4,88(s0)
ffffffffc020b18c:	6782                	ld	a5,0(sp)
ffffffffc020b18e:	14f71463          	bne	a4,a5,ffffffffc020b2d6 <sfs_namefile+0x1e0>
ffffffffc020b192:	4418                	lw	a4,8(s0)
ffffffffc020b194:	13270063          	beq	a4,s2,ffffffffc020b2b4 <sfs_namefile+0x1be>
ffffffffc020b198:	6018                	ld	a4,0(s0)
ffffffffc020b19a:	00475703          	lhu	a4,4(a4)
ffffffffc020b19e:	11a71b63          	bne	a4,s10,ffffffffc020b2b4 <sfs_namefile+0x1be>
ffffffffc020b1a2:	02040b93          	addi	s7,s0,32
ffffffffc020b1a6:	855e                	mv	a0,s7
ffffffffc020b1a8:	c70f90ef          	jal	ffffffffc0204618 <down>
ffffffffc020b1ac:	6018                	ld	a4,0(s0)
ffffffffc020b1ae:	00872983          	lw	s3,8(a4)
ffffffffc020b1b2:	0b305763          	blez	s3,ffffffffc020b260 <sfs_namefile+0x16a>
ffffffffc020b1b6:	8b22                	mv	s6,s0
ffffffffc020b1b8:	a039                	j	ffffffffc020b1c6 <sfs_namefile+0xd0>
ffffffffc020b1ba:	4098                	lw	a4,0(s1)
ffffffffc020b1bc:	01270e63          	beq	a4,s2,ffffffffc020b1d8 <sfs_namefile+0xe2>
ffffffffc020b1c0:	2d85                	addiw	s11,s11,1
ffffffffc020b1c2:	09b98763          	beq	s3,s11,ffffffffc020b250 <sfs_namefile+0x15a>
ffffffffc020b1c6:	86a6                	mv	a3,s1
ffffffffc020b1c8:	866e                	mv	a2,s11
ffffffffc020b1ca:	85a2                	mv	a1,s0
ffffffffc020b1cc:	8552                	mv	a0,s4
ffffffffc020b1ce:	f36ff0ef          	jal	ffffffffc020a904 <sfs_dirent_read_nolock>
ffffffffc020b1d2:	872a                	mv	a4,a0
ffffffffc020b1d4:	d17d                	beqz	a0,ffffffffc020b1ba <sfs_namefile+0xc4>
ffffffffc020b1d6:	a8b5                	j	ffffffffc020b252 <sfs_namefile+0x15c>
ffffffffc020b1d8:	855e                	mv	a0,s7
ffffffffc020b1da:	c3af90ef          	jal	ffffffffc0204614 <up>
ffffffffc020b1de:	00448513          	addi	a0,s1,4
ffffffffc020b1e2:	23b000ef          	jal	ffffffffc020bc1c <strlen>
ffffffffc020b1e6:	00150793          	addi	a5,a0,1
ffffffffc020b1ea:	0afc6e63          	bltu	s8,a5,ffffffffc020b2a6 <sfs_namefile+0x1b0>
ffffffffc020b1ee:	fff54913          	not	s2,a0
ffffffffc020b1f2:	862a                	mv	a2,a0
ffffffffc020b1f4:	00448593          	addi	a1,s1,4
ffffffffc020b1f8:	012a8533          	add	a0,s5,s2
ffffffffc020b1fc:	40fc0c33          	sub	s8,s8,a5
ffffffffc020b200:	321000ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc020b204:	02f00793          	li	a5,47
ffffffffc020b208:	fefa8fa3          	sb	a5,-1(s5)
ffffffffc020b20c:	0834                	addi	a3,sp,24
ffffffffc020b20e:	00004617          	auipc	a2,0x4
ffffffffc020b212:	e5a60613          	addi	a2,a2,-422 # ffffffffc020f068 <etext+0x3330>
ffffffffc020b216:	85da                	mv	a1,s6
ffffffffc020b218:	8552                	mv	a0,s4
ffffffffc020b21a:	ddbff0ef          	jal	ffffffffc020aff4 <sfs_lookup_once.constprop.0>
ffffffffc020b21e:	89a2                	mv	s3,s0
ffffffffc020b220:	9aca                	add	s5,s5,s2
ffffffffc020b222:	8daa                	mv	s11,a0
ffffffffc020b224:	d929                	beqz	a0,ffffffffc020b176 <sfs_namefile+0x80>
ffffffffc020b226:	854e                	mv	a0,s3
ffffffffc020b228:	e15fc0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020b22c:	8526                	mv	a0,s1
ffffffffc020b22e:	800f70ef          	jal	ffffffffc020222e <kfree>
ffffffffc020b232:	640a                	ld	s0,128(sp)
ffffffffc020b234:	74e6                	ld	s1,120(sp)
ffffffffc020b236:	7946                	ld	s2,112(sp)
ffffffffc020b238:	79a6                	ld	s3,104(sp)
ffffffffc020b23a:	7a06                	ld	s4,96(sp)
ffffffffc020b23c:	6ae6                	ld	s5,88(sp)
ffffffffc020b23e:	6b46                	ld	s6,80(sp)
ffffffffc020b240:	6ba6                	ld	s7,72(sp)
ffffffffc020b242:	6c06                	ld	s8,64(sp)
ffffffffc020b244:	60aa                	ld	ra,136(sp)
ffffffffc020b246:	7d42                	ld	s10,48(sp)
ffffffffc020b248:	856e                	mv	a0,s11
ffffffffc020b24a:	7da2                	ld	s11,40(sp)
ffffffffc020b24c:	6149                	addi	sp,sp,144
ffffffffc020b24e:	8082                	ret
ffffffffc020b250:	5741                	li	a4,-16
ffffffffc020b252:	855e                	mv	a0,s7
ffffffffc020b254:	e03a                	sd	a4,0(sp)
ffffffffc020b256:	89a2                	mv	s3,s0
ffffffffc020b258:	bbcf90ef          	jal	ffffffffc0204614 <up>
ffffffffc020b25c:	6d82                	ld	s11,0(sp)
ffffffffc020b25e:	b7e1                	j	ffffffffc020b226 <sfs_namefile+0x130>
ffffffffc020b260:	855e                	mv	a0,s7
ffffffffc020b262:	bb2f90ef          	jal	ffffffffc0204614 <up>
ffffffffc020b266:	89a2                	mv	s3,s0
ffffffffc020b268:	5dc1                	li	s11,-16
ffffffffc020b26a:	bf75                	j	ffffffffc020b226 <sfs_namefile+0x130>
ffffffffc020b26c:	854e                	mv	a0,s3
ffffffffc020b26e:	dcffc0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020b272:	6922                	ld	s2,8(sp)
ffffffffc020b274:	85d6                	mv	a1,s5
ffffffffc020b276:	01893403          	ld	s0,24(s2)
ffffffffc020b27a:	00093503          	ld	a0,0(s2)
ffffffffc020b27e:	1479                	addi	s0,s0,-2
ffffffffc020b280:	41840433          	sub	s0,s0,s8
ffffffffc020b284:	8622                	mv	a2,s0
ffffffffc020b286:	0505                	addi	a0,a0,1
ffffffffc020b288:	25b000ef          	jal	ffffffffc020bce2 <memmove>
ffffffffc020b28c:	02f00713          	li	a4,47
ffffffffc020b290:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020b294:	00850733          	add	a4,a0,s0
ffffffffc020b298:	00070023          	sb	zero,0(a4)
ffffffffc020b29c:	854a                	mv	a0,s2
ffffffffc020b29e:	85a2                	mv	a1,s0
ffffffffc020b2a0:	a9cfa0ef          	jal	ffffffffc020553c <iobuf_skip>
ffffffffc020b2a4:	b761                	j	ffffffffc020b22c <sfs_namefile+0x136>
ffffffffc020b2a6:	89a2                	mv	s3,s0
ffffffffc020b2a8:	5df1                	li	s11,-4
ffffffffc020b2aa:	bfb5                	j	ffffffffc020b226 <sfs_namefile+0x130>
ffffffffc020b2ac:	74e6                	ld	s1,120(sp)
ffffffffc020b2ae:	79a6                	ld	s3,104(sp)
ffffffffc020b2b0:	5df1                	li	s11,-4
ffffffffc020b2b2:	bf49                	j	ffffffffc020b244 <sfs_namefile+0x14e>
ffffffffc020b2b4:	00004697          	auipc	a3,0x4
ffffffffc020b2b8:	dbc68693          	addi	a3,a3,-580 # ffffffffc020f070 <etext+0x3338>
ffffffffc020b2bc:	00001617          	auipc	a2,0x1
ffffffffc020b2c0:	eb460613          	addi	a2,a2,-332 # ffffffffc020c170 <etext+0x438>
ffffffffc020b2c4:	2fc00593          	li	a1,764
ffffffffc020b2c8:	00004517          	auipc	a0,0x4
ffffffffc020b2cc:	b0050513          	addi	a0,a0,-1280 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b2d0:	fc66                	sd	s9,56(sp)
ffffffffc020b2d2:	978f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b2d6:	00004697          	auipc	a3,0x4
ffffffffc020b2da:	aba68693          	addi	a3,a3,-1350 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020b2de:	00001617          	auipc	a2,0x1
ffffffffc020b2e2:	e9260613          	addi	a2,a2,-366 # ffffffffc020c170 <etext+0x438>
ffffffffc020b2e6:	2fb00593          	li	a1,763
ffffffffc020b2ea:	00004517          	auipc	a0,0x4
ffffffffc020b2ee:	ade50513          	addi	a0,a0,-1314 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b2f2:	fc66                	sd	s9,56(sp)
ffffffffc020b2f4:	956f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b2f8:	00004697          	auipc	a3,0x4
ffffffffc020b2fc:	a9868693          	addi	a3,a3,-1384 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020b300:	00001617          	auipc	a2,0x1
ffffffffc020b304:	e7060613          	addi	a2,a2,-400 # ffffffffc020c170 <etext+0x438>
ffffffffc020b308:	2e800593          	li	a1,744
ffffffffc020b30c:	00004517          	auipc	a0,0x4
ffffffffc020b310:	abc50513          	addi	a0,a0,-1348 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b314:	fc66                	sd	s9,56(sp)
ffffffffc020b316:	934f50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b31a:	00004697          	auipc	a3,0x4
ffffffffc020b31e:	8ce68693          	addi	a3,a3,-1842 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020b322:	00001617          	auipc	a2,0x1
ffffffffc020b326:	e4e60613          	addi	a2,a2,-434 # ffffffffc020c170 <etext+0x438>
ffffffffc020b32a:	2e700593          	li	a1,743
ffffffffc020b32e:	00004517          	auipc	a0,0x4
ffffffffc020b332:	a9a50513          	addi	a0,a0,-1382 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b336:	e122                	sd	s0,128(sp)
ffffffffc020b338:	f8ca                	sd	s2,112(sp)
ffffffffc020b33a:	ecd6                	sd	s5,88(sp)
ffffffffc020b33c:	e8da                	sd	s6,80(sp)
ffffffffc020b33e:	e4de                	sd	s7,72(sp)
ffffffffc020b340:	e0e2                	sd	s8,64(sp)
ffffffffc020b342:	fc66                	sd	s9,56(sp)
ffffffffc020b344:	906f50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b348 <sfs_lookup>:
ffffffffc020b348:	7139                	addi	sp,sp,-64
ffffffffc020b34a:	f426                	sd	s1,40(sp)
ffffffffc020b34c:	7524                	ld	s1,104(a0)
ffffffffc020b34e:	fc06                	sd	ra,56(sp)
ffffffffc020b350:	f822                	sd	s0,48(sp)
ffffffffc020b352:	f04a                	sd	s2,32(sp)
ffffffffc020b354:	c4b5                	beqz	s1,ffffffffc020b3c0 <sfs_lookup+0x78>
ffffffffc020b356:	0b04a783          	lw	a5,176(s1)
ffffffffc020b35a:	e3bd                	bnez	a5,ffffffffc020b3c0 <sfs_lookup+0x78>
ffffffffc020b35c:	0005c783          	lbu	a5,0(a1)
ffffffffc020b360:	c3c5                	beqz	a5,ffffffffc020b400 <sfs_lookup+0xb8>
ffffffffc020b362:	fd178793          	addi	a5,a5,-47
ffffffffc020b366:	cfc9                	beqz	a5,ffffffffc020b400 <sfs_lookup+0xb8>
ffffffffc020b368:	842a                	mv	s0,a0
ffffffffc020b36a:	8932                	mv	s2,a2
ffffffffc020b36c:	e42e                	sd	a1,8(sp)
ffffffffc020b36e:	c01fc0ef          	jal	ffffffffc0207f6e <inode_ref_inc>
ffffffffc020b372:	4c38                	lw	a4,88(s0)
ffffffffc020b374:	6785                	lui	a5,0x1
ffffffffc020b376:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020b37a:	06f71363          	bne	a4,a5,ffffffffc020b3e0 <sfs_lookup+0x98>
ffffffffc020b37e:	6018                	ld	a4,0(s0)
ffffffffc020b380:	4789                	li	a5,2
ffffffffc020b382:	00475703          	lhu	a4,4(a4)
ffffffffc020b386:	02f71863          	bne	a4,a5,ffffffffc020b3b6 <sfs_lookup+0x6e>
ffffffffc020b38a:	6622                	ld	a2,8(sp)
ffffffffc020b38c:	85a2                	mv	a1,s0
ffffffffc020b38e:	8526                	mv	a0,s1
ffffffffc020b390:	0834                	addi	a3,sp,24
ffffffffc020b392:	c63ff0ef          	jal	ffffffffc020aff4 <sfs_lookup_once.constprop.0>
ffffffffc020b396:	87aa                	mv	a5,a0
ffffffffc020b398:	8522                	mv	a0,s0
ffffffffc020b39a:	843e                	mv	s0,a5
ffffffffc020b39c:	ca1fc0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020b3a0:	e401                	bnez	s0,ffffffffc020b3a8 <sfs_lookup+0x60>
ffffffffc020b3a2:	67e2                	ld	a5,24(sp)
ffffffffc020b3a4:	00f93023          	sd	a5,0(s2)
ffffffffc020b3a8:	70e2                	ld	ra,56(sp)
ffffffffc020b3aa:	8522                	mv	a0,s0
ffffffffc020b3ac:	7442                	ld	s0,48(sp)
ffffffffc020b3ae:	74a2                	ld	s1,40(sp)
ffffffffc020b3b0:	7902                	ld	s2,32(sp)
ffffffffc020b3b2:	6121                	addi	sp,sp,64
ffffffffc020b3b4:	8082                	ret
ffffffffc020b3b6:	8522                	mv	a0,s0
ffffffffc020b3b8:	c85fc0ef          	jal	ffffffffc020803c <inode_ref_dec>
ffffffffc020b3bc:	5439                	li	s0,-18
ffffffffc020b3be:	b7ed                	j	ffffffffc020b3a8 <sfs_lookup+0x60>
ffffffffc020b3c0:	00004697          	auipc	a3,0x4
ffffffffc020b3c4:	82868693          	addi	a3,a3,-2008 # ffffffffc020ebe8 <etext+0x2eb0>
ffffffffc020b3c8:	00001617          	auipc	a2,0x1
ffffffffc020b3cc:	da860613          	addi	a2,a2,-600 # ffffffffc020c170 <etext+0x438>
ffffffffc020b3d0:	3dd00593          	li	a1,989
ffffffffc020b3d4:	00004517          	auipc	a0,0x4
ffffffffc020b3d8:	9f450513          	addi	a0,a0,-1548 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b3dc:	86ef50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b3e0:	00004697          	auipc	a3,0x4
ffffffffc020b3e4:	9b068693          	addi	a3,a3,-1616 # ffffffffc020ed90 <etext+0x3058>
ffffffffc020b3e8:	00001617          	auipc	a2,0x1
ffffffffc020b3ec:	d8860613          	addi	a2,a2,-632 # ffffffffc020c170 <etext+0x438>
ffffffffc020b3f0:	3e000593          	li	a1,992
ffffffffc020b3f4:	00004517          	auipc	a0,0x4
ffffffffc020b3f8:	9d450513          	addi	a0,a0,-1580 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b3fc:	84ef50ef          	jal	ffffffffc020044a <__panic>
ffffffffc020b400:	00004697          	auipc	a3,0x4
ffffffffc020b404:	ca868693          	addi	a3,a3,-856 # ffffffffc020f0a8 <etext+0x3370>
ffffffffc020b408:	00001617          	auipc	a2,0x1
ffffffffc020b40c:	d6860613          	addi	a2,a2,-664 # ffffffffc020c170 <etext+0x438>
ffffffffc020b410:	3de00593          	li	a1,990
ffffffffc020b414:	00004517          	auipc	a0,0x4
ffffffffc020b418:	9b450513          	addi	a0,a0,-1612 # ffffffffc020edc8 <etext+0x3090>
ffffffffc020b41c:	82ef50ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b420 <sfs_rwblock_nolock>:
ffffffffc020b420:	7139                	addi	sp,sp,-64
ffffffffc020b422:	f822                	sd	s0,48(sp)
ffffffffc020b424:	f426                	sd	s1,40(sp)
ffffffffc020b426:	fc06                	sd	ra,56(sp)
ffffffffc020b428:	842a                	mv	s0,a0
ffffffffc020b42a:	84b6                	mv	s1,a3
ffffffffc020b42c:	e219                	bnez	a2,ffffffffc020b432 <sfs_rwblock_nolock+0x12>
ffffffffc020b42e:	8b05                	andi	a4,a4,1
ffffffffc020b430:	e71d                	bnez	a4,ffffffffc020b45e <sfs_rwblock_nolock+0x3e>
ffffffffc020b432:	405c                	lw	a5,4(s0)
ffffffffc020b434:	02f67563          	bgeu	a2,a5,ffffffffc020b45e <sfs_rwblock_nolock+0x3e>
ffffffffc020b438:	00c6161b          	slliw	a2,a2,0xc
ffffffffc020b43c:	02061693          	slli	a3,a2,0x20
ffffffffc020b440:	9281                	srli	a3,a3,0x20
ffffffffc020b442:	6605                	lui	a2,0x1
ffffffffc020b444:	850a                	mv	a0,sp
ffffffffc020b446:	868fa0ef          	jal	ffffffffc02054ae <iobuf_init>
ffffffffc020b44a:	85aa                	mv	a1,a0
ffffffffc020b44c:	7808                	ld	a0,48(s0)
ffffffffc020b44e:	8626                	mv	a2,s1
ffffffffc020b450:	7118                	ld	a4,32(a0)
ffffffffc020b452:	9702                	jalr	a4
ffffffffc020b454:	70e2                	ld	ra,56(sp)
ffffffffc020b456:	7442                	ld	s0,48(sp)
ffffffffc020b458:	74a2                	ld	s1,40(sp)
ffffffffc020b45a:	6121                	addi	sp,sp,64
ffffffffc020b45c:	8082                	ret
ffffffffc020b45e:	00004697          	auipc	a3,0x4
ffffffffc020b462:	c6a68693          	addi	a3,a3,-918 # ffffffffc020f0c8 <etext+0x3390>
ffffffffc020b466:	00001617          	auipc	a2,0x1
ffffffffc020b46a:	d0a60613          	addi	a2,a2,-758 # ffffffffc020c170 <etext+0x438>
ffffffffc020b46e:	45d5                	li	a1,21
ffffffffc020b470:	00004517          	auipc	a0,0x4
ffffffffc020b474:	c9050513          	addi	a0,a0,-880 # ffffffffc020f100 <etext+0x33c8>
ffffffffc020b478:	fd3f40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b47c <sfs_rblock>:
ffffffffc020b47c:	7139                	addi	sp,sp,-64
ffffffffc020b47e:	ec4e                	sd	s3,24(sp)
ffffffffc020b480:	89b6                	mv	s3,a3
ffffffffc020b482:	f822                	sd	s0,48(sp)
ffffffffc020b484:	f04a                	sd	s2,32(sp)
ffffffffc020b486:	e852                	sd	s4,16(sp)
ffffffffc020b488:	fc06                	sd	ra,56(sp)
ffffffffc020b48a:	f426                	sd	s1,40(sp)
ffffffffc020b48c:	892e                	mv	s2,a1
ffffffffc020b48e:	8432                	mv	s0,a2
ffffffffc020b490:	8a2a                	mv	s4,a0
ffffffffc020b492:	2ea000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b496:	02098763          	beqz	s3,ffffffffc020b4c4 <sfs_rblock+0x48>
ffffffffc020b49a:	e456                	sd	s5,8(sp)
ffffffffc020b49c:	013409bb          	addw	s3,s0,s3
ffffffffc020b4a0:	6a85                	lui	s5,0x1
ffffffffc020b4a2:	a021                	j	ffffffffc020b4aa <sfs_rblock+0x2e>
ffffffffc020b4a4:	9956                	add	s2,s2,s5
ffffffffc020b4a6:	01340e63          	beq	s0,s3,ffffffffc020b4c2 <sfs_rblock+0x46>
ffffffffc020b4aa:	8622                	mv	a2,s0
ffffffffc020b4ac:	4705                	li	a4,1
ffffffffc020b4ae:	4681                	li	a3,0
ffffffffc020b4b0:	85ca                	mv	a1,s2
ffffffffc020b4b2:	8552                	mv	a0,s4
ffffffffc020b4b4:	f6dff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b4b8:	84aa                	mv	s1,a0
ffffffffc020b4ba:	2405                	addiw	s0,s0,1
ffffffffc020b4bc:	d565                	beqz	a0,ffffffffc020b4a4 <sfs_rblock+0x28>
ffffffffc020b4be:	6aa2                	ld	s5,8(sp)
ffffffffc020b4c0:	a019                	j	ffffffffc020b4c6 <sfs_rblock+0x4a>
ffffffffc020b4c2:	6aa2                	ld	s5,8(sp)
ffffffffc020b4c4:	4481                	li	s1,0
ffffffffc020b4c6:	8552                	mv	a0,s4
ffffffffc020b4c8:	2c4000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b4cc:	70e2                	ld	ra,56(sp)
ffffffffc020b4ce:	7442                	ld	s0,48(sp)
ffffffffc020b4d0:	7902                	ld	s2,32(sp)
ffffffffc020b4d2:	69e2                	ld	s3,24(sp)
ffffffffc020b4d4:	6a42                	ld	s4,16(sp)
ffffffffc020b4d6:	8526                	mv	a0,s1
ffffffffc020b4d8:	74a2                	ld	s1,40(sp)
ffffffffc020b4da:	6121                	addi	sp,sp,64
ffffffffc020b4dc:	8082                	ret

ffffffffc020b4de <sfs_wblock>:
ffffffffc020b4de:	7139                	addi	sp,sp,-64
ffffffffc020b4e0:	ec4e                	sd	s3,24(sp)
ffffffffc020b4e2:	89b6                	mv	s3,a3
ffffffffc020b4e4:	f822                	sd	s0,48(sp)
ffffffffc020b4e6:	f04a                	sd	s2,32(sp)
ffffffffc020b4e8:	e852                	sd	s4,16(sp)
ffffffffc020b4ea:	fc06                	sd	ra,56(sp)
ffffffffc020b4ec:	f426                	sd	s1,40(sp)
ffffffffc020b4ee:	892e                	mv	s2,a1
ffffffffc020b4f0:	8432                	mv	s0,a2
ffffffffc020b4f2:	8a2a                	mv	s4,a0
ffffffffc020b4f4:	288000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b4f8:	02098763          	beqz	s3,ffffffffc020b526 <sfs_wblock+0x48>
ffffffffc020b4fc:	e456                	sd	s5,8(sp)
ffffffffc020b4fe:	013409bb          	addw	s3,s0,s3
ffffffffc020b502:	6a85                	lui	s5,0x1
ffffffffc020b504:	a021                	j	ffffffffc020b50c <sfs_wblock+0x2e>
ffffffffc020b506:	9956                	add	s2,s2,s5
ffffffffc020b508:	01340e63          	beq	s0,s3,ffffffffc020b524 <sfs_wblock+0x46>
ffffffffc020b50c:	4705                	li	a4,1
ffffffffc020b50e:	8622                	mv	a2,s0
ffffffffc020b510:	86ba                	mv	a3,a4
ffffffffc020b512:	85ca                	mv	a1,s2
ffffffffc020b514:	8552                	mv	a0,s4
ffffffffc020b516:	f0bff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b51a:	84aa                	mv	s1,a0
ffffffffc020b51c:	2405                	addiw	s0,s0,1
ffffffffc020b51e:	d565                	beqz	a0,ffffffffc020b506 <sfs_wblock+0x28>
ffffffffc020b520:	6aa2                	ld	s5,8(sp)
ffffffffc020b522:	a019                	j	ffffffffc020b528 <sfs_wblock+0x4a>
ffffffffc020b524:	6aa2                	ld	s5,8(sp)
ffffffffc020b526:	4481                	li	s1,0
ffffffffc020b528:	8552                	mv	a0,s4
ffffffffc020b52a:	262000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b52e:	70e2                	ld	ra,56(sp)
ffffffffc020b530:	7442                	ld	s0,48(sp)
ffffffffc020b532:	7902                	ld	s2,32(sp)
ffffffffc020b534:	69e2                	ld	s3,24(sp)
ffffffffc020b536:	6a42                	ld	s4,16(sp)
ffffffffc020b538:	8526                	mv	a0,s1
ffffffffc020b53a:	74a2                	ld	s1,40(sp)
ffffffffc020b53c:	6121                	addi	sp,sp,64
ffffffffc020b53e:	8082                	ret

ffffffffc020b540 <sfs_rbuf>:
ffffffffc020b540:	7179                	addi	sp,sp,-48
ffffffffc020b542:	f406                	sd	ra,40(sp)
ffffffffc020b544:	f022                	sd	s0,32(sp)
ffffffffc020b546:	ec26                	sd	s1,24(sp)
ffffffffc020b548:	e84a                	sd	s2,16(sp)
ffffffffc020b54a:	e44e                	sd	s3,8(sp)
ffffffffc020b54c:	e052                	sd	s4,0(sp)
ffffffffc020b54e:	6785                	lui	a5,0x1
ffffffffc020b550:	04f77863          	bgeu	a4,a5,ffffffffc020b5a0 <sfs_rbuf+0x60>
ffffffffc020b554:	84ba                	mv	s1,a4
ffffffffc020b556:	9732                	add	a4,a4,a2
ffffffffc020b558:	04e7e463          	bltu	a5,a4,ffffffffc020b5a0 <sfs_rbuf+0x60>
ffffffffc020b55c:	8936                	mv	s2,a3
ffffffffc020b55e:	842a                	mv	s0,a0
ffffffffc020b560:	89ae                	mv	s3,a1
ffffffffc020b562:	8a32                	mv	s4,a2
ffffffffc020b564:	218000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b568:	642c                	ld	a1,72(s0)
ffffffffc020b56a:	864a                	mv	a2,s2
ffffffffc020b56c:	8522                	mv	a0,s0
ffffffffc020b56e:	4705                	li	a4,1
ffffffffc020b570:	4681                	li	a3,0
ffffffffc020b572:	eafff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b576:	892a                	mv	s2,a0
ffffffffc020b578:	cd09                	beqz	a0,ffffffffc020b592 <sfs_rbuf+0x52>
ffffffffc020b57a:	8522                	mv	a0,s0
ffffffffc020b57c:	210000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b580:	70a2                	ld	ra,40(sp)
ffffffffc020b582:	7402                	ld	s0,32(sp)
ffffffffc020b584:	64e2                	ld	s1,24(sp)
ffffffffc020b586:	69a2                	ld	s3,8(sp)
ffffffffc020b588:	6a02                	ld	s4,0(sp)
ffffffffc020b58a:	854a                	mv	a0,s2
ffffffffc020b58c:	6942                	ld	s2,16(sp)
ffffffffc020b58e:	6145                	addi	sp,sp,48
ffffffffc020b590:	8082                	ret
ffffffffc020b592:	642c                	ld	a1,72(s0)
ffffffffc020b594:	8652                	mv	a2,s4
ffffffffc020b596:	854e                	mv	a0,s3
ffffffffc020b598:	95a6                	add	a1,a1,s1
ffffffffc020b59a:	786000ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc020b59e:	bff1                	j	ffffffffc020b57a <sfs_rbuf+0x3a>
ffffffffc020b5a0:	00004697          	auipc	a3,0x4
ffffffffc020b5a4:	b7868693          	addi	a3,a3,-1160 # ffffffffc020f118 <etext+0x33e0>
ffffffffc020b5a8:	00001617          	auipc	a2,0x1
ffffffffc020b5ac:	bc860613          	addi	a2,a2,-1080 # ffffffffc020c170 <etext+0x438>
ffffffffc020b5b0:	05500593          	li	a1,85
ffffffffc020b5b4:	00004517          	auipc	a0,0x4
ffffffffc020b5b8:	b4c50513          	addi	a0,a0,-1204 # ffffffffc020f100 <etext+0x33c8>
ffffffffc020b5bc:	e8ff40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b5c0 <sfs_wbuf>:
ffffffffc020b5c0:	7139                	addi	sp,sp,-64
ffffffffc020b5c2:	fc06                	sd	ra,56(sp)
ffffffffc020b5c4:	f822                	sd	s0,48(sp)
ffffffffc020b5c6:	f426                	sd	s1,40(sp)
ffffffffc020b5c8:	f04a                	sd	s2,32(sp)
ffffffffc020b5ca:	ec4e                	sd	s3,24(sp)
ffffffffc020b5cc:	e852                	sd	s4,16(sp)
ffffffffc020b5ce:	e456                	sd	s5,8(sp)
ffffffffc020b5d0:	6785                	lui	a5,0x1
ffffffffc020b5d2:	06f77163          	bgeu	a4,a5,ffffffffc020b634 <sfs_wbuf+0x74>
ffffffffc020b5d6:	893a                	mv	s2,a4
ffffffffc020b5d8:	9732                	add	a4,a4,a2
ffffffffc020b5da:	04e7ed63          	bltu	a5,a4,ffffffffc020b634 <sfs_wbuf+0x74>
ffffffffc020b5de:	89b6                	mv	s3,a3
ffffffffc020b5e0:	84aa                	mv	s1,a0
ffffffffc020b5e2:	8a2e                	mv	s4,a1
ffffffffc020b5e4:	8ab2                	mv	s5,a2
ffffffffc020b5e6:	196000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b5ea:	64ac                	ld	a1,72(s1)
ffffffffc020b5ec:	864e                	mv	a2,s3
ffffffffc020b5ee:	8526                	mv	a0,s1
ffffffffc020b5f0:	4705                	li	a4,1
ffffffffc020b5f2:	4681                	li	a3,0
ffffffffc020b5f4:	e2dff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b5f8:	842a                	mv	s0,a0
ffffffffc020b5fa:	cd11                	beqz	a0,ffffffffc020b616 <sfs_wbuf+0x56>
ffffffffc020b5fc:	8526                	mv	a0,s1
ffffffffc020b5fe:	18e000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b602:	70e2                	ld	ra,56(sp)
ffffffffc020b604:	8522                	mv	a0,s0
ffffffffc020b606:	7442                	ld	s0,48(sp)
ffffffffc020b608:	74a2                	ld	s1,40(sp)
ffffffffc020b60a:	7902                	ld	s2,32(sp)
ffffffffc020b60c:	69e2                	ld	s3,24(sp)
ffffffffc020b60e:	6a42                	ld	s4,16(sp)
ffffffffc020b610:	6aa2                	ld	s5,8(sp)
ffffffffc020b612:	6121                	addi	sp,sp,64
ffffffffc020b614:	8082                	ret
ffffffffc020b616:	64a8                	ld	a0,72(s1)
ffffffffc020b618:	8656                	mv	a2,s5
ffffffffc020b61a:	85d2                	mv	a1,s4
ffffffffc020b61c:	954a                	add	a0,a0,s2
ffffffffc020b61e:	702000ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc020b622:	64ac                	ld	a1,72(s1)
ffffffffc020b624:	4705                	li	a4,1
ffffffffc020b626:	864e                	mv	a2,s3
ffffffffc020b628:	8526                	mv	a0,s1
ffffffffc020b62a:	86ba                	mv	a3,a4
ffffffffc020b62c:	df5ff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b630:	842a                	mv	s0,a0
ffffffffc020b632:	b7e9                	j	ffffffffc020b5fc <sfs_wbuf+0x3c>
ffffffffc020b634:	00004697          	auipc	a3,0x4
ffffffffc020b638:	ae468693          	addi	a3,a3,-1308 # ffffffffc020f118 <etext+0x33e0>
ffffffffc020b63c:	00001617          	auipc	a2,0x1
ffffffffc020b640:	b3460613          	addi	a2,a2,-1228 # ffffffffc020c170 <etext+0x438>
ffffffffc020b644:	06b00593          	li	a1,107
ffffffffc020b648:	00004517          	auipc	a0,0x4
ffffffffc020b64c:	ab850513          	addi	a0,a0,-1352 # ffffffffc020f100 <etext+0x33c8>
ffffffffc020b650:	dfbf40ef          	jal	ffffffffc020044a <__panic>

ffffffffc020b654 <sfs_sync_super>:
ffffffffc020b654:	1101                	addi	sp,sp,-32
ffffffffc020b656:	ec06                	sd	ra,24(sp)
ffffffffc020b658:	e822                	sd	s0,16(sp)
ffffffffc020b65a:	e426                	sd	s1,8(sp)
ffffffffc020b65c:	842a                	mv	s0,a0
ffffffffc020b65e:	11e000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b662:	6428                	ld	a0,72(s0)
ffffffffc020b664:	6605                	lui	a2,0x1
ffffffffc020b666:	4581                	li	a1,0
ffffffffc020b668:	668000ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc020b66c:	6428                	ld	a0,72(s0)
ffffffffc020b66e:	85a2                	mv	a1,s0
ffffffffc020b670:	02c00613          	li	a2,44
ffffffffc020b674:	6ac000ef          	jal	ffffffffc020bd20 <memcpy>
ffffffffc020b678:	642c                	ld	a1,72(s0)
ffffffffc020b67a:	8522                	mv	a0,s0
ffffffffc020b67c:	4701                	li	a4,0
ffffffffc020b67e:	4685                	li	a3,1
ffffffffc020b680:	4601                	li	a2,0
ffffffffc020b682:	d9fff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b686:	84aa                	mv	s1,a0
ffffffffc020b688:	8522                	mv	a0,s0
ffffffffc020b68a:	102000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b68e:	60e2                	ld	ra,24(sp)
ffffffffc020b690:	6442                	ld	s0,16(sp)
ffffffffc020b692:	8526                	mv	a0,s1
ffffffffc020b694:	64a2                	ld	s1,8(sp)
ffffffffc020b696:	6105                	addi	sp,sp,32
ffffffffc020b698:	8082                	ret

ffffffffc020b69a <sfs_sync_freemap>:
ffffffffc020b69a:	7139                	addi	sp,sp,-64
ffffffffc020b69c:	ec4e                	sd	s3,24(sp)
ffffffffc020b69e:	e852                	sd	s4,16(sp)
ffffffffc020b6a0:	00456983          	lwu	s3,4(a0)
ffffffffc020b6a4:	8a2a                	mv	s4,a0
ffffffffc020b6a6:	7d08                	ld	a0,56(a0)
ffffffffc020b6a8:	67a1                	lui	a5,0x8
ffffffffc020b6aa:	17fd                	addi	a5,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020b6ac:	4581                	li	a1,0
ffffffffc020b6ae:	f822                	sd	s0,48(sp)
ffffffffc020b6b0:	fc06                	sd	ra,56(sp)
ffffffffc020b6b2:	f426                	sd	s1,40(sp)
ffffffffc020b6b4:	99be                	add	s3,s3,a5
ffffffffc020b6b6:	956fe0ef          	jal	ffffffffc020980c <bitmap_getdata>
ffffffffc020b6ba:	00f9d993          	srli	s3,s3,0xf
ffffffffc020b6be:	842a                	mv	s0,a0
ffffffffc020b6c0:	8552                	mv	a0,s4
ffffffffc020b6c2:	0ba000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b6c6:	02098b63          	beqz	s3,ffffffffc020b6fc <sfs_sync_freemap+0x62>
ffffffffc020b6ca:	09b2                	slli	s3,s3,0xc
ffffffffc020b6cc:	f04a                	sd	s2,32(sp)
ffffffffc020b6ce:	e456                	sd	s5,8(sp)
ffffffffc020b6d0:	99a2                	add	s3,s3,s0
ffffffffc020b6d2:	4909                	li	s2,2
ffffffffc020b6d4:	6a85                	lui	s5,0x1
ffffffffc020b6d6:	a021                	j	ffffffffc020b6de <sfs_sync_freemap+0x44>
ffffffffc020b6d8:	2905                	addiw	s2,s2,1
ffffffffc020b6da:	01340f63          	beq	s0,s3,ffffffffc020b6f8 <sfs_sync_freemap+0x5e>
ffffffffc020b6de:	4705                	li	a4,1
ffffffffc020b6e0:	85a2                	mv	a1,s0
ffffffffc020b6e2:	86ba                	mv	a3,a4
ffffffffc020b6e4:	864a                	mv	a2,s2
ffffffffc020b6e6:	8552                	mv	a0,s4
ffffffffc020b6e8:	d39ff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b6ec:	84aa                	mv	s1,a0
ffffffffc020b6ee:	9456                	add	s0,s0,s5
ffffffffc020b6f0:	d565                	beqz	a0,ffffffffc020b6d8 <sfs_sync_freemap+0x3e>
ffffffffc020b6f2:	7902                	ld	s2,32(sp)
ffffffffc020b6f4:	6aa2                	ld	s5,8(sp)
ffffffffc020b6f6:	a021                	j	ffffffffc020b6fe <sfs_sync_freemap+0x64>
ffffffffc020b6f8:	7902                	ld	s2,32(sp)
ffffffffc020b6fa:	6aa2                	ld	s5,8(sp)
ffffffffc020b6fc:	4481                	li	s1,0
ffffffffc020b6fe:	8552                	mv	a0,s4
ffffffffc020b700:	08c000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b704:	70e2                	ld	ra,56(sp)
ffffffffc020b706:	7442                	ld	s0,48(sp)
ffffffffc020b708:	69e2                	ld	s3,24(sp)
ffffffffc020b70a:	6a42                	ld	s4,16(sp)
ffffffffc020b70c:	8526                	mv	a0,s1
ffffffffc020b70e:	74a2                	ld	s1,40(sp)
ffffffffc020b710:	6121                	addi	sp,sp,64
ffffffffc020b712:	8082                	ret

ffffffffc020b714 <sfs_clear_block>:
ffffffffc020b714:	7179                	addi	sp,sp,-48
ffffffffc020b716:	f022                	sd	s0,32(sp)
ffffffffc020b718:	e84a                	sd	s2,16(sp)
ffffffffc020b71a:	e44e                	sd	s3,8(sp)
ffffffffc020b71c:	f406                	sd	ra,40(sp)
ffffffffc020b71e:	89b2                	mv	s3,a2
ffffffffc020b720:	ec26                	sd	s1,24(sp)
ffffffffc020b722:	842e                	mv	s0,a1
ffffffffc020b724:	892a                	mv	s2,a0
ffffffffc020b726:	056000ef          	jal	ffffffffc020b77c <lock_sfs_io>
ffffffffc020b72a:	04893503          	ld	a0,72(s2)
ffffffffc020b72e:	6605                	lui	a2,0x1
ffffffffc020b730:	4581                	li	a1,0
ffffffffc020b732:	59e000ef          	jal	ffffffffc020bcd0 <memset>
ffffffffc020b736:	02098d63          	beqz	s3,ffffffffc020b770 <sfs_clear_block+0x5c>
ffffffffc020b73a:	013409bb          	addw	s3,s0,s3
ffffffffc020b73e:	a019                	j	ffffffffc020b744 <sfs_clear_block+0x30>
ffffffffc020b740:	03340863          	beq	s0,s3,ffffffffc020b770 <sfs_clear_block+0x5c>
ffffffffc020b744:	04893583          	ld	a1,72(s2)
ffffffffc020b748:	4705                	li	a4,1
ffffffffc020b74a:	8622                	mv	a2,s0
ffffffffc020b74c:	86ba                	mv	a3,a4
ffffffffc020b74e:	854a                	mv	a0,s2
ffffffffc020b750:	cd1ff0ef          	jal	ffffffffc020b420 <sfs_rwblock_nolock>
ffffffffc020b754:	84aa                	mv	s1,a0
ffffffffc020b756:	2405                	addiw	s0,s0,1
ffffffffc020b758:	d565                	beqz	a0,ffffffffc020b740 <sfs_clear_block+0x2c>
ffffffffc020b75a:	854a                	mv	a0,s2
ffffffffc020b75c:	030000ef          	jal	ffffffffc020b78c <unlock_sfs_io>
ffffffffc020b760:	70a2                	ld	ra,40(sp)
ffffffffc020b762:	7402                	ld	s0,32(sp)
ffffffffc020b764:	6942                	ld	s2,16(sp)
ffffffffc020b766:	69a2                	ld	s3,8(sp)
ffffffffc020b768:	8526                	mv	a0,s1
ffffffffc020b76a:	64e2                	ld	s1,24(sp)
ffffffffc020b76c:	6145                	addi	sp,sp,48
ffffffffc020b76e:	8082                	ret
ffffffffc020b770:	4481                	li	s1,0
ffffffffc020b772:	b7e5                	j	ffffffffc020b75a <sfs_clear_block+0x46>

ffffffffc020b774 <lock_sfs_fs>:
ffffffffc020b774:	05050513          	addi	a0,a0,80
ffffffffc020b778:	ea1f806f          	j	ffffffffc0204618 <down>

ffffffffc020b77c <lock_sfs_io>:
ffffffffc020b77c:	06850513          	addi	a0,a0,104
ffffffffc020b780:	e99f806f          	j	ffffffffc0204618 <down>

ffffffffc020b784 <unlock_sfs_fs>:
ffffffffc020b784:	05050513          	addi	a0,a0,80
ffffffffc020b788:	e8df806f          	j	ffffffffc0204614 <up>

ffffffffc020b78c <unlock_sfs_io>:
ffffffffc020b78c:	06850513          	addi	a0,a0,104
ffffffffc020b790:	e85f806f          	j	ffffffffc0204614 <up>

ffffffffc020b794 <hash32>:
ffffffffc020b794:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b798:	2785                	addiw	a5,a5,1 # ffffffff9e370001 <_binary_bin_sfs_img_size+0xffffffff9e2fad01>
ffffffffc020b79a:	02a787bb          	mulw	a5,a5,a0
ffffffffc020b79e:	02000513          	li	a0,32
ffffffffc020b7a2:	9d0d                	subw	a0,a0,a1
ffffffffc020b7a4:	00a7d53b          	srlw	a0,a5,a0
ffffffffc020b7a8:	8082                	ret

ffffffffc020b7aa <printnum>:
ffffffffc020b7aa:	7139                	addi	sp,sp,-64
ffffffffc020b7ac:	02071893          	slli	a7,a4,0x20
ffffffffc020b7b0:	f822                	sd	s0,48(sp)
ffffffffc020b7b2:	f426                	sd	s1,40(sp)
ffffffffc020b7b4:	f04a                	sd	s2,32(sp)
ffffffffc020b7b6:	ec4e                	sd	s3,24(sp)
ffffffffc020b7b8:	e456                	sd	s5,8(sp)
ffffffffc020b7ba:	0208d893          	srli	a7,a7,0x20
ffffffffc020b7be:	fc06                	sd	ra,56(sp)
ffffffffc020b7c0:	0316fab3          	remu	s5,a3,a7
ffffffffc020b7c4:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b7c8:	84aa                	mv	s1,a0
ffffffffc020b7ca:	89ae                	mv	s3,a1
ffffffffc020b7cc:	8932                	mv	s2,a2
ffffffffc020b7ce:	0516f063          	bgeu	a3,a7,ffffffffc020b80e <printnum+0x64>
ffffffffc020b7d2:	e852                	sd	s4,16(sp)
ffffffffc020b7d4:	4705                	li	a4,1
ffffffffc020b7d6:	8a42                	mv	s4,a6
ffffffffc020b7d8:	00f75863          	bge	a4,a5,ffffffffc020b7e8 <printnum+0x3e>
ffffffffc020b7dc:	864e                	mv	a2,s3
ffffffffc020b7de:	85ca                	mv	a1,s2
ffffffffc020b7e0:	8552                	mv	a0,s4
ffffffffc020b7e2:	347d                	addiw	s0,s0,-1
ffffffffc020b7e4:	9482                	jalr	s1
ffffffffc020b7e6:	f87d                	bnez	s0,ffffffffc020b7dc <printnum+0x32>
ffffffffc020b7e8:	6a42                	ld	s4,16(sp)
ffffffffc020b7ea:	00004797          	auipc	a5,0x4
ffffffffc020b7ee:	97678793          	addi	a5,a5,-1674 # ffffffffc020f160 <etext+0x3428>
ffffffffc020b7f2:	97d6                	add	a5,a5,s5
ffffffffc020b7f4:	7442                	ld	s0,48(sp)
ffffffffc020b7f6:	0007c503          	lbu	a0,0(a5)
ffffffffc020b7fa:	70e2                	ld	ra,56(sp)
ffffffffc020b7fc:	6aa2                	ld	s5,8(sp)
ffffffffc020b7fe:	864e                	mv	a2,s3
ffffffffc020b800:	85ca                	mv	a1,s2
ffffffffc020b802:	69e2                	ld	s3,24(sp)
ffffffffc020b804:	7902                	ld	s2,32(sp)
ffffffffc020b806:	87a6                	mv	a5,s1
ffffffffc020b808:	74a2                	ld	s1,40(sp)
ffffffffc020b80a:	6121                	addi	sp,sp,64
ffffffffc020b80c:	8782                	jr	a5
ffffffffc020b80e:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b812:	87a2                	mv	a5,s0
ffffffffc020b814:	f97ff0ef          	jal	ffffffffc020b7aa <printnum>
ffffffffc020b818:	bfc9                	j	ffffffffc020b7ea <printnum+0x40>

ffffffffc020b81a <sprintputch>:
ffffffffc020b81a:	499c                	lw	a5,16(a1)
ffffffffc020b81c:	6198                	ld	a4,0(a1)
ffffffffc020b81e:	6594                	ld	a3,8(a1)
ffffffffc020b820:	2785                	addiw	a5,a5,1
ffffffffc020b822:	c99c                	sw	a5,16(a1)
ffffffffc020b824:	00d77763          	bgeu	a4,a3,ffffffffc020b832 <sprintputch+0x18>
ffffffffc020b828:	00170793          	addi	a5,a4,1
ffffffffc020b82c:	e19c                	sd	a5,0(a1)
ffffffffc020b82e:	00a70023          	sb	a0,0(a4)
ffffffffc020b832:	8082                	ret

ffffffffc020b834 <vprintfmt>:
ffffffffc020b834:	7119                	addi	sp,sp,-128
ffffffffc020b836:	f4a6                	sd	s1,104(sp)
ffffffffc020b838:	f0ca                	sd	s2,96(sp)
ffffffffc020b83a:	ecce                	sd	s3,88(sp)
ffffffffc020b83c:	e8d2                	sd	s4,80(sp)
ffffffffc020b83e:	e4d6                	sd	s5,72(sp)
ffffffffc020b840:	e0da                	sd	s6,64(sp)
ffffffffc020b842:	fc5e                	sd	s7,56(sp)
ffffffffc020b844:	f466                	sd	s9,40(sp)
ffffffffc020b846:	fc86                	sd	ra,120(sp)
ffffffffc020b848:	f8a2                	sd	s0,112(sp)
ffffffffc020b84a:	f862                	sd	s8,48(sp)
ffffffffc020b84c:	f06a                	sd	s10,32(sp)
ffffffffc020b84e:	ec6e                	sd	s11,24(sp)
ffffffffc020b850:	84aa                	mv	s1,a0
ffffffffc020b852:	8cb6                	mv	s9,a3
ffffffffc020b854:	8aba                	mv	s5,a4
ffffffffc020b856:	89ae                	mv	s3,a1
ffffffffc020b858:	8932                	mv	s2,a2
ffffffffc020b85a:	02500a13          	li	s4,37
ffffffffc020b85e:	05500b93          	li	s7,85
ffffffffc020b862:	00004b17          	auipc	s6,0x4
ffffffffc020b866:	5a6b0b13          	addi	s6,s6,1446 # ffffffffc020fe08 <sfs_node_dirops+0x80>
ffffffffc020b86a:	000cc503          	lbu	a0,0(s9)
ffffffffc020b86e:	001c8413          	addi	s0,s9,1
ffffffffc020b872:	01450b63          	beq	a0,s4,ffffffffc020b888 <vprintfmt+0x54>
ffffffffc020b876:	cd15                	beqz	a0,ffffffffc020b8b2 <vprintfmt+0x7e>
ffffffffc020b878:	864e                	mv	a2,s3
ffffffffc020b87a:	85ca                	mv	a1,s2
ffffffffc020b87c:	9482                	jalr	s1
ffffffffc020b87e:	00044503          	lbu	a0,0(s0)
ffffffffc020b882:	0405                	addi	s0,s0,1
ffffffffc020b884:	ff4519e3          	bne	a0,s4,ffffffffc020b876 <vprintfmt+0x42>
ffffffffc020b888:	5d7d                	li	s10,-1
ffffffffc020b88a:	8dea                	mv	s11,s10
ffffffffc020b88c:	02000813          	li	a6,32
ffffffffc020b890:	4c01                	li	s8,0
ffffffffc020b892:	4581                	li	a1,0
ffffffffc020b894:	00044703          	lbu	a4,0(s0)
ffffffffc020b898:	00140c93          	addi	s9,s0,1
ffffffffc020b89c:	fdd7061b          	addiw	a2,a4,-35
ffffffffc020b8a0:	0ff67613          	zext.b	a2,a2
ffffffffc020b8a4:	02cbe663          	bltu	s7,a2,ffffffffc020b8d0 <vprintfmt+0x9c>
ffffffffc020b8a8:	060a                	slli	a2,a2,0x2
ffffffffc020b8aa:	965a                	add	a2,a2,s6
ffffffffc020b8ac:	421c                	lw	a5,0(a2)
ffffffffc020b8ae:	97da                	add	a5,a5,s6
ffffffffc020b8b0:	8782                	jr	a5
ffffffffc020b8b2:	70e6                	ld	ra,120(sp)
ffffffffc020b8b4:	7446                	ld	s0,112(sp)
ffffffffc020b8b6:	74a6                	ld	s1,104(sp)
ffffffffc020b8b8:	7906                	ld	s2,96(sp)
ffffffffc020b8ba:	69e6                	ld	s3,88(sp)
ffffffffc020b8bc:	6a46                	ld	s4,80(sp)
ffffffffc020b8be:	6aa6                	ld	s5,72(sp)
ffffffffc020b8c0:	6b06                	ld	s6,64(sp)
ffffffffc020b8c2:	7be2                	ld	s7,56(sp)
ffffffffc020b8c4:	7c42                	ld	s8,48(sp)
ffffffffc020b8c6:	7ca2                	ld	s9,40(sp)
ffffffffc020b8c8:	7d02                	ld	s10,32(sp)
ffffffffc020b8ca:	6de2                	ld	s11,24(sp)
ffffffffc020b8cc:	6109                	addi	sp,sp,128
ffffffffc020b8ce:	8082                	ret
ffffffffc020b8d0:	864e                	mv	a2,s3
ffffffffc020b8d2:	85ca                	mv	a1,s2
ffffffffc020b8d4:	02500513          	li	a0,37
ffffffffc020b8d8:	9482                	jalr	s1
ffffffffc020b8da:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b8de:	02500713          	li	a4,37
ffffffffc020b8e2:	8ca2                	mv	s9,s0
ffffffffc020b8e4:	f8e783e3          	beq	a5,a4,ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020b8e8:	ffecc783          	lbu	a5,-2(s9)
ffffffffc020b8ec:	1cfd                	addi	s9,s9,-1
ffffffffc020b8ee:	fee79de3          	bne	a5,a4,ffffffffc020b8e8 <vprintfmt+0xb4>
ffffffffc020b8f2:	bfa5                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020b8f4:	00144683          	lbu	a3,1(s0)
ffffffffc020b8f8:	4525                	li	a0,9
ffffffffc020b8fa:	fd070d1b          	addiw	s10,a4,-48
ffffffffc020b8fe:	fd06879b          	addiw	a5,a3,-48
ffffffffc020b902:	28f56063          	bltu	a0,a5,ffffffffc020bb82 <vprintfmt+0x34e>
ffffffffc020b906:	2681                	sext.w	a3,a3
ffffffffc020b908:	8466                	mv	s0,s9
ffffffffc020b90a:	002d179b          	slliw	a5,s10,0x2
ffffffffc020b90e:	00144703          	lbu	a4,1(s0)
ffffffffc020b912:	01a787bb          	addw	a5,a5,s10
ffffffffc020b916:	0017979b          	slliw	a5,a5,0x1
ffffffffc020b91a:	9fb5                	addw	a5,a5,a3
ffffffffc020b91c:	fd07061b          	addiw	a2,a4,-48
ffffffffc020b920:	0405                	addi	s0,s0,1
ffffffffc020b922:	fd078d1b          	addiw	s10,a5,-48
ffffffffc020b926:	0007069b          	sext.w	a3,a4
ffffffffc020b92a:	fec570e3          	bgeu	a0,a2,ffffffffc020b90a <vprintfmt+0xd6>
ffffffffc020b92e:	f60dd3e3          	bgez	s11,ffffffffc020b894 <vprintfmt+0x60>
ffffffffc020b932:	8dea                	mv	s11,s10
ffffffffc020b934:	5d7d                	li	s10,-1
ffffffffc020b936:	bfb9                	j	ffffffffc020b894 <vprintfmt+0x60>
ffffffffc020b938:	883a                	mv	a6,a4
ffffffffc020b93a:	8466                	mv	s0,s9
ffffffffc020b93c:	bfa1                	j	ffffffffc020b894 <vprintfmt+0x60>
ffffffffc020b93e:	8466                	mv	s0,s9
ffffffffc020b940:	4c05                	li	s8,1
ffffffffc020b942:	bf89                	j	ffffffffc020b894 <vprintfmt+0x60>
ffffffffc020b944:	4785                	li	a5,1
ffffffffc020b946:	008a8613          	addi	a2,s5,8 # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc020b94a:	00b7c463          	blt	a5,a1,ffffffffc020b952 <vprintfmt+0x11e>
ffffffffc020b94e:	1c058363          	beqz	a1,ffffffffc020bb14 <vprintfmt+0x2e0>
ffffffffc020b952:	000ab683          	ld	a3,0(s5)
ffffffffc020b956:	4741                	li	a4,16
ffffffffc020b958:	8ab2                	mv	s5,a2
ffffffffc020b95a:	2801                	sext.w	a6,a6
ffffffffc020b95c:	87ee                	mv	a5,s11
ffffffffc020b95e:	864a                	mv	a2,s2
ffffffffc020b960:	85ce                	mv	a1,s3
ffffffffc020b962:	8526                	mv	a0,s1
ffffffffc020b964:	e47ff0ef          	jal	ffffffffc020b7aa <printnum>
ffffffffc020b968:	b709                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020b96a:	000aa503          	lw	a0,0(s5)
ffffffffc020b96e:	864e                	mv	a2,s3
ffffffffc020b970:	85ca                	mv	a1,s2
ffffffffc020b972:	9482                	jalr	s1
ffffffffc020b974:	0aa1                	addi	s5,s5,8
ffffffffc020b976:	bdd5                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020b978:	4785                	li	a5,1
ffffffffc020b97a:	008a8613          	addi	a2,s5,8
ffffffffc020b97e:	00b7c463          	blt	a5,a1,ffffffffc020b986 <vprintfmt+0x152>
ffffffffc020b982:	18058463          	beqz	a1,ffffffffc020bb0a <vprintfmt+0x2d6>
ffffffffc020b986:	000ab683          	ld	a3,0(s5)
ffffffffc020b98a:	4729                	li	a4,10
ffffffffc020b98c:	8ab2                	mv	s5,a2
ffffffffc020b98e:	b7f1                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020b990:	864e                	mv	a2,s3
ffffffffc020b992:	85ca                	mv	a1,s2
ffffffffc020b994:	03000513          	li	a0,48
ffffffffc020b998:	e042                	sd	a6,0(sp)
ffffffffc020b99a:	9482                	jalr	s1
ffffffffc020b99c:	864e                	mv	a2,s3
ffffffffc020b99e:	85ca                	mv	a1,s2
ffffffffc020b9a0:	07800513          	li	a0,120
ffffffffc020b9a4:	9482                	jalr	s1
ffffffffc020b9a6:	000ab683          	ld	a3,0(s5)
ffffffffc020b9aa:	6802                	ld	a6,0(sp)
ffffffffc020b9ac:	4741                	li	a4,16
ffffffffc020b9ae:	0aa1                	addi	s5,s5,8
ffffffffc020b9b0:	b76d                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020b9b2:	864e                	mv	a2,s3
ffffffffc020b9b4:	85ca                	mv	a1,s2
ffffffffc020b9b6:	02500513          	li	a0,37
ffffffffc020b9ba:	9482                	jalr	s1
ffffffffc020b9bc:	b57d                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020b9be:	000aad03          	lw	s10,0(s5)
ffffffffc020b9c2:	8466                	mv	s0,s9
ffffffffc020b9c4:	0aa1                	addi	s5,s5,8
ffffffffc020b9c6:	b7a5                	j	ffffffffc020b92e <vprintfmt+0xfa>
ffffffffc020b9c8:	4785                	li	a5,1
ffffffffc020b9ca:	008a8613          	addi	a2,s5,8
ffffffffc020b9ce:	00b7c463          	blt	a5,a1,ffffffffc020b9d6 <vprintfmt+0x1a2>
ffffffffc020b9d2:	12058763          	beqz	a1,ffffffffc020bb00 <vprintfmt+0x2cc>
ffffffffc020b9d6:	000ab683          	ld	a3,0(s5)
ffffffffc020b9da:	4721                	li	a4,8
ffffffffc020b9dc:	8ab2                	mv	s5,a2
ffffffffc020b9de:	bfb5                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020b9e0:	87ee                	mv	a5,s11
ffffffffc020b9e2:	000dd363          	bgez	s11,ffffffffc020b9e8 <vprintfmt+0x1b4>
ffffffffc020b9e6:	4781                	li	a5,0
ffffffffc020b9e8:	00078d9b          	sext.w	s11,a5
ffffffffc020b9ec:	8466                	mv	s0,s9
ffffffffc020b9ee:	b55d                	j	ffffffffc020b894 <vprintfmt+0x60>
ffffffffc020b9f0:	0008041b          	sext.w	s0,a6
ffffffffc020b9f4:	fd340793          	addi	a5,s0,-45
ffffffffc020b9f8:	01b02733          	sgtz	a4,s11
ffffffffc020b9fc:	00f037b3          	snez	a5,a5
ffffffffc020ba00:	8ff9                	and	a5,a5,a4
ffffffffc020ba02:	000ab703          	ld	a4,0(s5)
ffffffffc020ba06:	008a8693          	addi	a3,s5,8
ffffffffc020ba0a:	e436                	sd	a3,8(sp)
ffffffffc020ba0c:	12070563          	beqz	a4,ffffffffc020bb36 <vprintfmt+0x302>
ffffffffc020ba10:	12079d63          	bnez	a5,ffffffffc020bb4a <vprintfmt+0x316>
ffffffffc020ba14:	00074783          	lbu	a5,0(a4)
ffffffffc020ba18:	0007851b          	sext.w	a0,a5
ffffffffc020ba1c:	c78d                	beqz	a5,ffffffffc020ba46 <vprintfmt+0x212>
ffffffffc020ba1e:	00170a93          	addi	s5,a4,1
ffffffffc020ba22:	547d                	li	s0,-1
ffffffffc020ba24:	000d4563          	bltz	s10,ffffffffc020ba2e <vprintfmt+0x1fa>
ffffffffc020ba28:	3d7d                	addiw	s10,s10,-1
ffffffffc020ba2a:	008d0e63          	beq	s10,s0,ffffffffc020ba46 <vprintfmt+0x212>
ffffffffc020ba2e:	020c1863          	bnez	s8,ffffffffc020ba5e <vprintfmt+0x22a>
ffffffffc020ba32:	864e                	mv	a2,s3
ffffffffc020ba34:	85ca                	mv	a1,s2
ffffffffc020ba36:	9482                	jalr	s1
ffffffffc020ba38:	000ac783          	lbu	a5,0(s5)
ffffffffc020ba3c:	0a85                	addi	s5,s5,1
ffffffffc020ba3e:	3dfd                	addiw	s11,s11,-1
ffffffffc020ba40:	0007851b          	sext.w	a0,a5
ffffffffc020ba44:	f3e5                	bnez	a5,ffffffffc020ba24 <vprintfmt+0x1f0>
ffffffffc020ba46:	01b05a63          	blez	s11,ffffffffc020ba5a <vprintfmt+0x226>
ffffffffc020ba4a:	864e                	mv	a2,s3
ffffffffc020ba4c:	85ca                	mv	a1,s2
ffffffffc020ba4e:	02000513          	li	a0,32
ffffffffc020ba52:	3dfd                	addiw	s11,s11,-1
ffffffffc020ba54:	9482                	jalr	s1
ffffffffc020ba56:	fe0d9ae3          	bnez	s11,ffffffffc020ba4a <vprintfmt+0x216>
ffffffffc020ba5a:	6aa2                	ld	s5,8(sp)
ffffffffc020ba5c:	b539                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020ba5e:	3781                	addiw	a5,a5,-32
ffffffffc020ba60:	05e00713          	li	a4,94
ffffffffc020ba64:	fcf777e3          	bgeu	a4,a5,ffffffffc020ba32 <vprintfmt+0x1fe>
ffffffffc020ba68:	03f00513          	li	a0,63
ffffffffc020ba6c:	864e                	mv	a2,s3
ffffffffc020ba6e:	85ca                	mv	a1,s2
ffffffffc020ba70:	9482                	jalr	s1
ffffffffc020ba72:	000ac783          	lbu	a5,0(s5)
ffffffffc020ba76:	0a85                	addi	s5,s5,1
ffffffffc020ba78:	3dfd                	addiw	s11,s11,-1
ffffffffc020ba7a:	0007851b          	sext.w	a0,a5
ffffffffc020ba7e:	d7e1                	beqz	a5,ffffffffc020ba46 <vprintfmt+0x212>
ffffffffc020ba80:	fa0d54e3          	bgez	s10,ffffffffc020ba28 <vprintfmt+0x1f4>
ffffffffc020ba84:	bfe9                	j	ffffffffc020ba5e <vprintfmt+0x22a>
ffffffffc020ba86:	000aa783          	lw	a5,0(s5)
ffffffffc020ba8a:	46e1                	li	a3,24
ffffffffc020ba8c:	0aa1                	addi	s5,s5,8
ffffffffc020ba8e:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020ba92:	8fb9                	xor	a5,a5,a4
ffffffffc020ba94:	40e7873b          	subw	a4,a5,a4
ffffffffc020ba98:	02e6c663          	blt	a3,a4,ffffffffc020bac4 <vprintfmt+0x290>
ffffffffc020ba9c:	00004797          	auipc	a5,0x4
ffffffffc020baa0:	4c478793          	addi	a5,a5,1220 # ffffffffc020ff60 <error_string>
ffffffffc020baa4:	00371693          	slli	a3,a4,0x3
ffffffffc020baa8:	97b6                	add	a5,a5,a3
ffffffffc020baaa:	639c                	ld	a5,0(a5)
ffffffffc020baac:	cf81                	beqz	a5,ffffffffc020bac4 <vprintfmt+0x290>
ffffffffc020baae:	873e                	mv	a4,a5
ffffffffc020bab0:	00000697          	auipc	a3,0x0
ffffffffc020bab4:	2b068693          	addi	a3,a3,688 # ffffffffc020bd60 <etext+0x28>
ffffffffc020bab8:	864a                	mv	a2,s2
ffffffffc020baba:	85ce                	mv	a1,s3
ffffffffc020babc:	8526                	mv	a0,s1
ffffffffc020babe:	0f2000ef          	jal	ffffffffc020bbb0 <printfmt>
ffffffffc020bac2:	b365                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020bac4:	00003697          	auipc	a3,0x3
ffffffffc020bac8:	6bc68693          	addi	a3,a3,1724 # ffffffffc020f180 <etext+0x3448>
ffffffffc020bacc:	864a                	mv	a2,s2
ffffffffc020bace:	85ce                	mv	a1,s3
ffffffffc020bad0:	8526                	mv	a0,s1
ffffffffc020bad2:	0de000ef          	jal	ffffffffc020bbb0 <printfmt>
ffffffffc020bad6:	bb51                	j	ffffffffc020b86a <vprintfmt+0x36>
ffffffffc020bad8:	4785                	li	a5,1
ffffffffc020bada:	008a8c13          	addi	s8,s5,8
ffffffffc020bade:	00b7c363          	blt	a5,a1,ffffffffc020bae4 <vprintfmt+0x2b0>
ffffffffc020bae2:	cd81                	beqz	a1,ffffffffc020bafa <vprintfmt+0x2c6>
ffffffffc020bae4:	000ab403          	ld	s0,0(s5)
ffffffffc020bae8:	02044b63          	bltz	s0,ffffffffc020bb1e <vprintfmt+0x2ea>
ffffffffc020baec:	86a2                	mv	a3,s0
ffffffffc020baee:	8ae2                	mv	s5,s8
ffffffffc020baf0:	4729                	li	a4,10
ffffffffc020baf2:	b5a5                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020baf4:	2585                	addiw	a1,a1,1
ffffffffc020baf6:	8466                	mv	s0,s9
ffffffffc020baf8:	bb71                	j	ffffffffc020b894 <vprintfmt+0x60>
ffffffffc020bafa:	000aa403          	lw	s0,0(s5)
ffffffffc020bafe:	b7ed                	j	ffffffffc020bae8 <vprintfmt+0x2b4>
ffffffffc020bb00:	000ae683          	lwu	a3,0(s5)
ffffffffc020bb04:	4721                	li	a4,8
ffffffffc020bb06:	8ab2                	mv	s5,a2
ffffffffc020bb08:	bd89                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020bb0a:	000ae683          	lwu	a3,0(s5)
ffffffffc020bb0e:	4729                	li	a4,10
ffffffffc020bb10:	8ab2                	mv	s5,a2
ffffffffc020bb12:	b5a1                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020bb14:	000ae683          	lwu	a3,0(s5)
ffffffffc020bb18:	4741                	li	a4,16
ffffffffc020bb1a:	8ab2                	mv	s5,a2
ffffffffc020bb1c:	bd3d                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020bb1e:	864e                	mv	a2,s3
ffffffffc020bb20:	85ca                	mv	a1,s2
ffffffffc020bb22:	02d00513          	li	a0,45
ffffffffc020bb26:	e042                	sd	a6,0(sp)
ffffffffc020bb28:	9482                	jalr	s1
ffffffffc020bb2a:	6802                	ld	a6,0(sp)
ffffffffc020bb2c:	408006b3          	neg	a3,s0
ffffffffc020bb30:	8ae2                	mv	s5,s8
ffffffffc020bb32:	4729                	li	a4,10
ffffffffc020bb34:	b51d                	j	ffffffffc020b95a <vprintfmt+0x126>
ffffffffc020bb36:	eba1                	bnez	a5,ffffffffc020bb86 <vprintfmt+0x352>
ffffffffc020bb38:	02800793          	li	a5,40
ffffffffc020bb3c:	853e                	mv	a0,a5
ffffffffc020bb3e:	00003a97          	auipc	s5,0x3
ffffffffc020bb42:	63ba8a93          	addi	s5,s5,1595 # ffffffffc020f179 <etext+0x3441>
ffffffffc020bb46:	547d                	li	s0,-1
ffffffffc020bb48:	bdf1                	j	ffffffffc020ba24 <vprintfmt+0x1f0>
ffffffffc020bb4a:	853a                	mv	a0,a4
ffffffffc020bb4c:	85ea                	mv	a1,s10
ffffffffc020bb4e:	e03a                	sd	a4,0(sp)
ffffffffc020bb50:	0e4000ef          	jal	ffffffffc020bc34 <strnlen>
ffffffffc020bb54:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020bb58:	6702                	ld	a4,0(sp)
ffffffffc020bb5a:	01b05b63          	blez	s11,ffffffffc020bb70 <vprintfmt+0x33c>
ffffffffc020bb5e:	864e                	mv	a2,s3
ffffffffc020bb60:	85ca                	mv	a1,s2
ffffffffc020bb62:	8522                	mv	a0,s0
ffffffffc020bb64:	e03a                	sd	a4,0(sp)
ffffffffc020bb66:	3dfd                	addiw	s11,s11,-1
ffffffffc020bb68:	9482                	jalr	s1
ffffffffc020bb6a:	6702                	ld	a4,0(sp)
ffffffffc020bb6c:	fe0d99e3          	bnez	s11,ffffffffc020bb5e <vprintfmt+0x32a>
ffffffffc020bb70:	00074783          	lbu	a5,0(a4)
ffffffffc020bb74:	0007851b          	sext.w	a0,a5
ffffffffc020bb78:	ee0781e3          	beqz	a5,ffffffffc020ba5a <vprintfmt+0x226>
ffffffffc020bb7c:	00170a93          	addi	s5,a4,1
ffffffffc020bb80:	b54d                	j	ffffffffc020ba22 <vprintfmt+0x1ee>
ffffffffc020bb82:	8466                	mv	s0,s9
ffffffffc020bb84:	b36d                	j	ffffffffc020b92e <vprintfmt+0xfa>
ffffffffc020bb86:	85ea                	mv	a1,s10
ffffffffc020bb88:	00003517          	auipc	a0,0x3
ffffffffc020bb8c:	5f050513          	addi	a0,a0,1520 # ffffffffc020f178 <etext+0x3440>
ffffffffc020bb90:	0a4000ef          	jal	ffffffffc020bc34 <strnlen>
ffffffffc020bb94:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020bb98:	02800793          	li	a5,40
ffffffffc020bb9c:	00003717          	auipc	a4,0x3
ffffffffc020bba0:	5dc70713          	addi	a4,a4,1500 # ffffffffc020f178 <etext+0x3440>
ffffffffc020bba4:	853e                	mv	a0,a5
ffffffffc020bba6:	fbb04ce3          	bgtz	s11,ffffffffc020bb5e <vprintfmt+0x32a>
ffffffffc020bbaa:	00170a93          	addi	s5,a4,1
ffffffffc020bbae:	bd95                	j	ffffffffc020ba22 <vprintfmt+0x1ee>

ffffffffc020bbb0 <printfmt>:
ffffffffc020bbb0:	7139                	addi	sp,sp,-64
ffffffffc020bbb2:	02010313          	addi	t1,sp,32
ffffffffc020bbb6:	f03a                	sd	a4,32(sp)
ffffffffc020bbb8:	871a                	mv	a4,t1
ffffffffc020bbba:	ec06                	sd	ra,24(sp)
ffffffffc020bbbc:	f43e                	sd	a5,40(sp)
ffffffffc020bbbe:	f842                	sd	a6,48(sp)
ffffffffc020bbc0:	fc46                	sd	a7,56(sp)
ffffffffc020bbc2:	e41a                	sd	t1,8(sp)
ffffffffc020bbc4:	c71ff0ef          	jal	ffffffffc020b834 <vprintfmt>
ffffffffc020bbc8:	60e2                	ld	ra,24(sp)
ffffffffc020bbca:	6121                	addi	sp,sp,64
ffffffffc020bbcc:	8082                	ret

ffffffffc020bbce <snprintf>:
ffffffffc020bbce:	711d                	addi	sp,sp,-96
ffffffffc020bbd0:	15fd                	addi	a1,a1,-1
ffffffffc020bbd2:	95aa                	add	a1,a1,a0
ffffffffc020bbd4:	03810313          	addi	t1,sp,56
ffffffffc020bbd8:	f406                	sd	ra,40(sp)
ffffffffc020bbda:	e82e                	sd	a1,16(sp)
ffffffffc020bbdc:	e42a                	sd	a0,8(sp)
ffffffffc020bbde:	fc36                	sd	a3,56(sp)
ffffffffc020bbe0:	e0ba                	sd	a4,64(sp)
ffffffffc020bbe2:	e4be                	sd	a5,72(sp)
ffffffffc020bbe4:	e8c2                	sd	a6,80(sp)
ffffffffc020bbe6:	ecc6                	sd	a7,88(sp)
ffffffffc020bbe8:	cc02                	sw	zero,24(sp)
ffffffffc020bbea:	e01a                	sd	t1,0(sp)
ffffffffc020bbec:	c515                	beqz	a0,ffffffffc020bc18 <snprintf+0x4a>
ffffffffc020bbee:	02a5e563          	bltu	a1,a0,ffffffffc020bc18 <snprintf+0x4a>
ffffffffc020bbf2:	75dd                	lui	a1,0xffff7
ffffffffc020bbf4:	86b2                	mv	a3,a2
ffffffffc020bbf6:	00000517          	auipc	a0,0x0
ffffffffc020bbfa:	c2450513          	addi	a0,a0,-988 # ffffffffc020b81a <sprintputch>
ffffffffc020bbfe:	871a                	mv	a4,t1
ffffffffc020bc00:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd5f1c1>
ffffffffc020bc04:	0030                	addi	a2,sp,8
ffffffffc020bc06:	c2fff0ef          	jal	ffffffffc020b834 <vprintfmt>
ffffffffc020bc0a:	67a2                	ld	a5,8(sp)
ffffffffc020bc0c:	00078023          	sb	zero,0(a5)
ffffffffc020bc10:	4562                	lw	a0,24(sp)
ffffffffc020bc12:	70a2                	ld	ra,40(sp)
ffffffffc020bc14:	6125                	addi	sp,sp,96
ffffffffc020bc16:	8082                	ret
ffffffffc020bc18:	5575                	li	a0,-3
ffffffffc020bc1a:	bfe5                	j	ffffffffc020bc12 <snprintf+0x44>

ffffffffc020bc1c <strlen>:
ffffffffc020bc1c:	00054783          	lbu	a5,0(a0)
ffffffffc020bc20:	cb81                	beqz	a5,ffffffffc020bc30 <strlen+0x14>
ffffffffc020bc22:	4781                	li	a5,0
ffffffffc020bc24:	0785                	addi	a5,a5,1
ffffffffc020bc26:	00f50733          	add	a4,a0,a5
ffffffffc020bc2a:	00074703          	lbu	a4,0(a4)
ffffffffc020bc2e:	fb7d                	bnez	a4,ffffffffc020bc24 <strlen+0x8>
ffffffffc020bc30:	853e                	mv	a0,a5
ffffffffc020bc32:	8082                	ret

ffffffffc020bc34 <strnlen>:
ffffffffc020bc34:	4781                	li	a5,0
ffffffffc020bc36:	e589                	bnez	a1,ffffffffc020bc40 <strnlen+0xc>
ffffffffc020bc38:	a811                	j	ffffffffc020bc4c <strnlen+0x18>
ffffffffc020bc3a:	0785                	addi	a5,a5,1
ffffffffc020bc3c:	00f58863          	beq	a1,a5,ffffffffc020bc4c <strnlen+0x18>
ffffffffc020bc40:	00f50733          	add	a4,a0,a5
ffffffffc020bc44:	00074703          	lbu	a4,0(a4)
ffffffffc020bc48:	fb6d                	bnez	a4,ffffffffc020bc3a <strnlen+0x6>
ffffffffc020bc4a:	85be                	mv	a1,a5
ffffffffc020bc4c:	852e                	mv	a0,a1
ffffffffc020bc4e:	8082                	ret

ffffffffc020bc50 <strcpy>:
ffffffffc020bc50:	87aa                	mv	a5,a0
ffffffffc020bc52:	0005c703          	lbu	a4,0(a1)
ffffffffc020bc56:	0585                	addi	a1,a1,1
ffffffffc020bc58:	0785                	addi	a5,a5,1
ffffffffc020bc5a:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020bc5e:	fb75                	bnez	a4,ffffffffc020bc52 <strcpy+0x2>
ffffffffc020bc60:	8082                	ret

ffffffffc020bc62 <strcmp>:
ffffffffc020bc62:	00054783          	lbu	a5,0(a0)
ffffffffc020bc66:	e791                	bnez	a5,ffffffffc020bc72 <strcmp+0x10>
ffffffffc020bc68:	a01d                	j	ffffffffc020bc8e <strcmp+0x2c>
ffffffffc020bc6a:	00054783          	lbu	a5,0(a0)
ffffffffc020bc6e:	cb99                	beqz	a5,ffffffffc020bc84 <strcmp+0x22>
ffffffffc020bc70:	0585                	addi	a1,a1,1
ffffffffc020bc72:	0005c703          	lbu	a4,0(a1)
ffffffffc020bc76:	0505                	addi	a0,a0,1
ffffffffc020bc78:	fef709e3          	beq	a4,a5,ffffffffc020bc6a <strcmp+0x8>
ffffffffc020bc7c:	0007851b          	sext.w	a0,a5
ffffffffc020bc80:	9d19                	subw	a0,a0,a4
ffffffffc020bc82:	8082                	ret
ffffffffc020bc84:	0015c703          	lbu	a4,1(a1)
ffffffffc020bc88:	4501                	li	a0,0
ffffffffc020bc8a:	9d19                	subw	a0,a0,a4
ffffffffc020bc8c:	8082                	ret
ffffffffc020bc8e:	0005c703          	lbu	a4,0(a1)
ffffffffc020bc92:	4501                	li	a0,0
ffffffffc020bc94:	b7f5                	j	ffffffffc020bc80 <strcmp+0x1e>

ffffffffc020bc96 <strncmp>:
ffffffffc020bc96:	ce01                	beqz	a2,ffffffffc020bcae <strncmp+0x18>
ffffffffc020bc98:	00054783          	lbu	a5,0(a0)
ffffffffc020bc9c:	167d                	addi	a2,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020bc9e:	cb91                	beqz	a5,ffffffffc020bcb2 <strncmp+0x1c>
ffffffffc020bca0:	0005c703          	lbu	a4,0(a1)
ffffffffc020bca4:	00f71763          	bne	a4,a5,ffffffffc020bcb2 <strncmp+0x1c>
ffffffffc020bca8:	0505                	addi	a0,a0,1
ffffffffc020bcaa:	0585                	addi	a1,a1,1
ffffffffc020bcac:	f675                	bnez	a2,ffffffffc020bc98 <strncmp+0x2>
ffffffffc020bcae:	4501                	li	a0,0
ffffffffc020bcb0:	8082                	ret
ffffffffc020bcb2:	00054503          	lbu	a0,0(a0)
ffffffffc020bcb6:	0005c783          	lbu	a5,0(a1)
ffffffffc020bcba:	9d1d                	subw	a0,a0,a5
ffffffffc020bcbc:	8082                	ret

ffffffffc020bcbe <strchr>:
ffffffffc020bcbe:	a021                	j	ffffffffc020bcc6 <strchr+0x8>
ffffffffc020bcc0:	00f58763          	beq	a1,a5,ffffffffc020bcce <strchr+0x10>
ffffffffc020bcc4:	0505                	addi	a0,a0,1
ffffffffc020bcc6:	00054783          	lbu	a5,0(a0)
ffffffffc020bcca:	fbfd                	bnez	a5,ffffffffc020bcc0 <strchr+0x2>
ffffffffc020bccc:	4501                	li	a0,0
ffffffffc020bcce:	8082                	ret

ffffffffc020bcd0 <memset>:
ffffffffc020bcd0:	ca01                	beqz	a2,ffffffffc020bce0 <memset+0x10>
ffffffffc020bcd2:	962a                	add	a2,a2,a0
ffffffffc020bcd4:	87aa                	mv	a5,a0
ffffffffc020bcd6:	0785                	addi	a5,a5,1
ffffffffc020bcd8:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020bcdc:	fef61de3          	bne	a2,a5,ffffffffc020bcd6 <memset+0x6>
ffffffffc020bce0:	8082                	ret

ffffffffc020bce2 <memmove>:
ffffffffc020bce2:	02a5f163          	bgeu	a1,a0,ffffffffc020bd04 <memmove+0x22>
ffffffffc020bce6:	00c587b3          	add	a5,a1,a2
ffffffffc020bcea:	00f57d63          	bgeu	a0,a5,ffffffffc020bd04 <memmove+0x22>
ffffffffc020bcee:	c61d                	beqz	a2,ffffffffc020bd1c <memmove+0x3a>
ffffffffc020bcf0:	962a                	add	a2,a2,a0
ffffffffc020bcf2:	fff7c703          	lbu	a4,-1(a5)
ffffffffc020bcf6:	17fd                	addi	a5,a5,-1
ffffffffc020bcf8:	167d                	addi	a2,a2,-1
ffffffffc020bcfa:	00e60023          	sb	a4,0(a2)
ffffffffc020bcfe:	fef59ae3          	bne	a1,a5,ffffffffc020bcf2 <memmove+0x10>
ffffffffc020bd02:	8082                	ret
ffffffffc020bd04:	00c586b3          	add	a3,a1,a2
ffffffffc020bd08:	87aa                	mv	a5,a0
ffffffffc020bd0a:	ca11                	beqz	a2,ffffffffc020bd1e <memmove+0x3c>
ffffffffc020bd0c:	0005c703          	lbu	a4,0(a1)
ffffffffc020bd10:	0585                	addi	a1,a1,1
ffffffffc020bd12:	0785                	addi	a5,a5,1
ffffffffc020bd14:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020bd18:	feb69ae3          	bne	a3,a1,ffffffffc020bd0c <memmove+0x2a>
ffffffffc020bd1c:	8082                	ret
ffffffffc020bd1e:	8082                	ret

ffffffffc020bd20 <memcpy>:
ffffffffc020bd20:	ca19                	beqz	a2,ffffffffc020bd36 <memcpy+0x16>
ffffffffc020bd22:	962e                	add	a2,a2,a1
ffffffffc020bd24:	87aa                	mv	a5,a0
ffffffffc020bd26:	0005c703          	lbu	a4,0(a1)
ffffffffc020bd2a:	0585                	addi	a1,a1,1
ffffffffc020bd2c:	0785                	addi	a5,a5,1
ffffffffc020bd2e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020bd32:	feb61ae3          	bne	a2,a1,ffffffffc020bd26 <memcpy+0x6>
ffffffffc020bd36:	8082                	ret
