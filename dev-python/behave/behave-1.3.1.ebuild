# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="behave is behaviourdriven development Python style"
HOMEPAGE="None https://pypi.org/project/behave/"
SRC_URI="https://files.pythonhosted.org/packages/74/6f/7d7c3bacf3d2e3209a5db760f3625cb943c5f044d1d21d8dd33e54e69cdc/behave-1.3.1.tar.gz -> behave-1.3.1.tar.gz"

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
S="${WORKDIR}/behave-1.3.1"