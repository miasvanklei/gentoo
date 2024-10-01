# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.8.4.0.9999
#hackport: flags: +network--ge-3_0_0

CABAL_HACKAGE_REVISION=2
CABAL_PN="MissingH"

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Large utility library"
HOMEPAGE="https://hackage.haskell.org/package/MissingH"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux"

RESTRICT=test # tests are present for removed modules

RDEPEND=">=dev-haskell/hslogger-1.3.0.0:=[profile?] <dev-haskell/hslogger-1.4:=[profile?]
	>=dev-haskell/mtl-1.1.1.0:=[profile?] <dev-haskell/mtl-2.3:=[profile?]
	>=dev-haskell/old-locale-1.0:=[profile?] <dev-haskell/old-locale-1.1:=[profile?]
	>=dev-haskell/old-time-1.1:=[profile?] <dev-haskell/old-time-1.2:=[profile?]
	>=dev-haskell/parsec-3.1:=[profile?] <dev-haskell/parsec-3.2:=[profile?]
	dev-haskell/random
	>=dev-haskell/regex-compat-0.95.1:=[profile?] <dev-haskell/regex-compat-0.96:=[profile?]
	>=dev-lang/ghc-7.4.1:=
	>=dev-haskell/network-3.0:=[profile?] <dev-haskell/network-3.2:=[profile?]
	>=dev-haskell/network-bsd-2.8.1:=[profile?] <dev-haskell/network-bsd-2.9:=[profile?]
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.12
	test? ( >=dev-haskell/errorcall-eq-instance-0.3 <dev-haskell/errorcall-eq-instance-0.4
		>=dev-haskell/hunit-1.6 <dev-haskell/hunit-1.7 )
"

src_configure() {
	haskell-cabal_src_configure \
		--flag=network--ge-3_0_0
}
