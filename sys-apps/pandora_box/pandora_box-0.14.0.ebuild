# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.4

EAPI=8

SYDVER=3.32.0

IUSE="static"

CRATES="
	ahash@0.8.11
	arrayvec@0.7.6
	autocfg@1.4.0
	bitflags@2.6.0
	block-buffer@0.10.4
	btoi@0.4.3
	bumpalo@3.16.0
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	console@0.15.10
	cpufeatures@0.2.16
	crc-catalog@2.4.0
	crc@3.2.1
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	digest@0.10.7
	either@1.13.0
	encode_unicode@1.0.0
	equivalent@1.0.1
	errno@0.3.10
	fastrand@2.3.0
	generic-array@0.14.7
	getrandom@0.2.15
	hashbrown@0.15.2
	hermit-abi@0.3.9
	hex-conservative@0.3.0
	indexmap@2.7.0
	indicatif@0.17.9
	itoa@1.0.14
	js-sys@0.3.76
	keccak@0.1.5
	lexopt@0.3.0
	libc@0.2.169
	linux-raw-sys@0.4.14
	log@0.4.22
	md5@0.7.0
	memchr@2.7.4
	memoffset@0.9.1
	nix@0.29.0
	num-traits@0.2.19
	num_cpus@1.16.0
	number_prefix@0.4.0
	once_cell@1.20.2
	portable-atomic@1.10.0
	proc-macro2@1.0.92
	quote@1.0.38
	rayon-core@1.12.1
	rayon@1.10.0
	rustix@0.38.42
	ryu@1.0.18
	serde@1.0.217
	serde_derive@1.0.217
	serde_json@1.0.134
	sha1@0.10.6
	sha3@0.10.8
	syn@2.0.93
	tempfile@3.14.0
	typenum@1.17.0
	unicode-ident@1.0.14
	unicode-width@0.2.0
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.99
	wasm-bindgen-macro-support@0.2.99
	wasm-bindgen-macro@0.2.99
	wasm-bindgen-shared@0.2.99
	wasm-bindgen@0.2.99
	web-time@1.1.0
	windows-sys@0.59.0
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.52.6
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo

DESCRIPTION="Syd's log inspector & profile writer"
HOMEPAGE="https://man.exherbolinux.org"

SRC_URI="https://git.sr.ht/~alip/syd/archive/v${SYDVER}.tar.gz -> syd-${SYDVER}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD CC0-1.0 GPL-2
	ISC MIT MPL-2.0 Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}/syd-v${SYDVER}/pandora

src_configure() {
	if use static; then
		export RUSTFLAGS+="-Ctarget-feature=+crt-static"
	fi
	cargo_src_configure
}
