# ZenMoney Report
Скрипт, который выгружает инфу для вставки в мой ежемесячный отчет

Как пользоваться:
1. Экспортируй все операции в CSV из мобильного приложения.
1. Запусти скрипт и укажи название этого файла. Также можно указать месяц, но не обязательно:
    - Без указания месяца: `/zenmoney_report.sh file.csv`. В этом случае по дефолту возьмется предыдущий месяц
    - С указанием месяца в формате ГГГГ-ММ: `/zenmoney_report.sh file.csv 2021-21`

Подробнее о форматах ввода смотри справку, просто запусти скрипт без параметров