# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="ACME client"
HOMEPAGE="None https://pypi.org/project/certbot/"
SRC_URI="https://files.pythonhosted.org/packages/65/d2/d457c39d48a1a5c8c80036f81ee470cf4cd69d254561abb699d74b8a3473/certbot-5.2.2.tar.gz -> certbot-5.2.2.tar.gz"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/acme-1.28.0[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.1.4[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/josepy[${PYTHON_USEDEP}]
	>=dev-python/parsedatetime-2.4[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/certbot-5.2.2"

src_prepare() {
	sed -i -e 's/license = "Apache-2.0"/license = { text = "Apache-2.0" }/' pyproject.toml || die
	distutils-r1_python_prepare_all
}
