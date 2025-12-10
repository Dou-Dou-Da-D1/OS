
obj/__user_cow_test.out:     file format elf64-littleriscv


Disassembly of section .text:

0000000000800020 <_start>:
.text
.globl _start
_start:
    # call user-program function
    call umain
  800020:	0c4000ef          	jal	8000e4 <umain>
1:  j 1b
  800024:	a001                	j	800024 <_start+0x4>

0000000000800026 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800026:	1101                	addi	sp,sp,-32
  800028:	ec06                	sd	ra,24(sp)
  80002a:	e42e                	sd	a1,8(sp)
    sys_putc(c);
  80002c:	094000ef          	jal	8000c0 <sys_putc>
    (*cnt) ++;
  800030:	65a2                	ld	a1,8(sp)
}
  800032:	60e2                	ld	ra,24(sp)
    (*cnt) ++;
  800034:	419c                	lw	a5,0(a1)
  800036:	2785                	addiw	a5,a5,1
  800038:	c19c                	sw	a5,0(a1)
}
  80003a:	6105                	addi	sp,sp,32
  80003c:	8082                	ret

000000000080003e <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  80003e:	711d                	addi	sp,sp,-96
    va_list ap;

    va_start(ap, fmt);
  800040:	02810313          	addi	t1,sp,40
cprintf(const char *fmt, ...) {
  800044:	f42e                	sd	a1,40(sp)
  800046:	f832                	sd	a2,48(sp)
  800048:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  80004a:	862a                	mv	a2,a0
  80004c:	004c                	addi	a1,sp,4
  80004e:	00000517          	auipc	a0,0x0
  800052:	fd850513          	addi	a0,a0,-40 # 800026 <cputch>
  800056:	869a                	mv	a3,t1
cprintf(const char *fmt, ...) {
  800058:	ec06                	sd	ra,24(sp)
  80005a:	e0ba                	sd	a4,64(sp)
  80005c:	e4be                	sd	a5,72(sp)
  80005e:	e8c2                	sd	a6,80(sp)
  800060:	ecc6                	sd	a7,88(sp)
    int cnt = 0;
  800062:	c202                	sw	zero,4(sp)
    va_start(ap, fmt);
  800064:	e41a                	sd	t1,8(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  800066:	0f0000ef          	jal	800156 <vprintfmt>
    int cnt = vcprintf(fmt, ap);
    va_end(ap);

    return cnt;
}
  80006a:	60e2                	ld	ra,24(sp)
  80006c:	4512                	lw	a0,4(sp)
  80006e:	6125                	addi	sp,sp,96
  800070:	8082                	ret

0000000000800072 <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int64_t num, ...) {
  800072:	7175                	addi	sp,sp,-144
    va_list ap;
    va_start(ap, num);
    uint64_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint64_t);
  800074:	08010313          	addi	t1,sp,128
syscall(int64_t num, ...) {
  800078:	e42a                	sd	a0,8(sp)
  80007a:	ecae                	sd	a1,88(sp)
        a[i] = va_arg(ap, uint64_t);
  80007c:	f42e                	sd	a1,40(sp)
syscall(int64_t num, ...) {
  80007e:	f0b2                	sd	a2,96(sp)
        a[i] = va_arg(ap, uint64_t);
  800080:	f832                	sd	a2,48(sp)
syscall(int64_t num, ...) {
  800082:	f4b6                	sd	a3,104(sp)
        a[i] = va_arg(ap, uint64_t);
  800084:	fc36                	sd	a3,56(sp)
syscall(int64_t num, ...) {
  800086:	f8ba                	sd	a4,112(sp)
        a[i] = va_arg(ap, uint64_t);
  800088:	e0ba                	sd	a4,64(sp)
syscall(int64_t num, ...) {
  80008a:	fcbe                	sd	a5,120(sp)
        a[i] = va_arg(ap, uint64_t);
  80008c:	e4be                	sd	a5,72(sp)
syscall(int64_t num, ...) {
  80008e:	e142                	sd	a6,128(sp)
  800090:	e546                	sd	a7,136(sp)
        a[i] = va_arg(ap, uint64_t);
  800092:	f01a                	sd	t1,32(sp)
    }
    va_end(ap);

    asm volatile (
  800094:	6522                	ld	a0,8(sp)
  800096:	75a2                	ld	a1,40(sp)
  800098:	7642                	ld	a2,48(sp)
  80009a:	76e2                	ld	a3,56(sp)
  80009c:	6706                	ld	a4,64(sp)
  80009e:	67a6                	ld	a5,72(sp)
  8000a0:	00000073          	ecall
  8000a4:	00a13e23          	sd	a0,28(sp)
        "sd a0, %0"
        : "=m" (ret)
        : "m"(num), "m"(a[0]), "m"(a[1]), "m"(a[2]), "m"(a[3]), "m"(a[4])
        :"memory");
    return ret;
}
  8000a8:	4572                	lw	a0,28(sp)
  8000aa:	6149                	addi	sp,sp,144
  8000ac:	8082                	ret

00000000008000ae <sys_exit>:

int
sys_exit(int64_t error_code) {
  8000ae:	85aa                	mv	a1,a0
    return syscall(SYS_exit, error_code);
  8000b0:	4505                	li	a0,1
  8000b2:	b7c1                	j	800072 <syscall>

00000000008000b4 <sys_fork>:
}

int
sys_fork(void) {
    return syscall(SYS_fork);
  8000b4:	4509                	li	a0,2
  8000b6:	bf75                	j	800072 <syscall>

00000000008000b8 <sys_wait>:
}

int
sys_wait(int64_t pid, int *store) {
  8000b8:	862e                	mv	a2,a1
    return syscall(SYS_wait, pid, store);
  8000ba:	85aa                	mv	a1,a0
  8000bc:	450d                	li	a0,3
  8000be:	bf55                	j	800072 <syscall>

00000000008000c0 <sys_putc>:
sys_getpid(void) {
    return syscall(SYS_getpid);
}

int
sys_putc(int64_t c) {
  8000c0:	85aa                	mv	a1,a0
    return syscall(SYS_putc, c);
  8000c2:	4579                	li	a0,30
  8000c4:	b77d                	j	800072 <syscall>

00000000008000c6 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8000c6:	1141                	addi	sp,sp,-16
  8000c8:	e406                	sd	ra,8(sp)
    sys_exit(error_code);
  8000ca:	fe5ff0ef          	jal	8000ae <sys_exit>
    cprintf("BUG: exit failed.\n");
  8000ce:	00000517          	auipc	a0,0x0
  8000d2:	4fa50513          	addi	a0,a0,1274 # 8005c8 <main+0xf0>
  8000d6:	f69ff0ef          	jal	80003e <cprintf>
    while (1);
  8000da:	a001                	j	8000da <exit+0x14>

00000000008000dc <fork>:
}

int
fork(void) {
    return sys_fork();
  8000dc:	bfe1                	j	8000b4 <sys_fork>

00000000008000de <wait>:
}

int
wait(void) {
    return sys_wait(0, NULL);
  8000de:	4581                	li	a1,0
  8000e0:	4501                	li	a0,0
  8000e2:	bfd9                	j	8000b8 <sys_wait>

00000000008000e4 <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8000e4:	1141                	addi	sp,sp,-16
  8000e6:	e406                	sd	ra,8(sp)
    int ret = main();
  8000e8:	3f0000ef          	jal	8004d8 <main>
    exit(ret);
  8000ec:	fdbff0ef          	jal	8000c6 <exit>

00000000008000f0 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  8000f0:	7179                	addi	sp,sp,-48
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
  8000f2:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  8000f6:	f022                	sd	s0,32(sp)
  8000f8:	ec26                	sd	s1,24(sp)
  8000fa:	e84a                	sd	s2,16(sp)
  8000fc:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
  8000fe:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
  800102:	f406                	sd	ra,40(sp)
    unsigned mod = do_div(result, base);
  800104:	03067a33          	remu	s4,a2,a6
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800108:	fff7041b          	addiw	s0,a4,-1
        unsigned long long num, unsigned base, int width, int padc) {
  80010c:	84aa                	mv	s1,a0
  80010e:	892e                	mv	s2,a1
    if (num >= base) {
  800110:	03067d63          	bgeu	a2,a6,80014a <printnum+0x5a>
  800114:	e44e                	sd	s3,8(sp)
  800116:	89be                	mv	s3,a5
        while (-- width > 0)
  800118:	4785                	li	a5,1
  80011a:	00e7d763          	bge	a5,a4,800128 <printnum+0x38>
            putch(padc, putdat);
  80011e:	85ca                	mv	a1,s2
  800120:	854e                	mv	a0,s3
        while (-- width > 0)
  800122:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
  800124:	9482                	jalr	s1
        while (-- width > 0)
  800126:	fc65                	bnez	s0,80011e <printnum+0x2e>
  800128:	69a2                	ld	s3,8(sp)
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  80012a:	00000797          	auipc	a5,0x0
  80012e:	4b678793          	addi	a5,a5,1206 # 8005e0 <main+0x108>
  800132:	97d2                	add	a5,a5,s4
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
  800134:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
  800136:	0007c503          	lbu	a0,0(a5)
}
  80013a:	70a2                	ld	ra,40(sp)
  80013c:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
  80013e:	85ca                	mv	a1,s2
  800140:	87a6                	mv	a5,s1
}
  800142:	6942                	ld	s2,16(sp)
  800144:	64e2                	ld	s1,24(sp)
  800146:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
  800148:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
  80014a:	03065633          	divu	a2,a2,a6
  80014e:	8722                	mv	a4,s0
  800150:	fa1ff0ef          	jal	8000f0 <printnum>
  800154:	bfd9                	j	80012a <printnum+0x3a>

0000000000800156 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  800156:	7119                	addi	sp,sp,-128
  800158:	f4a6                	sd	s1,104(sp)
  80015a:	f0ca                	sd	s2,96(sp)
  80015c:	ecce                	sd	s3,88(sp)
  80015e:	e8d2                	sd	s4,80(sp)
  800160:	e4d6                	sd	s5,72(sp)
  800162:	e0da                	sd	s6,64(sp)
  800164:	f862                	sd	s8,48(sp)
  800166:	fc86                	sd	ra,120(sp)
  800168:	f8a2                	sd	s0,112(sp)
  80016a:	fc5e                	sd	s7,56(sp)
  80016c:	f466                	sd	s9,40(sp)
  80016e:	f06a                	sd	s10,32(sp)
  800170:	ec6e                	sd	s11,24(sp)
  800172:	84aa                	mv	s1,a0
  800174:	8c32                	mv	s8,a2
  800176:	8a36                	mv	s4,a3
  800178:	892e                	mv	s2,a1
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80017a:	02500993          	li	s3,37
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  80017e:	05500b13          	li	s6,85
  800182:	00000a97          	auipc	s5,0x0
  800186:	66ea8a93          	addi	s5,s5,1646 # 8007f0 <main+0x318>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80018a:	000c4503          	lbu	a0,0(s8)
  80018e:	001c0413          	addi	s0,s8,1
  800192:	01350a63          	beq	a0,s3,8001a6 <vprintfmt+0x50>
            if (ch == '\0') {
  800196:	cd0d                	beqz	a0,8001d0 <vprintfmt+0x7a>
            putch(ch, putdat);
  800198:	85ca                	mv	a1,s2
  80019a:	9482                	jalr	s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80019c:	00044503          	lbu	a0,0(s0)
  8001a0:	0405                	addi	s0,s0,1
  8001a2:	ff351ae3          	bne	a0,s3,800196 <vprintfmt+0x40>
        width = precision = -1;
  8001a6:	5cfd                	li	s9,-1
  8001a8:	8d66                	mv	s10,s9
        char padc = ' ';
  8001aa:	02000d93          	li	s11,32
        lflag = altflag = 0;
  8001ae:	4b81                	li	s7,0
  8001b0:	4781                	li	a5,0
        switch (ch = *(unsigned char *)fmt ++) {
  8001b2:	00044683          	lbu	a3,0(s0)
  8001b6:	00140c13          	addi	s8,s0,1
  8001ba:	fdd6859b          	addiw	a1,a3,-35
  8001be:	0ff5f593          	zext.b	a1,a1
  8001c2:	02bb6663          	bltu	s6,a1,8001ee <vprintfmt+0x98>
  8001c6:	058a                	slli	a1,a1,0x2
  8001c8:	95d6                	add	a1,a1,s5
  8001ca:	4198                	lw	a4,0(a1)
  8001cc:	9756                	add	a4,a4,s5
  8001ce:	8702                	jr	a4
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8001d0:	70e6                	ld	ra,120(sp)
  8001d2:	7446                	ld	s0,112(sp)
  8001d4:	74a6                	ld	s1,104(sp)
  8001d6:	7906                	ld	s2,96(sp)
  8001d8:	69e6                	ld	s3,88(sp)
  8001da:	6a46                	ld	s4,80(sp)
  8001dc:	6aa6                	ld	s5,72(sp)
  8001de:	6b06                	ld	s6,64(sp)
  8001e0:	7be2                	ld	s7,56(sp)
  8001e2:	7c42                	ld	s8,48(sp)
  8001e4:	7ca2                	ld	s9,40(sp)
  8001e6:	7d02                	ld	s10,32(sp)
  8001e8:	6de2                	ld	s11,24(sp)
  8001ea:	6109                	addi	sp,sp,128
  8001ec:	8082                	ret
            putch('%', putdat);
  8001ee:	85ca                	mv	a1,s2
  8001f0:	02500513          	li	a0,37
  8001f4:	9482                	jalr	s1
            for (fmt --; fmt[-1] != '%'; fmt --)
  8001f6:	fff44783          	lbu	a5,-1(s0)
  8001fa:	02500713          	li	a4,37
  8001fe:	8c22                	mv	s8,s0
  800200:	f8e785e3          	beq	a5,a4,80018a <vprintfmt+0x34>
  800204:	ffec4783          	lbu	a5,-2(s8)
  800208:	1c7d                	addi	s8,s8,-1
  80020a:	fee79de3          	bne	a5,a4,800204 <vprintfmt+0xae>
  80020e:	bfb5                	j	80018a <vprintfmt+0x34>
                ch = *fmt;
  800210:	00144603          	lbu	a2,1(s0)
                if (ch < '0' || ch > '9') {
  800214:	4525                	li	a0,9
                precision = precision * 10 + ch - '0';
  800216:	fd068c9b          	addiw	s9,a3,-48
                if (ch < '0' || ch > '9') {
  80021a:	fd06071b          	addiw	a4,a2,-48
  80021e:	24e56a63          	bltu	a0,a4,800472 <vprintfmt+0x31c>
                ch = *fmt;
  800222:	2601                	sext.w	a2,a2
        switch (ch = *(unsigned char *)fmt ++) {
  800224:	8462                	mv	s0,s8
                precision = precision * 10 + ch - '0';
  800226:	002c971b          	slliw	a4,s9,0x2
                ch = *fmt;
  80022a:	00144683          	lbu	a3,1(s0)
                precision = precision * 10 + ch - '0';
  80022e:	0197073b          	addw	a4,a4,s9
  800232:	0017171b          	slliw	a4,a4,0x1
  800236:	9f31                	addw	a4,a4,a2
                if (ch < '0' || ch > '9') {
  800238:	fd06859b          	addiw	a1,a3,-48
            for (precision = 0; ; ++ fmt) {
  80023c:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
  80023e:	fd070c9b          	addiw	s9,a4,-48
                ch = *fmt;
  800242:	0006861b          	sext.w	a2,a3
                if (ch < '0' || ch > '9') {
  800246:	feb570e3          	bgeu	a0,a1,800226 <vprintfmt+0xd0>
            if (width < 0)
  80024a:	f60d54e3          	bgez	s10,8001b2 <vprintfmt+0x5c>
                width = precision, precision = -1;
  80024e:	8d66                	mv	s10,s9
  800250:	5cfd                	li	s9,-1
  800252:	b785                	j	8001b2 <vprintfmt+0x5c>
        switch (ch = *(unsigned char *)fmt ++) {
  800254:	8db6                	mv	s11,a3
  800256:	8462                	mv	s0,s8
  800258:	bfa9                	j	8001b2 <vprintfmt+0x5c>
  80025a:	8462                	mv	s0,s8
            altflag = 1;
  80025c:	4b85                	li	s7,1
            goto reswitch;
  80025e:	bf91                	j	8001b2 <vprintfmt+0x5c>
    if (lflag >= 2) {
  800260:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800262:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800266:	00f74463          	blt	a4,a5,80026e <vprintfmt+0x118>
    else if (lflag) {
  80026a:	1a078763          	beqz	a5,800418 <vprintfmt+0x2c2>
        return va_arg(*ap, unsigned long);
  80026e:	000a3603          	ld	a2,0(s4)
  800272:	46c1                	li	a3,16
  800274:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
  800276:	000d879b          	sext.w	a5,s11
  80027a:	876a                	mv	a4,s10
  80027c:	85ca                	mv	a1,s2
  80027e:	8526                	mv	a0,s1
  800280:	e71ff0ef          	jal	8000f0 <printnum>
            break;
  800284:	b719                	j	80018a <vprintfmt+0x34>
            putch(va_arg(ap, int), putdat);
  800286:	000a2503          	lw	a0,0(s4)
  80028a:	85ca                	mv	a1,s2
  80028c:	0a21                	addi	s4,s4,8
  80028e:	9482                	jalr	s1
            break;
  800290:	bded                	j	80018a <vprintfmt+0x34>
    if (lflag >= 2) {
  800292:	4705                	li	a4,1
            precision = va_arg(ap, int);
  800294:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  800298:	00f74463          	blt	a4,a5,8002a0 <vprintfmt+0x14a>
    else if (lflag) {
  80029c:	16078963          	beqz	a5,80040e <vprintfmt+0x2b8>
        return va_arg(*ap, unsigned long);
  8002a0:	000a3603          	ld	a2,0(s4)
  8002a4:	46a9                	li	a3,10
  8002a6:	8a2e                	mv	s4,a1
  8002a8:	b7f9                	j	800276 <vprintfmt+0x120>
            putch('0', putdat);
  8002aa:	85ca                	mv	a1,s2
  8002ac:	03000513          	li	a0,48
  8002b0:	9482                	jalr	s1
            putch('x', putdat);
  8002b2:	85ca                	mv	a1,s2
  8002b4:	07800513          	li	a0,120
  8002b8:	9482                	jalr	s1
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8002ba:	000a3603          	ld	a2,0(s4)
            goto number;
  8002be:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8002c0:	0a21                	addi	s4,s4,8
            goto number;
  8002c2:	bf55                	j	800276 <vprintfmt+0x120>
            putch(ch, putdat);
  8002c4:	85ca                	mv	a1,s2
  8002c6:	02500513          	li	a0,37
  8002ca:	9482                	jalr	s1
            break;
  8002cc:	bd7d                	j	80018a <vprintfmt+0x34>
            precision = va_arg(ap, int);
  8002ce:	000a2c83          	lw	s9,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
  8002d2:	8462                	mv	s0,s8
            precision = va_arg(ap, int);
  8002d4:	0a21                	addi	s4,s4,8
            goto process_precision;
  8002d6:	bf95                	j	80024a <vprintfmt+0xf4>
    if (lflag >= 2) {
  8002d8:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8002da:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
  8002de:	00f74463          	blt	a4,a5,8002e6 <vprintfmt+0x190>
    else if (lflag) {
  8002e2:	12078163          	beqz	a5,800404 <vprintfmt+0x2ae>
        return va_arg(*ap, unsigned long);
  8002e6:	000a3603          	ld	a2,0(s4)
  8002ea:	46a1                	li	a3,8
  8002ec:	8a2e                	mv	s4,a1
  8002ee:	b761                	j	800276 <vprintfmt+0x120>
            if (width < 0)
  8002f0:	876a                	mv	a4,s10
  8002f2:	000d5363          	bgez	s10,8002f8 <vprintfmt+0x1a2>
  8002f6:	4701                	li	a4,0
  8002f8:	00070d1b          	sext.w	s10,a4
        switch (ch = *(unsigned char *)fmt ++) {
  8002fc:	8462                	mv	s0,s8
            goto reswitch;
  8002fe:	bd55                	j	8001b2 <vprintfmt+0x5c>
            if (width > 0 && padc != '-') {
  800300:	000d841b          	sext.w	s0,s11
  800304:	fd340793          	addi	a5,s0,-45
  800308:	00f037b3          	snez	a5,a5
  80030c:	01a02733          	sgtz	a4,s10
            if ((p = va_arg(ap, char *)) == NULL) {
  800310:	000a3d83          	ld	s11,0(s4)
            if (width > 0 && padc != '-') {
  800314:	8f7d                	and	a4,a4,a5
            if ((p = va_arg(ap, char *)) == NULL) {
  800316:	008a0793          	addi	a5,s4,8
  80031a:	e43e                	sd	a5,8(sp)
  80031c:	100d8c63          	beqz	s11,800434 <vprintfmt+0x2de>
            if (width > 0 && padc != '-') {
  800320:	12071363          	bnez	a4,800446 <vprintfmt+0x2f0>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800324:	000dc783          	lbu	a5,0(s11)
  800328:	0007851b          	sext.w	a0,a5
  80032c:	c78d                	beqz	a5,800356 <vprintfmt+0x200>
  80032e:	0d85                	addi	s11,s11,1
  800330:	547d                	li	s0,-1
                if (altflag && (ch < ' ' || ch > '~')) {
  800332:	05e00a13          	li	s4,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800336:	000cc563          	bltz	s9,800340 <vprintfmt+0x1ea>
  80033a:	3cfd                	addiw	s9,s9,-1
  80033c:	008c8d63          	beq	s9,s0,800356 <vprintfmt+0x200>
                if (altflag && (ch < ' ' || ch > '~')) {
  800340:	020b9663          	bnez	s7,80036c <vprintfmt+0x216>
                    putch(ch, putdat);
  800344:	85ca                	mv	a1,s2
  800346:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800348:	000dc783          	lbu	a5,0(s11)
  80034c:	0d85                	addi	s11,s11,1
  80034e:	3d7d                	addiw	s10,s10,-1
  800350:	0007851b          	sext.w	a0,a5
  800354:	f3ed                	bnez	a5,800336 <vprintfmt+0x1e0>
            for (; width > 0; width --) {
  800356:	01a05963          	blez	s10,800368 <vprintfmt+0x212>
                putch(' ', putdat);
  80035a:	85ca                	mv	a1,s2
  80035c:	02000513          	li	a0,32
            for (; width > 0; width --) {
  800360:	3d7d                	addiw	s10,s10,-1
                putch(' ', putdat);
  800362:	9482                	jalr	s1
            for (; width > 0; width --) {
  800364:	fe0d1be3          	bnez	s10,80035a <vprintfmt+0x204>
            if ((p = va_arg(ap, char *)) == NULL) {
  800368:	6a22                	ld	s4,8(sp)
  80036a:	b505                	j	80018a <vprintfmt+0x34>
                if (altflag && (ch < ' ' || ch > '~')) {
  80036c:	3781                	addiw	a5,a5,-32
  80036e:	fcfa7be3          	bgeu	s4,a5,800344 <vprintfmt+0x1ee>
                    putch('?', putdat);
  800372:	03f00513          	li	a0,63
  800376:	85ca                	mv	a1,s2
  800378:	9482                	jalr	s1
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80037a:	000dc783          	lbu	a5,0(s11)
  80037e:	0d85                	addi	s11,s11,1
  800380:	3d7d                	addiw	s10,s10,-1
  800382:	0007851b          	sext.w	a0,a5
  800386:	dbe1                	beqz	a5,800356 <vprintfmt+0x200>
  800388:	fa0cd9e3          	bgez	s9,80033a <vprintfmt+0x1e4>
  80038c:	b7c5                	j	80036c <vprintfmt+0x216>
            if (err < 0) {
  80038e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800392:	4661                	li	a2,24
            err = va_arg(ap, int);
  800394:	0a21                	addi	s4,s4,8
            if (err < 0) {
  800396:	41f7d71b          	sraiw	a4,a5,0x1f
  80039a:	8fb9                	xor	a5,a5,a4
  80039c:	40e786bb          	subw	a3,a5,a4
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8003a0:	02d64563          	blt	a2,a3,8003ca <vprintfmt+0x274>
  8003a4:	00000797          	auipc	a5,0x0
  8003a8:	5a478793          	addi	a5,a5,1444 # 800948 <error_string>
  8003ac:	00369713          	slli	a4,a3,0x3
  8003b0:	97ba                	add	a5,a5,a4
  8003b2:	639c                	ld	a5,0(a5)
  8003b4:	cb99                	beqz	a5,8003ca <vprintfmt+0x274>
                printfmt(putch, putdat, "%s", p);
  8003b6:	86be                	mv	a3,a5
  8003b8:	00000617          	auipc	a2,0x0
  8003bc:	26060613          	addi	a2,a2,608 # 800618 <main+0x140>
  8003c0:	85ca                	mv	a1,s2
  8003c2:	8526                	mv	a0,s1
  8003c4:	0d8000ef          	jal	80049c <printfmt>
  8003c8:	b3c9                	j	80018a <vprintfmt+0x34>
                printfmt(putch, putdat, "error %d", err);
  8003ca:	00000617          	auipc	a2,0x0
  8003ce:	23e60613          	addi	a2,a2,574 # 800608 <main+0x130>
  8003d2:	85ca                	mv	a1,s2
  8003d4:	8526                	mv	a0,s1
  8003d6:	0c6000ef          	jal	80049c <printfmt>
  8003da:	bb45                	j	80018a <vprintfmt+0x34>
    if (lflag >= 2) {
  8003dc:	4705                	li	a4,1
            precision = va_arg(ap, int);
  8003de:	008a0b93          	addi	s7,s4,8
    if (lflag >= 2) {
  8003e2:	00f74363          	blt	a4,a5,8003e8 <vprintfmt+0x292>
    else if (lflag) {
  8003e6:	cf81                	beqz	a5,8003fe <vprintfmt+0x2a8>
        return va_arg(*ap, long);
  8003e8:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
  8003ec:	02044b63          	bltz	s0,800422 <vprintfmt+0x2cc>
            num = getint(&ap, lflag);
  8003f0:	8622                	mv	a2,s0
  8003f2:	8a5e                	mv	s4,s7
  8003f4:	46a9                	li	a3,10
  8003f6:	b541                	j	800276 <vprintfmt+0x120>
            lflag ++;
  8003f8:	2785                	addiw	a5,a5,1
        switch (ch = *(unsigned char *)fmt ++) {
  8003fa:	8462                	mv	s0,s8
            goto reswitch;
  8003fc:	bb5d                	j	8001b2 <vprintfmt+0x5c>
        return va_arg(*ap, int);
  8003fe:	000a2403          	lw	s0,0(s4)
  800402:	b7ed                	j	8003ec <vprintfmt+0x296>
        return va_arg(*ap, unsigned int);
  800404:	000a6603          	lwu	a2,0(s4)
  800408:	46a1                	li	a3,8
  80040a:	8a2e                	mv	s4,a1
  80040c:	b5ad                	j	800276 <vprintfmt+0x120>
  80040e:	000a6603          	lwu	a2,0(s4)
  800412:	46a9                	li	a3,10
  800414:	8a2e                	mv	s4,a1
  800416:	b585                	j	800276 <vprintfmt+0x120>
  800418:	000a6603          	lwu	a2,0(s4)
  80041c:	46c1                	li	a3,16
  80041e:	8a2e                	mv	s4,a1
  800420:	bd99                	j	800276 <vprintfmt+0x120>
                putch('-', putdat);
  800422:	85ca                	mv	a1,s2
  800424:	02d00513          	li	a0,45
  800428:	9482                	jalr	s1
                num = -(long long)num;
  80042a:	40800633          	neg	a2,s0
  80042e:	8a5e                	mv	s4,s7
  800430:	46a9                	li	a3,10
  800432:	b591                	j	800276 <vprintfmt+0x120>
            if (width > 0 && padc != '-') {
  800434:	e329                	bnez	a4,800476 <vprintfmt+0x320>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800436:	02800793          	li	a5,40
  80043a:	853e                	mv	a0,a5
  80043c:	00000d97          	auipc	s11,0x0
  800440:	1bdd8d93          	addi	s11,s11,445 # 8005f9 <main+0x121>
  800444:	b5f5                	j	800330 <vprintfmt+0x1da>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800446:	85e6                	mv	a1,s9
  800448:	856e                	mv	a0,s11
  80044a:	072000ef          	jal	8004bc <strnlen>
  80044e:	40ad0d3b          	subw	s10,s10,a0
  800452:	01a05863          	blez	s10,800462 <vprintfmt+0x30c>
                    putch(padc, putdat);
  800456:	85ca                	mv	a1,s2
  800458:	8522                	mv	a0,s0
                for (width -= strnlen(p, precision); width > 0; width --) {
  80045a:	3d7d                	addiw	s10,s10,-1
                    putch(padc, putdat);
  80045c:	9482                	jalr	s1
                for (width -= strnlen(p, precision); width > 0; width --) {
  80045e:	fe0d1ce3          	bnez	s10,800456 <vprintfmt+0x300>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800462:	000dc783          	lbu	a5,0(s11)
  800466:	0007851b          	sext.w	a0,a5
  80046a:	ec0792e3          	bnez	a5,80032e <vprintfmt+0x1d8>
            if ((p = va_arg(ap, char *)) == NULL) {
  80046e:	6a22                	ld	s4,8(sp)
  800470:	bb29                	j	80018a <vprintfmt+0x34>
        switch (ch = *(unsigned char *)fmt ++) {
  800472:	8462                	mv	s0,s8
  800474:	bbd9                	j	80024a <vprintfmt+0xf4>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800476:	85e6                	mv	a1,s9
  800478:	00000517          	auipc	a0,0x0
  80047c:	18050513          	addi	a0,a0,384 # 8005f8 <main+0x120>
  800480:	03c000ef          	jal	8004bc <strnlen>
  800484:	40ad0d3b          	subw	s10,s10,a0
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800488:	02800793          	li	a5,40
                p = "(null)";
  80048c:	00000d97          	auipc	s11,0x0
  800490:	16cd8d93          	addi	s11,s11,364 # 8005f8 <main+0x120>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800494:	853e                	mv	a0,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
  800496:	fda040e3          	bgtz	s10,800456 <vprintfmt+0x300>
  80049a:	bd51                	j	80032e <vprintfmt+0x1d8>

000000000080049c <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80049c:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
  80049e:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004a2:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004a4:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8004a6:	ec06                	sd	ra,24(sp)
  8004a8:	f83a                	sd	a4,48(sp)
  8004aa:	fc3e                	sd	a5,56(sp)
  8004ac:	e0c2                	sd	a6,64(sp)
  8004ae:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
  8004b0:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
  8004b2:	ca5ff0ef          	jal	800156 <vprintfmt>
}
  8004b6:	60e2                	ld	ra,24(sp)
  8004b8:	6161                	addi	sp,sp,80
  8004ba:	8082                	ret

00000000008004bc <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
  8004bc:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
  8004be:	e589                	bnez	a1,8004c8 <strnlen+0xc>
  8004c0:	a811                	j	8004d4 <strnlen+0x18>
        cnt ++;
  8004c2:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
  8004c4:	00f58863          	beq	a1,a5,8004d4 <strnlen+0x18>
  8004c8:	00f50733          	add	a4,a0,a5
  8004cc:	00074703          	lbu	a4,0(a4)
  8004d0:	fb6d                	bnez	a4,8004c2 <strnlen+0x6>
  8004d2:	85be                	mv	a1,a5
    }
    return cnt;
}
  8004d4:	852e                	mv	a0,a1
  8004d6:	8082                	ret

00000000008004d8 <main>:
#include <ulib.h>
#include <unistd.h>

int global_data = 100;

int main(void) {
  8004d8:	1141                	addi	sp,sp,-16
    cprintf("COW Test Start\n");
  8004da:	00000517          	auipc	a0,0x0
  8004de:	20650513          	addi	a0,a0,518 # 8006e0 <main+0x208>
int main(void) {
  8004e2:	e406                	sd	ra,8(sp)
    cprintf("COW Test Start\n");
  8004e4:	b5bff0ef          	jal	80003e <cprintf>
    cprintf("Before fork: global_data = %d at %x\n", global_data, &global_data);
  8004e8:	00001597          	auipc	a1,0x1
  8004ec:	b185a583          	lw	a1,-1256(a1) # 801000 <global_data>
  8004f0:	00001617          	auipc	a2,0x1
  8004f4:	b1060613          	addi	a2,a2,-1264 # 801000 <global_data>
  8004f8:	00000517          	auipc	a0,0x0
  8004fc:	1f850513          	addi	a0,a0,504 # 8006f0 <main+0x218>
  800500:	b3fff0ef          	jal	80003e <cprintf>
    
    int pid = fork();
  800504:	bd9ff0ef          	jal	8000dc <fork>
    
    if (pid == 0) {
  800508:	c149                	beqz	a0,80058a <main+0xb2>
        // 子进程
        cprintf("Child: global_data = %d at %x\n", global_data, &global_data);
        global_data = 200;  // 触发 COW
        cprintf("Child: after write, global_data = %d at %x\n", global_data, &global_data);
        exit(0);
    } else if (pid > 0) {
  80050a:	06a05963          	blez	a0,80057c <main+0xa4>
        // 父进程
        cprintf("Parent: global_data = %d at %x\n", global_data, &global_data);
  80050e:	00001597          	auipc	a1,0x1
  800512:	af25a583          	lw	a1,-1294(a1) # 801000 <global_data>
  800516:	00001617          	auipc	a2,0x1
  80051a:	aea60613          	addi	a2,a2,-1302 # 801000 <global_data>
  80051e:	00000517          	auipc	a0,0x0
  800522:	24a50513          	addi	a0,a0,586 # 800768 <main+0x290>
  800526:	b19ff0ef          	jal	80003e <cprintf>
        // ucore 的 wait() 不接受参数
        wait();
  80052a:	bb5ff0ef          	jal	8000de <wait>
        cprintf("Parent: after child exit, global_data = %d at %x\n", global_data, &global_data);
  80052e:	00001597          	auipc	a1,0x1
  800532:	ad25a583          	lw	a1,-1326(a1) # 801000 <global_data>
  800536:	00001617          	auipc	a2,0x1
  80053a:	aca60613          	addi	a2,a2,-1334 # 801000 <global_data>
  80053e:	00000517          	auipc	a0,0x0
  800542:	24a50513          	addi	a0,a0,586 # 800788 <main+0x2b0>
  800546:	af9ff0ef          	jal	80003e <cprintf>
        
        if (global_data == 100) {
  80054a:	00001717          	auipc	a4,0x1
  80054e:	ab672703          	lw	a4,-1354(a4) # 801000 <global_data>
  800552:	06400793          	li	a5,100
  800556:	00f70c63          	beq	a4,a5,80056e <main+0x96>
            cprintf("COW Test PASS!\n");
        } else {
            cprintf("COW Test FAIL!\n");
  80055a:	00000517          	auipc	a0,0x0
  80055e:	27650513          	addi	a0,a0,630 # 8007d0 <main+0x2f8>
  800562:	addff0ef          	jal	80003e <cprintf>
    } else {
        cprintf("Fork failed!\n");
    }
    
    return 0;
}
  800566:	60a2                	ld	ra,8(sp)
  800568:	4501                	li	a0,0
  80056a:	0141                	addi	sp,sp,16
  80056c:	8082                	ret
            cprintf("COW Test PASS!\n");
  80056e:	00000517          	auipc	a0,0x0
  800572:	25250513          	addi	a0,a0,594 # 8007c0 <main+0x2e8>
  800576:	ac9ff0ef          	jal	80003e <cprintf>
  80057a:	b7f5                	j	800566 <main+0x8e>
        cprintf("Fork failed!\n");
  80057c:	00000517          	auipc	a0,0x0
  800580:	26450513          	addi	a0,a0,612 # 8007e0 <main+0x308>
  800584:	abbff0ef          	jal	80003e <cprintf>
  800588:	bff9                	j	800566 <main+0x8e>
        cprintf("Child: global_data = %d at %x\n", global_data, &global_data);
  80058a:	00001597          	auipc	a1,0x1
  80058e:	a765a583          	lw	a1,-1418(a1) # 801000 <global_data>
  800592:	00001617          	auipc	a2,0x1
  800596:	a6e60613          	addi	a2,a2,-1426 # 801000 <global_data>
  80059a:	00000517          	auipc	a0,0x0
  80059e:	17e50513          	addi	a0,a0,382 # 800718 <main+0x240>
  8005a2:	a9dff0ef          	jal	80003e <cprintf>
        global_data = 200;  // 触发 COW
  8005a6:	0c800593          	li	a1,200
        cprintf("Child: after write, global_data = %d at %x\n", global_data, &global_data);
  8005aa:	00001617          	auipc	a2,0x1
  8005ae:	a5660613          	addi	a2,a2,-1450 # 801000 <global_data>
  8005b2:	00000517          	auipc	a0,0x0
  8005b6:	18650513          	addi	a0,a0,390 # 800738 <main+0x260>
        global_data = 200;  // 触发 COW
  8005ba:	c20c                	sw	a1,0(a2)
        cprintf("Child: after write, global_data = %d at %x\n", global_data, &global_data);
  8005bc:	a83ff0ef          	jal	80003e <cprintf>
        exit(0);
  8005c0:	4501                	li	a0,0
  8005c2:	b05ff0ef          	jal	8000c6 <exit>
