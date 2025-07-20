# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Python bindings for the AWS Common Runtime"
HOMEPAGE="https://github.com/awslabs/aws-crt-python"
SRC_URI="
	https://github.com/awslabs/aws-crt-python/tarball/5cf5e7d70f5ecd3a88fae15fa3f427b82f30fbae -> aws-crt-python-0.27.4-5cf5e7d.tar.gz
	https://github.com/awslabs/aws-c-auth/tarball/cd9d6afcd42035d49bb2d0d3bef24b9faed57773 -> aws-c-auth-0.9.0-cd9d6af.tar.gz
	https://github.com/awslabs/aws-c-cal/tarball/8703b3e5930c9fd508025b268ab837fc9df3c4fd -> aws-c-cal-0.9.2-8703b3e.tar.gz
	https://github.com/awslabs/aws-c-common/tarball/2b67a658e461520f1de20d64342b91ddcedc7ebb -> aws-c-common-0.12.4-2b67a65.tar.gz
	https://github.com/awslabs/aws-c-compression/tarball/f951ab2b819fc6993b6e5e6cfef64b1a1554bfc8 -> aws-c-compression-0.3.1-f951ab2.tar.gz
	https://github.com/awslabs/aws-c-event-stream/tarball/8f8f599e78864188fe8547dafaa695a1d4855d6a -> aws-c-event-stream-0.5.5-8f8f599.tar.gz
	https://github.com/awslabs/aws-c-http/tarball/bfa03928d95771853d3bc952c30cad3ac7fdb361 -> aws-c-http-0.10.3-bfa0392.tar.gz
	https://github.com/awslabs/aws-c-io/tarball/12cb9f9c2702a5c864d6cefe19aa12e89924a3ac -> aws-c-io-0.21.1-12cb9f9.tar.gz
	https://github.com/awslabs/aws-c-mqtt/tarball/1d512d92709f60b74e2cafa018e69a2e647f28e9 -> aws-c-mqtt-0.13.3-1d512d9.tar.gz
	https://github.com/awslabs/aws-c-s3/tarball/70aacd2d22c7fe43d277ed32336dcc2b201ac05b -> aws-c-s3-0.8.5-70aacd2.tar.gz
	https://github.com/awslabs/aws-c-sdkutils/tarball/f678bda9e21f7217e4bbf35e0d1ea59540687933 -> aws-c-sdkutils-0.2.4-f678bda.tar.gz
	https://github.com/awslabs/aws-checksums/tarball/9978ba2c33a7a259c1a6bd0f62abe26827d03b85 -> aws-checksums-0.2.7-9978ba2.tar.gz
	https://github.com/awslabs/aws-lc/tarball/8b52781470d501fb94322ddfcadf06fcd3c19fa2 -> aws-lc-1.55.0-8b52781.tar.gz
	https://github.com/aws/s2n-tls/tarball/e33d7efac0336231a68663e17c779a6f523a838d -> s2n-tls-1.5.22-e33d7ef.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="dev-util/cmake"
RDEPEND=""
BDEPEND=""

AWS_C_MODULES=( 
	aws-c-auth
	aws-c-cal
	aws-c-common
	aws-c-compression
	aws-c-event-stream
	aws-c-http
	aws-c-io
	aws-c-mqtt
	aws-c-s3
	aws-c-sdkutils
	aws-checksums
	aws-lc
	s2n
)


post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv "${WORKDIR}"/awslabs-aws-crt-python-* "${S}" || die
	fi

	for module in "${AWS_C_MODULES[@]}"; do
		rmdir ${S}/crt/${module} || die
		einfo "Moving ${module} into source tree"
		mv ${WORKDIR}/*${module}* ${S}/crt/${module} || die
	done
}