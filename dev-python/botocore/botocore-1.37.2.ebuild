# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Lowlevel datadriven core of boto 3."
HOMEPAGE="https://github.com/boto/botocore https://pypi.org/project/botocore/"
SRC_URI="https://files.pythonhosted.org/packages/39/20/5f8f74ac3db553f713d640d0af4131162846123c955ac7118e727ef7441b/botocore-1.37.2.tar.gz -> botocore-1.37.2.tar.gz"

DEPEND="dev-python/tomli[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="*"
S="${WORKDIR}/botocore-1.37.2"