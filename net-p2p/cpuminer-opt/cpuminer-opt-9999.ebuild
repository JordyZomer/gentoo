# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic systemd

DESCRIPTION="Optimized multi algo CPU miner"
HOMEPAGE="https://github.com/JayDDee/cpuminer-opt"
IUSE="cpu_flags_x86_avx2 cpu_flags_x86_sse2 curl libressl"
LICENSE="GPL-2"
SLOT="0"
REQUIRED_USE="cpu_flags_x86_sse2"
DEPEND="
	dev-libs/gmp:0
	dev-libs/jansson
	curl? ( >=net-misc/curl-7.15[ssl] )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"
RDEPEND="${DEPEND}"
if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/JayDDee/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/JayDDee/${PN}/archive/v${PV}.tar.gz"
fi

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	use cpu_flags_x86_avx2 && append-cflags "-DFOUR_WAY"
	econf --with-crypto $(use_with curl)
}

src_install() {
	default
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto "/etc/${PN}"
	doins cpuminer-conf.json
}
