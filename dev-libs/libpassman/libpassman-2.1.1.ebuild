# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for interacting with passman++ database files."
HOMEPAGE="https://github.com/binex-dsk/${PN}"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/binex-dsk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P}"
	KEYWORDS="amd64 x86 ~arm64 ~ppc64"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/binex-dsk/${PN}"
	CMAKE_BUILD_TYPE="Debug"
fi

LICENSE="GPL-3"
SLOT="0"

DEPEND="dev-libs/botan dev-qt/qtbase"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	cmake_src_prepare
}

src_configure() {
    local mycmakeargs=(
	    -DCMAKE_INSTALL_PREFIX="/usr"
	)

	cmake_src_configure
}
