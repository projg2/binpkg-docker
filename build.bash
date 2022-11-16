#!/usr/bin/env bash

[[ -f localconfig.bash ]] && source localconfig.bash

die() {
	echo "${@}" >&2
	exit 1
}

export_vars() {
	local target=${1}
	local target_arch binpkg

	: ${DOCKER:=docker}
	: ${BINPKGROOT=~/binpkg}
	: ${DISTCACHE=~/distfiles}

	DOCKER_ARGS=( ${DOCKER} )
	BASE_TARGET=

	target_arch=${target#build-}
	target_arch=${target_arch%%-*}
	[[ ${target} == *-musl-* ]] && target_arch+=-musl

	case ${target} in
		build-*-kernel-deps)
			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				-f Dockerfile.deps
				--build-arg DEPS='
					virtual/libelf
					sys-devel/bc
					app-emulation/qemu
					dev-tcltk/expect
					sys-kernel/dracut
					net-misc/openssh
					dev-lang/python:3.11
					'
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
						app-laptop/tp_smapi
						dev-util/sysdig-kmod
						media-video/v4l2loopback
						net-dialup/accel-ppp
						net-firewall/rtsp-conntrack
						net-misc/AQtion
						net-wireless/broadcom-sta
						sys-fs/vhba
						sys-fs/zfs-kmod
						sys-power/acpi_call
						sys-power/bbswitch
						x11-drivers/nvidia-drivers
					)
					;;
				x86-5.4)
					post_pkgs=(
						app-laptop/tp_smapi
						media-video/v4l2loopback
						net-dialup/accel-ppp
						net-firewall/rtsp-conntrack
						net-wireless/broadcom-sta
						sys-fs/vhba
						sys-power/bbswitch
					)
					;;
				amd64-*)
					post_pkgs=(
						app-laptop/tp_smapi
						net-dialup/accel-ppp
						net-firewall/rtsp-conntrack
						sys-fs/vhba
						sys-power/acpi_call
						sys-power/bbswitch
					)
					;;
				x86-*)
					post_pkgs=(
						app-laptop/tp_smapi
						net-dialup/accel-ppp
						net-firewall/rtsp-conntrack
						sys-fs/vhba
						sys-power/bbswitch
					)
					;;
			esac

			DOCKER_ARGS+=(
				run
				-e EPYTHON=python3.11
				-e PKG="<sys-kernel/${pkg}-${version}.9999"
				-e POST_PKGS="${post_pkgs[*]}"
				--network host
			)

			binpkg=kernel
			;;

		build-*-pypy-deps)
			DOCKER_ARGS+=(
				build
				-f Dockerfile.deps
				--build-arg DEPS='
					dev-python/pypy
					dev-python/pypy-exe-bin
					'
				--network host
				-t "${target}" .
			)
			;;
		build-*-pypy|build-*-pypy3)
			BASE_TARGET=build-${target_arch}-pypy-deps
			DOCKER_ARGS+=(
				build
				--build-arg "BASE=${BASE_TARGET}"
				--network host
				-t "${target}" .
			)
			;;
		*-pypy|*-pypy3)
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

		prune)
			return
			;;

		*-prune)
			target_arch=${target%-prune}
			;;

		*)
			die "Invalid target: ${target}"
			;;
	esac

	local cflags='-mtune=generic -O2 -pipe'
	local ldflags='-Wl,-O1 -Wl,--as-needed'
	local stage
	case ${target_arch} in
		amd64)
			stage=gentoo/stage3:amd64-nomultilib-openrc
			cflags="-march=x86-64 ${flags}"
			;;
		amd64-musl)
			stage=gentoo/stage3:amd64-musl
			cflags="-march=x86-64 ${flags}"
			;;
		arm64)
			stage=gentoo/stage3:arm64-openrc
			;;
		arm64-musl)
			stage=gentoo/stage3:arm64-musl
			;;
		ppc64le)
			stage=gentoo/stage3:ppc64le-openrc
			cflags='-mcpu=power8 -mtune=power8 -O2 -pipe'
			;;
		ppc64le-musl)
			stage=gentoo/stage3:ppc64le-musl-hardened-openrc
			cflags='-mcpu=power8 -mtune=power8 -O2 -pipe'
			;;
		x86)
			stage=gentoo/stage3:i686-openrc
			cflags="-march=pentium-m ${flags}"
			;;
		x86-musl)
			stage=gentoo/stage3:i686-musl
			cflags="-march=pentium-m ${flags}"
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
			)
		fi
	fi

	local docker_arch=${target_arch%-*}
	local host_varname=DOCKER_HOST_${docker_arch^^}
	if [[ -v ${host_varname} ]]; then
		export DOCKER_HOST=${!host_varname}
	fi
}

do_prune() {
	local arch
	for arch in amd64 arm64 ppc64le x86; do
		# to get DOCKER_HOST
		unset DOCKER_HOST
		export_vars "${arch}-prune"
		"${DOCKER}" system prune -a -f --filter=label=mgorny-binpkg-docker
		"${DOCKER}" image prune -a -f
	done
}

do_target() {
	local target=${1}

	case ${target} in
		prune)
			do_prune
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
