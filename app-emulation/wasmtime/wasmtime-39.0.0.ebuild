# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v39.0.0/wasmtime-v39.0.0-src.tar.gz -> wasmtime-v39.0.0-src.tar.gz
https://direct-github.funmore.org/6a/f2/10/6af21034913731fb20b9a7e32acb3a0db70aef1bbd523a1f03883438f7ce4dbfcf72d92a854cf8a2391dd295f2c0beb17fa2e6cbb3e722e152386d9b317a48ae -> wasmtime-39.0.0-funtoo-crates-bundle-6d8b4bc27299879866967d269d7f79d48422ec35f91e9e8865eb249a3ad519caf79b4ce5fe7449e76d024e6fe2bd010b95f4385e4786311130361a467c8884dc.tar.gz"

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