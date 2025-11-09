# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for a freedesktop.org Secret Service API provider"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="|| (
	kde-frameworks/kwallet
	gnome-base/gnome-keyring
	app-admin/keepassxc
)"
