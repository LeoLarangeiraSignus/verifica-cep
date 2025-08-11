import requests
import time
import json

# cep = "13260000"
ceps = [
        '13253322',
        '07232-11',
        '88307322',
        '09823000',
        '13347120',
        '13347120',
        '13080150',
        '09370800',
        '04795100',
        '13260000']
erroCep = []
# url = f"https://viacep.com.br/ws/{cep}/json/"


for cep in range(len(ceps)):
    res = requests.get(f'https://viacep.com.br/ws/{ceps[cep]}/json/')
    time.sleep(1)
    if res.status_code == 200:
        dados = res.json()
        # dados = json.loads(dados)
        print(dados)
        # print(dados['erro'])
        if 'erro' in dados:
            erroCep.append(ceps[cep])

print(erroCep)


