DOCKER ?= docker
BINPKGROOT = ~/binpkg

build: build-amd64-pypy build-x86-pypy build-amd64-kernel

build-amd64-pypy: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=amd64 \
		--build-arg BASE=mgorny/gentoo-python \
		--build-arg PKG=dev-python/pypy-exe \
		--build-arg CFLAGS='-march=x86-64 -mtune=generic -O2 -pipe' \
		-t $@ .

amd64-pypy: build-amd64-pypy
	$(DOCKER) run -v $(BINPKGROOT)/amd64/pypy:/var/cache/binpkgs build-$@

build-amd64-pypy3: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=amd64 \
		--build-arg BASE=mgorny/gentoo-python \
		--build-arg PKG=dev-python/pypy3-exe \
		--build-arg DEPS='<virtual/pypy-7.3' \
		--build-arg CFLAGS='-march=x86-64 -mtune=generic -O2 -pipe' \
		-t $@ .

amd64-pypy3: build-amd64-pypy3
	$(DOCKER) run -v $(BINPKGROOT)/amd64/pypy:/var/cache/binpkgs build-$@

build-x86-pypy: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=x86 \
		--build-arg BASE=gentoo/stage3-x86 \
		--build-arg PKG=dev-python/pypy-exe \
		--build-arg DEPS='<dev-python/pypy-bin-7.3' \
		--build-arg CFLAGS='-march=pentium-m -mtune=generic -O2 -pipe' \
		--build-arg USE=cpu_flags_x86_sse2 \
		-t $@ .

x86-pypy: build-x86-pypy
	$(DOCKER) run -v $(BINPKGROOT)/x86/pypy:/var/cache/binpkgs build-$@

build-x86-pypy3: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=x86 \
		--build-arg BASE=gentoo/stage3-x86 \
		--build-arg PKG=dev-python/pypy3-exe \
		--build-arg DEPS='<virtual/pypy-7.3 <dev-python/pypy-bin-7.3' \
		--build-arg CFLAGS='-march=pentium-m -mtune=generic -O2 -pipe' \
		--build-arg USE=cpu_flags_x86_sse2 \
		-t $@ .

x86-pypy3: build-x86-pypy3
	$(DOCKER) run -v $(BINPKGROOT)/x86/pypy:/var/cache/binpkgs build-$@

build-amd64-vanilla-kernel: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=amd64 \
		--build-arg BASE=gentoo/stage3-amd64-nomultilib \
		--build-arg PKG=sys-kernel/vanilla-kernel \
		--build-arg DEPS='virtual/libelf sys-devel/bc' \
		--build-arg CFLAGS='-march=x86-64 -mtune=generic -O2 -pipe' \
		-t $@ .

amd64-vanilla-kernel: build-amd64-vanilla-kernel
	$(DOCKER) run -v $(BINPKGROOT)/amd64/kernel:/var/cache/binpkgs build-$@
