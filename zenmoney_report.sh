#!/bin/bash


###############################################
#                 VARIABLES
###############################################

# По дефолту ставим текущий месяц - 1. Если дата указана в параметрах, она переопределится дальше
DATE=$(date -d "$(date +%Y-%m-1) -1 month" +%Y-%m)

SQL_SCRIPT=script.sql
SQL_SCRIPT_TMP=script_tmp.sql
OUT_FILE=out.csv

###############################################
#                 FUNCTIONS
###############################################

function show_help {
    echo ''
    echo 'Как пользоваться скриптом:'
    echo '  - Первый параметр: имя csv-файла, который ты выгрузил из ZenMoney'
    echo '  - Второй параметр (необязательно): период в формате ГГГГ-ММ. Если его не указывать, выгрузка будет за прошлый месяц'
    echo ''
    echo 'Примеры:'
    echo '  ./zenmoney_report.sh file.csv'
    echo '  ./zenmoney_report.sh file.csv 2011-12'
    echo ''
}

# Проверяет и устанавливает параметры
function check_params() {
    if [ $# -lt 1 ]; then
        show_help
        exit 1;
    fi
    
    if [ ! -f $1 ]; then
        echo "Файл $1 не найден"
        exit 1;
    fi
    
    if [ -z "$2" ]; then
        echo ''
        echo "Дата не указана явно, поэтому будет использоваться прошлый месяц: $DATE"
    else
        DATE=$2 # TODO: Тут надо бы проверять дату на корректность
    fi
}

# 1. Копирует sql-скрипт в новый файл (временный)
# 2. Подставляет в него ГОД и МЕСЯЦ
function create_sql_script() {
    cp $SQL_SCRIPT $SQL_SCRIPT_TMP
    sed -i 's/_PASTE_YEAR_HERE_/'${DATE:0:4}'/g' $SQL_SCRIPT_TMP
    sed -i 's/_PASTE_MONTH_HERE_/'${DATE:5:2}'/g' $SQL_SCRIPT_TMP
}

# Импортирует csv-файл, запускает скрипт и экспортирует результат.
# Также удаляет за собой временный скрипт
function run_sql() {
sqlite3 << EOF
.separator ;
.import $1 TT
.output $OUT_FILE
.read $SQL_SCRIPT_TMP
.quit
EOF
rm $SQL_SCRIPT_TMP
}

###############################################
#                 MAIN SCRIPT
###############################################

check_params $1 $2
create_sql_script
run_sql $1

printf "\n\nСейчас откроется окно LibreOffice.\nВ качестве разделителя нужно выбрать только точку с запятой.\n\nНажми Enter для продолжения\n"
read

libreoffice $OUT_FILE

rm $OUT_FILE
