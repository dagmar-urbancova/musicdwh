FROM python:latest
WORKDIR /code
ADD requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY musicdwh.py musicdwh.py
CMD ["python", "-u", "musicdwh.py"]