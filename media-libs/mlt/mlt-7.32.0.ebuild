# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-single-r1 cmake flag-o-matic

DESCRIPTION="Open source multimedia framework for television broadcasting"
HOMEPAGE="https://www.mltframework.org/"
SRC_URI="https://github.com/mltframework/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/7"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="debug ffmpeg frei0r gtk jack libsamplerate opencv opengl python qt6 rtaudio rubberband sdl test vdpau vidstab xine xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Needs unpackaged 'kwalify'
RESTRICT="test"

# rtaudio will use OSS on non linux OSes
# Qt already needs FFTW/PLUS so let's just always have it on to ensure
# MLT is useful: bug #603168.
DEPEND="
	>=media-libs/libebur128-1.2.2:=
	sci-libs/fftw:3.0=
	ffmpeg? ( media-video/ffmpeg:0=[vdpau?] )
	frei0r? ( media-plugins/frei0r-plugins )
	gtk? (
		media-libs/libexif
		x11-libs/pango
	)
	jack? (
		>=dev-libs/libxml2-2.5:=
		media-libs/ladspa-sdk
		virtual/jack
	)
	libsamplerate? ( >=media-libs/libsamplerate-0.1.2 )
	opencv? (
		>=media-libs/opencv-4.5.1:=[contrib]
		|| (
			media-libs/opencv[ffmpeg]
			media-libs/opencv[gstreamer]
		)
	)
	opengl? (
		media-libs/libglvnd
		media-video/movit
	)
	python? ( ${PYTHON_DEPS} )
	qt6? (
		dev-qt/qt5compat:6
		dev-qt/qtbase:6[gui,network,opengl,widgets,xml]
		dev-qt/qtsvg:6
		media-libs/libexif
		x11-libs/libX11
	)
	rtaudio? (
		>=media-libs/rtaudio-4.1.2
		kernel_linux? ( media-libs/alsa-lib )
	)
	rubberband? ( media-libs/rubberband:= )
	sdl? (
		media-libs/libsdl2[opengl,video]
		media-libs/sdl2-image
	)
	vidstab? ( media-libs/vidstab )
	xine? ( >=media-libs/xine-lib-1.1.2_pre20060328-r7 )
	xml? ( >=dev-libs/libxml2-2.5:= )
"
#	java? ( >=virtual/jre-1.8:* )
#	perl? ( dev-lang/perl )
#	php? ( dev-lang/php )
#	ruby? ( ${RUBY_DEPS} )
#	sox? ( media-sound/sox )
#	tcl? ( dev-lang/tcl:0= )
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	python? ( >=dev-lang/swig-2.0 )
"

DOCS=( AUTHORS NEWS README.md )

PATCHES=(
	# downstream
	"${FILESDIR}"/${PN}-6.10.0-swig-underlinking.patch
	"${FILESDIR}"/${PN}-6.22.1-no_lua_bdepend.patch
	"${FILESDIR}"/${PN}-7.0.1-cmake-symlink.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# Respect CFLAGS LDFLAGS when building shared libraries. Bug #308873
	if use python; then
		sed -i "/mlt.so/s/ -lmlt++ /& ${CFLAGS} ${LDFLAGS} /" src/swig/python/build || die
		python_fix_shebang src/swig/python
	fi

	cmake_src_prepare
}

src_configure() {
	# Workaround for bug #919981
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DCLANG_FORMAT=OFF
		-DGPL=ON
		-DGPL3=ON
		-DMOD_QT=OFF
		-DMOD_GLAXNIMATE=OFF
		-DMOD_KDENLIVE=ON
		-DMOD_PLUS=ON
		-DMOD_SDL1=OFF
		-DMOD_SOX=OFF
		-DMOD_SPATIALAUDIO=OFF # TODO: package libspatialaudio
		-DUSE_LV2=OFF	# TODO
		-DUSE_VST2=OFF	# TODO
		-DMOD_AVFORMAT=$(usex ffmpeg)
		-DMOD_FREI0R=$(usex frei0r)
		-DMOD_GDK=$(usex gtk)
		-DMOD_JACKRACK=$(usex jack)
		-DMOD_RESAMPLE=$(usex libsamplerate)
		-DMOD_OPENCV=$(usex opencv)
		-DMOD_MOVIT=$(usex opengl)
		-DMOD_QT6=$(usex qt6)
		-DMOD_GLAXNIMATE_QT6=$(usex qt6)
		-DMOD_RTAUDIO=$(usex rtaudio)
		-DMOD_RUBBERBAND=$(usex rubberband)
		-DMOD_SDL2=$(usex sdl)
		-DBUILD_TESTING=OFF # Needs unpackaged 'kwalify'; restricted anyway.
		-DMOD_VIDSTAB=$(usex vidstab)
		-DMOD_XINE=$(usex xine)
		-DMOD_XML=$(usex xml)
	)

	# TODO: rework upstream CMake to allow controlling MMX/SSE/SSE2
	# TODO: add swig language bindings?
	# see also https://www.mltframework.org/twiki/bin/view/MLT/ExtremeMakeover

	if use python; then
		mycmakeargs+=(
			-DSWIG_PYTHON=ON
			-DPython3_EXECUTABLE="${PYTHON}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/${PN}
	doins -r demo

	#
	# Install SWIG bindings
	#

	docinto swig

	if use python; then
		dodoc "${S}"/src/swig/python/play.py
		python_optimize
	fi
}
