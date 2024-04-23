# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE=gst-plugins-good

inherit gstreamer-meson

DESCRIPTION="V4L2 source/sink plugin for GStreamer"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="libv4l udev"

RDEPEND="
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP}]
	libv4l? ( >=media-libs/libv4l-0.9.5[${MULTILIB_USEDEP}] )
	udev? ( >=dev-libs/libgudev-208:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	virtual/os-headers
"

GST_PLUGINS_ENABLED="v4l2"

multilib_src_configure() {
	local emesonargs=(
		-Dv4l2-gudev=$(usex udev enabled disabled)
		-Dv4l2-libv4l2=$(usex libv4l enabled disabled)
	)

	gstreamer_multilib_src_configure
}
