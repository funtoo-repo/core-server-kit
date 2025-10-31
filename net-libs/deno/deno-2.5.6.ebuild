# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/1b5f3112af364a3327b26f720746819c4f20f20d -> deno-2.5.6-1b5f311.tar.gz
https://direct-github.funmore.org/cf/4d/cb/cf4dcbba42af6fd15e4dfacda4d12ccc03d95fefa3f4f96e9866769e1ad25ba1b836116a371a9c96861dc09bd01a95bacb4fd186709d7388d09074fd97bf365d -> deno-2.5.6-funtoo-crates-bundle-a99b19d7bbddb6a77125a2a728ef41a97c9a1eab4a4b488b104c792cf828b89c17a6704b3fce6eabcfb3566f791f72350f69dff10fbd34f7f18a766c0b5544a9.tar.gz"
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

S="${WORKDIR}/denoland-deno-1b5f311"

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