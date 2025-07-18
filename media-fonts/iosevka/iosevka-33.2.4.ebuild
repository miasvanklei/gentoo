# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

# [...document.querySelectorAll('[colspan="3"] > b')]
#     .map(x => x.innerText.trim())
#     .map(x => x.substring(x.indexOf(' ') + 1).replaceAll("\xa0", " "))
#     .map(x => "\t[\""
#          + x.toLowerCase().replaceAll(" ", "-")
#          + "\"]=\""
#          + x
#          + "\"")
#     .join("\n")
declare -A MY_FONT_VARIANTS=(
	["iosevka"]="Iosevka"
	["iosevka-slab"]="Iosevka Slab"
	["iosevka-curly"]="Iosevka Curly"
	["iosevka-curly-slab"]="Iosevka Curly Slab"
	["iosevka-ss01"]="Iosevka SS01"
	["iosevka-ss02"]="Iosevka SS02"
	["iosevka-ss03"]="Iosevka SS03"
	["iosevka-ss04"]="Iosevka SS04"
	["iosevka-ss05"]="Iosevka SS05"
	["iosevka-ss06"]="Iosevka SS06"
	["iosevka-ss07"]="Iosevka SS07"
	["iosevka-ss08"]="Iosevka SS08"
	["iosevka-ss09"]="Iosevka SS09"
	["iosevka-ss10"]="Iosevka SS10"
	["iosevka-ss11"]="Iosevka SS11"
	["iosevka-ss12"]="Iosevka SS12"
	["iosevka-ss13"]="Iosevka SS13"
	["iosevka-ss14"]="Iosevka SS14"
	["iosevka-ss15"]="Iosevka SS15"
	["iosevka-ss16"]="Iosevka SS16"
	["iosevka-ss17"]="Iosevka SS17"
	["iosevka-ss18"]="Iosevka SS18"
	["iosevka-aile"]="Iosevka Aile"
	["iosevka-etoile"]="Iosevka Etoile"
)

DESCRIPTION="Slender typeface for code, from code"
HOMEPAGE="https://typeof.net/Iosevka/"

SRC_URI=''
REQUIRED_USE='|| ('
MY_BASE="https://github.com/be5invis/Iosevka/releases/download/v${PV}"
for variant in "${!MY_FONT_VARIANTS[@]}"; do
	up_variant="${variant}"
	up_variant="${up_variant/iosevka/Iosevka}"
	up_variant="${up_variant/ss/SS}"
	up_variant="${up_variant/iosevka/Iosevka}"
	up_variant="${up_variant/aile/Aile}"
	up_variant="${up_variant/etoile/Etoile}"
	up_variant="${up_variant/curly/Curly}"
	up_variant="${up_variant/slab/Slab}"
	up_variant="${up_variant//-/}"
	my_filename="SuperTTC-${up_variant}-${PV}.zip"

	[[ ${SRC_URI} ]] && SRC_URI+=' '
	SRC_URI+="${variant}? ( ${MY_BASE}/${my_filename} )"

	[[ ${IUSE} ]] && IUSE+=' '
	[[ ${variant} == iosevka ]] && IUSE+='+'
	IUSE+="${variant}"

	REQUIRED_USE+=" ${variant} "
done
REQUIRED_USE+=')'
unset MY_BASE my_filename variant up_variant

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttc"

src_prepare() {
	default

	FONT_CONF=()
	local vinternal
	for vinternal in "${!MY_FONT_VARIANTS[@]}"; do
		case "${vinternal}" in
			*-etoile|*-aile)
				continue
				;;
		esac
		local vname="${MY_FONT_VARIANTS[${vinternal}]}"
		use "${vinternal}" || continue
		cat >66-"${vinternal}".conf <<EOF
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<!-- Enable this config to change your monospace font to ${vname} -->
<fontconfig>
	<alias>
		<family>monospace</family>
		<prefer>
			<family>${vname}</family>
		</prefer>
	</alias>
	<alias>
		<family>${vname}</family>
		<default>
			<family>monospace</family>
		</default>
	</alias>
</fontconfig>
EOF
		assert "Failed to generate ${vinternal}"
		FONT_CONF+=( 66-"${vinternal}".conf )
	done
}
