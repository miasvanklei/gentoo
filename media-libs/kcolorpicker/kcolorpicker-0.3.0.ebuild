# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIRTUALX_REQUIRED="test"
inherit cmake virtualx

MY_PN=kColorPicker
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Qt based color picker with popup menu"
HOMEPAGE="https://github.com/ksnip/kColorPicker"
SRC_URI="https://github.com/ksnip/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"
IUSE="qt5 qt6 test"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5[png]
	)
	qt6? (
		dev-qt/qtbase[gui,widgets]
	)
"
DEPEND="${RDEPEND}
	test? ( qt5? ( dev-qt/qttest:5 ) )
"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DBUILD_WITH_QT6=$(usex qt6)
	)
	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
