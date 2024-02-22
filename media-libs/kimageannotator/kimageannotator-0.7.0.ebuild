# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VIRTUALX_REQUIRED="test"
inherit cmake virtualx

MY_PN=kImageAnnotator
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool for annotating images"
HOMEPAGE="https://github.com/ksnip/kImageAnnotator"
SRC_URI="https://github.com/ksnip/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="qt5 qt6 test"
REQUIRED_USE="|| ( qt5 qt6 )"

RDEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5[png]
		>=media-libs/kcolorpicker-0.3.0[qt5]
	)
	qt6? (
		dev-qt/qtbase[gui,svg,widgets]
		>=media-libs/kcolorpicker-0.3.0[qt6]
	)
	x11-libs/libX11
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	test? (
			qt5? ( dev-qt/qttest:5 )
			dev-cpp/gtest
	)
"
BDEPEND="
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttols[linguist] )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DBUILD_WITH_QT6=$(usex qt6)
	)
	cmake_src_configure
}

src_test() {
	BUILD_DIR="${BUILD_DIR}/tests" virtx cmake_src_test
}
