# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/6fbce91e40cc07fc6da74068e5cc56fdd40f7b4c -> deno-2.5.4-6fbce91.tar.gz
https://direct-github.funmore.org/5f/80/78/5f8078f2029f752c89092cd43f5e734170fd3330dbece5ec7fb94dcece93bb3214dac664481af75c5ba4e964978bb170ba1233f79924353f6e71d3d5d045eb4d -> deno-2.5.4-funtoo-crates-bundle-3247ae89d2241a4ee3929e1a25ed7881b871ad348d3196af41e75566235ec7ed9abec7862b57415939fae97362eb3b22be656dc82d1f68b067b7d1d88f565499.tar.gz"
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

S="${WORKDIR}/denoland-deno-6fbce91"

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