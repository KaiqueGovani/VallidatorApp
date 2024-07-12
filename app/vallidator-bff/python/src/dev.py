from bucket_util import *


filedir = "uploads/"  # ! em prod seria uploads/
filename = "clientes_incorreto_valor_faltando_2023-11-16_16-46-52.csv"
id_template = 2


validar_arquivo(filedir + filename, id_template)

