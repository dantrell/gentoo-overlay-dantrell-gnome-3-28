# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-backgrounds"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="vanilla-live"

RDEPEND="!<x11-themes/gnome-themes-standard-3.14"
DEPEND="
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
"

src_prepare() {
	if ! use vanilla-live; then
		cp "${FILESDIR}"/"${PN}"-3.14.1-restore-3.10-backgrounds/* "${S}"/backgrounds

		# From GNOME:
		# 	https://gitlab.gnome.org/GNOME/gnome-backgrounds/commit/acdebed0c93b785f81b2adf1d136178eac86ce80
		eapply -R "${FILESDIR}"/${PN}-3.27.90-build-remove-adwaita-lock-jpg.patch
	fi

	gnome2_src_prepare
}
