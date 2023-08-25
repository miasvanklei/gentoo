# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.6

EAPI=8

CRATES="
	addr2line@0.20.0
	adler@1.0.2
	aes-ctr@0.6.0
	aes-soft@0.6.4
	aes@0.6.0
	aesni@0.10.0
	ahash@0.8.3
	aho-corasick@1.0.2
	alsa-sys@0.3.1
	alsa@0.6.0
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.3.2
	anstyle-parse@0.2.1
	anstyle-query@1.0.0
	anstyle-wincon@1.0.1
	anstyle@1.0.1
	async-broadcast@0.5.1
	async-channel@1.9.0
	async-executor@1.5.1
	async-fs@1.6.0
	async-io@1.13.0
	async-lock@2.7.0
	async-process@1.7.0
	async-recursion@1.0.4
	async-task@4.4.0
	async-trait@0.1.72
	atomic-waker@1.1.1
	autocfg@1.1.0
	backtrace@0.3.68
	base64@0.13.1
	base64@0.20.0
	base64@0.21.2
	bindgen@0.64.0
	bitflags@1.3.2
	bitflags@2.3.3
	block-buffer@0.10.4
	block-buffer@0.9.0
	block@0.1.6
	blocking@1.3.1
	bumpalo@3.13.0
	bytecount@0.6.3
	byteorder@1.4.3
	bytes@1.4.0
	cc@1.0.79
	cesu8@1.1.0
	cexpr@0.6.0
	cfg-if@1.0.0
	chrono@0.4.26
	cipher@0.2.5
	clang-sys@1.6.1
	clap@4.3.19
	clap_builder@4.3.19
	clap_complete@4.3.2
	clap_lex@0.5.0
	clap_mangen@0.2.12
	clipboard-win@2.2.0
	clipboard@0.5.0
	colorchoice@1.0.0
	combine@4.6.6
	concurrent-queue@2.2.0
	cookie@0.16.2
	cookie_store@0.19.1
	core-foundation-sys@0.8.4
	core-foundation@0.9.3
	coreaudio-rs@0.10.0
	coreaudio-sys@0.2.12
	cpal@0.13.5
	cpufeatures@0.2.9
	crossbeam-channel@0.5.8
	crossbeam-utils@0.8.16
	crypto-common@0.1.6
	crypto-mac@0.11.1
	ctr@0.6.0
	cursive@0.20.0
	cursive_buffered_backend@0.6.1
	cursive_core@0.3.7
	darling@0.13.4
	darling@0.20.3
	darling_core@0.13.4
	darling_core@0.20.3
	darling_macro@0.13.4
	darling_macro@0.20.3
	derivative@2.2.0
	derive-new@0.5.9
	digest@0.10.7
	digest@0.9.0
	dirs-next@1.0.2
	dirs-next@2.0.0
	dirs-sys-next@0.1.2
	downcast-rs@1.2.0
	encoding_rs@0.8.32
	enum-map-derive@0.12.0
	enum-map@2.6.0
	enum_dispatch@0.3.12
	enumflags2@0.7.7
	enumflags2_derive@0.7.7
	enumset@1.1.2
	enumset_derive@0.8.1
	equivalent@1.0.1
	errno-dragonfly@0.1.2
	errno@0.3.1
	event-listener@2.5.3
	fastrand@1.9.0
	fastrand@2.0.0
	fern@0.6.2
	fixedbitset@0.4.2
	fnv@1.0.7
	foreign-types-shared@0.1.1
	foreign-types@0.3.2
	form_urlencoded@1.2.0
	futures-channel@0.3.28
	futures-core@0.3.28
	futures-executor@0.3.28
	futures-io@0.3.28
	futures-lite@1.13.0
	futures-macro@0.3.28
	futures-sink@0.3.28
	futures-task@0.3.28
	futures-util@0.3.28
	futures@0.3.28
	generic-array@0.14.7
	getrandom@0.2.10
	gimli@0.27.3
	glob@0.3.1
	h2@0.3.20
	half@1.8.2
	hashbrown@0.12.3
	hashbrown@0.14.0
	headers-core@0.2.0
	headers@0.3.8
	heck@0.4.1
	hermit-abi@0.3.2
	hex@0.4.3
	hmac@0.11.0
	http-body@0.4.5
	http@0.2.9
	httparse@1.8.0
	httpdate@1.0.2
	hyper-proxy@0.9.1
	hyper-tls@0.5.0
	hyper@0.14.27
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.57
	ident_case@1.0.1
	idna@0.3.0
	idna@0.4.0
	indexmap@1.9.3
	indexmap@2.0.0
	instant@0.1.12
	io-lifetimes@1.0.11
	ioctl-rs@0.2.0
	ipnet@2.8.0
	is-terminal@0.4.9
	itoa@1.0.9
	jni-sys@0.3.0
	jni@0.19.0
	jobserver@0.1.26
	js-sys@0.3.64
	lazy_static@1.4.0
	lazycell@1.3.0
	lewton@0.10.2
	libc@0.2.147
	libloading@0.7.4
	libm@0.2.7
	libpulse-binding@2.28.1
	libpulse-simple-binding@2.28.1
	libpulse-simple-sys@1.21.1
	libpulse-sys@1.21.0
	librespot-audio@0.4.2
	librespot-core@0.4.2
	librespot-metadata@0.4.2
	librespot-playback@0.4.2
	librespot-protocol@0.4.2
	linux-raw-sys@0.3.8
	linux-raw-sys@0.4.3
	lock_api@0.4.10
	log@0.4.19
	mac-notification-sys@0.5.8
	mach@0.3.2
	malloc_buf@0.0.6
	maplit@1.0.2
	maybe-async@0.2.7
	memchr@2.5.0
	memoffset@0.6.5
	memoffset@0.7.1
	mime@0.3.17
	minimal-lexical@0.2.1
	miniz_oxide@0.7.1
	mio@0.8.8
	native-tls@0.2.11
	ncurses@5.101.0
	ndk-context@0.1.1
	ndk-glue@0.6.2
	ndk-macro@0.3.0
	ndk-sys@0.3.0
	ndk@0.6.0
	nix@0.23.2
	nix@0.24.3
	nix@0.26.2
	nom@7.1.3
	notify-rust@4.8.0
	num-bigint@0.2.6
	num-bigint@0.4.3
	num-complex@0.2.4
	num-complex@0.4.3
	num-derive@0.3.3
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.2.4
	num-rational@0.4.1
	num-traits@0.2.16
	num@0.2.1
	num@0.4.1
	num_cpus@1.16.0
	num_enum@0.5.11
	num_enum_derive@0.5.11
	num_threads@0.1.6
	numtoa@0.1.0
	objc-foundation@0.1.1
	objc@0.2.7
	objc_id@0.1.1
	object@0.31.1
	oboe-sys@0.4.5
	oboe@0.4.6
	ogg@0.8.0
	once_cell@1.18.0
	opaque-debug@0.3.0
	openssl-macros@0.1.1
	openssl-probe@0.1.5
	openssl-sys@0.9.90
	openssl@0.10.55
	ordered-stream@0.2.0
	os_pipe@1.1.4
	owning_ref@0.4.1
	pancurses@0.17.0
	parking@2.1.0
	parking_lot@0.11.2
	parking_lot@0.12.1
	parking_lot_core@0.8.6
	parking_lot_core@0.9.8
	parse_duration@2.1.1
	pbkdf2@0.8.0
	pdcurses-sys@0.7.1
	peeking_take_while@0.1.2
	percent-encoding@2.3.0
	petgraph@0.6.3
	pin-project-lite@0.2.10
	pin-utils@0.1.0
	pkg-config@0.3.27
	platform-dirs@0.3.0
	polling@2.8.0
	portaudio-rs@0.3.2
	portaudio-sys@0.1.1
	ppv-lite86@0.2.17
	priority-queue@1.3.2
	proc-macro-crate@1.3.1
	proc-macro2@1.0.66
	protobuf-codegen-pure@2.28.0
	protobuf-codegen@2.28.0
	protobuf@2.28.0
	quick-xml@0.23.1
	quote@1.0.32
	rand@0.8.5
	rand_chacha@0.3.1
	rand_core@0.6.4
	rand_distr@0.4.3
	redox_syscall@0.2.16
	redox_syscall@0.3.5
	redox_termios@0.1.2
	redox_users@0.4.3
	regex-automata@0.3.3
	regex-syntax@0.7.4
	regex@1.9.1
	reqwest@0.11.18
	ring@0.16.20
	rodio@0.15.0
	roff@0.2.1
	rspotify-http@0.11.7
	rspotify-macros@0.11.7
	rspotify-model@0.11.7
	rspotify@0.11.7
	rustc-demangle@0.1.23
	rustc-hash@1.1.0
	rustc_version@0.4.0
	rustix@0.37.23
	rustix@0.38.4
	rustls-webpki@0.100.1
	rustls-webpki@0.101.1
	rustls@0.21.5
	rustversion@1.0.14
	ryu@1.0.15
	same-file@1.0.6
	schannel@0.1.22
	scopeguard@1.2.0
	sct@0.7.0
	security-framework-sys@2.9.1
	security-framework@2.9.2
	semver@1.0.18
	serde@1.0.174
	serde_cbor@0.11.2
	serde_derive@1.0.174
	serde_json@1.0.103
	serde_repr@0.1.15
	serde_spanned@0.6.3
	serde_urlencoded@0.7.1
	sha-1@0.9.8
	sha1@0.10.5
	sha2@0.10.7
	shannon@0.2.0
	shell-words@1.1.0
	shlex@1.1.0
	signal-hook-registry@1.4.1
	signal-hook@0.3.17
	slab@0.4.8
	smallvec@1.11.0
	socket2@0.4.9
	spin@0.5.2
	stable_deref_trait@1.2.0
	static_assertions@1.1.0
	stdweb@0.1.3
	strsim@0.10.0
	strum@0.24.1
	strum@0.25.0
	strum_macros@0.24.3
	strum_macros@0.25.1
	subtle@2.4.1
	syn@1.0.109
	syn@2.0.27
	tauri-winrt-notification@0.1.2
	tempfile@3.7.0
	term_size@0.3.2
	termion@1.5.6
	thiserror-impl@1.0.44
	thiserror@1.0.44
	thread-id@4.1.0
	time-core@0.1.1
	time-macros@0.2.10
	time@0.1.45
	time@0.3.23
	tinyvec@1.6.0
	tinyvec_macros@0.1.1
	tokio-macros@2.1.0
	tokio-native-tls@0.3.1
	tokio-stream@0.1.14
	tokio-util@0.7.8
	tokio@1.29.1
	toml@0.7.6
	toml_datetime@0.6.3
	toml_edit@0.19.14
	tower-service@0.3.2
	tracing-attributes@0.1.26
	tracing-core@0.1.31
	tracing@0.1.37
	tree_magic_mini@3.0.3
	try-lock@0.2.4
	typenum@1.16.0
	uds_windows@1.0.2
	unicode-bidi@0.3.13
	unicode-ident@1.0.11
	unicode-normalization@0.1.22
	unicode-segmentation@1.10.1
	unicode-width@0.1.10
	untrusted@0.7.1
	ureq@2.7.1
	url@2.4.0
	utf8parse@0.2.1
	uuid@1.4.1
	vcpkg@0.2.15
	vergen@3.2.0
	version_check@0.9.4
	waker-fn@1.1.0
	walkdir@2.3.3
	want@0.3.1
	wasi@0.10.0+wasi-snapshot-preview1
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.87
	wasm-bindgen-futures@0.4.37
	wasm-bindgen-macro-support@0.2.87
	wasm-bindgen-macro@0.2.87
	wasm-bindgen-shared@0.2.87
	wasm-bindgen@0.2.87
	wayland-client@0.29.5
	wayland-commons@0.29.5
	wayland-protocols@0.29.5
	wayland-scanner@0.29.5
	wayland-sys@0.29.5
	web-sys@0.3.64
	webpki-roots@0.23.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.5
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.48.0
	windows-targets@0.48.1
	windows@0.39.0
	windows@0.48.0
	windows_aarch64_gnullvm@0.48.0
	windows_aarch64_msvc@0.39.0
	windows_aarch64_msvc@0.48.0
	windows_i686_gnu@0.39.0
	windows_i686_gnu@0.48.0
	windows_i686_msvc@0.39.0
	windows_i686_msvc@0.48.0
	windows_x86_64_gnu@0.39.0
	windows_x86_64_gnu@0.48.0
	windows_x86_64_gnullvm@0.48.0
	windows_x86_64_msvc@0.39.0
	windows_x86_64_msvc@0.48.0
	winnow@0.5.0
	winreg@0.10.1
	winreg@0.5.1
	wl-clipboard-rs@0.7.0
	x11-clipboard@0.3.3
	xcb@0.8.2
	xdg-home@1.0.0
	xi-unicode@0.3.0
	xml-rs@0.8.16
	zbus@3.14.1
	zbus_macros@3.14.1
	zbus_names@2.6.0
	zerocopy-derive@0.3.2
	zerocopy@0.6.1
	zvariant@3.15.0
	zvariant_derive@3.15.0
	zvariant_utils@1.0.1
"

# xtask crates:
CRATES+="
	cargo-xtask-0.1.0
	clap_mangen-0.2.8
	clap_complete-4.2.1
	clap-4.2.7
"

PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 cargo desktop optfeature python-any-r1

DESCRIPTION="ncurses Spotify client written in Rust using librespot"
HOMEPAGE="https://github.com/hrkfdn/ncspot"
SRC_URI="https://github.com/hrkfdn/ncspot/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="BSD-2"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD-2 BSD ISC MIT MPL-2.0 Unicode-DFS-2016"
SLOT="0"
KEYWORDS="amd64"

IUSE="clipboard cover mpris ncurses +notify pulseaudio"

RDEPEND="dev-libs/openssl:=
	sys-apps/dbus
	clipboard? ( x11-libs/libxcb:= )
	cover? ( media-gfx/ueberzug )
	ncurses? ( sys-libs/ncurses:= )
	!ncurses? ( sys-libs/ncurses )
	pulseaudio? ( media-libs/libpulse )
	!pulseaudio? ( media-libs/alsa-lib )"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig"

QA_FLAGS_IGNORED="/usr/bin/ncspot"

src_configure() {
	local myfeaturesdef=""

	use clipboard && myfeaturesdef+="share_clipboard,share_selection,"
	use cover && myfeaturesdef+="cover,"
	use mpris && myfeaturesdef+="mpris,"
	use ncurses && myfeaturesdef+="ncurses_backend,"
	use notify && myfeaturesdef+="notify,"

	# It always seems to link to libpulse regardless of this setting if libpulse is installed.
	if use pulseaudio; then
	  myfeaturesdef+="pulseaudio_backend,"
	else
	  myfeaturesdef+="alsa_backend,"
	fi

	local myfeatures=( "${myfeaturesdef::-1}" )

	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile

	cargo xtask generate-shell-completion || die
	cargo xtask generate-manpage || die
}

src_install() {
	cargo_src_install
	einstalldocs

	domenu misc/ncspot.desktop
	newicon -s scalable images/logo.svg ncspot.svg

	dobashcomp misc/ncspot.bash

	insinto /usr/share/fish/completions
	doins misc/ncspot.fish

	insinto /usr/share/zsh/site-functions
	doins misc/_ncspot

	doman misc/ncspot.1
}

pkg_postinst() {
	optfeature_header "Optional runtime features:"
	optfeature "MPRIS song scrobbling support" media-sound/rescrobbled
}
