# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v33.0.0/wasmtime-v33.0.0-src.tar.gz -> wasmtime-v33.0.0-src.tar.gz
https://direct-github.funmore.org/3d/99/e8/3d99e8c637431d72a962ef70b23eb87438e4700cc9da8a6107f379e62ed831c40f0c3b4e13516fbae0b0c3d907ae6cb8f2f89bd3aa0707da1e8df0ad6ff20b92 -> wasmtime-33.0.0-funtoo-crates-bundle-6531677a59cf22505c4a322df4162908bde7986518181f09e605746dd9111634f3570302bd100470541bfe12d09604c87e7054e8fcad874e22eb81bca821eab8.tar.gz"

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