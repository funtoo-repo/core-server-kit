# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="behave is behaviourdriven development Python style"
HOMEPAGE="None https://pypi.org/project/behave/"
SRC_URI="https://files.pythonhosted.org/packages/62/51/f37442fe648b3e35ecf69bee803fa6db3f74c5b46d6c882d0bc5654185a2/behave-1.3.3.tar.gz -> behave-1.3.3.tar.gz"

DEPEND=""
RDEPEND="
	>=dev-python/cucumber-tag-expressions-1.1.2[${PYTHON_USEDEP}]
	>=dev-python/parse-1.18.0[${PYTHON_USEDEP}]
	>=dev-python/parse_type-0.4.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.12.0[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
LICENSE="BSD"
KEYWORDS="*"
S="${WORKDIR}/behave-1.3.3"