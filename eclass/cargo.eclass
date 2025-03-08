# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cargo.eclass
# @MAINTAINER:
# rust@gentoo.org
# @AUTHOR:
# Doug Goldstein <cardoe@gentoo.org>
# Georgy Yakovlev <gyakovlev@gentoo.org>
# Matt Jolly <kangie@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @PROVIDES: rust
# @BLURB: common functions and variables for cargo builds

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CARGO_ECLASS} ]]; then
_CARGO_ECLASS=1

if [[ -n ${RUST_NEEDS_LLVM} ]]; then
		inherit llvm-r1
fi

if [[ -n ${CARGO_OPTIONAL} ]]; then
	RUST_OPTIONAL=1
fi

# Either the lowest slot supported by rust.eclass _or_
# reference the changelog for a particular feature requirement
# https://github.com/rust-lang/cargo/blob/master/CHANGELOG.md
# For reference the actual minimum version of cargo that can be used
# is 1.53.0 for `cargo update --offline`; updated to 1.71.1 with rust eclass.
# No need to enable usage of legacy rust versions in ebuilds; keep it as-is.
_CARGO_ECLASS_RUST_MIN_VER="1.71.1"

case ${EAPI} in
	8)
		if [[ -n ${RUST_MIN_VER} ]]; then
			# This is _very_ unlikely given that we leverage the rust eclass but just in case cargo requires a newer version
			# than the oldest in-tree in future.
			if [[ -z ${CARGO_BOOTSTRAP} ]]; then
				if ver_test "${RUST_MIN_VER}" -lt "${_CARGO_ECLASS_RUST_MIN_VER}"; then
					die "RUST_MIN_VERSION must be at least ${_CARGO_ECLASS_RUST_MIN_VER}"
				fi
			fi
		else
			RUST_MIN_VER="${_CARGO_ECLASS_RUST_MIN_VER}"
		fi
		;;
esac

if [[ -n ${CRATE_PATHS_OVERRIDE} ]]; then
	CRATES="${CRATES} ${CRATE_PATHS_OVERRIDE}"
fi

inherit flag-o-matic multiprocessing rust rust-toolchain toolchain-funcs

IUSE="${IUSE} debug"

ECARGO_HOME="${WORKDIR}/cargo_home"
ECARGO_VENDOR="${ECARGO_HOME}/gentoo"

# @ECLASS_VARIABLE: CRATES
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Bash string containing all crates that are to be downloaded.
# It is used by cargo_crate_uris. Typically generated by app-portage/pycargoebuild.
#
# Ideally, crate names and versions should be separated by a `@`
# character.  A legacy syntax using hyphen is also supported but it is
# much slower.
#
# Example:
# @CODE
# CRATES="
# metal@1.2.3
# bar@4.5.6
# iron_oxide@0.0.1
# "
# inherit cargo
# ...
# SRC_URI="${CARGO_CRATE_URIS}"
# @CODE

# @ECLASS_VARIABLE: CRATE_PATHS_OVERRIDE
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Bash string containing crates that will be used to override
# dependencies via generated `paths = ['/path/to/crate']` configuration.
# This is not "smart", _all crates_ which match the `Cargo.toml`
# for a given crate/path will be overridden, ignoring lockfiles,
# version constraints, etc.
#
# This should be used as a last resort where (e.g.) you are
# bootstrapping Rust and need to override a vendored crate
# with a newer version, and all versions in use are compatible.
#
# Crate names and versions must be separated by a `@`;
# multiple crates are separated by a space or newline.
# Crates in CRATE_PATHS_OVERRIDE are implicitly added to CRATES;
# they do not need to be listed.
#
# Example:
# @CODE
# CRATES="
# 	foo@1.2.3
# "
#
# CRATE_PATHS_OVERRIDE="
# 	openssl@0.10.35
# 	openssl-sys@0.9.65
# "
#
# inherit cargo
# ...
# SRC_URI="${CARGO_CRATE_URIS}"
# @CODE

# @ECLASS_VARIABLE: GIT_CRATES
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Bash associative array containing all of the crates that are to be
# fetched via git.  It is used by cargo_crate_uris.
# If this is defined, then cargo_src_install will add --frozen to "cargo install".
# The key is a crate name, the value is a semicolon-separated list of:
#
# - the URI to fetch the crate from.
#     - This intelligently handles GitHub and GitLab URIs so that
#       just the repository path is needed.
#     - The string "%commit%" gets replaced with the commit's checksum.
# - the checksum of the commit to use.
# - optionally: the path to look for Cargo.toml in.
#   - This will also replace the string "%commit%" with the commit's checksum.
#   - Defaults to: "${crate}-%commit%"
# - optionally: the git host so it would generate tarball download link.
#   - E.g. gitlab
#   - It fallbacks to detecting from URL if it's gitlab.com or github.com
#     if no host provided.
#
# Example of a simple definition with no path to Cargo.toml:
# @CODE
# declare -A GIT_CRATES=(
# 	[home]="https://github.com/rbtcollins/home;a243ee2fbee6022c57d56f5aa79aefe194eabe53"
# )
# @CODE
#
# Example with paths defined:
# @CODE
# declare -A GIT_CRATES=(
# 	[rustpython-common]="https://github.com/RustPython/RustPython;4f38cb68e4a97aeea9eb19673803a0bd5f655383;RustPython-%commit%/common"
# 	[rustpython-parser]="https://github.com/RustPython/RustPython;4f38cb68e4a97aeea9eb19673803a0bd5f655383;RustPython-%commit%/compiler/parser"
# )
# @CODE
#
# Example with host defined:
# @CODE
# declare -A GIT_CRATES=(
#	[clapper]="https://gitlab.gnome.org/JanGernert/clapper-rs;530b6fd53a60563d8038f7a1d9d735d6dc496adb;clapper-rs-%commit%/libclapper-rs;gitlab"
# )
# @CODE

# @ECLASS_VARIABLE: CARGO_BOOTSTRAP
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# Ignore `_CARGO_ECLASS_RUST_MIN_VER` checks.
# If you aren't bootstrapping Rust you probably don't need this.

# @ECLASS_VARIABLE: CARGO_OPTIONAL
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set to a non-null value, the part of the ebuild before "inherit cargo" will
# be considered optional. No dependencies will be added and no phase
# functions will be exported.
#
# If you enable CARGO_OPTIONAL call at least cargo_gen_config manually
# before using other src_* functions or cargo_env of this eclass.
# Note that cargo_gen_config is automatically called by cargo_src_unpack.

# @ECLASS_VARIABLE: myfeatures
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional cargo features defined as bash array.
# Should be defined before calling cargo_src_configure.
#
# Example of a package that has x11 and wayland features and disables default features.
# @CODE
# src_configure() {
# 	local myfeatures=(
#		$(usex X x11 '')
# 		$(usev wayland)
# 	)
# 	cargo_src_configure --no-default-features
# }
# @CODE

# @ECLASS_VARIABLE: ECARGO_HOME
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Location of the cargo home directory.

# @ECLASS_VARIABLE: ECARGO_REGISTRY_DIR
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Storage directory for cargo registry.
# Used by cargo_live_src_unpack to cache downloads.
# This is intended to be set by users.
# Ebuilds must not set it.
#
# Defaults to "${DISTDIR}/cargo-registry" if not set.

# @ECLASS_VARIABLE: ECARGO_OFFLINE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty, this variable prevents online operations in
# cargo_live_src_unpack.
# Inherits value of EVCS_OFFLINE if not set explicitly.

# @ECLASS_VARIABLE: ECARGO_VENDOR
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# Location of the cargo vendor directory.

# @ECLASS_VARIABLE: EVCS_UMASK
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable to a custom umask. This is intended to be set by
# users. By setting this to something like 002, it can make life easier
# for people who use cargo in a home directory, but are in the portage
# group, and then switch over to building with FEATURES=userpriv.
# Or vice-versa.

# @ECLASS_VARIABLE: CARGO_CRATE_URIS
# @OUTPUT_VARIABLE
# @DESCRIPTION:
# List of URIs to put in SRC_URI created from CRATES variable.

# @FUNCTION: _cargo_set_crate_uris
# @USAGE: <crates>
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
# Constructs a list of crates from its arguments.
# If no arguments are provided, it uses the CRATES variable.
# The value is set as CARGO_CRATE_URIS.
_cargo_set_crate_uris() {
	local -r regex='^([a-zA-Z0-9_\-]+)-([0-9]+\.[0-9]+\.[0-9]+.*)$'
	local crates=${1}
	local crate

	CARGO_CRATE_URIS=
	for crate in ${crates}; do
		local name version url
		if [[ ${crate} == *@* ]]; then
			name=${crate%@*}
			version=${crate##*@}
		else
			[[ ${crate} =~ ${regex} ]] ||
				die "Could not parse name and version from crate: ${crate}"
			name="${BASH_REMATCH[1]}"
			version="${BASH_REMATCH[2]}"
		fi
		url="https://crates.io/api/v1/crates/${name}/${version}/download -> ${name}-${version}.crate"
		CARGO_CRATE_URIS+="${url} "

		# when invoked by pkgbump, avoid fetching all the crates
		# we just output the first one, to avoid creating empty groups
		# in SRC_URI
		[[ ${PKGBUMPING} == ${PVR} ]] && return
	done

	if declare -p GIT_CRATES &>/dev/null; then
		if [[ $(declare -p GIT_CRATES) == "declare -A"* ]]; then
			local crate commit crate_uri crate_dir host repo_ext feat_expr

			for crate in "${!GIT_CRATES[@]}"; do
				IFS=';' read -r crate_uri commit crate_dir host <<< "${GIT_CRATES[${crate}]}"

				if [[ -z ${host} ]]; then
					case "${crate_uri}" in
						https://github.com/*)
							host="github"
						;;
						https://gitlab.com/*)
							host="gitlab"
						;;
					esac
				fi

				case "${host}" in
					github)
						repo_ext=".gh"
						repo_name="${crate_uri##*/}"
						crate_uri="${crate_uri%/}/archive/%commit%.tar.gz"
					;;
					gitlab)
						repo_ext=".gl"
						repo_name="${crate_uri##*/}"
						crate_uri="${crate_uri%/}/-/archive/%commit%/${repo_name}-%commit%.tar.gz"
					;;
					gitea)
						repo_ext=".gt"
						repo_name="${crate_uri##*/}"
						crate_uri="${crate_uri%/}/archive/%commit%.tar.gz"
					;;
					*)
						repo_ext=
						repo_name="${crate}"
					;;
				esac

				CARGO_CRATE_URIS+="${crate_uri//%commit%/${commit}} -> ${repo_name}-${commit}${repo_ext}.tar.gz "
			done
		else
			die "GIT_CRATE must be declared as an associative array"
		fi
	fi
}
_cargo_set_crate_uris "${CRATES}"

# @FUNCTION: cargo_crate_uris
# @USAGE: [<crates>...]
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
# Constructs a list of crates from its arguments.
# If no arguments are provided, it uses the CRATES variable.
cargo_crate_uris() {
	local crates=${*-${CRATES}}
	if [[ -z ${crates} ]]; then
		eerror "CRATES variable is not defined and nothing passed as argument"
		die "Can't generate SRC_URI from empty input"
	fi

	_cargo_set_crate_uris "${crates}"
	echo "${CARGO_CRATE_URIS}"
}

# @FUNCTION: _cargo_gen_override_paths_config
# @INTERNAL
# @DESCRIPTION:
# Generate the TOML content for overriding crates globally using the package manager.
# This is called from within cargo_gen_config to insert the appropriate snippet
# into the generated config.toml. Does not support git crates.
_cargo_gen_override_paths_config() {
	if [[ ! ${#CRATE_PATHS_OVERRIDE[@]} -gt 0 ]]; then
		return
	fi
	local content override path
	content=( 'paths = [' )
	for override in ${CRATE_PATHS_OVERRIDE}; do
		local path="${ECARGO_VENDOR}/${override//@/-}"
		content+=( "'${path}'," )
	done
	content+=( ']' )
	printf "%s\n" "${content[@]}"
}

# @FUNCTION: cargo_gen_config
# @DESCRIPTION:
# Generate the $CARGO_HOME/config.toml necessary to use our local registry and settings.
# Cargo can also be configured through environment variables in addition to the TOML syntax below.
# For each configuration key below of the form foo.bar the environment variable CARGO_FOO_BAR
# can also be used to define the value.
# Environment variables will take precedence over TOML configuration,
# and currently only integer, boolean, and string keys are supported.
# For example the build.jobs key can also be defined by CARGO_BUILD_JOBS.
# Or setting CARGO_TERM_VERBOSE=false in make.conf will make build quieter.
cargo_gen_config() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_HOME}" || die

	cat > "${ECARGO_HOME}/config.toml" <<- _EOF_ || die "Failed to create cargo config"
	$(_cargo_gen_override_paths_config)

	[source.gentoo]
	directory = "${ECARGO_VENDOR}"

	[source.crates-io]
	replace-with = "gentoo"
	local-registry = "/nonexistent"

	[net]
	offline = true

	[build]
	jobs = $(makeopts_jobs)
	incremental = false

	[env]
	RUST_TEST_THREADS = "$(makeopts_jobs)"

	[term]
	verbose = true
	$([[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && echo "color = 'never'")
	$(_cargo_gen_git_config)

	_EOF_

	export CARGO_HOME="${ECARGO_HOME}"
	_CARGO_GEN_CONFIG_HAS_RUN=1
}

# @FUNCTION: _cargo_gen_git_config
# @USAGE:
# @INTERNAL
# @DESCRIPTION:
# Generate the cargo config for git crates, this will output the
# configuration for cargo to override the cargo config so the local git crates
# specified in GIT_CRATES will be used rather than attempting to fetch
# from git.
#
# Called by cargo_gen_config when generating the config.
_cargo_gen_git_config() {
	local git_crates_type
	git_crates_type="$(declare -p GIT_CRATES 2>&-)"

	if [[ ${git_crates_type} == "declare -A "* ]]; then
		local crate commit crate_uri crate_dir host
		local -A crate_patches

		for crate in "${!GIT_CRATES[@]}"; do
			IFS=';' read -r crate_uri commit crate_dir host <<< "${GIT_CRATES[${crate}]}"
			: "${crate_dir:=${crate}-%commit%}"
			crate_patches["${crate_uri}"]+="${crate} = { path = \"${WORKDIR}/${crate_dir//%commit%/${commit}}\" };;"
		done

		for crate_uri in "${!crate_patches[@]}"; do
			printf -- "[patch.'%s']\\n%s\n" "${crate_uri}" "${crate_patches["${crate_uri}"]//;;/$'\n'}"
		done

	elif [[ -n ${git_crates_type} ]]; then
		die "GIT_CRATE must be declared as an associative array"
	fi
}

# @FUNCTION: cargo_target_dir
# @DESCRIPTION:
# Return the directory within target that contains the build, e.g.
# target/aarch64-unknown-linux-gnu/release.
cargo_target_dir() {
	echo "${CARGO_TARGET_DIR:-target}/$(rust_abi)/$(usex debug debug release)"
}

# @FUNCTION: cargo_update_crates
# @USAGE:
# @DESCRIPTION:
# Helper function to call `cargo update --offline` with the given Cargo.toml.
# This will update Cargo.{toml,lock}. This should provide a straightforward
# approach to updating vulnerable crates in a package.
#
# To use: replace any vulnerable crates in ${CRATES} with updated (and compatible)
# versions, then call `cargo_update_crates` in src_prepare. If Cargo.toml is not
# in the root of ${S}, pass the path to the Cargo.toml as the first argument.
# It is up to the ebuild to ensure that the updated crates are compatible with the
# package and that no unexpected breakage occurs.
cargo_update_crates () {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z ${CARGO} ]]; then
		die "CARGO is not set; was rust_pkg_setup run?"
	fi

	local path=${1:-"${S}/Cargo.toml"}
	if [[ $# -gt 1 ]]; then
		die "Usage: cargo_update_crates [path_to_Cargo.toml]"
	fi
	[[ -f ${path} ]] || die "${path} does not exist"

	set -- "${CARGO}" update --offline --manifest-path "${path}"
	einfo "${@}"
	# This is overkill (we're not using rustflags (etc) here) but it's safe.
	cargo_env "${@}" || die "Failed to update crates"
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry.
cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" "${S}" || die

	local archive shasum pkg
	local crates=()
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				crates+=( "${archive}" )
				;;
			*)
				unpack "${archive}"
				;;
		esac
	done

	if [[ ${PKGBUMPING} != ${PVR} && ${crates[@]} ]]; then
		pushd "${DISTDIR}" >/dev/null || die

		ebegin "Unpacking crates"
		printf '%s\0' "${crates[@]}" |
			xargs -0 -P "$(makeopts_jobs)" -n 1 -t -- \
				tar -x -C "${ECARGO_VENDOR}" -f
		assert
		eend $?

		while read -d '' -r shasum archive; do
			pkg=${archive%.crate}
			cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json || die
			{
				"package": "${shasum}",
				"files": {}
			}
			EOF

			# if this is our target package we need it in ${WORKDIR} too
			# to make ${S} (and handle any revisions too)
			if [[ ${P} == ${pkg}* ]]; then
				tar -xf "${archive}" -C "${WORKDIR}" || die
			fi
		done < <(sha256sum -z "${crates[@]}" || die)

		popd >/dev/null || die

		if [[ ${#crates[@]} -ge 300 ]]; then
			eqawarn "This package uses a very large number of CRATES.  Please provide"
			eqawarn "a crate tarball instead and fetch it via SRC_URI.  You can use"
			eqawarn "'pycargoebuild --crate-tarball' to create one."
		fi
	fi

	cargo_gen_config
}

# @FUNCTION: cargo_live_src_unpack
# @DESCRIPTION:
# Runs 'cargo fetch' and vendors downloaded crates for offline use, used in live ebuilds.
# NOTE: might require passing --frozen to cargo_src_configure if git dependencies are used.
cargo_live_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	[[ "${PV}" == *9999* ]] || die "${FUNCNAME} only allowed in live/9999 ebuilds"
	[[ "${EBUILD_PHASE}" == unpack ]] || die "${FUNCNAME} only allowed in src_unpack"

	mkdir -p "${S}" || die
	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${ECARGO_HOME}" || die

	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	: "${ECARGO_REGISTRY_DIR:=${distdir}/cargo-registry}"

	local offline="${ECARGO_OFFLINE:-${EVCS_OFFLINE}}"

	if [[ ! -d ${ECARGO_REGISTRY_DIR} && ! ${offline} ]]; then
		(
			addwrite "${ECARGO_REGISTRY_DIR}"
			mkdir -p "${ECARGO_REGISTRY_DIR}"
		) || die "Unable to create ${ECARGO_REGISTRY_DIR}"
	fi

	if [[ ${offline} ]]; then
		local subdir
		for subdir in cache index src; do
			if [[ ! -d ${ECARGO_REGISTRY_DIR}/registry/${subdir} ]]; then
				eerror "Networking activity has been disabled via ECARGO_OFFLINE or EVCS_OFFLINE"
				eerror "However, no valid cargo registry available at ${ECARGO_REGISTRY_DIR}"
				die "Unable to proceed with ECARGO_OFFLINE/EVCS_OFFLINE."
			fi
		done
	fi

	if [[ ${EVCS_UMASK} ]]; then
		local saved_umask=$(umask)
		umask "${EVCS_UMASK}" || die "Bad options to umask: ${EVCS_UMASK}"
	fi

	pushd "${S}" > /dev/null || die

	# Respect user settings before cargo_gen_config is called.
	if [[ ! ${CARGO_TERM_COLOR} ]]; then
		[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && export CARGO_TERM_COLOR=never
		local unset_color=true
	fi
	if [[ ! ${CARGO_TERM_VERBOSE} ]]; then
		export CARGO_TERM_VERBOSE=true
		local unset_verbose=true
	fi

	# Let cargo fetch to system-wide location.
	# It will keep directory organized by itself.
	addwrite "${ECARGO_REGISTRY_DIR}"
	export CARGO_HOME="${ECARGO_REGISTRY_DIR}"

	# Absence of quotes around offline arg is intentional, as cargo bails out if it encounters ''
	einfo "cargo fetch ${offline:+--offline}"
	cargo fetch ${offline:+--offline} || die #nowarn

	# Let cargo copy all required crates to "${WORKDIR}" for offline use in later phases.
	einfo "cargo vendor ${offline:+--offline} ${ECARGO_VENDOR}"
	cargo vendor ${offline:+--offline} "${ECARGO_VENDOR}" || die #nowarn

	# Users may have git checkouts made by cargo.
	# While cargo vendors the sources, it still needs git checkout to be present.
	# Copying full dir is overkill, so just symlink it (guard w/ -L to keep idempotent).
	if [[ -d ${ECARGO_REGISTRY_DIR}/git && ! -L "${ECARGO_HOME}/git" ]]; then
		ln -sv "${ECARGO_REGISTRY_DIR}/git" "${ECARGO_HOME}/git" || die
	fi

	popd > /dev/null || die

	# Restore settings if needed.
	[[ ${unset_color} ]] && unset CARGO_TERM_COLOR
	[[ ${unset_verbose} ]] && unset CARGO_TERM_VERBOSE
	if [[ ${saved_umask} ]]; then
		umask "${saved_umask}" || die
	fi

	# After following calls, cargo will no longer use ${ECARGO_REGISTRY_DIR} as CARGO_HOME
	# It will be forced into offline mode to prevent network access.
	# But since we already vendored crates and symlinked git, it has all it needs to build.
	unset CARGO_HOME
	cargo_gen_config
}

# @FUNCTION: cargo_src_configure
# @DESCRIPTION:
# Configure cargo package features and arguments.
# Extra positional arguments supplied to this function
# will be passed to cargo in all phases.
# Make sure all cargo subcommands support flags passed here.
#
# Example of a package that explicitly builds only 'baz' binary and
# enables 'barfeature' and optional 'foo' feature.
# It will pass '--features barfeature --features foo --bin baz'
# in src_{compile,test,install}.
#
# @CODE
# src_configure() {
#	local myfeatures=(
#		barfeature
#		$(usev foo)
#	)
# 	cargo_src_configure --bin baz
# }
# @CODE
#
# In some cases crates may need the '--no-default-features' option,
# as there is no way to disable a single default feature, except disabling all.
# It can be passed directly to cargo_src_configure.
#
# Some live/9999 ebuild may need the '--frozen' option, if git crates
# are used.
# Otherwise src_install phase may query network again and fail.
cargo_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${myfeatures} ]] && declare -a myfeatures=()
	local myfeaturestype=$(declare -p myfeatures 2>&-)
	if [[ "${myfeaturestype}" != "declare -a myfeatures="* ]]; then
		die "myfeatures must be declared as array"
	fi

	# transform array from simple feature list
	# to multiple cargo args:
	# --features feature1 --features feature2 ...
	# this format is chosen because 2 other methods of
	# listing features (space OR comma separated) require
	# more fiddling with strings we'd like to avoid here.
	myfeatures=( ${myfeatures[@]/#/--features } )

	readonly ECARGO_ARGS=( ${myfeatures[@]} ${@} ${ECARGO_EXTRA_ARGS} )

	[[ ${ECARGO_ARGS[@]} ]] && einfo "Configured with: ${ECARGO_ARGS[@]}"
}

# @FUNCTION: cargo_env
# @USAGE: Command with its arguments
# @DESCRIPTION:
# Run the given command under an environment needed for performing tasks with
# Cargo such as building. RUSTFLAGS are appended to additional flags set here.
# Ensure these are set consistently between Cargo invocations, otherwise
# rebuilds will occur. Project-specific rustflags set against [build] will not
# take affect due to Cargo limitations, so add these to your ebuild's RUSTFLAGS
# if they seem important.
cargo_env() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${_CARGO_GEN_CONFIG_HAS_RUN} ]] || \
		die "FATAL: please call cargo_gen_config before using ${FUNCNAME}"

	# Shadow flag variables so that filtering below remains local.
	local flag
	for flag in $(all-flag-vars); do
		local -x "${flag}=${!flag}"
	done

	# Rust extensions are incompatible with C/C++ LTO compiler see e.g.
	# https://bugs.gentoo.org/910220
	filter-lto

	tc-export AR CC CXX PKG_CONFIG

	# Set vars for cc-rs crate.
	local -x \
		HOST_AR=$(tc-getBUILD_AR)
		HOST_CC=$(tc-getBUILD_CC)
		HOST_CXX=$(tc-getBUILD_CXX)
		HOST_CFLAGS=${BUILD_CFLAGS}
		HOST_CXXFLAGS=${BUILD_CXXFLAGS}

	# Unfortunately, Cargo is *really* bad at handling flags. In short, it uses
	# the first of the RUSTFLAGS env var, any target-specific config, and then
	# any generic [build] config. It can merge within the latter two types from
	# different sources, but it will not merge across these different types, so
	# if a project sets flags under [target.'cfg(all())'], it will override any
	# flags we set under [build] and vice-versa.
	#
	# It has been common for users and ebuilds to set RUSTFLAGS, which would
	# have overridden whatever a project sets anyway, so the least-worst option
	# is to include those RUSTFLAGS in target-specific config here, which will
	# merge with any the project sets. Only flags in generic [build] config set
	# by the project will be lost, and ebuilds will need to add those to
	# RUSTFLAGS themselves if they are important.
	#
	# We could potentially inspect a project's generic [build] config and
	# reapply those flags ourselves, but that would require a proper toml parser
	# like tomlq, it might lead to confusion where projects also have
	# target-specific config, and converting arrays to strings may not work
	# well. Nightly features to inspect the config might help here in future.
	#
	# As of Rust 1.80, it is not possible to set separate flags for the build
	# host and the target host when cross-compiling. The flags given are applied
	# to the target host only with no flags being applied to the build host. The
	# nightly host-config feature will improve this situation later.
	#
	# The default linker is "cc" so override by setting linker to CC in the
	# RUSTFLAGS. The given linker cannot include any arguments, so split these
	# into link-args along with LDFLAGS.
	#
	# Rust defaults to static linking (-C target-feature=+crt-static) on musl
	# targets. We already patch dev-lang/rust to always prefer dynamic linking,
	# but to ensure that behavior with dev-lang/rust-bin, set the opposite option
	# (-C target-feature=-crt-static) in RUSTFLAGS.
	local -x CARGO_BUILD_TARGET=$(rust_abi)
	local TRIPLE=${CARGO_BUILD_TARGET//-/_}
	local TRIPLE=${TRIPLE^^} LD_A=( $(tc-getCC) ${LDFLAGS} )
	local -Ix CARGO_TARGET_"${TRIPLE}"_RUSTFLAGS+=" -C strip=none -C linker=${LD_A[0]} -C target-feature=-crt-static"
	[[ ${#LD_A[@]} -gt 1 ]] && local CARGO_TARGET_"${TRIPLE}"_RUSTFLAGS+="$(printf -- ' -C link-arg=%s' "${LD_A[@]:1}")"
	local CARGO_TARGET_"${TRIPLE}"_RUSTFLAGS+=" ${RUSTFLAGS}"

	(
		# These variables will override the above, even if empty, so unset them
		# locally. Do this in a subshell so that they remain set afterwards.
		unset CARGO_BUILD_RUSTFLAGS CARGO_ENCODED_RUSTFLAGS RUSTFLAGS

		"${@}"
	)
}

# @FUNCTION: cargo_src_compile
# @DESCRIPTION:
# Build the package using cargo build.
cargo_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z "${CARGO}" ]]; then
		die "CARGO is not set; was rust_pkg_setup run?"
	fi

	set -- "${CARGO}" build $(usex debug "" --release) ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	cargo_env "${@}" || die "cargo build failed"
}

# @FUNCTION: cargo_src_install
# @DESCRIPTION:
# Installs the binaries generated by cargo.
# In some cases workspaces need an alternative --path parameter.
# Defaults to '--path ./' if no path is specified.
# '--path ./somedir' can be passed directly to cargo_src_install.
cargo_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z "${CARGO}" ]]; then
		die "CARGO is not set; was rust_pkg_setup run?"
	fi

	set -- "${CARGO}" install $(has --path ${@} || echo --path ./) \
		--root "${ED}/usr" \
		${GIT_CRATES[@]:+--frozen} \
		$(usex debug --debug "") \
		${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	cargo_env "${@}" || die "cargo install failed"

	rm -f "${ED}/usr/.crates.toml" || die
	rm -f "${ED}/usr/.crates2.json" || die
}

# @FUNCTION: cargo_src_test
# @DESCRIPTION:
# Test the package using cargo test.
cargo_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z "${CARGO}" ]]; then
		die "CARGO is not set; was rust_pkg_setup run?"
	fi

	set -- "${CARGO}" test $(usex debug "" --release) ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	cargo_env "${@}" || die "cargo test failed"
}

fi

if [[ ! ${CARGO_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_unpack src_configure src_compile src_install src_test
fi
