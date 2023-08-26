ARG BASE

FROM ${BASE}

CMD cp -a /var/cache/binpkgs /tmp/binpkg \
 && FEATURES=test \
 MODULES_SIGN_KEY="/tmp/signing_key.pem" \
 SECUREBOOT_SIGN_KEY="/tmp/signing_key.pem" \
 SECUREBOOT_SIGN_CERT="/tmp/signing_key.pem" emerge -1vB ${PKG} \
 && emerge -1vk ${PKG} \
 && rsync -av --checksum /tmp/binpkg/. /var/cache/binpkgs/ \
 && { [[ -z ${POST_PKGS} ]] || emerge -1vt --keep-going=y --jobs ${POST_PKGS}; }

COPY local.diff /
RUN patch -p1 -d /var/db/repos/gentoo < /local.diff \
 && rm /local.diff
