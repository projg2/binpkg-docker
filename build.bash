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

	local -A kernel_versions=(
		# this is for <, so +1
		[newest]=5.16
		[lts]=5.11
		[lts2]=5.5
	)

	DOCKER_ARGS=( ${DOCKER} )
	BASE_TARGET=

	case ${target} in
		build-*-kernel-deps)
			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				-f Dockerfile.deps
				--build-arg DEPS='
					virtual/libelf
					sys-devel/bc
					=app-emulation/qemu-6.2.0
					dev-tcltk/expect
					sys-kernel/dracut
					net-misc/openssh
					dev-util/pahole
					dev-lang/python:3.10
					'
				-t "${target}" .
			)
			target_arch=${target#build-}
			target_arch=${target_arch%%-*}
			;;
		build-*-*-kernel-*)
			target_arch=${target#build-}
			target_arch=${target_arch%%-*}
			BASE_TARGET=build-${target_arch}-kernel-deps
			DOCKER_ARGS+=(
				build
				--label=mgorny-binpkg-docker
				--build-arg "BASE=${BASE_TARGET}"
				-t "${target}" .
			)
			;;
		*-*-kernel-*)
			BASE_TARGET=build-${target}
			target_arch=${target%%-*}
			local version=${target##*-}
			local pkg=${target#*-}
			pkg=${pkg%-*}
			local post_pkgs

			case ${target_arch}-${version} in
				amd64-lts2)
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
				x86-lts2)
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
				-e EPYTHON=python3.10
				-e PKG="<sys-kernel/${pkg}-${kernel_versions[${version}]}"
				-e POST_PKGS="${post_pkgs[*]}"
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
				-t "${target}" .
			)
			target_arch=${target#build-}
			target_arch=${target_arch%%-*}
			;;
		build-*-pypy|build-*-pypy3)
			target_arch=${target#build-}
			target_arch=${target_arch%%-*}
			BASE_TARGET=build-${target_arch}-pypy-deps
			DOCKER_ARGS+=(
				build
				--build-arg "BASE=${BASE_TARGET}"
				-t "${target}" .
			)
			;;
		*-pypy|*-pypy3)
			BASE_TARGET=build-${target}
			target_arch=${target%%-*}
			local pkg=${target##*-}

			DOCKER_ARGS+=(
				run
				-e PKG="dev-python/${pkg}-exe"
				-e POST_PKGS="dev-python/${pkg}"
			)

			binpkg=kernel
			;;

		prune)
			return
			;;

		*-prune)
			target_arch=${target%%-*}
			;;

		*)
			die "Invalid target: ${target}"
			;;
	esac

	local stage=gentoo/stage3:${target_arch}
	local cflags='-mtune=generic -O2 -pipe'
	case ${target_arch} in
		amd64)
			stage=gentoo/stage3:amd64-nomultilib-openrc
			cflags="-march=x86-64 ${flags}"
			;;
		arm64)
			;;
		ppc64le)
			stage=gentoo/stage3:${target_arch}-openrc
			cflags='-mcpu=power8 -mtune=power8 -O2 -pipe'
			;;
		x86)
			cflags="-march=pentium-m ${flags}"
			;;
		*)
			die "Invalid arch: ${target_arch}"
			;;
	esac

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
			)
		fi
	fi

	local host_varname=DOCKER_HOST_${target_arch^^}
	if [[ -v ${host_varname} ]]; then
		export DOCKER_HOST=${!host_varname}
	fi
}

do_prune() {
	local arch
	for arch in amd64 arm64 ppc64le x86; do
		# to get DOCKER_HOST
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
