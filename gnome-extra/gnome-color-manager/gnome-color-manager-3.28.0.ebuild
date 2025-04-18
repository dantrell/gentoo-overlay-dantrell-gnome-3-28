# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome.org meson virtualx xdg

DESCRIPTION="GNOME color profile tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-color-manager"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="raw test"

RESTRICT="!test? ( test )"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
RDEPEND="
	>=dev-libs/glib-2.31.10:2
	>=x11-libs/gtk+-3.3.8:3
	>=x11-misc/colord-1.3.1:0=
	>=media-libs/lcms-2.2:2

	media-libs/libexif
	media-libs/tiff:=
	>=x11-libs/colord-gtk-0.1.20
	>=media-libs/libcanberra-0.10[gtk3]
	>=x11-libs/vte-0.25.1:2.91

	raw? ( media-gfx/exiv2:0= )
"
DEPEND="${RDEPEND}"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
BDEPEND="
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.26.0-fix-libm-check.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-color-manager/-/issues/4
	# 	https://bugs.gentoo.org/674086
	#
	# From Exiv2:
	# 	https://github.com/Exiv2/exiv2/issues/2630
	"${FILESDIR}"/${PN}-3.30.0-exiv2-0.28.patch
)

src_prepare() {
	xdg_src_prepare

	# Fix hard-coded package name
	# https://gitlab.gnome.org/GNOME/gnome-color-manager/-/issues/3
	sed 's:argyllcms:media-gfx/argyllcms:' -i src/gcm-utils.h || die
}

src_configure() {
	local emesonargs=(
		$(meson_use raw exiv)
		-Dpackagekit=false
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
