# Используем официальный образ Flutter для сборки
FROM cirrusci/flutter:latest

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем проект в контейнер
COPY . .

# Выполняем сборку приложения
RUN flutter build windows

# Устанавливаем рабочую директорию для выполнения
WORKDIR /app/build/windows/runner/Release

# Команда для выполнения приложения
CMD ["./volgatech.exe"]