#!/usr/bin/env bash
if [ -f "$load_spec" ]; then
    echo "loading $load_spec"
else 
    echo "$load_spec does not exist - must exit"
    exit 1
fi
export PYTHONPATH=$METdb/METdbLoad/ush
time python3 $METdb/METdbLoad/ush/cbload/run_cb_threads.py -t 12 $load_spec
