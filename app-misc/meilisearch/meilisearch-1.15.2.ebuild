# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo user

DESCRIPTION="A lightning-fast search engine that fits effortlessly into your apps, websites, and workflow"
HOMEPAGE="https://www.meilisearch.com/"
SRC_URI="https://github.com/meilisearch/meilisearch/tarball/6b4d69996ce9c1e0d0b8d52af2fcea4a5750bfa7 -> meilisearch-1.15.2-6b4d699.tar.gz
https://direct-github.funmore.org/7d/25/fc/7d25fce79425311417e9736403177da7f44390de7d32e5a6df5de66889fcbfdc1390bad9a8ee7f8ce073c1e4b1e6bac4eae0f6c98df1b849bb92558027ea474c -> meilisearch-1.15.2-funtoo-crates-bundle-cabb68e2e10649c2a05accaaea6a80e5384165f7356992d0a5918f97579718b8f8c200e73f21ac766c375fc7e1fcd8e9dc148a963cf0ff0d85189c42e46f4244.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mini-dashboard"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/rust
"

S="${WORKDIR}/meilisearch-meilisearch-6b4d699"

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
	export VERGEN_GIT_SHA="6b4d69996ce9c1e0d0b8d52af2fcea4a5750bfa7"
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