# Lab0

在lab0，我们主要进行实验环境的搭建。

首先打开vscode的 WSL Ubuntu 终端，执行以下命令：

```
mkdir -p ~/riscv
cd ~/riscv
```

现在，我们需要从 SiFive 的 GitHub Releases 页面下载最新的工具链。使用 wget 命令来下载文件:

```
wget https://static.dev.sifive.com/dev-tools/freedom-tools/v2020.12/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14.tar.gz
```
等待下载完成。下载的文件会保存在 ~/riscv 目录下。

下载完成后，我们得到了一个 .tar.gz 压缩包。使用 tar 命令来解压它。

```
tar -xzvf riscv64-unknown-elf-gcc-10.2.0-2020.12.0-x86_64-linux-ubuntu14.tar.gz
```

接下来我们配置环境变量PATH。

```
echo 'export PATH="$PATH:$HOME/riscv/riscv64-unknown-elf-gcc-10.2.0-2020.12.0-x86_64-linux-ubuntu14/bin"' >> ~/.bashrc
```

让配置立即生效。

```
source ~/.bashrc
```


发现gcc已经安装好了

下面安装qemu，失败了好多次。。。

```
$ wget https://download.qemu.org/qemu-4.1.1.tar.xz
$ tar xvJf qemu-4.1.1.tar.xz
$ cd qemu-4.1.1
$ ./configure --target-list=riscv32-softmmu,riscv64-softmmu
$ make -j
$ sudo make install
```

![8b0d501cffbb7d73a71a76d325f2dae](E:\学学学\本科\大三上\操作系统\Lab\Lab0\report\Lab0.assets\8b0d501cffbb7d73a71a76d325f2dae.png)

qemu安装成功！

输入

```bash
$ qemu-system-riscv64 \
  --machine virt \
  --nographic \
  --bios default
```

![9f924854c6b7ae49e127f2fe60e0878](E:\学学学\本科\大三上\操作系统\Lab\Lab0\report\Lab0.assets\9f924854c6b7ae49e127f2fe60e0878.png)

说明环境配置成功！

我们进行lab0的测试

![image-20240912223156063](E:\学学学\本科\大三上\操作系统\Lab\Lab0\report\Lab0.assets\image-20240912223156063.png)

成功！lab0就结束了