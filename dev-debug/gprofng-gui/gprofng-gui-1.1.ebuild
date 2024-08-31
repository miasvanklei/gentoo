# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Full-fledged graphical interface to operate gprofng"
HOMEPAGE="https://www.gnu.org/software/gprofng-gui/"
SRC_URI="mirror://gnu/gprofng-gui/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND="
	sys-devel/binutils:*[gprofng(-)]
	>=virtual/jre-1.8:*
"

src_prepare() {
	default
	java-pkg-2_src_prepare
}
