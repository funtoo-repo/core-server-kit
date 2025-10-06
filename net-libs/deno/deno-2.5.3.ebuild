# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/1c3d04cfaf50a4a0db7a1925c0a73af5ea89bc69 -> deno-2.5.3-1c3d04c.tar.gz
https://direct-github.funmore.org/df/9e/ee/df9eee3e3e0f5b9d1ec3ec4be4b7a87899aad186e6d3309566df9705c7a85bcdd584dd1e137657ef2802d52bc87340acc75c3ce662302625230360d61a22993f -> deno-2.5.3-funtoo-crates-bundle-970becf0226f4f583c7006839e3346b47650cb5bb2937c655acd2cde8b72ccf03c56dd5a69192c6d56f89bcb7cfd94bd13c52527297b2304193a89dd5e8e6917.tar.gz"
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

S="${WORKDIR}/denoland-deno-1c3d04c"

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