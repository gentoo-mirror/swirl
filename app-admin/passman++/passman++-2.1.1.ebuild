# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

_PN="passmanpp"

DESCRIPTION="An extremely simple, minimal, and easy-to-use yet just as secure and powerful GUI password manager."
HOMEPAGE="https://github.com/binex-dsk/${_PN}"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libpassman dev-libs/botan"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}/${_PN}-${PV}"

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
