FROM  python:3.9-slim-buster

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir \
            pandas \
            sqlalchemy \
            ipapi

COPY ./musicdwh/musicdwh.py . 
CMD [ "musicdwh.py" ]
ENTRYPOINT [ "python" ]
