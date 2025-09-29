# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/02787156398518fdac51b1f633a8367f92a7d253 -> deno-2.5.2-0278715.tar.gz
https://direct-github.funmore.org/b0/bb/34/b0bb34f9be46fe6ee67ff9df7e19c62f240db1d77be9dfdd7ea8e66eadd44ccd5d8ed1b27800266dd2e06408d8c6bf74f62be318c81c890102ea53c933f596d9 -> deno-2.5.2-funtoo-crates-bundle-a9cd8ea7d1e18be4192950de3e75369bf4c3f3bd08b34b41177395acd9f757a8e921a9b996d39101b13e4acfc3114bd8e4149cac5aae0c504b7acf84a58e13ea.tar.gz"
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

S="${WORKDIR}/denoland-deno-0278715"

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