FROM python:3.11.2-alpine as build

RUN adduser -D app && apk update && apk add runuser

USER app

RUN pip install pmml_ui waitress

CMD [ "/home/app/.local/bin/waitress-serve", "pmml_ui.app:create_app"]
