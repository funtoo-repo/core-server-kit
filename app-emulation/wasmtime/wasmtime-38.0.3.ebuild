# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v38.0.3/wasmtime-v38.0.3-src.tar.gz -> wasmtime-v38.0.3-src.tar.gz
https://direct-github.funmore.org/f9/a9/99/f9a99905f878d67580bf78918d0b1af89664b2e2c8c095ac6d390bacb3cab67e7f256a04b0cb82689dc044c7817726255a2a7093058dc8f9b5778800222c2150 -> wasmtime-38.0.3-funtoo-crates-bundle-a778c0476ebe6ba469ab887332039b32c4f8dffd3af7bec9f7ddafafda80d527cb55ae87b3842948a50e1c1c82d06b4f2002294dbe3bca07ae19ce8b474974a3.tar.gz"

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