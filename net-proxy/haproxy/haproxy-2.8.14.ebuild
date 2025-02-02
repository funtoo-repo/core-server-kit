# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit user toolchain-funcs flag-o-matic systemd linux-info

MY_P="${PN}-${PV/_beta/-dev}"

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://www.haproxy.org"
SRC_URI="http://www.haproxy.org/download/2.8/src/haproxy-2.8.14.tar.gz -> haproxy-2.8.14.tar.gz"
KEYWORDS="*"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="+crypt doc examples libressl slz +net_ns +pcre pcre-jit pcre2 pcre2-jit prometheus-exporter
ssl systemd +threads tools vim-syntax +zlib lua device-atlas 51degrees wurfl"
REQUIRED_USE="pcre-jit? ( pcre )
	pcre2-jit? ( pcre2 )
	pcre? ( !pcre2 )
	device-atlas? ( pcre )
	?? ( slz zlib )"

DEPEND="
	pcre? (
		dev-libs/libpcre
		pcre-jit? ( dev-libs/libpcre[jit] )
	)
	tools? ( dev-libs/libevent )
	pcre2? (
		dev-libs/libpcre
		pcre2-jit? ( dev-libs/libpcre2[jit] )
	)
	ssl? (
		dev-libs/openssl:0=
		libressl? ( dev-libs/libressl:0= )
	)
	slz? ( dev-libs/libslz:= )
	zlib? ( sys-libs/zlib )
	lua? ( dev-lua/lua:5.3 )
	device-atlas? ( dev-libs/device-atlas-api-c )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGELOG CONTRIBUTING MAINTAINERS README )
ADMINS=( iprange systemd )
ADMINS_DIRECT=( halog dyncookie )
ADDONS=()
DEV_TOOLS=( flags/flags hpack/decode hpack/gen-enc hpack/gen-rht poll/poll tcploop/tcploop )


haproxy_use() {
	(( $# != 2 )) && die "${FUNCNAME} <USE flag> <make option>"

	usex "${1}" "USE_${2}=1" "USE_${2}="
}

pkg_setup() {
	enewgroup haproxy
	enewuser haproxy -1 -1 -1 haproxy

	if use net_ns; then
		CONFIG_CHECK="~NET_NS"
		linux-info_pkg_setup
	fi
}

src_compile() {
	local -a args=(
		V=1
		TARGET=linux-glibc
	)

	if use device-atlas ; then
		ADDONS+=( deviceatlas )
	fi
	if use 51degrees ; then
		ADDONS+=( 51degrees )
	fi
	if use wurfl ; then
		ADDONS+=( wurfl )
	fi

	# TODO: PCRE2_WIDTH?
	args+=( $(haproxy_use threads THREAD) )
	args+=( $(haproxy_use crypt LIBCRYPT) )
	args+=( $(haproxy_use net_ns NS) )
	args+=( $(haproxy_use pcre PCRE) )
	args+=( $(haproxy_use pcre-jit PCRE_JIT) )
	args+=( $(haproxy_use pcre2 PCRE2) )
	args+=( $(haproxy_use pcre2-jit PCRE2_JIT) )
	args+=( $(haproxy_use ssl OPENSSL) )
	args+=( $(haproxy_use slz SLZ) )
	args+=( $(haproxy_use zlib ZLIB) )
	args+=( $(haproxy_use lua LUA) )
	args+=( $(haproxy_use 51degrees 51DEGREES) )
	args+=( $(haproxy_use device-atlas DEVICEATLAS) )
	args+=( $(haproxy_use wurfl WURFL) )
	args+=( $(haproxy_use systemd SYSTEMD) )
	args+=( $(haproxy_use prometheus-exporter PROEMEX) )

	# Bug #668002
	if use ppc || use arm || use hppa; then
		TARGET_LDFLAGS=-latomic
	fi

	# For now, until the strict-aliasing breakage will be fixed
	append-cflags -fno-strict-aliasing

	# HAProxy really needs some of those "SPEC_CFLAGS", like -fno-strict-aliasing
	emake CFLAGS="${CFLAGS} \$(SPEC_CFLAGS)" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) EXTRA_OBJS="${EXTRA_OBJS}"	TARGET_LDFLAGS="${TARGET_LDFLAGS}" PCRE_LIB=${ERROT}/usr/$(get_libdir) ${args[@]}

	for admin in ${ADMINS[@]} ; do
		emake -C admin/${admin} \
			SBINDIR=/usr/sbin \
			CFLAGS="${CFLAGS} -I../../include/ -I../../ebtree/" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
	done

	for admin in ${ADMINS_DIRECT[@]} ; do
		emake admin/${admin}/${admin} \
			CFLAGS="${CFLAGS} -I../../include/ -I../../ebtree/" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
	done

	if use tools ; then
		for addon in ${ADDONS[@]} ; do
			emake -C addons/${addon} \
				SBINDIR=/usr/sbin \
				CFLAGS="${CFLAGS} -I../../include/ -I../../ebtree/" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
		done

		for dev in ${DEV_TOOLS[@]} ; do
			emake dev/${dev} \
				SBINDIR=/usr/sbin \
				CFLAGS="${CFLAGS} -I../../include/ -I../../ebtree/" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
		done
	fi

}

src_install() {
	dosbin haproxy
	dosym ../sbin/haproxy /usr/bin/haproxy

	newconfd "${FILESDIR}/${PN}.confd" $PN
	newinitd "${FILESDIR}/${PN}.initd-r6" $PN

	doman doc/haproxy.1

	systemd_dounit admin/systemd/haproxy.service

	einstalldocs

	# The errorfiles are used by upstream defaults.
	insinto /etc/haproxy/errors/
	doins examples/errorfiles/*

	if use doc; then
		dodoc ROADMAP doc/*.txt
	fi

	if use tools ; then
		has halog "${ADMINS_DIRECT[@]}" && dobin admin/halog/halog
		has iprange "${ADMINS[@]}" && {
			newbin admin/iprange/iprange haproxy_iprange ;
			newbin admin/iprange/ip6range haproxy_ip6range ;
		}

		has tcploop/tcploop "${DEV_TOOLS[@]}" && newbin dev/tcploop/tcploop haproxy_tcploop
		has pool/pool "${DEV_TOOLS[@]}" && newbin dev/pool/poll haproxy_poll
		has flags/flags "${DEV_TOOLS[@]}" && newbin dev/flags/flags haproxy_flags
		has hpack/gen-rht "${DEV_TOOLS[@]}" && {
			newbin dev/hpack/gen-rht haproxy_gen-rht
			newbin dev/hpack/gen-enc haproxy_gen-enc
			newbin dev/hpack/decode haproxy_decode
		}
	fi

	if use examples ; then
		docinto examples
		dodoc examples/*.cfg
		dodoc doc/seamless_reload.txt
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins admin/syntax-highlight/haproxy.vim
	fi
}

pkg_postinst() {
	if [[ ! -f "${EROOT}/etc/haproxy/haproxy.cfg" ]] ; then
		ewarn "You need to create /etc/haproxy/haproxy.cfg before you start the haproxy service."
		ewarn "It's best practice to not run haproxy as root, user and group haproxy was therefore created."
		ewarn "Make use of them with the \"user\" and \"group\" directives."

		if [[ -d "${EROOT}/usr/share/doc/${PF}" ]]; then
			einfo "Please consult the installed documentation for learning the configuration file's syntax."
			einfo "The documentation and sample configuration files are installed here:"
			einfo "   ${EROOT}/usr/share/doc/${PF}"
		fi
	fi
}
