# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Python bindings for the AWS Common Runtime"
HOMEPAGE="https://github.com/awslabs/aws-crt-python"
SRC_URI="
	https://github.com/awslabs/aws-crt-python/tarball/e6a48db2b9c16288af5ae0b8bd5269eb9d3c3c02 -> aws-crt-python-0.28.1-e6a48db.tar.gz
	https://github.com/awslabs/aws-c-auth/tarball/ab03bdd996437d9097953ebb9495de71b6adc537 -> aws-c-auth-0.9.1-ab03bdd.tar.gz
	https://github.com/awslabs/aws-c-cal/tarball/cdd052bf0ac38d72177d6376ea668755fca13df4 -> aws-c-cal-0.9.3-cdd052b.tar.gz
	https://github.com/awslabs/aws-c-common/tarball/31578beb2309330fece3fb3a66035a568a2641e7 -> aws-c-common-0.12.5-31578be.tar.gz
	https://github.com/awslabs/aws-c-compression/tarball/f951ab2b819fc6993b6e5e6cfef64b1a1554bfc8 -> aws-c-compression-0.3.1-f951ab2.tar.gz
	https://github.com/awslabs/aws-c-event-stream/tarball/31a44ff9108840a8f3fec54006218f4bc6c505e1 -> aws-c-event-stream-0.5.7-31a44ff.tar.gz
	https://github.com/awslabs/aws-c-http/tarball/ce0d65623bff28f03204756d9d1b3366bd0b387d -> aws-c-http-0.10.4-ce0d656.tar.gz
	https://github.com/awslabs/aws-c-io/tarball/db7a1bddc9a29eca18734d0af189c3924775dcf1 -> aws-c-io-0.22.0-db7a1bd.tar.gz
	https://github.com/awslabs/aws-c-mqtt/tarball/1d512d92709f60b74e2cafa018e69a2e647f28e9 -> aws-c-mqtt-0.13.3-1d512d9.tar.gz
	https://github.com/awslabs/aws-c-s3/tarball/43d33d681da4fed34b8ae1e6b98700ab08291628 -> aws-c-s3-0.9.0-43d33d6.tar.gz
	https://github.com/awslabs/aws-c-sdkutils/tarball/f678bda9e21f7217e4bbf35e0d1ea59540687933 -> aws-c-sdkutils-0.2.4-f678bda.tar.gz
	https://github.com/awslabs/aws-checksums/tarball/9978ba2c33a7a259c1a6bd0f62abe26827d03b85 -> aws-checksums-0.2.7-9978ba2.tar.gz
	https://github.com/awslabs/aws-lc/tarball/0fa8839018a3d98bae2fb24c557183d8ca02e6c5 -> aws-lc-1.61.2-0fa8839.tar.gz
	https://github.com/aws/s2n-tls/tarball/792d36671f11d79c448519130c1b77f5540942fb -> s2n-tls-1.5.26-792d366.tar.gz
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