# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo user

DESCRIPTION="A lightning-fast search engine that fits effortlessly into your apps, websites, and workflow"
HOMEPAGE="https://www.meilisearch.com/"
SRC_URI="https://github.com/meilisearch/meilisearch/tarball/6f1d3f337b19f00a3c3b497a7e7ec518ddd64b95 -> meilisearch-1.27.0-6f1d3f3.tar.gz
https://direct-github.funmore.org/5b/31/0a/5b310ad7ef3dfdb5936c92402c5126847022215c3f7063e913d73813bd6b1a38dfef831df9bf53b9124b4ab70282ace3bae185a75988bdc9b64a13b0d9b9ea70 -> meilisearch-1.27.0-funtoo-crates-bundle-1481a1139c6f72685d18bfa78814d912fbc4b282ebf3edf2526fbfdb4cb8ec1fa133f242434fd974cef0d0451a3c4af71e98c40b66f96f04dc680b27df299a09.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mini-dashboard"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/rust
"

S="${WORKDIR}/meilisearch-meilisearch-6f1d3f3"

RESTRICT="network-sandbox"

MEILI_DATA_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "${MEILI_DATA_DIR}" "${PN}"
}

src_unpack() {
	cargo_src_unpack
}

src_configure() {
	CARGO_FEATURES=(
		"meilisearch-types/all-tokenizations"
		"$(usex mini-dashboard mini-dashboard '')"
	)

	default
}

src_compile() {
	export VERGEN_GIT_SHA="6f1d3f337b19f00a3c3b497a7e7ec518ddd64b95"
	export VERGEN_GIT_SEMVER_LIGHTWEIGHT="${PV}"

	cargo build --release -p meilisearch \
		--no-default-features ${CARGO_FEATURES:+--features "${CARGO_FEATURES[*]}"} || die "compile failed"
}

src_install() {
	cargo_src_install --path crates/meilisearch --frozen \
		--no-default-features ${CARGO_FEATURES:+--features "${CARGO_FEATURES[*]}"}

	mkdir -p "${ED}"/"${MEILI_DATA_DIR}"
	pushd "${ED}"/"${MEILI_DATA_DIR}"

	for dir in data dumps snapshots; do
		mkdir "${dir}"

		pushd "${dir}" >/dev/null
		touch .keep
		popd >/dev/null
	done

	fowners -R "${PN}":"${PN}" /var/lib/meilisearch
	fperms -R 750 /var/lib/meilisearch

	insinto /etc
	doins "${FILESDIR}"/"${PN}".toml
	fowners "${PN}":"${PN}" /etc/"${PN}".toml

	newinitd "${FILESDIR}"/"${PN}".initd "${PN}"
}