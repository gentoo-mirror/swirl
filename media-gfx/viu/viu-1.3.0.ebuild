# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rust-toolchain

DESCRIPTION="Simple terminal image viewer."
HOMEPAGE="https://github.com/atanunq/viu"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/atanunq/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/atanunq/${PN}"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/libc"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

src_compile() {
	cargo build --release --locked
}

src_test() {
	cargo test --release --locked
}

src_install() {
	cd "target/release"
	dobin viu
}
