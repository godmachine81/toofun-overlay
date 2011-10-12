# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/firefox-bin/firefox-bin-6.0.ebuild,v 1.2 2011/08/21 18:30:34 nirbheek Exp $

EAPI="3"

inherit eutils mozilla-launcher multilib mozextension


MY_PV="9.0a1"
MY_PN="firefox"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Firefox Web Browser"
#FTP_URI="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/"
SRC_URI="ftp://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/firefox-9.0a1.en-US.linux-x86_64.tar.bz2"
HOMEPAGE="http://www.mozilla.com/firefox"
RESTRICT="strip mirror"

KEYWORDS="-* ~amd64 ~x86"
SLOT="0"
LICENSE="|| ( MPL-1.1 GPL-2 LGPL-2.1 )"
IUSE="startup-notification"

DEPENDD="app-arch/unzip"
RDEPEND="dev-libs/dbus-glib
	x11-libs/libXrender
	x11-libs/libXt
	x11-libs/libXmu

	>=x11-libs/gtk+-2.2:2
	>=media-libs/alsa-lib-1.0.16
"

S="${WORKDIR}/${MY_PN}"


src_unpack() {
	unpack ${A}

}

src_install() {
	declare MOZILLA_FIVE_HOME=/opt/${MY_PN}

	# Install icon and .desktop for menu entry
	newicon "${S}"/chrome/icons/default/default48.png ${PN}-icon.png
	domenu "${FILESDIR}"/${PN}.desktop

	# Add StartupNotify=true bug 237317
	if use startup-notification; then
		echo "StartupNotify=true" >> "${D}"/usr/share/applications/${PN}.desktop
	fi

	# Install firefox in /opt/firefox
	dodir ${MOZILLA_FIVE_HOME%/*}
	mv "${S}" "${D}"${MOZILLA_FIVE_HOME} || die

	# Fix prefs that make no sense for a system-wide install
	insinto ${MOZILLA_FIVE_HOME}/defaults/pref/
	doins "${FILESDIR}"/${PN}-prefs.js || die

	#linguas
	for X in "${linguas[@]}"; do
		[[ ${X} != "en" ]] && xpi_install "${WORKDIR}"/"${P//}-${X}"
	done

	local LANG=${linguas%% *}
	if [[ -n ${LANG} && ${LANG} != "en" ]]; then
		elog "Setting default locale to ${LANG}"
		echo "pref(\"general.useragent.locale\", \"${LANG}\");" \
			>> "${D}${MOZILLA_FIVE_HOME}"/defaults/pref/${PN}-prefs.js || \
			die "sed failed to change locale"
	fi

	# Create /usr/bin/firefox-bin
	dodir /usr/bin/
	cat <<-EOF >"${D}"/usr/bin/${PN}
	#!/bin/sh
	unset LD_PRELOAD
	LD_LIBRARY_PATH="/opt/firefox/"
	GTK_PATH=/usr/lib/gtk-2.0/
	exec /opt/${MY_PN}/${MY_PN} "\$@"
	EOF
	fperms 0755 /usr/bin/${PN}

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	doins "${FILESDIR}"/10${PN} || die

	ln -sfn "/usr/$(get_libdir)/nsbrowser/plugins" \
			"${D}${MOZILLA_FIVE_HOME}/plugins" || die
}

pkg_postinst() {
	if ! has_version 'gnome-base/gconf' || ! has_version 'gnome-base/orbit' \
		|| ! has_version 'net-misc/curl'; then
		einfo
		einfo "For using the crashreporter, you need gnome-base/gconf,"
		einfo "gnome-base/orbit and net-misc/curl emerged."
		einfo
	fi
	if has_version 'net-misc/curl[nss]'; then
		einfo
		einfo "Crashreporter won't be able to send reports"
		einfo "if you have curl emerged with the nss USE-flag"
		einfo
	fi
}

pkg_postrm() {
	update_mozilla_launcher_symlinks
}
