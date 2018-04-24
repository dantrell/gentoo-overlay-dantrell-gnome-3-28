# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 meson

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://help.gnome.org/users/gnome-system-monitor/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="systemd X"

RDEPEND="
	>=dev-libs/glib-2.55.0:2
	>=gnome-base/libgtop-2.37.2:2=
	>=x11-libs/gtk+-3.22:3[X(+)]
	>=dev-cpp/gtkmm-3.3.18:3.0
	>=dev-cpp/glibmm-2.46:2
	>=dev-libs/libxml2-2.0:2
	>=gnome-base/librsvg-2.35:2
	systemd? ( >=sys-apps/systemd-44:0= )
	X? ( >=x11-libs/libwnck-2.91.0:3 )
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.41.0
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	# From GNOME:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=793598
	eapply "${FILESDIR}"/${PN}-3.28.1-support-meson.patch

	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-D wnck=$(usex X true false)
		-D systemd=$(usex systemd true false)
	)
	meson_src_configure
}
