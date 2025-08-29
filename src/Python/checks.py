import requests
import openpyxl
import os 
ERROCEP = []
EMAIL = ''
AEMAIL = []
NUMBERS = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

def verifica_cep(CEPS):
    cep = CEPS['cep']
    cep = cep.strip()
    res = requests.get(f"https://viacep.com.br/ws/{cep}/json/")

    # Initialize or load the workbook
    filename = 'ceps-errados.xlsx'
    if os.path.isfile(filename):
        workbook = openpyxl.load_workbook(filename)
        sheet = workbook.active
    else:
        workbook = openpyxl.Workbook()
        sheet = workbook.active
        sheet.title = 'CEPs Errados'
        # Write headers
        sheet.append(['Email', 'CEP'])

    if res.status_code == 200:
        dados = res.json()  
        if 'erro' in dados: 
            email = CEPS['email']
            AEMAIL.append([email, cep])
            # Append to Excel sheet
            sheet.append([email, cep])
            # Save the workbook
            workbook.save(filename)

    return AEMAIL

