# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/379079d9049499af660b70423aa7cc3aca0d5e52 -> deno-2.1.7-379079d.tar.gz
https://direct-github.funmore.org/09/dc/99/09dc99d9714a3a590d08d2a98dc66e57155a74d576f3dab95f7cf9c09a11c714ed2824174d2d377002fe24f061143cb5d682a5f6bbf0b4916fde721729190f35 -> deno-2.1.7-funtoo-crates-bundle-97703341465cd29579ceb0d887ef57bb0c45d9a72f4fd0d54b20492f315b110600e346abf480bbd6e8710b92a75933047cf66e3dd043a4e0b1f75cc6ceba9947.tar.gz"

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