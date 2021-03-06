# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit multilib toolchain-funcs eutils

IUSE=""

DESCRIPTION="A bunch of LADSPA plugins for audio processing"
HOMEPAGE="http://tap-plugins.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.7.3-cflags-ldflags.patch"
}

src_compile() {
	emake CC=$(tc-getCC) OPT_CFLAGS="${CFLAGS}" EXTRA_LDFLAGS="${LDFLAGS}"
}

src_install() {
	dodoc README CREDITS
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
	insinto /usr/share/ladspa/rdf
	insopts -m0644
	doins *.rdf
}
