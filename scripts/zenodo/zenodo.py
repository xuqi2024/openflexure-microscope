"""
Copyright (c) 2020 Bath Open Instrumentation Group
Adapted from: https://gitlab.com/schlauch/zenodo-api-test/
Copyright (c) 2018 German Aerospace Center (DLR). All rights reserved.
SPDX-License-Identifier: MIT-DLR

"""
import json
import os

import requests


class Zenodo:
    def __init__(self, api_token, use_sandbox=True):
        self._api_token = api_token
        self._use_sandbox = use_sandbox
        if use_sandbox:
            self.zenodo_url = "https://sandbox.zenodo.org/api/deposit/depositions"
        else:
            self.zenodo_url = "https://zenodo.org/api/deposit/depositions"

    def create_new_deposit(self):
        """ Creates a new (unpublished) Zenodo deposit and return its deposition ID. """

        headers = {"Content-Type": "application/json"}
        r = requests.post(
            self.zenodo_url,
            params={"access_token": self._api_token},
            json={},
            headers=headers,
        )
        print(r.status_code)
        print(r.json())
        return r.json()

    def set_metadata(self, deposition_id, metadata):
        """ Sets the given metadata for the specified deposit. """

        headers = {"Content-Type": "application/json"}
        r = requests.put(
            self.zenodo_url + "/{}".format(deposition_id),
            params={"access_token": self._api_token},
            data=json.dumps({"metadata": metadata}),
            headers=headers,
        )
        print(r.status_code)
        print(r.json())

    def upload_file(self, deposition_id, file_path):
        """ Uploads a new file for the given deposit. """

        file_name = os.path.basename(file_path)
        data = {"filename": file_name}
        files = {"file": open(file_path, "rb")}
        r = requests.post(
            self.zenodo_url + "/{}/files".format(deposition_id),
            params={"access_token": self._api_token},
            data=data,
            files=files,
        )
        print(r.status_code)
        print(r.json())

    def publish_deposit(self, deposition_id):
        """ Publishes the given deposit. BEWARE: It is now visible to all!!! """

        r = requests.post(
            self.zenodo_url + "/{}/actions/publish".format(deposition_id),
            params={"access_token": self._api_token},
        )
        print(r.status_code)
        print(r.json())

    def create_new_version(self, deposition_id):
        """ Creates a new version of an already published deposit. """

        r = requests.post(
            self.zenodo_url + "/{}/actions/newversion".format(deposition_id),
            params={"access_token": self._api_token},
        )
        print(r.status_code)
        print(r.json())
        return os.path.basename(r.json()["links"]["latest_draft"])

    def remove_all_files(self, deposition_id):
        """ Removes all uploaded files of a unpublished deposit. """

        r = requests.get(
            self.zenodo_url + "/{}/files".format(deposition_id),
            params={"access_token": self._api_token},
        )
        print(r.status_code)
        print(r.json())
        for file_entry in r.json():
            print("Remove file entry: " + file_entry["id"])
            print(
                requests.delete(
                    self.zenodo_url
                    + "/{}/files/{}".format(deposition_id, file_entry["id"]),
                    params={"access_token": self._api_token},
                )
            )
