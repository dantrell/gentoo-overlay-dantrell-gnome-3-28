# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="The Gnome System Monitor"
HOMEPAGE="https://help.gnome.org/users/gnome-system-monitor/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

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
	>=dev-util/intltool-0.41.0
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	# From GNOME:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=786944
	eapply "${FILESDIR}"/${PN}-3.28.1-use-intltool-for-policy.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# XXX: appdata is deprecated by appstream-glib, upstream must upgrade
	gnome2_src_configure \
		$(use_enable systemd) \
		$(use_enable X broken-wnck) \
		APPDATA_VALIDATE="$(type -P true)"
}
