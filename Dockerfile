FROM python:3.9-alpine3.13
LABEL maintainer="Aaron Munro"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
# create python virtual env
RUN python -m venv /py && \
# upgrade pip in the venv
    /py/bin/pip install --upgrade pip && \
# install postgres client (needed for psycopg2)
    apk add --update --no-cache postgresql-client && \
# install temporary build dependencies for (psycopg2)
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
# install requirements file
    /py/bin/pip install -r /tmp/requirements.txt && \
# if running dev then install requirements.dev.txt
if [ $DEV = "true" ]; \
    then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
fi && \
# remove tmp directory
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
# add a new user for django with no password or home dir
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user