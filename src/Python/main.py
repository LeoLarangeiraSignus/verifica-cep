import requests
import time
import json

ceps = [
        {
            'email': 'teste@mail.com',
            'cep':  '13253322'},
        {
         'email': 'teste@mail.com',    
        'cep': '07232-11'},
        { 
            'email': 'teste@mail.com',
            'cep':'88307322'},
        { 
            'email': '',
            'cep':'09823000'},
        { 
            'email': 'teste@mail.com',
            'cep':'13347120'},
        { 
            'email': 'teste@mail',
            'cep':'13347120'},
        { 
            'email': 'teste@mail.com',
            'cep':'13080150'},
        { 
            'email': 'teste@mail.com',
            'cep':'09370800'},
        { 
            'email': 'teste@mail.com',
            'cep':'04795100'},
        {
            'email': 'leonardo.larangeira@signus.ind.br',
            'cep':'13260000'}]
erroCep = []
email = ''
aEmail = []
# url = f"https://viacep.com.br/ws/{cep}/json/"


for cep in range(len(ceps)):
    res = requests.get(f'https://viacep.com.br/ws/{ceps[cep]['cep']}/json/')
    # time.sleep(1)
    if res.status_code == 200:
        dados = res.json()
        if 'erro' in dados:
            erroCep.append(ceps[cep])
    for x in range(len(erroCep)):
        email = erroCep[x]['email']
        aEmail.append(email)
print(email)
print(erroCep)


