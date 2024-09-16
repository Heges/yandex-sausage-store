FROM python:latest
WORKDIR /usr/app/src
COPY . .
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
EXPOSE 8080