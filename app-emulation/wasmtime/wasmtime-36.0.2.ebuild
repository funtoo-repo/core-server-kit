# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v36.0.2/wasmtime-v36.0.2-src.tar.gz -> wasmtime-v36.0.2-src.tar.gz
https://direct-github.funmore.org/63/85/bc/6385bcf72b1268634f72449b1c0c56f9febaa0bfd4297d184dcd39bf59af153584eb68b7b18a4c82c52eed7d9ad8494442c35c429db29833ae28325017bda0ed -> wasmtime-36.0.2-funtoo-crates-bundle-4f87fee97513a61cb68260248fcf368c36cb298cf98ad12cad60b76086ce428da7f07ec0eb316b9e7d73b25ec4d13f683b8915993a1b9f639759e00c45be0f9c.tar.gz"

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