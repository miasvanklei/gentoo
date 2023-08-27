# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: tree-sitter-grammar.eclass
# @MAINTAINER:
# Matthew Smith <matthew@gentoo.org>
# Nick Sarnie <sarnex@gentoo.org>
# @AUTHOR:
# Matthew Smith <matthew@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: Common functions and variables for Tree Sitter grammars

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_TREE_SITTER_GRAMMAR_ECLASS} ]]; then
_TREE_SITTER_GRAMMAR_ECLASS=1

inherit edo multilib toolchain-funcs

SRC_URI="https://github.com/tree-sitter/${PN}/archive/${TS_PV:-v${PV}}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${TS_PV:-${PV}}/src

BDEPEND+=" test? ( dev-util/tree-sitter-cli )"
IUSE+=" test"
RESTRICT+=" !test? ( test )"

# @ECLASS_VARIABLE: TS_PV
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used to override upstream tag name if tagged differently, e.g. most releases
# are v${PV} but some are tagged as rust-${PV}.

# @FUNCTION: _get_tsg_abi_ver
# @INTERNAL
# @DESCRIPTION:
# This internal function determines the ABI version of a grammar library based
# on a constant in the source file.
_get_tsg_abi_ver() {
	# This sed script finds ABI definition string in parser source file,
	# substitutes all the string until the ABI number, and prints remains
	# (the ABI number itself)
	sed -n 's/#define LANGUAGE_VERSION //p' "${S}"/parser.c ||
		die "Unable to extract ABI version for this grammar"
}

# @FUNCTION: tree-sitter-grammar_src_compile
# @DESCRIPTION:
# Compiles the Tree Sitter parser as a shared library.
tree-sitter-grammar_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	# Grammars always contain parser.c, and sometimes a scanner.c,
	# or scanner.cc.

	tc-export CC CXX
	# We want to use the bundled parser.h, not anything lurking on the system, hence -I
	# See https://github.com/tree-sitter/tree-sitter-bash/issues/199#issuecomment-1694416505
	export CFLAGS="${CFLAGS} -fPIC -I. -Itree_sitter"
	export CXXFLAGS="${CXXFLAGS} -fPIC -I. -Itree_sitter"

	local objects=( parser.o )
	if [[ -f "${S}"/scanner.c || -f "${S}"/scanner.cc ]]; then
		objects+=( scanner.o )
	fi
	emake "${objects[@]}"

	local link="$(tc-getCC) ${CFLAGS}"
	if [[ -f "${S}/scanner.cc" ]]; then
		link="$(tc-getCXX) ${CXXFLAGS}"
	fi

	local soname=lib${PN}$(get_libname $(_get_tsg_abi_ver))

	local soname_args="-Wl,--soname=${soname}"
	if [[ ${CHOST} == *darwin* ]] ; then
		soname_args="-Wl,-install_name,${EPREFIX}/usr/$(get_libdir)/${soname}"
	fi

	edo ${link} ${LDFLAGS} \
			-shared \
			*.o \
			${soname_args} \
			-o "${WORKDIR}"/${soname}
}

# @FUNCTION: tree-sitter-grammar_src_test
# @DESCRIPTION:
# Runs the Tree Sitter parser's test suite.
# See: https://tree-sitter.github.io/tree-sitter/creating-parsers#command-test
tree-sitter-grammar_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	(cd .. && tree-sitter test) || die "Test suite failed"
}

# @FUNCTION: tree-sitter-grammar_src_install
# @DESCRIPTION:
# Installs the Tree Sitter parser library.
tree-sitter-grammar_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	local soname=lib${PN}$(get_libname $(_get_tsg_abi_ver))

	dolib.so "${WORKDIR}/${soname}"
	dosym "${soname}" \
		  /usr/$(get_libdir)/lib${PN}$(get_libname)
}

fi

EXPORT_FUNCTIONS src_compile src_test src_install
