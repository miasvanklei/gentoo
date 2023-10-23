# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.8.2.0.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Converting to/from HTTP API data like URL pieces, headers and query parameters"
HOMEPAGE="https://github.com/fizruk/https-api-data"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="text-show"

RDEPEND=">=dev-haskell/attoparsec-0.13.2.2:=[profile?] <dev-haskell/attoparsec-0.15:=[profile?]
	>=dev-haskell/attoparsec-iso8601-1.1.0.0:=[profile?] <dev-haskell/attoparsec-iso8601-1.2:=[profile?]
	>=dev-haskell/base-compat-0.10.5:=[profile?] <dev-haskell/base-compat-0.14:=[profile?]
	>=dev-haskell/cookie-0.4.3:=[profile?] <dev-haskell/cookie-0.5:=[profile?]
	>=dev-haskell/hashable-1.2.7.0:=[profile?] <dev-haskell/hashable-1.5:=[profile?]
	>=dev-haskell/http-types-0.12.3:=[profile?] <dev-haskell/http-types-0.13:=[profile?]
	>=dev-haskell/tagged-0.8.5:=[profile?] <dev-haskell/tagged-0.9:=[profile?]
	>=dev-haskell/time-compat-1.9.5:=[profile?] <dev-haskell/time-compat-1.10:=[profile?]
	>=dev-haskell/unordered-containers-0.2.10.0:=[profile?] <dev-haskell/unordered-containers-0.3:=[profile?]
	>=dev-haskell/uuid-types-1.0.3:=[profile?] <dev-haskell/uuid-types-1.1:=[profile?]
	>=dev-lang/ghc-8.8.1:=
	>=dev-haskell/text-1.2.3.0:=[profile?] <dev-haskell/text-2.1:=[profile?]
	text-show? ( >=dev-haskell/text-show-3.8.2:=[profile?] <dev-haskell/text-show-3.11:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0.0
	test? ( >=dev-haskell/hspec-2.7.1 <dev-haskell/hspec-2.11
		>=dev-haskell/hunit-1.6.0.0 <dev-haskell/hunit-1.7
		>=dev-haskell/quickcheck-2.13.1 <dev-haskell/quickcheck-2.15
		>=dev-haskell/quickcheck-instances-0.3.25.2 <dev-haskell/quickcheck-instances-0.4
		dev-haskell/text )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag text-show use-text-show)
}
