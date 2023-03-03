FROM python:3.11.2-alpine as build

RUN adduser -D app && apk update && apk add runuser

USER app

RUN pip install waitress pmml-ui==0.1.1

CMD [ "/home/app/.local/bin/waitress-serve", "--call", "pmml_ui.app:create_app"]
