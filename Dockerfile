ARG BASE

FROM ${BASE}

RUN wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz \
 && mv gentoo-master /var/db/repos/gentoo

ARG ARCH
ARG PKG
ARG DEPS
ARG CFLAGS
ARG USE

VOLUME /var/cache/binpkgs
ENV PKG=${PKG}
CMD FEATURES=test emerge -1vB ${PKG}

COPY local.diff /
RUN patch -p1 -d /var/db/repos/gentoo < /local.diff \
 && rm /local.diff \
 && echo ${PKG} '~'${ARCH} >> /etc/portage/package.accept_keywords \
 && { [[ -z ${USE} ]] || echo ${PKG} ${USE} >> /etc/portage/package.use/local; } \
 && printf '\nCFLAGS="%s"\nCXXFLAGS="%s"\nBINPKG_COMPRESS="xz"\nBINPKG_COMPRESS_FLAGS="-9"\nFEATURES="${FEATURES} -sandbox -usersandbox -cgroup binpkg-multi-instance -binpkg-docompress -binpkg-dostrip"\n' "${CFLAGS}" "${CFLAGS}" >> /etc/portage/make.conf \
 && { [[ -z ${DEPS} ]] || emerge -1v --jobs ${DEPS}; } \
 && cat /etc/portage/make.conf \
 && emerge -1vBp ${PKG}
