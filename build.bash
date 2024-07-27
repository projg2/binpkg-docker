#!/usr/bin/env bash

[[ -f localconfig.bash ]] && source localconfig.bash

die() {
	echo "${@}" >&2
	tput bel
	tput bel
	tput bel
	exit 1
}

export_vars() {
	local target=${1}
	local target_arch binpkg
	local rc=openrc
	local cflags='-mtune=generic -O2 -pipe'
	local ldflags='-Wl,-O1 -Wl,--as-needed'
	local use=

	: ${DOCKER:=docker}
	: ${BINPKGROOT=~/binpkg}
	: ${DISTCACHE=~/distfiles}
	: ${BINPKGCACHE=~/binpkg-cache}

	DOCKER_ARGS=( ${DOCKER} )
	BASE_TARGET=

	target_arch=${target#build-}
	target_arch=${target_arch%%-*}
	[[ ${target} == *-musl-* ]] && target_arch+=-musl

	case ${target} in
		build-*-kernel-deps)
			local deps='
				app-emulation/qemu
				dev-lang/python:3.13
				dev-libs/openssl
				dev-tcltk/expect
				dev-build/cmake
				net-misc/openssh
				sys-devel/bc
				sys-kernel/dracut
				sys-kernel/installkernel
				virtual/libelf
			'
			case ${target_arch} in
				amd64)
					deps+='
						sys-firmware/intel-microcode
					'
					;&
				amd64|arm64)
					deps+='
						app-crypt/sbsigntools
						app-alternatives/awk
						app-alternatives/gzip
						app-alternatives/sh
						app-arch/bzip2
						app-arch/gzip
						app-arch/lz4
						app-arch/xz-utils
						app-arch/zstd
						app-crypt/argon2
						app-crypt/gnupg
						app-crypt/p11-kit
						app-crypt/tpm2-tools
						app-crypt/tpm2-tss
						app-misc/ddcutil
						app-misc/jq
						app-shells/bash
						dev-db/sqlite
						dev-libs/cyrus-sasl
						dev-libs/expat
						dev-libs/glib
						dev-libs/hidapi
						dev-libs/icu
						dev-libs/json-c
						dev-libs/libaio
						dev-libs/libassuan
						dev-libs/libevent
						dev-libs/libffi
						dev-libs/libgcrypt
						dev-libs/libgpg-error
						dev-libs/libp11
						dev-libs/libpcre2
						dev-libs/libtasn1
						dev-libs/libunistring
						dev-libs/libusb
						dev-libs/lzo
						dev-libs/npth
						dev-libs/nss
						dev-libs/oniguruma
						dev-libs/opensc
						dev-libs/userspace-rcu
						media-libs/libmtp
						media-libs/libv4l
						net-dns/c-ares
						net-dns/libidn2
						net-fs/cifs-utils
						net-fs/nfs-utils
						net-fs/samba
						net-libs/libmnl
						net-libs/libndp
						net-libs/libtirpc
						net-libs/nghttp2
						net-misc/curl
						net-misc/dhcp
						net-misc/networkmanager
						net-nds/openldap
						net-wireless/bluez
						net-wireless/iwd
						sys-apps/acl
						sys-apps/attr
						sys-apps/baselayout
						sys-apps/coreutils
						sys-apps/dbus
						sys-apps/fwupd
						sys-apps/gawk
						sys-apps/hwdata
						sys-apps/iproute2
						sys-apps/kbd
						sys-apps/keyutils
						sys-apps/kmod
						sys-apps/less
						sys-apps/nvme-cli
						sys-apps/pcsc-lite
						sys-apps/rng-tools
						sys-apps/sed
						sys-apps/shadow
						sys-apps/systemd
						sys-apps/util-linux
						sys-auth/polkit
						sys-block/nbd
						sys-devel/gcc
						sys-fs/btrfs-progs
						sys-fs/cryptsetup
						sys-fs/dmraid
						sys-fs/dosfstools
						sys-fs/e2fsprogs
						sys-fs/lvm2
						sys-fs/mdadm
						sys-fs/multipath-tools
						sys-fs/xfsprogs
						sys-kernel/linux-firmware
						sys-libs/glibc
						sys-libs/libapparmor
						sys-libs/libcap
						sys-libs/libcap-ng
						sys-libs/libnvme
						sys-libs/libseccomp
						sys-libs/libxcrypt
						sys-libs/ncurses
						sys-libs/pam
						sys-libs/readline
						sys-libs/zlib
						sys-process/procps
					'
					;;
				x86)
					deps+='
						app-crypt/sbsigntools
					'
					;;
			esac

			# we need systemd for initramfs
			rc=systemd
			# Optimize for smaller initrd
			cflags=${cflags/-O2/-Oz -flto}
			use=lto

			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				-f Dockerfile.deps
				--build-arg DOCKER_DEPS="${deps}"
				--network host
				-t "${target}" .
			)
			;;
		build-*-*-kernel-*)
			BASE_TARGET=build-${target_arch}-kernel-deps
			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				--build-arg "BASE=${BASE_TARGET}"
				--network host
				-t "${target}" .
			)
			;;
		*-kernel-sync)
			BASE_TARGET=build-${target_arch}-kernel-deps
			DOCKER_ARGS+=(
				run
				--network host
				-v "${BINPKGCACHE}/${target_arch}:/var/cache/binpkgs"
				"${BASE_TARGET}"
			)
			;;
		*-*-kernel-*)
			BASE_TARGET=build-${target}
			local version=${target##*-}
			local pkg=${target#*-}
			pkg=${pkg%-*}
			local post_pkgs

			case ${target_arch}-${version} in
				amd64-5.4)
					post_pkgs=(
						app-emulation/virtualbox-guest-additions
						app-emulation/virtualbox-modules
						media-video/v4l2loopback
						net-firewall/rtsp-conntrack
						net-misc/AQtion
						sys-fs/vhba
						sys-fs/zfs-kmod
						sys-power/acpi_call
						sys-power/bbswitch
					)
					;;
				x86-5.4)
					post_pkgs=(
						media-video/v4l2loopback
						net-firewall/rtsp-conntrack
						sys-fs/vhba
						sys-power/bbswitch
					)
					;;
				amd64-*)
					post_pkgs=(
						sys-fs/vhba
						sys-power/acpi_call
						sys-power/bbswitch
					)
					;;
				x86-*)
					post_pkgs=(
						sys-fs/vhba
						sys-power/bbswitch
					)
					;;
			esac

			DOCKER_ARGS+=(
				run
				-e EPYTHON=python3.13
				-e PKG="<sys-kernel/${pkg}-${version}.9999"
				-e POST_PKGS="${post_pkgs[*]}"
				--network host
			)

			binpkg=kernel
			;;

		build-*-pypy-deps)
			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				-f Dockerfile.deps
				--build-arg DOCKER_DEPS='
					dev-python/pypy
					dev-python/pypy-exe-bin
					'
				--network host
				-t "${target}" .
			)
			;;
		build-*-pypy|build-*-pypy3_*)
			BASE_TARGET=build-${target_arch}-pypy-deps
			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				--build-arg "BASE=${BASE_TARGET}"
				--network host
				-t "${target}" .
			)
			;;
		*-pypy|*-pypy3_*)
			BASE_TARGET=build-${target}
			local pkg=${target##*-}

			DOCKER_ARGS+=(
				run
				-e PKG="dev-python/${pkg}-exe"
				-e POST_PKGS="dev-python/${pkg}"
				--network host
			)

			binpkg=pypy
			;;

		prune|prune-all|rsync|status)
			return
			;;

		*-prune|*-prune-all|*-rsync|*-status)
			target_arch=${target%-*}
			;;

		*)
			die "Invalid target: ${target}"
			;;
	esac

	local stage
	case ${target_arch} in
		amd64)
			stage=gentoo/stage3:amd64-nomultilib-${rc}
			cflags="-march=x86-64 ${cflags}"
			;;
		amd64-musl)
			stage=gentoo/stage3:amd64-musl
			cflags="-march=x86-64 ${cflags}"
			;;
		arm64)
			stage=gentoo/stage3:arm64-${rc}
			;;
		arm64-musl)
			stage=gentoo/stage3:arm64-musl
			;;
		ppc64le)
			stage=gentoo/stage3:ppc64le-${rc}
			cflags='-mcpu=power8 -mtune=power8 -O2 -pipe'
			;;
		ppc64le-musl)
			stage=gentoo/stage3:ppc64le-musl-hardened-openrc
			cflags='-mcpu=power8 -mtune=power8 -O2 -pipe'
			;;
		x86)
			stage=gentoo/stage3:i686-${rc}
			cflags="-march=pentium-m ${cflags}"
			;;
		x86-musl)
			stage=gentoo/stage3:i686-musl
			cflags="-march=pentium-m ${cflags}"
			;;
		*)
			die "Invalid arch: ${target_arch}"
			;;
	esac

	if [[ ${target_arch} == *-musl && ${target} == *pypy* ]]; then
		# link to libgcc statically to avoid depending on sys-devel/gcc
		# and use the same package on musl-clang stages
		cflags+=" -static-libgcc"
		ldflags+=" -static-libgcc"
	fi

	if [[ ${binpkg} ]]; then
		DOCKER_ARGS+=(
			-v "${DISTCACHE}:/var/cache/distfiles"
			-v "${BINPKGROOT}/${target_arch}/${binpkg}:/var/cache/binpkgs"
			"${BASE_TARGET}"
		)
	else
		if [[ ! ${BASE_TARGET} ]]; then
			DOCKER_ARGS+=(
				--build-arg "BASE=${stage}"
				--build-arg "CFLAGS=${cflags}"
				--build-arg "LDFLAGS=${ldflags}"
				--build-arg "USE=${use}"
			)
		fi
	fi

	local docker_arch=${target_arch%-*}
	local host_varname=DOCKER_HOST_${docker_arch^^}
	if [[ -v ${host_varname} ]]; then
		export DOCKER_HOST=${!host_varname}
	fi
}

do_rsync() {
	local arch
	for arch in amd64 arm64 ppc64le x86; do
		# to get DOCKER_HOST
		unset DOCKER_HOST
		export_vars "${arch}-rsync"
		if [[ -n ${DOCKER_HOST} ]]; then
			rsync -rv --partial --progress --checksum \
				"${DOCKER_HOST#ssh://}":binpkg/. ~/binpkg ||
				die "rsync download failed"
		fi
	done
	rsync -rv --partial --progress ~/binpkg/. --delete --checksum \
		dev.gentoo.org:public_html/binpkg/ || die "rsync upload failed"
}

do_prune() {
	local arch
	for arch in amd64 arm64 ppc64le x86; do
		# to get DOCKER_HOST
		unset DOCKER_HOST
		export_vars "${arch}-prune"
		"${DOCKER}" system prune -a -f "${@}"
		"${DOCKER}" image prune -a -f
	done
}

do_status() {
	local arch
	for arch in amd64 arm64 ppc64le x86; do
		# to get DOCKER_HOST
		unset DOCKER_HOST
		export_vars "${arch}-status"
		"${DOCKER}" container ls -a --filter=label=mgorny-binpkg-docker
	done
}

do_target() {
	local target=${1}

	case ${target} in
		rsync)
			do_rsync
			return
			;;
		prune)
			do_prune --filter=label=mgorny-binpkg-docker
			return
			;;
		prune-all)
			do_prune
			return
			;;
		status)
			do_status
			return
			;;
	esac

	export_vars "${target}"
	if [[ -n ${BASE_TARGET} && " ${TARGETS_DONE[*]} " != *" ${BASE_TARGET} "* ]]; then
		"${0}" "${BASE_TARGET}" || die "Dependency ${BASE_TARGET} failed"
		TARGETS_DONE+=( "${BASE_TARGET}" )
	fi

	echo ">>> Running ${target}"
	set -- "${DOCKER_ARGS[@]}"
	echo "${*}" >&2
	echo >&2
	"${@}" || die "${*} failed"
	tput bel
	tput bel

	TARGETS_DONE+=( "${target}" )
}

main() {
	local arg
	local TARGETS_DONE=()

	# do a quick verification first
	for arg; do
		export_vars "${arg}"
	done

	# now run them for real
	for arg; do
		do_target "${arg}"
	done
}

main "${@}"
