SHELL:=/bin/bash -O globstar
.SHELLFLAGS = -ec
.PHONY:
.DEFAULT_GOAL := list
# this is just to try and supress errors caused by poetry run
export PYTHONWARNINGS=ignore:::setuptools.command.install

list:
	@grep '^[^#[:space:]].*:' Makefile

pwd := ${PWD}
dirname := $(notdir $(patsubst %/,%,$(CURDIR)))

install:
	asdf plugin-add tflint https://github.com/skyzyx/asdf-tflint || true
	asdf plugin-add terraform-docs https://github.com/looztra/asdf-terraform-docs || true
	asdf install
	poetry install --sync
	poetry run pre-commit install
	poetry run pre-commit autoupdate

update:
	poetry update

pre-commit:
	@poetry run pre-commit run --all-files
