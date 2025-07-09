FROM python:3.12-slim

WORKDIR /app

COPY app /app

RUN pip install --no-cache-dir -r /app/requirements.txt

EXPOSE 8000

CMD ["python", "main.py"]
