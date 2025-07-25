# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson optfeature toolchain-funcs xdg

DESCRIPTION="A free astronomical image processing software"
HOMEPAGE="https://siril.org/"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/free-astro/${PN}.git"
else
	SRC_URI="https://gitlab.com/free-astro/siril/-/archive/${PV/_/-}/${PN}-${PV/_/-}.tar.bz2"
	KEYWORDS="amd64 ~x86"
	S="${WORKDIR}/${PN}-${PV/_/-}"
fi

LICENSE="GPL-3+ Boost-1.0"
SLOT="0"
IUSE="curl exif ffmpeg heif jpeg libconfig openmp png raw tiff wcs"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/json-glib-1.2.6
	media-libs/librtprocess
	>=media-libs/opencv-4.4.0:=[features2d]
	sci-libs/cfitsio:=
	sci-libs/fftw:3.0=
	sci-libs/gsl:=
	x11-libs/gdk-pixbuf:2
	x11-libs/cairo
	x11-libs/pango
	>=x11-libs/gtk+-3.20.0:3
	curl? ( net-misc/curl )
	exif? ( >=media-gfx/exiv2-0.25:= )
	ffmpeg? ( media-video/ffmpeg:= )
	heif? ( media-libs/libheif:= )
	jpeg? ( media-libs/libjpeg-turbo:= )
	libconfig? ( >=dev-libs/libconfig-1.4:=[cxx] )
	png? ( >=media-libs/libpng-1.6.0:= )
	raw? ( media-libs/libraw:= )
	tiff? ( media-libs/tiff:= )
	wcs? ( >=sci-astronomy/wcslib-7.7:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="dev-build/cmake
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}/${PN}-docfiles.patch"
	"${FILESDIR}/${PN}-1.2-fseek64-musl.patch"
	"${FILESDIR}/${PN}-1.2.1-options.patch"
	"${FILESDIR}/${PN}-1.2.6-linkage.patch"
)

DOCS=( README.md NEWS ChangeLog AUTHORS )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_configure() {
	local emesonargs=(
		-Dffms2=false
		-Dcriterion=false
		$(meson_use exif exiv2)
		$(meson_use ffmpeg)
		$(meson_use heif libheif)
		$(meson_use jpeg libjpeg)
		$(meson_use libconfig)
		$(meson_use openmp)
		$(meson_use png libpng)
		$(meson_use raw libraw)
		$(meson_use tiff libtiff)
		$(meson_use wcs wcslib)
		$(usex curl -Denable-libcurl=yes -Denable-libcurl=no)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	optfeature "gnuplot support" sci-visualization/gnuplot
}
