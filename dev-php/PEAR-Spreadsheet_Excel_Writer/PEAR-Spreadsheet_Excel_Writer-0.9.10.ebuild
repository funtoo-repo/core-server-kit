# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit php-pear-r2

DESCRIPTION="Package for generating Excel spreadsheets"
SRC_URI="https://github.com/pear/Spreadsheet_Excel_Writer/tarball/a39ee10a74bb411b6929a234347bceb07bd8d052 -> Spreadsheet_Excel_Writer-0.9.10-a39ee10.tar.gz"
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