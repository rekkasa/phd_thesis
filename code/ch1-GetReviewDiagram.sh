#!/bin/bash
[[ ! -f figures/reviewDiagram.pdf ]] && wget -O figures/reviewDiagram.pdf https://github.com/rekkasa/phd_thesis/raw/develop/figures/reviewDiagram.pdf || echo -e "File exists"
