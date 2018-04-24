# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal meson

DESCRIPTION="D-Bus accessibility specifications and registration daemon"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE="X doc +introspection"

# x11-libs/libSM is needed until upstream #719808 is solved either
# making the dep unneeded or fixing their configure
# Only libX11 is optional right now
RDEPEND="
	>=dev-libs/glib-2.36:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	doc? ( >=dev-util/gtk-doc-am-1.9 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )
	X? (
		x11-libs/libX11[${MULTILIB_USEDEP}]
		x11-libs/libXi[${MULTILIB_USEDEP}]
		x11-libs/libXtst[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

PATCHES=(
	# disable teamspaces test since that requires Novell.ICEDesktop.Daemon
	"${FILESDIR}"/${PN}-2.0.2-disable-teamspaces-test.patch
)

multilib_src_configure() {
	local emesonargs=(
		-D enable_docs=$(usex doc true false)
		-D enable-introspection=$(usex introspection yes no)
		-D enable-x11=$(usex X yes no)
	)
	meson_src_configure

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		ln -s "${S}"/doc/libatspi/html doc/libatspi/html || die
	fi
}

multilib_src_compile() { meson_src_compile; }
multilib_src_install() { meson_src_install; }

# weird hacks (needs for multilib support)
pkg_postinst() {
	if [ -f /usr/lib64/pkgconfig/atspi-2.pc ]; then
		if [ -f /usr/lib32/libatspi.so.0 ]; then
			cp -f /usr/lib64/pkgconfig/atspi-2.pc /usr/lib32/pkgconfig/atspi-2.pc
			sed -i -e 's@lib64@lib32@g' /usr/lib32/pkgconfig/atspi-2.pc
		fi
	fi
	if [ -f /usr/lib32/libatspi.so.0 ]; then
		if [ ! -f /usr/lib32/libatspi.so ]; then
			ln /usr/lib32/libatspi.so.0 /usr/lib32/libatspi.so
		fi
	fi
}
