#!/usr/bin/env python

import sys
import re
import requests
import subprocess
import semver

endpoint = 'https://gitlab.com'
project_path = 'openflexure/openflexure-microscope'
project_id = '12049246'
# To find project_id for another project, see 
# https://stackoverflow.com/questions/39559689/where-do-i-find-the-project-id-for-the-gitlab-api
# Go to the project page in a browser and open dev tools (Ctrl+Shift+I)
# Paste `document.getElementById('project_id').value` into the console

def get_releases():
    """Return a list of tagged releases
    
    Currently this returns all tags starting with v and a number.
    """
    stdout = subprocess.check_output(["git", "tag"]).decode("utf8")
    release_semvers = []
    semvers_to_tags = {}
    for line in stdout.split("\n"):
        if line.startswith("v"):
            tag = line.strip()
            if line=="v5.15.2a":
                line="v5.15.2-a"
            try:
                v = semver.VersionInfo.parse(line.lstrip("v ").rstrip())
                release_semvers.append(v)
                semvers_to_tags[str(v)] = tag
            except:
                # the tag was not a release
                print(f"{line.strip()} was not a release.")
                pass
    # Use semantic versioning to sort the releases in order
    release_semvers.sort()
    # Convert them back into the tags for return
    return [semvers_to_tags[str(v)] for v in release_semvers]

def get_commits_between_refs(start, end):
    commits = subprocess.check_output(["git", "log", "--merges", "--pretty=format:%H", start, end]).decode("utf8")
    return [c.strip() for c in commits.split("\n")]

def get_date_for_tag(tag):
    return subprocess.check_output(["git", "log", "-1", "--pretty=tformat:%ad", "--date=short", tag]).decode("utf8").strip()

def list_merge_requests_for_commits(commits):
    mrs = set()
    for hash in commits:
        r = requests.get(endpoint + '/api/v4/projects/' + project_id + '/repository/commits/' + hash + '/merge_requests')
        for mr in r.json():
            if mr['id'] in mrs:
                continue
            mrs.add(mr['id'])

            print(f"* [!{mr['iid']}]({mr['web_url']}): {mr['title']}")

if __name__ == "__main__":
    releases = get_releases()
    releases.reverse()  # Start with the newest release
    for end, start in zip(["HEAD"] + releases[:-1], releases):
        date = get_date_for_tag(end)
        print(f"## [{end}]({endpoint}/{project_path}/compare/{start}..{end}/) ({date})")
        print()
        commits = get_commits_between_refs(start, end)
        list_merge_requests_for_commits(commits)
        print()