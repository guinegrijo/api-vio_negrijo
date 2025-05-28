create event if not exists arquivar_compras_antigas
    on schedule every 5 minute
    starts current_timestamp + interval 3 minute
    on completion preserve
    enable
do
    insert into historico_compra(id_compra, data_compra, id_usuario)
    select id_compra, data_compra, fk_id_usuario 
        from id_compra
        where data_compra < now() - interval 6 month;