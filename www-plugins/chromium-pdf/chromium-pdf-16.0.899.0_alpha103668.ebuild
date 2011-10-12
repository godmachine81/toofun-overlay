# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib versionator

DESCRIPTION="PDF plugin from google-chrome"
HOMEPAGE="http://www.google.com/chrome"

MY_PN="google-chrome-unstable"
MY_PV="${PV/_alpha/-r}"
MY_P="${MY_PN}_${MY_PV}"

SRC_URI="amd64? ( http://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb )
	x86? ( http://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_i386.deb )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="!app-arch/deb2targz"
RDEPEND="=www-client/chromium-$(get_major_version)*"

S="${WORKDIR}"
QA_PREBUILT="usr/$(get_libdir)/chromium-browser/libpdf.so"

src_unpack() {
	default
	unpack ./data.tar.lzma
}

src_install() {
	insinto "/usr/$(get_libdir)/chromium-browser"
	doins opt/google/chrome/libpdf.so
}
