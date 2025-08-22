import json
import os

from ver import *

base_path = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(base_path, "ceps.json")

#chamada do arquivo que contem os dados com Json
'''
Como eu não sei se posso conectar o Banco direto no projeto em python, crie um json com os 10 primeiros códigos 
'''

with open(file_path, "r") as f:
    ceps = json.load(f)
    for x in range(len(ceps)):
        verifica_cep(ceps[x])
    f.close()
