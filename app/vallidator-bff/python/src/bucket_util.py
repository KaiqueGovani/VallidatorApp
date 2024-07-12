import json
import pandas as pd
import os
import psycopg2
import sys
import io
from google.cloud import storage

#! Documentar melhor as funções com docstrings detalhadas


# Função para pegar o nome do bucket
def pegar_nome_bucket():
    """Pega o nome do bucket"""

    with open("bucket-name.txt", "r") as f:
        return f.read()


def pegar_url_bucket():
    """Pega a url do bucket"""

    return "https://console.cloud.google.com/storage/browser/" + pegar_nome_bucket()

# Funçao para verificar se o arquivo tem uma extensão válida
def arquivo_permitido(filename):
    """Verifica se o arquivo tem uma extensão válida"""
    ext = filename.rsplit(".", 1)[1].lower()  # pega a extensão do arquivo
    if ext in ["csv", "xlsx", "xls"]:
        return True
    else:
        return False


# Função que cria a pasta de uploads caso não exista
def criar_pasta_uploads():
    """Cria a pasta de uploads caso não exista"""

    if not os.path.exists("uploads"):
        os.makedirs("uploads")
    return


# Função que salva o arquivo na pasta uploads
def salvar_uploads(file):
    """Salva o arquivo na pasta uploads"""

    criar_pasta_uploads()  # cria a pasta de uploads caso não exista

    file.save(
        os.path.join("uploads", file.filename)
    )  # Salva o arquivo na pasta uploads
    return


def pegar_uploads_dir():
    """Pega o diretório da pasta de uploads"""


# Função que lê o arquivo de configuração
def ler_config():
    """Lê o arquivo de configuração em formato JSON. Levanta exceções para erros como arquivo não encontrado ou JSON inválido."""

    try:
        with open("../config/config.json", "r") as config_file:
            config = json.load(config_file)

        return config

    except FileNotFoundError:
        raise Exception("Arquivo de configuração não encontrado")

    except json.JSONDecodeError:
        raise Exception("Arquivo de configuração inválido")

    except Exception as error:
        raise Exception("Erro ao ler o arquivo de configuração:", error)


# Função que conecta ao banco de dados
def conectar_banco():
    """Conecta ao banco de dados"""

    config = ler_config()

    # Usa a configuração para conectar ao banco de dados
    try:
        connection = psycopg2.connect(
            dbname=config["database"],
            user=config["user"],
            password=config["password"],
            host=config["host"],
        )

        cursor = connection.cursor()
        return connection, cursor

    except psycopg2.Error as error:
        if connection:
            connection.close()

        raise Exception("Erro ao conectar ao banco via psycopg2:", error)


# Função que obtém os tipos de dados do banco
def obter_tipos():
    """Obtém os tipos de dados do banco"""

    conn, cur = conectar_banco()

    cur.execute("SELECT * FROM tipos ORDER BY id")

    resultado = cur.fetchall()

    return resultado


# Função que obtém os tipos de dados do banco em um dicionário
def obter_tipos_map():
    """Obtém os tipos de dados do banco em um dicionário"""

    tipos = obter_tipos()

    tipoMap = {}

    for tipo in tipos:
        tipoMap[tipo[0]] = tipo[1], tipo[2]

    return tipoMap


# Função que obtém as informações do template id em um objeto
def obter_info_template(id):
    """Obtém as informações do template id em um objeto"""

    try:
        conn, cur = conectar_banco()

        cur.execute(
            f"""
                SELECT 
                    t.id AS template_id,
                    t.nome AS template_nome,
                    t.id_criador,
                    t.extensao,
                    json_agg(json_build_object(
                        'ordem', tc.ordem,
                        'id_tipo', tc.id_tipo,
                        'nome_campo', tc.nome_campo,
                        'anulavel', tc.anulavel
                    )) AS campos
                FROM
                    public.template t
                JOIN
                    public.templatescampos tc ON t.id = tc.id_template
                WHERE
                    t.id = {id}
                GROUP BY
                    t.id, t.nome, t.id_criador, t.extensao
            """
        )

        resultado = cur.fetchone()

        if resultado:
            resultado = dict(zip([desc[0] for desc in cur.description], resultado))
            return resultado

        else:
            raise Exception(f"Template com id {id} não encontrado")

    except Exception as error:
        raise Exception("Erro ao obter campos do template:", error)


# Função que obtém os tipos de dados do banco em um dicionário
def converter_para_dataframe(file):
    """Converte o arquivo csv, xls ou xlsx para um dataframe"""

    if file.endswith(".csv"):
        return pd.read_csv(file)

    elif file.endswith(".xls"):
        return pd.read_excel(file)

    elif file.endswith(".xlsx"):
        return pd.read_excel(file)


# Função para verificar se o nome das colunas do arquivo é igual ao nome dos campos do template e também se são a mesma quantidade
def verificar_nome_colunas(df, campos) -> str:
    """Verifica se o nome das colunas do dataframe é igual ao nome dos campos do template e também se são a mesma quantidade

    Raise Exception se for diferente

    Args:
        df (dataframe): DataFrame do Arquivo
        campos (campo): Array dos objetos de campos do template

    """

    try:
        # Verificar primeiro se o número de colunas é igual ao número de campos
        if len(campos) != len(df.columns.values):
            raise Exception(
                "Número de colunas do arquivo é diferente do número de campos do template"
            )

        # Verificar se o nome das colunas é igual ao nome dos campos
        for i in range(len(campos)):
            # Se o nome dos campos for diferente do esperado
            if (campos[i]["nome_campo"] != df.columns.values[i]):  
                raise Exception(
                    f"Nome da coluna '{df.columns.values[i]}' é diferente do esperado '{campos[i]['nome_campo']}'"
                )

        # print("verificarNomeColunas OK")  # ! Remover
        return "OK"

    except Exception as error:
        # print("Erro ao verificar nome das colunas", error.args[0])  # ! Remover
        raise Exception("Erro ao verificar nome das colunas. " + error.args[0])


# Funçao para verificar se o arquivo tem uma extensão válida
def verificar_extensão(filename, extensao):
    """Verifica se o arquivo tem a extensão esperada"""
    try:
        if filename == "":
            raise Exception("Arquivo sem nome.")

        if not arquivo_permitido(filename):
            raise Exception(
                f"Extensão não permitida: {filename.rsplit('.', 1)[1].lower()}"
            )

        if not filename.endswith(extensao):
            raise Exception(
                f"Extensão não incompatível: {filename.rsplit('.', 1)[1].lower()}"
            )

        # print("verificarExtensão OK")  # ! Remover

    except Exception as error:
        raise Exception("Erro ao verificar extensão do arquivo: " + error.args[0])


def verificar_dados(df, campos):
    """Verifica os dados de um dataframe com base em campos específicos. Utiliza um mapeamento de tipos para realizar a verificação."""

    try:
        typeMap = obter_tipos_map()

        # Iterando por cada linha e coluna
        for i in range(len(df)):
            for j in range(len(df.columns)):
                data = df.iloc[i, j]
                dtype = type(data)
                campo_type = typeMap[campos[j]["id_tipo"]][0]
                campo_dtype = typeMap[campos[j]["id_tipo"]][1]
                
                # Verifica anuláveis
                if not campos[j]["anulavel"]:
                    if pd.isnull(data):
                        raise Exception(
                            f"Coluna '{campos[j]['nome_campo']}' não deve conter valores vazios/nulos. \n Linha {i+1}, coluna '{campos[j]['nome_campo']}'."
                        )

                if not tenta_converter_com_pandas(
                    data, campo_dtype
                ):  # Se não for possível converter
                    raise Exception(
                        f"\nErro ao converter '{data}' para o tipo: {campo_type}. \n Linha {i+1}, coluna '{campos[j]['nome_campo']}'."
                    )

            #     print("dtype, campo_dtype, data")
            #     print(dtype, campo_dtype, data)
            #     #print(isinstance(data, eval(campo_dtype)))
            #     print(tenta_converter_com_pandas(data, campo_dtype))
            #     #print(i, j, typeMap[campos[j]["id_tipo"]], df.iloc[i, j])

            # print()

        # print("verificarDados OK")  # ! Remover

    except Exception as error:
        raise Exception("Erro ao verificar dados: " + error.args[0])


def validar_arquivo(filepath, id_template, depth = 0):
    """Executa uma série de verificações em um arquivo, incluindo verificar a extensão, o nome das colunas e os dados."""

    try:
        # print("Validando arquivo: ", filepath, id_template)

        # Obter informações do template e desempacotar
        info = obter_info_template(id_template)
        template_id, id_criador, extensao, campos = (
            info["template_id"],
            info["id_criador"],
            info["extensao"],
            info["campos"],
        )
        campos.sort(
            key=lambda x: x["ordem"]
        )  # Garantir que os campos estão ordenados pela ordem

        df = converter_para_dataframe(filepath)
        # df = converte_tipos_dataframe(df, campos) # Função inutilizada para ter mais precisão nos erros. No lugar, usar a função verificar_dados

        verificar_extensão(filepath, extensao)
        verificar_nome_colunas(df, campos)
        
        if (int(depth) == 1):
            verificar_dados(df, campos)
        else:
            converte_tipos_dataframe(df, campos)
    
    except Exception as error:
        # print("Erro ao verificar arquivo: " + error.args[0]) # ! Remover
        raise Exception("Erro ao verificar arquivo: " + error.args[0])


def converte_tipos_dataframe(df, campos):
    """Converte os tipos do dataframe para os tipos do banco"""
    print(campos)
    print(df)
    try:
        typeMap = obter_tipos_map()
        colunas = [campo["nome_campo"] for campo in campos]  # Obter os nomes dos campos
        colunas_dtypes = [typeMap[campo["id_tipo"]][1] for campo in campos]  # Obter os data-tipos dos campos
        anulaveis = [campo["anulavel"] for campo in campos]  # Obter os anuláveis dos campos

        dict_dtypes = dict(
            zip(colunas, tuple(zip(colunas_dtypes, anulaveis)))
        )  # Dicionário com os nomes e tipos dos campos

        print(dict_dtypes)
        for coluna, info in dict_dtypes.items():
            tipo = info[0]
            anulavel = info[1]
            if not anulavel:
                if df[coluna].isnull().values.any():
                    raise Exception(f"Coluna '{coluna}' não deve conter valores vazios/nulos")    
            try:
                df[coluna] = df[coluna].astype(tipo) # Converte os tipos das colunas
            except Exception as error:
                raise Exception(f"Erro ao converter coluna '{coluna}' para o tipo '{tipo}'")
        

        print("converteTiposDataframe OK")  # ! Remover
        return df

    except Exception as error:
        raise Exception("Erro ao converter tipos do dataframe. " + error.args[0])


def tenta_converter_com_pandas(valor, tipo):
    """Tenta converter o valor para o tipo especificado usando o pandas"""
    try:
        pd.Series([valor]).astype(tipo)
        return True
    except:
        return False


def upload_blob(bucket_name, source_file_name, destination_blob_name, save_path = None):
    """Uploada um arquivo para o bucket."""
    # The ID of your GCS bucket
    # bucket_name = "your-bucket-name"
    # The path to your file to upload
    # source_file_name = "local/path/to/file"
    # The ID of your GCS object
    # destination_blob_name = "storage-object-name"

    storage_client = storage.Client.from_service_account_json("../config/credentials.json")
    bucket = storage_client.bucket(bucket_name)
    if (save_path):
        destination_blob_name = save_path + '/' + destination_blob_name
    blob = bucket.blob(destination_blob_name)

    blob.upload_from_filename(source_file_name)

    # print(f"File {source_file_name} uploaded to {destination_blob_name}.")


def apagar_arquivo(path: str):
    """Apaga o arquivo no caminho especificado

    Args:
        path (str): caminho para o arquivo
    """
    
    os.remove(path)
    # print(f"Arquivo {path} apagado.")
    

def tamanho_arquivo(path: str):
    """Retorna o tamanho do arquivo no caminho especificado

    Args:
        path (str): caminho para o arquivo
    """
    
    return os.path.getsize(path)
