#!/usr/bin/env bash

sed "s,python:2-alpine3.7,python:2-alpine3.8," | grep -v "^EXPOSE"