# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DRI=always
inherit xorg-3

DESCRIPTION="VMware SVGA video driver"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	kernel_linux? (
		>=x11-libs/libdrm-2.4.96[video_cards_vmware]
		media-libs/mesa[xa]
	)"
DEPEND="${RDEPEND}"
