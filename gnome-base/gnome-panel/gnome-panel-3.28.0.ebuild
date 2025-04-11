# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools gnome2 toolchain-funcs

DESCRIPTION="GNOME Flashback panel"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-panel"

LICENSE="GPL-2+ FDL-1.1 LGPL-2.1+"
SLOT="0"
KEYWORDS="*"

IUSE="eds elogind gtk-doc systemd"
REQUIRED_USE="^^ ( elogind systemd )"

RDEPEND="
	>=gnome-base/gnome-desktop-2.91.0:3=
	>=x11-libs/gdk-pixbuf-2.26.0:2
	>=x11-libs/pango-1.15.4
	>=dev-libs/glib-2.45.3:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=x11-libs/libwnck-3.4.6:3
	>=gnome-base/gnome-menus-3.7.90:3
	eds? (
		>=gnome-extra/evolution-data-server-3.5.3:=
		<gnome-extra/evolution-data-server-3.33
	)
	elogind? ( >=sys-auth/elogind-230 )
	systemd? ( >=sys-apps/systemd-230:= )
	>=x11-libs/cairo-1.0.0[X,glib]
	>=dev-libs/libgweather-3.17.1:2=
	>=gnome-base/dconf-0.13.4
	>=x11-libs/libXrandr-1.3.0
	gnome-base/gdm
	x11-libs/libX11
	sys-auth/polkit
	x11-libs/libXi
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	gtk-doc? ( >=dev-build/gtk-doc-am-1.25 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
" # yelp-tools and autoconf-archive for eautoreconf

src_prepare() {
	if use elogind; then
		# From GNOME Without Systemd:
		# 	https://forums.gentoo.org/viewtopic-p-8335598.html#8335598
		sed -e 's/libsystemd/libelogind/g' \
			-i configure.ac || die

		eautoreconf
	fi

	gnome2_src_prepare
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable eds)
		$(use_enable gtk-doc)
		$(use_enable gtk-doc gtk-doc-html)
	)

	# Below elogind MENU_* pkg-config calls need to match up with what upstream has
	# each version (libsystemd replaced with libelogind). Explicit per-version die
	# to force a manual recheck. Only update the explicit version if the
	# "PKG_CHECK_MODULES([MENU], ...)" block did not change; otherwise adjust
	# elogind conditional block below accordingly first.
	if ver_test ${PV} -ne 3.28.0; then
		die "Maintainer has not checked over packages MENU pkg-config deps for elogind support"
	fi

	if use elogind; then
		local pkgconfig="$(tc-getPKG_CONFIG)"
		myconf+=(
			MENU_CFLAGS="$(${pkgconfig} --cflags gdm gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind)"
			MENU_LIBS="$(${pkgconfig} --libs gdm gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind)"
		)
	fi

	gnome2_src_configure "${myconf[@]}"
}

src_install() {
	gnome2_src_install

	if ! use gtk-doc ; then
		rm -r "${ED}"/usr/share/gtk-doc || die
	fi
}
