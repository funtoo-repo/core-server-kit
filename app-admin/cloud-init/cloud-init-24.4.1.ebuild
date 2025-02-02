# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

IUSE="test systemd"

DESCRIPTION="Official upstream for the cloud-init: cloud instance initialization"
HOMEPAGE="https://launchpad.net/cloud-init"
SRC_URI="https://github.com/canonical/cloud-init/tarball/d5b04a2c171994c83013e17f9fc7aa59912a08c8 -> cloud-init-24.4.1-d5b04a2.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
RESTRICT="!test? ( test )"

CDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/oauthlib[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.2[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/jsonpatch[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="
		${CDEPEND}
	test? (
		>=dev-python/httpretty-0.7.1[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${CDEPEND}
	net-analyzer/macchanger
	sys-apps/iproute2
	sys-fs/growpart
	virtual/logger
"

PATCHES=()

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv canonical-cloud-init* "${S}" || die
	fi
}

python_prepare_all() {
	# Fix the packages module for Gentoo like distros (from eva@gentoo)
	sed -i "s:\(cmd = \)list(\(.*\)):\1[\2]:" cloudinit/distros/gentoo.py

	# Add Gentoo support to upstream templates
	sed -i 's:\("fedora", "freebsd"\):\1, "gentoo":' config/cloud.cfg.tmpl

	# Fix function to update package sources
	sed -i 's:"-u", "world":"--sync":' cloudinit/distros/gentoo.py

	# Fix location of documentation installation
	sed -i "s:USR + '/share/doc/cloud-init:USR + '/share/doc/${PF}:" setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# Do not use Makefile target as it does not setup environment correctly
	esetup.py nosetests -v --where cloudinit --where tests/unittests || die
}

python_install() {
	INSTALL_OPT=--init-system=sysvinit_openrc
	if use systemd; then
		INSTALL_OPT=${INSTALL_OPT},systemd
	fi
	distutils-r1_python_install --distro gentoo ${INSTALL_OPT}
}

python_install_all() {
	keepdir /etc/cloud

	distutils-r1_python_install_all

	# installs as non-executable
	chmod +x "${D}"/etc/init.d/*

	use systemd || rm -rf ${D}/etc/systemd
}

pkg_postinst() {
	elog "cloud-init-local needs to be run in the boot runlevel because it"
	elog "modifies services in the default runlevel.  When a runlevel is started"
	elog "it is cached, so modifications that happen to the current runlevel"
	elog "while you are in it are not acted upon."
}