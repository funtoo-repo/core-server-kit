# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Python bindings for the AWS Common Runtime"
HOMEPAGE="https://github.com/awslabs/aws-crt-python"
SRC_URI="
	https://github.com/awslabs/aws-crt-python/tarball/6f44eb2674f2db2a5456b325c6248dc2d24e09a4 -> aws-crt-python-0.28.4-6f44eb2.tar.gz
	https://github.com/awslabs/aws-c-auth/tarball/ab03bdd996437d9097953ebb9495de71b6adc537 -> aws-c-auth-0.9.1-ab03bdd.tar.gz
	https://github.com/awslabs/aws-c-cal/tarball/0f4ee2ceb385eef35fa1dc0a24e2729d2d5b73f2 -> aws-c-cal-0.9.10-0f4ee2c.tar.gz
	https://github.com/awslabs/aws-c-common/tarball/31578beb2309330fece3fb3a66035a568a2641e7 -> aws-c-common-0.12.5-31578be.tar.gz
	https://github.com/awslabs/aws-c-compression/tarball/f951ab2b819fc6993b6e5e6cfef64b1a1554bfc8 -> aws-c-compression-0.3.1-f951ab2.tar.gz
	https://github.com/awslabs/aws-c-event-stream/tarball/31a44ff9108840a8f3fec54006218f4bc6c505e1 -> aws-c-event-stream-0.5.7-31a44ff.tar.gz
	https://github.com/awslabs/aws-c-http/tarball/07302aa4a2892adbbf95ee6d458db3bb240030d3 -> aws-c-http-0.10.7-07302aa.tar.gz
	https://github.com/awslabs/aws-c-io/tarball/9cf142c08c28d5b1195aae09d2c05a6d17502e09 -> aws-c-io-0.23.3-9cf142c.tar.gz
	https://github.com/awslabs/aws-c-mqtt/tarball/1d512d92709f60b74e2cafa018e69a2e647f28e9 -> aws-c-mqtt-0.13.3-1d512d9.tar.gz
	https://github.com/awslabs/aws-c-s3/tarball/19a2454c8de8c10d213429ff85b309c684f7066d -> aws-c-s3-0.10.1-19a2454.tar.gz
	https://github.com/awslabs/aws-c-sdkutils/tarball/f678bda9e21f7217e4bbf35e0d1ea59540687933 -> aws-c-sdkutils-0.2.4-f678bda.tar.gz
	https://github.com/awslabs/aws-checksums/tarball/9978ba2c33a7a259c1a6bd0f62abe26827d03b85 -> aws-checksums-0.2.7-9978ba2.tar.gz
	https://github.com/awslabs/aws-lc/tarball/ab37578b5a0489873d3c7e14ed6ca0c0dcf58d22 -> aws-lc-1.63.0-ab37578.tar.gz
	https://github.com/aws/s2n-tls/tarball/6aefe741f17489211f6c28e837c1a65ee66a1ef2 -> s2n-tls-1.6.0-6aefe74.tar.gz
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