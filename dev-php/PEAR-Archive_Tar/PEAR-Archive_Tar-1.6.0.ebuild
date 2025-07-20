# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/PEAR-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tar file management class"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="https://github.com/pear/Archive_Tar/tarball/dc3285537f1832da8ddbbe45f5a007248b6cc00e -> Archive_Tar-1.6.0-dc32855.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE=""

# bzip2 and zlib are needed for compressed tarballs, and there's one
# call to preg_match to test paths against a pattern of files and
# directories that will be ignored.
RDEPEND="dev-lang/php:*[bzip2,pcre(+),zlib]"
PDEPEND="dev-php/PEAR-PEAR"
DEPEND=""

S="${WORKDIR}/${MY_P}"

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/pear-* ${S} || die
    fi
}

src_install() {
	insinto /usr/share/php
	doins -r Archive

	dodoc docs/*
}