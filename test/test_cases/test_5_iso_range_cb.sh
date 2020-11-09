#!/usr/bin/env bash
source ./getopts.sh
read -d '' prologue << PEOF
This is a test of a query captured from a basic die-off plot from the metviewer at
http://137.75.129.120:8080/metviewer-mysql/servlet  - historical plot named 20200515_162720.
PEOF
/opt/couchbase/bin/cbq -o "output/$0.json" -q -e couchbase://${server}/mdata -u met_admin -p met_adm_pwd <<-'EOF' 
SELECT r.mdata.geoLocation_id as vx_mask, data.fcst_init_beg, data.fcst_valid_beg, data.fcst_lead, r.mdata.model, r.mdata.fcst_lev, r.mdata.fcst_var, data.total, data.fabar, data.oabar, data.foabar, data.ffabar, data.ooabar 
FROM (
    SELECT *
    FROM mdata
    WHERE model == "GFS"
        AND dataType == "VSDB_V01_SAL1L2"
        AND subset == "mv_gfs_grid2obs_vsdb1"
        AND geoLocation_id IN ["G2/NHX","G2/SHX"]
        AND fcst_var == "HGT"
        AND fcst_lev in ['P10', 'P20', 'P30', 'P50', 'P70', 'P100', 'P150', 'P200', 'P250', 'P300', 'P400', 'P500', 'P700', 'P850', 'P925', 'P1000']
        AND fcst_valid_beg BETWEEN '2019-01-01T00:00:00Z' AND '2019-03-10T00:00:00Z' ) AS r
UNNEST r.mdata.data AS data
WHERE data.fcst_lead IN ['144']
ORDER BY data.fcst_valid_beg, data.fcst_init_beg, r.mdata.fcst_lev, data.fcst_lead, r.mdata.geoLocation_id;
EOF
echo $0 > "output/$0.time"
grep 'Time":' output/$0.json >> "output/$0.time"
cat "output/$0.json" | grep -vi select | jq -r '.results | (map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @tsv' > "output/$0.tmp"
# first row is strings... match the column headers from sql output
head -1 output/$0.tmp |   awk '{printf "%s\t%s\tfibT\t%s\tfvbT\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $13,$2,$5,$3,$9,$4,$6,$10,$1,$11,$8,$7,$12}' > "output/$0.tmpout"
# all the other rows are the data
tail -n+2 output/$0.tmp | awk '{printf "%s\t%s\t%s\t%i\t%s\t%s\t%s\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%i\n", $13,$2,$5,$3,$9,$4,$6,$10,$1,$11,$8,$7,$12}' | sed 's/\([0123456789]\)T\([0123456789]\)/\1 \2/g' | tr -d 'Z' >> "output/$0.tmpout"
cat output/$0.tmpout | column -t > output/$0.out
rm output/$0.tmpout
rm output/$0.tmp
                          
