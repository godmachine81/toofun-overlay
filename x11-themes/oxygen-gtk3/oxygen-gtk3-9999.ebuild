# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/oxygen-gtk/oxygen-gtk-1.1.1.ebuild,v 1.1 2011/07/17 16:25:52 scarabeus Exp $

EAPI=4

inherit cmake-utils git-2

DESCRIPTION="Official GTK+ port of KDE's Oxygen widget style"
HOMEPAGE="https://projects.kde.org/projects/playground/artwork/oxygen-gtk"
SRC_URI=""
EGIT_REPO_URI="git://anongit.kde.org/oxygen-gtk"
EGIT_BRANCH="gtk3"

LICENSE="LGPL-2.1"
KEYWORDS=""
SLOT="0"
IUSE="debug doc"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/pango
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
"

DOCS=(AUTHORS README)

src_install() {
	if use doc; then
		{ cd "${S}" && doxygen Doxyfile; } || die "Generating documentation failed"
		HTML_DOCS=( "${S}/doc/html/" )
	fi

	cmake-utils_src_install

	cat <<-EOF > 99oxygen-gtk3
CONFIG_PROTECT="${EPREFIX}/usr/share/themes/oxygen-gtk/gtk-3.0"
EOF
	doenvd 99oxygen-gtk3
}
