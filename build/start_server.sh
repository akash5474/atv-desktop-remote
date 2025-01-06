#!/bin/bash
INSTALL_LOG="atv_pip_install.log"
MY_PATH=$(dirname "$0")
cd "$MY_PATH"
if [[ ! -d env ]]; then
	dt=$(date)
	echo "ATVRemote - Python install started $dt" >> $INSTALL_LOG
	touch setting_up_python
	python3 -m venv env | tee -a $INSTALL_LOG
	source env/bin/activate
	python -m pip install --upgrade pip | tee -a $INSTALL_LOG
	python -m pip install websockets pyatv | tee -a $INSTALL_LOG
	dt=$(date)
	echo "ATVRemote - Python install ended $dt" >> $INSTALL_LOG
	echo "==================================================" >> $INSTALL_LOG
else
	source env/bin/activate
fi

function kill_proc () {
	for p in $(ps ax | grep -v grep | grep wsserver.py | awk '{print $1}'); do
		echo "Killing $p"
		kill $1 $p
	done
}
kill_proc
kill_proc "-9"
[[ -f setting_up_python ]] && rm setting_up_python
python wsserver.py
