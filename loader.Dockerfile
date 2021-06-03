FROM  python:3.9-slim-buster

RUN apt-get update && apt-get -y install postgresql postgresql-contrib

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
            pandas \
            sqlalchemy \
            ipapi \
            psycopg2-binary

COPY ./musicdwh/musicdwh.py .
COPY ./wait-for-postgres.sh .
RUN chmod +x wait-for-postgres.sh
CMD [ "python", "musicdwh.py", "-u" ]