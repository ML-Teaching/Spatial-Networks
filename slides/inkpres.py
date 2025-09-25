#! /usr/bin/python3
import xml.etree.ElementTree as ET
import shutil
import os
import copy
import sys
import argparse
from PyPDF2 import PdfMerger

# --- Arguments ---
parser = argparse.ArgumentParser()
parser.add_argument("--input", type=str, help="Path to input SVG file")
parser.add_argument("--output", type=str, help="Path to output PDF file")
args = parser.parse_args()

# --- Input file ---
input_file = args.input if args.input else 'presentation.svg'

# --- Output file ---
if args.output:
    output_file = args.output
    if not output_file.lower().endswith('.pdf'):
        print(f"Error: output file '{output_file}' must have a .pdf extension.")
        sys.exit(1)
else:
    output_file = os.path.splitext(input_file)[0] + '.pdf'

# --- Input validation ---
if not os.path.isfile(input_file):
    print(f"Error: input file '{input_file}' does not exist.")
    sys.exit(1)

if not input_file.lower().endswith('.svg'):
    print(f"Error: input file '{input_file}' is not an SVG file.")
    sys.exit(1)

# --- Output folder check ---
output_dir = os.path.dirname(os.path.abspath(output_file))
if not os.path.exists(output_dir):
    try:
        os.makedirs(output_dir)
    except Exception as e:
        print(f"Error: cannot create output directory '{output_dir}': {e}")
        sys.exit(1)

# --- Temporary folder ---
temp_dir = 'temp'
if os.path.exists(temp_dir):
    shutil.rmtree(temp_dir)
os.makedirs(temp_dir)

# --- Convert layers to SVG ---
tree = ET.parse(input_file)
root = tree.getroot()
list_of_layers = []

for g in root.findall('{http://www.w3.org/2000/svg}g'):
    name = g.get('{http://www.inkscape.org/namespaces/inkscape}label')
    list_of_layers.append(name)

for counter, lname in enumerate(list_of_layers):
    if len(lname) == 1:
        lname = 'char_' + str(ord(lname))
    layers_copy = list_of_layers[:]
    temp_tree = copy.deepcopy(tree)
    del layers_copy[counter]
    temp_root = temp_tree.getroot()
    for g in temp_root.findall('{http://www.w3.org/2000/svg}g'):
        name = g.get('{http://www.inkscape.org/namespaces/inkscape}label')
        if name in layers_copy:
            temp_root.remove(g)
        else:
            style = g.get('style')
            if isinstance(style, str):
                style = style.replace('display:none', 'display:inline')
                g.set('style', style)
    temp_tree.write(os.path.join(temp_dir, lname + '.svg'))
    print(f"Layer '{lname}' successfully converted to SVG!")

print(' ')

# --- Convert SVG to PDF ---
for lname in list_of_layers:
    svg_path = os.path.join(temp_dir, lname + '.svg')
    pdf_path = os.path.join(temp_dir, lname + '.pdf')
    command = f'inkscape --export-type=pdf "{svg_path}" -o "{pdf_path}"'
    os.system(command + ' > /dev/null 2>&1')
    print(f"'{lname}.svg' successfully converted to PDF!")

print(' ')

# --- Merge PDFs ---
pdf_paths = [os.path.join(temp_dir, lname + '.pdf') for lname in list_of_layers]
merger = PdfMerger()
for pdf in pdf_paths:
    merger.append(pdf)
merger.write(output_file)
merger.close()
print(f"PDFs successfully merged into '{output_file}'")

# --- Cleanup ---
if os.path.exists(temp_dir):
    shutil.rmtree(temp_dir)

