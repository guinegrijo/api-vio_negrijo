const connect = require("../db/connect")

module.exports = class compraController {
    static async registrarCompraSimples(req,res) {
        const {id_usuario, id_ingresso, quantidade} = req.body
        
        console.log("Body: ", id_usuario, id_ingresso, quantidade)

        if(!id_usuario || !id_ingresso || !quantidade) {
            return res.status(400).json({error: "Dados obrigatórios não enviados!"})
        }

        connect.query("call registrar_compra(?,?,?);", [id_usuario, id_ingresso, quantidade], (err,result) => {
            if (err) {
                console.log('Erro ao registar compra: ', err.message)
                return res.status(500).json({error: err.message})
            }

            return res.status(201).json({
                message:"Compra registrada com sucesso via procedure!", dados: {id_usuario, id_ingresso, quantidade}
            })
        })
    }

    static async registrarCompra(req,res) {
        const {id_usuario, ingressos } = req.body

        console.log("Body: ", id_usuario, ingressos)

        if(!id_usuario || !ingressos) {
            return res.status(400).json({error: "Dados obrigatórios não enviados!"})
        }

        connect.query("insert into compra(data_compra, fk_id_usuario) values (now(), ?)", [id_usuario], (err, result) =>{
            if(err) {
                console.log("Erro ao inserir compra", err)
                return res.status(500).json({error: "Erro ao cirar a compra no sistema!"})
            }

            // recupera o id compra recém criada
            const id_compra = result.insertId
            console.log("compra criada com o id: ", id_compra)

            let index = 0

            function processarIngressos(){
                if(index >= ingressos.length){
                    return res.status(201).json({
                        message: "Compra com realizada com suecsso!",
                        id_compra,
                        ingressos
                    })
                }

                const ingresso = ingressos [index]

                connect.query("call registrar_compra2 (?, ?, ?) ", [ingresso.id_ingresso, id_compra, ingresso.quantidade], (err, result) => {
                    if(err) {
                        return res.status(500).json({error: `Erro ao registrar ingresso ${index + 1}`, detalhes: err.message})
                    }

                    index++
                    processarIngressos()
                })
            }

            processarIngressos()

        })
    }
}