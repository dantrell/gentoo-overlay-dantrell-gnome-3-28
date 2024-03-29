# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit cmake-utils gnome2

DESCRIPTION="Evolution module for connecting to Microsoft Exchange Web Services"
HOMEPAGE="https://wiki.gnome.org/Apps/Evolution https://gitlab.gnome.org/GNOME/evolution-ews"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"

IUSE="test"

# Unittests fail to find libevolution-ews.so
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3=
	>=dev-libs/glib-2.46:2
	dev-libs/libical:0=
	>=dev-libs/libmspack-0.4
	dev-libs/libxml2:2
	>=gnome-extra/evolution-data-server-${PV}:0=
	>=mail-client/evolution-${PV}:2.0
	>=net-libs/libsoup-2.42:2.4
	>=x11-libs/gtk+-3.10:3
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35.5
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
	test? ( net-libs/uhttpmock:0 )
"

src_configure() {
	local mycmakeargs=(
		-DWITH_MSPACK=ON
		-DENABLE_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}
