ARG BASE

FROM ${BASE}

RUN wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz \
 && mv gentoo-master /var/db/repos/gentoo

ARG ARCH
ARG PKG
ARG DEPS

VOLUME /var/cache/binpkgs
ENV PKG=${PKG}
CMD emerge -1vB ${PKG}

COPY local.diff /
RUN patch -p1 -d /var/db/repos/gentoo < /local.diff \
 && rm /local.diff \
 && echo ${PKG} '~'${ARCH} >> /etc/portage/package.accept_keywords \
 && printf '\nBINPKG_COMPRESS="xz"\nBINPKG_COMPRESS_FLAGS="-9"\nFEATURES="${FEATURES} -sandbox binpkg-multi-instance -binpkg-docompress -binpkg-dostrip"\n' >> /etc/portage/make.conf \
 && { [[ -z ${DEPS} ]] || emerge -1v --jobs ${DEPS}; }
