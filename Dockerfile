FROM python:3.9-alpine3.13
LABEL maintainer="Aaron Munro"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# create python virtual env
RUN python -m venv /py && \
# upgrade pip in the venv
    /py/bin/pip install --upgrade pip && \
# install requirements file
    /py/bin/pip intall -r /tmp/requirements.txt && \
# remove tmp directory
    rm -rf /tmp && \
# add a new user for django with no password or home dir
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user