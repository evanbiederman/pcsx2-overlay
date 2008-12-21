# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

ESVN_REPO_URI="http://pcsx2.googlecode.com/svn/trunk/plugins/usb/USBnull"
inherit eutils games subversion

DESCRIPTION="PS2Emu null USB plugin"
HOMEPAGE="http://www.pcsx2.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"
RESTRICT="nomirror"

DEPEND=">=x11-libs/gtk+-2"

RDEPEND="${DEPEND}
	|| ( games-emulation/pcsx2 games-emulation/pcsx2-playground )"

S="${WORKDIR}/USBnull"

src_unpack() {
	subversion_src_unpack
	S="${S}/Linux"
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-custom-cflags.patch
}

src_install() {
	exeinto "$(games_get_libdir)/ps2emu/plugins"
	doexe libUSBnull.so || die
	exeinto "$(games_get_libdir)/ps2emu/plugins/cfg"
	doexe cfgUSBnull || die
	if use doc; then
		dodoc ../ReadMe.txt || die
	fi
	prepgamesdirs
}
