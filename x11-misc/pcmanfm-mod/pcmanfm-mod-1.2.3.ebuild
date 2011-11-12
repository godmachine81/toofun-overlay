# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pcmanfm/pcmanfm-0.9.9.ebuild,v 1.6 2011/09/18 16:49:47 maekke Exp $

EAPI=4

inherit autotools fdo-mime

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/pcmanfm-mod/pcmanfm-mod-1.2.3.tar.xz"

KEYWORDS="~alpha amd64 arm ~ppc x86 ~x86-linux"
LICENSE="GPL-2"
SLOT="0"
IUSE="debug -hal +startup-notification +gksu"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.22.1:2
	hal? ( sys-apps/hal )"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/pcmanfm
	dev-util/desktop-file-utils
	virtual/eject
	virtual/freedesktop-icon-theme
	virtual/fam
	x11-misc/shared-mime-info
	startup-notification? ( x11-libs/startup-notification )
	gksu? ( x11-libs/gksu )"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext"	

src_prepare() {
	# Fix desktop icons
	sed -i -e "/MimeType/s:=.*normal;:=:" "${S}"/data/${PN}.desktop \
		|| die "failed to fix desktop icon"
	# drop -O0. Bug #382265
	sed -i -e "s:-O0::" "${S}"/configure.ac
	eautoreconf

}

src_configure() {

	econf \
		$(use_enable hal) \ 
		--sysconfdir="${EPREFIX}/etc" \
		$(use_enable debug)
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog 'PCmanFM can optionally support the menu://applications/ location.'
	elog 'You should install lxde-base/lxmenu-data for that	functionality.'
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
 