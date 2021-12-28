# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake desktop

DESCRIPTION="Minecraft launcher with ability to manage multiple instances."
HOMEPAGE="https://github.com/PolyMC/PolyMC"

EGIT_REPO_URI="https://github.com/PolyMC/PolyMC https://github.com/MultiMC/libnbtplusplus https://github.com/PolyMC/quazip"

S="${WORKDIR}/${PN}-${PV}"

KEYWORDS="amd64 x86 ~arm64 ~ppc64"

LICENSE="Apache"
SLOT="0"

BDEPEND="virtual/jdk:1.8 media-gfx/inkscape media-gfx/imagemagick media-libs/libicns"
DEPEND="dev-qt/qtcore:5 virtual/jre sys-libs/zlib virtual/opengl"
RDEPEND="${DEPEND}"

src_unpack() {
	default
	git-r3_src_unpack
}

src_prepare() {
	git checkout 6a4130c9149deb029b496c81e3b874ad834c54b7 -- launcher/resources/{{OSX,flat,iOS,multimc,pe_{blue,colored,dark,light}}/scalable/multimc.svg,multimc/{32x32,128x128}/instances/infinity.png}

	for f in launcher/resources/{OSX,flat,iOS,multimc,pe_{blue,colored,dark,light}}/scalable
	do
	mv "$f/multimc.svg" "$f/launcher.svg"
	done

	cp launcher/resources/multimc/scalable/launcher.svg program_info/logo.svg

	git submodule init
	git config submodule.libnbtplusplus.url "${WORKDIR}/libnbtplusplus"
	git config submodule.quazip.url "${WORKDIR}/quazip"
	git submodule update

	default
	cmake_src_prepare
}

src_compile() {
	mkdir -p build

	cd build
	cmake -DCMAKE_BUILD_TYPE=None \
		-DCMAKE_INSTALL_PREFIX="/usr" \
		-DLauncher_LAYOUT=lin-system \
		-DLauncher_APP_BINARY_NAME="${PN}" \
		-DLauncher_SHARE_DEST_DIR="share/${PN}" \
		-DLauncher_LIBRARY_DEST_DIR="$(get_libdir)" \
		..
	emake

}

src_install() {
	cd "build"
	emake install DESTDIR="${D}"
	cd ..

	newicon "program_info/logo.svg" polymc.svg
	domenu "${FILESDIR}/${PN}.desktop"
}