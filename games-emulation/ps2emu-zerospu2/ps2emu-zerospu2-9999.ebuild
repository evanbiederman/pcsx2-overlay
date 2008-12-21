# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://pcsx2.googlecode.com/svn/trunk/plugins/spu2/zerospu2"
inherit eutils games subversion autotools

DESCRIPTION="Zero PS2Emu ALSA sound plugin"
HOMEPAGE="http://www.pcsx2.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"
RESTRICT="nomirror"

DEPEND="media-libs/alsa-lib
	>=x11-libs/gtk+-2"

RDEPEND="${DEPEND}
	|| ( games-emulation/pcsx2 games-emulation/pcsx2-playground )"

S="${WORKDIR}/zerospu2"

src_unpack() {
	subversion_src_unpack
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-custom-cflags.patch

	eautoreconf -v --install || die
}

src_compile() {
	egamesconf  \
		$(use_enable debug) \
		|| die

	emake || die
}

src_install() {
	exeinto "$(games_get_libdir)/ps2emu/plugins"
	doexe libZeroSPU2.so.*
	prepgamesdirs
}
