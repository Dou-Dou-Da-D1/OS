
### 1
make debug

### 3
make gdb

set remotetimeout unlimited

b kern_init

c

x/8i $pc(sd)

si 7

si

i r sp


### 2
pgrep -f qemu-system-riscv64 

sudo gdb

attach <pid>

handle SIGPIPE nostop noprint

c

b get_physical_address
b riscv_cpu_tlb_fill
b get_page_addr_code

c

p/x addr

c

p/x addr

c

c

ccccccc

bt 30(tlb_fill)



# 在riscv_cpu_tlb_fill断点处

# 1. 查看基本信息
print /x address
print /x ((CPURISCVState*)cs->env_ptr)->satp
print access_type
print mmu_idx

# 2. 解析SATP
set $satp = ((CPURISCVState*)cs->env_ptr)->satp
set $mode = ($satp >> 60) & 0xF
set $ppn = $satp & 0xFFFFFFFFFFF
print $mode
print /x $ppn
print /x $ppn << 12

# 3. 分解虚拟地址
set $va = address
set $vpn2 = ($va >> 30) & 0x1FF
set $vpn1 = ($va >> 21) & 0x1FF
set $vpn0 = ($va >> 12) & 0x1FF
set $offset = $va & 0xFFF
printf "VPN[2]=%d, VPN[1]=%d, VPN[0]=%d, Offset=0x%x\n", $vpn2, $vpn1, $vpn0, $offset

# 4. 继续到页表遍历
c

# 在get_physical_address断点处

# === 基本信息 ===
p/x addr
p/x env->satp
print access_type
print mmu_idx

# === SATP解析 ===
set $satp = env->satp
set $mode = ($satp >> 60) & 0xF
set $ppn = $satp & 0xFFFFFFFFFFF
print $mode
print /x $ppn << 12

# === 虚拟地址分解 ===
set $va = addr
set $vpn2 = ($va >> 30) & 0x1FF
set $vpn1 = ($va >> 21) & 0x1FF
set $vpn0 = ($va >> 12) & 0x1FF
set $offset = $va & 0xFFF
printf "VA=0x%lx: VPN[2]=%d VPN[1]=%d VPN[0]=%d Offset=0x%x\n", $va, $vpn2, $vpn1, $vpn0, $offset

# === 跳到for循环开始 ===
tbreak 237
c
print levels
print /x base

# === 第1次循环：计算idx ===
tbreak 238
c
print i
print idx

# === 计算pte_addr ===
tbreak 242
c
print /x pte_addr

# === 读取PTE后 ===
tbreak 254
c
print /x pte
print /x ppn
printf "L%d: idx=%ld pte_addr=0x%lx pte=0x%lx ppn=0x%lx\n", i+1, idx, pte_addr, pte, ppn



# === 或者直接跳到函数结束 ===
delete 3 4 5 6 7
finish
print /x *physical
printf "VA 0x%lx -> PA 0x%lx\n", addr, *physical