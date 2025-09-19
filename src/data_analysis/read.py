import pandas as pd 
import os 
from io import StringIO
import xml.etree.cElementTree as ET 

base_path = os.path.dirname(os.path.abspath(__file__))
parent_path = os.path.dirname(base_path)

file_path = os.path.join(parent_path, "data","saldodet.xml")

tree = ET.parse(file_path)
root = tree.getroot()

#converte o xml todo em string e depois faz o decode para ficar no tipo certo 
structed_xml = ET.tostring(root, encoding="utf8").decode('utf8')

'''
Para o pandas fazer a leitura do xml ele precisa que exista o parse, porem, alem disso, temos o aviso que ao passar um literal xml está depreciado. 
precisamos amarrar em um objeto StringIO 
'''

buffered_xml = StringIO(structed_xml)

#le o arquivo 

df = pd.read_xml(buffered_xml)
print(df.head())