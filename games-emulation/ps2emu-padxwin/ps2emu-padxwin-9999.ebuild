# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="https://pcsx2.svn.sourceforge.net/svnroot/pcsx2/plugins/pad/PADwin"
inherit eutils games subversion

DESCRIPTION="PS2Emu PAD plugin"
HOMEPAGE="http://www.pcsx2.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"

DEPEND=">=x11-libs/gtk+-2"

RDEPEND="${DEPEND}
	games-emulation/pcsx2"

S="${WORKDIR}/${PCSX2}/PADwin"

src_unpack() {
	subversion_src_unpack
	S="${S}/Src"
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-custom-cflags.patch
}

src_install() {
	exeinto "$(games_get_libdir)/ps2emu/plugins"
	doexe libPADwin.so || die
	if use doc; then
		dodoc ../ReadMe.txt || die
	fi
	prepgamesdirs
}