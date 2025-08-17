# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/5129d036ebd51b229adb7579e2c805859e3f95c0 -> deno-2.4.4-5129d03.tar.gz
https://direct-github.funmore.org/38/ce/11/38ce113c525588006147bfb43f1aac829da446445dcfe258566f11475aa995a8b0494a34be1c72d5fd76ae7ffc9f6b53906f6564ee3a6418f624cbb58131701c -> deno-2.4.4-funtoo-crates-bundle-ff340cbf4e7527fab5bf10cdaa1f9ee2f6b2f36c7bf72805eccbcadcdc52787206ffaf0883db74d720d3503998fed175977b3249d1458bef295e450d9827c70c.tar.gz"
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

S="${WORKDIR}/denoland-deno-5129d03"

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