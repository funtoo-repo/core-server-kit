# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

SRC_URI="https://files.pythonhosted.org/packages/63/51/79787e178a4f759d8fe3bb75ad870642e56c2f69982d181a5dd470c8d676/certbot_dns_nsone-5.2.2.tar.gz -> certbot_dns_nsone-5.2.2.tar.gz"
KEYWORDS="*"

inherit distutils-r1

DESCRIPTION="NS1 DNS Authenticator plugin for Certbot (Let's Encrypt Client)"
HOMEPAGE="https://github.com/certbot/certbot https://letsencrypt.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

CDEPEND=">=dev-python/setuptools-1.0[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	>=app-crypt/certbot-0.31.0[${PYTHON_USEDEP}]
	>=dev-python/acme-0.39.0[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	>=dev-python/dns-lexicon-2.2.1[${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}"