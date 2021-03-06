# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glew/glew-1.5.1.ebuild,v 1.1 2008/12/02 21:10:37 ssuominen Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="BSD GLX SGI-B GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	edos2unix config/config.guess
	sed -i -e 's:-s\b::g' Makefile || die "sed failed."
}

src_compile(){
	if use amd64 && has_multilib_profile; then
		cd "${WORKDIR}"
		mkdir 32bit 64bit
		cp -r "${PN}" 32bit/
		cp -r "${PN}" 64bit/
		S="${WORKDIR}"
		cd 32bit/${PN}
		pwd
		multilib_toolchain_setup x86
		emake LD="$(tc-getCC) ${LDFLAGS}" CC="$(tc-getCC)" \
			POPT="${CFLAGS}" M_ARCH="" AR="$(tc-getAR)" \
			|| die "emake failed."
		multilib_toolchain_setup amd64
		cd "${WORKDIR}/64bit/${PN}"
	fi
	emake LD="$(tc-getCC) ${LDFLAGS}" CC="$(tc-getCC)" \
		POPT="${CFLAGS}" M_ARCH="" AR="$(tc-getAR)" \
		|| die "emake failed."
}

src_install() {
	if use amd64 && has_multilib_profile; then
		cd "${WORKDIR}/32bit/${PN}"
		multilib_toolchain_setup x86
		emake GLEW_DEST="${D}/usr" LIBDIR="${D}/usr/$(get_libdir)" \
			M_ARCH="" install || die "emake install failed."
		multilib_toolchain_setup amd64
		cd "${WORKDIR}/64bit/${PN}"
	fi
	emake GLEW_DEST="${D}/usr" LIBDIR="${D}/usr/$(get_libdir)" \
		M_ARCH="" install || die "emake install failed."

	dodoc README.txt
	dohtml doc/*.{html,css,png,jpg}
}
