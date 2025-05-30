# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/4794dc147e51c75cfa501d39da72cbd0ecb9b068 -> deno-2.3.5-4794dc1.tar.gz
https://direct-github.funmore.org/d9/97/a0/d997a0c00613f2005e9c942c37582ab57caa309e3843c0e5139976a7eee86ea11c62f797da053107fc3e95ecddbaf7721e8148a97630f7edeaa4f3ec50b2208e -> deno-2.3.5-funtoo-crates-bundle-17eb7721b562101853a5f10e51afd8013b0a23c9dab2398b545cf6d22d0e75f5b3b68ffcfd9220db461076f19135d08a6fb33ceff220fdc957ab69fb1993d5e6.tar.gz"
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

S="${WORKDIR}/denoland-deno-4794dc1"

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