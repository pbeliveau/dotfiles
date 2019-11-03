echo -n "Your FOSS Freedom index is at least " && echo "scale=2;" \
    $(pacman -Qi | grep -e '^Licenses' | \
          grep -cE 'GPL|BSD|MIT|APACHE|MPL|PUBLIC|NCSA|NONE|NoCopywrite|ISC|CDDL|SIL|OFL' ) \
    \* 100 / $(pacman -Qi | grep -c 'Name' ) | bc -l
