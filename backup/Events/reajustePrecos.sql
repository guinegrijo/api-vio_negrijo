create event if not exists reajuste_precos_eventos_proximos
    on schedule every 1 day
    starts current_timestamp + interval 2 minute
    on completion preserve
    enable
do
    update ingresso set preco = preco * 1.10
    where fk_id_evento in(
        select fk_id_evento from evento
        where data_hora between now() and now() + interval 7 day
    );