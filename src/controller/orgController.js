const connect = require('../db/connect')

module.exports = class orgController {
  static async createOrg(req, res) {

    // Recebe valores do body da requisição
    const { nome, email, senha, telefone } = req.body;

    // Check se os campos foram preenchidos
    if (!nome || !email || !senha || !telefone) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos." });

    } // Check se o telefone não é feito de números ou não tem 11 digitos
    if (isNaN(telefone) || telefone.length !== 11) {
      return res.status(400).json({
        error: "Telefone inválido. Deve conter exatamente 11 dígitos numéricos.",
      });

    } // Check se o email não possui @
    else if (!email.includes("@")) {
      return res.status(400).json({ error: "Email inválido. Deve conter @." });

    } else {

       const query = `INSERT INTO organizador (nome, email, senha, telefone) VALUES ('${nome}', '${email}', '${senha}', '${telefone}')`

       //executando a query  criada
      try {
        connect.query(query, function(err, results){
          if (err){

            console.log(err)
            console.log(err.code)

            if (err.code === 'ER_DUP_ENTRY'){
              return res.status(400).json({error: "O E-mail já está vinculado a outro usuário"})
            } else {
              return res.status(500).json({error: "Erro interno no servidor"})
            }

          } else {
            return res.status(201).json({message:"Organizador criado com sucesso"})
          }

        })
      } catch (error) {
        console.error(error)
        res.status(500).json({error:"Erro interno do servidor"})
      }
    }
    
  }

  static async getAllOrg(req, res) {
    const query = 'SELECT * FROM organizador'

    try {
      connect.query(query, function(err, results){
        if(err) {
          console.error(err)
          return res.status(500).json({message: "Erro interno no servidor"})
        }
        return res.status(200).json({message: "Lista de organizadores: ", organizadores: results})
      })
    } catch(error) {
      console.error("Erro ao executar consulta: ", error)
      return res.status(500).json({error: "Erro interno do servidor"})
    }
  }

  static async updateOrg(req, res) {
    //Desestrutura e recupera os dados enviados via corpo da requisição
    const { id, nome, email, senha, telefone } = req.body;

    //Validar se todos os campos foram preenchidos
    if (!id || !nome || !email || !senha || !telefone) {
        return res
          .status(400)
          .json({ error: "Todos os campos devem ser preenchidos." });
    }
  
    const query = `UPDATE organizador SET nome = ?, email = ?, senha = ?, telefone = ? WHERE id_organizador = ?`
    const values = [nome, email, senha, telefone, id]

    try {
      connect.query(query, values ,function(err, results){
        if(err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({error: "Email já cadastrado por outro organizador"})
          } else {
            console.error(err)
            return res.status(500).json({error: "Erro interno no servidor"})
          }
        }

        if (results.affectedRows === 0){
          return res.status(404).json({error: "Organizador não encontrado"})
        }

        return res.status(200).json({message: 'Organizador atualizado com sucesso'})
      })
    } 
    catch(error) {
      console.error("Error ao executar consulta", error)
      return res.status(500).json({message: 'Error interno no servidor'})
    }    
  }

  static async deleteOrg(req, res) {
    const organizadorid = req.params.id
    const query = 'DELETE from organizador WHERE id_organizador = ?'
    const values = [organizadorid]

    try {
      connect.query (query, values, function(err, results){
        if(err) {
          console.error(err)
          return res.status(500).json({error: "Erro interno do servidor"})
        }

        if(results.affectedRows === 0) {
          return res.status(404).json({error: "Organizador não encontrado"})
        }

        return res.status(200).json({message: "Organizador excluido com sucesso"})

      })
    } 
    catch(error) {
        console.error(error)
        return res.status(500).json({error: "Erro interno do servidor"})
    }
  }
    
};
