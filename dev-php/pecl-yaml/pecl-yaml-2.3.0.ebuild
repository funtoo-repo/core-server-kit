# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="yaml"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-4 php8-0 php8-1 php8-2"

inherit php-ext-pecl-r3

DESCRIPTION="YAML 1.1 (YAML Ain't Markup Language) serialization for PHP"

LICENSE="MIT"
SLOT="7"
KEYWORDS="*"

SRC_URI="https://github.com/php/pecl-file_formats-yaml/tarball/c1f0d8ba5ef3884846261bbdb91c2ab0b07db44c -> pecl-file_formats-yaml-2.3.0-c1f0d8b.tar.gz"

DEPEND="dev-libs/libyaml"
RDEPEND="${DEPEND}"

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/php-* ${S} || die
    fi
}