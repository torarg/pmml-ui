FROM python:3.11.2-alpine

RUN adduser -D app

USER app

COPY dist/* /home/app/dist/

RUN pip install waitress==2.1.2 /home/app/dist/pmml_ui-0.1.5-py3-none-any.whl

CMD [ "/home/app/.local/bin/waitress-serve", "--call", "pmml_ui.app:create_app"]
