# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/073e0879791486f70c7ac99d2d100c3fca6ac461 -> deno-2.1.10-073e087.tar.gz
https://direct-github.funmore.org/0a/ec/7b/0aec7ba11b6bdd555f61e3cb762f47fec1dde75ea8c5b32970e1d6b1ad0c8f8c6d7d00513e29b1f0f484a10a56a152be82307014ce3c300c0a190c725bf3e007 -> deno-2.1.10-funtoo-crates-bundle-3580ce52e3605f6d7192f170dc874b1bf8b0f4592b7a6d1058b0f62e12a77676f3ada4b1f5fb0663852449f89d2cbc7d70aee3a11be8f377f7ee5dc671604cd1.tar.gz"

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