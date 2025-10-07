# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v37.0.2/wasmtime-v37.0.2-src.tar.gz -> wasmtime-v37.0.2-src.tar.gz
https://direct-github.funmore.org/a6/5f/f6/a65ff6f27c0edfaa368e6c651009800be2c31536e51ac1a94eb9b866e98b54006df8c4cd95868144dd599d01d60a70b361aaf923a68c03496acfef54e86baa75 -> wasmtime-37.0.2-funtoo-crates-bundle-0ae30cc6e5c5396cfa9442342a57a2880b22b46fc285380ae5c44cdb3759312208b4a190e24b752e06c8478a526835427bc3f0b3a926283cfe0dd952eea89468.tar.gz"

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