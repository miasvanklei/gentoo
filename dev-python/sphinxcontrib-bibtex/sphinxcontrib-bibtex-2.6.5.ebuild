# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extensions for BibTeX style citations"
HOMEPAGE="
	https://github.com/mcmtroffaes/sphinxcontrib-bibtex/
	https://pypi.org/project/sphinxcontrib-bibtex/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.8[${PYTHON_USEDEP}]
	>=dev-python/pybtex-0.25[${PYTHON_USEDEP}]
	>=dev-python/pybtex-docutils-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-3.5[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/numpydoc[${PYTHON_USEDEP}]
		dev-python/sphinx-autoapi[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# rinoh not packaged
	test/test_citation_rinoh.py::test_citation_rinoh
	test/test_citation_rinoh.py::test_citation_rinoh_multidoc
	# TODO
	test/test_debug.py::test_debug_docutils_citation
	test/test_debug.py::test_debug_bibtex_citation
	test/test_debug.py::test_debug_minimal_example
)

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest
distutils_enable_sphinx doc

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	distutils_write_namespace sphinxcontrib
	epytest
}
