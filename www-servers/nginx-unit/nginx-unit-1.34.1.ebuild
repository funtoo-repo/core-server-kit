# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit flag-o-matic python-single-r1 systemd toolchain-funcs user

MY_P="unit-${PV}"
DESCRIPTION="Dynamic web and application server"
HOMEPAGE="https://unit.nginx.org"
SRC_URI="https://github.com/nginx/unit/tarball/ed6f67d14dc5d03c2b5d10d5bb6eb237f9c9b896 -> unit-1.34.1-ed6f67d.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
MY_USE="perl python ruby"
MY_USE_PHP="php7-4 php8-0 php8-1 php8-2"
IUSE="${MY_USE} ${MY_USE_PHP} ssl"
REQUIRED_USE="|| ( ${IUSE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="perl? ( dev-lang/perl:= )
    php8-1? ( dev-lang/php:8.2[embed] )
	php8-1? ( dev-lang/php:8.1[embed] )
	php8-0? ( dev-lang/php:8.0[embed] )
    php7-4? ( dev-lang/php:7.4[embed] )
	python? ( ${PYTHON_DEPS} )
	ruby? (
		dev-lang/ruby:=
		dev-ruby/rubygems:=
	)
	ssl? ( dev-libs/openssl:0= )"

RDEPEND="${DEPEND}"


post_src_unpack() {
    if [ ! -d "${S}" ]; then
            mv nginx-unit* "${S}" || die
    fi
}

pkg_setup() {

    NGINX_UNIT_HOME="${EROOT}/var/lib/${PN}"
	NGINX_UNIT_HOME_TMP="${NGINX_UNIT_HOME}/tmp"

    if egetent group "${PN}" > /dev/null ; then
        elog "${PN} group already exist."
        elog "group creation step skipped."
    else
        enewgroup "${PN}" > /dev/null
        elog "${PN} group created by portage."
    fi

    if egetent passwd "${PN}" > /dev/null ; then
        elog "${PN} user already exist."
        elog "user creation step skipped."
    else
        enewuser "${PN}" -1 -1 "${NGINX_UNIT_HOME}" "${PN}" > /dev/null
        elog "${PN} user with ${NGINX_UNIT_HOME} home"
        elog "was created by portage."
    fi

    use python && python-single-r1_pkg_setup

}

src_prepare() {
	eapply_user
	sed -i '/^CFLAGS/d' auto/make || die
	default
}

src_configure() {
	local opt=(
		--control=unix:/run/${PN}.sock
		--log=/var/log/${PN}
		--modules=/usr/$(get_libdir)/${PN}
		--pid=/run/${PN}.pid
		--prefix=/usr
		--state=/var/lib/${PN}
		--user=${PN}
		--group=${PN}
	)

	use ssl && opt+=( --openssl )
	export AR="$(tc-getAR)"
	export CC="$(tc-getCC)"
	./configure ${opt[@]} --ld-opt="${LDFLAGS}" || die "Core configuration failed"

	# Modules require position-independent code
	append-cflags $(test-flags-CC -fPIC)

	for flag in ${MY_USE} ; do
		if use ${flag} ; then
			./configure ${flag} || die "Module configuration failed: ${flag}"
		fi
	done

	for flag in ${MY_USE_PHP} ; do
		if use ${flag} ; then
			local php_slot="/usr/$(get_libdir)/${flag/-/.}"
			./configure php \
				--module=${flag} \
				--config=${php_slot}/bin/php-config \
				--lib-path=${php_slot}/$(get_libdir) || die "Module configuration failed: ${flag}"
		fi
	done
}


src_install() {
	default

	if use perl ; then
		echo "1"
		echo "D is ${D}"
		emake DESTDIR="${D}/" perl-install
	fi

	rm -rf "${ED}"/usr/var

	diropts -m 0770
	keepdir /var/lib/${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}"/nginx-unit.confd nginx-unit
	# systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
}