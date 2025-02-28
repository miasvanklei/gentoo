# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Universal framework for cross-platform visualization applications"
HOMEPAGE="https://gr-framework.org/"
SRC_URI="https://github.com/sciapp/gr/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="agg cairo ffmpeg opengl postscript qt6 tiff truetype X"

DEPEND="
	media-libs/fontconfig
	media-libs/glfw
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/qhull:=
	net-libs/zeromq
	sys-libs/zlib
	virtual/opengl
	X? (
		x11-libs/libX11
		x11-libs/libXt
	)
	agg? ( x11-libs/agg )
	cairo? ( x11-libs/cairo )
	ffmpeg? ( media-video/ffmpeg:= )
	opengl? ( virtual/opengl[X] )
	postscript? ( app-text/ghostscript-gpl )
	qt6? ( dev-qt/qtgui:= )
	tiff? ( media-libs/tiff:= )
	truetype? ( media-libs/freetype )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.73.6-musl.patch"
	"${FILESDIR}/only-find-libraries-when-requested.patch"
	"${FILESDIR}/fix-fonts-path.patch"
)

REQUIRED_USE="cairo? ( truetype )"

src_configure() {
	if use agg ; then
		mycmakeargs+=( -DAGG_LIBRARY=/usr/$(get_libdir)/libagg.so -DAGG_INCLUDE_DIR=/usr/include/agg2 )
	else
		mycmakeargs+=( -DAGG_LIBRARY= )
	fi

	use cairo || mycmakeargs+=( -DCAIRO_LIBRARY= )
	use postscript || mycmakeargs+=( -DGS_LIBRARY= )
	use ffmpeg || mycmakeargs+=( -DFFMPEG_INCLUDE_DIR= )
	use opengl && mycmakeargs+=( -DWITH_OPENGL= )
	use qt6 && mycmakeargs+=( -DWITH_QT6= )
	use truetype || mycmakeargs+=( -DFREETYPE_LIBRARY= )
	use tiff || mycmakeargs+=( -DTIFF_LIBRARY= )
	use X && mycmakeargs+=( -DWITH_X11= )

	cmake_src_configure
}

src_install() {
	cmake_src_install

	find "${ED}" -name '*.a' -delete
}
