# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic llvm systemd toolchain-funcs

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"
SRC_URI="https://api.github.com/repos/zerotier/ZeroTierOne/tarball/refs/tags/1.14.2 -> zerotier-1.14.2.tar.gz"

LICENSE="BSL-1.1"
SLOT="0"
KEYWORDS="*"
IUSE="clang neon"

S="${WORKDIR}/zerotier-${PV}"

RDEPEND="
	dev-libs/json-glib
	net-libs/libnatpmp
	net-libs/miniupnpc:=
	clang? ( >=sys-devel/clang-6:* )"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.6-add-armv7a-support.patch"
)

DOCS=( README.md AUTHORS.md )

LLVM_MAX_SLOT=11

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/zerotier-* ${S} || die
}

src_prepare() {
	default
	sed -i -e 's/LDFLAGS=/LDFLAGS?=/g' ${S}/make-linux.mk || die
}

llvm_check_deps() {
	if use clang ; then
		if ! has_version --host-root "sys-devel/clang:${LLVM_SLOT}" ; then
			ewarn "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		if ! has_version --host-root "=sys-devel/lld-${LLVM_SLOT}*" ; then
			ewarn "=sys-devel/lld-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		einfo "Will use LLVM slot ${LLVM_SLOT}!"
	fi
}

pkg_setup() {
	if use clang && ! tc-is-clang ; then
		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
	else
		tc-export CXX CC
	fi
	use neon || export ZT_DISABLE_NEON=1
}

src_compile() {
	append-ldflags -Wl,-z,noexecstack
	emake CXX="${CXX}" STRIP=: one
}

src_test() {
	emake selftest
	./zerotier-selftest || die
}

src_install() {
	default
	# remove pre-zipped man pages
	rm "${ED}"/usr/share/man/{man1,man8}/* || die

	newinitd "${FILESDIR}/${PN}".init-r2 "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service
	doman doc/zerotier-{cli.1,idtool.1,one.8}
}