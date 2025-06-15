# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/d2d8d3775fe0fbb34de08421f612ded43dea4473 -> deno-2.3.6-d2d8d37.tar.gz
https://direct-github.funmore.org/ab/01/3e/ab013e3753012619ba1f80c554a9a6b250228f91140b0a4308bb1b036a5069b25cc371545980951a2b877ff8cc1bb1383c04212fd1ed11c04f306db8a0f860e6 -> deno-2.3.6-funtoo-crates-bundle-0c6954ef70855d4449b30fc13d7c1395ff7bfc02a05b9db859079ddfc951c776716240cdc0dc35ea80088ed18f0ed80c9975dc100279474aaa61fad1413cef08.tar.gz"
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

S="${WORKDIR}/denoland-deno-d2d8d37"

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