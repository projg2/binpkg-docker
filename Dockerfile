ARG BASE

FROM ${BASE}

RUN wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz \
 && mv gentoo-master /var/db/repos/gentoo

ARG ARCH
ARG PKG
ARG DEPS
ARG CFLAGS
ARG POST_PKGS

VOLUME /var/cache/binpkgs
ENV PKG=${PKG}
ENV POST_PKGS=${POST_PKGS}
CMD FEATURES=test emerge -1vB ${PKG} \
 && emerge -1vk ${PKG} \
 && { [[ -z ${POST_PKGS} ]] || emerge -1vt --keep-going=y --jobs ${POST_PKGS}; }

COPY local.diff /
COPY package.accept_keywords /etc/portage
COPY package.use /etc/portage/package.use/local
RUN patch -p1 -d /var/db/repos/gentoo < /local.diff \
 && rm /local.diff \
 && printf '\nCFLAGS="%s"\nCXXFLAGS="%s"\nBINPKG_COMPRESS="xz"\nBINPKG_COMPRESS_FLAGS="-9"\nFEATURES="${FEATURES} -sandbox -usersandbox -cgroup binpkg-multi-instance -binpkg-docompress -binpkg-dostrip"\nACCEPT_LICENSE="*"\n' "${CFLAGS}" "${CFLAGS}" >> /etc/portage/make.conf \
 && { [[ -z ${DEPS} ]] || emerge -1vt --jobs ${DEPS}; } \
 && cat /etc/portage/make.conf \
 && emerge -1vBp ${PKG}
