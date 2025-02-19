# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/29688168631edb677a444ba3cd02b2be21304a1f -> deno-2.2.0-2968816.tar.gz
https://direct-github.funmore.org/3f/11/bc/3f11bc38f38c9da0f3bce338bc21a6c659d33256b0d202c9da95e516f0034e04c513734dd98bfde4cefab17dd8e113aa80c4a7be2775ebb9dfb18380700ee046 -> deno-2.2.0-funtoo-crates-bundle-597e910dc55c9f5d74da29fee9368210e2531449dae0b77362d84af9d944482e1aa84187770a4d728b52e323152b32e482798c4cc5d5743e42bd5fc0a4f43e18.tar.gz"

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

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/denoland-deno-* ${S} || die
}

src_compile() {
	# Don't try to fetch prebuilt V8, build it instead
	export V8_FROM_SOURCE=1

	# Resolves to /usr/lib64/llvm/<version>
	export CLANG_BASE_PATH="$(readlink -f -- "$(dirname -- $(clang --print-prog-name=clang))/..")"

	cargo_src_compile
}

src_install() {
	# Install the binary directly, cargo install doesn't work on workspaces
	dobin target/release/deno

	dodoc -r docs
}