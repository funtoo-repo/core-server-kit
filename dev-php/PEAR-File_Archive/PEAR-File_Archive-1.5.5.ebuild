# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Easily manipulate archives in PHP"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="https://github.com/pear/File_Archive/tarball/f68386f8afebb41e9ddcd68650de0c01b918093b -> File_Archive-1.5.5-f68386f.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"
IUSE="minimal"

RDEPEND="dev-lang/php[bzip2,zlib]
	dev-php/PEAR-MIME_Type
	dev-php/PEAR-PEAR
	!minimal? (
		dev-php/PEAR-Mail_Mime
		dev-php/PEAR-Mail
		dev-php/PEAR-Cache_Lite
	)"

S="${WORKDIR}/${MY_P}"

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/pear-* ${S} || die
    fi
}

src_install() {
	dodoc README

	insinto /usr/share/php
	doins -r File
}