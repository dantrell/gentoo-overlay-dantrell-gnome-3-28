# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.53.4:2
	>=x11-libs/gtk+-3.11.4:3
	>=gnome-extra/evolution-data-server-3.13.90:=
	>=net-libs/webkit-gtk-2.10.0:4
	net-libs/gnome-online-accounts:=
	dev-libs/libxml2:2
	>=app-misc/tracker-2:=
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-D zeitgeist=false
		-D update_mimedb=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-notes/commit/0b89cde5c61febe581e804360442a4fa489ddde6
	insinto /usr/share/glib-2.0/schemas
	doins "${S}"/data/org.gnome.bijiben.gschema.xml
}
