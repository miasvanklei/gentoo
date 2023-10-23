# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.8.4.0.9999
#hackport: flags: +allow-sendfilefd,-network-bytestring,warp-debug:debug

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="A fast, light-weight web server for WAI applications"
HOMEPAGE="https://github.com/yesodweb/wai"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="debug +x509"

RDEPEND=">=dev-haskell/auto-update-0.1.3:=[profile?] <dev-haskell/auto-update-0.2:=[profile?]
	<dev-haskell/bsb-http-chunked-0.1:=[profile?]
	>=dev-haskell/case-insensitive-0.2:=[profile?]
	dev-haskell/hashable:=[profile?]
	dev-haskell/http-date:=[profile?]
	>=dev-haskell/http-types-0.12:=[profile?]
	>=dev-haskell/http2-3.0:=[profile?] <dev-haskell/http2-5:=[profile?]
	>=dev-haskell/iproute-1.3.1:=[profile?]
	>=dev-haskell/network-2.3:=[profile?]
	>=dev-haskell/recv-0.1.0:=[profile?] <dev-haskell/recv-0.2.0:=[profile?]
	>=dev-haskell/simple-sendfile-0.2.7:=[profile?] <dev-haskell/simple-sendfile-0.3:=[profile?]
	>=dev-haskell/streaming-commons-0.1.10:=[profile?]
	dev-haskell/text:=[profile?]
	dev-haskell/time-manager:=[profile?]
	dev-haskell/unliftio:=[profile?]
	>=dev-haskell/vault-0.3:=[profile?]
	>=dev-haskell/wai-3.2:=[profile?] <dev-haskell/wai-3.3:=[profile?]
	dev-haskell/word8:=[profile?]
	>=dev-lang/ghc-8.8.1:=
	x509? ( dev-haskell/crypton-x509:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-3.0.0.0
	test? ( >=dev-haskell/hspec-1.3
		dev-haskell/http-client
		dev-haskell/quickcheck )
"

src_configure() {
	haskell-cabal_src_configure \
		--flag=allow-sendfilefd \
		--flag=-network-bytestring \
		$(cabal_flag debug warp-debug) \
		$(cabal_flag x509 x509)
}
