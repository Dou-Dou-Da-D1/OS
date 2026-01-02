
obj/__user_badarg.out:     file format elf64-littleriscv


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
  80002a:	1ee000ef          	jal	800218 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	76250513          	addi	a0,a0,1890 # 8007a0 <main+0xee>
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
  800064:	76050513          	addi	a0,a0,1888 # 8007c0 <main+0x10e>
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
  800084:	74850513          	addi	a0,a0,1864 # 8007c8 <main+0x116>
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
  8000a6:	71e50513          	addi	a0,a0,1822 # 8007c0 <main+0x10e>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5e41>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	214000ef          	jal	8002fc <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5e41>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1da000ef          	jal	8002fc <vprintfmt>
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
  8001ac:	64050513          	addi	a0,a0,1600 # 8007e8 <main+0x136>
  8001b0:	f45ff0ef          	jal	8000f4 <cprintf>
  8001b4:	a001                	j	8001b4 <exit+0x14>

00000000008001b6 <fork>:
  8001b6:	bf65                	j	80016e <sys_fork>

00000000008001b8 <waitpid>:
  8001b8:	1101                	addi	sp,sp,-32
  8001ba:	e822                	sd	s0,16(sp)
  8001bc:	842e                	mv	s0,a1
  8001be:	002c                	addi	a1,sp,8
  8001c0:	ec06                	sd	ra,24(sp)
  8001c2:	fb1ff0ef          	jal	800172 <sys_wait>
  8001c6:	c019                	beqz	s0,8001cc <waitpid+0x14>
  8001c8:	67a2                	ld	a5,8(sp)
  8001ca:	c01c                	sw	a5,0(s0)
  8001cc:	60e2                	ld	ra,24(sp)
  8001ce:	6442                	ld	s0,16(sp)
  8001d0:	6105                	addi	sp,sp,32
  8001d2:	8082                	ret

00000000008001d4 <yield>:
  8001d4:	b75d                	j	80017a <sys_yield>

00000000008001d6 <initfd>:
  8001d6:	87ae                	mv	a5,a1
  8001d8:	1101                	addi	sp,sp,-32
  8001da:	e822                	sd	s0,16(sp)
  8001dc:	85b2                	mv	a1,a2
  8001de:	842a                	mv	s0,a0
  8001e0:	853e                	mv	a0,a5
  8001e2:	ec06                	sd	ra,24(sp)
  8001e4:	e3dff0ef          	jal	800020 <open>
  8001e8:	87aa                	mv	a5,a0
  8001ea:	00054463          	bltz	a0,8001f2 <initfd+0x1c>
  8001ee:	00851763          	bne	a0,s0,8001fc <initfd+0x26>
  8001f2:	60e2                	ld	ra,24(sp)
  8001f4:	6442                	ld	s0,16(sp)
  8001f6:	853e                	mv	a0,a5
  8001f8:	6105                	addi	sp,sp,32
  8001fa:	8082                	ret
  8001fc:	e42a                	sd	a0,8(sp)
  8001fe:	8522                	mv	a0,s0
  800200:	e27ff0ef          	jal	800026 <close>
  800204:	6522                	ld	a0,8(sp)
  800206:	85a2                	mv	a1,s0
  800208:	e21ff0ef          	jal	800028 <dup2>
  80020c:	842a                	mv	s0,a0
  80020e:	6522                	ld	a0,8(sp)
  800210:	e17ff0ef          	jal	800026 <close>
  800214:	87a2                	mv	a5,s0
  800216:	bff1                	j	8001f2 <initfd+0x1c>

0000000000800218 <umain>:
  800218:	1101                	addi	sp,sp,-32
  80021a:	e822                	sd	s0,16(sp)
  80021c:	e426                	sd	s1,8(sp)
  80021e:	842a                	mv	s0,a0
  800220:	84ae                	mv	s1,a1
  800222:	4601                	li	a2,0
  800224:	00000597          	auipc	a1,0x0
  800228:	5dc58593          	addi	a1,a1,1500 # 800800 <main+0x14e>
  80022c:	4501                	li	a0,0
  80022e:	ec06                	sd	ra,24(sp)
  800230:	fa7ff0ef          	jal	8001d6 <initfd>
  800234:	02054263          	bltz	a0,800258 <umain+0x40>
  800238:	4605                	li	a2,1
  80023a:	8532                	mv	a0,a2
  80023c:	00000597          	auipc	a1,0x0
  800240:	60458593          	addi	a1,a1,1540 # 800840 <main+0x18e>
  800244:	f93ff0ef          	jal	8001d6 <initfd>
  800248:	02054563          	bltz	a0,800272 <umain+0x5a>
  80024c:	85a6                	mv	a1,s1
  80024e:	8522                	mv	a0,s0
  800250:	462000ef          	jal	8006b2 <main>
  800254:	f4dff0ef          	jal	8001a0 <exit>
  800258:	86aa                	mv	a3,a0
  80025a:	00000617          	auipc	a2,0x0
  80025e:	5ae60613          	addi	a2,a2,1454 # 800808 <main+0x156>
  800262:	45e9                	li	a1,26
  800264:	00000517          	auipc	a0,0x0
  800268:	5c450513          	addi	a0,a0,1476 # 800828 <main+0x176>
  80026c:	e07ff0ef          	jal	800072 <__warn>
  800270:	b7e1                	j	800238 <umain+0x20>
  800272:	86aa                	mv	a3,a0
  800274:	00000617          	auipc	a2,0x0
  800278:	5d460613          	addi	a2,a2,1492 # 800848 <main+0x196>
  80027c:	45f5                	li	a1,29
  80027e:	00000517          	auipc	a0,0x0
  800282:	5aa50513          	addi	a0,a0,1450 # 800828 <main+0x176>
  800286:	dedff0ef          	jal	800072 <__warn>
  80028a:	b7c9                	j	80024c <umain+0x34>

000000000080028c <printnum>:
  80028c:	7139                	addi	sp,sp,-64
  80028e:	02071893          	slli	a7,a4,0x20
  800292:	f822                	sd	s0,48(sp)
  800294:	f426                	sd	s1,40(sp)
  800296:	f04a                	sd	s2,32(sp)
  800298:	ec4e                	sd	s3,24(sp)
  80029a:	e456                	sd	s5,8(sp)
  80029c:	0208d893          	srli	a7,a7,0x20
  8002a0:	fc06                	sd	ra,56(sp)
  8002a2:	0316fab3          	remu	s5,a3,a7
  8002a6:	fff7841b          	addiw	s0,a5,-1
  8002aa:	84aa                	mv	s1,a0
  8002ac:	89ae                	mv	s3,a1
  8002ae:	8932                	mv	s2,a2
  8002b0:	0516f063          	bgeu	a3,a7,8002f0 <printnum+0x64>
  8002b4:	e852                	sd	s4,16(sp)
  8002b6:	4705                	li	a4,1
  8002b8:	8a42                	mv	s4,a6
  8002ba:	00f75863          	bge	a4,a5,8002ca <printnum+0x3e>
  8002be:	864e                	mv	a2,s3
  8002c0:	85ca                	mv	a1,s2
  8002c2:	8552                	mv	a0,s4
  8002c4:	347d                	addiw	s0,s0,-1
  8002c6:	9482                	jalr	s1
  8002c8:	f87d                	bnez	s0,8002be <printnum+0x32>
  8002ca:	6a42                	ld	s4,16(sp)
  8002cc:	00000797          	auipc	a5,0x0
  8002d0:	59c78793          	addi	a5,a5,1436 # 800868 <main+0x1b6>
  8002d4:	97d6                	add	a5,a5,s5
  8002d6:	7442                	ld	s0,48(sp)
  8002d8:	0007c503          	lbu	a0,0(a5)
  8002dc:	70e2                	ld	ra,56(sp)
  8002de:	6aa2                	ld	s5,8(sp)
  8002e0:	864e                	mv	a2,s3
  8002e2:	85ca                	mv	a1,s2
  8002e4:	69e2                	ld	s3,24(sp)
  8002e6:	7902                	ld	s2,32(sp)
  8002e8:	87a6                	mv	a5,s1
  8002ea:	74a2                	ld	s1,40(sp)
  8002ec:	6121                	addi	sp,sp,64
  8002ee:	8782                	jr	a5
  8002f0:	0316d6b3          	divu	a3,a3,a7
  8002f4:	87a2                	mv	a5,s0
  8002f6:	f97ff0ef          	jal	80028c <printnum>
  8002fa:	bfc9                	j	8002cc <printnum+0x40>

00000000008002fc <vprintfmt>:
  8002fc:	7119                	addi	sp,sp,-128
  8002fe:	f4a6                	sd	s1,104(sp)
  800300:	f0ca                	sd	s2,96(sp)
  800302:	ecce                	sd	s3,88(sp)
  800304:	e8d2                	sd	s4,80(sp)
  800306:	e4d6                	sd	s5,72(sp)
  800308:	e0da                	sd	s6,64(sp)
  80030a:	fc5e                	sd	s7,56(sp)
  80030c:	f466                	sd	s9,40(sp)
  80030e:	fc86                	sd	ra,120(sp)
  800310:	f8a2                	sd	s0,112(sp)
  800312:	f862                	sd	s8,48(sp)
  800314:	f06a                	sd	s10,32(sp)
  800316:	ec6e                	sd	s11,24(sp)
  800318:	84aa                	mv	s1,a0
  80031a:	8cb6                	mv	s9,a3
  80031c:	8aba                	mv	s5,a4
  80031e:	89ae                	mv	s3,a1
  800320:	8932                	mv	s2,a2
  800322:	02500a13          	li	s4,37
  800326:	05500b93          	li	s7,85
  80032a:	00001b17          	auipc	s6,0x1
  80032e:	816b0b13          	addi	s6,s6,-2026 # 800b40 <main+0x48e>
  800332:	000cc503          	lbu	a0,0(s9)
  800336:	001c8413          	addi	s0,s9,1
  80033a:	01450b63          	beq	a0,s4,800350 <vprintfmt+0x54>
  80033e:	cd15                	beqz	a0,80037a <vprintfmt+0x7e>
  800340:	864e                	mv	a2,s3
  800342:	85ca                	mv	a1,s2
  800344:	9482                	jalr	s1
  800346:	00044503          	lbu	a0,0(s0)
  80034a:	0405                	addi	s0,s0,1
  80034c:	ff4519e3          	bne	a0,s4,80033e <vprintfmt+0x42>
  800350:	5d7d                	li	s10,-1
  800352:	8dea                	mv	s11,s10
  800354:	02000813          	li	a6,32
  800358:	4c01                	li	s8,0
  80035a:	4581                	li	a1,0
  80035c:	00044703          	lbu	a4,0(s0)
  800360:	00140c93          	addi	s9,s0,1
  800364:	fdd7061b          	addiw	a2,a4,-35
  800368:	0ff67613          	zext.b	a2,a2
  80036c:	02cbe663          	bltu	s7,a2,800398 <vprintfmt+0x9c>
  800370:	060a                	slli	a2,a2,0x2
  800372:	965a                	add	a2,a2,s6
  800374:	421c                	lw	a5,0(a2)
  800376:	97da                	add	a5,a5,s6
  800378:	8782                	jr	a5
  80037a:	70e6                	ld	ra,120(sp)
  80037c:	7446                	ld	s0,112(sp)
  80037e:	74a6                	ld	s1,104(sp)
  800380:	7906                	ld	s2,96(sp)
  800382:	69e6                	ld	s3,88(sp)
  800384:	6a46                	ld	s4,80(sp)
  800386:	6aa6                	ld	s5,72(sp)
  800388:	6b06                	ld	s6,64(sp)
  80038a:	7be2                	ld	s7,56(sp)
  80038c:	7c42                	ld	s8,48(sp)
  80038e:	7ca2                	ld	s9,40(sp)
  800390:	7d02                	ld	s10,32(sp)
  800392:	6de2                	ld	s11,24(sp)
  800394:	6109                	addi	sp,sp,128
  800396:	8082                	ret
  800398:	864e                	mv	a2,s3
  80039a:	85ca                	mv	a1,s2
  80039c:	02500513          	li	a0,37
  8003a0:	9482                	jalr	s1
  8003a2:	fff44783          	lbu	a5,-1(s0)
  8003a6:	02500713          	li	a4,37
  8003aa:	8ca2                	mv	s9,s0
  8003ac:	f8e783e3          	beq	a5,a4,800332 <vprintfmt+0x36>
  8003b0:	ffecc783          	lbu	a5,-2(s9)
  8003b4:	1cfd                	addi	s9,s9,-1
  8003b6:	fee79de3          	bne	a5,a4,8003b0 <vprintfmt+0xb4>
  8003ba:	bfa5                	j	800332 <vprintfmt+0x36>
  8003bc:	00144683          	lbu	a3,1(s0)
  8003c0:	4525                	li	a0,9
  8003c2:	fd070d1b          	addiw	s10,a4,-48
  8003c6:	fd06879b          	addiw	a5,a3,-48
  8003ca:	28f56063          	bltu	a0,a5,80064a <vprintfmt+0x34e>
  8003ce:	2681                	sext.w	a3,a3
  8003d0:	8466                	mv	s0,s9
  8003d2:	002d179b          	slliw	a5,s10,0x2
  8003d6:	00144703          	lbu	a4,1(s0)
  8003da:	01a787bb          	addw	a5,a5,s10
  8003de:	0017979b          	slliw	a5,a5,0x1
  8003e2:	9fb5                	addw	a5,a5,a3
  8003e4:	fd07061b          	addiw	a2,a4,-48
  8003e8:	0405                	addi	s0,s0,1
  8003ea:	fd078d1b          	addiw	s10,a5,-48
  8003ee:	0007069b          	sext.w	a3,a4
  8003f2:	fec570e3          	bgeu	a0,a2,8003d2 <vprintfmt+0xd6>
  8003f6:	f60dd3e3          	bgez	s11,80035c <vprintfmt+0x60>
  8003fa:	8dea                	mv	s11,s10
  8003fc:	5d7d                	li	s10,-1
  8003fe:	bfb9                	j	80035c <vprintfmt+0x60>
  800400:	883a                	mv	a6,a4
  800402:	8466                	mv	s0,s9
  800404:	bfa1                	j	80035c <vprintfmt+0x60>
  800406:	8466                	mv	s0,s9
  800408:	4c05                	li	s8,1
  80040a:	bf89                	j	80035c <vprintfmt+0x60>
  80040c:	4785                	li	a5,1
  80040e:	008a8613          	addi	a2,s5,8
  800412:	00b7c463          	blt	a5,a1,80041a <vprintfmt+0x11e>
  800416:	1c058363          	beqz	a1,8005dc <vprintfmt+0x2e0>
  80041a:	000ab683          	ld	a3,0(s5)
  80041e:	4741                	li	a4,16
  800420:	8ab2                	mv	s5,a2
  800422:	2801                	sext.w	a6,a6
  800424:	87ee                	mv	a5,s11
  800426:	864a                	mv	a2,s2
  800428:	85ce                	mv	a1,s3
  80042a:	8526                	mv	a0,s1
  80042c:	e61ff0ef          	jal	80028c <printnum>
  800430:	b709                	j	800332 <vprintfmt+0x36>
  800432:	000aa503          	lw	a0,0(s5)
  800436:	864e                	mv	a2,s3
  800438:	85ca                	mv	a1,s2
  80043a:	9482                	jalr	s1
  80043c:	0aa1                	addi	s5,s5,8
  80043e:	bdd5                	j	800332 <vprintfmt+0x36>
  800440:	4785                	li	a5,1
  800442:	008a8613          	addi	a2,s5,8
  800446:	00b7c463          	blt	a5,a1,80044e <vprintfmt+0x152>
  80044a:	18058463          	beqz	a1,8005d2 <vprintfmt+0x2d6>
  80044e:	000ab683          	ld	a3,0(s5)
  800452:	4729                	li	a4,10
  800454:	8ab2                	mv	s5,a2
  800456:	b7f1                	j	800422 <vprintfmt+0x126>
  800458:	864e                	mv	a2,s3
  80045a:	85ca                	mv	a1,s2
  80045c:	03000513          	li	a0,48
  800460:	e042                	sd	a6,0(sp)
  800462:	9482                	jalr	s1
  800464:	864e                	mv	a2,s3
  800466:	85ca                	mv	a1,s2
  800468:	07800513          	li	a0,120
  80046c:	9482                	jalr	s1
  80046e:	000ab683          	ld	a3,0(s5)
  800472:	6802                	ld	a6,0(sp)
  800474:	4741                	li	a4,16
  800476:	0aa1                	addi	s5,s5,8
  800478:	b76d                	j	800422 <vprintfmt+0x126>
  80047a:	864e                	mv	a2,s3
  80047c:	85ca                	mv	a1,s2
  80047e:	02500513          	li	a0,37
  800482:	9482                	jalr	s1
  800484:	b57d                	j	800332 <vprintfmt+0x36>
  800486:	000aad03          	lw	s10,0(s5)
  80048a:	8466                	mv	s0,s9
  80048c:	0aa1                	addi	s5,s5,8
  80048e:	b7a5                	j	8003f6 <vprintfmt+0xfa>
  800490:	4785                	li	a5,1
  800492:	008a8613          	addi	a2,s5,8
  800496:	00b7c463          	blt	a5,a1,80049e <vprintfmt+0x1a2>
  80049a:	12058763          	beqz	a1,8005c8 <vprintfmt+0x2cc>
  80049e:	000ab683          	ld	a3,0(s5)
  8004a2:	4721                	li	a4,8
  8004a4:	8ab2                	mv	s5,a2
  8004a6:	bfb5                	j	800422 <vprintfmt+0x126>
  8004a8:	87ee                	mv	a5,s11
  8004aa:	000dd363          	bgez	s11,8004b0 <vprintfmt+0x1b4>
  8004ae:	4781                	li	a5,0
  8004b0:	00078d9b          	sext.w	s11,a5
  8004b4:	8466                	mv	s0,s9
  8004b6:	b55d                	j	80035c <vprintfmt+0x60>
  8004b8:	0008041b          	sext.w	s0,a6
  8004bc:	fd340793          	addi	a5,s0,-45
  8004c0:	01b02733          	sgtz	a4,s11
  8004c4:	00f037b3          	snez	a5,a5
  8004c8:	8ff9                	and	a5,a5,a4
  8004ca:	000ab703          	ld	a4,0(s5)
  8004ce:	008a8693          	addi	a3,s5,8
  8004d2:	e436                	sd	a3,8(sp)
  8004d4:	12070563          	beqz	a4,8005fe <vprintfmt+0x302>
  8004d8:	12079d63          	bnez	a5,800612 <vprintfmt+0x316>
  8004dc:	00074783          	lbu	a5,0(a4)
  8004e0:	0007851b          	sext.w	a0,a5
  8004e4:	c78d                	beqz	a5,80050e <vprintfmt+0x212>
  8004e6:	00170a93          	addi	s5,a4,1
  8004ea:	547d                	li	s0,-1
  8004ec:	000d4563          	bltz	s10,8004f6 <vprintfmt+0x1fa>
  8004f0:	3d7d                	addiw	s10,s10,-1
  8004f2:	008d0e63          	beq	s10,s0,80050e <vprintfmt+0x212>
  8004f6:	020c1863          	bnez	s8,800526 <vprintfmt+0x22a>
  8004fa:	864e                	mv	a2,s3
  8004fc:	85ca                	mv	a1,s2
  8004fe:	9482                	jalr	s1
  800500:	000ac783          	lbu	a5,0(s5)
  800504:	0a85                	addi	s5,s5,1
  800506:	3dfd                	addiw	s11,s11,-1
  800508:	0007851b          	sext.w	a0,a5
  80050c:	f3e5                	bnez	a5,8004ec <vprintfmt+0x1f0>
  80050e:	01b05a63          	blez	s11,800522 <vprintfmt+0x226>
  800512:	864e                	mv	a2,s3
  800514:	85ca                	mv	a1,s2
  800516:	02000513          	li	a0,32
  80051a:	3dfd                	addiw	s11,s11,-1
  80051c:	9482                	jalr	s1
  80051e:	fe0d9ae3          	bnez	s11,800512 <vprintfmt+0x216>
  800522:	6aa2                	ld	s5,8(sp)
  800524:	b539                	j	800332 <vprintfmt+0x36>
  800526:	3781                	addiw	a5,a5,-32
  800528:	05e00713          	li	a4,94
  80052c:	fcf777e3          	bgeu	a4,a5,8004fa <vprintfmt+0x1fe>
  800530:	03f00513          	li	a0,63
  800534:	864e                	mv	a2,s3
  800536:	85ca                	mv	a1,s2
  800538:	9482                	jalr	s1
  80053a:	000ac783          	lbu	a5,0(s5)
  80053e:	0a85                	addi	s5,s5,1
  800540:	3dfd                	addiw	s11,s11,-1
  800542:	0007851b          	sext.w	a0,a5
  800546:	d7e1                	beqz	a5,80050e <vprintfmt+0x212>
  800548:	fa0d54e3          	bgez	s10,8004f0 <vprintfmt+0x1f4>
  80054c:	bfe9                	j	800526 <vprintfmt+0x22a>
  80054e:	000aa783          	lw	a5,0(s5)
  800552:	46e1                	li	a3,24
  800554:	0aa1                	addi	s5,s5,8
  800556:	41f7d71b          	sraiw	a4,a5,0x1f
  80055a:	8fb9                	xor	a5,a5,a4
  80055c:	40e7873b          	subw	a4,a5,a4
  800560:	02e6c663          	blt	a3,a4,80058c <vprintfmt+0x290>
  800564:	00000797          	auipc	a5,0x0
  800568:	73478793          	addi	a5,a5,1844 # 800c98 <error_string>
  80056c:	00371693          	slli	a3,a4,0x3
  800570:	97b6                	add	a5,a5,a3
  800572:	639c                	ld	a5,0(a5)
  800574:	cf81                	beqz	a5,80058c <vprintfmt+0x290>
  800576:	873e                	mv	a4,a5
  800578:	00000697          	auipc	a3,0x0
  80057c:	32068693          	addi	a3,a3,800 # 800898 <main+0x1e6>
  800580:	864a                	mv	a2,s2
  800582:	85ce                	mv	a1,s3
  800584:	8526                	mv	a0,s1
  800586:	0f2000ef          	jal	800678 <printfmt>
  80058a:	b365                	j	800332 <vprintfmt+0x36>
  80058c:	00000697          	auipc	a3,0x0
  800590:	2fc68693          	addi	a3,a3,764 # 800888 <main+0x1d6>
  800594:	864a                	mv	a2,s2
  800596:	85ce                	mv	a1,s3
  800598:	8526                	mv	a0,s1
  80059a:	0de000ef          	jal	800678 <printfmt>
  80059e:	bb51                	j	800332 <vprintfmt+0x36>
  8005a0:	4785                	li	a5,1
  8005a2:	008a8c13          	addi	s8,s5,8
  8005a6:	00b7c363          	blt	a5,a1,8005ac <vprintfmt+0x2b0>
  8005aa:	cd81                	beqz	a1,8005c2 <vprintfmt+0x2c6>
  8005ac:	000ab403          	ld	s0,0(s5)
  8005b0:	02044b63          	bltz	s0,8005e6 <vprintfmt+0x2ea>
  8005b4:	86a2                	mv	a3,s0
  8005b6:	8ae2                	mv	s5,s8
  8005b8:	4729                	li	a4,10
  8005ba:	b5a5                	j	800422 <vprintfmt+0x126>
  8005bc:	2585                	addiw	a1,a1,1
  8005be:	8466                	mv	s0,s9
  8005c0:	bb71                	j	80035c <vprintfmt+0x60>
  8005c2:	000aa403          	lw	s0,0(s5)
  8005c6:	b7ed                	j	8005b0 <vprintfmt+0x2b4>
  8005c8:	000ae683          	lwu	a3,0(s5)
  8005cc:	4721                	li	a4,8
  8005ce:	8ab2                	mv	s5,a2
  8005d0:	bd89                	j	800422 <vprintfmt+0x126>
  8005d2:	000ae683          	lwu	a3,0(s5)
  8005d6:	4729                	li	a4,10
  8005d8:	8ab2                	mv	s5,a2
  8005da:	b5a1                	j	800422 <vprintfmt+0x126>
  8005dc:	000ae683          	lwu	a3,0(s5)
  8005e0:	4741                	li	a4,16
  8005e2:	8ab2                	mv	s5,a2
  8005e4:	bd3d                	j	800422 <vprintfmt+0x126>
  8005e6:	864e                	mv	a2,s3
  8005e8:	85ca                	mv	a1,s2
  8005ea:	02d00513          	li	a0,45
  8005ee:	e042                	sd	a6,0(sp)
  8005f0:	9482                	jalr	s1
  8005f2:	6802                	ld	a6,0(sp)
  8005f4:	408006b3          	neg	a3,s0
  8005f8:	8ae2                	mv	s5,s8
  8005fa:	4729                	li	a4,10
  8005fc:	b51d                	j	800422 <vprintfmt+0x126>
  8005fe:	eba1                	bnez	a5,80064e <vprintfmt+0x352>
  800600:	02800793          	li	a5,40
  800604:	853e                	mv	a0,a5
  800606:	00000a97          	auipc	s5,0x0
  80060a:	27ba8a93          	addi	s5,s5,635 # 800881 <main+0x1cf>
  80060e:	547d                	li	s0,-1
  800610:	bdf1                	j	8004ec <vprintfmt+0x1f0>
  800612:	853a                	mv	a0,a4
  800614:	85ea                	mv	a1,s10
  800616:	e03a                	sd	a4,0(sp)
  800618:	07e000ef          	jal	800696 <strnlen>
  80061c:	40ad8dbb          	subw	s11,s11,a0
  800620:	6702                	ld	a4,0(sp)
  800622:	01b05b63          	blez	s11,800638 <vprintfmt+0x33c>
  800626:	864e                	mv	a2,s3
  800628:	85ca                	mv	a1,s2
  80062a:	8522                	mv	a0,s0
  80062c:	e03a                	sd	a4,0(sp)
  80062e:	3dfd                	addiw	s11,s11,-1
  800630:	9482                	jalr	s1
  800632:	6702                	ld	a4,0(sp)
  800634:	fe0d99e3          	bnez	s11,800626 <vprintfmt+0x32a>
  800638:	00074783          	lbu	a5,0(a4)
  80063c:	0007851b          	sext.w	a0,a5
  800640:	ee0781e3          	beqz	a5,800522 <vprintfmt+0x226>
  800644:	00170a93          	addi	s5,a4,1
  800648:	b54d                	j	8004ea <vprintfmt+0x1ee>
  80064a:	8466                	mv	s0,s9
  80064c:	b36d                	j	8003f6 <vprintfmt+0xfa>
  80064e:	85ea                	mv	a1,s10
  800650:	00000517          	auipc	a0,0x0
  800654:	23050513          	addi	a0,a0,560 # 800880 <main+0x1ce>
  800658:	03e000ef          	jal	800696 <strnlen>
  80065c:	40ad8dbb          	subw	s11,s11,a0
  800660:	02800793          	li	a5,40
  800664:	00000717          	auipc	a4,0x0
  800668:	21c70713          	addi	a4,a4,540 # 800880 <main+0x1ce>
  80066c:	853e                	mv	a0,a5
  80066e:	fbb04ce3          	bgtz	s11,800626 <vprintfmt+0x32a>
  800672:	00170a93          	addi	s5,a4,1
  800676:	bd95                	j	8004ea <vprintfmt+0x1ee>

0000000000800678 <printfmt>:
  800678:	7139                	addi	sp,sp,-64
  80067a:	02010313          	addi	t1,sp,32
  80067e:	f03a                	sd	a4,32(sp)
  800680:	871a                	mv	a4,t1
  800682:	ec06                	sd	ra,24(sp)
  800684:	f43e                	sd	a5,40(sp)
  800686:	f842                	sd	a6,48(sp)
  800688:	fc46                	sd	a7,56(sp)
  80068a:	e41a                	sd	t1,8(sp)
  80068c:	c71ff0ef          	jal	8002fc <vprintfmt>
  800690:	60e2                	ld	ra,24(sp)
  800692:	6121                	addi	sp,sp,64
  800694:	8082                	ret

0000000000800696 <strnlen>:
  800696:	4781                	li	a5,0
  800698:	e589                	bnez	a1,8006a2 <strnlen+0xc>
  80069a:	a811                	j	8006ae <strnlen+0x18>
  80069c:	0785                	addi	a5,a5,1
  80069e:	00f58863          	beq	a1,a5,8006ae <strnlen+0x18>
  8006a2:	00f50733          	add	a4,a0,a5
  8006a6:	00074703          	lbu	a4,0(a4)
  8006aa:	fb6d                	bnez	a4,80069c <strnlen+0x6>
  8006ac:	85be                	mv	a1,a5
  8006ae:	852e                	mv	a0,a1
  8006b0:	8082                	ret

00000000008006b2 <main>:
  8006b2:	1101                	addi	sp,sp,-32
  8006b4:	ec06                	sd	ra,24(sp)
  8006b6:	e822                	sd	s0,16(sp)
  8006b8:	affff0ef          	jal	8001b6 <fork>
  8006bc:	c169                	beqz	a0,80077e <main+0xcc>
  8006be:	842a                	mv	s0,a0
  8006c0:	0aa05063          	blez	a0,800760 <main+0xae>
  8006c4:	4581                	li	a1,0
  8006c6:	557d                	li	a0,-1
  8006c8:	af1ff0ef          	jal	8001b8 <waitpid>
  8006cc:	c93d                	beqz	a0,800742 <main+0x90>
  8006ce:	458d                	li	a1,3
  8006d0:	05fa                	slli	a1,a1,0x1e
  8006d2:	8522                	mv	a0,s0
  8006d4:	ae5ff0ef          	jal	8001b8 <waitpid>
  8006d8:	c531                	beqz	a0,800724 <main+0x72>
  8006da:	8522                	mv	a0,s0
  8006dc:	006c                	addi	a1,sp,12
  8006de:	adbff0ef          	jal	8001b8 <waitpid>
  8006e2:	e115                	bnez	a0,800706 <main+0x54>
  8006e4:	4732                	lw	a4,12(sp)
  8006e6:	67b1                	lui	a5,0xc
  8006e8:	eaf78793          	addi	a5,a5,-337 # beaf <open-0x7f4171>
  8006ec:	00f71d63          	bne	a4,a5,800706 <main+0x54>
  8006f0:	00000517          	auipc	a0,0x0
  8006f4:	44050513          	addi	a0,a0,1088 # 800b30 <main+0x47e>
  8006f8:	9fdff0ef          	jal	8000f4 <cprintf>
  8006fc:	60e2                	ld	ra,24(sp)
  8006fe:	6442                	ld	s0,16(sp)
  800700:	4501                	li	a0,0
  800702:	6105                	addi	sp,sp,32
  800704:	8082                	ret
  800706:	00000697          	auipc	a3,0x0
  80070a:	3f268693          	addi	a3,a3,1010 # 800af8 <main+0x446>
  80070e:	00000617          	auipc	a2,0x0
  800712:	38260613          	addi	a2,a2,898 # 800a90 <main+0x3de>
  800716:	45c9                	li	a1,18
  800718:	00000517          	auipc	a0,0x0
  80071c:	39050513          	addi	a0,a0,912 # 800aa8 <main+0x3f6>
  800720:	911ff0ef          	jal	800030 <__panic>
  800724:	00000697          	auipc	a3,0x0
  800728:	3ac68693          	addi	a3,a3,940 # 800ad0 <main+0x41e>
  80072c:	00000617          	auipc	a2,0x0
  800730:	36460613          	addi	a2,a2,868 # 800a90 <main+0x3de>
  800734:	45c5                	li	a1,17
  800736:	00000517          	auipc	a0,0x0
  80073a:	37250513          	addi	a0,a0,882 # 800aa8 <main+0x3f6>
  80073e:	8f3ff0ef          	jal	800030 <__panic>
  800742:	00000697          	auipc	a3,0x0
  800746:	37668693          	addi	a3,a3,886 # 800ab8 <main+0x406>
  80074a:	00000617          	auipc	a2,0x0
  80074e:	34660613          	addi	a2,a2,838 # 800a90 <main+0x3de>
  800752:	45c1                	li	a1,16
  800754:	00000517          	auipc	a0,0x0
  800758:	35450513          	addi	a0,a0,852 # 800aa8 <main+0x3f6>
  80075c:	8d5ff0ef          	jal	800030 <__panic>
  800760:	00000697          	auipc	a3,0x0
  800764:	32868693          	addi	a3,a3,808 # 800a88 <main+0x3d6>
  800768:	00000617          	auipc	a2,0x0
  80076c:	32860613          	addi	a2,a2,808 # 800a90 <main+0x3de>
  800770:	45bd                	li	a1,15
  800772:	00000517          	auipc	a0,0x0
  800776:	33650513          	addi	a0,a0,822 # 800aa8 <main+0x3f6>
  80077a:	8b7ff0ef          	jal	800030 <__panic>
  80077e:	00000517          	auipc	a0,0x0
  800782:	2fa50513          	addi	a0,a0,762 # 800a78 <main+0x3c6>
  800786:	96fff0ef          	jal	8000f4 <cprintf>
  80078a:	4429                	li	s0,10
  80078c:	347d                	addiw	s0,s0,-1
  80078e:	a47ff0ef          	jal	8001d4 <yield>
  800792:	fc6d                	bnez	s0,80078c <main+0xda>
  800794:	6531                	lui	a0,0xc
  800796:	eaf50513          	addi	a0,a0,-337 # beaf <open-0x7f4171>
  80079a:	a07ff0ef          	jal	8001a0 <exit>
