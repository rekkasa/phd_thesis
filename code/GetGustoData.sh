#!/bin/bash
[[ ! -e "data/introduction" ]] && mkdir -p data/introduction || echo -e "Directory introduction already exists"
[[ ! -f "data/introduction/gusto.rda" ]] && wget --output-document data/introduction/gusto.rda -nc http://hbiostat.org/data/gusto.rda || echo -e "Nothing to be done"
