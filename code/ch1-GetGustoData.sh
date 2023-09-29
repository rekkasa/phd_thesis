#!/bin/bash
[[ ! -e "data/introduction" ]] && mkdir -p data/introduction || echo -e "Directory introduction already exists"
[[ ! -f "data/introduction/gusto.rda" ]] && wget --output-document data/introduction/gusto.rda -nc https://github.com/rekkasa/phd_thesis/raw/large-files/data/introduction/gusto.rda || echo -e "Nothing to be done"
