FROM  debian:latest
#Копирование зеркала
ADD docker.list /etc/apt/source.list.d
# Обновление кеша и обновление пакетов
RUN apt-get update && apt-get upgrade -y && \
#Устанавливаем nginx
    apt-get install -y nginx && \
#Очищаем кеш
    apt-get clean && \
#Удаляем содержимое директории /var/www/
    rm -rf /var/www/* && \
#Создаем директорию с именем сайта и папку с картинками
    mkdir /var/www/lab4 && mkdir /var/www/lab4/img
#Копируем index.html в /var/www/lab4/
COPY index.html /var/www/lab4/
#Копируем в /var/www/Lab4/img/
#COPY ....jpg /var/www/lab4/img/
#Задаем рекурсивно на /var/www/lab4 права "владельцу - читать, писать, исполнять; группе - читать, исполнять, остальным - только читать"
RUN chmod -R 754 /var/www/lab4 && \
#Создаем пользователя
    adduser alexander && \ 
#Создаем группу
    groupadd ukrainets && \
#Добавляем в группу пользователя
    usermod -aG ukrainets alexander && \
#Рекурсивно присвоить созданных пользователя и группу на папки
    chown -R alexander:ukrainets /var/www/lab4 /var/lib/nginx /var/log/nginx /run /etc/nginx && \
# Заменяем наименование сайта
    sed -i 's|/var/www/html|/var/www/lab4|g' /etc/nginx/sites-available/default && \
#Заменяем пользователя
    sed -i 's|www-data|alexander|g' /etc/nginx/nginx.conf

# Указываем порт для работы приложения в контейнере
EXPOSE 80

# Запуск от пользователя
USER alexander

# Запускаем nginx
CMD ["nginx", "-c", "/etc/nginx/nginx.conf", "-g", "daemon off;"]
