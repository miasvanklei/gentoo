# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Tiny library for parsing, modifying, and composing SRT files"
HOMEPAGE="
	https://github.com/cdown/srt
	https://pypi.org/project/srt/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

RDEPEND="!dev-python/pysrt"
BDEPEND="
	test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )
"

EPYTEST_XDIST=1
distutils_enable_tests pytest
