const connect = require("../db/connect");

module.exports = async function validateCpf(cpf, userId = null) {
  return new Promise((resolve, reject) => {
    const query = "SELECT id_usuario FROM usuario WHERE cpf = ?";
    const values = [cpf];

    if(!validateCpf(cpf)) {
      resolve({error: "Informe um CPF válido"})
    }

    connect.query(query, values, (err, results) => {
      if (err) {
        reject("Erro ao verificar CPF");
      } else if (results.length > 0) {
        const cpfCadastrado = results[0].id_usuario;

        // Se um userId foi passado (update) e o CPF pertence a outro usuário, retorna erro
        if (userId && cpfCadastrado !== userId) {
          resolve({ error: "CPF já cadastrado para outro usuário" });
        } else if (!userId) {
          resolve({ error: "CPF já cadastrado" });
        } else {
          resolve(null);
        }
      } else {
        resolve(null);
      }
    });
  });
};

function validateCpfMath(cpf){
  cpf = cpf.replace(/[^\d]+/g,'')

  if(cpf.length !== 11 || /^(\d)\1+$/.test(cpf)) return false

  const calcularDigito = (base, pesoInicial) => {
    let soma = 0
    for(let i = 0; i < base.length; i++){
      soma += parseInt(base[i]) * (pesoInicial - i)
    }

    const resto = soma % 11
    return resto < 2 ? 0 : 11 - resto
  }

  const primeiroDigito = calcularDigito(cpf.substring(0,9), 10) //" 1 2 3 4 5 6 7 8 9 8" x= 8
  const segundoDigito = calcularDigito(cpf.substring(0,9) + primeiroDigito, 10)

  return (
    parseInt(cpf[9]) === primeiroDigito && parseInt(cpf[10]) === segundoDigito
  )


}