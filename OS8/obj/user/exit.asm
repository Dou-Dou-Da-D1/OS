
obj/__user_exit.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a285                	j	800184 <sys_open>

0000000000800026 <close>:
  800026:	a2a5                	j	80018e <sys_close>

0000000000800028 <dup2>:
  800028:	a2bd                	j	800196 <sys_dup>

000000000080002a <_start>:
  80002a:	1f4000ef          	jal	80021e <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	79250513          	addi	a0,a0,1938 # 8007d0 <main+0x118>
  800046:	ec06                	sd	ra,24(sp)
  800048:	f436                	sd	a3,40(sp)
  80004a:	f83a                	sd	a4,48(sp)
  80004c:	fc3e                	sd	a5,56(sp)
  80004e:	e0c2                	sd	a6,64(sp)
  800050:	e4c6                	sd	a7,72(sp)
  800052:	e41a                	sd	t1,8(sp)
  800054:	0a0000ef          	jal	8000f4 <cprintf>
  800058:	65a2                	ld	a1,8(sp)
  80005a:	8522                	mv	a0,s0
  80005c:	072000ef          	jal	8000ce <vcprintf>
  800060:	00000517          	auipc	a0,0x0
  800064:	79050513          	addi	a0,a0,1936 # 8007f0 <main+0x138>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	132000ef          	jal	8001a0 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	77850513          	addi	a0,a0,1912 # 8007f8 <main+0x140>
  800088:	ec06                	sd	ra,24(sp)
  80008a:	f436                	sd	a3,40(sp)
  80008c:	f83a                	sd	a4,48(sp)
  80008e:	fc3e                	sd	a5,56(sp)
  800090:	e0c2                	sd	a6,64(sp)
  800092:	e4c6                	sd	a7,72(sp)
  800094:	e41a                	sd	t1,8(sp)
  800096:	05e000ef          	jal	8000f4 <cprintf>
  80009a:	65a2                	ld	a1,8(sp)
  80009c:	8522                	mv	a0,s0
  80009e:	030000ef          	jal	8000ce <vcprintf>
  8000a2:	00000517          	auipc	a0,0x0
  8000a6:	74e50513          	addi	a0,a0,1870 # 8007f0 <main+0x138>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0c2000ef          	jal	80017e <sys_putc>
  8000c0:	65a2                	ld	a1,8(sp)
  8000c2:	60e2                	ld	ra,24(sp)
  8000c4:	419c                	lw	a5,0(a1)
  8000c6:	2785                	addiw	a5,a5,1
  8000c8:	c19c                	sw	a5,0(a1)
  8000ca:	6105                	addi	sp,sp,32
  8000cc:	8082                	ret

00000000008000ce <vcprintf>:
  8000ce:	1101                	addi	sp,sp,-32
  8000d0:	872e                	mv	a4,a1
  8000d2:	75dd                	lui	a1,0xffff7
  8000d4:	86aa                	mv	a3,a0
  8000d6:	0070                	addi	a2,sp,12
  8000d8:	00000517          	auipc	a0,0x0
  8000dc:	fde50513          	addi	a0,a0,-34 # 8000b6 <cputch>
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	21a000ef          	jal	800302 <vprintfmt>
  8000ec:	60e2                	ld	ra,24(sp)
  8000ee:	4532                	lw	a0,12(sp)
  8000f0:	6105                	addi	sp,sp,32
  8000f2:	8082                	ret

00000000008000f4 <cprintf>:
  8000f4:	711d                	addi	sp,sp,-96
  8000f6:	02810313          	addi	t1,sp,40
  8000fa:	f42e                	sd	a1,40(sp)
  8000fc:	75dd                	lui	a1,0xffff7
  8000fe:	f832                	sd	a2,48(sp)
  800100:	fc36                	sd	a3,56(sp)
  800102:	e0ba                	sd	a4,64(sp)
  800104:	86aa                	mv	a3,a0
  800106:	0050                	addi	a2,sp,4
  800108:	00000517          	auipc	a0,0x0
  80010c:	fae50513          	addi	a0,a0,-82 # 8000b6 <cputch>
  800110:	871a                	mv	a4,t1
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <magic+0xffffffffff7f5ad9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1e0000ef          	jal	800302 <vprintfmt>
  800126:	60e2                	ld	ra,24(sp)
  800128:	4512                	lw	a0,4(sp)
  80012a:	6125                	addi	sp,sp,96
  80012c:	8082                	ret

000000000080012e <syscall>:
  80012e:	7175                	addi	sp,sp,-144
  800130:	08010313          	addi	t1,sp,128
  800134:	e42a                	sd	a0,8(sp)
  800136:	ecae                	sd	a1,88(sp)
  800138:	f42e                	sd	a1,40(sp)
  80013a:	f0b2                	sd	a2,96(sp)
  80013c:	f832                	sd	a2,48(sp)
  80013e:	f4b6                	sd	a3,104(sp)
  800140:	fc36                	sd	a3,56(sp)
  800142:	f8ba                	sd	a4,112(sp)
  800144:	e0ba                	sd	a4,64(sp)
  800146:	fcbe                	sd	a5,120(sp)
  800148:	e4be                	sd	a5,72(sp)
  80014a:	e142                	sd	a6,128(sp)
  80014c:	e546                	sd	a7,136(sp)
  80014e:	f01a                	sd	t1,32(sp)
  800150:	4522                	lw	a0,8(sp)
  800152:	55a2                	lw	a1,40(sp)
  800154:	5642                	lw	a2,48(sp)
  800156:	56e2                	lw	a3,56(sp)
  800158:	4706                	lw	a4,64(sp)
  80015a:	47a6                	lw	a5,72(sp)
  80015c:	00000073          	ecall
  800160:	ce2a                	sw	a0,28(sp)
  800162:	4572                	lw	a0,28(sp)
  800164:	6149                	addi	sp,sp,144
  800166:	8082                	ret

0000000000800168 <sys_exit>:
  800168:	85aa                	mv	a1,a0
  80016a:	4505                	li	a0,1
  80016c:	b7c9                	j	80012e <syscall>

000000000080016e <sys_fork>:
  80016e:	4509                	li	a0,2
  800170:	bf7d                	j	80012e <syscall>

0000000000800172 <sys_wait>:
  800172:	862e                	mv	a2,a1
  800174:	85aa                	mv	a1,a0
  800176:	450d                	li	a0,3
  800178:	bf5d                	j	80012e <syscall>

000000000080017a <sys_yield>:
  80017a:	4529                	li	a0,10
  80017c:	bf4d                	j	80012e <syscall>

000000000080017e <sys_putc>:
  80017e:	85aa                	mv	a1,a0
  800180:	4579                	li	a0,30
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_open>:
  800184:	862e                	mv	a2,a1
  800186:	85aa                	mv	a1,a0
  800188:	06400513          	li	a0,100
  80018c:	b74d                	j	80012e <syscall>

000000000080018e <sys_close>:
  80018e:	85aa                	mv	a1,a0
  800190:	06500513          	li	a0,101
  800194:	bf69                	j	80012e <syscall>

0000000000800196 <sys_dup>:
  800196:	862e                	mv	a2,a1
  800198:	85aa                	mv	a1,a0
  80019a:	08200513          	li	a0,130
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <exit>:
  8001a0:	1141                	addi	sp,sp,-16
  8001a2:	e406                	sd	ra,8(sp)
  8001a4:	fc5ff0ef          	jal	800168 <sys_exit>
  8001a8:	00000517          	auipc	a0,0x0
  8001ac:	67050513          	addi	a0,a0,1648 # 800818 <main+0x160>
  8001b0:	f45ff0ef          	jal	8000f4 <cprintf>
  8001b4:	a001                	j	8001b4 <exit+0x14>

00000000008001b6 <fork>:
  8001b6:	bf65                	j	80016e <sys_fork>

00000000008001b8 <wait>:
  8001b8:	4581                	li	a1,0
  8001ba:	4501                	li	a0,0
  8001bc:	bf5d                	j	800172 <sys_wait>

00000000008001be <waitpid>:
  8001be:	1101                	addi	sp,sp,-32
  8001c0:	e822                	sd	s0,16(sp)
  8001c2:	842e                	mv	s0,a1
  8001c4:	002c                	addi	a1,sp,8
  8001c6:	ec06                	sd	ra,24(sp)
  8001c8:	fabff0ef          	jal	800172 <sys_wait>
  8001cc:	c019                	beqz	s0,8001d2 <waitpid+0x14>
  8001ce:	67a2                	ld	a5,8(sp)
  8001d0:	c01c                	sw	a5,0(s0)
  8001d2:	60e2                	ld	ra,24(sp)
  8001d4:	6442                	ld	s0,16(sp)
  8001d6:	6105                	addi	sp,sp,32
  8001d8:	8082                	ret

00000000008001da <yield>:
  8001da:	b745                	j	80017a <sys_yield>

00000000008001dc <initfd>:
  8001dc:	87ae                	mv	a5,a1
  8001de:	1101                	addi	sp,sp,-32
  8001e0:	e822                	sd	s0,16(sp)
  8001e2:	85b2                	mv	a1,a2
  8001e4:	842a                	mv	s0,a0
  8001e6:	853e                	mv	a0,a5
  8001e8:	ec06                	sd	ra,24(sp)
  8001ea:	e37ff0ef          	jal	800020 <open>
  8001ee:	87aa                	mv	a5,a0
  8001f0:	00054463          	bltz	a0,8001f8 <initfd+0x1c>
  8001f4:	00851763          	bne	a0,s0,800202 <initfd+0x26>
  8001f8:	60e2                	ld	ra,24(sp)
  8001fa:	6442                	ld	s0,16(sp)
  8001fc:	853e                	mv	a0,a5
  8001fe:	6105                	addi	sp,sp,32
  800200:	8082                	ret
  800202:	e42a                	sd	a0,8(sp)
  800204:	8522                	mv	a0,s0
  800206:	e21ff0ef          	jal	800026 <close>
  80020a:	6522                	ld	a0,8(sp)
  80020c:	85a2                	mv	a1,s0
  80020e:	e1bff0ef          	jal	800028 <dup2>
  800212:	842a                	mv	s0,a0
  800214:	6522                	ld	a0,8(sp)
  800216:	e11ff0ef          	jal	800026 <close>
  80021a:	87a2                	mv	a5,s0
  80021c:	bff1                	j	8001f8 <initfd+0x1c>

000000000080021e <umain>:
  80021e:	1101                	addi	sp,sp,-32
  800220:	e822                	sd	s0,16(sp)
  800222:	e426                	sd	s1,8(sp)
  800224:	842a                	mv	s0,a0
  800226:	84ae                	mv	s1,a1
  800228:	4601                	li	a2,0
  80022a:	00000597          	auipc	a1,0x0
  80022e:	60658593          	addi	a1,a1,1542 # 800830 <main+0x178>
  800232:	4501                	li	a0,0
  800234:	ec06                	sd	ra,24(sp)
  800236:	fa7ff0ef          	jal	8001dc <initfd>
  80023a:	02054263          	bltz	a0,80025e <umain+0x40>
  80023e:	4605                	li	a2,1
  800240:	8532                	mv	a0,a2
  800242:	00000597          	auipc	a1,0x0
  800246:	62e58593          	addi	a1,a1,1582 # 800870 <main+0x1b8>
  80024a:	f93ff0ef          	jal	8001dc <initfd>
  80024e:	02054563          	bltz	a0,800278 <umain+0x5a>
  800252:	85a6                	mv	a1,s1
  800254:	8522                	mv	a0,s0
  800256:	462000ef          	jal	8006b8 <main>
  80025a:	f47ff0ef          	jal	8001a0 <exit>
  80025e:	86aa                	mv	a3,a0
  800260:	00000617          	auipc	a2,0x0
  800264:	5d860613          	addi	a2,a2,1496 # 800838 <main+0x180>
  800268:	45e9                	li	a1,26
  80026a:	00000517          	auipc	a0,0x0
  80026e:	5ee50513          	addi	a0,a0,1518 # 800858 <main+0x1a0>
  800272:	e01ff0ef          	jal	800072 <__warn>
  800276:	b7e1                	j	80023e <umain+0x20>
  800278:	86aa                	mv	a3,a0
  80027a:	00000617          	auipc	a2,0x0
  80027e:	5fe60613          	addi	a2,a2,1534 # 800878 <main+0x1c0>
  800282:	45f5                	li	a1,29
  800284:	00000517          	auipc	a0,0x0
  800288:	5d450513          	addi	a0,a0,1492 # 800858 <main+0x1a0>
  80028c:	de7ff0ef          	jal	800072 <__warn>
  800290:	b7c9                	j	800252 <umain+0x34>

0000000000800292 <printnum>:
  800292:	7139                	addi	sp,sp,-64
  800294:	02071893          	slli	a7,a4,0x20
  800298:	f822                	sd	s0,48(sp)
  80029a:	f426                	sd	s1,40(sp)
  80029c:	f04a                	sd	s2,32(sp)
  80029e:	ec4e                	sd	s3,24(sp)
  8002a0:	e456                	sd	s5,8(sp)
  8002a2:	0208d893          	srli	a7,a7,0x20
  8002a6:	fc06                	sd	ra,56(sp)
  8002a8:	0316fab3          	remu	s5,a3,a7
  8002ac:	fff7841b          	addiw	s0,a5,-1
  8002b0:	84aa                	mv	s1,a0
  8002b2:	89ae                	mv	s3,a1
  8002b4:	8932                	mv	s2,a2
  8002b6:	0516f063          	bgeu	a3,a7,8002f6 <printnum+0x64>
  8002ba:	e852                	sd	s4,16(sp)
  8002bc:	4705                	li	a4,1
  8002be:	8a42                	mv	s4,a6
  8002c0:	00f75863          	bge	a4,a5,8002d0 <printnum+0x3e>
  8002c4:	864e                	mv	a2,s3
  8002c6:	85ca                	mv	a1,s2
  8002c8:	8552                	mv	a0,s4
  8002ca:	347d                	addiw	s0,s0,-1
  8002cc:	9482                	jalr	s1
  8002ce:	f87d                	bnez	s0,8002c4 <printnum+0x32>
  8002d0:	6a42                	ld	s4,16(sp)
  8002d2:	00000797          	auipc	a5,0x0
  8002d6:	5c678793          	addi	a5,a5,1478 # 800898 <main+0x1e0>
  8002da:	97d6                	add	a5,a5,s5
  8002dc:	7442                	ld	s0,48(sp)
  8002de:	0007c503          	lbu	a0,0(a5)
  8002e2:	70e2                	ld	ra,56(sp)
  8002e4:	6aa2                	ld	s5,8(sp)
  8002e6:	864e                	mv	a2,s3
  8002e8:	85ca                	mv	a1,s2
  8002ea:	69e2                	ld	s3,24(sp)
  8002ec:	7902                	ld	s2,32(sp)
  8002ee:	87a6                	mv	a5,s1
  8002f0:	74a2                	ld	s1,40(sp)
  8002f2:	6121                	addi	sp,sp,64
  8002f4:	8782                	jr	a5
  8002f6:	0316d6b3          	divu	a3,a3,a7
  8002fa:	87a2                	mv	a5,s0
  8002fc:	f97ff0ef          	jal	800292 <printnum>
  800300:	bfc9                	j	8002d2 <printnum+0x40>

0000000000800302 <vprintfmt>:
  800302:	7119                	addi	sp,sp,-128
  800304:	f4a6                	sd	s1,104(sp)
  800306:	f0ca                	sd	s2,96(sp)
  800308:	ecce                	sd	s3,88(sp)
  80030a:	e8d2                	sd	s4,80(sp)
  80030c:	e4d6                	sd	s5,72(sp)
  80030e:	e0da                	sd	s6,64(sp)
  800310:	fc5e                	sd	s7,56(sp)
  800312:	f466                	sd	s9,40(sp)
  800314:	fc86                	sd	ra,120(sp)
  800316:	f8a2                	sd	s0,112(sp)
  800318:	f862                	sd	s8,48(sp)
  80031a:	f06a                	sd	s10,32(sp)
  80031c:	ec6e                	sd	s11,24(sp)
  80031e:	84aa                	mv	s1,a0
  800320:	8cb6                	mv	s9,a3
  800322:	8aba                	mv	s5,a4
  800324:	89ae                	mv	s3,a1
  800326:	8932                	mv	s2,a2
  800328:	02500a13          	li	s4,37
  80032c:	05500b93          	li	s7,85
  800330:	00001b17          	auipc	s6,0x1
  800334:	8a4b0b13          	addi	s6,s6,-1884 # 800bd4 <main+0x51c>
  800338:	000cc503          	lbu	a0,0(s9)
  80033c:	001c8413          	addi	s0,s9,1
  800340:	01450b63          	beq	a0,s4,800356 <vprintfmt+0x54>
  800344:	cd15                	beqz	a0,800380 <vprintfmt+0x7e>
  800346:	864e                	mv	a2,s3
  800348:	85ca                	mv	a1,s2
  80034a:	9482                	jalr	s1
  80034c:	00044503          	lbu	a0,0(s0)
  800350:	0405                	addi	s0,s0,1
  800352:	ff4519e3          	bne	a0,s4,800344 <vprintfmt+0x42>
  800356:	5d7d                	li	s10,-1
  800358:	8dea                	mv	s11,s10
  80035a:	02000813          	li	a6,32
  80035e:	4c01                	li	s8,0
  800360:	4581                	li	a1,0
  800362:	00044703          	lbu	a4,0(s0)
  800366:	00140c93          	addi	s9,s0,1
  80036a:	fdd7061b          	addiw	a2,a4,-35
  80036e:	0ff67613          	zext.b	a2,a2
  800372:	02cbe663          	bltu	s7,a2,80039e <vprintfmt+0x9c>
  800376:	060a                	slli	a2,a2,0x2
  800378:	965a                	add	a2,a2,s6
  80037a:	421c                	lw	a5,0(a2)
  80037c:	97da                	add	a5,a5,s6
  80037e:	8782                	jr	a5
  800380:	70e6                	ld	ra,120(sp)
  800382:	7446                	ld	s0,112(sp)
  800384:	74a6                	ld	s1,104(sp)
  800386:	7906                	ld	s2,96(sp)
  800388:	69e6                	ld	s3,88(sp)
  80038a:	6a46                	ld	s4,80(sp)
  80038c:	6aa6                	ld	s5,72(sp)
  80038e:	6b06                	ld	s6,64(sp)
  800390:	7be2                	ld	s7,56(sp)
  800392:	7c42                	ld	s8,48(sp)
  800394:	7ca2                	ld	s9,40(sp)
  800396:	7d02                	ld	s10,32(sp)
  800398:	6de2                	ld	s11,24(sp)
  80039a:	6109                	addi	sp,sp,128
  80039c:	8082                	ret
  80039e:	864e                	mv	a2,s3
  8003a0:	85ca                	mv	a1,s2
  8003a2:	02500513          	li	a0,37
  8003a6:	9482                	jalr	s1
  8003a8:	fff44783          	lbu	a5,-1(s0)
  8003ac:	02500713          	li	a4,37
  8003b0:	8ca2                	mv	s9,s0
  8003b2:	f8e783e3          	beq	a5,a4,800338 <vprintfmt+0x36>
  8003b6:	ffecc783          	lbu	a5,-2(s9)
  8003ba:	1cfd                	addi	s9,s9,-1
  8003bc:	fee79de3          	bne	a5,a4,8003b6 <vprintfmt+0xb4>
  8003c0:	bfa5                	j	800338 <vprintfmt+0x36>
  8003c2:	00144683          	lbu	a3,1(s0)
  8003c6:	4525                	li	a0,9
  8003c8:	fd070d1b          	addiw	s10,a4,-48
  8003cc:	fd06879b          	addiw	a5,a3,-48
  8003d0:	28f56063          	bltu	a0,a5,800650 <vprintfmt+0x34e>
  8003d4:	2681                	sext.w	a3,a3
  8003d6:	8466                	mv	s0,s9
  8003d8:	002d179b          	slliw	a5,s10,0x2
  8003dc:	00144703          	lbu	a4,1(s0)
  8003e0:	01a787bb          	addw	a5,a5,s10
  8003e4:	0017979b          	slliw	a5,a5,0x1
  8003e8:	9fb5                	addw	a5,a5,a3
  8003ea:	fd07061b          	addiw	a2,a4,-48
  8003ee:	0405                	addi	s0,s0,1
  8003f0:	fd078d1b          	addiw	s10,a5,-48
  8003f4:	0007069b          	sext.w	a3,a4
  8003f8:	fec570e3          	bgeu	a0,a2,8003d8 <vprintfmt+0xd6>
  8003fc:	f60dd3e3          	bgez	s11,800362 <vprintfmt+0x60>
  800400:	8dea                	mv	s11,s10
  800402:	5d7d                	li	s10,-1
  800404:	bfb9                	j	800362 <vprintfmt+0x60>
  800406:	883a                	mv	a6,a4
  800408:	8466                	mv	s0,s9
  80040a:	bfa1                	j	800362 <vprintfmt+0x60>
  80040c:	8466                	mv	s0,s9
  80040e:	4c05                	li	s8,1
  800410:	bf89                	j	800362 <vprintfmt+0x60>
  800412:	4785                	li	a5,1
  800414:	008a8613          	addi	a2,s5,8
  800418:	00b7c463          	blt	a5,a1,800420 <vprintfmt+0x11e>
  80041c:	1c058363          	beqz	a1,8005e2 <vprintfmt+0x2e0>
  800420:	000ab683          	ld	a3,0(s5)
  800424:	4741                	li	a4,16
  800426:	8ab2                	mv	s5,a2
  800428:	2801                	sext.w	a6,a6
  80042a:	87ee                	mv	a5,s11
  80042c:	864a                	mv	a2,s2
  80042e:	85ce                	mv	a1,s3
  800430:	8526                	mv	a0,s1
  800432:	e61ff0ef          	jal	800292 <printnum>
  800436:	b709                	j	800338 <vprintfmt+0x36>
  800438:	000aa503          	lw	a0,0(s5)
  80043c:	864e                	mv	a2,s3
  80043e:	85ca                	mv	a1,s2
  800440:	9482                	jalr	s1
  800442:	0aa1                	addi	s5,s5,8
  800444:	bdd5                	j	800338 <vprintfmt+0x36>
  800446:	4785                	li	a5,1
  800448:	008a8613          	addi	a2,s5,8
  80044c:	00b7c463          	blt	a5,a1,800454 <vprintfmt+0x152>
  800450:	18058463          	beqz	a1,8005d8 <vprintfmt+0x2d6>
  800454:	000ab683          	ld	a3,0(s5)
  800458:	4729                	li	a4,10
  80045a:	8ab2                	mv	s5,a2
  80045c:	b7f1                	j	800428 <vprintfmt+0x126>
  80045e:	864e                	mv	a2,s3
  800460:	85ca                	mv	a1,s2
  800462:	03000513          	li	a0,48
  800466:	e042                	sd	a6,0(sp)
  800468:	9482                	jalr	s1
  80046a:	864e                	mv	a2,s3
  80046c:	85ca                	mv	a1,s2
  80046e:	07800513          	li	a0,120
  800472:	9482                	jalr	s1
  800474:	000ab683          	ld	a3,0(s5)
  800478:	6802                	ld	a6,0(sp)
  80047a:	4741                	li	a4,16
  80047c:	0aa1                	addi	s5,s5,8
  80047e:	b76d                	j	800428 <vprintfmt+0x126>
  800480:	864e                	mv	a2,s3
  800482:	85ca                	mv	a1,s2
  800484:	02500513          	li	a0,37
  800488:	9482                	jalr	s1
  80048a:	b57d                	j	800338 <vprintfmt+0x36>
  80048c:	000aad03          	lw	s10,0(s5)
  800490:	8466                	mv	s0,s9
  800492:	0aa1                	addi	s5,s5,8
  800494:	b7a5                	j	8003fc <vprintfmt+0xfa>
  800496:	4785                	li	a5,1
  800498:	008a8613          	addi	a2,s5,8
  80049c:	00b7c463          	blt	a5,a1,8004a4 <vprintfmt+0x1a2>
  8004a0:	12058763          	beqz	a1,8005ce <vprintfmt+0x2cc>
  8004a4:	000ab683          	ld	a3,0(s5)
  8004a8:	4721                	li	a4,8
  8004aa:	8ab2                	mv	s5,a2
  8004ac:	bfb5                	j	800428 <vprintfmt+0x126>
  8004ae:	87ee                	mv	a5,s11
  8004b0:	000dd363          	bgez	s11,8004b6 <vprintfmt+0x1b4>
  8004b4:	4781                	li	a5,0
  8004b6:	00078d9b          	sext.w	s11,a5
  8004ba:	8466                	mv	s0,s9
  8004bc:	b55d                	j	800362 <vprintfmt+0x60>
  8004be:	0008041b          	sext.w	s0,a6
  8004c2:	fd340793          	addi	a5,s0,-45
  8004c6:	01b02733          	sgtz	a4,s11
  8004ca:	00f037b3          	snez	a5,a5
  8004ce:	8ff9                	and	a5,a5,a4
  8004d0:	000ab703          	ld	a4,0(s5)
  8004d4:	008a8693          	addi	a3,s5,8
  8004d8:	e436                	sd	a3,8(sp)
  8004da:	12070563          	beqz	a4,800604 <vprintfmt+0x302>
  8004de:	12079d63          	bnez	a5,800618 <vprintfmt+0x316>
  8004e2:	00074783          	lbu	a5,0(a4)
  8004e6:	0007851b          	sext.w	a0,a5
  8004ea:	c78d                	beqz	a5,800514 <vprintfmt+0x212>
  8004ec:	00170a93          	addi	s5,a4,1
  8004f0:	547d                	li	s0,-1
  8004f2:	000d4563          	bltz	s10,8004fc <vprintfmt+0x1fa>
  8004f6:	3d7d                	addiw	s10,s10,-1
  8004f8:	008d0e63          	beq	s10,s0,800514 <vprintfmt+0x212>
  8004fc:	020c1863          	bnez	s8,80052c <vprintfmt+0x22a>
  800500:	864e                	mv	a2,s3
  800502:	85ca                	mv	a1,s2
  800504:	9482                	jalr	s1
  800506:	000ac783          	lbu	a5,0(s5)
  80050a:	0a85                	addi	s5,s5,1
  80050c:	3dfd                	addiw	s11,s11,-1
  80050e:	0007851b          	sext.w	a0,a5
  800512:	f3e5                	bnez	a5,8004f2 <vprintfmt+0x1f0>
  800514:	01b05a63          	blez	s11,800528 <vprintfmt+0x226>
  800518:	864e                	mv	a2,s3
  80051a:	85ca                	mv	a1,s2
  80051c:	02000513          	li	a0,32
  800520:	3dfd                	addiw	s11,s11,-1
  800522:	9482                	jalr	s1
  800524:	fe0d9ae3          	bnez	s11,800518 <vprintfmt+0x216>
  800528:	6aa2                	ld	s5,8(sp)
  80052a:	b539                	j	800338 <vprintfmt+0x36>
  80052c:	3781                	addiw	a5,a5,-32
  80052e:	05e00713          	li	a4,94
  800532:	fcf777e3          	bgeu	a4,a5,800500 <vprintfmt+0x1fe>
  800536:	03f00513          	li	a0,63
  80053a:	864e                	mv	a2,s3
  80053c:	85ca                	mv	a1,s2
  80053e:	9482                	jalr	s1
  800540:	000ac783          	lbu	a5,0(s5)
  800544:	0a85                	addi	s5,s5,1
  800546:	3dfd                	addiw	s11,s11,-1
  800548:	0007851b          	sext.w	a0,a5
  80054c:	d7e1                	beqz	a5,800514 <vprintfmt+0x212>
  80054e:	fa0d54e3          	bgez	s10,8004f6 <vprintfmt+0x1f4>
  800552:	bfe9                	j	80052c <vprintfmt+0x22a>
  800554:	000aa783          	lw	a5,0(s5)
  800558:	46e1                	li	a3,24
  80055a:	0aa1                	addi	s5,s5,8
  80055c:	41f7d71b          	sraiw	a4,a5,0x1f
  800560:	8fb9                	xor	a5,a5,a4
  800562:	40e7873b          	subw	a4,a5,a4
  800566:	02e6c663          	blt	a3,a4,800592 <vprintfmt+0x290>
  80056a:	00000797          	auipc	a5,0x0
  80056e:	7c678793          	addi	a5,a5,1990 # 800d30 <error_string>
  800572:	00371693          	slli	a3,a4,0x3
  800576:	97b6                	add	a5,a5,a3
  800578:	639c                	ld	a5,0(a5)
  80057a:	cf81                	beqz	a5,800592 <vprintfmt+0x290>
  80057c:	873e                	mv	a4,a5
  80057e:	00000697          	auipc	a3,0x0
  800582:	34a68693          	addi	a3,a3,842 # 8008c8 <main+0x210>
  800586:	864a                	mv	a2,s2
  800588:	85ce                	mv	a1,s3
  80058a:	8526                	mv	a0,s1
  80058c:	0f2000ef          	jal	80067e <printfmt>
  800590:	b365                	j	800338 <vprintfmt+0x36>
  800592:	00000697          	auipc	a3,0x0
  800596:	32668693          	addi	a3,a3,806 # 8008b8 <main+0x200>
  80059a:	864a                	mv	a2,s2
  80059c:	85ce                	mv	a1,s3
  80059e:	8526                	mv	a0,s1
  8005a0:	0de000ef          	jal	80067e <printfmt>
  8005a4:	bb51                	j	800338 <vprintfmt+0x36>
  8005a6:	4785                	li	a5,1
  8005a8:	008a8c13          	addi	s8,s5,8
  8005ac:	00b7c363          	blt	a5,a1,8005b2 <vprintfmt+0x2b0>
  8005b0:	cd81                	beqz	a1,8005c8 <vprintfmt+0x2c6>
  8005b2:	000ab403          	ld	s0,0(s5)
  8005b6:	02044b63          	bltz	s0,8005ec <vprintfmt+0x2ea>
  8005ba:	86a2                	mv	a3,s0
  8005bc:	8ae2                	mv	s5,s8
  8005be:	4729                	li	a4,10
  8005c0:	b5a5                	j	800428 <vprintfmt+0x126>
  8005c2:	2585                	addiw	a1,a1,1
  8005c4:	8466                	mv	s0,s9
  8005c6:	bb71                	j	800362 <vprintfmt+0x60>
  8005c8:	000aa403          	lw	s0,0(s5)
  8005cc:	b7ed                	j	8005b6 <vprintfmt+0x2b4>
  8005ce:	000ae683          	lwu	a3,0(s5)
  8005d2:	4721                	li	a4,8
  8005d4:	8ab2                	mv	s5,a2
  8005d6:	bd89                	j	800428 <vprintfmt+0x126>
  8005d8:	000ae683          	lwu	a3,0(s5)
  8005dc:	4729                	li	a4,10
  8005de:	8ab2                	mv	s5,a2
  8005e0:	b5a1                	j	800428 <vprintfmt+0x126>
  8005e2:	000ae683          	lwu	a3,0(s5)
  8005e6:	4741                	li	a4,16
  8005e8:	8ab2                	mv	s5,a2
  8005ea:	bd3d                	j	800428 <vprintfmt+0x126>
  8005ec:	864e                	mv	a2,s3
  8005ee:	85ca                	mv	a1,s2
  8005f0:	02d00513          	li	a0,45
  8005f4:	e042                	sd	a6,0(sp)
  8005f6:	9482                	jalr	s1
  8005f8:	6802                	ld	a6,0(sp)
  8005fa:	408006b3          	neg	a3,s0
  8005fe:	8ae2                	mv	s5,s8
  800600:	4729                	li	a4,10
  800602:	b51d                	j	800428 <vprintfmt+0x126>
  800604:	eba1                	bnez	a5,800654 <vprintfmt+0x352>
  800606:	02800793          	li	a5,40
  80060a:	853e                	mv	a0,a5
  80060c:	00000a97          	auipc	s5,0x0
  800610:	2a5a8a93          	addi	s5,s5,677 # 8008b1 <main+0x1f9>
  800614:	547d                	li	s0,-1
  800616:	bdf1                	j	8004f2 <vprintfmt+0x1f0>
  800618:	853a                	mv	a0,a4
  80061a:	85ea                	mv	a1,s10
  80061c:	e03a                	sd	a4,0(sp)
  80061e:	07e000ef          	jal	80069c <strnlen>
  800622:	40ad8dbb          	subw	s11,s11,a0
  800626:	6702                	ld	a4,0(sp)
  800628:	01b05b63          	blez	s11,80063e <vprintfmt+0x33c>
  80062c:	864e                	mv	a2,s3
  80062e:	85ca                	mv	a1,s2
  800630:	8522                	mv	a0,s0
  800632:	e03a                	sd	a4,0(sp)
  800634:	3dfd                	addiw	s11,s11,-1
  800636:	9482                	jalr	s1
  800638:	6702                	ld	a4,0(sp)
  80063a:	fe0d99e3          	bnez	s11,80062c <vprintfmt+0x32a>
  80063e:	00074783          	lbu	a5,0(a4)
  800642:	0007851b          	sext.w	a0,a5
  800646:	ee0781e3          	beqz	a5,800528 <vprintfmt+0x226>
  80064a:	00170a93          	addi	s5,a4,1
  80064e:	b54d                	j	8004f0 <vprintfmt+0x1ee>
  800650:	8466                	mv	s0,s9
  800652:	b36d                	j	8003fc <vprintfmt+0xfa>
  800654:	85ea                	mv	a1,s10
  800656:	00000517          	auipc	a0,0x0
  80065a:	25a50513          	addi	a0,a0,602 # 8008b0 <main+0x1f8>
  80065e:	03e000ef          	jal	80069c <strnlen>
  800662:	40ad8dbb          	subw	s11,s11,a0
  800666:	02800793          	li	a5,40
  80066a:	00000717          	auipc	a4,0x0
  80066e:	24670713          	addi	a4,a4,582 # 8008b0 <main+0x1f8>
  800672:	853e                	mv	a0,a5
  800674:	fbb04ce3          	bgtz	s11,80062c <vprintfmt+0x32a>
  800678:	00170a93          	addi	s5,a4,1
  80067c:	bd95                	j	8004f0 <vprintfmt+0x1ee>

000000000080067e <printfmt>:
  80067e:	7139                	addi	sp,sp,-64
  800680:	02010313          	addi	t1,sp,32
  800684:	f03a                	sd	a4,32(sp)
  800686:	871a                	mv	a4,t1
  800688:	ec06                	sd	ra,24(sp)
  80068a:	f43e                	sd	a5,40(sp)
  80068c:	f842                	sd	a6,48(sp)
  80068e:	fc46                	sd	a7,56(sp)
  800690:	e41a                	sd	t1,8(sp)
  800692:	c71ff0ef          	jal	800302 <vprintfmt>
  800696:	60e2                	ld	ra,24(sp)
  800698:	6121                	addi	sp,sp,64
  80069a:	8082                	ret

000000000080069c <strnlen>:
  80069c:	4781                	li	a5,0
  80069e:	e589                	bnez	a1,8006a8 <strnlen+0xc>
  8006a0:	a811                	j	8006b4 <strnlen+0x18>
  8006a2:	0785                	addi	a5,a5,1
  8006a4:	00f58863          	beq	a1,a5,8006b4 <strnlen+0x18>
  8006a8:	00f50733          	add	a4,a0,a5
  8006ac:	00074703          	lbu	a4,0(a4)
  8006b0:	fb6d                	bnez	a4,8006a2 <strnlen+0x6>
  8006b2:	85be                	mv	a1,a5
  8006b4:	852e                	mv	a0,a1
  8006b6:	8082                	ret

00000000008006b8 <main>:
  8006b8:	1101                	addi	sp,sp,-32
  8006ba:	00000517          	auipc	a0,0x0
  8006be:	3ee50513          	addi	a0,a0,1006 # 800aa8 <main+0x3f0>
  8006c2:	ec06                	sd	ra,24(sp)
  8006c4:	e822                	sd	s0,16(sp)
  8006c6:	a2fff0ef          	jal	8000f4 <cprintf>
  8006ca:	aedff0ef          	jal	8001b6 <fork>
  8006ce:	c561                	beqz	a0,800796 <main+0xde>
  8006d0:	842a                	mv	s0,a0
  8006d2:	85aa                	mv	a1,a0
  8006d4:	00000517          	auipc	a0,0x0
  8006d8:	41450513          	addi	a0,a0,1044 # 800ae8 <main+0x430>
  8006dc:	a19ff0ef          	jal	8000f4 <cprintf>
  8006e0:	08805c63          	blez	s0,800778 <main+0xc0>
  8006e4:	00000517          	auipc	a0,0x0
  8006e8:	45c50513          	addi	a0,a0,1116 # 800b40 <main+0x488>
  8006ec:	a09ff0ef          	jal	8000f4 <cprintf>
  8006f0:	006c                	addi	a1,sp,12
  8006f2:	8522                	mv	a0,s0
  8006f4:	acbff0ef          	jal	8001be <waitpid>
  8006f8:	e131                	bnez	a0,80073c <main+0x84>
  8006fa:	4732                	lw	a4,12(sp)
  8006fc:	00001797          	auipc	a5,0x1
  800700:	9047a783          	lw	a5,-1788(a5) # 801000 <magic>
  800704:	02f71c63          	bne	a4,a5,80073c <main+0x84>
  800708:	006c                	addi	a1,sp,12
  80070a:	8522                	mv	a0,s0
  80070c:	ab3ff0ef          	jal	8001be <waitpid>
  800710:	c529                	beqz	a0,80075a <main+0xa2>
  800712:	aa7ff0ef          	jal	8001b8 <wait>
  800716:	c131                	beqz	a0,80075a <main+0xa2>
  800718:	85a2                	mv	a1,s0
  80071a:	00000517          	auipc	a0,0x0
  80071e:	49e50513          	addi	a0,a0,1182 # 800bb8 <main+0x500>
  800722:	9d3ff0ef          	jal	8000f4 <cprintf>
  800726:	00000517          	auipc	a0,0x0
  80072a:	4a250513          	addi	a0,a0,1186 # 800bc8 <main+0x510>
  80072e:	9c7ff0ef          	jal	8000f4 <cprintf>
  800732:	60e2                	ld	ra,24(sp)
  800734:	6442                	ld	s0,16(sp)
  800736:	4501                	li	a0,0
  800738:	6105                	addi	sp,sp,32
  80073a:	8082                	ret
  80073c:	00000697          	auipc	a3,0x0
  800740:	42468693          	addi	a3,a3,1060 # 800b60 <main+0x4a8>
  800744:	00000617          	auipc	a2,0x0
  800748:	3d460613          	addi	a2,a2,980 # 800b18 <main+0x460>
  80074c:	45ed                	li	a1,27
  80074e:	00000517          	auipc	a0,0x0
  800752:	3e250513          	addi	a0,a0,994 # 800b30 <main+0x478>
  800756:	8dbff0ef          	jal	800030 <__panic>
  80075a:	00000697          	auipc	a3,0x0
  80075e:	43668693          	addi	a3,a3,1078 # 800b90 <main+0x4d8>
  800762:	00000617          	auipc	a2,0x0
  800766:	3b660613          	addi	a2,a2,950 # 800b18 <main+0x460>
  80076a:	45f1                	li	a1,28
  80076c:	00000517          	auipc	a0,0x0
  800770:	3c450513          	addi	a0,a0,964 # 800b30 <main+0x478>
  800774:	8bdff0ef          	jal	800030 <__panic>
  800778:	00000697          	auipc	a3,0x0
  80077c:	39868693          	addi	a3,a3,920 # 800b10 <main+0x458>
  800780:	00000617          	auipc	a2,0x0
  800784:	39860613          	addi	a2,a2,920 # 800b18 <main+0x460>
  800788:	45e1                	li	a1,24
  80078a:	00000517          	auipc	a0,0x0
  80078e:	3a650513          	addi	a0,a0,934 # 800b30 <main+0x478>
  800792:	89fff0ef          	jal	800030 <__panic>
  800796:	00000517          	auipc	a0,0x0
  80079a:	33a50513          	addi	a0,a0,826 # 800ad0 <main+0x418>
  80079e:	957ff0ef          	jal	8000f4 <cprintf>
  8007a2:	a39ff0ef          	jal	8001da <yield>
  8007a6:	a35ff0ef          	jal	8001da <yield>
  8007aa:	a31ff0ef          	jal	8001da <yield>
  8007ae:	a2dff0ef          	jal	8001da <yield>
  8007b2:	a29ff0ef          	jal	8001da <yield>
  8007b6:	a25ff0ef          	jal	8001da <yield>
  8007ba:	a21ff0ef          	jal	8001da <yield>
  8007be:	00001517          	auipc	a0,0x1
  8007c2:	84252503          	lw	a0,-1982(a0) # 801000 <magic>
  8007c6:	9dbff0ef          	jal	8001a0 <exit>
