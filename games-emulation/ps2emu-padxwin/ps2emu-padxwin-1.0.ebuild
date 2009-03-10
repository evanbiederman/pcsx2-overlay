# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils games multilib flag-o-matic

PCSX2="pcsx2-0.9.4"

DESCRIPTION="PS2Emu PAD plugin"
HOMEPAGE="http://www.pcsx2.net/"
SRC_URI="mirror://sourceforge/pcsx2/${PCSX2}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=">=x11-libs/gtk+-2"

RDEPEND="${DEPEND}
	|| ( games-emulation/pcsx2 games-emulation/pcsx2-playground )"

S="${WORKDIR}/${PCSX2}/plugins/pad/PADwin/Src"

pkg_setup() {
	games_pkg_setup

	if use amd64 && ! has_m32; then
		eerror "You must be on a multilib profile to use pcsx2!"
		die "No multilib profile."
	fi
	ABI="x86"
	ABI_ALLOW="x86"
	append-flags -m32
}

src_unpack() {
	unpack ${A}
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
