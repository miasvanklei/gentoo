# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.1

EAPI=8

RESTRICT="test" # fails with sandbox

CRATES="
	aho-corasick@1.1.2
	anes@0.1.6
	anstyle@1.0.6
	anyhow@1.0.79
	argv@0.1.11
	autocfg@1.1.0
	bitflags@1.3.2
	bitflags@2.4.2
	bstr@1.9.0
	byteorder@1.5.0
	cast@0.3.0
	cfg-if@1.0.0
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.0
	clap_builder@4.5.0
	clap_lex@0.7.0
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-channel@0.5.11
	crossbeam-utils@0.8.19
	crunchy@0.2.2
	either@1.10.0
	env_filter@0.1.0
	env_logger@0.11.1
	errno@0.3.8
	fastrand@2.0.1
	futures-channel@0.3.30
	futures-core@0.3.30
	futures-executor@0.3.30
	futures-task@0.3.30
	futures-util@0.3.30
	getargs@0.5.0
	globset@0.4.14
	half@2.3.1
	heck@0.4.1
	hermit-abi@0.3.5
	hex@0.4.3
	io-lifetimes@1.0.11
	io-uring@0.6.3
	ipnetwork@0.20.0
	is-terminal@0.4.12
	itertools@0.10.5
	itoa@1.0.10
	lazy_static@1.4.0
	libc@0.2.153
	libseccomp-sys@0.2.1
	libseccomp@0.3.0
	linux-raw-sys@0.1.4
	linux-raw-sys@0.4.13
	lock_api@0.4.11
	log@0.4.20
	memchr@2.7.1
	memoffset@0.7.1
	nix@0.26.4
	nonempty@0.9.0
	num-traits@0.2.18
	num_cpus@1.16.0
	once_cell@1.19.0
	oorandom@11.1.3
	openat2@0.1.2
	parking_lot@0.12.1
	parking_lot_core@0.9.9
	parse-size@1.0.0
	pin-project-lite@0.2.13
	pin-utils@0.1.0
	pkg-config@0.3.29
	proc-macro2@1.0.78
	procfs@0.15.1
	quote@1.0.35
	redox_syscall@0.4.1
	regex-automata@0.4.5
	regex-syntax@0.8.2
	regex@1.10.3
	rustix@0.36.17
	rustix@0.38.31
	rustversion@1.0.14
	rusty_pool@0.7.0
	ryu@1.0.16
	same-file@1.0.6
	scopeguard@1.2.0
	sendfd@0.4.3
	serde@1.0.196
	serde_derive@1.0.196
	serde_json@1.0.113
	slab@0.4.9
	smallvec@1.13.1
	strum@0.26.1
	strum_macros@0.26.1
	syn@2.0.48
	tempfile@3.10.0
	tinytemplate@1.2.1
	unicode-ident@1.0.12
	walkdir@2.4.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.45.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-targets@0.42.2
	windows-targets@0.48.5
	windows-targets@0.52.0
	windows_aarch64_gnullvm@0.42.2
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.0
	windows_aarch64_msvc@0.42.2
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.0
	windows_i686_gnu@0.42.2
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.0
	windows_i686_msvc@0.42.2
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.0
	windows_x86_64_gnu@0.42.2
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.0
	windows_x86_64_gnullvm@0.42.2
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.0
	windows_x86_64_msvc@0.42.2
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.0
"

inherit cargo

DESCRIPTION="seccomp and landlock based application sandbox with support for namespaces"
HOMEPAGE="https://sydbox.exherbolinux.org"
SRC_URI="https://git.sr.ht/~alip/syd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

IUSE="+static"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="static? ( sys-libs/libseccomp[static-libs] )
	sys-libs/libseccomp"
RDEPEND="${DEPEND}"

S="${WORKDIR}/syd-v${PV}"

src_compile() {
	if use static; then
		export LIBSECCOMP_LINK_TYPE="static"
		export LIBSECCOMP_LIB_PATH=$(pkgconf --variable=libdir libseccomp)
		export RUSTFLAGS+="-Clink-args=-static -Clink-args=-no-pie -Clink-args=-Wl,-Bstatic -Ctarget-feature=+crt-static"
		myfeatures=( "static" )
	fi
	cargo_src_compile
}

src_install () {
	cargo_src_install
	dodoc README.md
	insinto /usr/libexec
	doins src/esyd.sh

	insinto /etc
	newins data/user.syd-3 user.syd-3.sample
}

src_test() {
	RUSTFLAGS="" cargo_src_test
}
