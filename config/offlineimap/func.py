#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

import os
import subprocess


def get_pass(mail):
    return subprocess.check_output(f"pass {mail}", shell=True).splitlines()[0]


def mutt_oauth(mail):
    return subprocess.run(
        [
            "mutt_oauth2.py",
            os.path.join("~/.local/var/mutt_oauth/", mail)
        ],
        capture_output=True, text=True
    ).stdout
