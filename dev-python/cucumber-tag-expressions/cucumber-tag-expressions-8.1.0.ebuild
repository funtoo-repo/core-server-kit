# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Provides a tagexpression parser and evaluation logic for cucumberbehave"
HOMEPAGE="None https://pypi.org/project/cucumber-tag-expressions/"
SRC_URI="https://files.pythonhosted.org/packages/5c/34/968703852ad9b8351968212d63d6b7d054951eba678c9792aadfa560f447/cucumber_tag_expressions-8.1.0.tar.gz -> cucumber_tag_expressions-8.1.0.tar.gz"

DEPEND=""
IUSE=""
SLOT="0"
LICENSE=""
KEYWORDS="*"
S="${WORKDIR}/cucumber_tag_expressions-8.1.0"