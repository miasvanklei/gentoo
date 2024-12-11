# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="docs/.doxygen"
DOCS_DEPEND="media-gfx/graphviz"
LLVM_COMPAT=( 18 )
ROCM_VERSION=${PV}

inherit cmake docs edo multiprocessing rocm llvm-r1

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> rocm-${P}.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="BSD"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="benchmark test video_cards_amdgpu"
RESTRICT="!test? ( test )"
REQUIRED_USE="${ROCM_REQUIRED_USE}"

BDEPEND="
	>=dev-build/rocm-cmake-5.3
	video_cards_amdgpu? (
		dev-util/Tensile:${SLOT}
	)
	test? ( dev-cpp/gtest )
"

DEPEND="
	>=dev-cpp/msgpack-cxx-6.0.0
	=dev-util/hip-6*
	test? (
		virtual/blas
		dev-cpp/gtest
		llvm-runtimes/openmp
	)
	benchmark? (
		virtual/blas
		llvm-runtimes/openmp
	)
"

QA_FLAGS_IGNORED="/usr/lib64/rocblas/library/.*"

PATCHES=(
	"${FILESDIR}"/${PN}-5.4.2-cpp_lib_filesystem.patch
	"${FILESDIR}"/${PN}-5.4.2-add-missing-header.patch
	"${FILESDIR}"/${PN}-5.4.2-link-cblas.patch
	"${FILESDIR}"/${PN}-6.0.2-expand-isa-compatibility.patch
	)

src_prepare() {
	cmake_src_prepare
	sed -e "s:,-rpath=.*\":\":" -i clients/CMakeLists.txt || die
}

src_configure() {
	rocm_use_hipcc

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_FILE_REORG_BACKWARD_COMPATIBILITY=OFF
		-DROCM_SYMLINK_LIBS=OFF
		-DAMDGPU_TARGETS="$(get_amdgpu_flags)"
		-DBUILD_WITH_TENSILE="$(usex video_cards_amdgpu)"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS="$(usex test)"
		-DBUILD_CLIENTS_BENCHMARKS="$(usex benchmark)"
		-DBUILD_WITH_PIP=OFF
	)

	if usex video_cards_amdgpu; then
		mycmakeargs+=(
			-DTensile_LOGIC="asm_full"
			-DTensile_COMPILER="hipcc"
			-DTensile_LIBRARY_FORMAT="msgpack"
			-DTensile_CODE_OBJECT_VERSION="default"
			-DTensile_ROOT="${EPREFIX}/usr/share/Tensile"
			-DTensile_CPU_THREADS="$(makeopts_jobs)"
		)
	fi

	cmake_src_configure
}

src_compile() {
	docs_compile
	cmake_src_compile
}

src_test() {
	check_amdgpu
	cd "${BUILD_DIR}"/clients/staging || die
	export ROCBLAS_TEST_TIMEOUT=3600 ROCBLAS_TENSILE_LIBPATH="${BUILD_DIR}/Tensile/library"
	export LD_LIBRARY_PATH="${BUILD_DIR}/clients:${BUILD_DIR}/library/src"
	edob "./${PN,,}-test"
}

src_install() {
	cmake_src_install

	if use benchmark; then
		cd "${BUILD_DIR}" || die
		dolib.a clients/librocblas_fortran_client.a
		dobin clients/staging/rocblas-bench
	fi

	# Stop llvm-strip from removing .strtab section from *.hsaco files,
	# otherwise rocclr/elf/elf.cpp complains with "failed: null sections(STRTAB)" and crashes
	dostrip -x "/usr/$(get_libdir)/rocblas/library/"
}
