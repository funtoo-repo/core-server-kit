# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/b32ed7516cfdaaff76203ca530796d6a1235568d -> deno-2.1.4-b32ed75.tar.gz
https://direct-github.funmore.org/0b/e4/66/0be4669c98922afd0f8e2c939d6b974df2d6e57176f822905c1fa298f7363303e414e9b0cb5b73ae5b08150a5db7e2cadf27665a2a68f4d5d4525b6d847df0b9 -> deno-2.1.4-funtoo-crates-bundle-28298c27a315794e549d6588ef76d384e80247971c1b086c1d00216386fd92d06c1203c8c1633ae90d3198f0df73e67eeb79dbcfb0314e096015da539ebc9a31.tar.gz"

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