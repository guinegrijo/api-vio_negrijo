delimiter //

create trigger atualizar_total_ingressos
after insert on ingresso_compra
for each row
begin
    declare v_id_evento int;

    select fk_id_evento into v_id_evento
    from ingresso
    where id_ingresso = NEW.fk_id_ingresso;

    if exists (select 1 from resumo_evento where id_evento = v_id_evento) then
        update resumo_evento
        set total_ingressos = total_ingressos + NEW.quantidade
        where id_evento = v_id_evento;
    else
        insert into resumo_evento (id_evento, total_ingressos)
        values (v_id_evento, NEW.quantidade);
    end if;
end; //

delimiter ;