# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v37.0.1/wasmtime-v37.0.1-src.tar.gz -> wasmtime-v37.0.1-src.tar.gz
https://direct-github.funmore.org/2f/ab/01/2fab01dc1d4987afee8eb2fa3dad8532742aef31473a3c242660eb589981bd77299588f6355d23501662ce4aeb8a633c8cf0f8f6229650939dcadd1c9ec78933 -> wasmtime-37.0.1-funtoo-crates-bundle-0ae30cc6e5c5396cfa9442342a57a2880b22b46fc285380ae5c44cdb3759312208b4a190e24b752e06c8478a526835427bc3f0b3a926283cfe0dd952eea89468.tar.gz"

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