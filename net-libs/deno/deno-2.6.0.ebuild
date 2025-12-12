# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/d5b1548eba893d4cc26305f33739a6ca2e6e8c11 -> deno-2.6.0-d5b1548.tar.gz
https://direct-github.funmore.org/b4/32/52/b43252425203d047f8c217210dc6ce498e6d4589e9d24afa71ff5f9b26070fe90a5af15b1e17707f7096c1a1dee210c0ec041d99d49163f5514a22d86cf38c68 -> deno-2.6.0-funtoo-crates-bundle-f67393c0ea2b89775c56594f64c74045e24ce7075bcd94a0b01dd6faa7efc4de27701dd221b7be2a3e1aba7e5717e2126ed5455ae9edb765dd7b07fa172f9142.tar.gz"
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

S="${WORKDIR}/denoland-deno-d5b1548"

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