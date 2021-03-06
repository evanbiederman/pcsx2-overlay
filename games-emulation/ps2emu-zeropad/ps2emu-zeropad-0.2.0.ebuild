# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils games autotools multilib

DESCRIPTION="PS2Emu pad plugin"
HOMEPAGE="http://www.pcsx2.net/"
PCSX2_VER="0.9.6"
SRC_URI="http://www.pcsx2.net/files/12310 -> Pcsx2_${PCSX2_VER}_source.7z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug joystick"
RESTRICT="primaryuri"

DEPEND="
	app-arch/p7zip
	x86? (
		>=x11-libs/gtk+-2
		x11-proto/xproto
		joystick? ( media-libs/libsdl[joystick] )
	)
	amd64? (
	    app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-gtklibs
		joystick? ( app-emulation/emul-linux-x86-sdl )
	)"

RDEPEND="${DEPEND}
	|| ( games-emulation/pcsx2 games-emulation/pcsx2-playground )"

S="${WORKDIR}/rc_${PCSX2_VER}/plugins/zeropad"

pkg_setup() {
	if use amd64 && ! has_multilib_profile; then
		eerror "You must be on a multilib profile to use pcsx2!"
		die "No multilib profile."
	fi
	use amd64 && multilib_toolchain_setup x86
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-consistent-naming.patch"
	epatch "${FILESDIR}/${PN}-custom-cflags.patch"
	epatch "${FILESDIR}/${PN}-add-joystick.patch"

	eautoreconf -v --install || die
}

src_configure() {
	egamesconf \
		$(use_enable debug) \
		$(use_enable joystick) \
		|| die
}

src_install() {
	exeinto "$(games_get_libdir)/ps2emu/plugins"
	newexe libZeroPAD.so.* libZeroPad.so || die
	prepgamesdirs
}
