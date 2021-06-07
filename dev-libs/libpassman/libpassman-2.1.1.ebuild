# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Library for interacting with passman++ database files."
HOMEPAGE="https://github.com/binex-dsk/libpassman"
SRC_URI="https://github.com/binex-dsk/libpassman/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/botan"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}/${P}"

src_prepare() {
	default
	cmake_src_prepare
}

src_compile() {
	cmake . -DCMAKE_INSTALL_PREFIX="/usr"
	emake
}

src_install() {
	emake DESTDIR="${D}" install
}
