DOCKER ?= docker
BINPKGROOT = ~/binpkg

all:
	:

amd64-pypy: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=amd64 \
		--build-arg BASE=mgorny/gentoo-python \
		--build-arg PKG=dev-python/pypy-exe \
		-t build-$@ .
	$(DOCKER) run -v $(BINPKGROOT)/$(subst -,/,$@):/var/cache/binpkgs build-$@

amd64-vanilla-kernel: local.diff
	$(DOCKER) build --pull \
		--build-arg ARCH=amd64 \
		--build-arg BASE=gentoo/stage3-amd64-nomultilib \
		--build-arg PKG=sys-kernel/vanilla-kernel \
		--build-arg DEPS='virtual/libelf sys-devel/bc' \
		-t build-$@ .
	$(DOCKER) run -v $(BINPKGROOT)/$(subst -,/,$@):/var/cache/binpkgs build-$@
