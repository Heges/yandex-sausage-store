FROM python:latest
mkdir -p /app
mkdir -p /app/logs
WORKDIR /usr/app/src
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8080