# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v35.0.0/wasmtime-v35.0.0-src.tar.gz -> wasmtime-v35.0.0-src.tar.gz
https://direct-github.funmore.org/60/a2/5d/60a25dceedc8073a49fa29e0b64a98bf0608290eb00474eb4a1dfc38076c316d45e533170c8f9e7d12310e47e926fd9efa5f08c30ecdbf6ca2639d0c62aa17ba -> wasmtime-35.0.0-funtoo-crates-bundle-4934bafdbc37364b1e34c139c1270aedb30ebcc1c2194929baf4cdaddbc3b3ebd0545a0b3de876e2e382f6d549f91cc8c2c408d80ffb5ed24fbceae070f61b9f.tar.gz"

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