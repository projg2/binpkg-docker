ARG BASE

FROM ${BASE}

CMD cp -a /var/cache/binpkgs /tmp/binpkg \
 && FEATURES=test emerge -1vB ${PKG} \
 && emerge -1vk ${PKG} \
 && rsync -av --checksum /tmp/binpkg/. /var/cache/binpkgs/ \
 && { [[ -z ${POST_PKGS} ]] || emerge -1vt --keep-going=y --jobs ${POST_PKGS}; }

COPY signing_key.pem /tmp/signing_key.pem
COPY kernel-configd /etc/kernel/config.d/local.config
COPY local.diff /
RUN patch -p1 -d /var/db/repos/gentoo < /local.diff \
 && rm /local.diff
