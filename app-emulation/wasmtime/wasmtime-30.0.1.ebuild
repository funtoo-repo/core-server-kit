# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v30.0.1/wasmtime-v30.0.1-src.tar.gz -> wasmtime-v30.0.1-src.tar.gz
https://direct-github.funmore.org/8d/45/ca/8d45ca50c1df9edbb4156243f4d96c0a8d9e7cef5c2734f8a958ae963d148b3e22ecf3eaf794950f2af5cad5ff18f03573613dd0d86a499e75a87589373b170b -> wasmtime-30.0.1-funtoo-crates-bundle-a3f22d73dab515dbfdd941bdb7ca1ededc68b57e157118b42b48b564322c902e3728e8a037daa4042ece8a8b0ef140bf8c46739590025b711b0ec8dc88aee1e8.tar.gz"

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