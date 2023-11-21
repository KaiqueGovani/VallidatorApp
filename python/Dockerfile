# Usando a imagem oficial do Python
FROM python:3.9-slim

# Definindo o diretório de trabalho
WORKDIR /app

# Copiando requirements e instalando dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiando o restante do código
COPY . .

# Usando a variável de ambiente FLASK_ENV para ativar o modo de desenvolvimento
ENV FLASK_ENV=development

# Definindo a variável de ambiente para evitar a criação da pasta __pycache__
ENV PYTHONDONTWRITEBYTECODE 1

# Executando a configuração inicial da aplicação em modo de desenvolvimento
CMD ["sh", "-c", "python setup-gcs.py && flask run --host=0.0.0.0 --debug"]
