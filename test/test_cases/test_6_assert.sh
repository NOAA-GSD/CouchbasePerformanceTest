#!/usr/bin/env bash
export GRN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m'
output=$1
diff output/${output}/test_6_iso_cb.sh.out output/${output}/test_6_keys_cb.sh.out > /dev/null
ret=$?
if [[ $ret -ne 0 ]]; then
	echo -e "${Red}output/${output}/test_6_iso_cb.sh.out and output/${output}/test_6_keys_cb.sh.out differ and they should not${NC}"
else
	echo -e "${Green}output/${output}/test_6_iso_cb.sh.out and output/${output}/test_6_keys_cb.sh.out are the same${NC}"
fi

diff output/${output}/test_6_iso_cb.sh.out output/sql/test_6_sql.sh.out > /dev/null
ret=$?
if [[ $ret -ne 0 ]]; then
	echo -e "${Red}output/${output}/test_6_iso_cb.sh.out and output/sql/test_6_sql.sh.out differ and they should not${NC}"
else
	echo -e "${Green}output/${output}/test_6_iso_cb.sh.out and output/sql/test_6_sql.sh.out are the same${NC}"
fi
