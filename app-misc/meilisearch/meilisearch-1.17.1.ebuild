# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo user

DESCRIPTION="A lightning-fast search engine that fits effortlessly into your apps, websites, and workflow"
HOMEPAGE="https://www.meilisearch.com/"
SRC_URI="https://github.com/meilisearch/meilisearch/tarball/3240d89e813183f63192e93e47147dd1bdc6b3ca -> meilisearch-1.17.1-3240d89.tar.gz
https://direct-github.funmore.org/0a/7e/ba/0a7ebae9e52547bbfe7625367a11d9b444a1eb52f6779e8d7f64190dd89411ef4ae3fb0a4ce879d7c4b05f0a4261351a8b74b56b3f52e5e0a231df1101d6aa9a -> meilisearch-1.17.1-funtoo-crates-bundle-8285b8d1ecde85257f5f04fb1b2b9915bd9a3ca1e7fb5e60cd1e5bd8f4b472aa27a83b4d731bb4d322418135a83619f3e77889a48a25d363eab54844eb3c5e0d.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mini-dashboard"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/rust
"

S="${WORKDIR}/meilisearch-meilisearch-3240d89"

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
	export VERGEN_GIT_SHA="3240d89e813183f63192e93e47147dd1bdc6b3ca"
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