# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_10,3_11,3_12,3_13} )

inherit gnome2 python-single-r1 toolchain-funcs

DESCRIPTION="An API documentation browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Devhelp"

LICENSE="GPL-2+"
SLOT="0/3-5" # subslot = 3-(libdevhelp-3 soname version)
KEYWORDS="*"

IUSE="gedit +introspection"
REQUIRED_USE="gedit? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	>=dev-libs/glib-2.40:2[dbus]
	>=x11-libs/gtk+-3.22:3
	>=net-libs/webkit-gtk-2.19.2:4
	gnome-base/gsettings-desktop-schemas
	introspection? ( >=dev-libs/gobject-introspection-1.30:= )
"
RDEPEND="${COMMON_DEPEND}
	gedit? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			app-editors/gedit[introspection,python,${PYTHON_SINGLE_USEDEP}]
			dev-python/pygobject:3[${PYTHON_USEDEP}]
		')
		x11-libs/gtk+[introspection] )
"
# libxml2 required for glib-compile-resources
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/itstool
	>=dev-build/gtk-doc-am-1.25
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
# eautoreconf requires:
#  dev-libs/appstream-glib
#  dev-build/autoconf-archive
#  app-text/yelp-tools

pkg_setup() {
	use gedit && python-single-r1_pkg_setup
}

src_prepare() {
	if ! use gedit ; then
		sed -e '/SUBDIRS/ s/gedit-plugin//' -i plugins/Makefile.{am,in} || die
	fi

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
