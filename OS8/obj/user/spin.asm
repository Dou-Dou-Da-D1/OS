
obj/__user_spin.out:     file format elf64-littleriscv


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
  80002a:	1f6000ef          	jal	800220 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	74a50513          	addi	a0,a0,1866 # 800788 <main+0xce>
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
  800064:	74850513          	addi	a0,a0,1864 # 8007a8 <main+0xee>
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
  800084:	73050513          	addi	a0,a0,1840 # 8007b0 <main+0xf6>
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
  8000a6:	70650513          	addi	a0,a0,1798 # 8007a8 <main+0xee>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0c8000ef          	jal	800184 <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5de9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	21c000ef          	jal	800304 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <error_string+0xffffffffff7f5de9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1e2000ef          	jal	800304 <vprintfmt>
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

000000000080017e <sys_kill>:
  80017e:	85aa                	mv	a1,a0
  800180:	4531                	li	a0,12
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_putc>:
  800184:	85aa                	mv	a1,a0
  800186:	4579                	li	a0,30
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
  8001b2:	62250513          	addi	a0,a0,1570 # 8007d0 <main+0x116>
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

00000000008001da <yield>:
  8001da:	b745                	j	80017a <sys_yield>

00000000008001dc <kill>:
  8001dc:	b74d                	j	80017e <sys_kill>

00000000008001de <initfd>:
  8001de:	87ae                	mv	a5,a1
  8001e0:	1101                	addi	sp,sp,-32
  8001e2:	e822                	sd	s0,16(sp)
  8001e4:	85b2                	mv	a1,a2
  8001e6:	842a                	mv	s0,a0
  8001e8:	853e                	mv	a0,a5
  8001ea:	ec06                	sd	ra,24(sp)
  8001ec:	e35ff0ef          	jal	800020 <open>
  8001f0:	87aa                	mv	a5,a0
  8001f2:	00054463          	bltz	a0,8001fa <initfd+0x1c>
  8001f6:	00851763          	bne	a0,s0,800204 <initfd+0x26>
  8001fa:	60e2                	ld	ra,24(sp)
  8001fc:	6442                	ld	s0,16(sp)
  8001fe:	853e                	mv	a0,a5
  800200:	6105                	addi	sp,sp,32
  800202:	8082                	ret
  800204:	e42a                	sd	a0,8(sp)
  800206:	8522                	mv	a0,s0
  800208:	e1fff0ef          	jal	800026 <close>
  80020c:	6522                	ld	a0,8(sp)
  80020e:	85a2                	mv	a1,s0
  800210:	e19ff0ef          	jal	800028 <dup2>
  800214:	842a                	mv	s0,a0
  800216:	6522                	ld	a0,8(sp)
  800218:	e0fff0ef          	jal	800026 <close>
  80021c:	87a2                	mv	a5,s0
  80021e:	bff1                	j	8001fa <initfd+0x1c>

0000000000800220 <umain>:
  800220:	1101                	addi	sp,sp,-32
  800222:	e822                	sd	s0,16(sp)
  800224:	e426                	sd	s1,8(sp)
  800226:	842a                	mv	s0,a0
  800228:	84ae                	mv	s1,a1
  80022a:	4601                	li	a2,0
  80022c:	00000597          	auipc	a1,0x0
  800230:	5bc58593          	addi	a1,a1,1468 # 8007e8 <main+0x12e>
  800234:	4501                	li	a0,0
  800236:	ec06                	sd	ra,24(sp)
  800238:	fa7ff0ef          	jal	8001de <initfd>
  80023c:	02054263          	bltz	a0,800260 <umain+0x40>
  800240:	4605                	li	a2,1
  800242:	8532                	mv	a0,a2
  800244:	00000597          	auipc	a1,0x0
  800248:	5e458593          	addi	a1,a1,1508 # 800828 <main+0x16e>
  80024c:	f93ff0ef          	jal	8001de <initfd>
  800250:	02054563          	bltz	a0,80027a <umain+0x5a>
  800254:	85a6                	mv	a1,s1
  800256:	8522                	mv	a0,s0
  800258:	462000ef          	jal	8006ba <main>
  80025c:	f4bff0ef          	jal	8001a6 <exit>
  800260:	86aa                	mv	a3,a0
  800262:	00000617          	auipc	a2,0x0
  800266:	58e60613          	addi	a2,a2,1422 # 8007f0 <main+0x136>
  80026a:	45e9                	li	a1,26
  80026c:	00000517          	auipc	a0,0x0
  800270:	5a450513          	addi	a0,a0,1444 # 800810 <main+0x156>
  800274:	dffff0ef          	jal	800072 <__warn>
  800278:	b7e1                	j	800240 <umain+0x20>
  80027a:	86aa                	mv	a3,a0
  80027c:	00000617          	auipc	a2,0x0
  800280:	5b460613          	addi	a2,a2,1460 # 800830 <main+0x176>
  800284:	45f5                	li	a1,29
  800286:	00000517          	auipc	a0,0x0
  80028a:	58a50513          	addi	a0,a0,1418 # 800810 <main+0x156>
  80028e:	de5ff0ef          	jal	800072 <__warn>
  800292:	b7c9                	j	800254 <umain+0x34>

0000000000800294 <printnum>:
  800294:	7139                	addi	sp,sp,-64
  800296:	02071893          	slli	a7,a4,0x20
  80029a:	f822                	sd	s0,48(sp)
  80029c:	f426                	sd	s1,40(sp)
  80029e:	f04a                	sd	s2,32(sp)
  8002a0:	ec4e                	sd	s3,24(sp)
  8002a2:	e456                	sd	s5,8(sp)
  8002a4:	0208d893          	srli	a7,a7,0x20
  8002a8:	fc06                	sd	ra,56(sp)
  8002aa:	0316fab3          	remu	s5,a3,a7
  8002ae:	fff7841b          	addiw	s0,a5,-1
  8002b2:	84aa                	mv	s1,a0
  8002b4:	89ae                	mv	s3,a1
  8002b6:	8932                	mv	s2,a2
  8002b8:	0516f063          	bgeu	a3,a7,8002f8 <printnum+0x64>
  8002bc:	e852                	sd	s4,16(sp)
  8002be:	4705                	li	a4,1
  8002c0:	8a42                	mv	s4,a6
  8002c2:	00f75863          	bge	a4,a5,8002d2 <printnum+0x3e>
  8002c6:	864e                	mv	a2,s3
  8002c8:	85ca                	mv	a1,s2
  8002ca:	8552                	mv	a0,s4
  8002cc:	347d                	addiw	s0,s0,-1
  8002ce:	9482                	jalr	s1
  8002d0:	f87d                	bnez	s0,8002c6 <printnum+0x32>
  8002d2:	6a42                	ld	s4,16(sp)
  8002d4:	00000797          	auipc	a5,0x0
  8002d8:	57c78793          	addi	a5,a5,1404 # 800850 <main+0x196>
  8002dc:	97d6                	add	a5,a5,s5
  8002de:	7442                	ld	s0,48(sp)
  8002e0:	0007c503          	lbu	a0,0(a5)
  8002e4:	70e2                	ld	ra,56(sp)
  8002e6:	6aa2                	ld	s5,8(sp)
  8002e8:	864e                	mv	a2,s3
  8002ea:	85ca                	mv	a1,s2
  8002ec:	69e2                	ld	s3,24(sp)
  8002ee:	7902                	ld	s2,32(sp)
  8002f0:	87a6                	mv	a5,s1
  8002f2:	74a2                	ld	s1,40(sp)
  8002f4:	6121                	addi	sp,sp,64
  8002f6:	8782                	jr	a5
  8002f8:	0316d6b3          	divu	a3,a3,a7
  8002fc:	87a2                	mv	a5,s0
  8002fe:	f97ff0ef          	jal	800294 <printnum>
  800302:	bfc9                	j	8002d4 <printnum+0x40>

0000000000800304 <vprintfmt>:
  800304:	7119                	addi	sp,sp,-128
  800306:	f4a6                	sd	s1,104(sp)
  800308:	f0ca                	sd	s2,96(sp)
  80030a:	ecce                	sd	s3,88(sp)
  80030c:	e8d2                	sd	s4,80(sp)
  80030e:	e4d6                	sd	s5,72(sp)
  800310:	e0da                	sd	s6,64(sp)
  800312:	fc5e                	sd	s7,56(sp)
  800314:	f466                	sd	s9,40(sp)
  800316:	fc86                	sd	ra,120(sp)
  800318:	f8a2                	sd	s0,112(sp)
  80031a:	f862                	sd	s8,48(sp)
  80031c:	f06a                	sd	s10,32(sp)
  80031e:	ec6e                	sd	s11,24(sp)
  800320:	84aa                	mv	s1,a0
  800322:	8cb6                	mv	s9,a3
  800324:	8aba                	mv	s5,a4
  800326:	89ae                	mv	s3,a1
  800328:	8932                	mv	s2,a2
  80032a:	02500a13          	li	s4,37
  80032e:	05500b93          	li	s7,85
  800332:	00001b17          	auipc	s6,0x1
  800336:	866b0b13          	addi	s6,s6,-1946 # 800b98 <main+0x4de>
  80033a:	000cc503          	lbu	a0,0(s9)
  80033e:	001c8413          	addi	s0,s9,1
  800342:	01450b63          	beq	a0,s4,800358 <vprintfmt+0x54>
  800346:	cd15                	beqz	a0,800382 <vprintfmt+0x7e>
  800348:	864e                	mv	a2,s3
  80034a:	85ca                	mv	a1,s2
  80034c:	9482                	jalr	s1
  80034e:	00044503          	lbu	a0,0(s0)
  800352:	0405                	addi	s0,s0,1
  800354:	ff4519e3          	bne	a0,s4,800346 <vprintfmt+0x42>
  800358:	5d7d                	li	s10,-1
  80035a:	8dea                	mv	s11,s10
  80035c:	02000813          	li	a6,32
  800360:	4c01                	li	s8,0
  800362:	4581                	li	a1,0
  800364:	00044703          	lbu	a4,0(s0)
  800368:	00140c93          	addi	s9,s0,1
  80036c:	fdd7061b          	addiw	a2,a4,-35
  800370:	0ff67613          	zext.b	a2,a2
  800374:	02cbe663          	bltu	s7,a2,8003a0 <vprintfmt+0x9c>
  800378:	060a                	slli	a2,a2,0x2
  80037a:	965a                	add	a2,a2,s6
  80037c:	421c                	lw	a5,0(a2)
  80037e:	97da                	add	a5,a5,s6
  800380:	8782                	jr	a5
  800382:	70e6                	ld	ra,120(sp)
  800384:	7446                	ld	s0,112(sp)
  800386:	74a6                	ld	s1,104(sp)
  800388:	7906                	ld	s2,96(sp)
  80038a:	69e6                	ld	s3,88(sp)
  80038c:	6a46                	ld	s4,80(sp)
  80038e:	6aa6                	ld	s5,72(sp)
  800390:	6b06                	ld	s6,64(sp)
  800392:	7be2                	ld	s7,56(sp)
  800394:	7c42                	ld	s8,48(sp)
  800396:	7ca2                	ld	s9,40(sp)
  800398:	7d02                	ld	s10,32(sp)
  80039a:	6de2                	ld	s11,24(sp)
  80039c:	6109                	addi	sp,sp,128
  80039e:	8082                	ret
  8003a0:	864e                	mv	a2,s3
  8003a2:	85ca                	mv	a1,s2
  8003a4:	02500513          	li	a0,37
  8003a8:	9482                	jalr	s1
  8003aa:	fff44783          	lbu	a5,-1(s0)
  8003ae:	02500713          	li	a4,37
  8003b2:	8ca2                	mv	s9,s0
  8003b4:	f8e783e3          	beq	a5,a4,80033a <vprintfmt+0x36>
  8003b8:	ffecc783          	lbu	a5,-2(s9)
  8003bc:	1cfd                	addi	s9,s9,-1
  8003be:	fee79de3          	bne	a5,a4,8003b8 <vprintfmt+0xb4>
  8003c2:	bfa5                	j	80033a <vprintfmt+0x36>
  8003c4:	00144683          	lbu	a3,1(s0)
  8003c8:	4525                	li	a0,9
  8003ca:	fd070d1b          	addiw	s10,a4,-48
  8003ce:	fd06879b          	addiw	a5,a3,-48
  8003d2:	28f56063          	bltu	a0,a5,800652 <vprintfmt+0x34e>
  8003d6:	2681                	sext.w	a3,a3
  8003d8:	8466                	mv	s0,s9
  8003da:	002d179b          	slliw	a5,s10,0x2
  8003de:	00144703          	lbu	a4,1(s0)
  8003e2:	01a787bb          	addw	a5,a5,s10
  8003e6:	0017979b          	slliw	a5,a5,0x1
  8003ea:	9fb5                	addw	a5,a5,a3
  8003ec:	fd07061b          	addiw	a2,a4,-48
  8003f0:	0405                	addi	s0,s0,1
  8003f2:	fd078d1b          	addiw	s10,a5,-48
  8003f6:	0007069b          	sext.w	a3,a4
  8003fa:	fec570e3          	bgeu	a0,a2,8003da <vprintfmt+0xd6>
  8003fe:	f60dd3e3          	bgez	s11,800364 <vprintfmt+0x60>
  800402:	8dea                	mv	s11,s10
  800404:	5d7d                	li	s10,-1
  800406:	bfb9                	j	800364 <vprintfmt+0x60>
  800408:	883a                	mv	a6,a4
  80040a:	8466                	mv	s0,s9
  80040c:	bfa1                	j	800364 <vprintfmt+0x60>
  80040e:	8466                	mv	s0,s9
  800410:	4c05                	li	s8,1
  800412:	bf89                	j	800364 <vprintfmt+0x60>
  800414:	4785                	li	a5,1
  800416:	008a8613          	addi	a2,s5,8
  80041a:	00b7c463          	blt	a5,a1,800422 <vprintfmt+0x11e>
  80041e:	1c058363          	beqz	a1,8005e4 <vprintfmt+0x2e0>
  800422:	000ab683          	ld	a3,0(s5)
  800426:	4741                	li	a4,16
  800428:	8ab2                	mv	s5,a2
  80042a:	2801                	sext.w	a6,a6
  80042c:	87ee                	mv	a5,s11
  80042e:	864a                	mv	a2,s2
  800430:	85ce                	mv	a1,s3
  800432:	8526                	mv	a0,s1
  800434:	e61ff0ef          	jal	800294 <printnum>
  800438:	b709                	j	80033a <vprintfmt+0x36>
  80043a:	000aa503          	lw	a0,0(s5)
  80043e:	864e                	mv	a2,s3
  800440:	85ca                	mv	a1,s2
  800442:	9482                	jalr	s1
  800444:	0aa1                	addi	s5,s5,8
  800446:	bdd5                	j	80033a <vprintfmt+0x36>
  800448:	4785                	li	a5,1
  80044a:	008a8613          	addi	a2,s5,8
  80044e:	00b7c463          	blt	a5,a1,800456 <vprintfmt+0x152>
  800452:	18058463          	beqz	a1,8005da <vprintfmt+0x2d6>
  800456:	000ab683          	ld	a3,0(s5)
  80045a:	4729                	li	a4,10
  80045c:	8ab2                	mv	s5,a2
  80045e:	b7f1                	j	80042a <vprintfmt+0x126>
  800460:	864e                	mv	a2,s3
  800462:	85ca                	mv	a1,s2
  800464:	03000513          	li	a0,48
  800468:	e042                	sd	a6,0(sp)
  80046a:	9482                	jalr	s1
  80046c:	864e                	mv	a2,s3
  80046e:	85ca                	mv	a1,s2
  800470:	07800513          	li	a0,120
  800474:	9482                	jalr	s1
  800476:	000ab683          	ld	a3,0(s5)
  80047a:	6802                	ld	a6,0(sp)
  80047c:	4741                	li	a4,16
  80047e:	0aa1                	addi	s5,s5,8
  800480:	b76d                	j	80042a <vprintfmt+0x126>
  800482:	864e                	mv	a2,s3
  800484:	85ca                	mv	a1,s2
  800486:	02500513          	li	a0,37
  80048a:	9482                	jalr	s1
  80048c:	b57d                	j	80033a <vprintfmt+0x36>
  80048e:	000aad03          	lw	s10,0(s5)
  800492:	8466                	mv	s0,s9
  800494:	0aa1                	addi	s5,s5,8
  800496:	b7a5                	j	8003fe <vprintfmt+0xfa>
  800498:	4785                	li	a5,1
  80049a:	008a8613          	addi	a2,s5,8
  80049e:	00b7c463          	blt	a5,a1,8004a6 <vprintfmt+0x1a2>
  8004a2:	12058763          	beqz	a1,8005d0 <vprintfmt+0x2cc>
  8004a6:	000ab683          	ld	a3,0(s5)
  8004aa:	4721                	li	a4,8
  8004ac:	8ab2                	mv	s5,a2
  8004ae:	bfb5                	j	80042a <vprintfmt+0x126>
  8004b0:	87ee                	mv	a5,s11
  8004b2:	000dd363          	bgez	s11,8004b8 <vprintfmt+0x1b4>
  8004b6:	4781                	li	a5,0
  8004b8:	00078d9b          	sext.w	s11,a5
  8004bc:	8466                	mv	s0,s9
  8004be:	b55d                	j	800364 <vprintfmt+0x60>
  8004c0:	0008041b          	sext.w	s0,a6
  8004c4:	fd340793          	addi	a5,s0,-45
  8004c8:	01b02733          	sgtz	a4,s11
  8004cc:	00f037b3          	snez	a5,a5
  8004d0:	8ff9                	and	a5,a5,a4
  8004d2:	000ab703          	ld	a4,0(s5)
  8004d6:	008a8693          	addi	a3,s5,8
  8004da:	e436                	sd	a3,8(sp)
  8004dc:	12070563          	beqz	a4,800606 <vprintfmt+0x302>
  8004e0:	12079d63          	bnez	a5,80061a <vprintfmt+0x316>
  8004e4:	00074783          	lbu	a5,0(a4)
  8004e8:	0007851b          	sext.w	a0,a5
  8004ec:	c78d                	beqz	a5,800516 <vprintfmt+0x212>
  8004ee:	00170a93          	addi	s5,a4,1
  8004f2:	547d                	li	s0,-1
  8004f4:	000d4563          	bltz	s10,8004fe <vprintfmt+0x1fa>
  8004f8:	3d7d                	addiw	s10,s10,-1
  8004fa:	008d0e63          	beq	s10,s0,800516 <vprintfmt+0x212>
  8004fe:	020c1863          	bnez	s8,80052e <vprintfmt+0x22a>
  800502:	864e                	mv	a2,s3
  800504:	85ca                	mv	a1,s2
  800506:	9482                	jalr	s1
  800508:	000ac783          	lbu	a5,0(s5)
  80050c:	0a85                	addi	s5,s5,1
  80050e:	3dfd                	addiw	s11,s11,-1
  800510:	0007851b          	sext.w	a0,a5
  800514:	f3e5                	bnez	a5,8004f4 <vprintfmt+0x1f0>
  800516:	01b05a63          	blez	s11,80052a <vprintfmt+0x226>
  80051a:	864e                	mv	a2,s3
  80051c:	85ca                	mv	a1,s2
  80051e:	02000513          	li	a0,32
  800522:	3dfd                	addiw	s11,s11,-1
  800524:	9482                	jalr	s1
  800526:	fe0d9ae3          	bnez	s11,80051a <vprintfmt+0x216>
  80052a:	6aa2                	ld	s5,8(sp)
  80052c:	b539                	j	80033a <vprintfmt+0x36>
  80052e:	3781                	addiw	a5,a5,-32
  800530:	05e00713          	li	a4,94
  800534:	fcf777e3          	bgeu	a4,a5,800502 <vprintfmt+0x1fe>
  800538:	03f00513          	li	a0,63
  80053c:	864e                	mv	a2,s3
  80053e:	85ca                	mv	a1,s2
  800540:	9482                	jalr	s1
  800542:	000ac783          	lbu	a5,0(s5)
  800546:	0a85                	addi	s5,s5,1
  800548:	3dfd                	addiw	s11,s11,-1
  80054a:	0007851b          	sext.w	a0,a5
  80054e:	d7e1                	beqz	a5,800516 <vprintfmt+0x212>
  800550:	fa0d54e3          	bgez	s10,8004f8 <vprintfmt+0x1f4>
  800554:	bfe9                	j	80052e <vprintfmt+0x22a>
  800556:	000aa783          	lw	a5,0(s5)
  80055a:	46e1                	li	a3,24
  80055c:	0aa1                	addi	s5,s5,8
  80055e:	41f7d71b          	sraiw	a4,a5,0x1f
  800562:	8fb9                	xor	a5,a5,a4
  800564:	40e7873b          	subw	a4,a5,a4
  800568:	02e6c663          	blt	a3,a4,800594 <vprintfmt+0x290>
  80056c:	00000797          	auipc	a5,0x0
  800570:	78478793          	addi	a5,a5,1924 # 800cf0 <error_string>
  800574:	00371693          	slli	a3,a4,0x3
  800578:	97b6                	add	a5,a5,a3
  80057a:	639c                	ld	a5,0(a5)
  80057c:	cf81                	beqz	a5,800594 <vprintfmt+0x290>
  80057e:	873e                	mv	a4,a5
  800580:	00000697          	auipc	a3,0x0
  800584:	30068693          	addi	a3,a3,768 # 800880 <main+0x1c6>
  800588:	864a                	mv	a2,s2
  80058a:	85ce                	mv	a1,s3
  80058c:	8526                	mv	a0,s1
  80058e:	0f2000ef          	jal	800680 <printfmt>
  800592:	b365                	j	80033a <vprintfmt+0x36>
  800594:	00000697          	auipc	a3,0x0
  800598:	2dc68693          	addi	a3,a3,732 # 800870 <main+0x1b6>
  80059c:	864a                	mv	a2,s2
  80059e:	85ce                	mv	a1,s3
  8005a0:	8526                	mv	a0,s1
  8005a2:	0de000ef          	jal	800680 <printfmt>
  8005a6:	bb51                	j	80033a <vprintfmt+0x36>
  8005a8:	4785                	li	a5,1
  8005aa:	008a8c13          	addi	s8,s5,8
  8005ae:	00b7c363          	blt	a5,a1,8005b4 <vprintfmt+0x2b0>
  8005b2:	cd81                	beqz	a1,8005ca <vprintfmt+0x2c6>
  8005b4:	000ab403          	ld	s0,0(s5)
  8005b8:	02044b63          	bltz	s0,8005ee <vprintfmt+0x2ea>
  8005bc:	86a2                	mv	a3,s0
  8005be:	8ae2                	mv	s5,s8
  8005c0:	4729                	li	a4,10
  8005c2:	b5a5                	j	80042a <vprintfmt+0x126>
  8005c4:	2585                	addiw	a1,a1,1
  8005c6:	8466                	mv	s0,s9
  8005c8:	bb71                	j	800364 <vprintfmt+0x60>
  8005ca:	000aa403          	lw	s0,0(s5)
  8005ce:	b7ed                	j	8005b8 <vprintfmt+0x2b4>
  8005d0:	000ae683          	lwu	a3,0(s5)
  8005d4:	4721                	li	a4,8
  8005d6:	8ab2                	mv	s5,a2
  8005d8:	bd89                	j	80042a <vprintfmt+0x126>
  8005da:	000ae683          	lwu	a3,0(s5)
  8005de:	4729                	li	a4,10
  8005e0:	8ab2                	mv	s5,a2
  8005e2:	b5a1                	j	80042a <vprintfmt+0x126>
  8005e4:	000ae683          	lwu	a3,0(s5)
  8005e8:	4741                	li	a4,16
  8005ea:	8ab2                	mv	s5,a2
  8005ec:	bd3d                	j	80042a <vprintfmt+0x126>
  8005ee:	864e                	mv	a2,s3
  8005f0:	85ca                	mv	a1,s2
  8005f2:	02d00513          	li	a0,45
  8005f6:	e042                	sd	a6,0(sp)
  8005f8:	9482                	jalr	s1
  8005fa:	6802                	ld	a6,0(sp)
  8005fc:	408006b3          	neg	a3,s0
  800600:	8ae2                	mv	s5,s8
  800602:	4729                	li	a4,10
  800604:	b51d                	j	80042a <vprintfmt+0x126>
  800606:	eba1                	bnez	a5,800656 <vprintfmt+0x352>
  800608:	02800793          	li	a5,40
  80060c:	853e                	mv	a0,a5
  80060e:	00000a97          	auipc	s5,0x0
  800612:	25ba8a93          	addi	s5,s5,603 # 800869 <main+0x1af>
  800616:	547d                	li	s0,-1
  800618:	bdf1                	j	8004f4 <vprintfmt+0x1f0>
  80061a:	853a                	mv	a0,a4
  80061c:	85ea                	mv	a1,s10
  80061e:	e03a                	sd	a4,0(sp)
  800620:	07e000ef          	jal	80069e <strnlen>
  800624:	40ad8dbb          	subw	s11,s11,a0
  800628:	6702                	ld	a4,0(sp)
  80062a:	01b05b63          	blez	s11,800640 <vprintfmt+0x33c>
  80062e:	864e                	mv	a2,s3
  800630:	85ca                	mv	a1,s2
  800632:	8522                	mv	a0,s0
  800634:	e03a                	sd	a4,0(sp)
  800636:	3dfd                	addiw	s11,s11,-1
  800638:	9482                	jalr	s1
  80063a:	6702                	ld	a4,0(sp)
  80063c:	fe0d99e3          	bnez	s11,80062e <vprintfmt+0x32a>
  800640:	00074783          	lbu	a5,0(a4)
  800644:	0007851b          	sext.w	a0,a5
  800648:	ee0781e3          	beqz	a5,80052a <vprintfmt+0x226>
  80064c:	00170a93          	addi	s5,a4,1
  800650:	b54d                	j	8004f2 <vprintfmt+0x1ee>
  800652:	8466                	mv	s0,s9
  800654:	b36d                	j	8003fe <vprintfmt+0xfa>
  800656:	85ea                	mv	a1,s10
  800658:	00000517          	auipc	a0,0x0
  80065c:	21050513          	addi	a0,a0,528 # 800868 <main+0x1ae>
  800660:	03e000ef          	jal	80069e <strnlen>
  800664:	40ad8dbb          	subw	s11,s11,a0
  800668:	02800793          	li	a5,40
  80066c:	00000717          	auipc	a4,0x0
  800670:	1fc70713          	addi	a4,a4,508 # 800868 <main+0x1ae>
  800674:	853e                	mv	a0,a5
  800676:	fbb04ce3          	bgtz	s11,80062e <vprintfmt+0x32a>
  80067a:	00170a93          	addi	s5,a4,1
  80067e:	bd95                	j	8004f2 <vprintfmt+0x1ee>

0000000000800680 <printfmt>:
  800680:	7139                	addi	sp,sp,-64
  800682:	02010313          	addi	t1,sp,32
  800686:	f03a                	sd	a4,32(sp)
  800688:	871a                	mv	a4,t1
  80068a:	ec06                	sd	ra,24(sp)
  80068c:	f43e                	sd	a5,40(sp)
  80068e:	f842                	sd	a6,48(sp)
  800690:	fc46                	sd	a7,56(sp)
  800692:	e41a                	sd	t1,8(sp)
  800694:	c71ff0ef          	jal	800304 <vprintfmt>
  800698:	60e2                	ld	ra,24(sp)
  80069a:	6121                	addi	sp,sp,64
  80069c:	8082                	ret

000000000080069e <strnlen>:
  80069e:	4781                	li	a5,0
  8006a0:	e589                	bnez	a1,8006aa <strnlen+0xc>
  8006a2:	a811                	j	8006b6 <strnlen+0x18>
  8006a4:	0785                	addi	a5,a5,1
  8006a6:	00f58863          	beq	a1,a5,8006b6 <strnlen+0x18>
  8006aa:	00f50733          	add	a4,a0,a5
  8006ae:	00074703          	lbu	a4,0(a4)
  8006b2:	fb6d                	bnez	a4,8006a4 <strnlen+0x6>
  8006b4:	85be                	mv	a1,a5
  8006b6:	852e                	mv	a0,a1
  8006b8:	8082                	ret

00000000008006ba <main>:
  8006ba:	1141                	addi	sp,sp,-16
  8006bc:	00000517          	auipc	a0,0x0
  8006c0:	3a450513          	addi	a0,a0,932 # 800a60 <main+0x3a6>
  8006c4:	e406                	sd	ra,8(sp)
  8006c6:	e022                	sd	s0,0(sp)
  8006c8:	a2dff0ef          	jal	8000f4 <cprintf>
  8006cc:	af1ff0ef          	jal	8001bc <fork>
  8006d0:	e901                	bnez	a0,8006e0 <main+0x26>
  8006d2:	00000517          	auipc	a0,0x0
  8006d6:	3b650513          	addi	a0,a0,950 # 800a88 <main+0x3ce>
  8006da:	a1bff0ef          	jal	8000f4 <cprintf>
  8006de:	a001                	j	8006de <main+0x24>
  8006e0:	842a                	mv	s0,a0
  8006e2:	00000517          	auipc	a0,0x0
  8006e6:	3c650513          	addi	a0,a0,966 # 800aa8 <main+0x3ee>
  8006ea:	a0bff0ef          	jal	8000f4 <cprintf>
  8006ee:	aedff0ef          	jal	8001da <yield>
  8006f2:	ae9ff0ef          	jal	8001da <yield>
  8006f6:	ae5ff0ef          	jal	8001da <yield>
  8006fa:	00000517          	auipc	a0,0x0
  8006fe:	3d650513          	addi	a0,a0,982 # 800ad0 <main+0x416>
  800702:	9f3ff0ef          	jal	8000f4 <cprintf>
  800706:	8522                	mv	a0,s0
  800708:	ad5ff0ef          	jal	8001dc <kill>
  80070c:	ed31                	bnez	a0,800768 <main+0xae>
  80070e:	4581                	li	a1,0
  800710:	00000517          	auipc	a0,0x0
  800714:	42850513          	addi	a0,a0,1064 # 800b38 <main+0x47e>
  800718:	9ddff0ef          	jal	8000f4 <cprintf>
  80071c:	8522                	mv	a0,s0
  80071e:	4581                	li	a1,0
  800720:	a9fff0ef          	jal	8001be <waitpid>
  800724:	e11d                	bnez	a0,80074a <main+0x90>
  800726:	4581                	li	a1,0
  800728:	00000517          	auipc	a0,0x0
  80072c:	44850513          	addi	a0,a0,1096 # 800b70 <main+0x4b6>
  800730:	9c5ff0ef          	jal	8000f4 <cprintf>
  800734:	00000517          	auipc	a0,0x0
  800738:	45450513          	addi	a0,a0,1108 # 800b88 <main+0x4ce>
  80073c:	9b9ff0ef          	jal	8000f4 <cprintf>
  800740:	60a2                	ld	ra,8(sp)
  800742:	6402                	ld	s0,0(sp)
  800744:	4501                	li	a0,0
  800746:	0141                	addi	sp,sp,16
  800748:	8082                	ret
  80074a:	00000697          	auipc	a3,0x0
  80074e:	40668693          	addi	a3,a3,1030 # 800b50 <main+0x496>
  800752:	00000617          	auipc	a2,0x0
  800756:	3be60613          	addi	a2,a2,958 # 800b10 <main+0x456>
  80075a:	45dd                	li	a1,23
  80075c:	00000517          	auipc	a0,0x0
  800760:	3cc50513          	addi	a0,a0,972 # 800b28 <main+0x46e>
  800764:	8cdff0ef          	jal	800030 <__panic>
  800768:	00000697          	auipc	a3,0x0
  80076c:	39068693          	addi	a3,a3,912 # 800af8 <main+0x43e>
  800770:	00000617          	auipc	a2,0x0
  800774:	3a060613          	addi	a2,a2,928 # 800b10 <main+0x456>
  800778:	45d1                	li	a1,20
  80077a:	00000517          	auipc	a0,0x0
  80077e:	3ae50513          	addi	a0,a0,942 # 800b28 <main+0x46e>
  800782:	8afff0ef          	jal	800030 <__panic>
