# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fish-like autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/${PN}"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/zsh-users/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zsh-users/${PN}"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="app-shells/zsh"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}/${P}"

src_install() {
    insinto /usr/share/zsh/site-functions/
	doins ${PN}{,.plugin}.zsh
}
