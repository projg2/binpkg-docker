DOCKER ?= docker
BUILD_ARGS_DEPS = --pull
BUILD_ARGS =

KERNEL_NEWEST_LT = 5.12
KERNEL_SECOND_LT = 5.11
KERNEL_LTS_LT = 5.5

ARGS_AMD64 = \
	--build-arg BASE=gentoo/stage3:amd64-nomultilib \
	--build-arg CFLAGS='-march=x86-64 -mtune=generic -O2 -pipe'
ARGS_X86 = \
	--build-arg BASE=gentoo/stage3:x86 \
	--build-arg CFLAGS='-march=pentium-m -mtune=generic -O2 -pipe'


ARGS_PYPY_DEPS = \
	--build-arg DEPS='dev-python/pypy dev-python/pypy-exe-bin'

RUN_ARGS_PYPY2_COMMON = \
	-e POST_PKGS='dev-python/pypy'
RUN_ARGS_PYPY3_COMMON = \
	-e POST_PKGS='dev-python/pypy3'

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
		dev-util/dwarves \
		'


RUN_ARGS_KERNEL_NEWEST_AMD64 = \
	-e POST_PKGS=' \
		app-laptop/tp_smapi \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		sys-fs/vhba \
		sys-power/acpi_call \
		sys-power/bbswitch \
		'
RUN_ARGS_KERNEL_NEWEST_X86 = \
	-e POST_PKGS=' \
		app-laptop/tp_smapi \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		sys-fs/vhba \
		sys-power/bbswitch \
		'

RUN_ARGS_VANILLA_KERNEL_NEWEST = \
	-e PKG='<sys-kernel/vanilla-kernel-$(KERNEL_NEWEST_LT)'
RUN_ARGS_VANILLA_KERNEL_NEWEST_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-$(KERNEL_NEWEST_LT)'
RUN_ARGS_GENTOO_KERNEL_NEWEST = \
	-e PKG='<sys-kernel/gentoo-kernel-$(KERNEL_NEWEST_LT)'
RUN_ARGS_GENTOO_KERNEL_NEWEST_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-$(KERNEL_NEWEST_LT)'


RUN_ARGS_KERNEL_SECOND_AMD64 = \
	-e POST_PKGS=' \
		app-laptop/tp_smapi \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		sys-fs/vhba \
		sys-power/acpi_call \
		sys-power/bbswitch \
		'
RUN_ARGS_KERNEL_SECOND_X86 = \
	-e POST_PKGS=' \
		app-laptop/tp_smapi \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		net-firewall/xtables-addons \
		sys-fs/vhba \
		sys-power/bbswitch \
		'

RUN_ARGS_VANILLA_KERNEL_SECOND = \
	-e PKG='<sys-kernel/vanilla-kernel-$(KERNEL_SECOND_LT)'
RUN_ARGS_VANILLA_KERNEL_SECOND_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-$(KERNEL_SECOND_LT)'
RUN_ARGS_GENTOO_KERNEL_SECOND = \
	-e PKG='<sys-kernel/gentoo-kernel-$(KERNEL_SECOND_LT)'
RUN_ARGS_GENTOO_KERNEL_SECOND_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-$(KERNEL_SECOND_LT)'


RUN_ARGS_KERNEL_LTS_AMD64 = \
	-e POST_PKGS=' \
		app-emulation/virtualbox-guest-additions \
		app-emulation/virtualbox-modules \
		app-laptop/tp_smapi \
		dev-util/sysdig-kmod \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		net-misc/AQtion \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-fs/zfs-kmod \
		sys-power/acpi_call \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'
RUN_ARGS_KERNEL_LTS_X86 = \
	-e POST_PKGS=' \
		app-laptop/tp_smapi \
		media-video/v4l2loopback \
		net-dialup/accel-ppp \
		net-firewall/rtsp-conntrack \
		net-wireless/broadcom-sta \
		sys-fs/vhba \
		sys-power/bbswitch \
		x11-drivers/nvidia-drivers \
		'

RUN_ARGS_VANILLA_KERNEL_LTS = \
	-e PKG='<sys-kernel/vanilla-kernel-$(KERNEL_LTS_LT)'
RUN_ARGS_VANILLA_KERNEL_LTS_BIN = \
	-e PKG='<sys-kernel/vanilla-kernel-bin-$(KERNEL_LTS_LT)'
RUN_ARGS_GENTOO_KERNEL_LTS = \
	-e PKG='<sys-kernel/gentoo-kernel-$(KERNEL_LTS_LT)'
RUN_ARGS_GENTOO_KERNEL_LTS_BIN = \
	-e PKG='<sys-kernel/gentoo-kernel-bin-$(KERNEL_LTS_LT)'


BINPKGROOT = ~/binpkg
DISTCACHE = ~/distfiles
BIN_ARGS_COMMON = \
	-v $(DISTCACHE):/var/cache/distfiles
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
build: build-amd64-vanilla-kernel-second build-x86-vanilla-kernel-second
build: build-amd64-vanilla-kernel-lts build-x86-vanilla-kernel-lts
build: build-amd64-gentoo-kernel-second build-x86-gentoo-kernel-second
build: build-amd64-gentoo-kernel-lts build-x86-gentoo-kernel-lts


gentoo-x86-stable:
	$(DOCKER) build -f Dockerfile.base \
		--build-arg BASE=gentoo/stage3:x86 -t mgorny/$@ .

gentoo-amd64-stable:
	$(DOCKER) build -f Dockerfile.base \
		--build-arg BASE=gentoo/stage3:amd64-nomultilib -t mgorny/$@ .


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


build-amd64-vanilla-kernel-newest: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-newest: build-amd64-vanilla-kernel-newest
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_NEWEST) \
		$(RUN_ARGS_KERNEL_NEWEST_AMD64) build-$@

build-x86-vanilla-kernel-newest: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-newest: build-x86-vanilla-kernel-newest
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_NEWEST) \
		$(RUN_ARGS_KERNEL_NEWEST_X86) build-$@

build-amd64-vanilla-kernel-newest-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-newest-bin: build-amd64-vanilla-kernel-newest-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_NEWEST) \
		$(RUN_ARGS_KERNEL_NEWEST_AMD64) build-$@

build-x86-vanilla-kernel-newest-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-newest-bin: build-x86-vanilla-kernel-newest-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_NEWEST) \
		$(RUN_ARGS_KERNEL_NEWEST_X86) build-$@


build-amd64-vanilla-kernel-second: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-second: build-amd64-vanilla-kernel-second
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_SECOND) \
		$(RUN_ARGS_KERNEL_SECOND_AMD64) build-$@

build-x86-vanilla-kernel-second: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-second: build-x86-vanilla-kernel-second
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_VANILLA_KERNEL_SECOND) \
		$(RUN_ARGS_KERNEL_SECOND_X86) build-$@

build-amd64-vanilla-kernel-second-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-vanilla-kernel-second-bin: build-amd64-vanilla-kernel-second-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_SECOND) \
		$(RUN_ARGS_KERNEL_SECOND_AMD64) build-$@

build-x86-vanilla-kernel-second-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-vanilla-kernel-second-bin: build-x86-vanilla-kernel-second-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_VANILLA_KERNEL_BIN_SECOND) \
		$(RUN_ARGS_KERNEL_SECOND_X86) build-$@


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


build-amd64-gentoo-kernel-newest: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-newest: build-amd64-gentoo-kernel-newest
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_NEWEST) \
		$(RUN_ARGS_KERNEL_NEWEST_AMD64) build-$@

build-x86-gentoo-kernel-newest: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-newest: build-x86-gentoo-kernel-newest
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_NEWEST) \
		$(RUN_ARGS_KERNEL_NEWEST_X86) build-$@

build-amd64-gentoo-kernel-newest-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-newest-bin: build-amd64-gentoo-kernel-newest-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_NEWEST_BIN) \
		$(RUN_ARGS_KERNEL_NEWEST_AMD64) build-$@

build-x86-gentoo-kernel-newest-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-newest-bin: build-x86-gentoo-kernel-newest-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_NEWEST_BIN) \
		$(RUN_ARGS_KERNEL_NEWEST_X86) build-$@


build-amd64-gentoo-kernel-second: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-second: build-amd64-gentoo-kernel-second
	$(DOCKER) run $(BIN_ARGS_AMD64_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_SECOND) \
		$(RUN_ARGS_KERNEL_SECOND_AMD64) build-$@

build-x86-gentoo-kernel-second: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-second: build-x86-gentoo-kernel-second
	$(DOCKER) run $(BIN_ARGS_X86_KERNEL) $(RUN_ARGS_GENTOO_KERNEL_SECOND) \
		$(RUN_ARGS_KERNEL_SECOND_X86) build-$@

build-amd64-gentoo-kernel-second-bin: build-amd64-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
amd64-gentoo-kernel-second-bin: build-amd64-gentoo-kernel-second-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_SECOND_BIN) \
		$(RUN_ARGS_KERNEL_SECOND_AMD64) build-$@

build-x86-gentoo-kernel-second-bin: build-x86-kernel-deps local.diff
	$(DOCKER) build $(BUILD_ARGS) --build-arg BASE=$< -t $@ .
x86-gentoo-kernel-second-bin: build-x86-gentoo-kernel-second-bin
	$(DOCKER) run $(BIN_ARGS_BIN) $(RUN_ARGS_GENTOO_KERNEL_SECOND_BIN) \
		$(RUN_ARGS_KERNEL_SECOND_X86) build-$@


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
