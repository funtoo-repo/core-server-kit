# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"

DESCRIPTION="An API for talking to sieve (RFC 3028) servers"
HOMEPAGE="https://github.com/roundcube/${MY_PN}"
SRC_URI="https://github.com/pear/Net_Sieve/tarball/345eb171c0b377e4f9f6fe9c6e532a76dfe2d754 -> Net_Sieve-1.4.8-345eb17.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="sasl"

RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR
	dev-php/PEAR-Net_Socket
	sasl? ( dev-php/PEAR-Auth_SASL )"

S="${WORKDIR}/${MY_PN}-${PV}"


post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/pear-* ${S} || die
    fi
}

src_install() {
	# Install into "Net" for backwards compatibility (that's where PEAR
	# used to put things).
	insinto /usr/share/php/Net
	doins Sieve.php
}