# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v29.0.0/wasmtime-v29.0.0-src.tar.gz -> wasmtime-v29.0.0-src.tar.gz
https://direct-github.funmore.org/94/56/d2/9456d2a6589e4343c7bc88373e6f8c65bff9455c05551ee7e43f7661a44e9bbabf576a4d08fab00dc5ffcdf0f67a248b2b426e3ffaf1948b44c7ea4ea07941d9 -> wasmtime-29.0.0-funtoo-crates-bundle-18a6c27a9378036d7d67c4b2832752590fc62882060c1a7cc25fa6c1afea3f6d936c7865b1f36f345d74a569ced0e837217a542ad5c516bb945e2e579e45ef63.tar.gz"

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