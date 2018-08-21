# Distributed under the terms of the GNU General Public License v2

EAPI="6"
# gedit-3.8 is python3 only, this also per:
# https://bugzilla.redhat.com/show_bug.cgi?id=979450
PYTHON_COMPAT=( python{3_4,3_5,3_6,3_7} )

inherit autotools gnome2 python-single-r1 toolchain-funcs

DESCRIPTION="An API documentation browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Devhelp"

LICENSE="GPL-2+"
SLOT="0/3-4" # subslot = 3-(libdevhelp-3 soname version)
KEYWORDS="*"

IUSE="gedit +introspection +vanilla-dpi"
REQUIRED_USE="gedit? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	>=dev-libs/glib-2.38:2[dbus]
	>=x11-libs/gtk+-3.20:3
	gnome-base/gsettings-desktop-schemas
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
	vanilla-dpi? ( >=net-libs/webkit-gtk-2.19.2:4 )
	!vanilla-dpi? ( >=net-libs/webkit-gtk-2.6.0:4 )
"
RDEPEND="${COMMON_DEPEND}
	gedit? (
		${PYTHON_DEPS}
		app-editors/gedit[introspection,python,${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		x11-libs/gtk+[introspection] )
"
# libxml2 required for glib-compile-resources
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1.25
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
# eautoreconf requires:
#  dev-libs/appstream-glib
#  sys-devel/autoconf-archive

pkg_setup() {
	use gedit && python-single-r1_pkg_setup
}

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/devhelp/commit/25cd3af113d1b450ed8415c47cefc2ef7a50bca0
	if ! use vanilla-dpi; then
		eapply "${FILESDIR}"/${PN}-3.28.1-use-old-font-size-functionality.patch
	fi

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	local myconf=""
	# ICC is crazy, silence warnings (bug #154010)
	if [[ $(tc-getCC) == "icc" ]] ; then
		myconf="--with-compile-warnings=no"
	fi
	gnome2_src_configure \
		$(use_enable introspection) \
		${myconf}
}
