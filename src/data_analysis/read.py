import pandas as pd 
import os 

base_path = os.path.dirname(os.path.abspath(__file__))
parent_path = os.path.dirname(base_path)

file_path = os.path.join(parent_path, "data","inttrib.xlsx")


print(file_path)

# gerado 03-09
df = pd.read_excel(file_path, sheet_name= 'Planilha1')
grouped_df = ( df.groupby(['F3_NFISCAL','F3_SERIE', 'F3_CLIEFOR'])['F3_NFISCAL'].count()
              .reset_index(name = 'Quantidade')
              .query('Quantidade > 1'))

print(grouped_df)