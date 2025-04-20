# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Deno is a simple, modern and secure runtime for JavaScript and TypeScript"
HOMEPAGE="https://github.com/denoland/deno"
SRC_URI="https://github.com/denoland/deno/tarball/225fbd59bf9a1d50603adb99fe2748edf70b9de2 -> deno-2.2.11-225fbd5.tar.gz
https://direct-github.funmore.org/29/6d/1e/296d1e68ec9bccbb252bd2d35faace88a5704a5b335af2023bac20c74bbe948b4fe80ad4c3eb61481b2cfb435cd0665d97be2a3b86f6514b5bfe34a61435e457 -> deno-2.2.11-funtoo-crates-bundle-ad94114495eda31c971122ca78d45b46315c648c6a434145bd3ceff43a92642c52bb9d3bd0571fcd84c54323140ee68ab980ce18c4885690382b665022117ff5.tar.gz"
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

S="${WORKDIR}/denoland-deno-225fbd5"

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

	dodoc -r docs
}