# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=1.2
inherit perl-module

DESCRIPTION="Use Apache format config files"

SLOT="0"
KEYWORDS="~alpha amd64 ~ppc sparc x86"

RDEPEND="
	>=dev-perl/Class-MethodMaker-1.80.0
	>=virtual/perl-File-Spec-0.820.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Text-Balanced-1.890.0

"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
