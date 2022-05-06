FROM python:3.9.5-slim

# install the `aim` package on the latest version
RUN pip install --upgrade aim

EXPOSE 43800
EXPOSE 53800

ENTRYPOINT ["/bin/sh", "-c"]

# We use args here and keep the image generic for everything
