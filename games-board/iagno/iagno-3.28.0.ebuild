# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_MIN_API_VERSION="0.28"

inherit gnome2 vala

DESCRIPTION="Dominate the board in a classic version of Reversi"
HOMEPAGE="https://wiki.gnome.org/Apps/Iagno"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2
	>=gnome-base/librsvg-2.32.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.15:3
"
RDEPEND="${COMMON_DEPEND}
	!<x11-themes/gnome-themes-standard-3.14
"
# libxml2:2 needed for glib-compile-resources xml-stripblanks attributes
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}
