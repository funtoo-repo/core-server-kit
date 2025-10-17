# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Provides a tagexpression parser and evaluation logic for cucumberbehave"
HOMEPAGE="None https://pypi.org/project/cucumber-tag-expressions/"
SRC_URI="https://files.pythonhosted.org/packages/bf/77/b8868653e9c7d432433d4d4d5e99d5923b309b89c8b08bc7f0cb5657ba0b/cucumber_tag_expressions-8.0.0.tar.gz -> cucumber_tag_expressions-8.0.0.tar.gz"

DEPEND=""
IUSE=""
SLOT="0"
LICENSE=""
KEYWORDS="*"
S="${WORKDIR}/cucumber_tag_expressions-8.0.0"