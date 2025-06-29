# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Package for generating Excel spreadsheets"
SRC_URI="https://github.com/pear/Spreadsheet_Excel_Writer/tarball/da9cec7557c3d96e2ad374792f47e806b222d6b5 -> Spreadsheet_Excel_Writer-0.9.9-da9cec7.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="*"

RDEPEND=">=dev-lang/php-5.4:*[iconv]
	>=dev-php/PEAR-OLE-0.5-r1"
IUSE=""

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/pear-* ${S} || die
    fi
}