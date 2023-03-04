# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Some additional tests are run if Python is found
PYTHON_COMPAT=( python3_{9..11} )
inherit cmake python-any-r1

DESCRIPTION="BLAS,CBLAS,LAPACK,LAPACKE reference implementations"
HOMEPAGE="https://www.netlib.org/lapack/"
SRC_URI="https://github.com/Reference-LAPACK/lapack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
# TODO: static-libs 64bit-index
IUSE="lapacke deprecated doc eselect-ldso test"
RESTRICT="!test? ( test )"

RDEPEND="
	!app-eselect/eselect-cblas
	virtual/fortran
	eselect-ldso? (
		>=app-eselect/eselect-blas-0.2
		>=app-eselect/eselect-lapack-0.2
	)
	doc? ( app-doc/blas-docs )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCBLAS=ON
		-DLAPACKE=$(usex lapacke)
		-DBUILD_DEPRECATED=$(usex deprecated)
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	use eselect-ldso || return
	# Create private lib directory for eselect::blas (ld.so.conf)
	dodir /usr/$(get_libdir)/blas/reference
	dosym ../../libblas.so usr/$(get_libdir)/blas/reference/libblas.so
	dosym ../../libblas.so.3 usr/$(get_libdir)/blas/reference/libblas.so.3
	dosym ../../libcblas.so usr/$(get_libdir)/blas/reference/libcblas.so
	dosym ../../libcblas.so.3 usr/$(get_libdir)/blas/reference/libcblas.so.3

	# Create private lib directory for eselect::lapack (ld.so.conf)
	dodir /usr/$(get_libdir)/lapack/reference
	dosym ../../liblapack.so usr/$(get_libdir)/lapack/reference/liblapack.so
	dosym ../../liblapack.so.3 usr/$(get_libdir)/lapack/reference/liblapack.so.3
}

pkg_postinst() {
	use eselect-ldso || return

	local me=reference libdir=$(get_libdir)
	# check eselect-blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == ${me} || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi

	# check eselect-lapack
	eselect lapack add ${libdir} "${EROOT}"/usr/${libdir}/lapack/${me} ${me}
	local current_lapack=$(eselect lapack show ${libdir} | cut -d' ' -f2)
	if [[ ${current_lapack} == ${me} || -z ${current_lapack} ]]; then
		eselect lapack set ${libdir} ${me}
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
		elog "To use lapack [${me}] implementation, you have to issue (as root):"
		elog "\t eselect lapack set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso || return

	eselect blas validate
	eselect lapack validate
}
