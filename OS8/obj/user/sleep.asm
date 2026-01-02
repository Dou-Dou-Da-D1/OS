
obj/__user_sleep.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a29d                	j	80018a <sys_open>

0000000000800026 <close>:
  800026:	a2bd                	j	800194 <sys_close>

0000000000800028 <dup2>:
  800028:	aa95                	j	80019c <sys_dup>

000000000080002a <_start>:
  80002a:	1fa000ef          	jal	800224 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	72250513          	addi	a0,a0,1826 # 800760 <main+0x70>
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
  800064:	72050513          	addi	a0,a0,1824 # 800780 <main+0x90>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	138000ef          	jal	8001a6 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	70850513          	addi	a0,a0,1800 # 800788 <main+0x98>
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
  8000a6:	6de50513          	addi	a0,a0,1758 # 800780 <main+0x90>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0be000ef          	jal	80017a <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ea9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	220000ef          	jal	800308 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5ea9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1e6000ef          	jal	800308 <vprintfmt>
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

000000000080017a <sys_putc>:
  80017a:	85aa                	mv	a1,a0
  80017c:	4579                	li	a0,30
  80017e:	bf45                	j	80012e <syscall>

0000000000800180 <sys_sleep>:
  800180:	85aa                	mv	a1,a0
  800182:	452d                	li	a0,11
  800184:	b76d                	j	80012e <syscall>

0000000000800186 <sys_gettime>:
  800186:	4545                	li	a0,17
  800188:	b75d                	j	80012e <syscall>

000000000080018a <sys_open>:
  80018a:	862e                	mv	a2,a1
  80018c:	85aa                	mv	a1,a0
  80018e:	06400513          	li	a0,100
  800192:	bf71                	j	80012e <syscall>

0000000000800194 <sys_close>:
  800194:	85aa                	mv	a1,a0
  800196:	06500513          	li	a0,101
  80019a:	bf51                	j	80012e <syscall>

000000000080019c <sys_dup>:
  80019c:	862e                	mv	a2,a1
  80019e:	85aa                	mv	a1,a0
  8001a0:	08200513          	li	a0,130
  8001a4:	b769                	j	80012e <syscall>

00000000008001a6 <exit>:
  8001a6:	1141                	addi	sp,sp,-16
  8001a8:	e406                	sd	ra,8(sp)
  8001aa:	fbfff0ef          	jal	800168 <sys_exit>
  8001ae:	00000517          	auipc	a0,0x0
  8001b2:	5fa50513          	addi	a0,a0,1530 # 8007a8 <main+0xb8>
  8001b6:	f3fff0ef          	jal	8000f4 <cprintf>
  8001ba:	a001                	j	8001ba <exit+0x14>

00000000008001bc <fork>:
  8001bc:	bf4d                	j	80016e <sys_fork>

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

00000000008001da <gettime_msec>:
  8001da:	b775                	j	800186 <sys_gettime>

00000000008001dc <sleep>:
  8001dc:	1502                	slli	a0,a0,0x20
  8001de:	9101                	srli	a0,a0,0x20
  8001e0:	b745                	j	800180 <sys_sleep>

00000000008001e2 <initfd>:
  8001e2:	87ae                	mv	a5,a1
  8001e4:	1101                	addi	sp,sp,-32
  8001e6:	e822                	sd	s0,16(sp)
  8001e8:	85b2                	mv	a1,a2
  8001ea:	842a                	mv	s0,a0
  8001ec:	853e                	mv	a0,a5
  8001ee:	ec06                	sd	ra,24(sp)
  8001f0:	e31ff0ef          	jal	800020 <open>
  8001f4:	87aa                	mv	a5,a0
  8001f6:	00054463          	bltz	a0,8001fe <initfd+0x1c>
  8001fa:	00851763          	bne	a0,s0,800208 <initfd+0x26>
  8001fe:	60e2                	ld	ra,24(sp)
  800200:	6442                	ld	s0,16(sp)
  800202:	853e                	mv	a0,a5
  800204:	6105                	addi	sp,sp,32
  800206:	8082                	ret
  800208:	e42a                	sd	a0,8(sp)
  80020a:	8522                	mv	a0,s0
  80020c:	e1bff0ef          	jal	800026 <close>
  800210:	6522                	ld	a0,8(sp)
  800212:	85a2                	mv	a1,s0
  800214:	e15ff0ef          	jal	800028 <dup2>
  800218:	842a                	mv	s0,a0
  80021a:	6522                	ld	a0,8(sp)
  80021c:	e0bff0ef          	jal	800026 <close>
  800220:	87a2                	mv	a5,s0
  800222:	bff1                	j	8001fe <initfd+0x1c>

0000000000800224 <umain>:
  800224:	1101                	addi	sp,sp,-32
  800226:	e822                	sd	s0,16(sp)
  800228:	e426                	sd	s1,8(sp)
  80022a:	842a                	mv	s0,a0
  80022c:	84ae                	mv	s1,a1
  80022e:	4601                	li	a2,0
  800230:	00000597          	auipc	a1,0x0
  800234:	59058593          	addi	a1,a1,1424 # 8007c0 <main+0xd0>
  800238:	4501                	li	a0,0
  80023a:	ec06                	sd	ra,24(sp)
  80023c:	fa7ff0ef          	jal	8001e2 <initfd>
  800240:	02054263          	bltz	a0,800264 <umain+0x40>
  800244:	4605                	li	a2,1
  800246:	8532                	mv	a0,a2
  800248:	00000597          	auipc	a1,0x0
  80024c:	5b858593          	addi	a1,a1,1464 # 800800 <main+0x110>
  800250:	f93ff0ef          	jal	8001e2 <initfd>
  800254:	02054563          	bltz	a0,80027e <umain+0x5a>
  800258:	85a6                	mv	a1,s1
  80025a:	8522                	mv	a0,s0
  80025c:	494000ef          	jal	8006f0 <main>
  800260:	f47ff0ef          	jal	8001a6 <exit>
  800264:	86aa                	mv	a3,a0
  800266:	00000617          	auipc	a2,0x0
  80026a:	56260613          	addi	a2,a2,1378 # 8007c8 <main+0xd8>
  80026e:	45e9                	li	a1,26
  800270:	00000517          	auipc	a0,0x0
  800274:	57850513          	addi	a0,a0,1400 # 8007e8 <main+0xf8>
  800278:	dfbff0ef          	jal	800072 <__warn>
  80027c:	b7e1                	j	800244 <umain+0x20>
  80027e:	86aa                	mv	a3,a0
  800280:	00000617          	auipc	a2,0x0
  800284:	58860613          	addi	a2,a2,1416 # 800808 <main+0x118>
  800288:	45f5                	li	a1,29
  80028a:	00000517          	auipc	a0,0x0
  80028e:	55e50513          	addi	a0,a0,1374 # 8007e8 <main+0xf8>
  800292:	de1ff0ef          	jal	800072 <__warn>
  800296:	b7c9                	j	800258 <umain+0x34>

0000000000800298 <printnum>:
  800298:	7139                	addi	sp,sp,-64
  80029a:	02071893          	slli	a7,a4,0x20
  80029e:	f822                	sd	s0,48(sp)
  8002a0:	f426                	sd	s1,40(sp)
  8002a2:	f04a                	sd	s2,32(sp)
  8002a4:	ec4e                	sd	s3,24(sp)
  8002a6:	e456                	sd	s5,8(sp)
  8002a8:	0208d893          	srli	a7,a7,0x20
  8002ac:	fc06                	sd	ra,56(sp)
  8002ae:	0316fab3          	remu	s5,a3,a7
  8002b2:	fff7841b          	addiw	s0,a5,-1
  8002b6:	84aa                	mv	s1,a0
  8002b8:	89ae                	mv	s3,a1
  8002ba:	8932                	mv	s2,a2
  8002bc:	0516f063          	bgeu	a3,a7,8002fc <printnum+0x64>
  8002c0:	e852                	sd	s4,16(sp)
  8002c2:	4705                	li	a4,1
  8002c4:	8a42                	mv	s4,a6
  8002c6:	00f75863          	bge	a4,a5,8002d6 <printnum+0x3e>
  8002ca:	864e                	mv	a2,s3
  8002cc:	85ca                	mv	a1,s2
  8002ce:	8552                	mv	a0,s4
  8002d0:	347d                	addiw	s0,s0,-1
  8002d2:	9482                	jalr	s1
  8002d4:	f87d                	bnez	s0,8002ca <printnum+0x32>
  8002d6:	6a42                	ld	s4,16(sp)
  8002d8:	00000797          	auipc	a5,0x0
  8002dc:	55078793          	addi	a5,a5,1360 # 800828 <main+0x138>
  8002e0:	97d6                	add	a5,a5,s5
  8002e2:	7442                	ld	s0,48(sp)
  8002e4:	0007c503          	lbu	a0,0(a5)
  8002e8:	70e2                	ld	ra,56(sp)
  8002ea:	6aa2                	ld	s5,8(sp)
  8002ec:	864e                	mv	a2,s3
  8002ee:	85ca                	mv	a1,s2
  8002f0:	69e2                	ld	s3,24(sp)
  8002f2:	7902                	ld	s2,32(sp)
  8002f4:	87a6                	mv	a5,s1
  8002f6:	74a2                	ld	s1,40(sp)
  8002f8:	6121                	addi	sp,sp,64
  8002fa:	8782                	jr	a5
  8002fc:	0316d6b3          	divu	a3,a3,a7
  800300:	87a2                	mv	a5,s0
  800302:	f97ff0ef          	jal	800298 <printnum>
  800306:	bfc9                	j	8002d8 <printnum+0x40>

0000000000800308 <vprintfmt>:
  800308:	7119                	addi	sp,sp,-128
  80030a:	f4a6                	sd	s1,104(sp)
  80030c:	f0ca                	sd	s2,96(sp)
  80030e:	ecce                	sd	s3,88(sp)
  800310:	e8d2                	sd	s4,80(sp)
  800312:	e4d6                	sd	s5,72(sp)
  800314:	e0da                	sd	s6,64(sp)
  800316:	fc5e                	sd	s7,56(sp)
  800318:	f466                	sd	s9,40(sp)
  80031a:	fc86                	sd	ra,120(sp)
  80031c:	f8a2                	sd	s0,112(sp)
  80031e:	f862                	sd	s8,48(sp)
  800320:	f06a                	sd	s10,32(sp)
  800322:	ec6e                	sd	s11,24(sp)
  800324:	84aa                	mv	s1,a0
  800326:	8cb6                	mv	s9,a3
  800328:	8aba                	mv	s5,a4
  80032a:	89ae                	mv	s3,a1
  80032c:	8932                	mv	s2,a2
  80032e:	02500a13          	li	s4,37
  800332:	05500b93          	li	s7,85
  800336:	00000b17          	auipc	s6,0x0
  80033a:	7a2b0b13          	addi	s6,s6,1954 # 800ad8 <main+0x3e8>
  80033e:	000cc503          	lbu	a0,0(s9)
  800342:	001c8413          	addi	s0,s9,1
  800346:	01450b63          	beq	a0,s4,80035c <vprintfmt+0x54>
  80034a:	cd15                	beqz	a0,800386 <vprintfmt+0x7e>
  80034c:	864e                	mv	a2,s3
  80034e:	85ca                	mv	a1,s2
  800350:	9482                	jalr	s1
  800352:	00044503          	lbu	a0,0(s0)
  800356:	0405                	addi	s0,s0,1
  800358:	ff4519e3          	bne	a0,s4,80034a <vprintfmt+0x42>
  80035c:	5d7d                	li	s10,-1
  80035e:	8dea                	mv	s11,s10
  800360:	02000813          	li	a6,32
  800364:	4c01                	li	s8,0
  800366:	4581                	li	a1,0
  800368:	00044703          	lbu	a4,0(s0)
  80036c:	00140c93          	addi	s9,s0,1
  800370:	fdd7061b          	addiw	a2,a4,-35
  800374:	0ff67613          	zext.b	a2,a2
  800378:	02cbe663          	bltu	s7,a2,8003a4 <vprintfmt+0x9c>
  80037c:	060a                	slli	a2,a2,0x2
  80037e:	965a                	add	a2,a2,s6
  800380:	421c                	lw	a5,0(a2)
  800382:	97da                	add	a5,a5,s6
  800384:	8782                	jr	a5
  800386:	70e6                	ld	ra,120(sp)
  800388:	7446                	ld	s0,112(sp)
  80038a:	74a6                	ld	s1,104(sp)
  80038c:	7906                	ld	s2,96(sp)
  80038e:	69e6                	ld	s3,88(sp)
  800390:	6a46                	ld	s4,80(sp)
  800392:	6aa6                	ld	s5,72(sp)
  800394:	6b06                	ld	s6,64(sp)
  800396:	7be2                	ld	s7,56(sp)
  800398:	7c42                	ld	s8,48(sp)
  80039a:	7ca2                	ld	s9,40(sp)
  80039c:	7d02                	ld	s10,32(sp)
  80039e:	6de2                	ld	s11,24(sp)
  8003a0:	6109                	addi	sp,sp,128
  8003a2:	8082                	ret
  8003a4:	864e                	mv	a2,s3
  8003a6:	85ca                	mv	a1,s2
  8003a8:	02500513          	li	a0,37
  8003ac:	9482                	jalr	s1
  8003ae:	fff44783          	lbu	a5,-1(s0)
  8003b2:	02500713          	li	a4,37
  8003b6:	8ca2                	mv	s9,s0
  8003b8:	f8e783e3          	beq	a5,a4,80033e <vprintfmt+0x36>
  8003bc:	ffecc783          	lbu	a5,-2(s9)
  8003c0:	1cfd                	addi	s9,s9,-1
  8003c2:	fee79de3          	bne	a5,a4,8003bc <vprintfmt+0xb4>
  8003c6:	bfa5                	j	80033e <vprintfmt+0x36>
  8003c8:	00144683          	lbu	a3,1(s0)
  8003cc:	4525                	li	a0,9
  8003ce:	fd070d1b          	addiw	s10,a4,-48
  8003d2:	fd06879b          	addiw	a5,a3,-48
  8003d6:	28f56063          	bltu	a0,a5,800656 <vprintfmt+0x34e>
  8003da:	2681                	sext.w	a3,a3
  8003dc:	8466                	mv	s0,s9
  8003de:	002d179b          	slliw	a5,s10,0x2
  8003e2:	00144703          	lbu	a4,1(s0)
  8003e6:	01a787bb          	addw	a5,a5,s10
  8003ea:	0017979b          	slliw	a5,a5,0x1
  8003ee:	9fb5                	addw	a5,a5,a3
  8003f0:	fd07061b          	addiw	a2,a4,-48
  8003f4:	0405                	addi	s0,s0,1
  8003f6:	fd078d1b          	addiw	s10,a5,-48
  8003fa:	0007069b          	sext.w	a3,a4
  8003fe:	fec570e3          	bgeu	a0,a2,8003de <vprintfmt+0xd6>
  800402:	f60dd3e3          	bgez	s11,800368 <vprintfmt+0x60>
  800406:	8dea                	mv	s11,s10
  800408:	5d7d                	li	s10,-1
  80040a:	bfb9                	j	800368 <vprintfmt+0x60>
  80040c:	883a                	mv	a6,a4
  80040e:	8466                	mv	s0,s9
  800410:	bfa1                	j	800368 <vprintfmt+0x60>
  800412:	8466                	mv	s0,s9
  800414:	4c05                	li	s8,1
  800416:	bf89                	j	800368 <vprintfmt+0x60>
  800418:	4785                	li	a5,1
  80041a:	008a8613          	addi	a2,s5,8
  80041e:	00b7c463          	blt	a5,a1,800426 <vprintfmt+0x11e>
  800422:	1c058363          	beqz	a1,8005e8 <vprintfmt+0x2e0>
  800426:	000ab683          	ld	a3,0(s5)
  80042a:	4741                	li	a4,16
  80042c:	8ab2                	mv	s5,a2
  80042e:	2801                	sext.w	a6,a6
  800430:	87ee                	mv	a5,s11
  800432:	864a                	mv	a2,s2
  800434:	85ce                	mv	a1,s3
  800436:	8526                	mv	a0,s1
  800438:	e61ff0ef          	jal	800298 <printnum>
  80043c:	b709                	j	80033e <vprintfmt+0x36>
  80043e:	000aa503          	lw	a0,0(s5)
  800442:	864e                	mv	a2,s3
  800444:	85ca                	mv	a1,s2
  800446:	9482                	jalr	s1
  800448:	0aa1                	addi	s5,s5,8
  80044a:	bdd5                	j	80033e <vprintfmt+0x36>
  80044c:	4785                	li	a5,1
  80044e:	008a8613          	addi	a2,s5,8
  800452:	00b7c463          	blt	a5,a1,80045a <vprintfmt+0x152>
  800456:	18058463          	beqz	a1,8005de <vprintfmt+0x2d6>
  80045a:	000ab683          	ld	a3,0(s5)
  80045e:	4729                	li	a4,10
  800460:	8ab2                	mv	s5,a2
  800462:	b7f1                	j	80042e <vprintfmt+0x126>
  800464:	864e                	mv	a2,s3
  800466:	85ca                	mv	a1,s2
  800468:	03000513          	li	a0,48
  80046c:	e042                	sd	a6,0(sp)
  80046e:	9482                	jalr	s1
  800470:	864e                	mv	a2,s3
  800472:	85ca                	mv	a1,s2
  800474:	07800513          	li	a0,120
  800478:	9482                	jalr	s1
  80047a:	000ab683          	ld	a3,0(s5)
  80047e:	6802                	ld	a6,0(sp)
  800480:	4741                	li	a4,16
  800482:	0aa1                	addi	s5,s5,8
  800484:	b76d                	j	80042e <vprintfmt+0x126>
  800486:	864e                	mv	a2,s3
  800488:	85ca                	mv	a1,s2
  80048a:	02500513          	li	a0,37
  80048e:	9482                	jalr	s1
  800490:	b57d                	j	80033e <vprintfmt+0x36>
  800492:	000aad03          	lw	s10,0(s5)
  800496:	8466                	mv	s0,s9
  800498:	0aa1                	addi	s5,s5,8
  80049a:	b7a5                	j	800402 <vprintfmt+0xfa>
  80049c:	4785                	li	a5,1
  80049e:	008a8613          	addi	a2,s5,8
  8004a2:	00b7c463          	blt	a5,a1,8004aa <vprintfmt+0x1a2>
  8004a6:	12058763          	beqz	a1,8005d4 <vprintfmt+0x2cc>
  8004aa:	000ab683          	ld	a3,0(s5)
  8004ae:	4721                	li	a4,8
  8004b0:	8ab2                	mv	s5,a2
  8004b2:	bfb5                	j	80042e <vprintfmt+0x126>
  8004b4:	87ee                	mv	a5,s11
  8004b6:	000dd363          	bgez	s11,8004bc <vprintfmt+0x1b4>
  8004ba:	4781                	li	a5,0
  8004bc:	00078d9b          	sext.w	s11,a5
  8004c0:	8466                	mv	s0,s9
  8004c2:	b55d                	j	800368 <vprintfmt+0x60>
  8004c4:	0008041b          	sext.w	s0,a6
  8004c8:	fd340793          	addi	a5,s0,-45
  8004cc:	01b02733          	sgtz	a4,s11
  8004d0:	00f037b3          	snez	a5,a5
  8004d4:	8ff9                	and	a5,a5,a4
  8004d6:	000ab703          	ld	a4,0(s5)
  8004da:	008a8693          	addi	a3,s5,8
  8004de:	e436                	sd	a3,8(sp)
  8004e0:	12070563          	beqz	a4,80060a <vprintfmt+0x302>
  8004e4:	12079d63          	bnez	a5,80061e <vprintfmt+0x316>
  8004e8:	00074783          	lbu	a5,0(a4)
  8004ec:	0007851b          	sext.w	a0,a5
  8004f0:	c78d                	beqz	a5,80051a <vprintfmt+0x212>
  8004f2:	00170a93          	addi	s5,a4,1
  8004f6:	547d                	li	s0,-1
  8004f8:	000d4563          	bltz	s10,800502 <vprintfmt+0x1fa>
  8004fc:	3d7d                	addiw	s10,s10,-1
  8004fe:	008d0e63          	beq	s10,s0,80051a <vprintfmt+0x212>
  800502:	020c1863          	bnez	s8,800532 <vprintfmt+0x22a>
  800506:	864e                	mv	a2,s3
  800508:	85ca                	mv	a1,s2
  80050a:	9482                	jalr	s1
  80050c:	000ac783          	lbu	a5,0(s5)
  800510:	0a85                	addi	s5,s5,1
  800512:	3dfd                	addiw	s11,s11,-1
  800514:	0007851b          	sext.w	a0,a5
  800518:	f3e5                	bnez	a5,8004f8 <vprintfmt+0x1f0>
  80051a:	01b05a63          	blez	s11,80052e <vprintfmt+0x226>
  80051e:	864e                	mv	a2,s3
  800520:	85ca                	mv	a1,s2
  800522:	02000513          	li	a0,32
  800526:	3dfd                	addiw	s11,s11,-1
  800528:	9482                	jalr	s1
  80052a:	fe0d9ae3          	bnez	s11,80051e <vprintfmt+0x216>
  80052e:	6aa2                	ld	s5,8(sp)
  800530:	b539                	j	80033e <vprintfmt+0x36>
  800532:	3781                	addiw	a5,a5,-32
  800534:	05e00713          	li	a4,94
  800538:	fcf777e3          	bgeu	a4,a5,800506 <vprintfmt+0x1fe>
  80053c:	03f00513          	li	a0,63
  800540:	864e                	mv	a2,s3
  800542:	85ca                	mv	a1,s2
  800544:	9482                	jalr	s1
  800546:	000ac783          	lbu	a5,0(s5)
  80054a:	0a85                	addi	s5,s5,1
  80054c:	3dfd                	addiw	s11,s11,-1
  80054e:	0007851b          	sext.w	a0,a5
  800552:	d7e1                	beqz	a5,80051a <vprintfmt+0x212>
  800554:	fa0d54e3          	bgez	s10,8004fc <vprintfmt+0x1f4>
  800558:	bfe9                	j	800532 <vprintfmt+0x22a>
  80055a:	000aa783          	lw	a5,0(s5)
  80055e:	46e1                	li	a3,24
  800560:	0aa1                	addi	s5,s5,8
  800562:	41f7d71b          	sraiw	a4,a5,0x1f
  800566:	8fb9                	xor	a5,a5,a4
  800568:	40e7873b          	subw	a4,a5,a4
  80056c:	02e6c663          	blt	a3,a4,800598 <vprintfmt+0x290>
  800570:	00000797          	auipc	a5,0x0
  800574:	6c078793          	addi	a5,a5,1728 # 800c30 <error_string>
  800578:	00371693          	slli	a3,a4,0x3
  80057c:	97b6                	add	a5,a5,a3
  80057e:	639c                	ld	a5,0(a5)
  800580:	cf81                	beqz	a5,800598 <vprintfmt+0x290>
  800582:	873e                	mv	a4,a5
  800584:	00000697          	auipc	a3,0x0
  800588:	2d468693          	addi	a3,a3,724 # 800858 <main+0x168>
  80058c:	864a                	mv	a2,s2
  80058e:	85ce                	mv	a1,s3
  800590:	8526                	mv	a0,s1
  800592:	0f2000ef          	jal	800684 <printfmt>
  800596:	b365                	j	80033e <vprintfmt+0x36>
  800598:	00000697          	auipc	a3,0x0
  80059c:	2b068693          	addi	a3,a3,688 # 800848 <main+0x158>
  8005a0:	864a                	mv	a2,s2
  8005a2:	85ce                	mv	a1,s3
  8005a4:	8526                	mv	a0,s1
  8005a6:	0de000ef          	jal	800684 <printfmt>
  8005aa:	bb51                	j	80033e <vprintfmt+0x36>
  8005ac:	4785                	li	a5,1
  8005ae:	008a8c13          	addi	s8,s5,8
  8005b2:	00b7c363          	blt	a5,a1,8005b8 <vprintfmt+0x2b0>
  8005b6:	cd81                	beqz	a1,8005ce <vprintfmt+0x2c6>
  8005b8:	000ab403          	ld	s0,0(s5)
  8005bc:	02044b63          	bltz	s0,8005f2 <vprintfmt+0x2ea>
  8005c0:	86a2                	mv	a3,s0
  8005c2:	8ae2                	mv	s5,s8
  8005c4:	4729                	li	a4,10
  8005c6:	b5a5                	j	80042e <vprintfmt+0x126>
  8005c8:	2585                	addiw	a1,a1,1
  8005ca:	8466                	mv	s0,s9
  8005cc:	bb71                	j	800368 <vprintfmt+0x60>
  8005ce:	000aa403          	lw	s0,0(s5)
  8005d2:	b7ed                	j	8005bc <vprintfmt+0x2b4>
  8005d4:	000ae683          	lwu	a3,0(s5)
  8005d8:	4721                	li	a4,8
  8005da:	8ab2                	mv	s5,a2
  8005dc:	bd89                	j	80042e <vprintfmt+0x126>
  8005de:	000ae683          	lwu	a3,0(s5)
  8005e2:	4729                	li	a4,10
  8005e4:	8ab2                	mv	s5,a2
  8005e6:	b5a1                	j	80042e <vprintfmt+0x126>
  8005e8:	000ae683          	lwu	a3,0(s5)
  8005ec:	4741                	li	a4,16
  8005ee:	8ab2                	mv	s5,a2
  8005f0:	bd3d                	j	80042e <vprintfmt+0x126>
  8005f2:	864e                	mv	a2,s3
  8005f4:	85ca                	mv	a1,s2
  8005f6:	02d00513          	li	a0,45
  8005fa:	e042                	sd	a6,0(sp)
  8005fc:	9482                	jalr	s1
  8005fe:	6802                	ld	a6,0(sp)
  800600:	408006b3          	neg	a3,s0
  800604:	8ae2                	mv	s5,s8
  800606:	4729                	li	a4,10
  800608:	b51d                	j	80042e <vprintfmt+0x126>
  80060a:	eba1                	bnez	a5,80065a <vprintfmt+0x352>
  80060c:	02800793          	li	a5,40
  800610:	853e                	mv	a0,a5
  800612:	00000a97          	auipc	s5,0x0
  800616:	22fa8a93          	addi	s5,s5,559 # 800841 <main+0x151>
  80061a:	547d                	li	s0,-1
  80061c:	bdf1                	j	8004f8 <vprintfmt+0x1f0>
  80061e:	853a                	mv	a0,a4
  800620:	85ea                	mv	a1,s10
  800622:	e03a                	sd	a4,0(sp)
  800624:	07e000ef          	jal	8006a2 <strnlen>
  800628:	40ad8dbb          	subw	s11,s11,a0
  80062c:	6702                	ld	a4,0(sp)
  80062e:	01b05b63          	blez	s11,800644 <vprintfmt+0x33c>
  800632:	864e                	mv	a2,s3
  800634:	85ca                	mv	a1,s2
  800636:	8522                	mv	a0,s0
  800638:	e03a                	sd	a4,0(sp)
  80063a:	3dfd                	addiw	s11,s11,-1
  80063c:	9482                	jalr	s1
  80063e:	6702                	ld	a4,0(sp)
  800640:	fe0d99e3          	bnez	s11,800632 <vprintfmt+0x32a>
  800644:	00074783          	lbu	a5,0(a4)
  800648:	0007851b          	sext.w	a0,a5
  80064c:	ee0781e3          	beqz	a5,80052e <vprintfmt+0x226>
  800650:	00170a93          	addi	s5,a4,1
  800654:	b54d                	j	8004f6 <vprintfmt+0x1ee>
  800656:	8466                	mv	s0,s9
  800658:	b36d                	j	800402 <vprintfmt+0xfa>
  80065a:	85ea                	mv	a1,s10
  80065c:	00000517          	auipc	a0,0x0
  800660:	1e450513          	addi	a0,a0,484 # 800840 <main+0x150>
  800664:	03e000ef          	jal	8006a2 <strnlen>
  800668:	40ad8dbb          	subw	s11,s11,a0
  80066c:	02800793          	li	a5,40
  800670:	00000717          	auipc	a4,0x0
  800674:	1d070713          	addi	a4,a4,464 # 800840 <main+0x150>
  800678:	853e                	mv	a0,a5
  80067a:	fbb04ce3          	bgtz	s11,800632 <vprintfmt+0x32a>
  80067e:	00170a93          	addi	s5,a4,1
  800682:	bd95                	j	8004f6 <vprintfmt+0x1ee>

0000000000800684 <printfmt>:
  800684:	7139                	addi	sp,sp,-64
  800686:	02010313          	addi	t1,sp,32
  80068a:	f03a                	sd	a4,32(sp)
  80068c:	871a                	mv	a4,t1
  80068e:	ec06                	sd	ra,24(sp)
  800690:	f43e                	sd	a5,40(sp)
  800692:	f842                	sd	a6,48(sp)
  800694:	fc46                	sd	a7,56(sp)
  800696:	e41a                	sd	t1,8(sp)
  800698:	c71ff0ef          	jal	800308 <vprintfmt>
  80069c:	60e2                	ld	ra,24(sp)
  80069e:	6121                	addi	sp,sp,64
  8006a0:	8082                	ret

00000000008006a2 <strnlen>:
  8006a2:	4781                	li	a5,0
  8006a4:	e589                	bnez	a1,8006ae <strnlen+0xc>
  8006a6:	a811                	j	8006ba <strnlen+0x18>
  8006a8:	0785                	addi	a5,a5,1
  8006aa:	00f58863          	beq	a1,a5,8006ba <strnlen+0x18>
  8006ae:	00f50733          	add	a4,a0,a5
  8006b2:	00074703          	lbu	a4,0(a4)
  8006b6:	fb6d                	bnez	a4,8006a8 <strnlen+0x6>
  8006b8:	85be                	mv	a1,a5
  8006ba:	852e                	mv	a0,a1
  8006bc:	8082                	ret

00000000008006be <sleepy>:
  8006be:	1101                	addi	sp,sp,-32
  8006c0:	e822                	sd	s0,16(sp)
  8006c2:	e426                	sd	s1,8(sp)
  8006c4:	ec06                	sd	ra,24(sp)
  8006c6:	4401                	li	s0,0
  8006c8:	44a9                	li	s1,10
  8006ca:	06400513          	li	a0,100
  8006ce:	b0fff0ef          	jal	8001dc <sleep>
  8006d2:	2405                	addiw	s0,s0,1
  8006d4:	85a2                	mv	a1,s0
  8006d6:	06400613          	li	a2,100
  8006da:	00000517          	auipc	a0,0x0
  8006de:	35e50513          	addi	a0,a0,862 # 800a38 <main+0x348>
  8006e2:	a13ff0ef          	jal	8000f4 <cprintf>
  8006e6:	fe9412e3          	bne	s0,s1,8006ca <sleepy+0xc>
  8006ea:	4501                	li	a0,0
  8006ec:	abbff0ef          	jal	8001a6 <exit>

00000000008006f0 <main>:
  8006f0:	1101                	addi	sp,sp,-32
  8006f2:	e822                	sd	s0,16(sp)
  8006f4:	ec06                	sd	ra,24(sp)
  8006f6:	ae5ff0ef          	jal	8001da <gettime_msec>
  8006fa:	842a                	mv	s0,a0
  8006fc:	ac1ff0ef          	jal	8001bc <fork>
  800700:	cd21                	beqz	a0,800758 <main+0x68>
  800702:	006c                	addi	a1,sp,12
  800704:	abbff0ef          	jal	8001be <waitpid>
  800708:	47b2                	lw	a5,12(sp)
  80070a:	8d5d                	or	a0,a0,a5
  80070c:	2501                	sext.w	a0,a0
  80070e:	e515                	bnez	a0,80073a <main+0x4a>
  800710:	acbff0ef          	jal	8001da <gettime_msec>
  800714:	408505bb          	subw	a1,a0,s0
  800718:	00000517          	auipc	a0,0x0
  80071c:	39850513          	addi	a0,a0,920 # 800ab0 <main+0x3c0>
  800720:	9d5ff0ef          	jal	8000f4 <cprintf>
  800724:	00000517          	auipc	a0,0x0
  800728:	3a450513          	addi	a0,a0,932 # 800ac8 <main+0x3d8>
  80072c:	9c9ff0ef          	jal	8000f4 <cprintf>
  800730:	60e2                	ld	ra,24(sp)
  800732:	6442                	ld	s0,16(sp)
  800734:	4501                	li	a0,0
  800736:	6105                	addi	sp,sp,32
  800738:	8082                	ret
  80073a:	00000697          	auipc	a3,0x0
  80073e:	31668693          	addi	a3,a3,790 # 800a50 <main+0x360>
  800742:	00000617          	auipc	a2,0x0
  800746:	34660613          	addi	a2,a2,838 # 800a88 <main+0x398>
  80074a:	45dd                	li	a1,23
  80074c:	00000517          	auipc	a0,0x0
  800750:	35450513          	addi	a0,a0,852 # 800aa0 <main+0x3b0>
  800754:	8ddff0ef          	jal	800030 <__panic>
  800758:	f67ff0ef          	jal	8006be <sleepy>
