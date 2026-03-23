DROP TABLE IF EXISTS MODELO, ITEM, CLIENTE, VENDA, AVALIACAO;

-- Create
CREATE TABLE MODELO(
  ID INT PRIMARY KEY,
  Nome VARCHAR(100) UNIQUE NOT NULL,
  Descricao TEXT
  
);

CREATE TABLE ITEM(
  Numero_serie INT PRIMARY KEY,
  Valor_aquisicao NUMERIC(7,2) NOT NULL,
  ID INT NOT NULL,
  
  CHECK(Valor_aquisicao > 0),
  
  FOREIGN KEY(ID) REFERENCES MODELO(ID)
  
);

CREATE TABLE CLIENTE(
  CPF CHAR(11) PRIMARY KEY,
  Nome VARCHAR(50) NOT NULL,
  Nascimento DATE,
  Genero VARCHAR (20)
  
);

CREATE TABLE VENDA(
  Item_vendido INT PRIMARY KEY,
  Cliente CHAR(11) NOT NULL,
  Data DATE NOT NULL,
  Hora TIME NOT NULL,
  Valor_vendido NUMERIC(7,2) NOT NULL,
  
  CHECK(Item_vendido > 0),
    
  FOREIGN KEY(Item_vendido) REFERENCES ITEM(Numero_serie),
  FOREIGN KEY(Cliente) REFERENCES CLIENTE(CPF)
  
);

CREATE TABLE AVALIACAO(
	Verificador INT NOT NULL,
    CPF CHAR(11),
    ID_modelo INT,
    
    PRIMARY KEY(CPF, ID_modelo),
    FOREIGN KEY(ID_modelo) REFERENCES MODELO(ID),
    FOREIGN KEY(CPF) REFERENCES CLIENTE(CPF),
    
    CHECK(Verificador BETWEEN 0 AND 5)
    
);


-- Insert

INSERT INTO MODELO (ID, Nome, Descricao) VALUES
(1, 'Painel Solar 550W Monocristalino', 'Painel de alta eficiência para usinas solares.'),
(2, 'Inversor On-Grid 5kW', 'Inversor monofásico para conexão com a rede da COSERN.'),
(3, 'Estrutura de Solo Alumínio', 'Suporte para fixação de até 4 módulos em solo.');

INSERT INTO ITEM (Numero_serie, Valor_aquisicao, ID) VALUES
(1001, 850.00, 1),
(1002, 850.00, 1),
(1003, 850.00, 1),
(1004, 850.00, 1),
(2001, 4200.00, 2),
(2002, 4200.00, 2),
(3001, 1100.00, 3),
(3002, 1100.00, 3),
(3003, 1100.00, 3),
(3004, 1100.00, 3);

INSERT INTO CLIENTE (CPF, Nome, Nascimento, Genero) VALUES
('11122233344', 'Fabricio Oliveira', '1995-05-20', 'Masculino'),
('55566677788', 'Fabio Macelo', '1988-10-12', 'Feminino'),
('99900011122', 'Danilo', '1975-03-15', 'Masculino'),
('44455566677', 'Carla Mendonça', '1992-08-30', 'Feminino');

INSERT INTO VENDA (Item_vendido, Cliente, Data, Hora, Valor_vendido) VALUES
(1001, '11122233344', '2026-03-10', '14:30:00', 1100.00),
(2001, '55566677788', '2026-03-12', '09:15:00', 5500.00),
(3001, '99900011122', '2026-03-14', '16:45:00', 1600.00),
(1002, '44455566677', '2026-03-15', '11:00:00', 1100.00),
(2002, '11122233344', '2026-03-18', '15:20:00', 5500.00);

INSERT INTO AVALIACAO (Verificador, CPF, ID_modelo) VALUES
(5, '11122233344', 1),
(4, '55566677788', 1),
(5, '99900011122', 1),
(3, '44455566677', 1);

INSERT INTO AVALIACAO (Verificador, CPF, ID_modelo) VALUES
(5, '11122233344', 2),
(5, '55566677788', 2),
(2, '99900011122', 2),
(4, '44455566677', 2);

INSERT INTO AVALIACAO (Verificador, CPF, ID_modelo) VALUES
(4, '11122233344', 3),
(4, '55566677788', 3),
(3, '99900011122', 3),
(5, '44455566677', 3);

-- Exibir