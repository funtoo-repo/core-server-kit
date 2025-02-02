# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A filesystem backup utility based on rsync"
HOMEPAGE="http://www.rsnapshot.org"
SRC_URI="https://github.com/rsnapshot/rsnapshot/tarball/367a49cda9d428c27a50641d99734c7b790f2cc1 -> rsnapshot-1.5.1-367a49c.tar.gz"

S="${WORKDIR}/rsnapshot-rsnapshot-367a49c"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="*"

RDEPEND=">=dev-lang/perl-5.8.2
		dev-perl/Lchown
		>=sys-apps/util-linux-2.12-r4
		>=sys-apps/coreutils-5.0.91-r4
		>=net-misc/openssh-3.7.1_p2-r1
		>=net-misc/rsync-2.6.0"
DEPEND="${RDEPEND}"


src_prepare() {
	default
	# remove '/etc/' since we don't place it here, bug #461554
	sed -i -e 's:/etc/rsnapshot.conf.default:rsnapshot.conf.default:' rsnapshot-program.pl || die
	./autogen.sh || die "autogen failed"
}

src_configure() {
	default
	# If the version didn't get set, fix it here.
	# See: https://github.com/rsnapshot/rsnapshot/issues/321
	sed -i "s/my \$VERSION = '@.*@'/my \$VERSION = '${PV}'/g" rsnapshot-program.pl || die
}

src_install() {
	docompress -x "/usr/share/doc/${PF}/rsnapshot.conf.default"

	# Change sysconfdir to install the template file as documentation rather
	# than in /etc.  Note:  Must do it here, rather than calling ./configure
	# with the --sysconfdir option, as doing the latter will force rsnapshot
	# to look for its config file in the sysconfdir if it is set by
	# ./configure.  Setting it with the environment variable here installs the
	# sample file in the desired location without changing where rsnapshot
	# expects to find its config file, by default in /etc/rsnapshot.conf.
	emake install DESTDIR="${D}" \
		sysconfdir="${EPREFIX}/usr/share/doc/${PF}"

	dodoc README.md AUTHORS ChangeLog \
		docs/Upgrading_from_1.1

	docinto utils
	dodoc utils/{README,rsnaptar,*.sh,*.pl}

	docinto utils/rsnapshotdb
	dodoc utils/rsnapshotdb/*
}

pkg_postinst() {
	elog "The template configuration file has been installed as"
	elog "  /usr/share/doc/${PF}/rsnapshot.conf.default"
	elog "Copy and edit the the above file as /etc/rsnapshot.conf"
}