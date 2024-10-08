# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A brainfuck interpreter"
HOMEPAGE="https://github.com/apankrat/bff"
SRC_URI="https://github.com/apankrat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~m68k ppc ppc64 ~s390 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND=""

src_compile() {
	# Makefile is not nice
	emake -f /dev/null CC="$(tc-getCC)" bff
}

src_test() {
	ebegin "Running mandelbrot test"
	./bff samples/mandelbrot.b > mandelbrot.out
	eend $? || die
	md5sum -c <<< '5024283fa65866ddd347b877798e84d8 mandelbrot.out' \
		&& cat mandelbrot.out \
		|| die "mandelbrot did not output correctly"
}

src_install() {
	dobin bff
}
