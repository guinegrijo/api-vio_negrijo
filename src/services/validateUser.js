module.exports = function validateUser({
    cpf,
    email,
    password,
    name,
    data_nascimento,
  }) {
    if (!cpf || !email || !password || !name || !data_nascimento) {
      return { error: "Todos os campos devem ser preenchidos" };
    }
  
    if (isNaN(cpf) || cpf.length !== 11) {
      return {
        error: "CPF inválido. Deve conter exatamente 11 dígitos numéricos",
      };
    }
  
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res
        .status(400)
        .json({ error: "E-mail inválido." });
    }
  
    return null; // Retorna null se não houver erro
  };  