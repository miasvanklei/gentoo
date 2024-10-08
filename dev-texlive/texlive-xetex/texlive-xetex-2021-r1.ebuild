# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

TEXLIVE_MODULE_CONTENTS="arabxetex awesomebox bidi-atbegshi bidicontour bidipagegrid bidishadowtext bidipresentation businesscard-qrcode cqubeamer fixlatvian font-change-xetex fontbook fontwrap interchar na-position philokalia ptext realscripts simple-resume-cv simple-thesis-dissertation tetragonos ucharclasses unicode-bidi unisugar xebaposter xechangebar xecjk xecolor xecyr xeindex xelatex-dev xesearch xespotcolor xetex xetex-itrans xetex-pstricks xetex-tibetan xetexconfig xetexfontinfo xetexko xevlna zbmath-review-template collection-xetex
"
TEXLIVE_MODULE_DOC_CONTENTS="arabxetex.doc awesomebox.doc bidi-atbegshi.doc bidicontour.doc bidipagegrid.doc bidishadowtext.doc bidipresentation.doc businesscard-qrcode.doc cqubeamer.doc fixlatvian.doc font-change-xetex.doc fontbook.doc fontwrap.doc interchar.doc na-position.doc philokalia.doc ptext.doc realscripts.doc simple-resume-cv.doc simple-thesis-dissertation.doc tetragonos.doc ucharclasses.doc unicode-bidi.doc unisugar.doc xebaposter.doc xechangebar.doc xecjk.doc xecolor.doc xecyr.doc xeindex.doc xesearch.doc xespotcolor.doc xetex.doc xetex-itrans.doc xetex-pstricks.doc xetex-tibetan.doc xetexfontinfo.doc xetexko.doc xevlna.doc zbmath-review-template.doc "
TEXLIVE_MODULE_SRC_CONTENTS="arabxetex.source fixlatvian.source fontbook.source philokalia.source realscripts.source xecjk.source xespotcolor.source "
inherit font texlive-module
DESCRIPTION="TeXLive XeTeX and packages"

LICENSE=" Apache-2.0 GPL-1 GPL-2 GPL-3 LGPL-2 LPPL-1.2 LPPL-1.3 LPPL-1.3c MIT public-domain TeX-other-free "
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2021
>=dev-texlive/texlive-basic-2019
>=dev-texlive/texlive-latexextra-2010
>=app-text/texlive-core-2010[xetex]
dev-texlive/texlive-mathscience
dev-texlive/texlive-luatex
"
RDEPEND="${DEPEND} "
FONT_CONF=( "${FILESDIR}"/09-texlive.conf )

src_install() {
	texlive-module_src_install
	font_fontconfig
}

pkg_postinst() {
	texlive-module_pkg_postinst
	font_pkg_postinst

	# Force additional run of fc-cache to populate .uuid files
	# in non-standard font dirs listed in 09-texlive.conf
	# Bug: 812401
	fc-cache -fs "${EROOT}"/usr/share/texmf-dist/fonts/opentype "${EROOT}"/usr/share/texmf-dist/fonts/truetype
}

pkg_postrm() {
	texlive-module_pkg_postrm
	font_pkg_postrm
}
