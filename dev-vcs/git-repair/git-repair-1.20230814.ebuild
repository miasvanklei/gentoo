# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.8.4.0.9999

CABAL_FEATURES=""
inherit haskell-cabal

DESCRIPTION="A tool to repair damaged git repositories"
HOMEPAGE="https://git-repair.branchable.com/"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"

GHC_BOOTSTRAP_PACKAGES=(
	async
	data-default
	filepath-bytestring
	hslogger
	IfElse
	split
	unix-compat
)

RDEPEND="
	dev-haskell/async:=
	dev-haskell/attoparsec:=
	dev-haskell/data-default:=
	>=dev-haskell/filepath-bytestring-1.4.2.1.4:=
	dev-haskell/hslogger:=
	dev-haskell/ifelse:=
	>=dev-haskell/network-2.6:=
	>=dev-haskell/network-uri-2.6:=
	>=dev-haskell/optparse-applicative-0.14.1:=
	dev-haskell/quickcheck:2=
	dev-haskell/split:=
	dev-haskell/text:=
	>=dev-haskell/unix-compat-0.5:=
	dev-haskell/utf8-string:=
	>=dev-lang/ghc-8.10.6:=
"
DEPEND="
	${RDEPEND}
	>=dev-haskell/cabal-3.2.1.0
"

src_install() {
	haskell-cabal_src_install
	doman git-repair.1
}
