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

接下来我们安装模拟器 Qemu。先创建一个目录保存qemu。

```
mkdir -p ~/qemu
cd ~/qemu
```

下载并解压 QEMU 源码。

```
wget https://download.qemu.org/qemu-4.1.1.tar.xz
tar xvJf qemu-4.1.1.tar.xz
```

进入 QEMU 源码目录并开始编译。

```
cd qemu-4.1.1
./configure --target-list=riscv32-softmmu,riscv64-softmmu
make -j$(nproc) 
sudo make install
```

新版 Qemu 中内置了 OpenSBI 固件（firmware），它主要负责在操作系统运行前的硬件初始化和加载操作系统的功能。我们使用以下命令尝试运行一下：

```
qemu-system-riscv64 \
  --machine virt \
  --nographic \
  --bios default
```
我们在终端上看到下面的输出，这就是 OpenSBI 的启动信息。

![OpenSBI启动界面](https://raw.githubusercontent.com/Dou-Dou-Da-D1/OS/master/OS0/images/1.png)

说明环境配置成功！