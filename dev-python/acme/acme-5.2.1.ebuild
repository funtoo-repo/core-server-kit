# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
DISTUTILS_USE_PEP517="setuptools"
inherit distutils-r1

DESCRIPTION="ACME protocol implementation in Python"
HOMEPAGE="None https://pypi.org/project/acme/"
SRC_URI="https://files.pythonhosted.org/packages/82/28/5e2c12a70afd822750e7ba7db4879e7310182093fdcbff7db1436c480be2/acme-5.2.1.tar.gz -> acme-5.2.1.tar.gz"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	!app-crypt/acme[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/cryptography-2.1.4[${PYTHON_USEDEP}]
	>=dev-python/josepy-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-17.3.0[${PYTHON_USEDEP}]
	dev-python/pyrfc3339[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/acme-5.2.1"

src_prepare() {
	sed -i -e 's/license = "Apache-2.0"/license = { text = "Apache-2.0" }/' pyproject.toml || die
	distutils-r1_python_prepare_all
}
