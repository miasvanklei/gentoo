# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( pypy3 pypy3_11 python3_{10..13} python3_13t )

inherit distutils-r1

DESCRIPTION="A backend script to aid installing Python packages in Gentoo"
HOMEPAGE="
	https://pypi.org/project/gpep517/
	https://github.com/projg2/gpep517/
"
SRC_URI="
	https://github.com/projg2/gpep517/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-python/installer-0.5.0[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.2.3[${PYTHON_USEDEP}]
	' 3.10)
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -o tmp_path_retention_policy=all
}

python_install() {
	python_domodule gpep517
	python_newscript - gpep517 <<-EOF
		#!${EPREFIX}/usr/bin/python
		import sys
		from gpep517.__main__ import main
		sys.exit(main())
	EOF
}
