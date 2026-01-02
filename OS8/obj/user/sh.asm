
obj/__user_sh.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	ac09                	j	800236 <sys_open>

0000000000800026 <close>:
  800026:	ac29                	j	800240 <sys_close>

0000000000800028 <read>:
  800028:	a405                	j	800248 <sys_read>

000000000080002a <write>:
  80002a:	a42d                	j	800254 <sys_write>

000000000080002c <dup2>:
  80002c:	ac15                	j	800260 <sys_dup>

000000000080002e <_start>:
  80002e:	2ce000ef          	jal	8002fc <umain>
  800032:	a001                	j	800032 <_start+0x4>

0000000000800034 <__panic>:
  800034:	715d                	addi	sp,sp,-80
  800036:	02810313          	addi	t1,sp,40
  80003a:	e822                	sd	s0,16(sp)
  80003c:	8432                	mv	s0,a2
  80003e:	862e                	mv	a2,a1
  800040:	85aa                	mv	a1,a0
  800042:	00001517          	auipc	a0,0x1
  800046:	d3650513          	addi	a0,a0,-714 # 800d78 <main+0xc8>
  80004a:	ec06                	sd	ra,24(sp)
  80004c:	f436                	sd	a3,40(sp)
  80004e:	f83a                	sd	a4,48(sp)
  800050:	fc3e                	sd	a5,56(sp)
  800052:	e0c2                	sd	a6,64(sp)
  800054:	e4c6                	sd	a7,72(sp)
  800056:	e41a                	sd	t1,8(sp)
  800058:	0c6000ef          	jal	80011e <cprintf>
  80005c:	65a2                	ld	a1,8(sp)
  80005e:	8522                	mv	a0,s0
  800060:	098000ef          	jal	8000f8 <vcprintf>
  800064:	00001517          	auipc	a0,0x1
  800068:	d3450513          	addi	a0,a0,-716 # 800d98 <main+0xe8>
  80006c:	0b2000ef          	jal	80011e <cprintf>
  800070:	5559                	li	a0,-10
  800072:	1f8000ef          	jal	80026a <exit>

0000000000800076 <__warn>:
  800076:	715d                	addi	sp,sp,-80
  800078:	e822                	sd	s0,16(sp)
  80007a:	02810313          	addi	t1,sp,40
  80007e:	8432                	mv	s0,a2
  800080:	862e                	mv	a2,a1
  800082:	85aa                	mv	a1,a0
  800084:	00001517          	auipc	a0,0x1
  800088:	d1c50513          	addi	a0,a0,-740 # 800da0 <main+0xf0>
  80008c:	ec06                	sd	ra,24(sp)
  80008e:	f436                	sd	a3,40(sp)
  800090:	f83a                	sd	a4,48(sp)
  800092:	fc3e                	sd	a5,56(sp)
  800094:	e0c2                	sd	a6,64(sp)
  800096:	e4c6                	sd	a7,72(sp)
  800098:	e41a                	sd	t1,8(sp)
  80009a:	084000ef          	jal	80011e <cprintf>
  80009e:	65a2                	ld	a1,8(sp)
  8000a0:	8522                	mv	a0,s0
  8000a2:	056000ef          	jal	8000f8 <vcprintf>
  8000a6:	00001517          	auipc	a0,0x1
  8000aa:	cf250513          	addi	a0,a0,-782 # 800d98 <main+0xe8>
  8000ae:	070000ef          	jal	80011e <cprintf>
  8000b2:	60e2                	ld	ra,24(sp)
  8000b4:	6442                	ld	s0,16(sp)
  8000b6:	6161                	addi	sp,sp,80
  8000b8:	8082                	ret

00000000008000ba <cputch>:
  8000ba:	1101                	addi	sp,sp,-32
  8000bc:	ec06                	sd	ra,24(sp)
  8000be:	e42e                	sd	a1,8(sp)
  8000c0:	166000ef          	jal	800226 <sys_putc>
  8000c4:	65a2                	ld	a1,8(sp)
  8000c6:	60e2                	ld	ra,24(sp)
  8000c8:	419c                	lw	a5,0(a1)
  8000ca:	2785                	addiw	a5,a5,1
  8000cc:	c19c                	sw	a5,0(a1)
  8000ce:	6105                	addi	sp,sp,32
  8000d0:	8082                	ret

00000000008000d2 <fputch>:
  8000d2:	1101                	addi	sp,sp,-32
  8000d4:	e822                	sd	s0,16(sp)
  8000d6:	00a107a3          	sb	a0,15(sp)
  8000da:	842e                	mv	s0,a1
  8000dc:	8532                	mv	a0,a2
  8000de:	00f10593          	addi	a1,sp,15
  8000e2:	4605                	li	a2,1
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	f45ff0ef          	jal	80002a <write>
  8000ea:	401c                	lw	a5,0(s0)
  8000ec:	60e2                	ld	ra,24(sp)
  8000ee:	2785                	addiw	a5,a5,1
  8000f0:	c01c                	sw	a5,0(s0)
  8000f2:	6442                	ld	s0,16(sp)
  8000f4:	6105                	addi	sp,sp,32
  8000f6:	8082                	ret

00000000008000f8 <vcprintf>:
  8000f8:	1101                	addi	sp,sp,-32
  8000fa:	872e                	mv	a4,a1
  8000fc:	75dd                	lui	a1,0xffff7
  8000fe:	86aa                	mv	a3,a0
  800100:	0070                	addi	a2,sp,12
  800102:	00000517          	auipc	a0,0x0
  800106:	fb850513          	addi	a0,a0,-72 # 8000ba <cputch>
  80010a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  80010e:	ec06                	sd	ra,24(sp)
  800110:	c602                	sw	zero,12(sp)
  800112:	2e8000ef          	jal	8003fa <vprintfmt>
  800116:	60e2                	ld	ra,24(sp)
  800118:	4532                	lw	a0,12(sp)
  80011a:	6105                	addi	sp,sp,32
  80011c:	8082                	ret

000000000080011e <cprintf>:
  80011e:	711d                	addi	sp,sp,-96
  800120:	02810313          	addi	t1,sp,40
  800124:	f42e                	sd	a1,40(sp)
  800126:	75dd                	lui	a1,0xffff7
  800128:	f832                	sd	a2,48(sp)
  80012a:	fc36                	sd	a3,56(sp)
  80012c:	e0ba                	sd	a4,64(sp)
  80012e:	86aa                	mv	a3,a0
  800130:	0050                	addi	a2,sp,4
  800132:	00000517          	auipc	a0,0x0
  800136:	f8850513          	addi	a0,a0,-120 # 8000ba <cputch>
  80013a:	871a                	mv	a4,t1
  80013c:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  800140:	ec06                	sd	ra,24(sp)
  800142:	e4be                	sd	a5,72(sp)
  800144:	e8c2                	sd	a6,80(sp)
  800146:	ecc6                	sd	a7,88(sp)
  800148:	c202                	sw	zero,4(sp)
  80014a:	e41a                	sd	t1,8(sp)
  80014c:	2ae000ef          	jal	8003fa <vprintfmt>
  800150:	60e2                	ld	ra,24(sp)
  800152:	4512                	lw	a0,4(sp)
  800154:	6125                	addi	sp,sp,96
  800156:	8082                	ret

0000000000800158 <cputs>:
  800158:	1101                	addi	sp,sp,-32
  80015a:	e822                	sd	s0,16(sp)
  80015c:	ec06                	sd	ra,24(sp)
  80015e:	842a                	mv	s0,a0
  800160:	00054503          	lbu	a0,0(a0)
  800164:	c51d                	beqz	a0,800192 <cputs+0x3a>
  800166:	e426                	sd	s1,8(sp)
  800168:	0405                	addi	s0,s0,1
  80016a:	4481                	li	s1,0
  80016c:	0ba000ef          	jal	800226 <sys_putc>
  800170:	00044503          	lbu	a0,0(s0)
  800174:	0405                	addi	s0,s0,1
  800176:	87a6                	mv	a5,s1
  800178:	2485                	addiw	s1,s1,1
  80017a:	f96d                	bnez	a0,80016c <cputs+0x14>
  80017c:	4529                	li	a0,10
  80017e:	0027841b          	addiw	s0,a5,2
  800182:	64a2                	ld	s1,8(sp)
  800184:	0a2000ef          	jal	800226 <sys_putc>
  800188:	60e2                	ld	ra,24(sp)
  80018a:	8522                	mv	a0,s0
  80018c:	6442                	ld	s0,16(sp)
  80018e:	6105                	addi	sp,sp,32
  800190:	8082                	ret
  800192:	4529                	li	a0,10
  800194:	092000ef          	jal	800226 <sys_putc>
  800198:	4405                	li	s0,1
  80019a:	60e2                	ld	ra,24(sp)
  80019c:	8522                	mv	a0,s0
  80019e:	6442                	ld	s0,16(sp)
  8001a0:	6105                	addi	sp,sp,32
  8001a2:	8082                	ret

00000000008001a4 <fprintf>:
  8001a4:	715d                	addi	sp,sp,-80
  8001a6:	02010313          	addi	t1,sp,32
  8001aa:	8e2e                	mv	t3,a1
  8001ac:	f032                	sd	a2,32(sp)
  8001ae:	f436                	sd	a3,40(sp)
  8001b0:	f83a                	sd	a4,48(sp)
  8001b2:	85aa                	mv	a1,a0
  8001b4:	0050                	addi	a2,sp,4
  8001b6:	00000517          	auipc	a0,0x0
  8001ba:	f1c50513          	addi	a0,a0,-228 # 8000d2 <fputch>
  8001be:	86f2                	mv	a3,t3
  8001c0:	871a                	mv	a4,t1
  8001c2:	ec06                	sd	ra,24(sp)
  8001c4:	fc3e                	sd	a5,56(sp)
  8001c6:	e0c2                	sd	a6,64(sp)
  8001c8:	e4c6                	sd	a7,72(sp)
  8001ca:	c202                	sw	zero,4(sp)
  8001cc:	e41a                	sd	t1,8(sp)
  8001ce:	22c000ef          	jal	8003fa <vprintfmt>
  8001d2:	60e2                	ld	ra,24(sp)
  8001d4:	4512                	lw	a0,4(sp)
  8001d6:	6161                	addi	sp,sp,80
  8001d8:	8082                	ret

00000000008001da <syscall>:
  8001da:	7175                	addi	sp,sp,-144
  8001dc:	08010313          	addi	t1,sp,128
  8001e0:	e42a                	sd	a0,8(sp)
  8001e2:	ecae                	sd	a1,88(sp)
  8001e4:	f42e                	sd	a1,40(sp)
  8001e6:	f0b2                	sd	a2,96(sp)
  8001e8:	f832                	sd	a2,48(sp)
  8001ea:	f4b6                	sd	a3,104(sp)
  8001ec:	fc36                	sd	a3,56(sp)
  8001ee:	f8ba                	sd	a4,112(sp)
  8001f0:	e0ba                	sd	a4,64(sp)
  8001f2:	fcbe                	sd	a5,120(sp)
  8001f4:	e4be                	sd	a5,72(sp)
  8001f6:	e142                	sd	a6,128(sp)
  8001f8:	e546                	sd	a7,136(sp)
  8001fa:	f01a                	sd	t1,32(sp)
  8001fc:	4522                	lw	a0,8(sp)
  8001fe:	55a2                	lw	a1,40(sp)
  800200:	5642                	lw	a2,48(sp)
  800202:	56e2                	lw	a3,56(sp)
  800204:	4706                	lw	a4,64(sp)
  800206:	47a6                	lw	a5,72(sp)
  800208:	00000073          	ecall
  80020c:	ce2a                	sw	a0,28(sp)
  80020e:	4572                	lw	a0,28(sp)
  800210:	6149                	addi	sp,sp,144
  800212:	8082                	ret

0000000000800214 <sys_exit>:
  800214:	85aa                	mv	a1,a0
  800216:	4505                	li	a0,1
  800218:	b7c9                	j	8001da <syscall>

000000000080021a <sys_fork>:
  80021a:	4509                	li	a0,2
  80021c:	bf7d                	j	8001da <syscall>

000000000080021e <sys_wait>:
  80021e:	862e                	mv	a2,a1
  800220:	85aa                	mv	a1,a0
  800222:	450d                	li	a0,3
  800224:	bf5d                	j	8001da <syscall>

0000000000800226 <sys_putc>:
  800226:	85aa                	mv	a1,a0
  800228:	4579                	li	a0,30
  80022a:	bf45                	j	8001da <syscall>

000000000080022c <sys_exec>:
  80022c:	86b2                	mv	a3,a2
  80022e:	862e                	mv	a2,a1
  800230:	85aa                	mv	a1,a0
  800232:	4511                	li	a0,4
  800234:	b75d                	j	8001da <syscall>

0000000000800236 <sys_open>:
  800236:	862e                	mv	a2,a1
  800238:	85aa                	mv	a1,a0
  80023a:	06400513          	li	a0,100
  80023e:	bf71                	j	8001da <syscall>

0000000000800240 <sys_close>:
  800240:	85aa                	mv	a1,a0
  800242:	06500513          	li	a0,101
  800246:	bf51                	j	8001da <syscall>

0000000000800248 <sys_read>:
  800248:	86b2                	mv	a3,a2
  80024a:	862e                	mv	a2,a1
  80024c:	85aa                	mv	a1,a0
  80024e:	06600513          	li	a0,102
  800252:	b761                	j	8001da <syscall>

0000000000800254 <sys_write>:
  800254:	86b2                	mv	a3,a2
  800256:	862e                	mv	a2,a1
  800258:	85aa                	mv	a1,a0
  80025a:	06700513          	li	a0,103
  80025e:	bfb5                	j	8001da <syscall>

0000000000800260 <sys_dup>:
  800260:	862e                	mv	a2,a1
  800262:	85aa                	mv	a1,a0
  800264:	08200513          	li	a0,130
  800268:	bf8d                	j	8001da <syscall>

000000000080026a <exit>:
  80026a:	1141                	addi	sp,sp,-16
  80026c:	e406                	sd	ra,8(sp)
  80026e:	fa7ff0ef          	jal	800214 <sys_exit>
  800272:	00001517          	auipc	a0,0x1
  800276:	b4e50513          	addi	a0,a0,-1202 # 800dc0 <main+0x110>
  80027a:	ea5ff0ef          	jal	80011e <cprintf>
  80027e:	a001                	j	80027e <exit+0x14>

0000000000800280 <fork>:
  800280:	bf69                	j	80021a <sys_fork>

0000000000800282 <waitpid>:
  800282:	1101                	addi	sp,sp,-32
  800284:	e822                	sd	s0,16(sp)
  800286:	842e                	mv	s0,a1
  800288:	002c                	addi	a1,sp,8
  80028a:	ec06                	sd	ra,24(sp)
  80028c:	f93ff0ef          	jal	80021e <sys_wait>
  800290:	c019                	beqz	s0,800296 <waitpid+0x14>
  800292:	67a2                	ld	a5,8(sp)
  800294:	c01c                	sw	a5,0(s0)
  800296:	60e2                	ld	ra,24(sp)
  800298:	6442                	ld	s0,16(sp)
  80029a:	6105                	addi	sp,sp,32
  80029c:	8082                	ret

000000000080029e <__exec>:
  80029e:	619c                	ld	a5,0(a1)
  8002a0:	862e                	mv	a2,a1
  8002a2:	cb91                	beqz	a5,8002b6 <__exec+0x18>
  8002a4:	00858793          	addi	a5,a1,8
  8002a8:	4701                	li	a4,0
  8002aa:	6394                	ld	a3,0(a5)
  8002ac:	07a1                	addi	a5,a5,8
  8002ae:	2705                	addiw	a4,a4,1
  8002b0:	feed                	bnez	a3,8002aa <__exec+0xc>
  8002b2:	85ba                	mv	a1,a4
  8002b4:	bfa5                	j	80022c <sys_exec>
  8002b6:	4581                	li	a1,0
  8002b8:	bf95                	j	80022c <sys_exec>

00000000008002ba <initfd>:
  8002ba:	87ae                	mv	a5,a1
  8002bc:	1101                	addi	sp,sp,-32
  8002be:	e822                	sd	s0,16(sp)
  8002c0:	85b2                	mv	a1,a2
  8002c2:	842a                	mv	s0,a0
  8002c4:	853e                	mv	a0,a5
  8002c6:	ec06                	sd	ra,24(sp)
  8002c8:	d59ff0ef          	jal	800020 <open>
  8002cc:	87aa                	mv	a5,a0
  8002ce:	00054463          	bltz	a0,8002d6 <initfd+0x1c>
  8002d2:	00851763          	bne	a0,s0,8002e0 <initfd+0x26>
  8002d6:	60e2                	ld	ra,24(sp)
  8002d8:	6442                	ld	s0,16(sp)
  8002da:	853e                	mv	a0,a5
  8002dc:	6105                	addi	sp,sp,32
  8002de:	8082                	ret
  8002e0:	e42a                	sd	a0,8(sp)
  8002e2:	8522                	mv	a0,s0
  8002e4:	d43ff0ef          	jal	800026 <close>
  8002e8:	6522                	ld	a0,8(sp)
  8002ea:	85a2                	mv	a1,s0
  8002ec:	d41ff0ef          	jal	80002c <dup2>
  8002f0:	842a                	mv	s0,a0
  8002f2:	6522                	ld	a0,8(sp)
  8002f4:	d33ff0ef          	jal	800026 <close>
  8002f8:	87a2                	mv	a5,s0
  8002fa:	bff1                	j	8002d6 <initfd+0x1c>

00000000008002fc <umain>:
  8002fc:	1101                	addi	sp,sp,-32
  8002fe:	e822                	sd	s0,16(sp)
  800300:	e426                	sd	s1,8(sp)
  800302:	842a                	mv	s0,a0
  800304:	84ae                	mv	s1,a1
  800306:	4601                	li	a2,0
  800308:	00001597          	auipc	a1,0x1
  80030c:	ad058593          	addi	a1,a1,-1328 # 800dd8 <main+0x128>
  800310:	4501                	li	a0,0
  800312:	ec06                	sd	ra,24(sp)
  800314:	fa7ff0ef          	jal	8002ba <initfd>
  800318:	02054263          	bltz	a0,80033c <umain+0x40>
  80031c:	4605                	li	a2,1
  80031e:	8532                	mv	a0,a2
  800320:	00001597          	auipc	a1,0x1
  800324:	af858593          	addi	a1,a1,-1288 # 800e18 <main+0x168>
  800328:	f93ff0ef          	jal	8002ba <initfd>
  80032c:	02054563          	bltz	a0,800356 <umain+0x5a>
  800330:	85a6                	mv	a1,s1
  800332:	8522                	mv	a0,s0
  800334:	17d000ef          	jal	800cb0 <main>
  800338:	f33ff0ef          	jal	80026a <exit>
  80033c:	86aa                	mv	a3,a0
  80033e:	00001617          	auipc	a2,0x1
  800342:	aa260613          	addi	a2,a2,-1374 # 800de0 <main+0x130>
  800346:	45e9                	li	a1,26
  800348:	00001517          	auipc	a0,0x1
  80034c:	ab850513          	addi	a0,a0,-1352 # 800e00 <main+0x150>
  800350:	d27ff0ef          	jal	800076 <__warn>
  800354:	b7e1                	j	80031c <umain+0x20>
  800356:	86aa                	mv	a3,a0
  800358:	00001617          	auipc	a2,0x1
  80035c:	ac860613          	addi	a2,a2,-1336 # 800e20 <main+0x170>
  800360:	45f5                	li	a1,29
  800362:	00001517          	auipc	a0,0x1
  800366:	a9e50513          	addi	a0,a0,-1378 # 800e00 <main+0x150>
  80036a:	d0dff0ef          	jal	800076 <__warn>
  80036e:	b7c9                	j	800330 <umain+0x34>

0000000000800370 <printnum>:
  800370:	7139                	addi	sp,sp,-64
  800372:	02071893          	slli	a7,a4,0x20
  800376:	f822                	sd	s0,48(sp)
  800378:	f426                	sd	s1,40(sp)
  80037a:	f04a                	sd	s2,32(sp)
  80037c:	ec4e                	sd	s3,24(sp)
  80037e:	e456                	sd	s5,8(sp)
  800380:	0208d893          	srli	a7,a7,0x20
  800384:	fc06                	sd	ra,56(sp)
  800386:	0316fab3          	remu	s5,a3,a7
  80038a:	fff7841b          	addiw	s0,a5,-1
  80038e:	84aa                	mv	s1,a0
  800390:	89ae                	mv	s3,a1
  800392:	8932                	mv	s2,a2
  800394:	0516f063          	bgeu	a3,a7,8003d4 <printnum+0x64>
  800398:	e852                	sd	s4,16(sp)
  80039a:	4705                	li	a4,1
  80039c:	8a42                	mv	s4,a6
  80039e:	00f75863          	bge	a4,a5,8003ae <printnum+0x3e>
  8003a2:	864e                	mv	a2,s3
  8003a4:	85ca                	mv	a1,s2
  8003a6:	8552                	mv	a0,s4
  8003a8:	347d                	addiw	s0,s0,-1
  8003aa:	9482                	jalr	s1
  8003ac:	f87d                	bnez	s0,8003a2 <printnum+0x32>
  8003ae:	6a42                	ld	s4,16(sp)
  8003b0:	00001797          	auipc	a5,0x1
  8003b4:	a9078793          	addi	a5,a5,-1392 # 800e40 <main+0x190>
  8003b8:	97d6                	add	a5,a5,s5
  8003ba:	7442                	ld	s0,48(sp)
  8003bc:	0007c503          	lbu	a0,0(a5)
  8003c0:	70e2                	ld	ra,56(sp)
  8003c2:	6aa2                	ld	s5,8(sp)
  8003c4:	864e                	mv	a2,s3
  8003c6:	85ca                	mv	a1,s2
  8003c8:	69e2                	ld	s3,24(sp)
  8003ca:	7902                	ld	s2,32(sp)
  8003cc:	87a6                	mv	a5,s1
  8003ce:	74a2                	ld	s1,40(sp)
  8003d0:	6121                	addi	sp,sp,64
  8003d2:	8782                	jr	a5
  8003d4:	0316d6b3          	divu	a3,a3,a7
  8003d8:	87a2                	mv	a5,s0
  8003da:	f97ff0ef          	jal	800370 <printnum>
  8003de:	bfc9                	j	8003b0 <printnum+0x40>

00000000008003e0 <sprintputch>:
  8003e0:	499c                	lw	a5,16(a1)
  8003e2:	6198                	ld	a4,0(a1)
  8003e4:	6594                	ld	a3,8(a1)
  8003e6:	2785                	addiw	a5,a5,1
  8003e8:	c99c                	sw	a5,16(a1)
  8003ea:	00d77763          	bgeu	a4,a3,8003f8 <sprintputch+0x18>
  8003ee:	00170793          	addi	a5,a4,1
  8003f2:	e19c                	sd	a5,0(a1)
  8003f4:	00a70023          	sb	a0,0(a4)
  8003f8:	8082                	ret

00000000008003fa <vprintfmt>:
  8003fa:	7119                	addi	sp,sp,-128
  8003fc:	f4a6                	sd	s1,104(sp)
  8003fe:	f0ca                	sd	s2,96(sp)
  800400:	ecce                	sd	s3,88(sp)
  800402:	e8d2                	sd	s4,80(sp)
  800404:	e4d6                	sd	s5,72(sp)
  800406:	e0da                	sd	s6,64(sp)
  800408:	fc5e                	sd	s7,56(sp)
  80040a:	f466                	sd	s9,40(sp)
  80040c:	fc86                	sd	ra,120(sp)
  80040e:	f8a2                	sd	s0,112(sp)
  800410:	f862                	sd	s8,48(sp)
  800412:	f06a                	sd	s10,32(sp)
  800414:	ec6e                	sd	s11,24(sp)
  800416:	84aa                	mv	s1,a0
  800418:	8cb6                	mv	s9,a3
  80041a:	8aba                	mv	s5,a4
  80041c:	89ae                	mv	s3,a1
  80041e:	8932                	mv	s2,a2
  800420:	02500a13          	li	s4,37
  800424:	05500b93          	li	s7,85
  800428:	00001b17          	auipc	s6,0x1
  80042c:	d8cb0b13          	addi	s6,s6,-628 # 8011b4 <main+0x504>
  800430:	000cc503          	lbu	a0,0(s9)
  800434:	001c8413          	addi	s0,s9,1
  800438:	01450b63          	beq	a0,s4,80044e <vprintfmt+0x54>
  80043c:	cd15                	beqz	a0,800478 <vprintfmt+0x7e>
  80043e:	864e                	mv	a2,s3
  800440:	85ca                	mv	a1,s2
  800442:	9482                	jalr	s1
  800444:	00044503          	lbu	a0,0(s0)
  800448:	0405                	addi	s0,s0,1
  80044a:	ff4519e3          	bne	a0,s4,80043c <vprintfmt+0x42>
  80044e:	5d7d                	li	s10,-1
  800450:	8dea                	mv	s11,s10
  800452:	02000813          	li	a6,32
  800456:	4c01                	li	s8,0
  800458:	4581                	li	a1,0
  80045a:	00044703          	lbu	a4,0(s0)
  80045e:	00140c93          	addi	s9,s0,1
  800462:	fdd7061b          	addiw	a2,a4,-35
  800466:	0ff67613          	zext.b	a2,a2
  80046a:	02cbe663          	bltu	s7,a2,800496 <vprintfmt+0x9c>
  80046e:	060a                	slli	a2,a2,0x2
  800470:	965a                	add	a2,a2,s6
  800472:	421c                	lw	a5,0(a2)
  800474:	97da                	add	a5,a5,s6
  800476:	8782                	jr	a5
  800478:	70e6                	ld	ra,120(sp)
  80047a:	7446                	ld	s0,112(sp)
  80047c:	74a6                	ld	s1,104(sp)
  80047e:	7906                	ld	s2,96(sp)
  800480:	69e6                	ld	s3,88(sp)
  800482:	6a46                	ld	s4,80(sp)
  800484:	6aa6                	ld	s5,72(sp)
  800486:	6b06                	ld	s6,64(sp)
  800488:	7be2                	ld	s7,56(sp)
  80048a:	7c42                	ld	s8,48(sp)
  80048c:	7ca2                	ld	s9,40(sp)
  80048e:	7d02                	ld	s10,32(sp)
  800490:	6de2                	ld	s11,24(sp)
  800492:	6109                	addi	sp,sp,128
  800494:	8082                	ret
  800496:	864e                	mv	a2,s3
  800498:	85ca                	mv	a1,s2
  80049a:	02500513          	li	a0,37
  80049e:	9482                	jalr	s1
  8004a0:	fff44783          	lbu	a5,-1(s0)
  8004a4:	02500713          	li	a4,37
  8004a8:	8ca2                	mv	s9,s0
  8004aa:	f8e783e3          	beq	a5,a4,800430 <vprintfmt+0x36>
  8004ae:	ffecc783          	lbu	a5,-2(s9)
  8004b2:	1cfd                	addi	s9,s9,-1
  8004b4:	fee79de3          	bne	a5,a4,8004ae <vprintfmt+0xb4>
  8004b8:	bfa5                	j	800430 <vprintfmt+0x36>
  8004ba:	00144683          	lbu	a3,1(s0)
  8004be:	4525                	li	a0,9
  8004c0:	fd070d1b          	addiw	s10,a4,-48
  8004c4:	fd06879b          	addiw	a5,a3,-48
  8004c8:	28f56063          	bltu	a0,a5,800748 <vprintfmt+0x34e>
  8004cc:	2681                	sext.w	a3,a3
  8004ce:	8466                	mv	s0,s9
  8004d0:	002d179b          	slliw	a5,s10,0x2
  8004d4:	00144703          	lbu	a4,1(s0)
  8004d8:	01a787bb          	addw	a5,a5,s10
  8004dc:	0017979b          	slliw	a5,a5,0x1
  8004e0:	9fb5                	addw	a5,a5,a3
  8004e2:	fd07061b          	addiw	a2,a4,-48
  8004e6:	0405                	addi	s0,s0,1
  8004e8:	fd078d1b          	addiw	s10,a5,-48
  8004ec:	0007069b          	sext.w	a3,a4
  8004f0:	fec570e3          	bgeu	a0,a2,8004d0 <vprintfmt+0xd6>
  8004f4:	f60dd3e3          	bgez	s11,80045a <vprintfmt+0x60>
  8004f8:	8dea                	mv	s11,s10
  8004fa:	5d7d                	li	s10,-1
  8004fc:	bfb9                	j	80045a <vprintfmt+0x60>
  8004fe:	883a                	mv	a6,a4
  800500:	8466                	mv	s0,s9
  800502:	bfa1                	j	80045a <vprintfmt+0x60>
  800504:	8466                	mv	s0,s9
  800506:	4c05                	li	s8,1
  800508:	bf89                	j	80045a <vprintfmt+0x60>
  80050a:	4785                	li	a5,1
  80050c:	008a8613          	addi	a2,s5,8
  800510:	00b7c463          	blt	a5,a1,800518 <vprintfmt+0x11e>
  800514:	1c058363          	beqz	a1,8006da <vprintfmt+0x2e0>
  800518:	000ab683          	ld	a3,0(s5)
  80051c:	4741                	li	a4,16
  80051e:	8ab2                	mv	s5,a2
  800520:	2801                	sext.w	a6,a6
  800522:	87ee                	mv	a5,s11
  800524:	864a                	mv	a2,s2
  800526:	85ce                	mv	a1,s3
  800528:	8526                	mv	a0,s1
  80052a:	e47ff0ef          	jal	800370 <printnum>
  80052e:	b709                	j	800430 <vprintfmt+0x36>
  800530:	000aa503          	lw	a0,0(s5)
  800534:	864e                	mv	a2,s3
  800536:	85ca                	mv	a1,s2
  800538:	9482                	jalr	s1
  80053a:	0aa1                	addi	s5,s5,8
  80053c:	bdd5                	j	800430 <vprintfmt+0x36>
  80053e:	4785                	li	a5,1
  800540:	008a8613          	addi	a2,s5,8
  800544:	00b7c463          	blt	a5,a1,80054c <vprintfmt+0x152>
  800548:	18058463          	beqz	a1,8006d0 <vprintfmt+0x2d6>
  80054c:	000ab683          	ld	a3,0(s5)
  800550:	4729                	li	a4,10
  800552:	8ab2                	mv	s5,a2
  800554:	b7f1                	j	800520 <vprintfmt+0x126>
  800556:	864e                	mv	a2,s3
  800558:	85ca                	mv	a1,s2
  80055a:	03000513          	li	a0,48
  80055e:	e042                	sd	a6,0(sp)
  800560:	9482                	jalr	s1
  800562:	864e                	mv	a2,s3
  800564:	85ca                	mv	a1,s2
  800566:	07800513          	li	a0,120
  80056a:	9482                	jalr	s1
  80056c:	000ab683          	ld	a3,0(s5)
  800570:	6802                	ld	a6,0(sp)
  800572:	4741                	li	a4,16
  800574:	0aa1                	addi	s5,s5,8
  800576:	b76d                	j	800520 <vprintfmt+0x126>
  800578:	864e                	mv	a2,s3
  80057a:	85ca                	mv	a1,s2
  80057c:	02500513          	li	a0,37
  800580:	9482                	jalr	s1
  800582:	b57d                	j	800430 <vprintfmt+0x36>
  800584:	000aad03          	lw	s10,0(s5)
  800588:	8466                	mv	s0,s9
  80058a:	0aa1                	addi	s5,s5,8
  80058c:	b7a5                	j	8004f4 <vprintfmt+0xfa>
  80058e:	4785                	li	a5,1
  800590:	008a8613          	addi	a2,s5,8
  800594:	00b7c463          	blt	a5,a1,80059c <vprintfmt+0x1a2>
  800598:	12058763          	beqz	a1,8006c6 <vprintfmt+0x2cc>
  80059c:	000ab683          	ld	a3,0(s5)
  8005a0:	4721                	li	a4,8
  8005a2:	8ab2                	mv	s5,a2
  8005a4:	bfb5                	j	800520 <vprintfmt+0x126>
  8005a6:	87ee                	mv	a5,s11
  8005a8:	000dd363          	bgez	s11,8005ae <vprintfmt+0x1b4>
  8005ac:	4781                	li	a5,0
  8005ae:	00078d9b          	sext.w	s11,a5
  8005b2:	8466                	mv	s0,s9
  8005b4:	b55d                	j	80045a <vprintfmt+0x60>
  8005b6:	0008041b          	sext.w	s0,a6
  8005ba:	fd340793          	addi	a5,s0,-45
  8005be:	01b02733          	sgtz	a4,s11
  8005c2:	00f037b3          	snez	a5,a5
  8005c6:	8ff9                	and	a5,a5,a4
  8005c8:	000ab703          	ld	a4,0(s5)
  8005cc:	008a8693          	addi	a3,s5,8
  8005d0:	e436                	sd	a3,8(sp)
  8005d2:	12070563          	beqz	a4,8006fc <vprintfmt+0x302>
  8005d6:	12079d63          	bnez	a5,800710 <vprintfmt+0x316>
  8005da:	00074783          	lbu	a5,0(a4)
  8005de:	0007851b          	sext.w	a0,a5
  8005e2:	c78d                	beqz	a5,80060c <vprintfmt+0x212>
  8005e4:	00170a93          	addi	s5,a4,1
  8005e8:	547d                	li	s0,-1
  8005ea:	000d4563          	bltz	s10,8005f4 <vprintfmt+0x1fa>
  8005ee:	3d7d                	addiw	s10,s10,-1
  8005f0:	008d0e63          	beq	s10,s0,80060c <vprintfmt+0x212>
  8005f4:	020c1863          	bnez	s8,800624 <vprintfmt+0x22a>
  8005f8:	864e                	mv	a2,s3
  8005fa:	85ca                	mv	a1,s2
  8005fc:	9482                	jalr	s1
  8005fe:	000ac783          	lbu	a5,0(s5)
  800602:	0a85                	addi	s5,s5,1
  800604:	3dfd                	addiw	s11,s11,-1
  800606:	0007851b          	sext.w	a0,a5
  80060a:	f3e5                	bnez	a5,8005ea <vprintfmt+0x1f0>
  80060c:	01b05a63          	blez	s11,800620 <vprintfmt+0x226>
  800610:	864e                	mv	a2,s3
  800612:	85ca                	mv	a1,s2
  800614:	02000513          	li	a0,32
  800618:	3dfd                	addiw	s11,s11,-1
  80061a:	9482                	jalr	s1
  80061c:	fe0d9ae3          	bnez	s11,800610 <vprintfmt+0x216>
  800620:	6aa2                	ld	s5,8(sp)
  800622:	b539                	j	800430 <vprintfmt+0x36>
  800624:	3781                	addiw	a5,a5,-32
  800626:	05e00713          	li	a4,94
  80062a:	fcf777e3          	bgeu	a4,a5,8005f8 <vprintfmt+0x1fe>
  80062e:	03f00513          	li	a0,63
  800632:	864e                	mv	a2,s3
  800634:	85ca                	mv	a1,s2
  800636:	9482                	jalr	s1
  800638:	000ac783          	lbu	a5,0(s5)
  80063c:	0a85                	addi	s5,s5,1
  80063e:	3dfd                	addiw	s11,s11,-1
  800640:	0007851b          	sext.w	a0,a5
  800644:	d7e1                	beqz	a5,80060c <vprintfmt+0x212>
  800646:	fa0d54e3          	bgez	s10,8005ee <vprintfmt+0x1f4>
  80064a:	bfe9                	j	800624 <vprintfmt+0x22a>
  80064c:	000aa783          	lw	a5,0(s5)
  800650:	46e1                	li	a3,24
  800652:	0aa1                	addi	s5,s5,8
  800654:	41f7d71b          	sraiw	a4,a5,0x1f
  800658:	8fb9                	xor	a5,a5,a4
  80065a:	40e7873b          	subw	a4,a5,a4
  80065e:	02e6c663          	blt	a3,a4,80068a <vprintfmt+0x290>
  800662:	00001797          	auipc	a5,0x1
  800666:	cae78793          	addi	a5,a5,-850 # 801310 <error_string>
  80066a:	00371693          	slli	a3,a4,0x3
  80066e:	97b6                	add	a5,a5,a3
  800670:	639c                	ld	a5,0(a5)
  800672:	cf81                	beqz	a5,80068a <vprintfmt+0x290>
  800674:	873e                	mv	a4,a5
  800676:	00000697          	auipc	a3,0x0
  80067a:	7fa68693          	addi	a3,a3,2042 # 800e70 <main+0x1c0>
  80067e:	864a                	mv	a2,s2
  800680:	85ce                	mv	a1,s3
  800682:	8526                	mv	a0,s1
  800684:	0f2000ef          	jal	800776 <printfmt>
  800688:	b365                	j	800430 <vprintfmt+0x36>
  80068a:	00000697          	auipc	a3,0x0
  80068e:	7d668693          	addi	a3,a3,2006 # 800e60 <main+0x1b0>
  800692:	864a                	mv	a2,s2
  800694:	85ce                	mv	a1,s3
  800696:	8526                	mv	a0,s1
  800698:	0de000ef          	jal	800776 <printfmt>
  80069c:	bb51                	j	800430 <vprintfmt+0x36>
  80069e:	4785                	li	a5,1
  8006a0:	008a8c13          	addi	s8,s5,8
  8006a4:	00b7c363          	blt	a5,a1,8006aa <vprintfmt+0x2b0>
  8006a8:	cd81                	beqz	a1,8006c0 <vprintfmt+0x2c6>
  8006aa:	000ab403          	ld	s0,0(s5)
  8006ae:	02044b63          	bltz	s0,8006e4 <vprintfmt+0x2ea>
  8006b2:	86a2                	mv	a3,s0
  8006b4:	8ae2                	mv	s5,s8
  8006b6:	4729                	li	a4,10
  8006b8:	b5a5                	j	800520 <vprintfmt+0x126>
  8006ba:	2585                	addiw	a1,a1,1
  8006bc:	8466                	mv	s0,s9
  8006be:	bb71                	j	80045a <vprintfmt+0x60>
  8006c0:	000aa403          	lw	s0,0(s5)
  8006c4:	b7ed                	j	8006ae <vprintfmt+0x2b4>
  8006c6:	000ae683          	lwu	a3,0(s5)
  8006ca:	4721                	li	a4,8
  8006cc:	8ab2                	mv	s5,a2
  8006ce:	bd89                	j	800520 <vprintfmt+0x126>
  8006d0:	000ae683          	lwu	a3,0(s5)
  8006d4:	4729                	li	a4,10
  8006d6:	8ab2                	mv	s5,a2
  8006d8:	b5a1                	j	800520 <vprintfmt+0x126>
  8006da:	000ae683          	lwu	a3,0(s5)
  8006de:	4741                	li	a4,16
  8006e0:	8ab2                	mv	s5,a2
  8006e2:	bd3d                	j	800520 <vprintfmt+0x126>
  8006e4:	864e                	mv	a2,s3
  8006e6:	85ca                	mv	a1,s2
  8006e8:	02d00513          	li	a0,45
  8006ec:	e042                	sd	a6,0(sp)
  8006ee:	9482                	jalr	s1
  8006f0:	6802                	ld	a6,0(sp)
  8006f2:	408006b3          	neg	a3,s0
  8006f6:	8ae2                	mv	s5,s8
  8006f8:	4729                	li	a4,10
  8006fa:	b51d                	j	800520 <vprintfmt+0x126>
  8006fc:	eba1                	bnez	a5,80074c <vprintfmt+0x352>
  8006fe:	02800793          	li	a5,40
  800702:	853e                	mv	a0,a5
  800704:	00000a97          	auipc	s5,0x0
  800708:	755a8a93          	addi	s5,s5,1877 # 800e59 <main+0x1a9>
  80070c:	547d                	li	s0,-1
  80070e:	bdf1                	j	8005ea <vprintfmt+0x1f0>
  800710:	853a                	mv	a0,a4
  800712:	85ea                	mv	a1,s10
  800714:	e03a                	sd	a4,0(sp)
  800716:	0cc000ef          	jal	8007e2 <strnlen>
  80071a:	40ad8dbb          	subw	s11,s11,a0
  80071e:	6702                	ld	a4,0(sp)
  800720:	01b05b63          	blez	s11,800736 <vprintfmt+0x33c>
  800724:	864e                	mv	a2,s3
  800726:	85ca                	mv	a1,s2
  800728:	8522                	mv	a0,s0
  80072a:	e03a                	sd	a4,0(sp)
  80072c:	3dfd                	addiw	s11,s11,-1
  80072e:	9482                	jalr	s1
  800730:	6702                	ld	a4,0(sp)
  800732:	fe0d99e3          	bnez	s11,800724 <vprintfmt+0x32a>
  800736:	00074783          	lbu	a5,0(a4)
  80073a:	0007851b          	sext.w	a0,a5
  80073e:	ee0781e3          	beqz	a5,800620 <vprintfmt+0x226>
  800742:	00170a93          	addi	s5,a4,1
  800746:	b54d                	j	8005e8 <vprintfmt+0x1ee>
  800748:	8466                	mv	s0,s9
  80074a:	b36d                	j	8004f4 <vprintfmt+0xfa>
  80074c:	85ea                	mv	a1,s10
  80074e:	00000517          	auipc	a0,0x0
  800752:	70a50513          	addi	a0,a0,1802 # 800e58 <main+0x1a8>
  800756:	08c000ef          	jal	8007e2 <strnlen>
  80075a:	40ad8dbb          	subw	s11,s11,a0
  80075e:	02800793          	li	a5,40
  800762:	00000717          	auipc	a4,0x0
  800766:	6f670713          	addi	a4,a4,1782 # 800e58 <main+0x1a8>
  80076a:	853e                	mv	a0,a5
  80076c:	fbb04ce3          	bgtz	s11,800724 <vprintfmt+0x32a>
  800770:	00170a93          	addi	s5,a4,1
  800774:	bd95                	j	8005e8 <vprintfmt+0x1ee>

0000000000800776 <printfmt>:
  800776:	7139                	addi	sp,sp,-64
  800778:	02010313          	addi	t1,sp,32
  80077c:	f03a                	sd	a4,32(sp)
  80077e:	871a                	mv	a4,t1
  800780:	ec06                	sd	ra,24(sp)
  800782:	f43e                	sd	a5,40(sp)
  800784:	f842                	sd	a6,48(sp)
  800786:	fc46                	sd	a7,56(sp)
  800788:	e41a                	sd	t1,8(sp)
  80078a:	c71ff0ef          	jal	8003fa <vprintfmt>
  80078e:	60e2                	ld	ra,24(sp)
  800790:	6121                	addi	sp,sp,64
  800792:	8082                	ret

0000000000800794 <snprintf>:
  800794:	711d                	addi	sp,sp,-96
  800796:	15fd                	addi	a1,a1,-1
  800798:	95aa                	add	a1,a1,a0
  80079a:	03810313          	addi	t1,sp,56
  80079e:	f406                	sd	ra,40(sp)
  8007a0:	e82e                	sd	a1,16(sp)
  8007a2:	e42a                	sd	a0,8(sp)
  8007a4:	fc36                	sd	a3,56(sp)
  8007a6:	e0ba                	sd	a4,64(sp)
  8007a8:	e4be                	sd	a5,72(sp)
  8007aa:	e8c2                	sd	a6,80(sp)
  8007ac:	ecc6                	sd	a7,88(sp)
  8007ae:	cc02                	sw	zero,24(sp)
  8007b0:	e01a                	sd	t1,0(sp)
  8007b2:	c515                	beqz	a0,8007de <snprintf+0x4a>
  8007b4:	02a5e563          	bltu	a1,a0,8007de <snprintf+0x4a>
  8007b8:	75dd                	lui	a1,0xffff7
  8007ba:	86b2                	mv	a3,a2
  8007bc:	00000517          	auipc	a0,0x0
  8007c0:	c2450513          	addi	a0,a0,-988 # 8003e0 <sprintputch>
  8007c4:	871a                	mv	a4,t1
  8007c6:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <shcwd+0xffffffffff7f29d1>
  8007ca:	0030                	addi	a2,sp,8
  8007cc:	c2fff0ef          	jal	8003fa <vprintfmt>
  8007d0:	67a2                	ld	a5,8(sp)
  8007d2:	00078023          	sb	zero,0(a5)
  8007d6:	4562                	lw	a0,24(sp)
  8007d8:	70a2                	ld	ra,40(sp)
  8007da:	6125                	addi	sp,sp,96
  8007dc:	8082                	ret
  8007de:	5575                	li	a0,-3
  8007e0:	bfe5                	j	8007d8 <snprintf+0x44>

00000000008007e2 <strnlen>:
  8007e2:	4781                	li	a5,0
  8007e4:	e589                	bnez	a1,8007ee <strnlen+0xc>
  8007e6:	a811                	j	8007fa <strnlen+0x18>
  8007e8:	0785                	addi	a5,a5,1
  8007ea:	00f58863          	beq	a1,a5,8007fa <strnlen+0x18>
  8007ee:	00f50733          	add	a4,a0,a5
  8007f2:	00074703          	lbu	a4,0(a4)
  8007f6:	fb6d                	bnez	a4,8007e8 <strnlen+0x6>
  8007f8:	85be                	mv	a1,a5
  8007fa:	852e                	mv	a0,a1
  8007fc:	8082                	ret

00000000008007fe <strcpy>:
  8007fe:	87aa                	mv	a5,a0
  800800:	0005c703          	lbu	a4,0(a1)
  800804:	0585                	addi	a1,a1,1
  800806:	0785                	addi	a5,a5,1
  800808:	fee78fa3          	sb	a4,-1(a5)
  80080c:	fb75                	bnez	a4,800800 <strcpy+0x2>
  80080e:	8082                	ret

0000000000800810 <strcmp>:
  800810:	00054783          	lbu	a5,0(a0)
  800814:	e791                	bnez	a5,800820 <strcmp+0x10>
  800816:	a01d                	j	80083c <strcmp+0x2c>
  800818:	00054783          	lbu	a5,0(a0)
  80081c:	cb99                	beqz	a5,800832 <strcmp+0x22>
  80081e:	0585                	addi	a1,a1,1
  800820:	0005c703          	lbu	a4,0(a1)
  800824:	0505                	addi	a0,a0,1
  800826:	fef709e3          	beq	a4,a5,800818 <strcmp+0x8>
  80082a:	0007851b          	sext.w	a0,a5
  80082e:	9d19                	subw	a0,a0,a4
  800830:	8082                	ret
  800832:	0015c703          	lbu	a4,1(a1)
  800836:	4501                	li	a0,0
  800838:	9d19                	subw	a0,a0,a4
  80083a:	8082                	ret
  80083c:	0005c703          	lbu	a4,0(a1)
  800840:	4501                	li	a0,0
  800842:	b7f5                	j	80082e <strcmp+0x1e>

0000000000800844 <strchr>:
  800844:	a021                	j	80084c <strchr+0x8>
  800846:	00f58763          	beq	a1,a5,800854 <strchr+0x10>
  80084a:	0505                	addi	a0,a0,1
  80084c:	00054783          	lbu	a5,0(a0)
  800850:	fbfd                	bnez	a5,800846 <strchr+0x2>
  800852:	4501                	li	a0,0
  800854:	8082                	ret

0000000000800856 <gettoken>:
  800856:	7139                	addi	sp,sp,-64
  800858:	f822                	sd	s0,48(sp)
  80085a:	6100                	ld	s0,0(a0)
  80085c:	fc06                	sd	ra,56(sp)
  80085e:	c815                	beqz	s0,800892 <gettoken+0x3c>
  800860:	f04a                	sd	s2,32(sp)
  800862:	ec4e                	sd	s3,24(sp)
  800864:	f426                	sd	s1,40(sp)
  800866:	892a                	mv	s2,a0
  800868:	89ae                	mv	s3,a1
  80086a:	a021                	j	800872 <gettoken+0x1c>
  80086c:	0405                	addi	s0,s0,1
  80086e:	fe040fa3          	sb	zero,-1(s0)
  800872:	00044583          	lbu	a1,0(s0)
  800876:	00000517          	auipc	a0,0x0
  80087a:	7da50513          	addi	a0,a0,2010 # 801050 <main+0x3a0>
  80087e:	fc7ff0ef          	jal	800844 <strchr>
  800882:	84aa                	mv	s1,a0
  800884:	f565                	bnez	a0,80086c <gettoken+0x16>
  800886:	00044783          	lbu	a5,0(s0)
  80088a:	eb89                	bnez	a5,80089c <gettoken+0x46>
  80088c:	74a2                	ld	s1,40(sp)
  80088e:	7902                	ld	s2,32(sp)
  800890:	69e2                	ld	s3,24(sp)
  800892:	70e2                	ld	ra,56(sp)
  800894:	7442                	ld	s0,48(sp)
  800896:	4501                	li	a0,0
  800898:	6121                	addi	sp,sp,64
  80089a:	8082                	ret
  80089c:	0089b023          	sd	s0,0(s3)
  8008a0:	00044583          	lbu	a1,0(s0)
  8008a4:	00000517          	auipc	a0,0x0
  8008a8:	7b450513          	addi	a0,a0,1972 # 801058 <main+0x3a8>
  8008ac:	f99ff0ef          	jal	800844 <strchr>
  8008b0:	00044583          	lbu	a1,0(s0)
  8008b4:	c505                	beqz	a0,8008dc <gettoken+0x86>
  8008b6:	00144783          	lbu	a5,1(s0)
  8008ba:	0005851b          	sext.w	a0,a1
  8008be:	00040023          	sb	zero,0(s0)
  8008c2:	00140713          	addi	a4,s0,1
  8008c6:	c391                	beqz	a5,8008ca <gettoken+0x74>
  8008c8:	84ba                	mv	s1,a4
  8008ca:	70e2                	ld	ra,56(sp)
  8008cc:	7442                	ld	s0,48(sp)
  8008ce:	00993023          	sd	s1,0(s2)
  8008d2:	69e2                	ld	s3,24(sp)
  8008d4:	74a2                	ld	s1,40(sp)
  8008d6:	7902                	ld	s2,32(sp)
  8008d8:	6121                	addi	sp,sp,64
  8008da:	8082                	ret
  8008dc:	4701                	li	a4,0
  8008de:	02200693          	li	a3,34
  8008e2:	c185                	beqz	a1,800902 <gettoken+0xac>
  8008e4:	c31d                	beqz	a4,80090a <gettoken+0xb4>
  8008e6:	00044783          	lbu	a5,0(s0)
  8008ea:	00d79863          	bne	a5,a3,8008fa <gettoken+0xa4>
  8008ee:	02000793          	li	a5,32
  8008f2:	00f40023          	sb	a5,0(s0)
  8008f6:	00174713          	xori	a4,a4,1
  8008fa:	00144583          	lbu	a1,1(s0)
  8008fe:	0405                	addi	s0,s0,1
  800900:	f1f5                	bnez	a1,8008e4 <gettoken+0x8e>
  800902:	4481                	li	s1,0
  800904:	07700513          	li	a0,119
  800908:	b7c9                	j	8008ca <gettoken+0x74>
  80090a:	00000517          	auipc	a0,0x0
  80090e:	75650513          	addi	a0,a0,1878 # 801060 <main+0x3b0>
  800912:	e43a                	sd	a4,8(sp)
  800914:	f31ff0ef          	jal	800844 <strchr>
  800918:	6722                	ld	a4,8(sp)
  80091a:	02200693          	li	a3,34
  80091e:	d561                	beqz	a0,8008e6 <gettoken+0x90>
  800920:	00044783          	lbu	a5,0(s0)
  800924:	8722                	mv	a4,s0
  800926:	07700513          	li	a0,119
  80092a:	bf71                	j	8008c6 <gettoken+0x70>

000000000080092c <readline>:
  80092c:	715d                	addi	sp,sp,-80
  80092e:	e486                	sd	ra,72(sp)
  800930:	e0a2                	sd	s0,64(sp)
  800932:	fc26                	sd	s1,56(sp)
  800934:	f84a                	sd	s2,48(sp)
  800936:	f44e                	sd	s3,40(sp)
  800938:	f052                	sd	s4,32(sp)
  80093a:	ec56                	sd	s5,24(sp)
  80093c:	c909                	beqz	a0,80094e <readline+0x22>
  80093e:	862a                	mv	a2,a0
  800940:	00000597          	auipc	a1,0x0
  800944:	53058593          	addi	a1,a1,1328 # 800e70 <main+0x1c0>
  800948:	4505                	li	a0,1
  80094a:	85bff0ef          	jal	8001a4 <fprintf>
  80094e:	6985                	lui	s3,0x1
  800950:	19f9                	addi	s3,s3,-2 # ffe <open-0x7ff022>
  800952:	4401                	li	s0,0
  800954:	448d                	li	s1,3
  800956:	497d                	li	s2,31
  800958:	4a21                	li	s4,8
  80095a:	00002a97          	auipc	s5,0x2
  80095e:	7aea8a93          	addi	s5,s5,1966 # 803108 <buffer.2>
  800962:	4605                	li	a2,1
  800964:	00f10593          	addi	a1,sp,15
  800968:	4501                	li	a0,0
  80096a:	ebeff0ef          	jal	800028 <read>
  80096e:	04054163          	bltz	a0,8009b0 <readline+0x84>
  800972:	c549                	beqz	a0,8009fc <readline+0xd0>
  800974:	00f14603          	lbu	a2,15(sp)
  800978:	02960c63          	beq	a2,s1,8009b0 <readline+0x84>
  80097c:	04c97463          	bgeu	s2,a2,8009c4 <readline+0x98>
  800980:	fe89c1e3          	blt	s3,s0,800962 <readline+0x36>
  800984:	00000597          	auipc	a1,0x0
  800988:	6ec58593          	addi	a1,a1,1772 # 801070 <main+0x3c0>
  80098c:	4505                	li	a0,1
  80098e:	817ff0ef          	jal	8001a4 <fprintf>
  800992:	00f14703          	lbu	a4,15(sp)
  800996:	008a87b3          	add	a5,s5,s0
  80099a:	4605                	li	a2,1
  80099c:	00f10593          	addi	a1,sp,15
  8009a0:	4501                	li	a0,0
  8009a2:	00e78023          	sb	a4,0(a5)
  8009a6:	2405                	addiw	s0,s0,1
  8009a8:	e80ff0ef          	jal	800028 <read>
  8009ac:	fc0553e3          	bgez	a0,800972 <readline+0x46>
  8009b0:	4501                	li	a0,0
  8009b2:	60a6                	ld	ra,72(sp)
  8009b4:	6406                	ld	s0,64(sp)
  8009b6:	74e2                	ld	s1,56(sp)
  8009b8:	7942                	ld	s2,48(sp)
  8009ba:	79a2                	ld	s3,40(sp)
  8009bc:	7a02                	ld	s4,32(sp)
  8009be:	6ae2                	ld	s5,24(sp)
  8009c0:	6161                	addi	sp,sp,80
  8009c2:	8082                	ret
  8009c4:	01461d63          	bne	a2,s4,8009de <readline+0xb2>
  8009c8:	f8805de3          	blez	s0,800962 <readline+0x36>
  8009cc:	00000597          	auipc	a1,0x0
  8009d0:	6a458593          	addi	a1,a1,1700 # 801070 <main+0x3c0>
  8009d4:	4505                	li	a0,1
  8009d6:	fceff0ef          	jal	8001a4 <fprintf>
  8009da:	347d                	addiw	s0,s0,-1
  8009dc:	b759                	j	800962 <readline+0x36>
  8009de:	ff660793          	addi	a5,a2,-10
  8009e2:	2601                	sext.w	a2,a2
  8009e4:	c781                	beqz	a5,8009ec <readline+0xc0>
  8009e6:	ff360793          	addi	a5,a2,-13
  8009ea:	ffa5                	bnez	a5,800962 <readline+0x36>
  8009ec:	00000597          	auipc	a1,0x0
  8009f0:	68458593          	addi	a1,a1,1668 # 801070 <main+0x3c0>
  8009f4:	4505                	li	a0,1
  8009f6:	faeff0ef          	jal	8001a4 <fprintf>
  8009fa:	a019                	j	800a00 <readline+0xd4>
  8009fc:	fa805be3          	blez	s0,8009b2 <readline+0x86>
  800a00:	00002517          	auipc	a0,0x2
  800a04:	70850513          	addi	a0,a0,1800 # 803108 <buffer.2>
  800a08:	942a                	add	s0,s0,a0
  800a0a:	00040023          	sb	zero,0(s0)
  800a0e:	b755                	j	8009b2 <readline+0x86>

0000000000800a10 <reopen>:
  800a10:	7179                	addi	sp,sp,-48
  800a12:	f406                	sd	ra,40(sp)
  800a14:	f022                	sd	s0,32(sp)
  800a16:	ec26                	sd	s1,24(sp)
  800a18:	e432                	sd	a2,8(sp)
  800a1a:	84ae                	mv	s1,a1
  800a1c:	842a                	mv	s0,a0
  800a1e:	e08ff0ef          	jal	800026 <close>
  800a22:	65a2                	ld	a1,8(sp)
  800a24:	8526                	mv	a0,s1
  800a26:	dfaff0ef          	jal	800020 <open>
  800a2a:	87aa                	mv	a5,a0
  800a2c:	00a40763          	beq	s0,a0,800a3a <reopen+0x2a>
  800a30:	fff54713          	not	a4,a0
  800a34:	01f7571b          	srliw	a4,a4,0x1f
  800a38:	eb19                	bnez	a4,800a4e <reopen+0x3e>
  800a3a:	0007851b          	sext.w	a0,a5
  800a3e:	00f05363          	blez	a5,800a44 <reopen+0x34>
  800a42:	4501                	li	a0,0
  800a44:	70a2                	ld	ra,40(sp)
  800a46:	7402                	ld	s0,32(sp)
  800a48:	64e2                	ld	s1,24(sp)
  800a4a:	6145                	addi	sp,sp,48
  800a4c:	8082                	ret
  800a4e:	e42a                	sd	a0,8(sp)
  800a50:	8522                	mv	a0,s0
  800a52:	dd4ff0ef          	jal	800026 <close>
  800a56:	6522                	ld	a0,8(sp)
  800a58:	85a2                	mv	a1,s0
  800a5a:	dd2ff0ef          	jal	80002c <dup2>
  800a5e:	842a                	mv	s0,a0
  800a60:	6522                	ld	a0,8(sp)
  800a62:	dc4ff0ef          	jal	800026 <close>
  800a66:	87a2                	mv	a5,s0
  800a68:	bfc9                	j	800a3a <reopen+0x2a>

0000000000800a6a <runcmd>:
  800a6a:	711d                	addi	sp,sp,-96
  800a6c:	e8a2                	sd	s0,80(sp)
  800a6e:	e0ca                	sd	s2,64(sp)
  800a70:	fc4e                	sd	s3,56(sp)
  800a72:	f852                	sd	s4,48(sp)
  800a74:	ec86                	sd	ra,88(sp)
  800a76:	e4a6                	sd	s1,72(sp)
  800a78:	e42a                	sd	a0,8(sp)
  800a7a:	03e00413          	li	s0,62
  800a7e:	07700a13          	li	s4,119
  800a82:	03b00913          	li	s2,59
  800a86:	03c00993          	li	s3,60
  800a8a:	4481                	li	s1,0
  800a8c:	082c                	addi	a1,sp,24
  800a8e:	0028                	addi	a0,sp,8
  800a90:	dc7ff0ef          	jal	800856 <gettoken>
  800a94:	0c850c63          	beq	a0,s0,800b6c <runcmd+0x102>
  800a98:	04a44163          	blt	s0,a0,800ada <runcmd+0x70>
  800a9c:	13250063          	beq	a0,s2,800bbc <runcmd+0x152>
  800aa0:	09350a63          	beq	a0,s3,800b34 <runcmd+0xca>
  800aa4:	e535                	bnez	a0,800b10 <runcmd+0xa6>
  800aa6:	c885                	beqz	s1,800ad6 <runcmd+0x6c>
  800aa8:	00002417          	auipc	s0,0x2
  800aac:	55840413          	addi	s0,s0,1368 # 803000 <argv.1>
  800ab0:	6008                	ld	a0,0(s0)
  800ab2:	00000597          	auipc	a1,0x0
  800ab6:	68e58593          	addi	a1,a1,1678 # 801140 <main+0x490>
  800aba:	d57ff0ef          	jal	800810 <strcmp>
  800abe:	14051263          	bnez	a0,800c02 <runcmd+0x198>
  800ac2:	4789                	li	a5,2
  800ac4:	04f49e63          	bne	s1,a5,800b20 <runcmd+0xb6>
  800ac8:	640c                	ld	a1,8(s0)
  800aca:	00003517          	auipc	a0,0x3
  800ace:	63e50513          	addi	a0,a0,1598 # 804108 <shcwd>
  800ad2:	d2dff0ef          	jal	8007fe <strcpy>
  800ad6:	4781                	li	a5,0
  800ad8:	a0a9                	j	800b22 <runcmd+0xb8>
  800ada:	0f450c63          	beq	a0,s4,800bd2 <runcmd+0x168>
  800ade:	07c00793          	li	a5,124
  800ae2:	02f51763          	bne	a0,a5,800b10 <runcmd+0xa6>
  800ae6:	f9aff0ef          	jal	800280 <fork>
  800aea:	87aa                	mv	a5,a0
  800aec:	18051f63          	bnez	a0,800c8a <runcmd+0x220>
  800af0:	d36ff0ef          	jal	800026 <close>
  800af4:	4581                	li	a1,0
  800af6:	4501                	li	a0,0
  800af8:	d34ff0ef          	jal	80002c <dup2>
  800afc:	87aa                	mv	a5,a0
  800afe:	02054263          	bltz	a0,800b22 <runcmd+0xb8>
  800b02:	4501                	li	a0,0
  800b04:	d22ff0ef          	jal	800026 <close>
  800b08:	4501                	li	a0,0
  800b0a:	d1cff0ef          	jal	800026 <close>
  800b0e:	bfb5                	j	800a8a <runcmd+0x20>
  800b10:	862a                	mv	a2,a0
  800b12:	00000597          	auipc	a1,0x0
  800b16:	60658593          	addi	a1,a1,1542 # 801118 <main+0x468>
  800b1a:	4505                	li	a0,1
  800b1c:	e88ff0ef          	jal	8001a4 <fprintf>
  800b20:	57fd                	li	a5,-1
  800b22:	60e6                	ld	ra,88(sp)
  800b24:	6446                	ld	s0,80(sp)
  800b26:	64a6                	ld	s1,72(sp)
  800b28:	6906                	ld	s2,64(sp)
  800b2a:	79e2                	ld	s3,56(sp)
  800b2c:	7a42                	ld	s4,48(sp)
  800b2e:	853e                	mv	a0,a5
  800b30:	6125                	addi	sp,sp,96
  800b32:	8082                	ret
  800b34:	082c                	addi	a1,sp,24
  800b36:	0028                	addi	a0,sp,8
  800b38:	d1fff0ef          	jal	800856 <gettoken>
  800b3c:	07700793          	li	a5,119
  800b40:	10f51d63          	bne	a0,a5,800c5a <runcmd+0x1f0>
  800b44:	f456                	sd	s5,40(sp)
  800b46:	6ae2                	ld	s5,24(sp)
  800b48:	4501                	li	a0,0
  800b4a:	cdcff0ef          	jal	800026 <close>
  800b4e:	8556                	mv	a0,s5
  800b50:	4581                	li	a1,0
  800b52:	cceff0ef          	jal	800020 <open>
  800b56:	87aa                	mv	a5,a0
  800b58:	08054c63          	bltz	a0,800bf0 <runcmd+0x186>
  800b5c:	ed41                	bnez	a0,800bf4 <runcmd+0x18a>
  800b5e:	082c                	addi	a1,sp,24
  800b60:	0028                	addi	a0,sp,8
  800b62:	7aa2                	ld	s5,40(sp)
  800b64:	cf3ff0ef          	jal	800856 <gettoken>
  800b68:	f28518e3          	bne	a0,s0,800a98 <runcmd+0x2e>
  800b6c:	082c                	addi	a1,sp,24
  800b6e:	0028                	addi	a0,sp,8
  800b70:	ce7ff0ef          	jal	800856 <gettoken>
  800b74:	07700793          	li	a5,119
  800b78:	0ef51963          	bne	a0,a5,800c6a <runcmd+0x200>
  800b7c:	f456                	sd	s5,40(sp)
  800b7e:	6ae2                	ld	s5,24(sp)
  800b80:	4505                	li	a0,1
  800b82:	ca4ff0ef          	jal	800026 <close>
  800b86:	8556                	mv	a0,s5
  800b88:	45d9                	li	a1,22
  800b8a:	c96ff0ef          	jal	800020 <open>
  800b8e:	87aa                	mv	a5,a0
  800b90:	06054063          	bltz	a0,800bf0 <runcmd+0x186>
  800b94:	4585                	li	a1,1
  800b96:	fcb504e3          	beq	a0,a1,800b5e <runcmd+0xf4>
  800b9a:	852e                	mv	a0,a1
  800b9c:	e03e                	sd	a5,0(sp)
  800b9e:	c88ff0ef          	jal	800026 <close>
  800ba2:	6502                	ld	a0,0(sp)
  800ba4:	4585                	li	a1,1
  800ba6:	c86ff0ef          	jal	80002c <dup2>
  800baa:	8aaa                	mv	s5,a0
  800bac:	6502                	ld	a0,0(sp)
  800bae:	c78ff0ef          	jal	800026 <close>
  800bb2:	fa0ad6e3          	bgez	s5,800b5e <runcmd+0xf4>
  800bb6:	87d6                	mv	a5,s5
  800bb8:	7aa2                	ld	s5,40(sp)
  800bba:	b7a5                	j	800b22 <runcmd+0xb8>
  800bbc:	ec4ff0ef          	jal	800280 <fork>
  800bc0:	87aa                	mv	a5,a0
  800bc2:	ee0502e3          	beqz	a0,800aa6 <runcmd+0x3c>
  800bc6:	f4054ee3          	bltz	a0,800b22 <runcmd+0xb8>
  800bca:	4581                	li	a1,0
  800bcc:	eb6ff0ef          	jal	800282 <waitpid>
  800bd0:	bd6d                	j	800a8a <runcmd+0x20>
  800bd2:	02000793          	li	a5,32
  800bd6:	0af48263          	beq	s1,a5,800c7a <runcmd+0x210>
  800bda:	6762                	ld	a4,24(sp)
  800bdc:	00349693          	slli	a3,s1,0x3
  800be0:	00002797          	auipc	a5,0x2
  800be4:	42078793          	addi	a5,a5,1056 # 803000 <argv.1>
  800be8:	97b6                	add	a5,a5,a3
  800bea:	2485                	addiw	s1,s1,1
  800bec:	e398                	sd	a4,0(a5)
  800bee:	bd79                	j	800a8c <runcmd+0x22>
  800bf0:	7aa2                	ld	s5,40(sp)
  800bf2:	bf05                	j	800b22 <runcmd+0xb8>
  800bf4:	4501                	li	a0,0
  800bf6:	e03e                	sd	a5,0(sp)
  800bf8:	c2eff0ef          	jal	800026 <close>
  800bfc:	6502                	ld	a0,0(sp)
  800bfe:	4581                	li	a1,0
  800c00:	b75d                	j	800ba6 <runcmd+0x13c>
  800c02:	6008                	ld	a0,0(s0)
  800c04:	4581                	li	a1,0
  800c06:	c1aff0ef          	jal	800020 <open>
  800c0a:	87aa                	mv	a5,a0
  800c0c:	02054263          	bltz	a0,800c30 <runcmd+0x1c6>
  800c10:	c16ff0ef          	jal	800026 <close>
  800c14:	00349793          	slli	a5,s1,0x3
  800c18:	97a2                	add	a5,a5,s0
  800c1a:	0007b023          	sd	zero,0(a5)
  800c1e:	6008                	ld	a0,0(s0)
  800c20:	00002597          	auipc	a1,0x2
  800c24:	3e058593          	addi	a1,a1,992 # 803000 <argv.1>
  800c28:	e76ff0ef          	jal	80029e <__exec>
  800c2c:	87aa                	mv	a5,a0
  800c2e:	bdd5                	j	800b22 <runcmd+0xb8>
  800c30:	5741                	li	a4,-16
  800c32:	eee518e3          	bne	a0,a4,800b22 <runcmd+0xb8>
  800c36:	6014                	ld	a3,0(s0)
  800c38:	00000617          	auipc	a2,0x0
  800c3c:	51060613          	addi	a2,a2,1296 # 801148 <main+0x498>
  800c40:	6585                	lui	a1,0x1
  800c42:	00001517          	auipc	a0,0x1
  800c46:	3be50513          	addi	a0,a0,958 # 802000 <argv0.0>
  800c4a:	b4bff0ef          	jal	800794 <snprintf>
  800c4e:	00001797          	auipc	a5,0x1
  800c52:	3b278793          	addi	a5,a5,946 # 802000 <argv0.0>
  800c56:	e01c                	sd	a5,0(s0)
  800c58:	bf75                	j	800c14 <runcmd+0x1aa>
  800c5a:	00000597          	auipc	a1,0x0
  800c5e:	45e58593          	addi	a1,a1,1118 # 8010b8 <main+0x408>
  800c62:	4505                	li	a0,1
  800c64:	d40ff0ef          	jal	8001a4 <fprintf>
  800c68:	bd65                	j	800b20 <runcmd+0xb6>
  800c6a:	00000597          	auipc	a1,0x0
  800c6e:	47e58593          	addi	a1,a1,1150 # 8010e8 <main+0x438>
  800c72:	4505                	li	a0,1
  800c74:	d30ff0ef          	jal	8001a4 <fprintf>
  800c78:	b565                	j	800b20 <runcmd+0xb6>
  800c7a:	00000597          	auipc	a1,0x0
  800c7e:	41e58593          	addi	a1,a1,1054 # 801098 <main+0x3e8>
  800c82:	4505                	li	a0,1
  800c84:	d20ff0ef          	jal	8001a4 <fprintf>
  800c88:	bd61                	j	800b20 <runcmd+0xb6>
  800c8a:	e8054ce3          	bltz	a0,800b22 <runcmd+0xb8>
  800c8e:	4505                	li	a0,1
  800c90:	b96ff0ef          	jal	800026 <close>
  800c94:	4585                	li	a1,1
  800c96:	4501                	li	a0,0
  800c98:	b94ff0ef          	jal	80002c <dup2>
  800c9c:	87aa                	mv	a5,a0
  800c9e:	e80542e3          	bltz	a0,800b22 <runcmd+0xb8>
  800ca2:	4501                	li	a0,0
  800ca4:	b82ff0ef          	jal	800026 <close>
  800ca8:	4501                	li	a0,0
  800caa:	b7cff0ef          	jal	800026 <close>
  800cae:	bbe5                	j	800aa6 <runcmd+0x3c>

0000000000800cb0 <main>:
  800cb0:	7179                	addi	sp,sp,-48
  800cb2:	f022                	sd	s0,32(sp)
  800cb4:	842a                	mv	s0,a0
  800cb6:	00000517          	auipc	a0,0x0
  800cba:	49a50513          	addi	a0,a0,1178 # 801150 <main+0x4a0>
  800cbe:	ec26                	sd	s1,24(sp)
  800cc0:	f406                	sd	ra,40(sp)
  800cc2:	84ae                	mv	s1,a1
  800cc4:	c94ff0ef          	jal	800158 <cputs>
  800cc8:	4789                	li	a5,2
  800cca:	04f40c63          	beq	s0,a5,800d22 <main+0x72>
  800cce:	00000497          	auipc	s1,0x0
  800cd2:	4e248493          	addi	s1,s1,1250 # 8011b0 <main+0x500>
  800cd6:	0287d063          	bge	a5,s0,800cf6 <main+0x46>
  800cda:	a059                	j	800d60 <main+0xb0>
  800cdc:	00003797          	auipc	a5,0x3
  800ce0:	42078623          	sb	zero,1068(a5) # 804108 <shcwd>
  800ce4:	d9cff0ef          	jal	800280 <fork>
  800ce8:	c535                	beqz	a0,800d54 <main+0xa4>
  800cea:	04054563          	bltz	a0,800d34 <main+0x84>
  800cee:	006c                	addi	a1,sp,12
  800cf0:	d92ff0ef          	jal	800282 <waitpid>
  800cf4:	cd01                	beqz	a0,800d0c <main+0x5c>
  800cf6:	8526                	mv	a0,s1
  800cf8:	c35ff0ef          	jal	80092c <readline>
  800cfc:	842a                	mv	s0,a0
  800cfe:	fd79                	bnez	a0,800cdc <main+0x2c>
  800d00:	4501                	li	a0,0
  800d02:	70a2                	ld	ra,40(sp)
  800d04:	7402                	ld	s0,32(sp)
  800d06:	64e2                	ld	s1,24(sp)
  800d08:	6145                	addi	sp,sp,48
  800d0a:	8082                	ret
  800d0c:	46b2                	lw	a3,12(sp)
  800d0e:	d6e5                	beqz	a3,800cf6 <main+0x46>
  800d10:	8636                	mv	a2,a3
  800d12:	00000597          	auipc	a1,0x0
  800d16:	48e58593          	addi	a1,a1,1166 # 8011a0 <main+0x4f0>
  800d1a:	4505                	li	a0,1
  800d1c:	c88ff0ef          	jal	8001a4 <fprintf>
  800d20:	bfd9                	j	800cf6 <main+0x46>
  800d22:	648c                	ld	a1,8(s1)
  800d24:	4601                	li	a2,0
  800d26:	4501                	li	a0,0
  800d28:	ce9ff0ef          	jal	800a10 <reopen>
  800d2c:	c62a                	sw	a0,12(sp)
  800d2e:	4481                	li	s1,0
  800d30:	d179                	beqz	a0,800cf6 <main+0x46>
  800d32:	bfc1                	j	800d02 <main+0x52>
  800d34:	00000697          	auipc	a3,0x0
  800d38:	43468693          	addi	a3,a3,1076 # 801168 <main+0x4b8>
  800d3c:	00000617          	auipc	a2,0x0
  800d40:	43c60613          	addi	a2,a2,1084 # 801178 <main+0x4c8>
  800d44:	0f200593          	li	a1,242
  800d48:	00000517          	auipc	a0,0x0
  800d4c:	44850513          	addi	a0,a0,1096 # 801190 <main+0x4e0>
  800d50:	ae4ff0ef          	jal	800034 <__panic>
  800d54:	8522                	mv	a0,s0
  800d56:	d15ff0ef          	jal	800a6a <runcmd>
  800d5a:	c62a                	sw	a0,12(sp)
  800d5c:	d0eff0ef          	jal	80026a <exit>
  800d60:	00000597          	auipc	a1,0x0
  800d64:	31858593          	addi	a1,a1,792 # 801078 <main+0x3c8>
  800d68:	4505                	li	a0,1
  800d6a:	c3aff0ef          	jal	8001a4 <fprintf>
  800d6e:	557d                	li	a0,-1
  800d70:	bf49                	j	800d02 <main+0x52>
