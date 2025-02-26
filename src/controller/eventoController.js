const connect = require("../db/connect");

module.exports = class eventoController {
  static async createEvento(req, res) {
    const { nome, descricao, data_hora, local, fk_id_organizador } = req.body;

    // Validação
    if (!nome || !descricao || !data_hora || !local || !fk_id_organizador) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos!" });
    }

    const query = `INSERT INTO evento (nome, descricao, data_hora, local, fk_id_organizador) VALUES (?, ?, ?, ?, ?)`;
    const values = [nome, descricao, data_hora, local, fk_id_organizador];

    try {
      connect.query(query, values, (err) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao criar evento" });
        }
        return res.status(201).json({ message: "Evento criado com sucesso!" });
      });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: "Erro ao criar o evento" });
    }
  }

  static async getAllEventos(req, res) {
    const query = `SELECT * FROM evento`;

    try {
      connect.query(query, (err, results) => {
        if (err) {
          console.log(err);
          return res.status(500).json({ error: "Erro ao buscar evento" });
        }
        return res
          .status(200)
          .json({ message: "Evento listados com sucesso", events: results });
      });
    } catch (error) {
      console.log("Error ao executar a consulta");
      return res.status(500).json({ error: "Erro interno do servidor" });
    }
  }

  static async updateEvento(req, res) {
    const { id_evento, nome, descricao, data_hora, local, fk_id_organizador } =
      req.body;

    // Validação
    if (
      !id_evento ||
      !nome ||
      !descricao ||
      !data_hora ||
      !local ||
      !fk_id_organizador
    ) {
      return res
        .status(400)
        .json({ error: "Todos os campos devem ser preenchidos!" });
    }

    const query = `UPDATE evento SET nome = ?, descricao = ?, data_hora = ?, local = ?, fk_id_organizador = ? WHERE id_evento = ?`;
    const values = [
      nome,
      descricao,
      data_hora,
      local,
      fk_id_organizador,
      id_evento,
    ];

    try {
        connect.query(query, values, (err,results) => {
          if (err) {
            console.log(err);
            return res.status(500).json({ error: "Erro ao atualizar evento" });
          }
          if (results.affectedRows === 0) {
            return res.status(404).json({error: "Evento não encontrado"})
          }
          return res.status(200).json({ message: "Evento atualizado com sucesso!" });
        })
      } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Erro ao criar o evento" });
      }
  }

    static async deleteEvento(req, res) {
        const idEvento = req.params.id
        const query = 'DELETE from evento WHERE id_evento = ?'
        const values = [idEvento]

        try {
        connect.query (query, values, function(err, results){
            if(err) {
            console.error(err)
            return res.status(500).json({error: "Erro interno do servidor"})
            }

            if(results.affectedRows === 0) {
            return res.status(404).json({error: "Evento não encontrado"})
            }

            return res.status(200).json({message: "Evento excluido com sucesso"})

        })
        } 
        catch(error) {
            console.error(error)
            return res.status(500).json({error: "Erro interno do servidor"})
        }
    }

    static async getEventosPorData(req, res) {
      const query = `SELECT * FROM evento`

      try {
        connect.query(query, (err,results)=>{
          if(err){
            console.error(err)
            return res.status(500).json({error: "Erro ao buscar eventos"})
          }

          const datasEvento = new Date(results[0].data_hora)
          const dia = datasEvento.getDate()
          const mes = datasEvento.getMonth()
          const ano = datasEvento.getFullYear()
          console.log(`${dia}/ ${mes}/ ${ano}`)

          const now = new Date()
          const eventosPassados = results.filter(evento => new Date(evento.data_hora) < now)
          const eventosFuturos = results.filter(evento => new Date(evento.data_hora) >= now)
        

          const diferencaMs = eventosFuturos[0].data_hora.getTime() - now.getTime()
          const dias = Math.floor( diferencaMs / (1000 * 60 * 60 * 24) )
          const horas = Math.floor( diferencaMs % (1000 * 60 * 60 * 24)/(1000 * 60 * 60))
          console.log(diferencaMs, `Falta ${dias} dias e ${horas} horas`)

          const dataFiltro = new Date('2024-12-15').toISOString().split('T')
          const eventosDias = results.filter(evento => new Date(evento.data_hora).toISOString().split("T")[0] === dataFiltro[0])

          console.log("Eventos: ", eventosDias)

          return res.status(200).json({message: "OK", eventosPassados, eventosFuturos})
        })
        
      } catch(error){
        console.error(error)
        return res.status(500).json({error: "Erro ao buscar eventos"})
      }

    }

    static async EventosSemana(req, res) {
      const { data } = req.params // 2024-10-01    
  
      const dataInicio = new Date(data)
      const dataFim = new Date(dataInicio)
      dataFim.setDate(dataFim.getDate() + 6) // Adicionando 6 dias para os próximos 6 dias
    
      const query = "SELECT * FROM evento"
    
      try {
        connect.query(query, (err, results) => {
          if (err) {
            console.error(err)
            return res.status(500).json({ error: "Erro ao buscar eventos" })
          }
    
          const eventosSemana = results.filter((evento) => {
            const datasEventos = new Date(evento.data_hora) // pega todas as datas do banco
            return datasEventos >= dataInicio && datasEventos <= dataFim  // seja entre dataInicio e dataFim
          })
    
          return res.status(200).json({
            message: "Eventos encontrados",
            dataInicio: dataInicio.toISOString().split("T")[0],
            dataFim: dataFim.toISOString().split("T")[0],
            eventos: eventosSemana,
          })

        })
      } catch (error) {
        console.error(error);
        return res.status(500).json({ error: "Erro ao buscar eventos" })
      }
    }
    
}
