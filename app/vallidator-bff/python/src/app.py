from flask import Flask, request, jsonify, send_file
import os
import pandas as pd
from io import BytesIO

from bucket_util import *  # importa todas as funções do bucket_util.py

app = Flask(__name__)


@app.route("/")
def hello_world():
    return 200


@app.route("/validar", methods=["POST"])
def validar():
    try:
        if not request.form["id_template"]:
            return {
                "mensagem": "id_template não enviado."
            }, 400  # retorna um json com uma mensagem de erro

        if "file" not in request.files:  # verifica se o arquivo foi enviado
            return {
                "mensagem": "Arquivo não enviado."
            }, 400  # retorna um json com uma mensagem de erro

        file = request.files["file"]  # pega o arquivo enviado

        app.logger.info(f"Arquivo recebido: {file.filename}")

        if file.filename == "":  # verifica se o arquivo tem um nome
            return {"mensagem": "Arquivo sem nome."}, 400

        if not arquivo_permitido(
            file.filename
        ):  # verifica se o arquivo tem uma extensão válida
            return {
                "mensagem": f"Extensão não permitida: {file.filename.rsplit('.', 1)[1].lower()}"
            }, 400

        caminho = request.form["caminho"] if "caminho" in request.form else None
        depth = request.form["depth"] if "depth" in request.form else None
        
        app.logger.info(f"Caminho recebido: {caminho}")
        app.logger.info(f"Depth recebido: {depth}")

        if file:  # verifica se o arquivo existe
            criar_pasta_uploads()  # cria a pasta de uploads caso não exista
            filedir = "uploads/"

            salvar_uploads(file)

            try:
                validar_arquivo(filedir + file.filename, request.form["id_template"], depth)

                # Realiza o upload do arquivo para o bucket caso o bucket exista
                if (pegar_nome_bucket()):
                    try :
                        upload_blob(pegar_nome_bucket(), filedir + file.filename, file.filename, caminho)
                        pass
                    except Exception as error:
                        print(error.args[0]) 
        
                return {"mensagem": "Sucesso!"}, 200

            except Exception as error:
                # Apagar o arquivo aqui
                # ! apagar_arquivo(filedir + file.filename)
                raise Exception(error.args[0])

        return {"mensagem": "Erro no upload."}, 500

    except Exception as error:
        # retorna um json com uma mensagem de erro
        return {"mensagem": f"{error.args[0]}"}, 500

@app.route("/download", methods=["POST"])
def download_template():
    try:
        # Pega o JSON do corpo da requisição
        data = request.get_json()
        
        app.logger.info(f"JSON recebido: {data}")

        # Cria um DataFrame com os cabeçalhos das colunas e uma linha com os tipos
        headers = [field['nome_campo'] for field in data['campos']]
        types = [field['nome_tipo'] for field in data['campos']]

        # Cria um buffer para armazenar o arquivo temporariamente
        buffer = BytesIO()

        # Escreve os cabeçalhos e tipos em um arquivo, dependendo da extensão
        if data['extensao'] == 'csv':
            # Para CSV, escreve diretamente no buffer
            buffer.write(','.join(headers).encode(encoding='utf-8'))
            buffer.write('\n'.encode(encoding='utf-8'))
            buffer.write(','.join(types).encode(encoding='utf-8'))
            buffer.seek(0) # Volta ao início do buffer para ler o conteúdo na resposta
        elif data['extensao'] in ['xls', 'xlsx']:
            # Para Excel, usa o Pandas para escrever
            df = pd.DataFrame([types], columns=headers)
            df.to_excel(buffer, index=False, engine='openpyxl')
            buffer.seek(0) # Volta ao início do buffer para ler o conteúdo na resposta
        else:
            return "Extensão não suportada", 400

        buffer.seek(0)

        # Retorna o arquivo
        return send_file(buffer, as_attachment=True, download_name=f"file.{data['extensao']}")

    except ValueError as ve:  # Catch only ValueError
        return {"mensagem": str(ve)}, 400  # Return a client error on bad request
    except Exception as e:  # Catch all other exceptions
        return {"mensagem": f"Erro ao gerar template de download: {str(e)}"}, 500  # Return a server error
    
if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
