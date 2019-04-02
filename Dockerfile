### Build and install packages
FROM python:3.6 as build-python

RUN apt-get -y update \
  && apt-get install -y gettext \
  # Cleanup apt cache
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install pipenv
COPY Pipfile Pipfile.lock /app/
WORKDIR /app
RUN pipenv install --system --deploy --dev


ARG STATIC_URL
ENV STATIC_URL ${STATIC_URL:-/static/}

### Final image
FROM python:3.6-slim

ARG STATIC_URL
ENV STATIC_URL ${STATIC_URL:-/static/}

RUN groupadd -r saleor && useradd -r -g saleor saleor

RUN apt-get update \
  && apt-get install -y \
    libxml2 \
    libssl1.1 \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf2.0-0 \
    shared-mime-info \
    mime-support \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY . /app
COPY --from=build-python /usr/local/lib/python3.6/site-packages/ /usr/local/lib/python3.6/site-packages/
COPY --from=build-python /usr/local/bin/ /usr/local/bin/
WORKDIR /app

RUN SECRET_KEY=dummyuffjhdffh STATIC_URL=${STATIC_URL} python3 manage.py collectstatic --no-input

RUN mkdir -p /app/media /app/static \
  && chown -R saleor:saleor /app/

EXPOSE 8000
ENV PORT 8000
ENV PYTHONUNBUFFERED 1
ENV PROCESSES 4

CMD ["python", "manage.py", "makemigrations"]
CMD ["python", "manage.py", "migrate"]
CMD ["python", "manage.py", "shell","-c","from populatedb import main;main()"]
CMD ["python", "manage.py", "migrate"]
CMD ["python", "manage.py", "runserver"]
