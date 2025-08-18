CREATE DATABASE IF NOT EXISTS `vio_negrijo` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `vio_negrijo`;

DROP TABLE IF EXISTS `presenca`;
DROP TABLE IF EXISTS `ingresso_compra`;
DROP TABLE IF EXISTS `ingresso`;
DROP TABLE IF EXISTS `compra`;
DROP TABLE IF EXISTS `evento`;
DROP TABLE IF EXISTS `resumo_evento`;
DROP TABLE IF EXISTS `historico_compra`;
DROP TABLE IF EXISTS `organizador`;
DROP TABLE IF EXISTS `usuario`;
DROP VIEW IF EXISTS `compras_por_usuario`;

CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `cpf` char(11) NOT NULL,
  `data_nascimento` date NOT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `usuario` VALUES
(1,'João Silva','joao.silva@example.com','$2b$10$MBxqcvhFahRYGrw.sPyV3./3VtWippf6CO0cKuRspOOFUS5Yi/hJ6','16123456789','1990-01-15'),
(2,'Carlos Pereira','carlos.pereira@example.com','$2b$10$BBproq9kX2sKwS6OmS1aPuk2IycMBAsM8pEAHhJiIifD5oYHHSLLK','16123987456','1992-11-30');

CREATE TABLE `organizador` (
  `id_organizador` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(50) NOT NULL,
  `telefone` char(11) NOT NULL,
  PRIMARY KEY (`id_organizador`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `organizador` VALUES
(1,'Organização ABC','contato@abc.com','senha123','11111222333'),
(2,'Eventos XYZ','info@xyz.com','senha123','11222333444'),
(3,'Festivais BR','contato@festbr.com','senha123','11333444555'),
(4,'Eventos GL','support@gl.com','senha123','11444555666'),
(5,'Eventos JQ','contact@jq.com','senha123','11555666777');

CREATE TABLE `evento` (
  `id_evento` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `data_hora` datetime NOT NULL,
  `local` varchar(255) NOT NULL,
  `fk_id_organizador` int NOT NULL,
  `imagem` LONGBLOB,
  `tipo_imagem` varchar(100),
  PRIMARY KEY (`id_evento`),
  KEY `fk_id_organizador` (`fk_id_organizador`),
  CONSTRAINT `evento_ibfk_1` FOREIGN KEY (`fk_id_organizador`) REFERENCES `organizador` (`id_organizador`)
) ENGINE=InnoDB AUTO_INCREMENT=3002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `evento` VALUES
(1,'Festival de Verão','evento de verao','2024-12-15 00:00:00','Praia Central',1,NULL,NULL),
(2,'Congresso de Tecnologia','Evento de tecnologia','2024-11-20 00:00:00','Centro de convencoes',2,NULL,NULL),
(3,'Show Internacional','Evento internacional','2024-10-30 00:00:00','Arena Principal',3,NULL,NULL),
(4,'Feira Cultural de Inverno','Evento cultural com música e gastronomia.','2025-07-20 18:00:00','Parque Municipal',1,NULL,NULL),
(5,'a','a','2025-10-10 00:00:00','a',3,NULL,NULL),
(3001,'Show de teste','teste teste','2025-05-31 15:23:57','franca',1,NULL,NULL);

CREATE TABLE `compra` (
  `id_compra` int NOT NULL AUTO_INCREMENT,
  `data_compra` datetime NOT NULL,
  `fk_id_usuario` int NOT NULL,
  PRIMARY KEY (`id_compra`),
  KEY `fk_id_usuario` (`fk_id_usuario`),
  CONSTRAINT `compra_ibfk_1` FOREIGN KEY (`fk_id_usuario`) REFERENCES `usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `compra` VALUES
(1,'2024-11-14 19:04:00',1),(2,'2024-11-13 17:00:00',1),(3,'2024-11-12 15:30:00',2),(4,'2024-11-11 14:20:00',2),
(5,'2025-05-12 10:53:38',3),(6,'2025-05-12 13:25:51',7),(7,'2025-05-26 10:50:50',1),(8,'2025-05-26 10:50:52',1),
(9,'2025-05-26 10:57:23',1),(10,'2025-05-26 10:57:33',2),(11,'2025-06-02 08:51:00',1),(12,'2025-06-02 11:14:07',1),
(13,'2025-06-02 11:15:21',1),(14,'2025-06-02 11:17:43',1),(15,'2025-06-02 11:25:05',1),
(16,'2025-06-02 11:25:07',1),(17,'2025-06-02 11:25:16',1),(18,'2025-06-02 11:25:21',1);

CREATE TABLE `ingresso` (
  `id_ingresso` int NOT NULL AUTO_INCREMENT,
  `preco` decimal(5,2) NOT NULL,
  `tipo` varchar(10) NOT NULL,
  `fk_id_evento` int NOT NULL,
  PRIMARY KEY (`id_ingresso`),
  KEY `fk_id_evento` (`fk_id_evento`),
  CONSTRAINT `ingresso_ibfk_1` FOREIGN KEY (`fk_id_evento`) REFERENCES `evento` (`id_evento`)
) ENGINE=InnoDB AUTO_INCREMENT=4002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `ingresso` VALUES
(1,550.00,'vip',1),(2,165.00,'pista',1),(3,220.00,'pista',2),(4,660.00,'vip',3),
(5,275.00,'pista',3),(6,132.00,'vip',4),(7,66.00,'pista',4),(8,110.00,'vip',5),(4001,110.00,'pista',3001);

CREATE TABLE `ingresso_compra` (
  `id_ingresso_compra` int NOT NULL AUTO_INCREMENT,
  `quantidade` int NOT NULL,
  `fk_id_ingresso` int NOT NULL,
  `fk_id_compra` int NOT NULL,
  PRIMARY KEY (`id_ingresso_compra`),
  KEY `fk_id_ingresso` (`fk_id_ingresso`),
  KEY `fk_id_compra` (`fk_id_compra`),
  CONSTRAINT `ingresso_compra_ibfk_1` FOREIGN KEY (`fk_id_ingresso`) REFERENCES `ingresso` (`id_ingresso`),
  CONSTRAINT `ingresso_compra_ibfk_2` FOREIGN KEY (`fk_id_compra`) REFERENCES `compra` (`id_compra`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `ingresso_compra` VALUES
(1,5,4,1),(2,2,5,1),(3,1,1,2),(4,2,2,2),(5,5,2,5),(6,10,7,6),(7,10,7,6),(8,10,7,6),
(9,10,6,5),(10,30,7,6),(11,30,7,5),(12,3,8,5),(13,10,7,7),(14,10,7,8),(15,50,6,9),
(16,50,8,10),(17,3,6,11),(18,10,6,14),(19,2,7,14),(20,10,6,15),(21,2,7,15),
(22,10,6,16),(23,2,7,16),(24,10,6,17),(25,10,6,18),(26,2,7,18);

CREATE TABLE `historico_compra` (
  `id_historioco` int NOT NULL AUTO_INCREMENT,
  `id_compra` int NOT NULL,
  `data_compra` datetime NOT NULL,
  `id_usuario` int NOT NULL,
  `data_exclusao` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historioco`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `historico_compra` VALUES
(1,1,'2024-11-14 19:04:00',1,'2025-05-28 14:22:04'),
(2,2,'2024-11-13 17:00:00',1,'2025-05-28 14:22:04'),
(3,3,'2024-11-12 15:30:00',2,'2025-05-28 14:22:04'),
(4,4,'2024-11-11 14:20:00',2,'2025-05-28 14:22:04');

CREATE TABLE `presenca` (
  `id_presenca` int NOT NULL AUTO_INCREMENT,
  `data_hora_checkin` datetime DEFAULT NULL,
  `fk_id_evento` int NOT NULL,
  `fk_id_compra` int NOT NULL,
  PRIMARY KEY (`id_presenca`),
  KEY `fk_id_evento` (`fk_id_evento`),
  KEY `fk_id_compra` (`fk_id_compra`),
  CONSTRAINT `presenca_ibfk_1` FOREIGN KEY (`fk_id_evento`) REFERENCES `evento` (`id_evento`),
  CONSTRAINT `presenca_ibfk_2` FOREIGN KEY (`fk_id_compra`) REFERENCES `compra` (`id_compra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `resumo_evento` (
  `id_evento` int NOT NULL,
  `total_ingressos` int DEFAULT NULL,
  PRIMARY KEY (`id_evento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `resumo_evento` VALUES (4,191),(5,53);

DELIMITER ;;
CREATE TRIGGER `delete_compra` AFTER DELETE ON `compra` FOR EACH ROW
BEGIN
    INSERT INTO historico_compra (id_compra, data_compra, id_usuario)
    VALUES (OLD.id_compra, OLD.data_compra, OLD.fk_id_usuario);
END;;
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `impedir_alteracao_evento_passado` BEFORE UPDATE ON `evento` FOR EACH ROW
BEGIN
    IF OLD.data_hora < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é permitido alterar eventos que já ocorreram.';
    END IF;
END;;
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `verifica_data_evento` BEFORE INSERT ON `ingresso_compra` FOR EACH ROW
BEGIN
    DECLARE data_evento datetime;
    SELECT e.data_hora INTO data_evento
    FROM ingresso i
    JOIN evento e ON i.fk_id_evento = e.id_evento
    WHERE i.id_ingresso = NEW.fk_id_ingresso;
    IF DATE(data_evento) < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não é possível comprar ingresso para eventos passados';
    END IF;
END;;
DELIMITER ;

DELIMITER ;;
CREATE TRIGGER `atualizar_total_ingressos` AFTER INSERT ON `ingresso_compra` FOR EACH ROW
BEGIN
    DECLARE v_id_evento INT;
    SELECT fk_id_evento INTO v_id_evento
    FROM ingresso
    WHERE id_ingresso = NEW.fk_id_ingresso;

    IF EXISTS (SELECT 1 FROM resumo_evento WHERE id_evento = v_id_evento) THEN
        UPDATE resumo_evento
        SET total_ingressos = total_ingressos + NEW.quantidade
        WHERE id_evento = v_id_evento;
    ELSE
        INSERT INTO resumo_evento (id_evento, total_ingressos)
        VALUES (v_id_evento, NEW.quantidade);
    END IF;
END;;
DELIMITER ;

DROP EVENT IF EXISTS `arquivar_compras_antigas`;
CREATE EVENT `arquivar_compras_antigas`
ON SCHEDULE EVERY 1 DAY STARTS '2025-05-29 14:22:48'
ON COMPLETION PRESERVE ENABLE
DO
INSERT INTO historico_compra (id_compra, data_compra, id_usuario)
SELECT id_compra, data_compra, fk_id_usuario
FROM compra
WHERE data_compra < NOW() - INTERVAL 6 MONTH;

DROP EVENT IF EXISTS `excluir_eventos_antigos`;
CREATE EVENT `excluir_eventos_antigos`
ON SCHEDULE EVERY 1 WEEK STARTS '2025-05-28 14:39:38'
ON COMPLETION PRESERVE ENABLE
DO
DELETE FROM evento
WHERE data_hora < NOW() - INTERVAL 1 YEAR;

DROP EVENT IF EXISTS `reajuste_precos_eventos_proximos`;
CREATE EVENT `reajuste_precos_eventos_proximos`
ON SCHEDULE EVERY 1 DAY STARTS '2025-05-28 15:28:56'
ON COMPLETION PRESERVE ENABLE
DO
UPDATE ingresso
SET preco = preco * 1.10
WHERE fk_id_evento IN (
    SELECT id_evento FROM evento
    WHERE data_hora BETWEEN NOW() AND NOW() + INTERVAL 7 DAY
);

DELIMITER ;;
DROP PROCEDURE IF EXISTS `registrar_compra`;
CREATE PROCEDURE `registrar_compra`(
    IN p_id_usuario INT,
    IN p_id_ingresso INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_id_compra INT;
    DECLARE v_data_evento DATETIME;

    SELECT e.data_hora INTO v_data_evento
    FROM ingresso i
    JOIN evento e ON i.fk_id_evento = e.id_evento
    WHERE i.id_ingresso = p_id_ingresso;

    IF DATE(v_data_evento) < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_PROCEDURE - Não é possivel comprar ingressos para eventos passados';
    END IF;

    INSERT INTO compra (data_compra, fk_id_usuario)
    VALUES (NOW(), p_id_usuario);

    SET v_id_compra = LAST_INSERT_ID();

    INSERT INTO ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
    VALUES (v_id_compra, p_id_ingresso, p_quantidade);
END;;
DELIMITER ;

DELIMITER ;;
DROP PROCEDURE IF EXISTS `registrar_compra2`;
CREATE PROCEDURE `registrar_compra2`(
    IN p_id_ingresso INT,
    IN p_id_compra INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_data_evento DATETIME;

    SELECT e.data_hora INTO v_data_evento
    FROM ingresso i
    JOIN evento e ON i.fk_id_evento = e.id_evento
    WHERE i.id_ingresso = p_id_ingresso;

    IF DATE(v_data_evento) < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO_PROCEDURE - Não é possivel comprar ingressos para eventos passados';
    END IF;

    INSERT INTO ingresso_compra (fk_id_compra, fk_id_ingresso, quantidade)
    VALUES (p_id_compra, p_id_ingresso, p_quantidade);
END;;
DELIMITER ;

DELIMITER ;;
DROP PROCEDURE IF EXISTS `registrar_presenca`;
CREATE PROCEDURE `registrar_presenca`(
    IN p_id_compra INT,
    IN p_id_evento INT
)
BEGIN
    INSERT INTO presenca (data_hora_checkin, fk_id_evento, fk_id_compra)
    VALUES (NOW(), p_id_evento, p_id_compra);
END;;
DELIMITER ;

DELIMITER ;;
DROP PROCEDURE IF EXISTS `resumo_evento`;
CREATE PROCEDURE `resumo_evento`(IN id_evento INT)
BEGIN
    DECLARE nome_evento VARCHAR(100);
    DECLARE data_hora_evento DATE;
    DECLARE total_vendido INT;
    DECLARE renda_total DECIMAL(10,2);

    SELECT e.nome, e.data_hora INTO nome_evento, data_hora_evento
    FROM evento e
    WHERE e.id_evento = id_evento;

    SET total_vendido = total_ingressos_vendidos(id_evento);
    SET renda_total = renda_total_evento(id_evento);

    SELECT IFNULL(nome_evento, 'Não tem') AS `nome do evento`,
           IFNULL(CAST(data_hora_evento AS CHAR), 'não tem') AS `data`,
           total_vendido AS `total de ingressos vendidos`,
           renda_total AS `renda total`;
END;;
DELIMITER ;

DELIMITER ;;
DROP PROCEDURE IF EXISTS `resumo_usuario`;
CREATE PROCEDURE `resumo_usuario`(IN pid INT)
BEGIN
    DECLARE nome VARCHAR(100);
    DECLARE email VARCHAR(100);
    DECLARE totalrs DECIMAL(10,2);
    DECLARE faixa VARCHAR(20);

    SELECT u.name, u.email INTO nome, email FROM usuario u
    WHERE u.id_usuario = pid;

    SET totalrs = calcula_total_gasto(pid);
    SET faixa = buscar_faixa_etaria_usuario(pid);

    SELECT nome AS nome_usuario, email AS email_usuario, totalrs AS total_gasto, faixa AS faixa_etaria;
END;;
DELIMITER ;

DELIMITER ;;
DROP PROCEDURE IF EXISTS `total_ingresso_usuario`;
CREATE PROCEDURE `total_ingresso_usuario`(
    IN p_id_usuario INT,
    OUT p_total_ingressos INT
)
BEGIN
    SET p_total_ingressos = 0;

    SELECT COALESCE(SUM(ic.quantidade), 0)
    INTO p_total_ingressos
    FROM ingresso_compra ic
    JOIN compra c ON ic.fk_id_compra = c.id_compra
    WHERE c.fk_id_usuario = p_id_usuario;
END;;
DELIMITER ;

CREATE VIEW `compras_por_usuario` (`usuario`,`evento`,`data_compra`,`tipo_ingresso`,`quantidade_vip`,`preco_total`) AS
SELECT
    u.name AS `Usuario`,
    e.nome AS `Evento`,
    c.data_compra AS `Data_Compra`,
    i.tipo AS `Tipo_Ingresso`,
    SUM(CASE WHEN i.tipo = 'vip' THEN ic.quantidade ELSE 0 END) AS `Quantidade_VIP`,
    ROUND(SUM(ic.quantidade * i.preco), 2) AS `Preco_Total`
FROM usuario u
JOIN compra c ON u.id_usuario = c.fk_id_usuario
JOIN ingresso_compra ic ON c.id_compra = ic.fk_id_compra
JOIN ingresso i ON ic.fk_id_ingresso = i.id_ingresso
JOIN evento e ON i.fk_id_evento = e.id_evento
GROUP BY u.name, e.nome, c.data_compra, i.tipo;

DELIMITER ;;
DROP TRIGGER IF EXISTS `impedir_alteracao_cpf`;
CREATE TRIGGER `impedir_alteracao_cpf` BEFORE UPDATE ON `usuario` FOR EACH ROW
BEGIN
    IF OLD.cpf <> NEW.cpf THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'não é permitido alterar o cpf de um usuário já cadastrado';
    END IF;
END;;
DELIMITER ;
