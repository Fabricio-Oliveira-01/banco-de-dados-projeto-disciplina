DROP TABLE IF EXISTS CLIENTE, CORRETOR, SEGURO, SINISTRO, PERITO, BEM, AUTOMOVEL, IMOVEL, TELEFONES_CLIENTE, AVALIACAO_SINISTRO, ADQUIRE;

CREATE TABLE CLIENTE(
cpf_cliente CHAR(11),
nome_cliente VARCHAR(30) NOT NULL,
endereco_cliente VARCHAR(50),

PRIMARY KEY (cpf_cliente)
);


CREATE TABLE CORRETOR(
cpf_corretor CHAR(11) UNIQUE NOT NULL,
n_SUSEP CHAR(17),
nome_corretor VARCHAR(30) NOT NULL,

PRIMARY KEY (n_SUSEP)
);


CREATE TABLE PERITO(
cpf_perito CHAR(11),
nome_perito VARCHAR(20) NOT NULL,
especialita VARCHAR(30),

PRIMARY KEY(cpf_perito)
);


CREATE TABLE BEM(
codigo_bem VARCHAR(20),
valor_bem REAL NOT NULL,

PRIMARY KEY(codigo_bem)
);


CREATE TABLE SEGURO(
n_apolice VARCHAR(30),
periodo_cobertura VARCHAR(3) NOT NULL,
data_inicio DATE NOT NULL,
franquia VARCHAR(40) NOT NULL,

codigo_bem VARCHAR(20),

FOREIGN KEY (codigo_bem) REFERENCES BEM(codigo_bem),
PRIMARY KEY (n_apolice)
);


CREATE TABLE SINISTRO(
descricao_sinistro TEXT NOT NULL,
n_sinistro VARCHAR(20),
valor_sinistro REAL NOT NULL,

n_apolice VARCHAR(30),

FOREIGN KEY (n_apolice) REFERENCES SEGURO(n_apolice),
PRIMARY KEY (n_apolice, n_sinistro)
);


CREATE TABLE AUTOMOVEL(
modelo VARCHAR(20),

codigo_bem VARCHAR(20),

FOREIGN KEY (codigo_bem) REFERENCES BEM(codigo_bem),
PRIMARY KEY (codigo_bem)
);

CREATE TABLE IMOVEL(
localizacao VARCHAR(50),

codigo_bem VARCHAR(20),

FOREIGN KEY (codigo_bem) REFERENCES BEM(codigo_bem),
PRIMARY KEY (codigo_bem)
);


--Atributo multivalorado de cliente
CREATE TABLE TELEFONES_CLIENTE(
telefone CHAR(11),

cpf_cliente CHAR(11),

FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf_cliente),
PRIMARY KEY (cpf_cliente, telefone)
);


--Relacionamento avalia
CREATE TABLE AVALIACAO_SINISTRO(
observacao TEXT,
data_vistoria DATE NOT NULL,

cpf_perito CHAR(11),
n_apolice VARCHAR(30),
n_sinistro VARCHAR(20),

FOREIGN KEY (cpf_perito) REFERENCES PERITO(cpf_perito),
FOREIGN KEY (n_apolice, n_sinistro) REFERENCES SINISTRO(n_apolice, n_sinistro),
PRIMARY KEY (cpf_perito, n_apolice, n_sinistro)
);


--Relacionamento Adquire 
CREATE TABLE ADQUIRE(
data_assinatura DATE NOT NULL,

cpf_cliente CHAR(11),
n_SUSEP CHAR(17),
n_apolice VARCHAR(30),

FOREIGN KEY (cpf_cliente) REFERENCES CLIENTE(cpf_cliente),
FOREIGN KEY (n_SUSEP) REFERENCES CORRETOR(n_SUSEP),
FOREIGN KEY (n_apolice) REFERENCES SEGURO(n_apolice),
PRIMARY KEY (n_apolice)
);