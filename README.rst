====================================================
Dockerfiles for building kernel/PyPy binary packages
====================================================


Configuration
=============
Before running any builds, you may want to create ``localconfig.bash``.
This file is sourced automatically and contains environment variables
to configure the builds.  The common use is to define
``DOCKER_HOST_${ARCH}`` variables, to list hosts used for builds, e.g.::

    DOCKER_HOST_ARM64=ssh://jiji.arm.dev.gentoo.org
    DOCKER_HOST_PPC64LE=ssh://bogsucker.ppc64.dev.gentoo.org

All builds require ``local.diff`` file which is applied on top of
``gentoo.git``.  You prepare your changes, then do e.g.::

    git diff origin > ${BINPKG_DOCKER}/local.diff

This is done automatically by ``bump-kernels`` script
from mgorny-dev-scripts_.


Building kernels
================
The usual way to build kernels is to prepare the bumps and write them
into ``local.diff``, e.g. using::

    bump-kernel 6.6.{7,8} 6.1.{68,69} 5.15.{143,143} 5.10.{204,205}

Then run the following target::

    make ${ARCH}-gentoo-kernel-${VERSION}

Where ``ARCH`` is one of: ``amd64``, ``arm64``, ``ppc64le``, ``x86``,
and ``VERSION`` is two-component version, e.g.::

    make amd64-gentoo-kernel-{6.{6,1},5.{15,10}}


Building PyPy
=============
Bump the main and ``-exe`` PyPy builds, and write the changes
to ``local.diff``, e.g.::

    cd dev-python/pypy-exe
    pkgbump pypy-exe-7.3.{13,14}.ebuild
    pkgcommit --bump
    cd ../pypy
    pkgbump pypy-7.3.{13,14}.ebuild
    pkgcommit --bump
    git diff origin > ${BINPKG_DOCKER}/local.diff

Afterwards run the target::

    make ${ARCH}-pypy${SUFFIX}
    make ${ARCH}-musl-pypy${SUFFIX}

No suffix means building PyPy2.7, otherwise a suffix such as ``3_9``
or ``3_10`` is to be used (matching package name).


Transferring binary packages
============================
The ``rsync`` target is provided to copy ``~/binpkg`` tree from all
Docker hosts to the current machine, and then to your devspace::

    make rsync


Build dependency cache
======================
When building dependencies, the process automatically keeps a cache
of binary package within the image.  For this cache to be useful,
it needs to be copied to the host by running::

    make ${ARCH}-kernel-sync

Then, when running builds one needs to start a web server with
the packages::

    python -m http.server -b 127.0.0.1 -d binpkg-cache/amd64 8787


.. _mgorny-dev-scripts: https://github.com/projg2/mgorny-dev-scripts/
