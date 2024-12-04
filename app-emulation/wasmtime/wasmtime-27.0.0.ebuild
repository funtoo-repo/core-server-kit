# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v27.0.0/wasmtime-v27.0.0-src.tar.gz -> wasmtime-v27.0.0-src.tar.gz
https://direct-github.funmore.org/0e/b3/df/0eb3df8e5bfc2eec199d4235fdcfe28ef651e5faed308e9b74c3edc75165c3e0b9a4ccba23db65bb0143b661c9e1d4494596277d50842d3416a3cbb807cf3e00 -> wasmtime-27.0.0-funtoo-crates-bundle-aa728a44a3a071809bbc739d46ad0d8dc0c61914424ede8f83635e78ca90ebd3d45afa3c10e3485199461a3eeecc8fdc028cee9f8c6da10999720fdf4652753b.tar.gz"

LICENSE="Apache-2.0 Boost-1.0 BSD BSD-2 CC0-1.0 ISC LGPL-3+ MIT Apache-2.0 Unlicense ZLIB"
SLOT="0"
KEYWORDS="*"

DOCS=( ADOPTERS.md README.md RELEASES.md )

QA_FLAGS_IGNORED="/usr/bin/wasmtime"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/wasmtime-* ${S} || die
}

src_install() {
	cargo_src_install
	einstalldocs
}