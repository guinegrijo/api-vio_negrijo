## baixa e executa a imagem do node na versão Alpine (versão simplificada)
FROM node:alpine

## define o local onde o app irá ficar no disco do container
## o caminho o Dev quem escolhe
WORKDIR /usr/app

## Copia tudo que começa com package e termina com .json para dentro do usr/app
COPY package*.json ./

## Executa npm install para adicionar todas as dependencias e criar a pasta node_modules
RUN npm install

## Copia tudo que está no diretório onde o arquivo Dockerfile está
## Será copiado dentro da pasta /usr/app do container
## Vamos ignorar a node_modules (.dockerignore)
COPY . .

## Container ficará ouvindo os acesos na porta 5000
EXPOSE 5000 

## Executa o comando para iniciar o script que está no package.json
CMD npm start