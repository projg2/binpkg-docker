DOCKER ?= docker
BUILD_ARGS = --pull

ARGS_AMD64 = \
	--build-arg ARCH=amd64 \
	--build-arg BASE=gentoo/stage3-amd64-nomultilib \
	--build-arg CFLAGS='-march=x86-64 -mtune=generic -O2 -pipe'
ARGS_X86 = \
	--build-arg ARCH=x86 \
	--build-arg BASE=gentoo/stage3-x86 \
	--build-arg CFLAGS='-march=pentium-m -mtune=generic -O2 -pipe'

ARGS_PYPY_COMMON = \
	--build-arg DEPS='dev-python/pypy dev-python/pypy-exe-bin'
ARGS_PYPY2_COMMON = $(ARGS_PYPY_COMMON) \
	--build-arg POST_PKGS='dev-python/pypy'
ARGS_PYPY3_COMMON = $(ARGS_PYPY_COMMON) \
	--build-arg POST_PKGS=' \
		dev-python/pypy3 \
		dev-python/setuptools \
		dev-python/cryptography \
		'
ARGS_PYPY = $(ARGS_PYPY2_COMMON) \
	--build-arg PKG=dev-python/pypy-exe
ARGS_PYPY3 = $(ARGS_PYPY3_COMMON) \
	--build-arg PKG=dev-python/pypy3-exe
ARGS_PYPY_BIN = $(ARGS_PYPY2_COMMON) \
	--build-arg PKG=dev-python/pypy-exe-bin
ARGS_PYPY3_BIN = $(ARGS_PYPY3_COMMON) \
	--build-arg PKG=dev-python/pypy3-exe-bin

ARGS_KERNEL_COMMON = \
	--build-arg DEPS=' \
		virtual/libelf \
		sys-devel/bc \
		app-emulation/qemu \
		dev-tcltk/expect \
		sys-kernel/dracut \
		net-misc/openssh \
		' \
	--build-arg POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-emulation/virtualbox-guest-additions \
		app-emulation/virtualbox-modules \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-misc/AQtion \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-fs/zfs-kmod \
		sys-power/acpi_call \
		sys-power/bbswitch \
		'
ARGS_VANILLA_KERNEL = $(ARGS_KERNEL_COMMON) \
	--build-arg PKG=sys-kernel/vanilla-kernel
ARGS_VANILLA_KERNEL_BIN = $(ARGS_KERNEL_COMMON) \
	--build-arg PKG=sys-kernel/vanilla-kernel-bin

BINPKGROOT = ~/binpkg
RUN_ARGS_AMD64_PYPY = \
	-v $(BINPKGROOT)/amd64/pypy:/var/cache/binpkgs
RUN_ARGS_X86_PYPY = \
	-v $(BINPKGROOT)/x86/pypy:/var/cache/binpkgs
RUN_ARGS_AMD64_KERNEL = \
	-v $(BINPKGROOT)/amd64/kernel:/var/cache/binpkgs
RUN_ARGS_X86_KERNEL = \
	-v $(BINPKGROOT)/x86/kernel:/var/cache/binpkgs
# throwaway
RUN_ARGS_BIN =

build: build-amd64-pypy build-x86-pypy
build: build-amd64-pypy3 build-x86-pypy3
build: build-amd64-vanilla-kernel build-x86-vanilla-kernel

build-amd64-pypy: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_AMD64) $(ARGS_PYPY) -t $@ .
amd64-pypy: build-amd64-pypy
	$(DOCKER) run $(RUN_ARGS_AMD64_PYPY) build-$@

build-amd64-pypy3: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_AMD64) $(ARGS_PYPY3) -t $@ .
amd64-pypy3: build-amd64-pypy3
	$(DOCKER) run $(RUN_ARGS_AMD64_PYPY) build-$@

build-amd64-pypy-bin: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_AMD64) $(ARGS_PYPY_BIN) -t $@ .
amd64-pypy-bin: build-amd64-pypy-bin
	$(DOCKER) run $(RUN_ARGS_BIN) build-$@

build-amd64-pypy3-bin: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_AMD64) $(ARGS_PYPY3_BIN) -t $@ .
amd64-pypy3-bin: build-amd64-pypy3-bin
	$(DOCKER) run $(RUN_ARGS_BIN) build-$@

build-x86-pypy: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_X86) $(ARGS_PYPY) -t $@ .
x86-pypy: build-x86-pypy
	$(DOCKER) run $(RUN_ARGS_X86_PYPY) build-$@

build-x86-pypy3: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_X86) $(ARGS_PYPY3) -t $@ .
x86-pypy3: build-x86-pypy3
	$(DOCKER) run $(RUN_ARGS_X86_PYPY) build-$@

build-x86-pypy-bin: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_X86) $(ARGS_PYPY_BIN) -t $@ .
x86-pypy-bin: build-x86-pypy-bin
	$(DOCKER) run $(RUN_ARGS_BIN) build-$@

build-x86-pypy3-bin: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_X86) $(ARGS_PYPY3_BIN) -t $@ .
x86-pypy3-bin: build-x86-pypy3-bin
	$(DOCKER) run $(RUN_ARGS_BIN) build-$@

build-amd64-vanilla-kernel: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_AMD64) $(ARGS_VANILLA_KERNEL) -t $@ .
amd64-vanilla-kernel: build-amd64-vanilla-kernel
	$(DOCKER) run $(RUN_ARGS_AMD64_KERNEL) build-$@

build-x86-vanilla-kernel: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_X86) $(ARGS_VANILLA_KERNEL) -t $@ .
x86-vanilla-kernel: build-x86-vanilla-kernel
	$(DOCKER) run $(RUN_ARGS_X86_KERNEL) build-$@

build-amd64-vanilla-kernel-bin: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_AMD64) $(ARGS_VANILLA_KERNEL_BIN) -t $@ .
amd64-vanilla-kernel-bin: build-amd64-vanilla-kernel-bin
	$(DOCKER) run $(RUN_ARGS_AMD64_KERNEL) build-$@

build-x86-vanilla-kernel-bin: local.diff
	$(DOCKER) build $(BUILD_ARGS) $(ARGS_X86) $(ARGS_VANILLA_KERNEL_BIN) -t $@ .
x86-vanilla-kernel-bin: build-x86-vanilla-kernel-bin
	$(DOCKER) run $(RUN_ARGS_X86_KERNEL) build-$@
