const connect = require("../db/connect");

module.exports = class ingressoController {
    static async createIngresso(req, res) {
        const { preco, tipo, fk_id_evento } = req.body;
    
        // Validação
        if (!preco || !tipo || !fk_id_evento) {
          return res
            .status(400)
            .json({ error: "Todos os campos devem ser preenchidos!" });
        }
    
        const query = `INSERT INTO ingresso (preco, tipo, fk_id_evento) VALUES (?, ?, ?)`;
        const values = [preco, tipo, fk_id_evento];
    
        try {
          connect.query(query, values, (err) => {
            if (err) {
              console.log(err);
              return res.status(500).json({ error: "Erro ao criar ingresso" });
            }
            return res.status(201).json({ message: "Ingresso criado com sucesso!" });
          });
        } catch (error) {
          console.error(error);
          return res.status(500).json({ error: "Erro ao criar o ingresso" });
        }
    }



    static async getAllIngresso(req, res) {
        const query = `SELECT * FROM ingresso`;
    
        try {
          connect.query(query, (err, results) => {
            if (err) {
              console.log(err);
              return res.status(500).json({ error: "Erro ao buscar ingresso" });
            }
            return res
              .status(200)
              .json({ message: "Ingressos listados com sucesso", events: results });
          });
        } catch (error) {
          console.log("Error ao executar a consulta");
          return res.status(500).json({ error: "Erro interno do servidor" });
        }
    }

    static async updateIngresso(req, res) {
        //Desestrutura e recupera os dados enviados via corpo da requisição
        const { id, preco, tipo, fk_id_evento } = req.body;
    
        //Validar se todos os campos foram preenchidos
        if (!id || !preco || !tipo || !fk_id_evento) {
            return res
              .status(400)
              .json({ error: "Todos os campos devem ser preenchidos." });
        }
      
        const query = `UPDATE ingresso SET preco = ?, tipo = ?, fk_id_evento = ? WHERE id_ingresso = ?`
        const values = [preco, tipo, fk_id_evento, id]
    
        try {
            connect.query(query, values, (err,results) => {
              if (err) {
                console.log(err);
                return res.status(500).json({ error: "Erro ao atualizar ingresso" });
              }
              if (results.affectedRows === 0) {
                return res.status(404).json({error: "ingresso não encontrado"})
              }
              return res.status(200).json({ message: "ingresso atualizado com sucesso!" });
            })
        } catch (error) {
            console.error(error);
            return res.status(500).json({ error: "Erro ao criar o ingresso" });
        }
    }

    static async deleteIngresso(req, res) {
        const idIngresso = req.params.id
        const query = 'DELETE from ingresso WHERE id_ingresso = ?'
        const values = [idIngresso]

        try {
            connect.query (query, values, function(err, results){
            if(err) {
                console.error(err)
                return res.status(500).json({error: "Erro interno do servidor"})
            }

            if(results.affectedRows === 0) {
                return res.status(404).json({error: "Ingresso não encontrado"})
            }
            return res.status(200).json({message: "Ingresso excluido com sucesso"})

            })
        } catch(error) {
            console.error(error)
            return res.status(500).json({error: "Erro interno do servidor"})
        }
    }
}
