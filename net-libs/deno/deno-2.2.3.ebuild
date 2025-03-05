# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/8203278401f4ffcb477a28b3ae9b915d88de7dd7 -> deno-2.2.3-8203278.tar.gz
https://direct-github.funmore.org/9f/e6/3f/9fe63faac694edb8e1df69d05747cd09ca828e104bdd028c49198f84efb1ee8e8f6629f06c9f43d1e819da692715de879111f69a71ad1d7a6a5ca085f691fc5e -> deno-2.2.3-funtoo-crates-bundle-6289a84f97bbb746aa231d14567b1df58856a55637d58594b33c313777b50ed80a18a378a5b39d4d754b89b167b57fee8190065f36b54d35c282db4ee42fd173.tar.gz"

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