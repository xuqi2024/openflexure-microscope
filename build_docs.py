# Copy the documentation files to a folder, allowing for some processing.
from __future__ import print_function
import os
import sys
import shutil
import re

def insert_markdown(infile, outfile):
    """Insert content into the target markdown file"""
    pass

def process_markdown(infile, outfile):
    """Process and copy a markdown file, and scan for images used in the file"""
    images = set()
    with open(infile, 'r', encoding='utf8') as input_file, open(outfile, 'w', encoding='utf8') as output_file:
        print(f"Opened {infile}...")

        # Inject extra markdown only if the file isn't special
        if (os.path.basename(infile)[0] != "_"):
            insert_markdown(infile=infile, outfile=outfile)
        else:
            print(f"File {infile} is special. Copying without modification.")

        # Copy the basic markdown content into the new file, and find images
        for line in input_file:
            # Copy over the line
            output_file.write(line) # copy over the file
            # Search for images
            m = re.search(r"images/([^.]*\.(jpeg|jpg|JPG|JPEG|png|PNG))", line)
            if m:
                images.add(m.group(1))
    return images


if __name__ == "__main__":
    # Find all relevant directories
    here = os.path.dirname(os.path.realpath(__file__))
    docs_dir = os.path.abspath(os.path.join(here, "docs"))
    parts_dir = os.path.abspath(os.path.join(docs_dir, "parts"))
    build_dir = os.path.abspath(os.path.join(here, "builds"))
    output_dir = os.path.abspath(os.path.join(build_dir, "docs"))

    if not os.path.isdir(build_dir):
        os.mkdir(build_dir)

    # Delete the output directory if it exists
    if os.path.isdir(output_dir):
        shutil.rmtree(output_dir)

    # Create the output directory and the folder structure
    os.mkdir(output_dir)
    os.mkdir(os.path.join(output_dir, "parts"))

    for f in os.listdir(parts_dir):
        if os.path.isdir(os.path.join(parts_dir, f)):
            os.mkdir(os.path.join(output_dir, "parts", f))
    os.mkdir(os.path.join(output_dir, "images"))

    # Copy our docsify index page
    shutil.copyfile(os.path.join(docs_dir, "index.html"), os.path.join(output_dir, "index.html"))

    # Create a set to note our used image files
    images = set()
    # TODO: This should be recursive or something - but for now, I just enumerate the parts directory
    for input_dir in ['.', 'parts'] + [os.path.join('parts', d) for d in os.listdir(parts_dir) if os.path.isdir(os.path.join(parts_dir, d))]:
        input_dir_abs = os.path.join(docs_dir, input_dir)
        for f in os.listdir(os.path.join(docs_dir, input_dir)):
            if f.endswith(".md"):
                f_images = process_markdown(os.path.join(input_dir_abs, f), os.path.join(output_dir, input_dir, f))
                images.update(f_images)

    # Copy over only the images that are actually used
    for f in images:
        shutil.copyfile(os.path.join(docs_dir, "images", f), os.path.join(output_dir, "images", f))

