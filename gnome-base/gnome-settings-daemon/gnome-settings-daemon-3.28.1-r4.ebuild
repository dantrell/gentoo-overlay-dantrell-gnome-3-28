# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )

inherit autotools gnome2 python-any-r1 systemd udev virtualx

DESCRIPTION="Gnome Settings Daemon"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-settings-daemon"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+colord +cups debug elogind input_devices_wacom networkmanager smartcard systemd test +udev vanilla-inactivity wayland"
REQUIRED_USE="
	?? ( elogind systemd )
	input_devices_wacom? ( udev )
	smartcard? ( udev )
	wayland? ( udev )
"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2[dbus]
	>=x11-libs/gtk+-3.15.3:3[X,wayland?]
	>=gnome-base/gnome-desktop-3.11.1:3=
	>=gnome-base/gsettings-desktop-schemas-3.23.3
	>=gnome-base/librsvg-2.36.2:2
	media-fonts/cantarell
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/libcanberra[gtk3]
	>=media-sound/pulseaudio-2
	>=sys-power/upower-0.99:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.3:=
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libXi
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-misc/xkeyboard-config

	>=app-misc/geoclue-2.3.1:2.0
	>=dev-libs/libgweather-3.9.5:2=
	>=sci-geosciences/geocode-glib-3.10
	>=sys-auth/polkit-0.103

	colord? (
		>=media-libs/lcms-2.2:2
		>=x11-misc/colord-1.0.2:= )
	cups? ( >=net-print/cups-1.4[dbus] )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=x11-libs/pango-1.20
		x11-drivers/xf86-input-wacom
		dev-libs/libgudev:= )
	networkmanager? ( >=net-misc/networkmanager-1.0:= )
	smartcard? ( >=dev-libs/nss-3.11.2 )
	udev? ( dev-libs/libgudev:= )
	wayland? ( dev-libs/wayland )
"
# consolekit or logind needed for power and session management, bug #464944
# dbus[user-session] for user services support (functional screen sharing setup)
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	elogind? ( sys-auth/elogind )
	systemd? ( >=sys-apps/systemd-186:0=
		sys-apps/dbus[user-session] )
	!<gnome-base/gnome-session-3.27.90
"
# xproto-7.0.15 needed for power plugin
DEPEND="${COMMON_DEPEND}
	cups? ( sys-apps/sed )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]')
		gnome-base/gnome-session )
	dev-libs/libxml2:2
	sys-devel/gettext
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	x11-base/xorg-proto
"

python_check_deps() {
	if use test; then
		has_version "dev-python/pygobject:3[${PYTHON_USEDEP}]" &&
		has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
	fi
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/07b346e4f99a912861978eb77058504af0871d3a
	# 	https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/acdd75f8f1d3802149a34531f19e7dc12595dddf
	# 	https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/f69e9d8c74a46b700d751ec93cd82a3699d6c497
	eapply "${FILESDIR}"/${PN}-3.28.1-support-autotools.patch
	# Make colord and wacom optional; requires eautoreconf
	eapply "${FILESDIR}"/${PN}-3.24.3-optional.patch
	# Allow specifying udevrulesdir via configure, bug 509484; requires eautoreconf
	eapply "${FILESDIR}"/${PN}-3.26.2-udevrulesdir-configure.patch
	# Fix build when Wayland is disabled
	eapply "${FILESDIR}"/${PN}-3.24.3-fix-without-gdkwayland.patch

	if ! use vanilla-inactivity; then
		# From GNOME:
		# 	https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/2fdb48fa3333638cee889b8bb80dc1d2b65aaa4a
		eapply -R "${FILESDIR}"/${PN}-3.27.90-power-default-to-suspend-after-20-minutes-of-inactivity.patch
	fi

	# From Ben Wolsieffer:
	# 	https://bugzilla.gnome.org/show_bug.cgi?id=734964
	eapply "${FILESDIR}"/${PN}-3.12.0-optionally-allow-suspending-with-multiple-monitors-on-lid-close.patch

	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-settings-daemon/commit/3110457f72f70b2d283c1ad2f27b91b95d75d92f
	eapply "${FILESDIR}"/${PN}-3.29.90-housekeeping-fix-improper-notify-notification-close-usage.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-udevrulesdir="$(get_udevdir)"/rules.d \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable debug more-warnings) \
		$(use_enable networkmanager network-manager) \
		$(use_enable smartcard smartcard-support) \
		$(use_enable udev gudev) \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable wayland)
}

src_test() {
	virtx emake check
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use systemd && [[ ! -d /run/systemd/system ]]; then
		ewarn "You have installed GNOME Settings Daemon *with* systemd support"
		ewarn "but the system was not booted using systemd."
		ewarn "To correct this, reference: https://wiki.gentoo.org/wiki/Systemd"
	fi

	if ! use systemd; then
		ewarn "You have installed GNOME Settings Daemon *without* systemd support."
		ewarn "To report issues, see: https://github.com/dantrell/gentoo-project-gnome-without-systemd/blob/master/GOVERNANCE.md#bugs-and-other-issues"
	fi
}
