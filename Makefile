DOCKER ?= docker
BUILD_ARGS_DEPS = --pull
BUILD_ARGS =

ARGS_AMD64 = \
	--build-arg BASE=gentoo/stage3-amd64-nomultilib \
	--build-arg CFLAGS='-march=x86-64 -mtune=generic -O2 -pipe'
ARGS_X86 = \
	--build-arg BASE=gentoo/stage3-x86 \
	--build-arg CFLAGS='-march=pentium-m -mtune=generic -O2 -pipe'


ARGS_PYPY_DEPS = \
	--build-arg DEPS='dev-python/pypy dev-python/pypy-exe-bin'

RUN_ARGS_PYPY2_COMMON = \
	-e POST_PKGS='dev-python/pypy'
RUN_ARGS_PYPY3_COMMON = \
	-e POST_PKGS=' \
		dev-python/pypy3 \
		dev-python/setuptools \
		dev-python/cryptography \
		'

RUN_ARGS_PYPY = $(RUN_ARGS_PYPY2_COMMON) \
	-e PKG=dev-python/pypy-exe
RUN_ARGS_PYPY3 = $(RUN_ARGS_PYPY3_COMMON) \
	-e PKG=dev-python/pypy3-exe
RUN_ARGS_PYPY_BIN = $(RUN_ARGS_PYPY2_COMMON) \
	-e PKG=dev-python/pypy-exe-bin
RUN_ARGS_PYPY3_BIN = $(RUN_ARGS_PYPY3_COMMON) \
	-e PKG=dev-python/pypy3-exe-bin


ARGS_KERNEL_DEPS = \
	--build-arg DEPS=' \
		virtual/libelf \
		sys-devel/bc \
		app-emulation/qemu \
		dev-tcltk/expect \
		sys-kernel/dracut \
		net-misc/openssh \
		'

RUN_ARGS_KERNEL_AMD64 = \
	-e POST_PKGS=' \
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
RUN_ARGS_KERNEL_X86 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-power/bbswitch \
		'

RUN_ARGS_VANILLA_KERNEL = \
	-e PKG=sys-kernel/vanilla-kernel
RUN_ARGS_VANILLA_KERNEL_BIN = \
	-e PKG=sys-kernel/vanilla-kernel-bin
RUN_ARGS_GENTOO_KERNEL = \
	-e PKG=sys-kernel/gentoo-kernel
RUN_ARGS_GENTOO_KERNEL_BIN = \
	-e PKG=sys-kernel/gentoo-kernel-bin

RUN_ARGS_KERNEL_LTS_AMD64 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-emulation/virtualbox-guest-additions \
		app-emulation/virtualbox-modules \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-fs/openafs \
		net-misc/AQtion \
		net-misc/ena-driver \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sci-libs/linux-gpib-modules \
		sys-cluster/knem \
		sys-fs/loop-aes \
		sys-fs/vhba \
		sys-fs/zfs-kmod \
		sys-kernel/cryptodev \
		sys-power/acpi_call \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'
RUN_ARGS_KERNEL_LTS_X86 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-fs/openafs \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sci-libs/linux-gpib-modules \
		sys-cluster/knem \
		sys-fs/loop-aes \
		sys-fs/vhba \
		sys-kernel/cryptodev \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'

RUN_ARGS_VANILLA_KERNEL_LTS = \
	-e PKG='<sys-kernel/vanilla-kernel-5'
RUN_ARGS_VANILLA_KERNEL_LTS_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-5'
RUN_ARGS_GENTOO_KERNEL_LTS = \
	-e PKG='<sys-kernel/gentoo-kernel-5'
RUN_ARGS_GENTOO_KERNEL_LTS_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-5'

BINPKGROOT = ~/binpkg
DISTCACHE = ~/distfiles
CCACHE = ~/ccache
BIN_ARGS_COMMON = \
	-v $(DISTCACHE):/var/cache/distfiles \
	-v $(CCACHE):/var/tmp/ccache
BIN_ARGS_AMD64_PYPY = $(BIN_ARGS_COMMON) \
	-v $(BINPKGROOT)/amd64/pypy:/var/cache/binpkgs
BIN_ARGS_X86_PYPY = $(BIN_ARGS_COMMON) \
	-v $(BINPKGROOT)/x86/pypy:/var/cache/binpkgs
BIN_ARGS_AMD64_KERNEL = $(BIN_ARGS_COMMON) \
	-v $(BINPKGROOT)/amd64/kernel:/var/cache/binpkgs
BIN_ARGS_X86_KERNEL = $(BIN_ARGS_COMMON) \
	-v $(BINPKGROOT)/x86/kernel:/var/cache/binpkgs
# throwaway
BIN_ARGS_BIN = $(BIN_ARGS_COMMON)


build-deps: build-amd64-pypy-deps build-x86-pypy-deps
build-deps: build-amd64-kernel-deps build-x86-kernel-deps

build: build-amd64-pypy build-x86-pypy
build: build-amd64-pypy3 build-x86-pypy3
build: build-amd64-vanilla-kernel build-x86-vanilla-kernel
build: build-amd64-vanilla-kernel-lts build-x86-vanilla-kernel-lts
build: build-amd64-gentoo-kernel build-x86-gentoo-kernel
build: build-amd64-gentoo-kernel-lts build-x86-gentoo-kernel-lts


build-amd64-pypy-deps:
	$(DOCKER) build -f Dockerfile.deps \
		$(BUILD_ARGS_DEPS) $(ARGS_AMD64) $(ARGS_PYPY_DEPS) -t $@ .
build-x86-pypy-deps:
	$(DOCKER) build -f Dockerfile.deps \
		$(BUILD_ARGS_DEPS) $(ARGS_X86) $(ARGS_PYPY_DEPS) -t $@ .

build-amd64-kernel-deps:
	$(DOCKER) build -f Dockerfile.deps \
		$(BUILD_ARGS_DEPS) $(ARGS_AMD64) $(ARGS_KERNEL_DEPS) -t $@ .
build-x86-kernel-deps:
	$(DOCKER) build -f Dockerfile.deps \
		$(BUILD_ARGS_DEPS) $(ARGS_X86) $(ARGS_KERNEL_DEPS) -t $@ .


build-amd64-pypy: build-amd64-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-pypy: build-amd64-pypy
	$(DOCKER) run $(BIN_ARGS_AMD64_PYPY) $(RUN_ARGS_PYPY) build-$@

build-amd64-pypy3: build-amd64-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-pypy3: build-amd64-pypy3
	$(DOCKER) run $(BIN_ARGS_AMD64_PYPY) $(RUN_ARGS_PYPY3) build-$@

build-amd64-pypy-bin: build-amd64-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-pypy-bin: build-amd64-pypy-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_PYPY_BIN) build-$@

build-amd64-pypy3-bin: build-amd64-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-pypy3-bin: build-amd64-pypy3-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_PYPY3_BIN) build-$@

build-x86-pypy: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY) -t $@ .
x86-pypy: build-x86-pypy
	$(DOCKER) run $(BIN_ARGS_X86_PYPY) build-$@

build-x86-pypy3: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY3) -t $@ .
x86-pypy3: build-x86-pypy3
	$(DOCKER) run $(BIN_ARGS_X86_PYPY) build-$@

build-x86-pypy-bin: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY_BIN) -t $@ .
x86-pypy-bin: build-x86-pypy-bin
	$(DOCKER) run $(BIN_ARGS_BIN) build-$@

build-x86-pypy3-bin: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY3_BIN) -t $@ .
x86-pypy3-bin: build-x86-pypy3-bin
	$(DOCKER) run $(BIN_ARGS_BIN) build-$@


build-amd64-vanilla-kernel: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel: build-amd64-vanilla-kernel
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL) \
		$(RUN_ARGS_KERNEL_AMD64) build-$@

build-x86-vanilla-kernel: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel: build-x86-vanilla-kernel
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL) \
		$(RUN_ARGS_KERNEL_X86) build-$@

build-amd64-vanilla-kernel-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-bin: build-amd64-vanilla-kernel-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN) \
		$(RUN_ARGS_KERNEL_AMD64) build-$@

build-x86-vanilla-kernel-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-bin: build-x86-vanilla-kernel-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN) \
		$(RUN_ARGS_KERNEL_X86) build-$@

build-amd64-vanilla-kernel-lts: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-lts: build-amd64-vanilla-kernel-lts
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_LTS) \
		$(RUN_ARGS_KERNEL_LTS_AMD64) build-$@

build-x86-vanilla-kernel-lts: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-lts: build-x86-vanilla-kernel-lts
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_LTS) \
		$(RUN_ARGS_KERNEL_LTS_X86) build-$@

build-amd64-vanilla-kernel-lts-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-lts-bin: build-amd64-vanilla-kernel-lts-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_LTS_BIN) \
		$(RUN_ARGS_KERNEL_LTS_AMD64) build-$@

build-x86-vanilla-kernel-lts-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-lts-bin: build-x86-vanilla-kernel-lts-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_LTS_BIN) \
		$(RUN_ARGS_KERNEL_LTS_X86) build-$@


build-amd64-gentoo-kernel: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel: build-amd64-gentoo-kernel
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL) \
		$(RUN_ARGS_KERNEL_AMD64) build-$@

build-x86-gentoo-kernel: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel: build-x86-gentoo-kernel
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL) \
		$(RUN_ARGS_KERNEL_X86) build-$@

build-amd64-gentoo-kernel-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-bin: build-amd64-gentoo-kernel-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_BIN) \
		$(RUN_ARGS_KERNEL_AMD64) build-$@

build-x86-gentoo-kernel-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-bin: build-x86-gentoo-kernel-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_BIN) \
		$(RUN_ARGS_KERNEL_X86) build-$@

build-amd64-gentoo-kernel-lts: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-lts: build-amd64-gentoo-kernel-lts
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_LTS) \
		$(RUN_ARGS_KERNEL_LTS_AMD64) build-$@

build-x86-gentoo-kernel-lts: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-lts: build-x86-gentoo-kernel-lts
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_LTS) \
		$(RUN_ARGS_KERNEL_LTS_X86) build-$@

build-amd64-gentoo-kernel-lts-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-lts-bin: build-amd64-gentoo-kernel-lts-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_LTS_BIN) \
		$(RUN_ARGS_KERNEL_LTS_AMD64) build-$@

build-x86-gentoo-kernel-lts-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-lts-bin: build-x86-gentoo-kernel-lts-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_LTS_BIN) \
		$(RUN_ARGS_KERNEL_LTS_X86) build-$@


prune:
	$(DOCKER) container prune -f
	$(DOCKER) image prune -a -f
	$(DOCKER) volume prune -f
