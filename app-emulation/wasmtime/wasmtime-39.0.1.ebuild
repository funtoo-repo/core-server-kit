# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v39.0.1/wasmtime-v39.0.1-src.tar.gz -> wasmtime-v39.0.1-src.tar.gz
https://direct-github.funmore.org/17/6a/44/176a449e8aa200b37bc9681b4aa11dab0fed1bd3883bd59158fbf815820b48c9adca8ff34871bdfddb91562ad200a2e572c8d438e79bbc62abb5d3446fdefce1 -> wasmtime-39.0.1-funtoo-crates-bundle-6d8b4bc27299879866967d269d7f79d48422ec35f91e9e8865eb249a3ad519caf79b4ce5fe7449e76d024e6fe2bd010b95f4385e4786311130361a467c8884dc.tar.gz"

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