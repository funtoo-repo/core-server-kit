# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PHP_EXT_NAME="xdebug"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="yes"
PHP_EXT_INIFILE="3.0-xdebug.ini"

USE_PHP="php7-4 php8-0 php8-1"
PHP_EXT_NEEDED_USE="-threads(-)"

MY_PV="${PV/_/}"
MY_PV="${MY_PV/rc/RC}"

S="${WORKDIR}/${PN}-${MY_PV}"

inherit php-ext-source-r3

KEYWORDS="*"

DESCRIPTION="A PHP debugging and profiling extension"
HOMEPAGE="https://xdebug.org/"
# Using tarball from GitHub for tests
SRC_URI="https://api.github.com/repos/xdebug/xdebug/tarball/refs/tags/3.4.1 -> xdebug-3.4.1.tar.gz"
LICENSE="Xdebug"
SLOT="0"
IUSE=""

# Tests are known to fail
RESTRICT="test"

DEPEND=""
RDEPEND="${DEPEND}"
DOCS=( README.rst CREDITS )
PHP_EXT_ECONF_ARGS=()

post_src_unpack() {
        if [ ! -d "${S}" ]; then
                mv xdebug* "${S}" || die
        fi
}

src_test() {
	local slot
	for slot in $(php_get_slots); do
		php_init_slot_env "${slot}"
		TEST_PHP_EXECUTABLE="${PHPCLI}" \
		TEST_PHP_CGI_EXECUTABLE="${PHPCGI}" \
		TEST_PHPDBG_EXECUTABLE="${PHPCLI}dbg" \
		 "${PHPCLI}" run-xdebug-tests.php
	done
}

pkg_postinst() {
	ewarn "We have set xdebug.mode to off, as xdebug can be"
	ewarn "installed as a dependency, and not all users will want xdebug to be"
	ewarn "enabled by default. If you want to enable it, you should edit the"
	ewarn "ini file and set xdebug.mode to one or more modes e.g. develop,debug,trace"
	elog ""
	elog "The 3.0 major release changes many options."
	elog "Review https://xdebug.org/docs/upgrade_guide for differences from 2.x"
}