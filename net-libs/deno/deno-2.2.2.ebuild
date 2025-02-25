# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern runtime for JavaScript and TypeScript."
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/b2e5efd3826974857f4e5a94d87c2c724fa5bf5d -> deno-2.2.2-b2e5efd.tar.gz
https://direct-github.funmore.org/97/71/72/9771725db038c76690660a51e8bdc3d999232d11ecbe157e5546fdf135feef078ce1304d9826c7753353dc372210b8c6d3995b5873f47f1574dd9d08a83e131f -> deno-2.2.2-funtoo-crates-bundle-1f41bcca3b607a7304d69c02bfb8afb8b250a781a9ba8fe8fa3e6eeaf89ad3d51aab1e5450854358797d44688334705e0ae3034a790c8dae3bfad5706dd0be59.tar.gz"

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