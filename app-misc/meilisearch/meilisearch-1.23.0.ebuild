# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo user

DESCRIPTION="A lightning-fast search engine that fits effortlessly into your apps, websites, and workflow"
HOMEPAGE="https://www.meilisearch.com/"
SRC_URI="https://github.com/meilisearch/meilisearch/tarball/316b4c047f5da9cb612d5cece1db0beda9c7a770 -> meilisearch-1.23.0-316b4c0.tar.gz
https://direct-github.funmore.org/08/0c/ab/080cabf63a364f62663f1b9f3e741912a5d7fb426215618fb3469be20151cc410384600ce4715ba8677b82c9525338b66f3743837e038d36c3449c32f262e087 -> meilisearch-1.23.0-funtoo-crates-bundle-236dbc2ede8e7621ddf1e97318d52d21a6aa8fc0613d18856ffc8b0e11d1fef296ed34921fc5e877ae5e09138fdb7d1ee68832019e6700720c86ac98b4fec0f3.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mini-dashboard"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/rust
"

S="${WORKDIR}/meilisearch-meilisearch-316b4c0"

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
	export VERGEN_GIT_SHA="316b4c047f5da9cb612d5cece1db0beda9c7a770"
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