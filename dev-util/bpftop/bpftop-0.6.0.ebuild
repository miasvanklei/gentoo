# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.13.5

EAPI=8

CRATES="
	adler@1.0.2
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.18
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.14
	anstyle-parse@0.2.4
	anstyle-query@1.0.3
	anstyle-wincon@3.0.3
	anstyle@1.0.10
	anyhow@1.0.95
	autocfg@1.3.0
	bitflags@2.5.0
	bumpalo@3.16.0
	camino@1.1.6
	cargo-platform@0.1.8
	cargo_metadata@0.15.4
	cassowary@0.3.0
	castaway@0.2.3
	cc@1.1.7
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.38
	circular-buffer@1.0.0
	clap@4.5.28
	clap_builder@4.5.27
	clap_derive@4.5.28
	clap_lex@0.7.4
	colorchoice@1.0.1
	compact_str@0.8.0
	core-foundation-sys@0.8.6
	crc32fast@1.4.0
	crossterm@0.28.1
	crossterm_winapi@0.9.1
	either@1.11.0
	errno@0.3.8
	fastrand@2.1.0
	flate2@1.0.30
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	hex@0.4.3
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.60
	indoc@2.0.5
	instability@0.3.2
	is_terminal_polyfill@1.70.0
	itertools@0.12.1
	itertools@0.13.0
	itoa@1.0.11
	js-sys@0.3.69
	lazy_static@1.4.0
	libbpf-cargo@0.24.8
	libbpf-rs@0.24.8
	libbpf-sys@1.5.0+v1.5.0
	libc@0.2.155
	linux-raw-sys@0.4.13
	lock_api@0.4.12
	log@0.4.21
	lru@0.12.3
	memchr@2.7.2
	memmap2@0.5.10
	miniz_oxide@0.7.2
	mio@1.0.1
	nix@0.29.0
	nu-ansi-term@0.46.0
	num-traits@0.2.19
	once_cell@1.19.0
	overload@0.1.1
	parking_lot@0.12.2
	parking_lot_core@0.9.10
	paste@1.0.15
	pin-project-lite@0.2.14
	pkg-config@0.3.30
	proc-macro2@1.0.82
	procfs-core@0.17.0
	procfs@0.17.0
	quote@1.0.36
	ratatui@0.29.0
	redox_syscall@0.5.1
	regex-automata@0.4.6
	regex-syntax@0.8.3
	regex@1.10.4
	rustix@0.38.34
	rustversion@1.0.16
	ryu@1.0.18
	scopeguard@1.2.0
	semver@1.0.23
	serde@1.0.201
	serde_derive@1.0.201
	serde_json@1.0.117
	sharded-slab@0.1.7
	signal-hook-mio@0.2.4
	signal-hook-registry@1.4.2
	signal-hook@0.3.17
	smallvec@1.13.2
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.61
	tempfile@3.10.1
	thiserror-impl@1.0.60
	thiserror@1.0.60
	thread_local@1.1.8
	tracing-attributes@0.1.28
	tracing-core@0.1.33
	tracing-journald@0.3.1
	tracing-log@0.2.0
	tracing-subscriber@0.3.19
	tracing@0.1.41
	tui-input@0.11.1
	unicode-ident@1.0.12
	unicode-segmentation@1.11.0
	unicode-truncate@1.0.0
	unicode-width@0.1.13
	unicode-width@0.2.0
	utf8parse@0.2.1
	valuable@0.1.0
	version_check@0.9.4
	vsprintf@2.0.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.92
	wasm-bindgen-macro-support@0.2.92
	wasm-bindgen-macro@0.2.92
	wasm-bindgen-shared@0.2.92
	wasm-bindgen@0.2.92
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.52.0
	windows-targets@0.52.5
	windows_aarch64_gnullvm@0.52.5
	windows_aarch64_msvc@0.52.5
	windows_i686_gnu@0.52.5
	windows_i686_gnullvm@0.52.5
	windows_i686_msvc@0.52.5
	windows_x86_64_gnu@0.52.5
	windows_x86_64_gnullvm@0.52.5
	windows_x86_64_msvc@0.52.5
	zerocopy-derive@0.7.34
	zerocopy@0.7.34
"

inherit desktop cargo

DESCRIPTION="Process monitor for BPF programs"
HOMEPAGE="https://github.com/Netflix/bpftop"
SRC_URI="
	https://github.com/Netflix/bpftop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	BSD-2 BSD MIT Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

DOCS=(
	README.md
)

src_install() {
	cargo_src_install

	doicon bpftop-logo.png
	make_desktop_entry /usr/bin/${PN} bpftop-logo.png Development
}
