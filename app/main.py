import os
import pymysql
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

# Получаем строку подключения из переменных окружения
DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "dbuser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "password")
DB_NAME = os.getenv("DB_NAME", "webapp")


@app.get("/", response_class=HTMLResponse)
def read_root():
    try:
        # Пытаемся подключиться к Yandex Managed MySQL
        connection = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            connect_timeout=5,
        )
        connection.close()
        return """
        <html>
            <body style="font-family: Arial, sans-serif; text-align: center; margin-top: 50px;">
                <h1 style="color: #2e7d32;">🚀 Успех!</h1>
                <p style="font-size: 18px;">Приложение на <b>Python (FastAPI)</b> запущено и успешно подключено к облачной MySQL в Yandex Cloud.</p>
            </body>
        </html>
        """
    except Exception as e:
        return f"""
        <html>
            <body style="font-family: Arial, sans-serif; text-align: center; margin-top: 50px;">
                <h1 style="color: #c62828;">❌ Ошибка подключения к БД</h1>
                <p style="font-size: 18px; color: #555;">Не удалось связаться с Yandex Managed MySQL.</p>
                <code style="background: #eee; padding: 10px; display: inline-block; text-align: left;">{str(e)}</code>
            </body>
        </html>
        """
