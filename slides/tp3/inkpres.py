#! /usr/bin/python3
import xml.etree.ElementTree as ET
import shutil
import os
import copy
import sys
from PyPDF2 import PdfMerger

# Temporary folder
temp = 'temp'
if os.path.exists(temp):
    shutil.rmtree(temp)
os.makedirs(temp)

# Convert layer to svg (based on https://github.com/james-bird/layer-to-svg)
tree = ET.parse('presentation.svg')
root = tree.getroot()
listoflayers=[]
for g in root.findall('{http://www.w3.org/2000/svg}g'):
    name = g.get('{http://www.inkscape.org/namespaces/inkscape}label')
    listoflayers.append(name)
#print(listoflayers)
#print(' ')

for counter in range(len(listoflayers)):
    lname = listoflayers[counter]
    if len(lname) == 1:
        lname = 'char_' + str(ord( lname ))
    james=listoflayers[:]
    temp_tree = copy.deepcopy(tree)
    del james[counter]
    temp_root = temp_tree.getroot()
    for g in temp_root.findall('{http://www.w3.org/2000/svg}g'):
        name = g.get('{http://www.inkscape.org/namespaces/inkscape}label')
        if name in james:
            temp_root.remove(g)
        else:
            style = g.get('style')
            if type(style) is str:
                style = style.replace( 'display:none', 'display:inline' )
                g.set('style', style)
    temp_tree.write( os.path.join(temp, lname +'.svg' ))
    print('Layer ' + str(lname) + ' successfully converted in svg!')
print(' ')
	
# Convert svg to pdf
for counter in range(len(listoflayers)):
    lname = listoflayers[counter]
    svg = str(temp) + '/' + str(lname) + '.svg'
    pdf = str(temp) + '/' + str(lname) + '.pdf'
    command = 'inkscape --export-type=pdf ' + svg + ' -o ' + pdf 
    os.system(command + ' > /dev/null 2>&1')
    print(str(lname) + '.svg successfully converted in pdf!')
print(' ')    

# Merge pdf
pdfs = [sub + '.pdf' for sub in listoflayers]
merger = PdfMerger()
for pdf in pdfs:
    merger.append(temp + '/' + pdf)
merger.write("presentation.pdf")
merger.close()
print('pdfs successfully merged')

# Remove temp
if os.path.exists(temp):
    shutil.rmtree(temp)	


