delimiter //

create trigger impedir_alteracao_cpf
before update on usuario
for each row
begin
    if old.cpf <> new.cpf then
        signal sqlstate '45000'
        set message_text = 'não é permitido alterar o cpf de um usuário já cadastrado';
    end if;
end //

delimiter ;
