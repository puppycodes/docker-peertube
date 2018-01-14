#!/usr/bin/python

import os
import subprocess
import jinja2

convert = lambda src, dst, args: open(dst, "w").write(jinja2.Template(open(src).read()).render(**args))

# Actual startup script
convert("/conf/production.yaml", "/app/config/production.yaml", os.environ)
os.execv("/usr/local/bin/npm", ["npm", "start"])
