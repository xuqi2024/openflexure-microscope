#!/usr/bin/env python3
"""
This is used to write version string on CI int a .env file.
It is needed due to a weird LFS bug in GitLab
https://gitlab.com/gitlab-org/gitlab/-/issues/325299
"""
from build_system.util import version_string
version_string = version_string(force_clean=True, check_env=False)

for env in ['build.env', 'render.env']:
    with open(env, 'w', encoding="utf-8") as file_obj:
        file_obj.write("CI_VERSION_STRING="+version_string)
