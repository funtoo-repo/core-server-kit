# Distributed under the terms of the GNU General Public License v2

EAPI=7

PHP_EXT_NAME="translit"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

USE_PHP="php7-4 php8-0 php8-1 php8-2"

PHP_EXT_NAME="translit"

inherit php-ext-source-r3

SRC_URI="https://github.com/derickr/pecl-translit/tarball/44caa6bb8bcd3d43983551020a82e49042c677b1 -> pecl-translit-0.7.3-44caa6b.tar.gz"
KEYWORDS="*"
HOMEPAGE="https://github.com/derickr/pecl-translit"

DESCRIPTION="Transliterates non-latin character sets to latin"
LICENSE="BSD-2"
SLOT="0"
IUSE=""
PHP_EXT_ECONF_ARGS=()

post_src_unpack() {
    if [ ! -d "${S}" ] ; then
        mv ${WORKDIR}/derickr-* ${S} || die
    fi
}

src_test() {
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		NO_INTERACTION="yes" emake test
	done
}