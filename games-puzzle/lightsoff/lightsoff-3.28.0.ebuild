# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 vala

DESCRIPTION="Turn off all the lights"
HOMEPAGE="https://wiki.gnome.org/Apps/Lightsoff"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=x11-libs/gtk+-3.13.4:3
	>=media-libs/clutter-1.14.0:1.0
	>=media-libs/clutter-gtk-1.5.5:1.0
	>=gnome-base/librsvg-2.32.0:2
"
# libxml2:2 needed for glib-compile-resources xml-stripblanks attributes
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
	vala_src_prepare
}
