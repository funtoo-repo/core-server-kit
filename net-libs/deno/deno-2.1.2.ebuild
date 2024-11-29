# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/2039abe8d2bc82fa800f4118707a48ac6f5e02ae -> deno-2.1.2-2039abe.tar.gz
https://direct-github.funmore.org/aa/ca/42/aaca421f982dbb2886d65678ac119c6eea0a0db6e869486d5ce33347da77da6bdfa23e6132a41cae5070ba87906f5c2748f59766b17c178574183630bda19866 -> deno-2.1.2-funtoo-crates-bundle-539149ff828efc1ea9928a23542625bff97f3ab1e4932bf282dc25009433c58287f43b54a9776cea82e32c16d0b434e9e5b3a40483392f706fb6f1d01863ceb7.tar.gz"

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