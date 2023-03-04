FROM python:3.11.2-alpine as build

RUN adduser -D app && apk update && apk add runuser

USER app

COPY dist/* /home/app/dist/

RUN pip install waitress=2.1.2 /home/app/dist/pmml_ui-0.1.4-py3-none-any.whl

CMD [ "/home/app/.local/bin/waitress-serve", "--call", "pmml_ui.app:create_app"]
