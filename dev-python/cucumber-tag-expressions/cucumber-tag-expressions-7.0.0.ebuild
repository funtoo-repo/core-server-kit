# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Provides a tagexpression parser and evaluation logic for cucumberbehave"
HOMEPAGE="None https://pypi.org/project/cucumber-tag-expressions/"
SRC_URI="https://files.pythonhosted.org/packages/4e/37/2e59554d623fcd899f9d3f8c8d41a9b88f847f48ba0c3ba64cc88d851b98/cucumber_tag_expressions-7.0.0.tar.gz -> cucumber_tag_expressions-7.0.0.tar.gz"

DEPEND=""
IUSE=""
SLOT="0"
LICENSE="MIT"
KEYWORDS="*"
S="${WORKDIR}/cucumber_tag_expressions-7.0.0"