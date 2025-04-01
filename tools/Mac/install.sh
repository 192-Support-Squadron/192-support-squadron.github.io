#!/bin/bash

VENVPATH="venv-mkdocs"

brew install python
brew install pipx
pipx install virtualenv
python3 -m venv $VENVPATH\
pip install -r requirements.txt