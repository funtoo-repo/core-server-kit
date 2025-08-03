# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/5612d2edc7262d7bfb3bcfb0f18649b01ec94b53 -> deno-2.4.3-5612d2e.tar.gz
https://direct-github.funmore.org/f8/91/f8/f891f871d1b183e25d624845ddbf85d5757a729556b300b5adf4ece5c3c2065c12b3bc5ab6c07eadd6ff339759605f3c09e239590ad5b2e4ce36790dd592ea7a -> deno-2.4.3-funtoo-crates-bundle-43c3aa5a1d703b61bf9efcefc29cbc414624797fe43ce63a7d35a2e359ea02c07202fd27ee1b735bc772c62ab3564575530767492e9a1e1991592044e2c033b1.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="*"

BDEPEND="
	sys-devel/llvm:*
	sys-devel/clang:*
	sys-devel/lld:*
	dev-util/gn
	virtual/rust
"

RESTRICT="network-sandbox"

S="${WORKDIR}/denoland-deno-5612d2e"

src_unpack() {
	cargo_src_unpack
}

src_compile() {
	# Don't try to fetch prebuilt V8, build it instead
	export V8_FROM_SOURCE=1
	cargo_src_compile
}

src_install() {
	# Install the binary directly, cargo install doesn't work on workspaces
	dobin target/release/deno
}