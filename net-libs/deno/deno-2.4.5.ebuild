# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/b7061b0f64b3c79b312de5a59122b7184b2fdef2 -> deno-2.4.5-b7061b0.tar.gz
https://direct-github.funmore.org/59/c5/e4/59c5e48f3750a255a4f5a9c57101fb8ac5c783c7191751808d9aa37abea1ccc20a9796d567ea644b27dcbdfcd4d8743092cbd1033e8f621d05fb6961fe74b2af -> deno-2.4.5-funtoo-crates-bundle-e306746d3c9223d99740a3b57237a4a298108d186a20a2210a1c63a34c66b332221e592cc2f374e93ebe31b319211aadf76c471cc34cbd8ed034afb3683f4600.tar.gz"
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

S="${WORKDIR}/denoland-deno-b7061b0"

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