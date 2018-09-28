# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson vala

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Calculator"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE=""

# gtksourceview vapi definitions in dev-lang/vala itself are too old, and newer vala removes them
# altogether, thus we need them installed by gtksourceview[vala]
RDEPEND="
	>=dev-libs/glib-2.40:2
	>=x11-libs/gtk+-3.19.3:3
	>=x11-libs/gtksourceview-3.15.1:3.0[vala]
	>=net-libs/libsoup-2.42:2.4
	dev-libs/libxml2:2
	dev-libs/mpc:=
	dev-libs/mpfr:0=
"
DEPEND="${RDEPEND}
	$(vala_depend)
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}
