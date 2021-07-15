# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
WX_GTK_VER="3.0-gtk3"

inherit cmake flag-o-matic wxwidgets xdg

DESCRIPTION="Audacity fork without any telemetry"
HOMEPAGE="https://github.com/Sneeds-Feed-and-Seed/${PN}"

if [[ "${PV}" != 9999 ]] ; then
	SRC_URI="https://github.com/Sneeds-Feed-and-Seed/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	         $SRC_URI"
	S="${WORKDIR}/${P}"
    KEYWORDS="amd64 ~arm64 ~mips ppc ppc64 x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Sneeds-Feed-and-Seed/${PN}"
	CMAKE_BUILD_TYPE="Debug"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa ffmpeg +flac id3tag jack +ladspa +lv2 mad ogg oss
	portmidi +portmixer portsmf sbsms twolame vamp +vorbis +vst"

RESTRICT="test"

RDEPEND="dev-libs/expat
	media-libs/libsndfile
	media-libs/libsoundtouch
	media-libs/portaudio[alsa?]
	media-libs/soxr
	>=media-sound/lame-3.100-r3
	x11-libs/wxGTK[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac[cxx] )
	id3tag? ( media-libs/libid3tag )
	jack? ( virtual/jack )
	lv2? (
		dev-libs/serd
		dev-libs/sord
		>=media-libs/lilv-0.24.6-r2
		media-libs/lv2
		media-libs/sratom
		media-libs/suil
	)
	mad? ( >=media-libs/libmad-0.15.1b )
	ogg? ( media-libs/libogg )
	portmidi? ( media-libs/portmidi )
	sbsms? ( media-libs/libsbsms )
	twolame? ( media-sound/twolame )
	vamp? ( media-libs/vamp-plugin-sdk )
	vorbis? ( media-libs/libvorbis )
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	sys-devel/gettext
	virtual/pkgconfig
"

REQUIRED_USE="portmidi? ( portsmf )"

src_prepare() {
	cmake_src_prepare

	if [[ "${PV}" == 9999 ]]
	then
		git checkout conan_removal # conan bad
	fi
}

src_configure() {
	setup-wxwidgets
	append-cxxflags -std=gnu++14

	# * always use system libraries if possible
	# * options listed in the order that cmake-gui lists them
	local mycmakeargs=(
#		--disable-dynamic-loading
		-Dsneedacity_lib_preference=system
		-Dsneedacity_use_expat=system
		-Dsneedacity_use_ffmpeg=$(usex ffmpeg loaded off)
		-Dsneedacity_use_flac=$(usex flac system off)
		-Dsneedacity_use_id3tag=$(usex id3tag system off)
		-Dsneedacity_use_ladspa=$(usex ladspa)
		-Dsneedacity_use_lame=system
		-Dsneedacity_use_lv2=$(usex lv2 system off)
		-Dsneedacity_use_mad=$(usex mad system off)
		-Dsneedacity_use_midi=$(usex portmidi system off)
		-Dsneedacity_use_nyquist=local
		-Dsneedacity_use_ogg=$(usex ogg system off)
		-Dsneedacity_use_pa_alsa=$(usex alsa)
		-Dsneedacity_use_pa_jack=$(usex jack linked off)
		-Dsneedacity_use_pa_oss=$(usex oss)
		#-Dsneedacity_use_pch leaving it to the default behavior
		-Dsneedacity_use_portaudio=local # only 'local' option is present
		-Dsneedacity_use_portmixer=$(usex portmixer local off)
		-Dsneedacity_use_portsmf=$(usex portsmf local off)
		-Dsneedacity_use_sbsms=$(usex sbsms local off) # no 'system' option in configuration?
		-Dsneedacity_use_sndfile=system
		-Dsneedacity_use_soundtouch=system
		-Dsneedacity_use_soxr=system
		-Dsneedacity_use_twolame=$(usex twolame system off)
		-Dsneedacity_use_vamp=$(usex vamp system off)
		-Dsneedacity_use_vorbis=$(usex vorbis system off)
		-Dsneedacity_use_vst=$(usex vst)
		-Dsneedacity_use_wxwidgets=local # required, sneedacity needs wx >=3.1, Gentoo ships up to 3.0.5 currently
	)

	cmake_src_configure

	# if git is not installed, this (empty) file is not being created and the compilation fails
	# so we create it manually
	touch "${BUILD_DIR}/src/private/RevisionIdent.h" || die "failed to create file"
}

src_install() {
	cmake_src_install
}
