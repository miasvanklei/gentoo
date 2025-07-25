# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.markdown README.markdown"

RUBY_FAKEGEM_GEMSPEC="web-console.gemspec"

inherit ruby-fakegem

DESCRIPTION="A debugging tool for your Ruby on Rails applications"
HOMEPAGE="https://github.com/rails/web-console"
SRC_URI="https://github.com/rails/web-console/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/actionview-6.0:*
	>=dev-ruby/activemodel-6.0:*
	>=dev-ruby/bindex-0.4.0
	>=dev-ruby/railties-6.0:*
"

ruby_add_bdepend "test? (
	dev-ruby/bundler
	>=dev-ruby/rails-6.0
	dev-ruby/rack
	dev-ruby/sqlite3
	dev-ruby/mocha
	www-servers/puma
)"

all_ruby_prepare() {
	# Use an installed rails version rather than live source from github, and
	# rack is now part of rails.
	sed -e '/\(rack\|arel\|rails\|simplecov\)/ s/,/#/'  \
		-e '/\(byebug\|simplecov\)/ s:^:#:' \
		-e '/arel/ s:^:#:' \
		-i Gemfile || die

	sed -i -e '/simplecov/I s:^:#:' test/test_helper.rb || die
}
