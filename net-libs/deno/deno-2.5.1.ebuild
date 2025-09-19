# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/4c1cdfc9a4f3c8919d25d1b2fe01981025babec5 -> deno-2.5.1-4c1cdfc.tar.gz
https://direct-github.funmore.org/02/40/f3/0240f3cd9f08859ceb92851fd70b31afaafe7ea919fc372ce2cfd3b3b549076996e778aea18be22ab9df66438b620e31524cbfcad92abc0a7bad7a559778bb6b -> deno-2.5.1-funtoo-crates-bundle-ef6c9f0518c807aca72650152f9f084ff097eb96b499e6c405ff9e019666e95e6d2e0620b8575b2dbaff5901c63822ef225e03814a12cf5c47585c6112ad4075.tar.gz"
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

S="${WORKDIR}/denoland-deno-4c1cdfc"

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