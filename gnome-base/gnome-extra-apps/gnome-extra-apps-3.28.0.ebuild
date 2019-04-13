# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="3.0"
# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="*"

IUSE="anjuta +bijiben boxes builder california empathy epiphany +evolution flashback +fonts +games geary gnote latexila multiwriter +recipes +share +shotwell simple-scan +todo +tracker +usage"

# Note to developers:
#
# This is a wrapper for the extra apps integrated with GNOME 3
#
# cantarell upstream relies on noto, unifont and symbola fonts for
# the fonts they cannot handle due to lack of enough manpower:
# https://bugzilla.gnome.org/show_bug.cgi?id=762890
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=app-admin/gnome-system-log-20170809
	>=app-arch/file-roller-${PV}
	>=app-dicts/gnome-dictionary-3.26
	>=gnome-base/dconf-editor-${PV}
	>=gnome-extra/gconf-editor-3
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-getting-started-docs-${PV}
	>=gnome-extra/gnome-power-manager-3.26
	>=gnome-extra/gnome-search-tool-3.6
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-tweaks-${PV}
	>=gnome-extra/gnome-weather-3.26
	>=gnome-extra/gucharmap-${PV}:2.90
	>=gnome-extra/nautilus-sendto-3.8.5
	>=gnome-extra/sushi-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-3.26
	>=media-sound/gnome-sound-recorder-${PV}
	>=media-sound/sound-juicer-3.24
	>=media-video/cheese-${PV}
	>=net-analyzer/gnome-nettool-3.8
	>=net-misc/vinagre-3.22
	>=net-misc/vino-3.22
	>=sci-geosciences/gnome-maps-${PV}
	>=sys-apps/baobab-${PV}
	>=sys-apps/gnome-disk-utility-${PV}

	anjuta? ( >=dev-util/anjuta-${PV} )
	bijiben? ( >=app-misc/bijiben-${PV} )
	boxes? ( >=gnome-extra/gnome-boxes-${PV} )
	builder? ( >=dev-util/gnome-builder-${PV} )
	california? ( >=gnome-extra/california-0.4.0 )
	empathy? ( >=net-im/empathy-3.12.13 )
	epiphany? ( >=www-client/epiphany-${PV} )
	evolution? ( >=mail-client/evolution-${PV} )
	flashback? ( >=gnome-base/gnome-flashback-${PV} )
	fonts? (
		>=media-fonts/noto-20170403
		>=media-fonts/symbola-9.17
		>=media-fonts/unifont-10.0.06 )
	games? (
		>=games-arcade/gnome-nibbles-3.24.0
		>=games-arcade/gnome-robots-3.22.0
		>=games-board/aisleriot-3.22.0
		>=games-board/four-in-a-row-${PV}
		>=games-board/gnome-chess-${PV}
		>=games-board/gnome-mahjongg-3.22.0
		>=games-board/gnome-mines-${PV}
		>=games-board/iagno-${PV}
		>=games-board/tali-3.22.0
		>=games-puzzle/atomix-3.22.0
		>=games-puzzle/five-or-more-${PV}
		>=games-puzzle/gnome2048-3.26
		>=games-puzzle/gnome-klotski-3.22.0
		>=games-puzzle/gnome-sudoku-${PV}
		>=games-puzzle/gnome-taquin-${PV}
		>=games-puzzle/gnome-tetravex-3.22.0
		>=games-puzzle/hitori-3.22.0
		>=games-puzzle/lightsoff-${PV}
		>=games-puzzle/quadrapassel-3.22.0
		>=games-puzzle/swell-foop-${PV} )
	geary? ( >=mail-client/geary-0.12.4 )
	gnote? ( >=app-misc/gnote-${PV} )
	latexila? ( >=app-editors/gnome-latex-${PV} )
	multiwriter? ( >=gnome-extra/gnome-multi-writer-3.24.0 )
	recipes? ( >=gnome-extra/gnome-recipes-1.6.2 )
	share? ( >=gnome-extra/gnome-user-share-${PV} )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	simple-scan? ( >=media-gfx/simple-scan-${PV} )
	todo? ( >=gnome-extra/gnome-todo-${PV} )
	tracker? (
		>=app-misc/tracker-2
		>=gnome-extra/gnome-documents-${PV}
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
	usage? ( >=gnome-extra/gnome-usage-${PV} )
"
DEPEND=""
S=${WORKDIR}
