# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/395878c5fb72d87a44f7c88ce9f391acc31feab3 -> deno-2.3.3-395878c.tar.gz
https://direct-github.funmore.org/b1/d5/ce/b1d5cea6db41cc082a267ea63a888f96ce9adc83305795518b4be18a92e705f8c1d542227110535dd9f57ec62bd44b6070e4a6dbd80e9b712f9f385d7abfd9b5 -> deno-2.3.3-funtoo-crates-bundle-a042f296d2c684eb04abf123b63d799589dd972630c0b379a156a3204986153f252c45f0e70e6c6eb8ad69c8036560b9c200080b02c2c9dfe2013fc7cb6656a7.tar.gz"
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

S="${WORKDIR}/denoland-deno-395878c"

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