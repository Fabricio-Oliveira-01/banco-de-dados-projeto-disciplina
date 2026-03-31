DROP TABLE IF EXISTS AVALIACAO, VENDA, ITEM, MODELO, CLIENTE, LUCRO_MODELOS;

-- Questão 1 (Aula 05/06): Esquema com restrições lógicas
CREATE TABLE MODELO(
  ID_modelo INT PRIMARY KEY,
  Nome_modelo VARCHAR(100) UNIQUE NOT NULL,
  Descricao_modelo TEXT
);

CREATE TABLE ITEM(
  Numero_serie INT PRIMARY KEY,
  Valor_aquisicao DECIMAL(7,2) NOT NULL CHECK (Valor_aquisicao > 0),
  ID_modelo INT NOT NULL,
  FOREIGN KEY(ID_modelo) REFERENCES MODELO(ID_modelo) ON UPDATE CASCADE
);

CREATE TABLE CLIENTE(
  CPF CHAR(11) PRIMARY KEY,
  Nome_cliente VARCHAR(50) NOT NULL,
  Data_nascimento DATE,
  Genero VARCHAR(20)
);

CREATE TABLE VENDA(
  Item_vendido INT PRIMARY KEY,
  CPF_cliente CHAR(11) NOT NULL,
  Data_venda DATE NOT NULL,
  Hora_venda TIME NOT NULL,
  Valor_venda DECIMAL(7,2) NOT NULL,
  FOREIGN KEY(Item_vendido) REFERENCES ITEM(Numero_serie),
  FOREIGN KEY(CPF_cliente) REFERENCES CLIENTE(CPF)
);

-- Questão 2 (Aula 06): Avaliações
CREATE TABLE AVALIACAO(
  CPF_cliente CHAR(11),
  ID_modelo INT,
  Nota_avaliacao INT NOT NULL CHECK(Nota_avaliacao BETWEEN 0 AND 5),
  PRIMARY KEY(CPF_cliente, ID_modelo),
  FOREIGN KEY(ID_modelo) REFERENCES MODELO(ID_modelo),
  FOREIGN KEY(CPF_cliente) REFERENCES CLIENTE(CPF)
);

-- Inserts de Exemplo (Aula 06)
INSERT INTO MODELO VALUES (1, 'Painel Solar 550W', 'Alta eficiência'), (2, 'Inversor 5kW', 'Monofásico'), (3, 'Estrutura Solo', 'Suporte Alumínio');
INSERT INTO ITEM VALUES (1001, 800.00, 1), (1002, 800.00, 1), (2001, 4000.00, 2), (3001, 1000.00, 3);
INSERT INTO CLIENTE VALUES ('11122233344', 'Fabricio Oliveira', '1995-05-20', 'M'), ('55566677788', 'Fabio Macelo', '1988-10-12', 'M');
INSERT INTO VENDA VALUES (1001, '11122233344', '2026-03-30', '14:00:00', 1200.00), (2001, '55566677788', '2026-03-30', '15:00:00', 5500.00);
INSERT INTO AVALIACAO VALUES ('11122233344', 1, 5), ('55566677788', 1, 4), ('11122233344', 2, 5), ('55566677788', 2, 3);

-- Questão 3 (Aula 07): View Materializada (Tabela de Lucro)
CREATE TABLE LUCRO_MODELOS AS
SELECT 
    M.Nome_modelo,
    IFNULL(SUM(V.Valor_venda - I.Valor_aquisicao), 0) AS lucro_acumulado
FROM MODELO M 
LEFT JOIN ITEM I ON M.ID_modelo = I.ID_modelo
LEFT JOIN VENDA V ON I.Numero_serie = V.Item_vendido
GROUP BY M.Nome_modelo
ORDER BY lucro_acumulado DESC;

-- Questão 4 (Aula 08): Trigger de Proteção Funcao
DELIMITER $$

CREATE TRIGGER trg_valida_margem_venda
BEFORE INSERT ON VENDA
FOR EACH ROW
BEGIN
    DECLARE v_custo_item DECIMAL(7,2);

    -- Busca o valor de aquisição do item que está sendo vendido
    SELECT Valor_aquisicao INTO v_custo_item
    FROM ITEM
    WHERE Numero_serie = NEW.Item_vendido;

    -- Verifica se o valor de venda é menor que custo + 30%
    IF NEW.Valor_venda < (v_custo_item * 1.30) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Erro: O valor de venda deve ser pelo menos 30% maior que o custo.';
    END IF;
END$$

DELIMITER ;


-- Questao 03: Ordenar 
-- SELECT * FROM LUCRO_MODELOS;

-- Questao 04: Tá falhando, de acordo com os testes
-- INSERT INTO VENDA (Item_vendido, CPF_cliente, Data_venda, Hora_venda, Valor_venda) 
-- VALUES (1002, '11122233344', '2026-03-30', '16:00:00', 900.00);

SELECT AVG(Nota_avaliacao) AS Media_avaliacao
FROM AVALIACAO
GROUP BY ID_modelo;