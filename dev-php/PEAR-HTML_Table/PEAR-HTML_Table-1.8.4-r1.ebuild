# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Makes the design of HTML tables easy, flexible, reusable and efficient"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( >=dev-php/PEAR-PEAR-1.5.0
	>=dev-php/PEAR-HTML_Common-1.2.3 )"
RDEPEND=">=dev-php/PEAR-HTML_Common-1.2.3"
HTML_DOCS=( docs/Table_example1.php docs/Table_example2.php )

src_test() {
	peardev run-tests -r || die
}
