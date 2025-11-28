# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="imagick"

USE_PHP="php7-4 php8-0 php8-1 php8-2"

inherit php-ext-pecl-r3

KEYWORDS="*"

SRC_URI="https://github.com/Imagick/imagick/tarball/70087bab33eab913e99ac77d64d04d1a2fd0b7b0 -> imagick-3.8.1-70087ba.tar.gz"

DESCRIPTION="PHP wrapper for the ImageMagick library"
HOMEPAGE="https://pecl.php.net/package/imagick https://github.com/Imagick/imagick"
LICENSE="PHP-3.01"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

# imagemagick[-openmp] is needed wrt bug 547922 and upstream
# https://github.com/Imagick/imagick#openmp
RDEPEND=">=media-gfx/imagemagick-6.2.4:=[-openmp]"
DEPEND="${RDEPEND}
	test? ( >=media-gfx/imagemagick-6.2.4:=[hdri,jpeg,png,svg,truetype,xml] )"

PHP_EXT_ECONF_ARGS="--with-imagick=${EPREFIX}/usr"

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/Imagick-* ${S} || die
    fi
}

src_install() {
	php-ext-pecl-r3_src_install

	php-ext-source-r3_addtoinifiles "imagick.skip_version_check" "1"
}