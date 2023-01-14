# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.6

EAPI=8

CRATES="
	addr2line-0.19.0
	adler-1.0.2
	aes-0.6.0
	aes-ctr-0.6.0
	aes-soft-0.6.4
	aesni-0.10.0
	ahash-0.8.2
	aho-corasick-0.7.20
	alsa-0.6.0
	alsa-sys-0.3.1
	android_system_properties-0.1.5
	async-trait-0.1.60
	autocfg-1.1.0
	backtrace-0.3.67
	base64-0.13.1
	bindgen-0.61.0
	bitflags-1.3.2
	block-0.1.6
	block-buffer-0.10.3
	block-buffer-0.9.0
	bumpalo-3.11.1
	bytecount-0.6.3
	byteorder-1.4.3
	bytes-1.3.0
	cc-1.0.78
	cesu8-1.1.0
	cexpr-0.6.0
	cfg-if-1.0.0
	chrono-0.4.23
	chunked_transfer-1.4.1
	cipher-0.2.5
	clang-sys-1.4.0
	clap-4.0.32
	clap_lex-0.3.0
	clipboard-0.5.0
	clipboard-win-2.2.0
	codespan-reporting-0.11.1
	combine-4.6.6
	cookie-0.16.2
	cookie_store-0.16.1
	core-foundation-0.9.3
	core-foundation-sys-0.8.3
	coreaudio-rs-0.10.0
	coreaudio-sys-0.2.11
	cpal-0.13.5
	cpufeatures-0.2.5
	crossbeam-channel-0.5.6
	crossbeam-utils-0.8.14
	crypto-common-0.1.6
	crypto-mac-0.11.1
	ctr-0.6.0
	cursive-0.20.0
	cursive_buffered_backend-0.6.1
	cursive_core-0.3.6
	cxx-1.0.85
	cxx-build-1.0.85
	cxxbridge-flags-1.0.85
	cxxbridge-macro-1.0.85
	darling-0.13.4
	darling-0.14.2
	darling_core-0.13.4
	darling_core-0.14.2
	darling_macro-0.13.4
	darling_macro-0.14.2
	dbus-0.9.6
	dbus-tree-0.9.2
	derive-new-0.5.9
	digest-0.10.6
	digest-0.9.0
	dirs-next-1.0.2
	dirs-next-2.0.0
	dirs-sys-next-0.1.2
	downcast-rs-1.2.0
	encoding_rs-0.8.31
	enum-map-2.4.2
	enum-map-derive-0.11.0
	enum_dispatch-0.3.8
	enumset-1.0.12
	enumset_derive-0.6.1
	errno-0.2.8
	errno-dragonfly-0.1.2
	fastrand-1.8.0
	fern-0.6.1
	fixedbitset-0.4.2
	fnv-1.0.7
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.1.0
	futures-0.3.25
	futures-channel-0.3.25
	futures-core-0.3.25
	futures-executor-0.3.25
	futures-io-0.3.25
	futures-macro-0.3.25
	futures-sink-0.3.25
	futures-task-0.3.25
	futures-util-0.3.25
	generic-array-0.14.6
	getrandom-0.2.8
	gimli-0.27.0
	glob-0.3.0
	h2-0.3.15
	half-1.8.2
	hashbrown-0.12.3
	headers-0.3.8
	headers-core-0.2.0
	heck-0.3.3
	heck-0.4.0
	hermit-abi-0.2.6
	hmac-0.11.0
	http-0.2.8
	http-body-0.4.5
	httparse-1.8.0
	httpdate-1.0.2
	hyper-0.14.23
	hyper-proxy-0.9.1
	hyper-tls-0.5.0
	iana-time-zone-0.1.53
	iana-time-zone-haiku-0.1.1
	ident_case-1.0.1
	idna-0.2.3
	idna-0.3.0
	indexmap-1.9.2
	instant-0.1.12
	io-lifetimes-1.0.3
	ioctl-rs-0.2.0
	ipnet-2.7.0
	is-terminal-0.4.2
	itoa-1.0.5
	jni-0.19.0
	jni-sys-0.3.0
	jobserver-0.1.25
	js-sys-0.3.60
	lazy_static-1.4.0
	lazycell-1.3.0
	lewton-0.10.2
	libc-0.2.139
	libdbus-sys-0.2.2
	libloading-0.7.4
	libm-0.2.6
	libpulse-binding-2.26.0
	libpulse-simple-binding-2.25.0
	libpulse-simple-sys-1.19.2
	libpulse-sys-1.19.3
	librespot-audio-0.4.2
	librespot-core-0.4.2
	librespot-metadata-0.4.2
	librespot-playback-0.4.2
	librespot-protocol-0.4.2
	link-cplusplus-1.0.8
	linux-raw-sys-0.1.4
	lock_api-0.4.9
	log-0.4.17
	mac-notification-sys-0.5.6
	mach-0.3.2
	malloc_buf-0.0.6
	maplit-1.0.2
	matches-0.1.9
	maybe-async-0.2.6
	memchr-2.5.0
	memoffset-0.6.5
	mime-0.3.16
	minimal-lexical-0.2.1
	miniz_oxide-0.6.2
	mio-0.8.5
	native-tls-0.2.11
	ncurses-5.101.0
	ndk-0.6.0
	ndk-context-0.1.1
	ndk-glue-0.6.2
	ndk-macro-0.3.0
	ndk-sys-0.3.0
	nix-0.23.2
	nix-0.24.3
	nom-7.1.1
	notify-rust-4.6.0
	num-0.2.1
	num-0.4.0
	num-bigint-0.2.6
	num-bigint-0.4.3
	num-complex-0.2.4
	num-complex-0.4.2
	num-derive-0.3.3
	num-integer-0.1.45
	num-iter-0.1.43
	num-rational-0.2.4
	num-rational-0.4.1
	num-traits-0.2.15
	num_cpus-1.15.0
	num_enum-0.5.7
	num_enum_derive-0.5.7
	num_threads-0.1.6
	numtoa-0.1.0
	objc-0.2.7
	objc-foundation-0.1.1
	objc_id-0.1.1
	object-0.30.0
	oboe-0.4.6
	oboe-sys-0.4.5
	ogg-0.8.0
	once_cell-1.16.0
	opaque-debug-0.3.0
	openssl-0.10.45
	openssl-macros-0.1.0
	openssl-probe-0.1.5
	openssl-sys-0.9.80
	os_pipe-1.1.2
	os_str_bytes-6.4.1
	owning_ref-0.4.1
	pancurses-0.17.0
	parking_lot-0.11.2
	parking_lot-0.12.1
	parking_lot_core-0.8.6
	parking_lot_core-0.9.5
	parse_duration-2.1.1
	pbkdf2-0.8.0
	pdcurses-sys-0.7.1
	peeking_take_while-0.1.2
	percent-encoding-2.2.0
	petgraph-0.6.2
	pin-project-lite-0.2.9
	pin-utils-0.1.0
	pkg-config-0.3.26
	platform-dirs-0.3.0
	portaudio-rs-0.3.2
	portaudio-sys-0.1.1
	ppv-lite86-0.2.17
	priority-queue-1.3.0
	proc-macro-crate-1.2.1
	proc-macro2-1.0.49
	protobuf-2.28.0
	protobuf-codegen-2.28.0
	protobuf-codegen-pure-2.28.0
	psl-types-2.0.11
	publicsuffix-2.2.3
	quick-xml-0.23.1
	quote-1.0.23
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.6.4
	rand_distr-0.4.3
	redox_syscall-0.2.16
	redox_termios-0.1.2
	redox_users-0.4.3
	regex-1.7.0
	regex-syntax-0.6.28
	remove_dir_all-0.5.3
	reqwest-0.11.13
	ring-0.16.20
	rodio-0.15.0
	rspotify-0.11.6
	rspotify-http-0.11.6
	rspotify-macros-0.11.6
	rspotify-model-0.11.6
	rustc-demangle-0.1.21
	rustc-hash-1.1.0
	rustc-serialize-0.3.24
	rustc_version-0.4.0
	rustix-0.36.6
	rustls-0.20.7
	rustversion-1.0.11
	ryu-1.0.12
	same-file-1.0.6
	schannel-0.1.20
	scopeguard-1.1.0
	scratch-1.0.3
	sct-0.7.0
	security-framework-2.7.0
	security-framework-sys-2.6.1
	semver-1.0.16
	serde-1.0.152
	serde_cbor-0.11.2
	serde_derive-1.0.152
	serde_json-1.0.91
	serde_urlencoded-0.7.1
	sha-1-0.9.8
	sha1-0.10.5
	sha2-0.10.6
	shannon-0.2.0
	shell-words-1.1.0
	shlex-1.1.0
	signal-hook-0.3.14
	signal-hook-registry-1.4.0
	slab-0.4.7
	smallvec-1.10.0
	socket2-0.4.7
	spin-0.5.2
	stable_deref_trait-1.2.0
	stdweb-0.1.3
	strsim-0.10.0
	strum-0.22.0
	strum-0.24.1
	strum_macros-0.22.0
	strum_macros-0.24.3
	subtle-2.4.1
	syn-1.0.107
	tauri-winrt-notification-0.1.0
	tempfile-3.3.0
	term_size-0.3.2
	termcolor-1.1.3
	termion-1.5.6
	thiserror-1.0.38
	thiserror-impl-1.0.38
	thread-id-4.0.0
	time-0.1.45
	time-0.3.17
	time-core-0.1.0
	time-macros-0.2.6
	tinyvec-1.6.0
	tinyvec_macros-0.1.0
	tokio-1.23.0
	tokio-macros-1.8.2
	tokio-native-tls-0.3.0
	tokio-stream-0.1.11
	tokio-util-0.7.4
	toml-0.5.10
	tower-service-0.3.2
	tracing-0.1.37
	tracing-core-0.1.30
	tree_magic_mini-3.0.3
	try-lock-0.2.3
	typenum-1.16.0
	unicode-bidi-0.3.8
	unicode-ident-1.0.6
	unicode-normalization-0.1.22
	unicode-segmentation-1.10.0
	unicode-width-0.1.10
	untrusted-0.7.1
	ureq-2.5.0
	url-2.3.1
	uuid-1.2.2
	vcpkg-0.2.15
	vergen-3.2.0
	version_check-0.9.4
	walkdir-2.3.2
	want-0.3.0
	wasi-0.10.0+wasi-snapshot-preview1
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.83
	wasm-bindgen-backend-0.2.83
	wasm-bindgen-futures-0.4.33
	wasm-bindgen-macro-0.2.83
	wasm-bindgen-macro-support-0.2.83
	wasm-bindgen-shared-0.2.83
	wayland-client-0.29.5
	wayland-commons-0.29.5
	wayland-protocols-0.29.5
	wayland-scanner-0.29.5
	wayland-sys-0.29.5
	web-sys-0.3.60
	webpki-0.22.0
	webpki-roots-0.22.6
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-0.39.0
	windows-sys-0.36.1
	windows-sys-0.42.0
	windows_aarch64_gnullvm-0.42.0
	windows_aarch64_msvc-0.36.1
	windows_aarch64_msvc-0.39.0
	windows_aarch64_msvc-0.42.0
	windows_i686_gnu-0.36.1
	windows_i686_gnu-0.39.0
	windows_i686_gnu-0.42.0
	windows_i686_msvc-0.36.1
	windows_i686_msvc-0.39.0
	windows_i686_msvc-0.42.0
	windows_x86_64_gnu-0.36.1
	windows_x86_64_gnu-0.39.0
	windows_x86_64_gnu-0.42.0
	windows_x86_64_gnullvm-0.42.0
	windows_x86_64_msvc-0.36.1
	windows_x86_64_msvc-0.39.0
	windows_x86_64_msvc-0.42.0
	winreg-0.10.1
	winreg-0.5.1
	wl-clipboard-rs-0.7.0
	x11-clipboard-0.3.3
	xcb-0.8.2
	xi-unicode-0.3.0
	xml-rs-0.8.4
	zerocopy-0.6.1
	zerocopy-derive-0.3.2
"

PYTHON_COMPAT=( python3_{9..11} )

inherit cargo optfeature python-any-r1

DESCRIPTION="ncurses Spotify client written in Rust using librespot"
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="BSD-2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"

IUSE="clipboard cover mpris +notify"

RDEPEND="dev-libs/openssl:=
	media-libs/libpulse
	sys-apps/dbus
	sys-libs/ncurses
	x11-libs/libxcb:=
	cover? ( media-gfx/ueberzug )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig"

QA_FLAGS_IGNORED="/usr/bin/ncspot"

src_configure() {
	local myfeaturesdef=""

	use clipboard && myfeaturesdef+="share_clipboard,share_selection,"
	use cover && myfeaturesdef+="cover,"
	use mpris && myfeaturesdef+="mpris,"
	use notify && myfeaturesdef+="notify,"

	# It always seems to link to libpulse regardless of this setting, testing required from someone
	# with full alsa setup (no pulseaudio/pipewire). v0.12.0
	# if use pulseaudio; then
	#	myfeaturesdef+="pulseaudio_backend,"
	# else
	#	myfeaturesdef+="alsa_backend,"
	# fi

	myfeaturesdef+="pulseaudio_backend,"

	local myfeatures=( "${myfeaturesdef::-1}" )

	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs
}

pkg_postinst() {
	optfeature_header "Optional runtime features:"
	optfeature "media-sound/rescrobbled" MPRIS song scrobbling support
}
