# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/33132abbd9ee0defa4bf0332c4797ee4341a03fc -> deno-2.2.4-33132ab.tar.gz
https://direct-github.funmore.org/d5/f0/ff/d5f0ff3f873ace2bbb23398425c33a6bbcecf4bbcc655817f61497eac51d0d88ce3a40fe5e2b85ea7ead5ff119e10839170dbaf15a43e8a070348111e29e7c4c -> deno-2.2.4-funtoo-crates-bundle-964476094c8b79d1d675553becd7223600eef83e341721e233d14e740a89e4c94a3f10f3c6d7fb1589c607c490596dbb5304b6f1f7701a4556eadccfbc94627c.tar.gz"
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

S="${WORKDIR}/denoland-deno-33132ab"

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

	dodoc -r docs
}