# syntax=docker/dockerfile:1.3

ARG BASE

FROM ${BASE}

CMD --mount=type=tmpfs,target=/var/tmp/portage \
 cp -a /var/cache/binpkgs /tmp/binpkg \
 && FEATURES=test emerge -1vB ${PKG} \
 && emerge -1vk ${PKG} \
 && { [[ -z ${POST_PKGS} ]] || emerge -1vt --keep-going=y --jobs ${POST_PKGS}; } \
 && rsync -av --checksum /tmp/binpkg/. /var/cache/binpkgs/

COPY local.diff /
RUN patch -p1 -d /var/db/repos/gentoo < /local.diff \
 && rm /local.diff
