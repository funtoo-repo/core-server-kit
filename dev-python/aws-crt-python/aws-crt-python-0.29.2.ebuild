# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Python bindings for the AWS Common Runtime"
HOMEPAGE="https://github.com/awslabs/aws-crt-python"
SRC_URI="
	https://github.com/awslabs/aws-crt-python/tarball/e2d3bd54ef65527481fb0e662ac65b0a7b10f595 -> aws-crt-python-0.29.2-e2d3bd5.tar.gz
	https://github.com/awslabs/aws-c-auth/tarball/7d6cfb92530e12109560988abec72c8ac9817281 -> aws-c-auth-0.9.3-7d6cfb9.tar.gz
	https://github.com/awslabs/aws-c-cal/tarball/1cb9412158890201a6ffceed779f90fe1f48180c -> aws-c-cal-0.9.13-1cb9412.tar.gz
	https://github.com/awslabs/aws-c-common/tarball/95515a8b1ff40d5bb14f965ca4cbbe99ad1843df -> aws-c-common-0.12.6-95515a8.tar.gz
	https://github.com/awslabs/aws-c-compression/tarball/f951ab2b819fc6993b6e5e6cfef64b1a1554bfc8 -> aws-c-compression-0.3.1-f951ab2.tar.gz
	https://github.com/awslabs/aws-c-event-stream/tarball/31a44ff9108840a8f3fec54006218f4bc6c505e1 -> aws-c-event-stream-0.5.7-31a44ff.tar.gz
	https://github.com/awslabs/aws-c-http/tarball/07302aa4a2892adbbf95ee6d458db3bb240030d3 -> aws-c-http-0.10.7-07302aa.tar.gz
	https://github.com/awslabs/aws-c-io/tarball/9cf142c08c28d5b1195aae09d2c05a6d17502e09 -> aws-c-io-0.23.3-9cf142c.tar.gz
	https://github.com/awslabs/aws-c-mqtt/tarball/1d512d92709f60b74e2cafa018e69a2e647f28e9 -> aws-c-mqtt-0.13.3-1d512d9.tar.gz
	https://github.com/awslabs/aws-c-s3/tarball/3f81fc9e90b11e6b3e434b166e275f65d5c98d39 -> aws-c-s3-0.11.3-3f81fc9.tar.gz
	https://github.com/awslabs/aws-c-sdkutils/tarball/f678bda9e21f7217e4bbf35e0d1ea59540687933 -> aws-c-sdkutils-0.2.4-f678bda.tar.gz
	https://github.com/awslabs/aws-checksums/tarball/9978ba2c33a7a259c1a6bd0f62abe26827d03b85 -> aws-checksums-0.2.7-9978ba2.tar.gz
	https://github.com/awslabs/aws-lc/tarball/b5e2f866efc0c7f90fcb6781281ea31063efbd96 -> aws-lc-1.65.1-b5e2f86.tar.gz
	https://github.com/aws/s2n-tls/tarball/f6ca8f0941851af4a05739c4a4b426970e953317 -> s2n-tls-1.6.2-f6ca8f0.tar.gz
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