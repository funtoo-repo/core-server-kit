# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v29.0.1/wasmtime-v29.0.1-src.tar.gz -> wasmtime-v29.0.1-src.tar.gz
https://direct-github.funmore.org/be/23/cc/be23cc85204188d7d3e9f052128e1215272022888d491465a274e5ccfa62c343bd9aba96c2212e0f1ce2b4c4f1596aaeef100f1b76d78e5892b2bce94e1c4adc -> wasmtime-29.0.1-funtoo-crates-bundle-4e0ef0347bc27613bf7babbd0221e253edebfcacfbf0c06c153b49ddf78b033cb3a8fd7126c35925c118558b8a2aa289a18156fbc0728cefeeb1fb8709c13019.tar.gz"

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