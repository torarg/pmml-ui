FROM python:3.11.2-alpine as build

RUN adduser -D app && apk update && apk add runuser

USER app

RUN pip install pmml-ui==0.1.1 waitress

CMD [ "/home/app/.local/bin/waitress-serve", "--call", "pmml_ui.app:create_app"]
