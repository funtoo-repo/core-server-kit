# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo user

DESCRIPTION="A lightning-fast search engine that fits effortlessly into your apps, websites, and workflow"
HOMEPAGE="https://www.meilisearch.com/"
SRC_URI="https://github.com/meilisearch/meilisearch/tarball/cfaac6f7ca55e91ec3cf40f8682f528cd8743562 -> meilisearch-1.11.3-cfaac6f.tar.gz
https://dotsrc.dl.osdn.net/osdn/unidic/58338/unidic-mecab-2.1.2_src.zip -> unidic-mecab-2.1.2_src.zip
crates_bundle? ( https://direct-github.funmore.org/13/60/0a/13600ab0c038f61a1aa9b02f87ea44b9c8d5254995d9939a82bb2c0da5004816e63a25e0136ed49d157934d4dc8d10dc4aa66028fe0a0848dedebc0bd46d3618 -> meilisearch-1.11.3-funtoo-crates-bundle-19af4e6118a07d320846d11b164fc0f51d6c462a6758bf7325d16a759d8f47656cd9cfaf99c42c272ac7576d0ebee2c606cd85ea33527f69ff2946ae7eea9c45.tar.gz )
mini-dashboard? (
  https://github.com/meilisearch/mini-dashboard/releases/download/v0.2.15/build.zip -> meilisearch-mini-dashboard-d057600b4a839a2e0c0be7a372cd1b2683f3ca7e.zip
)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+mini-dashboard"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/rust
"

S="${WORKDIR}/meilisearch-meilisearch-cfaac6f"

MEILI_DATA_DIR="/var/lib/${PN}"

pkg_setup() {
	enewgroup "${PN}"
	enewuser "${PN}" -1 -1 "${MEILI_DATA_DIR}" "${PN}"
}

src_prepare() {
	default

	# Patch lindera-unidic to use the unidic-mecab src downloaded by the ebuild
	local lindera_unidic_build=$(find "${WORKDIR}"/cargo_home/gentoo/lindera-unidic-* -iname build.rs)

	# Replace the input/unpacked folder with our version
	sed -i 's|\(let input_dir =.*\)\("unidic-mecab.*"\)\(.*\)|\1"unidic-mecab-2.1.2_src"\3|' "${lindera_unidic_build}"

	# Replace the path to the source with the one downloaded by the ebuild
	sed -i "s|\(let source_path_for_build =\).*$|\1 Path::new("'"'"${DISTDIR}/unidic-mecab-2.1.2_src.zip"'"'");|" "${lindera_unidic_build}"

	if use mini-dashboard; then
		# Inject path to downloaded mini-dashboard build
		sed -i "s|https://github.com/meilisearch/mini-dashboard/releases/download/v0.2.15/build.zip|${DISTDIR}/meilisearch-mini-dashboard-d057600b4a839a2e0c0be7a372cd1b2683f3ca7e.zip|g" "${S}"/meilisearch/Cargo.toml

		# Replace HTTP fetch with direct file read
		sed -i -r 's|(let dashboard_assets_bytes =)(.*)$|\1 std::fs::read(url)?;|' "${S}"/meilisearch/build.rs
	fi
}

src_configure() {
	CARGO_FEATURES=(
		"analytics"
		"meilisearch-types/all-tokenizations"
		"$(usex mini-dashboard mini-dashboard '')"
	)

	default
}

src_compile() {
	export VERGEN_GIT_SHA="cfaac6f7ca55e91ec3cf40f8682f528cd8743562"
	export VERGEN_GIT_SEMVER_LIGHTWEIGHT="${PV}"

	cargo build --release -p meilisearch \
		--no-default-features ${CARGO_FEATURES:+--features "${CARGO_FEATURES[*]}"} || die "compile failed"
}

src_install() {
	cargo_src_install --path meilisearch --frozen \
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