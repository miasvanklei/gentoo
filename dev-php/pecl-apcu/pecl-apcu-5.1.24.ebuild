# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PHP_EXT_INI="yes"
PHP_EXT_NAME="apcu"
PHP_EXT_ZENDEXT="no"
USE_PHP="php8-2 php8-3 php8-4"

inherit php-ext-pecl-r3

DESCRIPTION="Stripped down version of APC supporting only user cache"

LICENSE="PHP-3.01"
SLOT="7"
KEYWORDS="amd64 ~arm arm64 x86"

LOCKS="pthreadmutex pthreadrw spinlock semaphore"
LUSE=""
for l in ${LOCKS}; do
	LUSE+="lock-${l} "
done
IUSE="+mmap ${LUSE/lock-pthreadrw/+lock-pthreadrw}"
REQUIRED_USE="^^ ( $LUSE )"

DOCS=( NOTICE README.md TECHNOTES.txt )

src_configure() {
	local PHP_EXT_ECONF_ARGS=(
		--enable-apcu
		$(use_enable mmap apcu-mmap)
		$(use_enable lock-spinlock apcu-spinlocks)
	)

	# Broken upstream autoconf test disables if present at all
	use lock-pthreadrw || PHP_EXT_ECONF_ARGS+=( --disable-apcu-rwlocks )

	php-ext-source-r3_src_configure
}

src_install() {
	php-ext-pecl-r3_src_install

	insinto /usr/share/php8/apcu
	doins apc.php
}

pkg_postinst() {
	elog "The apc.php file shipped with this release of pecl-apcu"
	elog "was installed to ${EPREFIX}/usr/share/php8/apcu/."
}
