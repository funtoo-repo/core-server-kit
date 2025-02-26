# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A lightweight WebAssembly runtime that is fast, secure, and standards-compliant"
HOMEPAGE="https://github.com/bytecodealliance/wasmtime https://docs.wasmtime.dev"
SRC_URI="https://github.com/bytecodealliance/wasmtime/releases/download/v30.0.2/wasmtime-v30.0.2-src.tar.gz -> wasmtime-v30.0.2-src.tar.gz
https://direct-github.funmore.org/0f/f1/25/0ff12522b36713b958e53676fcd5555f3c952591b3d5ca050a2277b6c7463eeda49a2c72aa9f7a7a183b1e8151f7acae4941198b72c156ddf15b630a8ec46ee1 -> wasmtime-30.0.2-funtoo-crates-bundle-a3f22d73dab515dbfdd941bdb7ca1ededc68b57e157118b42b48b564322c902e3728e8a037daa4042ece8a8b0ef140bf8c46739590025b711b0ec8dc88aee1e8.tar.gz"

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