# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="ca de es fr ja ko pt_BR ru sv tr uk"
PLOCALES_BIN="${PLOCALES} bg cs eu fi hu id it ka nb nl pl pt tg zh_TW zh_CN"
PLOCALE_BACKUP="sv"
PYTHON_COMPAT=( python3+ )

inherit autotools flag-o-matic linux-info optfeature plocale \
	python-single-r1 pam toolchain-funcs

DESCRIPTION="System Security Services Daemon provides access to identity and authentication"
HOMEPAGE="https://pagure.io/SSSD/sssd"
SRC_URI="https://github.com/SSSD/sssd/tarball/7386dd08a71aef3aef40637b7a74326ab298213d -> sssd-2.10.2-7386dd0.tar.gz"
KEYWORDS="*"
LICENSE="GPL-3"
SLOT="0"

IUSE="acl doc +netlink nfsv4 nls +man python samba selinux subid sudo systemtap test"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( sudo )"
RESTRICT="!test? ( test )"

DEPEND="
	>=app-crypt/mit-krb5-1.19.1
	app-crypt/p11-kit
	>=dev-libs/ding-libs-0.2
	>=dev-libs/cyrus-sasl-2.1.25-r3[kerberos]
	dev-libs/jansson:=
	dev-libs/libpcre2:=
	dev-libs/libunistring:=
	>=dev-libs/popt-1.16
	>=dev-libs/openssl-1.0.2:=
	>=net-dns/bind-tools-9.9[gssapi]
	>=net-dns/c-ares-1.10.0-r1:=
	>=net-nds/openldap-2.4.30:=[sasl,experimental]
	>=sys-apps/dbus-1.6
	>=sys-apps/keyutils-1.5:=
	>=sys-libs/pam-0-r1
	>=sys-libs/talloc-2.0.7
	>=sys-libs/tdb-1.2.9
	>=sys-libs/tevent-0.9.16
	>=sys-libs/ldb-1.1.17-r1:=
	virtual/libintl
	acl? ( net-fs/cifs-utils[acl] )
	netlink? ( dev-libs/libnl:3 )
	nfsv4? ( >=net-fs/nfs-utils-2.3.1-r2 )
	nls? ( >=sys-devel/gettext-0.18 )
	python? ( ${PYTHON_DEPS} )
	samba? ( >=net-fs/samba-4.10.2[winbind] )
	selinux? (
		>=sys-libs/libselinux-2.1.9
		>=sys-libs/libsemanage-2.1
	)
	subid? ( >=sys-apps/shadow-4.9 )
	systemtap? ( dev-debug/systemtap )"
RDEPEND="${DEPEND}
	selinux? ( >=sec-policy/selinux-sssd-2.20120725-r9 )"
BDEPEND="
	virtual/pkgconfig
	${PYTHON_DEPS}
	doc? ( app-text/doxygen )
	man? (
		app-text/docbook-xml-dtd:4.4
		>=dev-libs/libxslt-1.1.26
		nls? ( app-text/po4a )
	)
	nls? ( sys-devel/gettext )
	test? (
		dev-libs/check
		dev-libs/softhsm:2
		dev-util/cmocka
		net-libs/gnutls[pkcs11,tools]
		sys-libs/libfaketime
		sys-libs/nss_wrapper
		sys-libs/pam_wrapper
		sys-libs/uid_wrapper
	)
"
CONFIG_CHECK="~KEYS"
PATCHES=(
	"${FILESDIR}"/"${PN}-2.8.2-krb5_pw_locked.patch"
	"${FILESDIR}"/"${PN}-2.9.1-conditional-python-install.patch"
)

S="${WORKDIR}/SSSD-sssd-7386dd0"


pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	plocale_get_locales > src/man/po/LINGUAS || die

	sed -i \
		-e "/_langs]/ s/ .*//" \
		src/man/po/po4a.cfg \
		|| die
	enable_locale() {
		local locale=${1}

		sed -i \
			-e "/_langs]/ s/$/ ${locale}/" \
			src/man/po/po4a.cfg \
			|| die
	}

	plocale_for_each_locale enable_locale

	PLOCALES="${PLOCALES_BIN}"
	plocale_get_locales > po/LINGUAS || die

	sed -i \
		-e 's:/var/run:/run:' \
		src/examples/logrotate \
		|| die

	# disable flaky test, see https://github.com/SSSD/sssd/issues/5631
	sed -i \
		-e '/^\s*pam-srv-tests[ \\]*$/d' \
		Makefile.am \
		|| die

	eautoreconf
}

src_configure() {
	local native_dbus_cflags=$($(tc-getPKG_CONFIG) --cflags dbus-1 || die)
	local myconf=()

	myconf+=(
		--libexecdir="${EPREFIX}"/usr/libexec
		--localstatedir="${EPREFIX}"/var
		--runstatedir="${EPREFIX}"/run
		--sbindir="${EPREFIX}"/usr/sbin
		--with-pid-path="${EPREFIX}"/run
		--with-plugin-path="${EPREFIX}"/usr/$(get_libdir)/sssd
		--enable-pammoddir="${EPREFIX}"/$(getpam_mod_dir)
		--with-ldb-lib-dir="${EPREFIX}"/usr/$(get_libdir)/samba/ldb
		--with-db-path="${EPREFIX}"/var/lib/sss/db
		--with-gpo-cache-path="${EPREFIX}"/var/lib/sss/gpo_cache
		--with-pubconf-path="${EPREFIX}"/var/lib/sss/pubconf
		--with-pipe-path="${EPREFIX}"/var/lib/sss/pipes
		--with-mcache-path="${EPREFIX}"/var/lib/sss/mc
		--with-secrets-db-path="${EPREFIX}"/var/lib/sss/secrets
		--with-log-path="${EPREFIX}"/var/log/sssd
		--with-kcm
		--enable-kcm-renewal
		--with-os=gentoo
		--disable-rpath
		--disable-static
		# Valgrind is only used for tests
		--disable-valgrind
		$(use_with samba)
		--with-smb-idmap-interface-version=6
		$(use_enable acl cifs-idmap-plugin)
		$(use_with selinux)
		$(use_with selinux semanage)
		--enable-krb5-locator-plugin
		$(use_enable samba pac-responder)
		$(use_with nfsv4 nfsv4-idmapd-plugin)
		$(use_enable nls)
		$(use_with netlink libnl)
		$(use_with man manpages)
		$(use_with sudo)
		--with-autofs
		--with-ssh
		--without-oidc-child
		--without-passkey
		$(use_with subid)
		$(use_enable systemtap)
		--without-python2-bindings
		$(use_with python python3-bindings)
		--with-initscript=sysv
	)

	econf "${myconf[@]}"
}

src_compile() {
	default
	use doc && emake docs
}

src_test() {
	local -x CK_TIMEOUT_MULTIPLIER=10
	emake check VERBOSE=yes
}


src_install() {
	emake -j1 DESTDIR="${D}" install
	if use python; then
		python_fix_shebang "${ED}"
		python_optimize
	fi
	einstalldocs

	insinto /etc/sssd
	insopts -m600
	doins src/examples/sssd-example.conf

	insinto /etc/logrotate.d
	insopts -m644
	newins src/examples/logrotate sssd

	newconfd "${FILESDIR}"/sssd.conf sssd

	keepdir /var/lib/sss/db
	keepdir /var/lib/sss/deskprofile
	keepdir /var/lib/sss/gpo_cache
	keepdir /var/lib/sss/keytabs
	keepdir /var/lib/sss/mc
	keepdir /var/lib/sss/pipes/private
	keepdir /var/lib/sss/pubconf/krb5.include.d
	keepdir /var/lib/sss/secrets
	keepdir /var/log/sssd

	# strip empty dirs
	if ! use doc; then
		rm -r "${ED}"/usr/share/doc/"${PF}"/doc || die
		rm -r "${ED}"/usr/share/doc/"${PF}"/{hbac,idmap,nss_idmap}_doc || die
	fi

	rm -r "${ED}"/run || die
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	elog "You must set up sssd.conf (default installed into /etc/sssd)"
	elog "and (optionally) configuration in /etc/pam.d in order to use SSSD"
	elog "features."
	optfeature "Kerberos keytab renew (see krb5_renew_interval)" app-crypt/adcli
}

# vim: noet ts=4 syn=ebuild