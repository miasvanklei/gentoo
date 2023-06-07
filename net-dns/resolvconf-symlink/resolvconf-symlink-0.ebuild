# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Make /etc/resolv.conf a symlink to a runtime-writable location"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""
S=${WORKDIR}

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+symlink"

pkg_preinst() {
	if use symlink; then
		if [[ -f ${EROOT}/etc/resolv.conf && ! -L ${EROOT}/etc/resolv.conf ]]
		then # migrate existing resolv.conf
			if [[ "$(head -n 1 "${EROOT}"/etc/resolv.conf)" \
					!= "# Generated by "* ]]; then

				eerror "${EROOT}/etc/resolv.conf seems not to be autogenerated."
				eerror "Aborting build to avoid removing user data. If that file is supposed"
				eerror "to be autogenerated, please remove it manually. Otherwise, please"
				eerror "set USE=-symlink to avoid installing resolv.conf symlink."

				die "${EROOT}/etc/resolv.conf not autogenerated"
			else
				ebegin "Moving ${EROOT}/etc/resolv.conf to ${EROOT}/var/run/"
				mv "${EROOT}"/etc/resolv.conf "${EROOT}"/var/run/
				eend ${?} || die
			fi
		fi
	fi
}

src_install() {
	# XXX: /run should be more correct, when it's supported by baselayout

	use symlink && dosym ../var/run/resolv.conf /etc/resolv.conf
}

pkg_postrm() {
	# Don't leave the user with no resolv.conf
	if [[ ! -e ${EROOT}/etc/resolv.conf && -f ${EROOT}/var/run/resolv.conf ]]
	then
		ebegin "Moving ${EROOT}/var/run/resolv.conf to ${EROOT}/etc/"
		mv "${EROOT}"/var/run/resolv.conf "${EROOT}"/etc/
		eend ${?} || die
	fi
}
