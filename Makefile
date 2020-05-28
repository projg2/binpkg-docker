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


RUN_ARGS_KERNEL_5_6_AMD64 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		sys-fs/vhba \
		sys-power/acpi_call \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'
RUN_ARGS_KERNEL_5_6_X86 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		sys-fs/vhba \
		sys-power/bbswitch \
		'

RUN_ARGS_VANILLA_KERNEL_5_6 = \
	-e PKG='<sys-kernel/vanilla-kernel-5.7'
RUN_ARGS_VANILLA_KERNEL_5_6_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-5.7'
RUN_ARGS_GENTOO_KERNEL_5_6 = \
	-e PKG='<sys-kernel/gentoo-kernel-5.7'
RUN_ARGS_GENTOO_KERNEL_5_6_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-5.7'


RUN_ARGS_KERNEL_5_5_AMD64 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-emulation/virtualbox-modules \
		app-laptop/tp_smapi \
		dev-util/sysdig-kmod \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-misc/AQtion \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-power/acpi_call \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'
RUN_ARGS_KERNEL_5_5_X86 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		dev-util/sysdig-kmod \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-power/bbswitch \
		'

RUN_ARGS_VANILLA_KERNEL_5_5 = \
	-e PKG='<sys-kernel/vanilla-kernel-5.6'
RUN_ARGS_VANILLA_KERNEL_5_5_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-5.6'
RUN_ARGS_GENTOO_KERNEL_5_5 = \
	-e PKG='<sys-kernel/gentoo-kernel-5.6'
RUN_ARGS_GENTOO_KERNEL_5_5_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-5.6'


RUN_ARGS_KERNEL_5_4_AMD64 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-emulation/virtualbox-guest-additions \
		app-emulation/virtualbox-modules \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig-kmod \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
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
		x11-drivers/nvidia-drivers \
		'
RUN_ARGS_KERNEL_5_4_X86 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-vpn/wireguard-modules \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'

RUN_ARGS_VANILLA_KERNEL_5_4 = \
	-e PKG='<sys-kernel/vanilla-kernel-5.5'
RUN_ARGS_VANILLA_KERNEL_5_4_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-5.5'
RUN_ARGS_GENTOO_KERNEL_5_4 = \
	-e PKG='<sys-kernel/gentoo-kernel-5.5'
RUN_ARGS_GENTOO_KERNEL_5_4_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-5.5'


RUN_ARGS_KERNEL_4_19_AMD64 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-emulation/virtualbox-guest-additions \
		app-emulation/virtualbox-modules \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig-kmod \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/ipt_netflow \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		net-fs/openafs \
		net-misc/AQtion \
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
RUN_ARGS_KERNEL_4_19_X86 = \
	-e POST_PKGS=' \
		app-crypt/tpm-emulator \
		app-laptop/tp_smapi \
		dev-util/lttng-modules \
		dev-util/sysdig-kmod \
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

RUN_ARGS_VANILLA_KERNEL_4_19 = \
	-e PKG='<sys-kernel/vanilla-kernel-5'
RUN_ARGS_VANILLA_KERNEL_4_19_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-5'
RUN_ARGS_GENTOO_KERNEL_4_19 = \
	-e PKG='<sys-kernel/gentoo-kernel-5'
RUN_ARGS_GENTOO_KERNEL_4_19_BIN = \
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
build: build-amd64-vanilla-kernel-5.6 build-x86-vanilla-kernel-5.6
build: build-amd64-vanilla-kernel-5.5 build-x86-vanilla-kernel-5.5
build: build-amd64-vanilla-kernel-5.4 build-x86-vanilla-kernel-5.4
build: build-amd64-vanilla-kernel-4.19 build-x86-vanilla-kernel-4.19
build: build-amd64-gentoo-kernel-5.6 build-x86-gentoo-kernel-5.6
build: build-amd64-gentoo-kernel-5.5 build-x86-gentoo-kernel-5.5
build: build-amd64-gentoo-kernel-5.4 build-x86-gentoo-kernel-5.4
build: build-amd64-gentoo-kernel-4.19 build-x86-gentoo-kernel-4.19


gentoo-x86-stable:
	$(DOCKER) build -f Dockerfile.base \
		--build-arg BASE=gentoo/stage3-x86 -t mgorny/$@ .

gentoo-amd64-stable:
	$(DOCKER) build -f Dockerfile.base \
		--build-arg BASE=gentoo/stage3-amd64-nomultilib -t mgorny/$@ .


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
	$(DOCKER) run $(BIN_ARGS_X86_PYPY) $(RUN_ARGS_PYPY) build-$@

build-x86-pypy3: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY3) -t $@ .
x86-pypy3: build-x86-pypy3
	$(DOCKER) run $(BIN_ARGS_X86_PYPY) $(RUN_ARGS_PYPY3) build-$@

build-x86-pypy-bin: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY_BIN) -t $@ .
x86-pypy-bin: build-x86-pypy-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_PYPY_BIN) build-$@

build-x86-pypy3-bin: build-x86-pypy-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< $(ARGS_PYPY3_BIN) -t $@ .
x86-pypy3-bin: build-x86-pypy3-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_PYPY3_BIN) build-$@


build-amd64-vanilla-kernel-5.6: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-5.6: build-amd64-vanilla-kernel-5.6
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_5_6) \
		$(RUN_ARGS_KERNEL_5_6_AMD64) build-$@

build-x86-vanilla-kernel-5.6: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-5.6: build-x86-vanilla-kernel-5.6
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_5_6) \
		$(RUN_ARGS_KERNEL_5_6_X86) build-$@

build-amd64-vanilla-kernel-5.6-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-5.6-bin: build-amd64-vanilla-kernel-5.6-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_5_6) \
		$(RUN_ARGS_KERNEL_5_6_AMD64) build-$@

build-x86-vanilla-kernel-5.6-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-5.6-bin: build-x86-vanilla-kernel-5.6-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_5_6) \
		$(RUN_ARGS_KERNEL_5_6_X86) build-$@


build-amd64-vanilla-kernel-5.5: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-5.5: build-amd64-vanilla-kernel-5.5
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_5_5) \
		$(RUN_ARGS_KERNEL_5_5_AMD64) build-$@

build-x86-vanilla-kernel-5.5: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-5.5: build-x86-vanilla-kernel-5.5
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_5_5) \
		$(RUN_ARGS_KERNEL_5_5_X86) build-$@

build-amd64-vanilla-kernel-5.5-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-5.5-bin: build-amd64-vanilla-kernel-5.5-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_5_5) \
		$(RUN_ARGS_KERNEL_5_5_AMD64) build-$@

build-x86-vanilla-kernel-5.5-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-5.5-bin: build-x86-vanilla-kernel-5.5-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_5_5) \
		$(RUN_ARGS_KERNEL_5_5_X86) build-$@


build-amd64-vanilla-kernel-5.4: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-5.4: build-amd64-vanilla-kernel-5.4
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_5_4) \
		$(RUN_ARGS_KERNEL_5_4_AMD64) build-$@

build-x86-vanilla-kernel-5.4: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-5.4: build-x86-vanilla-kernel-5.4
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_5_4) \
		$(RUN_ARGS_KERNEL_5_4_X86) build-$@

build-amd64-vanilla-kernel-5.4-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-5.4-bin: build-amd64-vanilla-kernel-5.4-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_5_4_BIN) \
		$(RUN_ARGS_KERNEL_5_4_AMD64) build-$@

build-x86-vanilla-kernel-5.4-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-5.4-bin: build-x86-vanilla-kernel-5.4-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_5_4_BIN) \
		$(RUN_ARGS_KERNEL_5_4_X86) build-$@


build-amd64-vanilla-kernel-4.19: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-4.19: build-amd64-vanilla-kernel-4.19
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_4_19) \
		$(RUN_ARGS_KERNEL_4_19_AMD64) build-$@

build-x86-vanilla-kernel-4.19: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-4.19: build-x86-vanilla-kernel-4.19
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_4_19) \
		$(RUN_ARGS_KERNEL_4_19_X86) build-$@

build-amd64-vanilla-kernel-4.19-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-4.19-bin: build-amd64-vanilla-kernel-4.19-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_4_19_BIN) \
		$(RUN_ARGS_KERNEL_4_19_AMD64) build-$@

build-x86-vanilla-kernel-4.19-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-4.19-bin: build-x86-vanilla-kernel-4.19-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_4_19_BIN) \
		$(RUN_ARGS_KERNEL_4_19_X86) build-$@


build-amd64-gentoo-kernel-5.6: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-5.6: build-amd64-gentoo-kernel-5.6
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_5_6) \
		$(RUN_ARGS_KERNEL_5_6_AMD64) build-$@

build-x86-gentoo-kernel-5.6: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-5.6: build-x86-gentoo-kernel-5.6
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_5_6) \
		$(RUN_ARGS_KERNEL_5_6_X86) build-$@

build-amd64-gentoo-kernel-5.6-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-5.6-bin: build-amd64-gentoo-kernel-5.6-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_5_6_BIN) \
		$(RUN_ARGS_KERNEL_5_6_AMD64) build-$@

build-x86-gentoo-kernel-5.6-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-5.6-bin: build-x86-gentoo-kernel-5.6-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_5_6_BIN) \
		$(RUN_ARGS_KERNEL_5_6_X86) build-$@


build-amd64-gentoo-kernel-5.5: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-5.5: build-amd64-gentoo-kernel-5.5
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_5_5) \
		$(RUN_ARGS_KERNEL_5_5_AMD64) build-$@

build-x86-gentoo-kernel-5.5: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-5.5: build-x86-gentoo-kernel-5.5
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_5_5) \
		$(RUN_ARGS_KERNEL_5_5_X86) build-$@

build-amd64-gentoo-kernel-5.5-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-5.5-bin: build-amd64-gentoo-kernel-5.5-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_5_5_BIN) \
		$(RUN_ARGS_KERNEL_5_5_AMD64) build-$@

build-x86-gentoo-kernel-5.5-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-5.5-bin: build-x86-gentoo-kernel-5.5-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_5_5_BIN) \
		$(RUN_ARGS_KERNEL_5_5_X86) build-$@


build-amd64-gentoo-kernel-5.4: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-5.4: build-amd64-gentoo-kernel-5.4
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_5_4) \
		$(RUN_ARGS_KERNEL_5_4_AMD64) build-$@

build-x86-gentoo-kernel-5.4: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-5.4: build-x86-gentoo-kernel-5.4
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_5_4) \
		$(RUN_ARGS_KERNEL_5_4_X86) build-$@

build-amd64-gentoo-kernel-5.4-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-5.4-bin: build-amd64-gentoo-kernel-5.4-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_5_4_BIN) \
		$(RUN_ARGS_KERNEL_5_4_AMD64) build-$@

build-x86-gentoo-kernel-5.4-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-5.4-bin: build-x86-gentoo-kernel-5.4-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_5_4_BIN) \
		$(RUN_ARGS_KERNEL_5_4_X86) build-$@


build-amd64-gentoo-kernel-4.19: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-4.19: build-amd64-gentoo-kernel-4.19
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_4_19) \
		$(RUN_ARGS_KERNEL_4_19_AMD64) build-$@

build-x86-gentoo-kernel-4.19: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-4.19: build-x86-gentoo-kernel-4.19
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_4_19) \
		$(RUN_ARGS_KERNEL_4_19_X86) build-$@

build-amd64-gentoo-kernel-4.19-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-4.19-bin: build-amd64-gentoo-kernel-4.19-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_4_19_BIN) \
		$(RUN_ARGS_KERNEL_4_19_AMD64) build-$@

build-x86-gentoo-kernel-4.19-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-4.19-bin: build-x86-gentoo-kernel-4.19-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_4_19_BIN) \
		$(RUN_ARGS_KERNEL_4_19_X86) build-$@


prune:
	$(DOCKER) container prune -f
	$(DOCKER) image prune -a -f
	$(DOCKER) volume prune -f
