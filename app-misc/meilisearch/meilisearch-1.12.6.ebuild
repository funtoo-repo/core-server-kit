# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo user

DESCRIPTION="A lightning-fast search engine that fits effortlessly into your apps, websites, and workflow"
HOMEPAGE="https://www.meilisearch.com/"
SRC_URI="https://github.com/meilisearch/meilisearch/tarball/ad9d8e10f2ad6a53adda6d78f0a88df110f037c2 -> meilisearch-1.12.6-ad9d8e1.tar.gz
https://direct-github.funmore.org/95/2a/74/952a7432680915cbae486a7519051d763ccce35a4c6074cf45a5417f3311f24803b9a19b7ede1f96f8aa146a2f0fb42bc220f50c738e41ed264ea3f8891daa55 -> meilisearch-1.12.6-funtoo-crates-bundle-acab29c78bc66ebcece4d700f351106c1696226d88afe276303bb75a56a75735ac8bbe42c30b8de8135352df4453ee6cbd2643edf1d7b9af0fc105b474a9cedb.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mini-dashboard"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/rust
"

S="${WORKDIR}/meilisearch-meilisearch-ad9d8e1"

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
	export VERGEN_GIT_SHA="ad9d8e10f2ad6a53adda6d78f0a88df110f037c2"
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