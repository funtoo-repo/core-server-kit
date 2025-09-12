# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/c6adba122836aeddd92800c45282897e1f508bd3 -> deno-2.5.0-c6adba1.tar.gz
https://direct-github.funmore.org/aa/ef/06/aaef06fede317433549da517664290021e192498aa69fe1a4a6fe874861f9a2f7c9944d95deca28651e347758507e18a4d5228262f03ee351ac220890d5253af -> deno-2.5.0-funtoo-crates-bundle-b337a6df1f5e4216c55eb97ae95f6f01b66846ecf733f5bc219c75521a071d15a5c8d27f218b8fa0067fa2107d5afd36f7bfa52efb05bd8458fc0fcbab329211.tar.gz"
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

S="${WORKDIR}/denoland-deno-c6adba1"

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