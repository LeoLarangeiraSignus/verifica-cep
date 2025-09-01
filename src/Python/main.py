import json
import os
import openpyxl
import pandas as pd
from ver import *


base_path = os.path.dirname(os.path.abspath(__file__))
parent_path = os.path.dirname(base_path)

file_path = os.path.join(parent_path, "data","dados.xlsx")


df = pd.read_excel(file_path)



for index, row in df.iterrows():
    name = row['A1_NOME']
    email = row['A1_EMAIL']
    tel = row['A1_TEL']
    cep = row['A1_CEP']

    ceps = {'nome': name, 'email': email, 'cep' : cep, 'tel' : tel}

    
    verifica_cep(ceps)
# with open(file_path, "r") as f:
#     ceps = json.load(f)
#     for x in range(len(ceps)):
#         verifica_cep(ceps[x])
#     f.close()
