#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pmml_ui.updater import exceptions
from flask import abort

def exception_handler(func):
    def inner_function(*args, **kwargs):
        try:
            func(*args, **kwargs)
        except exceptions.KubernetesConnectionError:
            return abort(503, "Kubernetes connection failed")
    return inner_function
