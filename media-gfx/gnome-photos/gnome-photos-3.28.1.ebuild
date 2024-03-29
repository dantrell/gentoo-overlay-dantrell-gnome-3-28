# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="Access, organize and share your photos on GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Photos"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="flickr upnp-av"

RESTRICT="test"

COMMON_DEPEND="
	>=app-misc/tracker-2:0=[miner-fs]
	>=dev-libs/glib-2.44:2
	gnome-base/gsettings-desktop-schemas
	>=dev-libs/libgdata-0.15.2:0=[gnome-online-accounts]
	media-libs/babl
	>=media-libs/gegl-0.3.15:0.3[cairo,raw]
	media-libs/gexiv2
	>=media-libs/grilo-0.3.0:0.3=
	>=media-libs/libpng-1.6:0=
	>=net-libs/gnome-online-accounts-3.8:=
	>=net-libs/libgfbgraph-0.2.1:0.2
	sci-geosciences/geocode-glib:0
	>=x11-libs/cairo-1.14
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22.16:3
"
# gnome-online-miners is also used for google, facebook, DLNA - not only flickr
# but out of all the grilo-plugins, only upnp-av and flickr get used, which have USE flags here,
# so don't pull it always, but only if either USE flag is enabled
RDEPEND="${COMMON_DEPEND}
	net-misc/gnome-online-miners[flickr?]
	upnp-av? ( media-plugins/grilo-plugins:0.3[upnp-av] )
	flickr? ( media-plugins/grilo-plugins:0.3[flickr] )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-util/desktop-file-utils
	>=dev-util/intltool-0.50.1
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure --disable-dogtail
}
