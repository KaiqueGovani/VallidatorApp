from time import gmtime, strftime
from bucket_util import pegar_url_bucket, pegar_nome_bucket
import os

def run_storage_setup():
    # Importa o cliente do storage da biblioteca do google cloud
    from google.cloud import storage

    # Instancia um cliente do storage com as credenciais do GCP
    storage_client = storage.Client.from_service_account_json("../config/credentials.json")

    # Checa se o cliente foi instanciado corretamente
    if not storage_client:
        print("Erro ao instanciar o cliente do storage.")
        return
    
    # Checa se o arquivo bucket-name.txt já existe
    if os.path.isfile("bucket-name.txt"):
        bucket_name = pegar_nome_bucket()
        print(f"{bucket_name} encontrado em bucket-name.txt.")
        
        # Checa se o bucket com esse nome já existe
        if storage_client.lookup_bucket(bucket_name):
            print(f"Bucket {bucket_name} existe no cloud storage.")
        else:
            print(f"Bucket {bucket_name} não existe no cloud storage.")
            print("Gerando novo bucket...")
            
            # Nome para seu bucket do GCS
            bucket_name = "vallidator-" + strftime("%Y%m%d%H%M%S", gmtime()) # 
            
             # Cria o bucket
            bucket = storage_client.create_bucket(bucket_name, location="us-central1")
            print(f"Bucket {bucket.name} criado.")
            
            # Cria um arquivo para salvar o nome do bucket
            with open("bucket-name.txt", "w") as f:
                f.write(bucket_name)
    
            print(f"nome do Bucket salvo em bucket-name.txt.")
    else:
        # Nome para seu bucket do GCS
        bucket_name = "vallidator-" + strftime("%Y%m%d%H%M%S", gmtime())

         # Cria o bucket
        bucket = storage_client.create_bucket(bucket_name, location="us-central1")
        print(f"Bucket {bucket.name} criado.")
        
        # Cria um arquivo para salvar o nome do bucket
        with open("bucket-name.txt", "w") as f:
            f.write(bucket_name)

        print(f"nome do Bucket salvo em bucket-name.txt.")
        
    print(f"Bucket disponível em: " + pegar_url_bucket())
        

if __name__ == "__main__":
    run_storage_setup()
