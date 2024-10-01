# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.6.9999
#hackport: flags: with-conduit:conduit

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Data encoding library"
HOMEPAGE="https://hackage.haskell.org/package/sandi"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+conduit"

RDEPEND=">=dev-lang/ghc-7.4.1:=
	conduit? ( >=dev-haskell/conduit-1.3:=[profile?]
			dev-haskell/exceptions:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.12
	test? ( dev-haskell/tasty
		dev-haskell/tasty-hunit
		dev-haskell/tasty-quickcheck
		dev-haskell/tasty-th )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag conduit with-conduit)
}
