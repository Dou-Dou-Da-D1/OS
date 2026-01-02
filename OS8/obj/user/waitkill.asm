
obj/__user_waitkill.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	a2ad                	j	80018e <sys_open>

0000000000800026 <close>:
  800026:	aa8d                	j	800198 <sys_close>

0000000000800028 <dup2>:
  800028:	aaa5                	j	8001a0 <sys_dup>

000000000080002a <_start>:
  80002a:	1fc000ef          	jal	800226 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00000517          	auipc	a0,0x0
  800042:	7ca50513          	addi	a0,a0,1994 # 800808 <main+0xc0>
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
  800060:	00001517          	auipc	a0,0x1
  800064:	a8050513          	addi	a0,a0,-1408 # 800ae0 <main+0x398>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	13c000ef          	jal	8001aa <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00000517          	auipc	a0,0x0
  800084:	7a850513          	addi	a0,a0,1960 # 800828 <main+0xe0>
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
  8000a2:	00001517          	auipc	a0,0x1
  8000a6:	a3e50513          	addi	a0,a0,-1474 # 800ae0 <main+0x398>
  8000aa:	04a000ef          	jal	8000f4 <cprintf>
  8000ae:	60e2                	ld	ra,24(sp)
  8000b0:	6442                	ld	s0,16(sp)
  8000b2:	6161                	addi	sp,sp,80
  8000b4:	8082                	ret

00000000008000b6 <cputch>:
  8000b6:	1101                	addi	sp,sp,-32
  8000b8:	ec06                	sd	ra,24(sp)
  8000ba:	e42e                	sd	a1,8(sp)
  8000bc:	0cc000ef          	jal	800188 <sys_putc>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <parent+0xffffffffff7f5ad1>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	222000ef          	jal	80030a <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <parent+0xffffffffff7f5ad1>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1e8000ef          	jal	80030a <vprintfmt>
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

0000000000800184 <sys_getpid>:
  800184:	4549                	li	a0,18
  800186:	b765                	j	80012e <syscall>

0000000000800188 <sys_putc>:
  800188:	85aa                	mv	a1,a0
  80018a:	4579                	li	a0,30
  80018c:	b74d                	j	80012e <syscall>

000000000080018e <sys_open>:
  80018e:	862e                	mv	a2,a1
  800190:	85aa                	mv	a1,a0
  800192:	06400513          	li	a0,100
  800196:	bf61                	j	80012e <syscall>

0000000000800198 <sys_close>:
  800198:	85aa                	mv	a1,a0
  80019a:	06500513          	li	a0,101
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <sys_dup>:
  8001a0:	862e                	mv	a2,a1
  8001a2:	85aa                	mv	a1,a0
  8001a4:	08200513          	li	a0,130
  8001a8:	b759                	j	80012e <syscall>

00000000008001aa <exit>:
  8001aa:	1141                	addi	sp,sp,-16
  8001ac:	e406                	sd	ra,8(sp)
  8001ae:	fbbff0ef          	jal	800168 <sys_exit>
  8001b2:	00000517          	auipc	a0,0x0
  8001b6:	69650513          	addi	a0,a0,1686 # 800848 <main+0x100>
  8001ba:	f3bff0ef          	jal	8000f4 <cprintf>
  8001be:	a001                	j	8001be <exit+0x14>

00000000008001c0 <fork>:
  8001c0:	b77d                	j	80016e <sys_fork>

00000000008001c2 <waitpid>:
  8001c2:	1101                	addi	sp,sp,-32
  8001c4:	e822                	sd	s0,16(sp)
  8001c6:	842e                	mv	s0,a1
  8001c8:	002c                	addi	a1,sp,8
  8001ca:	ec06                	sd	ra,24(sp)
  8001cc:	fa7ff0ef          	jal	800172 <sys_wait>
  8001d0:	c019                	beqz	s0,8001d6 <waitpid+0x14>
  8001d2:	67a2                	ld	a5,8(sp)
  8001d4:	c01c                	sw	a5,0(s0)
  8001d6:	60e2                	ld	ra,24(sp)
  8001d8:	6442                	ld	s0,16(sp)
  8001da:	6105                	addi	sp,sp,32
  8001dc:	8082                	ret

00000000008001de <yield>:
  8001de:	bf71                	j	80017a <sys_yield>

00000000008001e0 <kill>:
  8001e0:	bf79                	j	80017e <sys_kill>

00000000008001e2 <getpid>:
  8001e2:	b74d                	j	800184 <sys_getpid>

00000000008001e4 <initfd>:
  8001e4:	87ae                	mv	a5,a1
  8001e6:	1101                	addi	sp,sp,-32
  8001e8:	e822                	sd	s0,16(sp)
  8001ea:	85b2                	mv	a1,a2
  8001ec:	842a                	mv	s0,a0
  8001ee:	853e                	mv	a0,a5
  8001f0:	ec06                	sd	ra,24(sp)
  8001f2:	e2fff0ef          	jal	800020 <open>
  8001f6:	87aa                	mv	a5,a0
  8001f8:	00054463          	bltz	a0,800200 <initfd+0x1c>
  8001fc:	00851763          	bne	a0,s0,80020a <initfd+0x26>
  800200:	60e2                	ld	ra,24(sp)
  800202:	6442                	ld	s0,16(sp)
  800204:	853e                	mv	a0,a5
  800206:	6105                	addi	sp,sp,32
  800208:	8082                	ret
  80020a:	e42a                	sd	a0,8(sp)
  80020c:	8522                	mv	a0,s0
  80020e:	e19ff0ef          	jal	800026 <close>
  800212:	6522                	ld	a0,8(sp)
  800214:	85a2                	mv	a1,s0
  800216:	e13ff0ef          	jal	800028 <dup2>
  80021a:	842a                	mv	s0,a0
  80021c:	6522                	ld	a0,8(sp)
  80021e:	e09ff0ef          	jal	800026 <close>
  800222:	87a2                	mv	a5,s0
  800224:	bff1                	j	800200 <initfd+0x1c>

0000000000800226 <umain>:
  800226:	1101                	addi	sp,sp,-32
  800228:	e822                	sd	s0,16(sp)
  80022a:	e426                	sd	s1,8(sp)
  80022c:	842a                	mv	s0,a0
  80022e:	84ae                	mv	s1,a1
  800230:	4601                	li	a2,0
  800232:	00000597          	auipc	a1,0x0
  800236:	62e58593          	addi	a1,a1,1582 # 800860 <main+0x118>
  80023a:	4501                	li	a0,0
  80023c:	ec06                	sd	ra,24(sp)
  80023e:	fa7ff0ef          	jal	8001e4 <initfd>
  800242:	02054263          	bltz	a0,800266 <umain+0x40>
  800246:	4605                	li	a2,1
  800248:	8532                	mv	a0,a2
  80024a:	00000597          	auipc	a1,0x0
  80024e:	65658593          	addi	a1,a1,1622 # 8008a0 <main+0x158>
  800252:	f93ff0ef          	jal	8001e4 <initfd>
  800256:	02054563          	bltz	a0,800280 <umain+0x5a>
  80025a:	85a6                	mv	a1,s1
  80025c:	8522                	mv	a0,s0
  80025e:	4ea000ef          	jal	800748 <main>
  800262:	f49ff0ef          	jal	8001aa <exit>
  800266:	86aa                	mv	a3,a0
  800268:	00000617          	auipc	a2,0x0
  80026c:	60060613          	addi	a2,a2,1536 # 800868 <main+0x120>
  800270:	45e9                	li	a1,26
  800272:	00000517          	auipc	a0,0x0
  800276:	61650513          	addi	a0,a0,1558 # 800888 <main+0x140>
  80027a:	df9ff0ef          	jal	800072 <__warn>
  80027e:	b7e1                	j	800246 <umain+0x20>
  800280:	86aa                	mv	a3,a0
  800282:	00000617          	auipc	a2,0x0
  800286:	62660613          	addi	a2,a2,1574 # 8008a8 <main+0x160>
  80028a:	45f5                	li	a1,29
  80028c:	00000517          	auipc	a0,0x0
  800290:	5fc50513          	addi	a0,a0,1532 # 800888 <main+0x140>
  800294:	ddfff0ef          	jal	800072 <__warn>
  800298:	b7c9                	j	80025a <umain+0x34>

000000000080029a <printnum>:
  80029a:	7139                	addi	sp,sp,-64
  80029c:	02071893          	slli	a7,a4,0x20
  8002a0:	f822                	sd	s0,48(sp)
  8002a2:	f426                	sd	s1,40(sp)
  8002a4:	f04a                	sd	s2,32(sp)
  8002a6:	ec4e                	sd	s3,24(sp)
  8002a8:	e456                	sd	s5,8(sp)
  8002aa:	0208d893          	srli	a7,a7,0x20
  8002ae:	fc06                	sd	ra,56(sp)
  8002b0:	0316fab3          	remu	s5,a3,a7
  8002b4:	fff7841b          	addiw	s0,a5,-1
  8002b8:	84aa                	mv	s1,a0
  8002ba:	89ae                	mv	s3,a1
  8002bc:	8932                	mv	s2,a2
  8002be:	0516f063          	bgeu	a3,a7,8002fe <printnum+0x64>
  8002c2:	e852                	sd	s4,16(sp)
  8002c4:	4705                	li	a4,1
  8002c6:	8a42                	mv	s4,a6
  8002c8:	00f75863          	bge	a4,a5,8002d8 <printnum+0x3e>
  8002cc:	864e                	mv	a2,s3
  8002ce:	85ca                	mv	a1,s2
  8002d0:	8552                	mv	a0,s4
  8002d2:	347d                	addiw	s0,s0,-1
  8002d4:	9482                	jalr	s1
  8002d6:	f87d                	bnez	s0,8002cc <printnum+0x32>
  8002d8:	6a42                	ld	s4,16(sp)
  8002da:	00000797          	auipc	a5,0x0
  8002de:	5ee78793          	addi	a5,a5,1518 # 8008c8 <main+0x180>
  8002e2:	97d6                	add	a5,a5,s5
  8002e4:	7442                	ld	s0,48(sp)
  8002e6:	0007c503          	lbu	a0,0(a5)
  8002ea:	70e2                	ld	ra,56(sp)
  8002ec:	6aa2                	ld	s5,8(sp)
  8002ee:	864e                	mv	a2,s3
  8002f0:	85ca                	mv	a1,s2
  8002f2:	69e2                	ld	s3,24(sp)
  8002f4:	7902                	ld	s2,32(sp)
  8002f6:	87a6                	mv	a5,s1
  8002f8:	74a2                	ld	s1,40(sp)
  8002fa:	6121                	addi	sp,sp,64
  8002fc:	8782                	jr	a5
  8002fe:	0316d6b3          	divu	a3,a3,a7
  800302:	87a2                	mv	a5,s0
  800304:	f97ff0ef          	jal	80029a <printnum>
  800308:	bfc9                	j	8002da <printnum+0x40>

000000000080030a <vprintfmt>:
  80030a:	7119                	addi	sp,sp,-128
  80030c:	f4a6                	sd	s1,104(sp)
  80030e:	f0ca                	sd	s2,96(sp)
  800310:	ecce                	sd	s3,88(sp)
  800312:	e8d2                	sd	s4,80(sp)
  800314:	e4d6                	sd	s5,72(sp)
  800316:	e0da                	sd	s6,64(sp)
  800318:	fc5e                	sd	s7,56(sp)
  80031a:	f466                	sd	s9,40(sp)
  80031c:	fc86                	sd	ra,120(sp)
  80031e:	f8a2                	sd	s0,112(sp)
  800320:	f862                	sd	s8,48(sp)
  800322:	f06a                	sd	s10,32(sp)
  800324:	ec6e                	sd	s11,24(sp)
  800326:	84aa                	mv	s1,a0
  800328:	8cb6                	mv	s9,a3
  80032a:	8aba                	mv	s5,a4
  80032c:	89ae                	mv	s3,a1
  80032e:	8932                	mv	s2,a2
  800330:	02500a13          	li	s4,37
  800334:	05500b93          	li	s7,85
  800338:	00001b17          	auipc	s6,0x1
  80033c:	85cb0b13          	addi	s6,s6,-1956 # 800b94 <main+0x44c>
  800340:	000cc503          	lbu	a0,0(s9)
  800344:	001c8413          	addi	s0,s9,1
  800348:	01450b63          	beq	a0,s4,80035e <vprintfmt+0x54>
  80034c:	cd15                	beqz	a0,800388 <vprintfmt+0x7e>
  80034e:	864e                	mv	a2,s3
  800350:	85ca                	mv	a1,s2
  800352:	9482                	jalr	s1
  800354:	00044503          	lbu	a0,0(s0)
  800358:	0405                	addi	s0,s0,1
  80035a:	ff4519e3          	bne	a0,s4,80034c <vprintfmt+0x42>
  80035e:	5d7d                	li	s10,-1
  800360:	8dea                	mv	s11,s10
  800362:	02000813          	li	a6,32
  800366:	4c01                	li	s8,0
  800368:	4581                	li	a1,0
  80036a:	00044703          	lbu	a4,0(s0)
  80036e:	00140c93          	addi	s9,s0,1
  800372:	fdd7061b          	addiw	a2,a4,-35
  800376:	0ff67613          	zext.b	a2,a2
  80037a:	02cbe663          	bltu	s7,a2,8003a6 <vprintfmt+0x9c>
  80037e:	060a                	slli	a2,a2,0x2
  800380:	965a                	add	a2,a2,s6
  800382:	421c                	lw	a5,0(a2)
  800384:	97da                	add	a5,a5,s6
  800386:	8782                	jr	a5
  800388:	70e6                	ld	ra,120(sp)
  80038a:	7446                	ld	s0,112(sp)
  80038c:	74a6                	ld	s1,104(sp)
  80038e:	7906                	ld	s2,96(sp)
  800390:	69e6                	ld	s3,88(sp)
  800392:	6a46                	ld	s4,80(sp)
  800394:	6aa6                	ld	s5,72(sp)
  800396:	6b06                	ld	s6,64(sp)
  800398:	7be2                	ld	s7,56(sp)
  80039a:	7c42                	ld	s8,48(sp)
  80039c:	7ca2                	ld	s9,40(sp)
  80039e:	7d02                	ld	s10,32(sp)
  8003a0:	6de2                	ld	s11,24(sp)
  8003a2:	6109                	addi	sp,sp,128
  8003a4:	8082                	ret
  8003a6:	864e                	mv	a2,s3
  8003a8:	85ca                	mv	a1,s2
  8003aa:	02500513          	li	a0,37
  8003ae:	9482                	jalr	s1
  8003b0:	fff44783          	lbu	a5,-1(s0)
  8003b4:	02500713          	li	a4,37
  8003b8:	8ca2                	mv	s9,s0
  8003ba:	f8e783e3          	beq	a5,a4,800340 <vprintfmt+0x36>
  8003be:	ffecc783          	lbu	a5,-2(s9)
  8003c2:	1cfd                	addi	s9,s9,-1
  8003c4:	fee79de3          	bne	a5,a4,8003be <vprintfmt+0xb4>
  8003c8:	bfa5                	j	800340 <vprintfmt+0x36>
  8003ca:	00144683          	lbu	a3,1(s0)
  8003ce:	4525                	li	a0,9
  8003d0:	fd070d1b          	addiw	s10,a4,-48
  8003d4:	fd06879b          	addiw	a5,a3,-48
  8003d8:	28f56063          	bltu	a0,a5,800658 <vprintfmt+0x34e>
  8003dc:	2681                	sext.w	a3,a3
  8003de:	8466                	mv	s0,s9
  8003e0:	002d179b          	slliw	a5,s10,0x2
  8003e4:	00144703          	lbu	a4,1(s0)
  8003e8:	01a787bb          	addw	a5,a5,s10
  8003ec:	0017979b          	slliw	a5,a5,0x1
  8003f0:	9fb5                	addw	a5,a5,a3
  8003f2:	fd07061b          	addiw	a2,a4,-48
  8003f6:	0405                	addi	s0,s0,1
  8003f8:	fd078d1b          	addiw	s10,a5,-48
  8003fc:	0007069b          	sext.w	a3,a4
  800400:	fec570e3          	bgeu	a0,a2,8003e0 <vprintfmt+0xd6>
  800404:	f60dd3e3          	bgez	s11,80036a <vprintfmt+0x60>
  800408:	8dea                	mv	s11,s10
  80040a:	5d7d                	li	s10,-1
  80040c:	bfb9                	j	80036a <vprintfmt+0x60>
  80040e:	883a                	mv	a6,a4
  800410:	8466                	mv	s0,s9
  800412:	bfa1                	j	80036a <vprintfmt+0x60>
  800414:	8466                	mv	s0,s9
  800416:	4c05                	li	s8,1
  800418:	bf89                	j	80036a <vprintfmt+0x60>
  80041a:	4785                	li	a5,1
  80041c:	008a8613          	addi	a2,s5,8
  800420:	00b7c463          	blt	a5,a1,800428 <vprintfmt+0x11e>
  800424:	1c058363          	beqz	a1,8005ea <vprintfmt+0x2e0>
  800428:	000ab683          	ld	a3,0(s5)
  80042c:	4741                	li	a4,16
  80042e:	8ab2                	mv	s5,a2
  800430:	2801                	sext.w	a6,a6
  800432:	87ee                	mv	a5,s11
  800434:	864a                	mv	a2,s2
  800436:	85ce                	mv	a1,s3
  800438:	8526                	mv	a0,s1
  80043a:	e61ff0ef          	jal	80029a <printnum>
  80043e:	b709                	j	800340 <vprintfmt+0x36>
  800440:	000aa503          	lw	a0,0(s5)
  800444:	864e                	mv	a2,s3
  800446:	85ca                	mv	a1,s2
  800448:	9482                	jalr	s1
  80044a:	0aa1                	addi	s5,s5,8
  80044c:	bdd5                	j	800340 <vprintfmt+0x36>
  80044e:	4785                	li	a5,1
  800450:	008a8613          	addi	a2,s5,8
  800454:	00b7c463          	blt	a5,a1,80045c <vprintfmt+0x152>
  800458:	18058463          	beqz	a1,8005e0 <vprintfmt+0x2d6>
  80045c:	000ab683          	ld	a3,0(s5)
  800460:	4729                	li	a4,10
  800462:	8ab2                	mv	s5,a2
  800464:	b7f1                	j	800430 <vprintfmt+0x126>
  800466:	864e                	mv	a2,s3
  800468:	85ca                	mv	a1,s2
  80046a:	03000513          	li	a0,48
  80046e:	e042                	sd	a6,0(sp)
  800470:	9482                	jalr	s1
  800472:	864e                	mv	a2,s3
  800474:	85ca                	mv	a1,s2
  800476:	07800513          	li	a0,120
  80047a:	9482                	jalr	s1
  80047c:	000ab683          	ld	a3,0(s5)
  800480:	6802                	ld	a6,0(sp)
  800482:	4741                	li	a4,16
  800484:	0aa1                	addi	s5,s5,8
  800486:	b76d                	j	800430 <vprintfmt+0x126>
  800488:	864e                	mv	a2,s3
  80048a:	85ca                	mv	a1,s2
  80048c:	02500513          	li	a0,37
  800490:	9482                	jalr	s1
  800492:	b57d                	j	800340 <vprintfmt+0x36>
  800494:	000aad03          	lw	s10,0(s5)
  800498:	8466                	mv	s0,s9
  80049a:	0aa1                	addi	s5,s5,8
  80049c:	b7a5                	j	800404 <vprintfmt+0xfa>
  80049e:	4785                	li	a5,1
  8004a0:	008a8613          	addi	a2,s5,8
  8004a4:	00b7c463          	blt	a5,a1,8004ac <vprintfmt+0x1a2>
  8004a8:	12058763          	beqz	a1,8005d6 <vprintfmt+0x2cc>
  8004ac:	000ab683          	ld	a3,0(s5)
  8004b0:	4721                	li	a4,8
  8004b2:	8ab2                	mv	s5,a2
  8004b4:	bfb5                	j	800430 <vprintfmt+0x126>
  8004b6:	87ee                	mv	a5,s11
  8004b8:	000dd363          	bgez	s11,8004be <vprintfmt+0x1b4>
  8004bc:	4781                	li	a5,0
  8004be:	00078d9b          	sext.w	s11,a5
  8004c2:	8466                	mv	s0,s9
  8004c4:	b55d                	j	80036a <vprintfmt+0x60>
  8004c6:	0008041b          	sext.w	s0,a6
  8004ca:	fd340793          	addi	a5,s0,-45
  8004ce:	01b02733          	sgtz	a4,s11
  8004d2:	00f037b3          	snez	a5,a5
  8004d6:	8ff9                	and	a5,a5,a4
  8004d8:	000ab703          	ld	a4,0(s5)
  8004dc:	008a8693          	addi	a3,s5,8
  8004e0:	e436                	sd	a3,8(sp)
  8004e2:	12070563          	beqz	a4,80060c <vprintfmt+0x302>
  8004e6:	12079d63          	bnez	a5,800620 <vprintfmt+0x316>
  8004ea:	00074783          	lbu	a5,0(a4)
  8004ee:	0007851b          	sext.w	a0,a5
  8004f2:	c78d                	beqz	a5,80051c <vprintfmt+0x212>
  8004f4:	00170a93          	addi	s5,a4,1
  8004f8:	547d                	li	s0,-1
  8004fa:	000d4563          	bltz	s10,800504 <vprintfmt+0x1fa>
  8004fe:	3d7d                	addiw	s10,s10,-1
  800500:	008d0e63          	beq	s10,s0,80051c <vprintfmt+0x212>
  800504:	020c1863          	bnez	s8,800534 <vprintfmt+0x22a>
  800508:	864e                	mv	a2,s3
  80050a:	85ca                	mv	a1,s2
  80050c:	9482                	jalr	s1
  80050e:	000ac783          	lbu	a5,0(s5)
  800512:	0a85                	addi	s5,s5,1
  800514:	3dfd                	addiw	s11,s11,-1
  800516:	0007851b          	sext.w	a0,a5
  80051a:	f3e5                	bnez	a5,8004fa <vprintfmt+0x1f0>
  80051c:	01b05a63          	blez	s11,800530 <vprintfmt+0x226>
  800520:	864e                	mv	a2,s3
  800522:	85ca                	mv	a1,s2
  800524:	02000513          	li	a0,32
  800528:	3dfd                	addiw	s11,s11,-1
  80052a:	9482                	jalr	s1
  80052c:	fe0d9ae3          	bnez	s11,800520 <vprintfmt+0x216>
  800530:	6aa2                	ld	s5,8(sp)
  800532:	b539                	j	800340 <vprintfmt+0x36>
  800534:	3781                	addiw	a5,a5,-32
  800536:	05e00713          	li	a4,94
  80053a:	fcf777e3          	bgeu	a4,a5,800508 <vprintfmt+0x1fe>
  80053e:	03f00513          	li	a0,63
  800542:	864e                	mv	a2,s3
  800544:	85ca                	mv	a1,s2
  800546:	9482                	jalr	s1
  800548:	000ac783          	lbu	a5,0(s5)
  80054c:	0a85                	addi	s5,s5,1
  80054e:	3dfd                	addiw	s11,s11,-1
  800550:	0007851b          	sext.w	a0,a5
  800554:	d7e1                	beqz	a5,80051c <vprintfmt+0x212>
  800556:	fa0d54e3          	bgez	s10,8004fe <vprintfmt+0x1f4>
  80055a:	bfe9                	j	800534 <vprintfmt+0x22a>
  80055c:	000aa783          	lw	a5,0(s5)
  800560:	46e1                	li	a3,24
  800562:	0aa1                	addi	s5,s5,8
  800564:	41f7d71b          	sraiw	a4,a5,0x1f
  800568:	8fb9                	xor	a5,a5,a4
  80056a:	40e7873b          	subw	a4,a5,a4
  80056e:	02e6c663          	blt	a3,a4,80059a <vprintfmt+0x290>
  800572:	00000797          	auipc	a5,0x0
  800576:	77e78793          	addi	a5,a5,1918 # 800cf0 <error_string>
  80057a:	00371693          	slli	a3,a4,0x3
  80057e:	97b6                	add	a5,a5,a3
  800580:	639c                	ld	a5,0(a5)
  800582:	cf81                	beqz	a5,80059a <vprintfmt+0x290>
  800584:	873e                	mv	a4,a5
  800586:	00000697          	auipc	a3,0x0
  80058a:	37268693          	addi	a3,a3,882 # 8008f8 <main+0x1b0>
  80058e:	864a                	mv	a2,s2
  800590:	85ce                	mv	a1,s3
  800592:	8526                	mv	a0,s1
  800594:	0f2000ef          	jal	800686 <printfmt>
  800598:	b365                	j	800340 <vprintfmt+0x36>
  80059a:	00000697          	auipc	a3,0x0
  80059e:	34e68693          	addi	a3,a3,846 # 8008e8 <main+0x1a0>
  8005a2:	864a                	mv	a2,s2
  8005a4:	85ce                	mv	a1,s3
  8005a6:	8526                	mv	a0,s1
  8005a8:	0de000ef          	jal	800686 <printfmt>
  8005ac:	bb51                	j	800340 <vprintfmt+0x36>
  8005ae:	4785                	li	a5,1
  8005b0:	008a8c13          	addi	s8,s5,8
  8005b4:	00b7c363          	blt	a5,a1,8005ba <vprintfmt+0x2b0>
  8005b8:	cd81                	beqz	a1,8005d0 <vprintfmt+0x2c6>
  8005ba:	000ab403          	ld	s0,0(s5)
  8005be:	02044b63          	bltz	s0,8005f4 <vprintfmt+0x2ea>
  8005c2:	86a2                	mv	a3,s0
  8005c4:	8ae2                	mv	s5,s8
  8005c6:	4729                	li	a4,10
  8005c8:	b5a5                	j	800430 <vprintfmt+0x126>
  8005ca:	2585                	addiw	a1,a1,1
  8005cc:	8466                	mv	s0,s9
  8005ce:	bb71                	j	80036a <vprintfmt+0x60>
  8005d0:	000aa403          	lw	s0,0(s5)
  8005d4:	b7ed                	j	8005be <vprintfmt+0x2b4>
  8005d6:	000ae683          	lwu	a3,0(s5)
  8005da:	4721                	li	a4,8
  8005dc:	8ab2                	mv	s5,a2
  8005de:	bd89                	j	800430 <vprintfmt+0x126>
  8005e0:	000ae683          	lwu	a3,0(s5)
  8005e4:	4729                	li	a4,10
  8005e6:	8ab2                	mv	s5,a2
  8005e8:	b5a1                	j	800430 <vprintfmt+0x126>
  8005ea:	000ae683          	lwu	a3,0(s5)
  8005ee:	4741                	li	a4,16
  8005f0:	8ab2                	mv	s5,a2
  8005f2:	bd3d                	j	800430 <vprintfmt+0x126>
  8005f4:	864e                	mv	a2,s3
  8005f6:	85ca                	mv	a1,s2
  8005f8:	02d00513          	li	a0,45
  8005fc:	e042                	sd	a6,0(sp)
  8005fe:	9482                	jalr	s1
  800600:	6802                	ld	a6,0(sp)
  800602:	408006b3          	neg	a3,s0
  800606:	8ae2                	mv	s5,s8
  800608:	4729                	li	a4,10
  80060a:	b51d                	j	800430 <vprintfmt+0x126>
  80060c:	eba1                	bnez	a5,80065c <vprintfmt+0x352>
  80060e:	02800793          	li	a5,40
  800612:	853e                	mv	a0,a5
  800614:	00000a97          	auipc	s5,0x0
  800618:	2cda8a93          	addi	s5,s5,717 # 8008e1 <main+0x199>
  80061c:	547d                	li	s0,-1
  80061e:	bdf1                	j	8004fa <vprintfmt+0x1f0>
  800620:	853a                	mv	a0,a4
  800622:	85ea                	mv	a1,s10
  800624:	e03a                	sd	a4,0(sp)
  800626:	07e000ef          	jal	8006a4 <strnlen>
  80062a:	40ad8dbb          	subw	s11,s11,a0
  80062e:	6702                	ld	a4,0(sp)
  800630:	01b05b63          	blez	s11,800646 <vprintfmt+0x33c>
  800634:	864e                	mv	a2,s3
  800636:	85ca                	mv	a1,s2
  800638:	8522                	mv	a0,s0
  80063a:	e03a                	sd	a4,0(sp)
  80063c:	3dfd                	addiw	s11,s11,-1
  80063e:	9482                	jalr	s1
  800640:	6702                	ld	a4,0(sp)
  800642:	fe0d99e3          	bnez	s11,800634 <vprintfmt+0x32a>
  800646:	00074783          	lbu	a5,0(a4)
  80064a:	0007851b          	sext.w	a0,a5
  80064e:	ee0781e3          	beqz	a5,800530 <vprintfmt+0x226>
  800652:	00170a93          	addi	s5,a4,1
  800656:	b54d                	j	8004f8 <vprintfmt+0x1ee>
  800658:	8466                	mv	s0,s9
  80065a:	b36d                	j	800404 <vprintfmt+0xfa>
  80065c:	85ea                	mv	a1,s10
  80065e:	00000517          	auipc	a0,0x0
  800662:	28250513          	addi	a0,a0,642 # 8008e0 <main+0x198>
  800666:	03e000ef          	jal	8006a4 <strnlen>
  80066a:	40ad8dbb          	subw	s11,s11,a0
  80066e:	02800793          	li	a5,40
  800672:	00000717          	auipc	a4,0x0
  800676:	26e70713          	addi	a4,a4,622 # 8008e0 <main+0x198>
  80067a:	853e                	mv	a0,a5
  80067c:	fbb04ce3          	bgtz	s11,800634 <vprintfmt+0x32a>
  800680:	00170a93          	addi	s5,a4,1
  800684:	bd95                	j	8004f8 <vprintfmt+0x1ee>

0000000000800686 <printfmt>:
  800686:	7139                	addi	sp,sp,-64
  800688:	02010313          	addi	t1,sp,32
  80068c:	f03a                	sd	a4,32(sp)
  80068e:	871a                	mv	a4,t1
  800690:	ec06                	sd	ra,24(sp)
  800692:	f43e                	sd	a5,40(sp)
  800694:	f842                	sd	a6,48(sp)
  800696:	fc46                	sd	a7,56(sp)
  800698:	e41a                	sd	t1,8(sp)
  80069a:	c71ff0ef          	jal	80030a <vprintfmt>
  80069e:	60e2                	ld	ra,24(sp)
  8006a0:	6121                	addi	sp,sp,64
  8006a2:	8082                	ret

00000000008006a4 <strnlen>:
  8006a4:	4781                	li	a5,0
  8006a6:	e589                	bnez	a1,8006b0 <strnlen+0xc>
  8006a8:	a811                	j	8006bc <strnlen+0x18>
  8006aa:	0785                	addi	a5,a5,1
  8006ac:	00f58863          	beq	a1,a5,8006bc <strnlen+0x18>
  8006b0:	00f50733          	add	a4,a0,a5
  8006b4:	00074703          	lbu	a4,0(a4)
  8006b8:	fb6d                	bnez	a4,8006aa <strnlen+0x6>
  8006ba:	85be                	mv	a1,a5
  8006bc:	852e                	mv	a0,a1
  8006be:	8082                	ret

00000000008006c0 <do_yield>:
  8006c0:	1141                	addi	sp,sp,-16
  8006c2:	e406                	sd	ra,8(sp)
  8006c4:	b1bff0ef          	jal	8001de <yield>
  8006c8:	b17ff0ef          	jal	8001de <yield>
  8006cc:	b13ff0ef          	jal	8001de <yield>
  8006d0:	b0fff0ef          	jal	8001de <yield>
  8006d4:	b0bff0ef          	jal	8001de <yield>
  8006d8:	60a2                	ld	ra,8(sp)
  8006da:	0141                	addi	sp,sp,16
  8006dc:	b609                	j	8001de <yield>

00000000008006de <loop>:
  8006de:	1141                	addi	sp,sp,-16
  8006e0:	00000517          	auipc	a0,0x0
  8006e4:	3f850513          	addi	a0,a0,1016 # 800ad8 <main+0x390>
  8006e8:	e406                	sd	ra,8(sp)
  8006ea:	a0bff0ef          	jal	8000f4 <cprintf>
  8006ee:	a001                	j	8006ee <loop+0x10>

00000000008006f0 <work>:
  8006f0:	1141                	addi	sp,sp,-16
  8006f2:	00000517          	auipc	a0,0x0
  8006f6:	3f650513          	addi	a0,a0,1014 # 800ae8 <main+0x3a0>
  8006fa:	e406                	sd	ra,8(sp)
  8006fc:	9f9ff0ef          	jal	8000f4 <cprintf>
  800700:	fc1ff0ef          	jal	8006c0 <do_yield>
  800704:	00001517          	auipc	a0,0x1
  800708:	90452503          	lw	a0,-1788(a0) # 801008 <parent>
  80070c:	ad5ff0ef          	jal	8001e0 <kill>
  800710:	e105                	bnez	a0,800730 <work+0x40>
  800712:	00000517          	auipc	a0,0x0
  800716:	3e650513          	addi	a0,a0,998 # 800af8 <main+0x3b0>
  80071a:	9dbff0ef          	jal	8000f4 <cprintf>
  80071e:	fa3ff0ef          	jal	8006c0 <do_yield>
  800722:	00001517          	auipc	a0,0x1
  800726:	8e252503          	lw	a0,-1822(a0) # 801004 <pid1>
  80072a:	ab7ff0ef          	jal	8001e0 <kill>
  80072e:	c501                	beqz	a0,800736 <work+0x46>
  800730:	557d                	li	a0,-1
  800732:	a79ff0ef          	jal	8001aa <exit>
  800736:	00000517          	auipc	a0,0x0
  80073a:	3da50513          	addi	a0,a0,986 # 800b10 <main+0x3c8>
  80073e:	9b7ff0ef          	jal	8000f4 <cprintf>
  800742:	4501                	li	a0,0
  800744:	a67ff0ef          	jal	8001aa <exit>

0000000000800748 <main>:
  800748:	1141                	addi	sp,sp,-16
  80074a:	e406                	sd	ra,8(sp)
  80074c:	a97ff0ef          	jal	8001e2 <getpid>
  800750:	00001797          	auipc	a5,0x1
  800754:	8aa7ac23          	sw	a0,-1864(a5) # 801008 <parent>
  800758:	a69ff0ef          	jal	8001c0 <fork>
  80075c:	00001797          	auipc	a5,0x1
  800760:	8aa7a423          	sw	a0,-1880(a5) # 801004 <pid1>
  800764:	c92d                	beqz	a0,8007d6 <main+0x8e>
  800766:	04a05863          	blez	a0,8007b6 <main+0x6e>
  80076a:	a57ff0ef          	jal	8001c0 <fork>
  80076e:	00001797          	auipc	a5,0x1
  800772:	88a7a923          	sw	a0,-1902(a5) # 801000 <pid2>
  800776:	c541                	beqz	a0,8007fe <main+0xb6>
  800778:	06a05163          	blez	a0,8007da <main+0x92>
  80077c:	00000517          	auipc	a0,0x0
  800780:	3e450513          	addi	a0,a0,996 # 800b60 <main+0x418>
  800784:	971ff0ef          	jal	8000f4 <cprintf>
  800788:	00001517          	auipc	a0,0x1
  80078c:	87c52503          	lw	a0,-1924(a0) # 801004 <pid1>
  800790:	4581                	li	a1,0
  800792:	a31ff0ef          	jal	8001c2 <waitpid>
  800796:	00001697          	auipc	a3,0x1
  80079a:	86e6a683          	lw	a3,-1938(a3) # 801004 <pid1>
  80079e:	00000617          	auipc	a2,0x0
  8007a2:	3d260613          	addi	a2,a2,978 # 800b70 <main+0x428>
  8007a6:	03400593          	li	a1,52
  8007aa:	00000517          	auipc	a0,0x0
  8007ae:	3a650513          	addi	a0,a0,934 # 800b50 <main+0x408>
  8007b2:	87fff0ef          	jal	800030 <__panic>
  8007b6:	00000697          	auipc	a3,0x0
  8007ba:	37268693          	addi	a3,a3,882 # 800b28 <main+0x3e0>
  8007be:	00000617          	auipc	a2,0x0
  8007c2:	37a60613          	addi	a2,a2,890 # 800b38 <main+0x3f0>
  8007c6:	02c00593          	li	a1,44
  8007ca:	00000517          	auipc	a0,0x0
  8007ce:	38650513          	addi	a0,a0,902 # 800b50 <main+0x408>
  8007d2:	85fff0ef          	jal	800030 <__panic>
  8007d6:	f09ff0ef          	jal	8006de <loop>
  8007da:	00001517          	auipc	a0,0x1
  8007de:	82a52503          	lw	a0,-2006(a0) # 801004 <pid1>
  8007e2:	9ffff0ef          	jal	8001e0 <kill>
  8007e6:	00000617          	auipc	a2,0x0
  8007ea:	3a260613          	addi	a2,a2,930 # 800b88 <main+0x440>
  8007ee:	03900593          	li	a1,57
  8007f2:	00000517          	auipc	a0,0x0
  8007f6:	35e50513          	addi	a0,a0,862 # 800b50 <main+0x408>
  8007fa:	837ff0ef          	jal	800030 <__panic>
  8007fe:	ef3ff0ef          	jal	8006f0 <work>
