FROM python:3.9.5-slim

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt && \
    rm requirements.txt

EXPOSE 43800
EXPOSE 53800

ENTRYPOINT ["/bin/sh", "-c"]

# We only use ENTRYPOINT so we can define our own "args" for each specific Aimstack component
