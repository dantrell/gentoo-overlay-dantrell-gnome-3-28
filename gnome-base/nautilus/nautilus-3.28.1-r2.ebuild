# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # Needed with USE 'sendto'

inherit gnome2 readme.gentoo-r1 versionator meson

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Nautilus"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"
KEYWORDS="*"

IUSE="doc gnome +introspection +previewer selinux sendto vanilla-menu vanilla-menu-compress vanilla-rename vanilla-search vanilla-thumbnailer test"

# FIXME: tests fails under Xvfb, but pass when building manually
# "FAIL: check failed in nautilus-file.c, line 8307"
# need org.gnome.SessionManager service (aka gnome-session) but cannot find it
RESTRICT="test"

# Require {glib,gdbus-codegen}-2.30.0 due to GDBus API changes between 2.29.92
# and 2.30.0
COMMON_DEPEND="
	>=app-arch/gnome-autoar-0.2.1
	>=dev-libs/glib-2.51.2:2[dbus]
	>=x11-libs/pango-1.28.3
	>=x11-libs/gtk+-3.22.26:3[introspection?]
	>=dev-libs/libxml2-2.7.8:2
	>=gnome-base/gnome-desktop-3:3=

	gnome-base/dconf
	>=gnome-base/gsettings-desktop-schemas-3.8.0
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender

	doc? ( >=dev-util/gtk-doc-am-1.10 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	selinux? ( >=sys-libs/libselinux-2 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-lang/perl-5
	>=dev-util/gdbus-codegen-2.33
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
	x11-base/xorg-proto
	app-misc/tracker:0=
	>=media-libs/gexiv2-0.10.0
"
RDEPEND="${COMMON_DEPEND}
	sendto? ( !<gnome-extra/nautilus-sendto-3.0.1 )
"
PDEPEND="
	gnome? ( x11-themes/adwaita-icon-theme )
	previewer? ( >=gnome-extra/sushi-0.1.9 )
	sendto? ( >=gnome-extra/nautilus-sendto-3.0.1 )
	>=gnome-base/gvfs-1.14[gtk(+)]
	>=media-video/totem-3.26[vanilla-thumbnailer=]
	!vanilla-thumbnailer? ( media-video/ffmpegthumbnailer )
"
# Need gvfs[gtk] for recent:/// support

src_prepare() {
	if use previewer; then
		DOC_CONTENTS="nautilus uses gnome-extra/sushi to preview media files.
			To activate the previewer, select a file and press space; to
			close the previewer, press space again."
	fi

	# Don't treat warnings as errors
	sed -e 's/-Werror=/-W/' -i meson.build || die "sed failed"

	if ! use vanilla-menu; then
		if ! use vanilla-menu-compress; then
			eapply "${FILESDIR}"/${PN}-3.28.1-use-old-compress-extension.patch
			eapply "${FILESDIR}"/${PN}-3.28.1-reorder-context-menu-rebased.patch
		else
			eapply "${FILESDIR}"/${PN}-3.26.3.1-reorder-context-menu.patch
		fi
	elif ! use vanilla-menu-compress; then
		eapply "${FILESDIR}"/${PN}-3.28.1-use-old-compress-extension.patch
	fi

	if ! use vanilla-rename; then
		eapply "${FILESDIR}"/${PN}-3.28.1-support-slow-double-click-to-rename.patch
	fi

	if ! use vanilla-search; then
		# From Dr. Amr Osman:
		# 	https://bugs.launchpad.net/ubuntu/+source/nautilus/+bug/1164016/comments/31
		eapply "${FILESDIR}"/${PN}-3.26.3.1-support-alternative-search.patch
	fi

	eapply_user
}

src_configure() {
	local emesonargs=(
		-D docs=$(usex doc true false)
		-D extensions=$(usex sendto true false)
		-D packagekit=false
		-D selinux=$(usex selinux true false)
		-D profiling=false
		-D tests=$(usex test all none)
	)
	meson_src_configure
}

src_install() {
	use previewer && readme.gentoo_create_doc
	meson_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use previewer; then
		readme.gentoo_print_elog
	else
		elog "To preview media files, emerge nautilus with USE=previewer"
	fi
}
