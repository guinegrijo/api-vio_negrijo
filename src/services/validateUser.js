module.exports = function validateUser ({cpf, email, password, name, data_nascimento}) {
    if (!cpf || !email || !password || !name || !data_nascimento) {
        return{error: "todos os campos devem ser preenchidos"}
    }
    if (isNaN(cpf)||cpf.length != 11){
        return {error: "CPF inválido, deve conter 11 dígitos numéricos"}
    }
    if (!email.includes('@')){
        return {error: "Email inválido, deve conter @"}
    }
    return null
}