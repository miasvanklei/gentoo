# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
ROCM_VERSION=${PV}

inherit cmake flag-o-matic prefix python-any-r1 rocm toolchain-funcs

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm/roctracer"
SRC_URI="https://github.com/ROCm/roctracer/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/roctracer-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	dev-libs/rocr-runtime
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
	dev-python/cppheaderparser[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-with-tests.patch"
	"${FILESDIR}/${PN}-6.3.0-fix-prettyprinter.patch"
)

python_check_deps() {
	python_has_version "dev-python/cppheaderparser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

pkg_setup() {
	python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	hprefixify script/*.py
	eapply $(prefixify_ro "${FILESDIR}/${PN}"-5.3.3-rocm-path.patch)

	# Install libs directly into /usr/lib64
	sed -e "s:\${CMAKE_INSTALL_LIBDIR}/\${PROJECT_NAME}:\${CMAKE_INSTALL_LIBDIR}:g" \
		-i src/CMakeLists.txt plugin/file/CMakeLists.txt || die

	# Remove all install commands for tests
	sed -E '/^ *install\(.+/d' -i test/CMakeLists.txt || die

	# Test fails: https://github.com/ROCm/roctracer/issues/109
	sed '/load_unload_reload_test/d' -i test/run.sh || die

	# Fix search path for HIP cmake
	sed -e "s,\${ROCM_PATH}/lib/cmake,/usr/$(get_libdir)/cmake,g" -i test/CMakeLists.txt || die

	# bug #892732
	sed -e 's/-Werror//' -i CMakeLists.txt || die

	# libc++ may have no experimental/filesystem
	sed -e 's|experimental/||' -e 's|experimental::||' \
		-i plugin/file/file.cpp src/hip_stats/hip_stats.cpp \
		src/roctracer/loader.h src/tracer_tool/tracer_tool.cpp || die
}

src_configure() {
	rocm_use_hipcc

	if [[ $(tc-get-cxx-stdlib) == "libc++" ]] ; then
		# https://releases.llvm.org/9.0.0/projects/libcxx/docs/UsingLibcxx.html#using-filesystem
		append-libs "-lc++fs"
	fi

	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${EPREFIX}/usr/$(get_libdir)/cmake/hip"
		-DFILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DWITH_TESTS=$(usex test)
		-DPython3_EXECUTABLE="${PYTHON}"
	)
	use test && mycmakeargs+=(
		-DHIP_ROOT_DIR="${EPREFIX}/usr"
		-DGPU_TARGETS="$(get_amdgpu_flags)"
	)

	cmake_src_configure
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}" || die
	# if LD_LIBRARY_PATH not set, dlopen cannot find correct lib
	LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir):${LD_LIBRARY_PATH}" bash run.sh || die
}

src_install() {
	cmake_src_install

	# remove unneeded copy
	rm -r "${ED}/usr/share/doc/${PF}-asan" || die
}
