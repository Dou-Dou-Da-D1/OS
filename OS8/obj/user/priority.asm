
obj/__user_priority.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <open>:
  800020:	1582                	slli	a1,a1,0x20
  800022:	9181                	srli	a1,a1,0x20
  800024:	aa8d                	j	800196 <sys_open>

0000000000800026 <close>:
  800026:	aaad                	j	8001a0 <sys_close>

0000000000800028 <dup2>:
  800028:	a241                	j	8001a8 <sys_dup>

000000000080002a <_start>:
  80002a:	20a000ef          	jal	800234 <umain>
  80002e:	a001                	j	80002e <_start+0x4>

0000000000800030 <__panic>:
  800030:	715d                	addi	sp,sp,-80
  800032:	02810313          	addi	t1,sp,40
  800036:	e822                	sd	s0,16(sp)
  800038:	8432                	mv	s0,a2
  80003a:	862e                	mv	a2,a1
  80003c:	85aa                	mv	a1,a0
  80003e:	00001517          	auipc	a0,0x1
  800042:	85250513          	addi	a0,a0,-1966 # 800890 <main+0x1b0>
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
  800064:	85050513          	addi	a0,a0,-1968 # 8008b0 <main+0x1d0>
  800068:	08c000ef          	jal	8000f4 <cprintf>
  80006c:	5559                	li	a0,-10
  80006e:	144000ef          	jal	8001b2 <exit>

0000000000800072 <__warn>:
  800072:	715d                	addi	sp,sp,-80
  800074:	e822                	sd	s0,16(sp)
  800076:	02810313          	addi	t1,sp,40
  80007a:	8432                	mv	s0,a2
  80007c:	862e                	mv	a2,a1
  80007e:	85aa                	mv	a1,a0
  800080:	00001517          	auipc	a0,0x1
  800084:	83850513          	addi	a0,a0,-1992 # 8008b8 <main+0x1d8>
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
  8000a6:	80e50513          	addi	a0,a0,-2034 # 8008b0 <main+0x1d0>
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
  8000e0:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <acc+0xffffffffff7f5aa9>
  8000e4:	ec06                	sd	ra,24(sp)
  8000e6:	c602                	sw	zero,12(sp)
  8000e8:	230000ef          	jal	800318 <vprintfmt>
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
  800112:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <acc+0xffffffffff7f5aa9>
  800116:	ec06                	sd	ra,24(sp)
  800118:	e4be                	sd	a5,72(sp)
  80011a:	e8c2                	sd	a6,80(sp)
  80011c:	ecc6                	sd	a7,88(sp)
  80011e:	c202                	sw	zero,4(sp)
  800120:	e41a                	sd	t1,8(sp)
  800122:	1f6000ef          	jal	800318 <vprintfmt>
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

000000000080017a <sys_kill>:
  80017a:	85aa                	mv	a1,a0
  80017c:	4531                	li	a0,12
  80017e:	bf45                	j	80012e <syscall>

0000000000800180 <sys_getpid>:
  800180:	4549                	li	a0,18
  800182:	b775                	j	80012e <syscall>

0000000000800184 <sys_putc>:
  800184:	85aa                	mv	a1,a0
  800186:	4579                	li	a0,30
  800188:	b75d                	j	80012e <syscall>

000000000080018a <sys_lab6_set_priority>:
  80018a:	85aa                	mv	a1,a0
  80018c:	0ff00513          	li	a0,255
  800190:	bf79                	j	80012e <syscall>

0000000000800192 <sys_gettime>:
  800192:	4545                	li	a0,17
  800194:	bf69                	j	80012e <syscall>

0000000000800196 <sys_open>:
  800196:	862e                	mv	a2,a1
  800198:	85aa                	mv	a1,a0
  80019a:	06400513          	li	a0,100
  80019e:	bf41                	j	80012e <syscall>

00000000008001a0 <sys_close>:
  8001a0:	85aa                	mv	a1,a0
  8001a2:	06500513          	li	a0,101
  8001a6:	b761                	j	80012e <syscall>

00000000008001a8 <sys_dup>:
  8001a8:	862e                	mv	a2,a1
  8001aa:	85aa                	mv	a1,a0
  8001ac:	08200513          	li	a0,130
  8001b0:	bfbd                	j	80012e <syscall>

00000000008001b2 <exit>:
  8001b2:	1141                	addi	sp,sp,-16
  8001b4:	e406                	sd	ra,8(sp)
  8001b6:	fb3ff0ef          	jal	800168 <sys_exit>
  8001ba:	00000517          	auipc	a0,0x0
  8001be:	71e50513          	addi	a0,a0,1822 # 8008d8 <main+0x1f8>
  8001c2:	f33ff0ef          	jal	8000f4 <cprintf>
  8001c6:	a001                	j	8001c6 <exit+0x14>

00000000008001c8 <fork>:
  8001c8:	b75d                	j	80016e <sys_fork>

00000000008001ca <waitpid>:
  8001ca:	1101                	addi	sp,sp,-32
  8001cc:	e822                	sd	s0,16(sp)
  8001ce:	842e                	mv	s0,a1
  8001d0:	002c                	addi	a1,sp,8
  8001d2:	ec06                	sd	ra,24(sp)
  8001d4:	f9fff0ef          	jal	800172 <sys_wait>
  8001d8:	c019                	beqz	s0,8001de <waitpid+0x14>
  8001da:	67a2                	ld	a5,8(sp)
  8001dc:	c01c                	sw	a5,0(s0)
  8001de:	60e2                	ld	ra,24(sp)
  8001e0:	6442                	ld	s0,16(sp)
  8001e2:	6105                	addi	sp,sp,32
  8001e4:	8082                	ret

00000000008001e6 <kill>:
  8001e6:	bf51                	j	80017a <sys_kill>

00000000008001e8 <getpid>:
  8001e8:	bf61                	j	800180 <sys_getpid>

00000000008001ea <gettime_msec>:
  8001ea:	b765                	j	800192 <sys_gettime>

00000000008001ec <lab6_set_priority>:
  8001ec:	1502                	slli	a0,a0,0x20
  8001ee:	9101                	srli	a0,a0,0x20
  8001f0:	bf69                	j	80018a <sys_lab6_set_priority>

00000000008001f2 <initfd>:
  8001f2:	87ae                	mv	a5,a1
  8001f4:	1101                	addi	sp,sp,-32
  8001f6:	e822                	sd	s0,16(sp)
  8001f8:	85b2                	mv	a1,a2
  8001fa:	842a                	mv	s0,a0
  8001fc:	853e                	mv	a0,a5
  8001fe:	ec06                	sd	ra,24(sp)
  800200:	e21ff0ef          	jal	800020 <open>
  800204:	87aa                	mv	a5,a0
  800206:	00054463          	bltz	a0,80020e <initfd+0x1c>
  80020a:	00851763          	bne	a0,s0,800218 <initfd+0x26>
  80020e:	60e2                	ld	ra,24(sp)
  800210:	6442                	ld	s0,16(sp)
  800212:	853e                	mv	a0,a5
  800214:	6105                	addi	sp,sp,32
  800216:	8082                	ret
  800218:	e42a                	sd	a0,8(sp)
  80021a:	8522                	mv	a0,s0
  80021c:	e0bff0ef          	jal	800026 <close>
  800220:	6522                	ld	a0,8(sp)
  800222:	85a2                	mv	a1,s0
  800224:	e05ff0ef          	jal	800028 <dup2>
  800228:	842a                	mv	s0,a0
  80022a:	6522                	ld	a0,8(sp)
  80022c:	dfbff0ef          	jal	800026 <close>
  800230:	87a2                	mv	a5,s0
  800232:	bff1                	j	80020e <initfd+0x1c>

0000000000800234 <umain>:
  800234:	1101                	addi	sp,sp,-32
  800236:	e822                	sd	s0,16(sp)
  800238:	e426                	sd	s1,8(sp)
  80023a:	842a                	mv	s0,a0
  80023c:	84ae                	mv	s1,a1
  80023e:	4601                	li	a2,0
  800240:	00000597          	auipc	a1,0x0
  800244:	6b058593          	addi	a1,a1,1712 # 8008f0 <main+0x210>
  800248:	4501                	li	a0,0
  80024a:	ec06                	sd	ra,24(sp)
  80024c:	fa7ff0ef          	jal	8001f2 <initfd>
  800250:	02054263          	bltz	a0,800274 <umain+0x40>
  800254:	4605                	li	a2,1
  800256:	8532                	mv	a0,a2
  800258:	00000597          	auipc	a1,0x0
  80025c:	6d858593          	addi	a1,a1,1752 # 800930 <main+0x250>
  800260:	f93ff0ef          	jal	8001f2 <initfd>
  800264:	02054563          	bltz	a0,80028e <umain+0x5a>
  800268:	85a6                	mv	a1,s1
  80026a:	8522                	mv	a0,s0
  80026c:	474000ef          	jal	8006e0 <main>
  800270:	f43ff0ef          	jal	8001b2 <exit>
  800274:	86aa                	mv	a3,a0
  800276:	00000617          	auipc	a2,0x0
  80027a:	68260613          	addi	a2,a2,1666 # 8008f8 <main+0x218>
  80027e:	45e9                	li	a1,26
  800280:	00000517          	auipc	a0,0x0
  800284:	69850513          	addi	a0,a0,1688 # 800918 <main+0x238>
  800288:	debff0ef          	jal	800072 <__warn>
  80028c:	b7e1                	j	800254 <umain+0x20>
  80028e:	86aa                	mv	a3,a0
  800290:	00000617          	auipc	a2,0x0
  800294:	6a860613          	addi	a2,a2,1704 # 800938 <main+0x258>
  800298:	45f5                	li	a1,29
  80029a:	00000517          	auipc	a0,0x0
  80029e:	67e50513          	addi	a0,a0,1662 # 800918 <main+0x238>
  8002a2:	dd1ff0ef          	jal	800072 <__warn>
  8002a6:	b7c9                	j	800268 <umain+0x34>

00000000008002a8 <printnum>:
  8002a8:	7139                	addi	sp,sp,-64
  8002aa:	02071893          	slli	a7,a4,0x20
  8002ae:	f822                	sd	s0,48(sp)
  8002b0:	f426                	sd	s1,40(sp)
  8002b2:	f04a                	sd	s2,32(sp)
  8002b4:	ec4e                	sd	s3,24(sp)
  8002b6:	e456                	sd	s5,8(sp)
  8002b8:	0208d893          	srli	a7,a7,0x20
  8002bc:	fc06                	sd	ra,56(sp)
  8002be:	0316fab3          	remu	s5,a3,a7
  8002c2:	fff7841b          	addiw	s0,a5,-1
  8002c6:	84aa                	mv	s1,a0
  8002c8:	89ae                	mv	s3,a1
  8002ca:	8932                	mv	s2,a2
  8002cc:	0516f063          	bgeu	a3,a7,80030c <printnum+0x64>
  8002d0:	e852                	sd	s4,16(sp)
  8002d2:	4705                	li	a4,1
  8002d4:	8a42                	mv	s4,a6
  8002d6:	00f75863          	bge	a4,a5,8002e6 <printnum+0x3e>
  8002da:	864e                	mv	a2,s3
  8002dc:	85ca                	mv	a1,s2
  8002de:	8552                	mv	a0,s4
  8002e0:	347d                	addiw	s0,s0,-1
  8002e2:	9482                	jalr	s1
  8002e4:	f87d                	bnez	s0,8002da <printnum+0x32>
  8002e6:	6a42                	ld	s4,16(sp)
  8002e8:	00000797          	auipc	a5,0x0
  8002ec:	67078793          	addi	a5,a5,1648 # 800958 <main+0x278>
  8002f0:	97d6                	add	a5,a5,s5
  8002f2:	7442                	ld	s0,48(sp)
  8002f4:	0007c503          	lbu	a0,0(a5)
  8002f8:	70e2                	ld	ra,56(sp)
  8002fa:	6aa2                	ld	s5,8(sp)
  8002fc:	864e                	mv	a2,s3
  8002fe:	85ca                	mv	a1,s2
  800300:	69e2                	ld	s3,24(sp)
  800302:	7902                	ld	s2,32(sp)
  800304:	87a6                	mv	a5,s1
  800306:	74a2                	ld	s1,40(sp)
  800308:	6121                	addi	sp,sp,64
  80030a:	8782                	jr	a5
  80030c:	0316d6b3          	divu	a3,a3,a7
  800310:	87a2                	mv	a5,s0
  800312:	f97ff0ef          	jal	8002a8 <printnum>
  800316:	bfc9                	j	8002e8 <printnum+0x40>

0000000000800318 <vprintfmt>:
  800318:	7119                	addi	sp,sp,-128
  80031a:	f4a6                	sd	s1,104(sp)
  80031c:	f0ca                	sd	s2,96(sp)
  80031e:	ecce                	sd	s3,88(sp)
  800320:	e8d2                	sd	s4,80(sp)
  800322:	e4d6                	sd	s5,72(sp)
  800324:	e0da                	sd	s6,64(sp)
  800326:	fc5e                	sd	s7,56(sp)
  800328:	f466                	sd	s9,40(sp)
  80032a:	fc86                	sd	ra,120(sp)
  80032c:	f8a2                	sd	s0,112(sp)
  80032e:	f862                	sd	s8,48(sp)
  800330:	f06a                	sd	s10,32(sp)
  800332:	ec6e                	sd	s11,24(sp)
  800334:	84aa                	mv	s1,a0
  800336:	8cb6                	mv	s9,a3
  800338:	8aba                	mv	s5,a4
  80033a:	89ae                	mv	s3,a1
  80033c:	8932                	mv	s2,a2
  80033e:	02500a13          	li	s4,37
  800342:	05500b93          	li	s7,85
  800346:	00001b17          	auipc	s6,0x1
  80034a:	8eab0b13          	addi	s6,s6,-1814 # 800c30 <main+0x550>
  80034e:	000cc503          	lbu	a0,0(s9)
  800352:	001c8413          	addi	s0,s9,1
  800356:	01450b63          	beq	a0,s4,80036c <vprintfmt+0x54>
  80035a:	cd15                	beqz	a0,800396 <vprintfmt+0x7e>
  80035c:	864e                	mv	a2,s3
  80035e:	85ca                	mv	a1,s2
  800360:	9482                	jalr	s1
  800362:	00044503          	lbu	a0,0(s0)
  800366:	0405                	addi	s0,s0,1
  800368:	ff4519e3          	bne	a0,s4,80035a <vprintfmt+0x42>
  80036c:	5d7d                	li	s10,-1
  80036e:	8dea                	mv	s11,s10
  800370:	02000813          	li	a6,32
  800374:	4c01                	li	s8,0
  800376:	4581                	li	a1,0
  800378:	00044703          	lbu	a4,0(s0)
  80037c:	00140c93          	addi	s9,s0,1
  800380:	fdd7061b          	addiw	a2,a4,-35
  800384:	0ff67613          	zext.b	a2,a2
  800388:	02cbe663          	bltu	s7,a2,8003b4 <vprintfmt+0x9c>
  80038c:	060a                	slli	a2,a2,0x2
  80038e:	965a                	add	a2,a2,s6
  800390:	421c                	lw	a5,0(a2)
  800392:	97da                	add	a5,a5,s6
  800394:	8782                	jr	a5
  800396:	70e6                	ld	ra,120(sp)
  800398:	7446                	ld	s0,112(sp)
  80039a:	74a6                	ld	s1,104(sp)
  80039c:	7906                	ld	s2,96(sp)
  80039e:	69e6                	ld	s3,88(sp)
  8003a0:	6a46                	ld	s4,80(sp)
  8003a2:	6aa6                	ld	s5,72(sp)
  8003a4:	6b06                	ld	s6,64(sp)
  8003a6:	7be2                	ld	s7,56(sp)
  8003a8:	7c42                	ld	s8,48(sp)
  8003aa:	7ca2                	ld	s9,40(sp)
  8003ac:	7d02                	ld	s10,32(sp)
  8003ae:	6de2                	ld	s11,24(sp)
  8003b0:	6109                	addi	sp,sp,128
  8003b2:	8082                	ret
  8003b4:	864e                	mv	a2,s3
  8003b6:	85ca                	mv	a1,s2
  8003b8:	02500513          	li	a0,37
  8003bc:	9482                	jalr	s1
  8003be:	fff44783          	lbu	a5,-1(s0)
  8003c2:	02500713          	li	a4,37
  8003c6:	8ca2                	mv	s9,s0
  8003c8:	f8e783e3          	beq	a5,a4,80034e <vprintfmt+0x36>
  8003cc:	ffecc783          	lbu	a5,-2(s9)
  8003d0:	1cfd                	addi	s9,s9,-1
  8003d2:	fee79de3          	bne	a5,a4,8003cc <vprintfmt+0xb4>
  8003d6:	bfa5                	j	80034e <vprintfmt+0x36>
  8003d8:	00144683          	lbu	a3,1(s0)
  8003dc:	4525                	li	a0,9
  8003de:	fd070d1b          	addiw	s10,a4,-48
  8003e2:	fd06879b          	addiw	a5,a3,-48
  8003e6:	28f56063          	bltu	a0,a5,800666 <vprintfmt+0x34e>
  8003ea:	2681                	sext.w	a3,a3
  8003ec:	8466                	mv	s0,s9
  8003ee:	002d179b          	slliw	a5,s10,0x2
  8003f2:	00144703          	lbu	a4,1(s0)
  8003f6:	01a787bb          	addw	a5,a5,s10
  8003fa:	0017979b          	slliw	a5,a5,0x1
  8003fe:	9fb5                	addw	a5,a5,a3
  800400:	fd07061b          	addiw	a2,a4,-48
  800404:	0405                	addi	s0,s0,1
  800406:	fd078d1b          	addiw	s10,a5,-48
  80040a:	0007069b          	sext.w	a3,a4
  80040e:	fec570e3          	bgeu	a0,a2,8003ee <vprintfmt+0xd6>
  800412:	f60dd3e3          	bgez	s11,800378 <vprintfmt+0x60>
  800416:	8dea                	mv	s11,s10
  800418:	5d7d                	li	s10,-1
  80041a:	bfb9                	j	800378 <vprintfmt+0x60>
  80041c:	883a                	mv	a6,a4
  80041e:	8466                	mv	s0,s9
  800420:	bfa1                	j	800378 <vprintfmt+0x60>
  800422:	8466                	mv	s0,s9
  800424:	4c05                	li	s8,1
  800426:	bf89                	j	800378 <vprintfmt+0x60>
  800428:	4785                	li	a5,1
  80042a:	008a8613          	addi	a2,s5,8
  80042e:	00b7c463          	blt	a5,a1,800436 <vprintfmt+0x11e>
  800432:	1c058363          	beqz	a1,8005f8 <vprintfmt+0x2e0>
  800436:	000ab683          	ld	a3,0(s5)
  80043a:	4741                	li	a4,16
  80043c:	8ab2                	mv	s5,a2
  80043e:	2801                	sext.w	a6,a6
  800440:	87ee                	mv	a5,s11
  800442:	864a                	mv	a2,s2
  800444:	85ce                	mv	a1,s3
  800446:	8526                	mv	a0,s1
  800448:	e61ff0ef          	jal	8002a8 <printnum>
  80044c:	b709                	j	80034e <vprintfmt+0x36>
  80044e:	000aa503          	lw	a0,0(s5)
  800452:	864e                	mv	a2,s3
  800454:	85ca                	mv	a1,s2
  800456:	9482                	jalr	s1
  800458:	0aa1                	addi	s5,s5,8
  80045a:	bdd5                	j	80034e <vprintfmt+0x36>
  80045c:	4785                	li	a5,1
  80045e:	008a8613          	addi	a2,s5,8
  800462:	00b7c463          	blt	a5,a1,80046a <vprintfmt+0x152>
  800466:	18058463          	beqz	a1,8005ee <vprintfmt+0x2d6>
  80046a:	000ab683          	ld	a3,0(s5)
  80046e:	4729                	li	a4,10
  800470:	8ab2                	mv	s5,a2
  800472:	b7f1                	j	80043e <vprintfmt+0x126>
  800474:	864e                	mv	a2,s3
  800476:	85ca                	mv	a1,s2
  800478:	03000513          	li	a0,48
  80047c:	e042                	sd	a6,0(sp)
  80047e:	9482                	jalr	s1
  800480:	864e                	mv	a2,s3
  800482:	85ca                	mv	a1,s2
  800484:	07800513          	li	a0,120
  800488:	9482                	jalr	s1
  80048a:	000ab683          	ld	a3,0(s5)
  80048e:	6802                	ld	a6,0(sp)
  800490:	4741                	li	a4,16
  800492:	0aa1                	addi	s5,s5,8
  800494:	b76d                	j	80043e <vprintfmt+0x126>
  800496:	864e                	mv	a2,s3
  800498:	85ca                	mv	a1,s2
  80049a:	02500513          	li	a0,37
  80049e:	9482                	jalr	s1
  8004a0:	b57d                	j	80034e <vprintfmt+0x36>
  8004a2:	000aad03          	lw	s10,0(s5)
  8004a6:	8466                	mv	s0,s9
  8004a8:	0aa1                	addi	s5,s5,8
  8004aa:	b7a5                	j	800412 <vprintfmt+0xfa>
  8004ac:	4785                	li	a5,1
  8004ae:	008a8613          	addi	a2,s5,8
  8004b2:	00b7c463          	blt	a5,a1,8004ba <vprintfmt+0x1a2>
  8004b6:	12058763          	beqz	a1,8005e4 <vprintfmt+0x2cc>
  8004ba:	000ab683          	ld	a3,0(s5)
  8004be:	4721                	li	a4,8
  8004c0:	8ab2                	mv	s5,a2
  8004c2:	bfb5                	j	80043e <vprintfmt+0x126>
  8004c4:	87ee                	mv	a5,s11
  8004c6:	000dd363          	bgez	s11,8004cc <vprintfmt+0x1b4>
  8004ca:	4781                	li	a5,0
  8004cc:	00078d9b          	sext.w	s11,a5
  8004d0:	8466                	mv	s0,s9
  8004d2:	b55d                	j	800378 <vprintfmt+0x60>
  8004d4:	0008041b          	sext.w	s0,a6
  8004d8:	fd340793          	addi	a5,s0,-45
  8004dc:	01b02733          	sgtz	a4,s11
  8004e0:	00f037b3          	snez	a5,a5
  8004e4:	8ff9                	and	a5,a5,a4
  8004e6:	000ab703          	ld	a4,0(s5)
  8004ea:	008a8693          	addi	a3,s5,8
  8004ee:	e436                	sd	a3,8(sp)
  8004f0:	12070563          	beqz	a4,80061a <vprintfmt+0x302>
  8004f4:	12079d63          	bnez	a5,80062e <vprintfmt+0x316>
  8004f8:	00074783          	lbu	a5,0(a4)
  8004fc:	0007851b          	sext.w	a0,a5
  800500:	c78d                	beqz	a5,80052a <vprintfmt+0x212>
  800502:	00170a93          	addi	s5,a4,1
  800506:	547d                	li	s0,-1
  800508:	000d4563          	bltz	s10,800512 <vprintfmt+0x1fa>
  80050c:	3d7d                	addiw	s10,s10,-1
  80050e:	008d0e63          	beq	s10,s0,80052a <vprintfmt+0x212>
  800512:	020c1863          	bnez	s8,800542 <vprintfmt+0x22a>
  800516:	864e                	mv	a2,s3
  800518:	85ca                	mv	a1,s2
  80051a:	9482                	jalr	s1
  80051c:	000ac783          	lbu	a5,0(s5)
  800520:	0a85                	addi	s5,s5,1
  800522:	3dfd                	addiw	s11,s11,-1
  800524:	0007851b          	sext.w	a0,a5
  800528:	f3e5                	bnez	a5,800508 <vprintfmt+0x1f0>
  80052a:	01b05a63          	blez	s11,80053e <vprintfmt+0x226>
  80052e:	864e                	mv	a2,s3
  800530:	85ca                	mv	a1,s2
  800532:	02000513          	li	a0,32
  800536:	3dfd                	addiw	s11,s11,-1
  800538:	9482                	jalr	s1
  80053a:	fe0d9ae3          	bnez	s11,80052e <vprintfmt+0x216>
  80053e:	6aa2                	ld	s5,8(sp)
  800540:	b539                	j	80034e <vprintfmt+0x36>
  800542:	3781                	addiw	a5,a5,-32
  800544:	05e00713          	li	a4,94
  800548:	fcf777e3          	bgeu	a4,a5,800516 <vprintfmt+0x1fe>
  80054c:	03f00513          	li	a0,63
  800550:	864e                	mv	a2,s3
  800552:	85ca                	mv	a1,s2
  800554:	9482                	jalr	s1
  800556:	000ac783          	lbu	a5,0(s5)
  80055a:	0a85                	addi	s5,s5,1
  80055c:	3dfd                	addiw	s11,s11,-1
  80055e:	0007851b          	sext.w	a0,a5
  800562:	d7e1                	beqz	a5,80052a <vprintfmt+0x212>
  800564:	fa0d54e3          	bgez	s10,80050c <vprintfmt+0x1f4>
  800568:	bfe9                	j	800542 <vprintfmt+0x22a>
  80056a:	000aa783          	lw	a5,0(s5)
  80056e:	46e1                	li	a3,24
  800570:	0aa1                	addi	s5,s5,8
  800572:	41f7d71b          	sraiw	a4,a5,0x1f
  800576:	8fb9                	xor	a5,a5,a4
  800578:	40e7873b          	subw	a4,a5,a4
  80057c:	02e6c663          	blt	a3,a4,8005a8 <vprintfmt+0x290>
  800580:	00001797          	auipc	a5,0x1
  800584:	80878793          	addi	a5,a5,-2040 # 800d88 <error_string>
  800588:	00371693          	slli	a3,a4,0x3
  80058c:	97b6                	add	a5,a5,a3
  80058e:	639c                	ld	a5,0(a5)
  800590:	cf81                	beqz	a5,8005a8 <vprintfmt+0x290>
  800592:	873e                	mv	a4,a5
  800594:	00000697          	auipc	a3,0x0
  800598:	3f468693          	addi	a3,a3,1012 # 800988 <main+0x2a8>
  80059c:	864a                	mv	a2,s2
  80059e:	85ce                	mv	a1,s3
  8005a0:	8526                	mv	a0,s1
  8005a2:	0f2000ef          	jal	800694 <printfmt>
  8005a6:	b365                	j	80034e <vprintfmt+0x36>
  8005a8:	00000697          	auipc	a3,0x0
  8005ac:	3d068693          	addi	a3,a3,976 # 800978 <main+0x298>
  8005b0:	864a                	mv	a2,s2
  8005b2:	85ce                	mv	a1,s3
  8005b4:	8526                	mv	a0,s1
  8005b6:	0de000ef          	jal	800694 <printfmt>
  8005ba:	bb51                	j	80034e <vprintfmt+0x36>
  8005bc:	4785                	li	a5,1
  8005be:	008a8c13          	addi	s8,s5,8
  8005c2:	00b7c363          	blt	a5,a1,8005c8 <vprintfmt+0x2b0>
  8005c6:	cd81                	beqz	a1,8005de <vprintfmt+0x2c6>
  8005c8:	000ab403          	ld	s0,0(s5)
  8005cc:	02044b63          	bltz	s0,800602 <vprintfmt+0x2ea>
  8005d0:	86a2                	mv	a3,s0
  8005d2:	8ae2                	mv	s5,s8
  8005d4:	4729                	li	a4,10
  8005d6:	b5a5                	j	80043e <vprintfmt+0x126>
  8005d8:	2585                	addiw	a1,a1,1
  8005da:	8466                	mv	s0,s9
  8005dc:	bb71                	j	800378 <vprintfmt+0x60>
  8005de:	000aa403          	lw	s0,0(s5)
  8005e2:	b7ed                	j	8005cc <vprintfmt+0x2b4>
  8005e4:	000ae683          	lwu	a3,0(s5)
  8005e8:	4721                	li	a4,8
  8005ea:	8ab2                	mv	s5,a2
  8005ec:	bd89                	j	80043e <vprintfmt+0x126>
  8005ee:	000ae683          	lwu	a3,0(s5)
  8005f2:	4729                	li	a4,10
  8005f4:	8ab2                	mv	s5,a2
  8005f6:	b5a1                	j	80043e <vprintfmt+0x126>
  8005f8:	000ae683          	lwu	a3,0(s5)
  8005fc:	4741                	li	a4,16
  8005fe:	8ab2                	mv	s5,a2
  800600:	bd3d                	j	80043e <vprintfmt+0x126>
  800602:	864e                	mv	a2,s3
  800604:	85ca                	mv	a1,s2
  800606:	02d00513          	li	a0,45
  80060a:	e042                	sd	a6,0(sp)
  80060c:	9482                	jalr	s1
  80060e:	6802                	ld	a6,0(sp)
  800610:	408006b3          	neg	a3,s0
  800614:	8ae2                	mv	s5,s8
  800616:	4729                	li	a4,10
  800618:	b51d                	j	80043e <vprintfmt+0x126>
  80061a:	eba1                	bnez	a5,80066a <vprintfmt+0x352>
  80061c:	02800793          	li	a5,40
  800620:	853e                	mv	a0,a5
  800622:	00000a97          	auipc	s5,0x0
  800626:	34fa8a93          	addi	s5,s5,847 # 800971 <main+0x291>
  80062a:	547d                	li	s0,-1
  80062c:	bdf1                	j	800508 <vprintfmt+0x1f0>
  80062e:	853a                	mv	a0,a4
  800630:	85ea                	mv	a1,s10
  800632:	e03a                	sd	a4,0(sp)
  800634:	07e000ef          	jal	8006b2 <strnlen>
  800638:	40ad8dbb          	subw	s11,s11,a0
  80063c:	6702                	ld	a4,0(sp)
  80063e:	01b05b63          	blez	s11,800654 <vprintfmt+0x33c>
  800642:	864e                	mv	a2,s3
  800644:	85ca                	mv	a1,s2
  800646:	8522                	mv	a0,s0
  800648:	e03a                	sd	a4,0(sp)
  80064a:	3dfd                	addiw	s11,s11,-1
  80064c:	9482                	jalr	s1
  80064e:	6702                	ld	a4,0(sp)
  800650:	fe0d99e3          	bnez	s11,800642 <vprintfmt+0x32a>
  800654:	00074783          	lbu	a5,0(a4)
  800658:	0007851b          	sext.w	a0,a5
  80065c:	ee0781e3          	beqz	a5,80053e <vprintfmt+0x226>
  800660:	00170a93          	addi	s5,a4,1
  800664:	b54d                	j	800506 <vprintfmt+0x1ee>
  800666:	8466                	mv	s0,s9
  800668:	b36d                	j	800412 <vprintfmt+0xfa>
  80066a:	85ea                	mv	a1,s10
  80066c:	00000517          	auipc	a0,0x0
  800670:	30450513          	addi	a0,a0,772 # 800970 <main+0x290>
  800674:	03e000ef          	jal	8006b2 <strnlen>
  800678:	40ad8dbb          	subw	s11,s11,a0
  80067c:	02800793          	li	a5,40
  800680:	00000717          	auipc	a4,0x0
  800684:	2f070713          	addi	a4,a4,752 # 800970 <main+0x290>
  800688:	853e                	mv	a0,a5
  80068a:	fbb04ce3          	bgtz	s11,800642 <vprintfmt+0x32a>
  80068e:	00170a93          	addi	s5,a4,1
  800692:	bd95                	j	800506 <vprintfmt+0x1ee>

0000000000800694 <printfmt>:
  800694:	7139                	addi	sp,sp,-64
  800696:	02010313          	addi	t1,sp,32
  80069a:	f03a                	sd	a4,32(sp)
  80069c:	871a                	mv	a4,t1
  80069e:	ec06                	sd	ra,24(sp)
  8006a0:	f43e                	sd	a5,40(sp)
  8006a2:	f842                	sd	a6,48(sp)
  8006a4:	fc46                	sd	a7,56(sp)
  8006a6:	e41a                	sd	t1,8(sp)
  8006a8:	c71ff0ef          	jal	800318 <vprintfmt>
  8006ac:	60e2                	ld	ra,24(sp)
  8006ae:	6121                	addi	sp,sp,64
  8006b0:	8082                	ret

00000000008006b2 <strnlen>:
  8006b2:	4781                	li	a5,0
  8006b4:	e589                	bnez	a1,8006be <strnlen+0xc>
  8006b6:	a811                	j	8006ca <strnlen+0x18>
  8006b8:	0785                	addi	a5,a5,1
  8006ba:	00f58863          	beq	a1,a5,8006ca <strnlen+0x18>
  8006be:	00f50733          	add	a4,a0,a5
  8006c2:	00074703          	lbu	a4,0(a4)
  8006c6:	fb6d                	bnez	a4,8006b8 <strnlen+0x6>
  8006c8:	85be                	mv	a1,a5
  8006ca:	852e                	mv	a0,a1
  8006cc:	8082                	ret

00000000008006ce <memset>:
  8006ce:	ca01                	beqz	a2,8006de <memset+0x10>
  8006d0:	962a                	add	a2,a2,a0
  8006d2:	87aa                	mv	a5,a0
  8006d4:	0785                	addi	a5,a5,1
  8006d6:	feb78fa3          	sb	a1,-1(a5)
  8006da:	fef61de3          	bne	a2,a5,8006d4 <memset+0x6>
  8006de:	8082                	ret

00000000008006e0 <main>:
  8006e0:	715d                	addi	sp,sp,-80
  8006e2:	4651                	li	a2,20
  8006e4:	4581                	li	a1,0
  8006e6:	00001517          	auipc	a0,0x1
  8006ea:	91a50513          	addi	a0,a0,-1766 # 801000 <pids>
  8006ee:	e486                	sd	ra,72(sp)
  8006f0:	e0a2                	sd	s0,64(sp)
  8006f2:	fc26                	sd	s1,56(sp)
  8006f4:	f84a                	sd	s2,48(sp)
  8006f6:	f44e                	sd	s3,40(sp)
  8006f8:	f052                	sd	s4,32(sp)
  8006fa:	ec56                	sd	s5,24(sp)
  8006fc:	fd3ff0ef          	jal	8006ce <memset>
  800700:	4519                	li	a0,6
  800702:	00001a97          	auipc	s5,0x1
  800706:	92ea8a93          	addi	s5,s5,-1746 # 801030 <acc>
  80070a:	00001497          	auipc	s1,0x1
  80070e:	8f648493          	addi	s1,s1,-1802 # 801000 <pids>
  800712:	adbff0ef          	jal	8001ec <lab6_set_priority>
  800716:	89d6                	mv	s3,s5
  800718:	8926                	mv	s2,s1
  80071a:	4401                	li	s0,0
  80071c:	4a15                	li	s4,5
  80071e:	0009a023          	sw	zero,0(s3)
  800722:	aa7ff0ef          	jal	8001c8 <fork>
  800726:	00a92023          	sw	a0,0(s2)
  80072a:	c561                	beqz	a0,8007f2 <main+0x112>
  80072c:	12054863          	bltz	a0,80085c <main+0x17c>
  800730:	2405                	addiw	s0,s0,1
  800732:	0991                	addi	s3,s3,4
  800734:	0911                	addi	s2,s2,4
  800736:	ff4414e3          	bne	s0,s4,80071e <main+0x3e>
  80073a:	00000517          	auipc	a0,0x0
  80073e:	44e50513          	addi	a0,a0,1102 # 800b88 <main+0x4a8>
  800742:	00001917          	auipc	s2,0x1
  800746:	8d690913          	addi	s2,s2,-1834 # 801018 <status>
  80074a:	9abff0ef          	jal	8000f4 <cprintf>
  80074e:	844a                	mv	s0,s2
  800750:	00001997          	auipc	s3,0x1
  800754:	8dc98993          	addi	s3,s3,-1828 # 80102c <status+0x14>
  800758:	4088                	lw	a0,0(s1)
  80075a:	85a2                	mv	a1,s0
  80075c:	00042023          	sw	zero,0(s0)
  800760:	a6bff0ef          	jal	8001ca <waitpid>
  800764:	0004aa03          	lw	s4,0(s1)
  800768:	00042a83          	lw	s5,0(s0)
  80076c:	a7fff0ef          	jal	8001ea <gettime_msec>
  800770:	86aa                	mv	a3,a0
  800772:	8656                	mv	a2,s5
  800774:	85d2                	mv	a1,s4
  800776:	00000517          	auipc	a0,0x0
  80077a:	43a50513          	addi	a0,a0,1082 # 800bb0 <main+0x4d0>
  80077e:	0411                	addi	s0,s0,4
  800780:	975ff0ef          	jal	8000f4 <cprintf>
  800784:	0491                	addi	s1,s1,4
  800786:	fd3419e3          	bne	s0,s3,800758 <main+0x78>
  80078a:	00000517          	auipc	a0,0x0
  80078e:	44650513          	addi	a0,a0,1094 # 800bd0 <main+0x4f0>
  800792:	963ff0ef          	jal	8000f4 <cprintf>
  800796:	00000517          	auipc	a0,0x0
  80079a:	45250513          	addi	a0,a0,1106 # 800be8 <main+0x508>
  80079e:	957ff0ef          	jal	8000f4 <cprintf>
  8007a2:	00092783          	lw	a5,0(s2)
  8007a6:	00001717          	auipc	a4,0x1
  8007aa:	87272703          	lw	a4,-1934(a4) # 801018 <status>
  8007ae:	00000517          	auipc	a0,0x0
  8007b2:	45a50513          	addi	a0,a0,1114 # 800c08 <main+0x528>
  8007b6:	0017979b          	slliw	a5,a5,0x1
  8007ba:	02e7c7bb          	divw	a5,a5,a4
  8007be:	0911                	addi	s2,s2,4
  8007c0:	2785                	addiw	a5,a5,1
  8007c2:	01f7d59b          	srliw	a1,a5,0x1f
  8007c6:	9dbd                	addw	a1,a1,a5
  8007c8:	8585                	srai	a1,a1,0x1
  8007ca:	92bff0ef          	jal	8000f4 <cprintf>
  8007ce:	fd391ae3          	bne	s2,s3,8007a2 <main+0xc2>
  8007d2:	00000517          	auipc	a0,0x0
  8007d6:	0de50513          	addi	a0,a0,222 # 8008b0 <main+0x1d0>
  8007da:	91bff0ef          	jal	8000f4 <cprintf>
  8007de:	60a6                	ld	ra,72(sp)
  8007e0:	6406                	ld	s0,64(sp)
  8007e2:	74e2                	ld	s1,56(sp)
  8007e4:	7942                	ld	s2,48(sp)
  8007e6:	79a2                	ld	s3,40(sp)
  8007e8:	7a02                	ld	s4,32(sp)
  8007ea:	6ae2                	ld	s5,24(sp)
  8007ec:	4501                	li	a0,0
  8007ee:	6161                	addi	sp,sp,80
  8007f0:	8082                	ret
  8007f2:	0014051b          	addiw	a0,s0,1
  8007f6:	040a                	slli	s0,s0,0x2
  8007f8:	9aa2                	add	s5,s5,s0
  8007fa:	6489                	lui	s1,0x2
  8007fc:	6405                	lui	s0,0x1
  8007fe:	9efff0ef          	jal	8001ec <lab6_set_priority>
  800802:	fa04041b          	addiw	s0,s0,-96 # fa0 <open-0x7ff080>
  800806:	000aa023          	sw	zero,0(s5)
  80080a:	71048493          	addi	s1,s1,1808 # 2710 <open-0x7fd910>
  80080e:	000aa683          	lw	a3,0(s5)
  800812:	2685                	addiw	a3,a3,1
  800814:	0c800713          	li	a4,200
  800818:	47b2                	lw	a5,12(sp)
  80081a:	377d                	addiw	a4,a4,-1
  80081c:	0017b793          	seqz	a5,a5
  800820:	c63e                	sw	a5,12(sp)
  800822:	fb7d                	bnez	a4,800818 <main+0x138>
  800824:	0286f7bb          	remuw	a5,a3,s0
  800828:	c399                	beqz	a5,80082e <main+0x14e>
  80082a:	2685                	addiw	a3,a3,1
  80082c:	b7e5                	j	800814 <main+0x134>
  80082e:	00daa023          	sw	a3,0(s5)
  800832:	9b9ff0ef          	jal	8001ea <gettime_msec>
  800836:	892a                	mv	s2,a0
  800838:	fca4dbe3          	bge	s1,a0,80080e <main+0x12e>
  80083c:	9adff0ef          	jal	8001e8 <getpid>
  800840:	000aa603          	lw	a2,0(s5)
  800844:	85aa                	mv	a1,a0
  800846:	86ca                	mv	a3,s2
  800848:	00000517          	auipc	a0,0x0
  80084c:	32050513          	addi	a0,a0,800 # 800b68 <main+0x488>
  800850:	8a5ff0ef          	jal	8000f4 <cprintf>
  800854:	000aa503          	lw	a0,0(s5)
  800858:	95bff0ef          	jal	8001b2 <exit>
  80085c:	00000417          	auipc	s0,0x0
  800860:	7b840413          	addi	s0,s0,1976 # 801014 <pids+0x14>
  800864:	4088                	lw	a0,0(s1)
  800866:	00a05463          	blez	a0,80086e <main+0x18e>
  80086a:	97dff0ef          	jal	8001e6 <kill>
  80086e:	0491                	addi	s1,s1,4
  800870:	fe849ae3          	bne	s1,s0,800864 <main+0x184>
  800874:	00000617          	auipc	a2,0x0
  800878:	39c60613          	addi	a2,a2,924 # 800c10 <main+0x530>
  80087c:	04b00593          	li	a1,75
  800880:	00000517          	auipc	a0,0x0
  800884:	3a050513          	addi	a0,a0,928 # 800c20 <main+0x540>
  800888:	fa8ff0ef          	jal	800030 <__panic>
