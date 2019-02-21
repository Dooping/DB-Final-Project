----------------------------------------------------
---------------------- Grupo12 ---------------------
-----------------David Gago nr 41710----------------
----------------Joao Almeida nr 42009---------------
---------------Olena Bernatska nr 41692-------------
----------------------------------------------------

----------------------------------------------------
---------------------- Tabelas ---------------------
----------------------------------------------------

drop table Pessoa cascade constraints;
create table Pessoa(
    numBI varchar2(8) not null,
    nome varchar2(50) not null,
	data_nsc timestamp not null,
    morada varchar2(50) not null,
    sexo char(1) not null check ( sexo in ( 'F' , 'M' ) ),
	email varchar2(50) not null,
	telefone varchar(15) not null,
    primary key (numBI)
);

drop table Cliente cascade constraints;
create table Cliente(
	numBI varchar2(8) not null,
	numSocio number(8) not null,
	primary key (numSocio),
	foreign key (numBI) references Pessoa(numBI)
);

drop table Cargo cascade constraints;
create table Cargo(
	nomeCargo varchar2(50) not null,
	salario number(8) not null,
	primary key (nomeCargo)
);

drop table Funcionario cascade constraints;
create table Funcionario(
	numBI varchar2(8) not null,
	numFuncionario number(8) not null,
	nomeCargo varchar2(50) not null,
	primary key (numFuncionario),
	foreign key (numBI) references Pessoa(numBI),
	foreign key (nomeCargo) references Cargo(nomeCargo)
);

drop table Filme cascade constraints;
create table Filme(
	codFilme number(8) not null,
	titulo varchar2(50) not null,
	dataLancamento timestamp not null,
	duracao number(4) not null,
	primary key (codFilme)
);

drop table Genero cascade constraints;
create table Genero(
	idGenero number(8) not null,
	nomeGenero varchar2(50) not null,
	primary key (idGenero),
	unique (nomeGenero)
);

drop table Caracterizado cascade constraints;
create table Caracterizado(
	codFilme number(8) not null,
	idGenero number(8) not null,
	primary key (codFilme, idGenero),
	foreign key (idGenero) references Genero(idGenero),
	foreign key (codFilme) references Filme(codFilme)
);

drop table Actor_Realizador cascade constraints;
create table Actor_Realizador(
	ID number (10) not null,
	nome varchar2(50) not null,
	nacionalidade varchar2(50) not null,
	primary key(ID)
);

drop table Realizado cascade constraints;
create table Realizado(
	codFilme number(8) not null,
	ID number (10) not null,
	primary key(codFilme, ID),
	foreign key(codFilme) references Filme(codFilme),
	foreign key(ID) references Actor_Realizador(ID)
);

drop table Protagonizado cascade constraints;
create table Protagonizado(
	codFilme number(8) not null,
	ID number (10) not null,
	primary key(codFilme, ID),
	foreign key(codFilme) references Filme(codFilme),
	foreign key(ID) references Actor_Realizador(ID)
);

drop table Copia cascade constraints;
create table Copia(
	numCopia number(10) not null,
	codFilme number(8) not null,
	primary key (numCopia,codFilme),
	foreign key (codFilme) references Filme(codFilme)
);

drop table Aluguer cascade constraints;
create table Aluguer(
	numAluguer number(10) not null,
	dataAluguer timestamp not null,
	numCopia number(10) not null,
	codFilme number(8) not null,
	dataDev timestamp,
	numSocio number(8) not null,
	dataDevPrevista timestamp not null,
	numFuncionario number(8) not null,
	primary key(numAluguer),
	foreign key (numCopia,codFilme) references Copia(numCopia,codFilme),
	foreign key (numSocio) references Cliente(numSocio),
	foreign key (numFuncionario) references Funcionario(numFuncionario)
);

----------------------------------------------------
-------------------- Sequencias --------------------
----------------------------------------------------

drop sequence seq_socio;
create sequence seq_socio
start with 1
increment by 1;

drop sequence seq_funcionario;
create sequence seq_funcionario
start with 1
increment by 1;

drop sequence seq_aluguer;
create sequence seq_aluguer
start with 1
increment by 1;

drop sequence seq_filme;
create sequence seq_filme
start with 1
increment by 1;

drop sequence seq_actor;
create sequence seq_actor
start with 1
increment by 1;

drop sequence seq_genero;
create sequence seq_genero
start with 1
increment by 1;

----------------------------------------------------
----------------------- Views ----------------------
----------------------------------------------------

create or replace view clientes as(
    select     "PESSOA"."NUMBI" as "NUMBI",
     "PESSOA"."NOME" as "NOME",
     "PESSOA"."DATA_NSC" as "DATA_NSC",
     "PESSOA"."MORADA" as "MORADA",
     "PESSOA"."SEXO" as "SEXO",
     "PESSOA"."EMAIL" as "EMAIL",
     "PESSOA"."TELEFONE" as "TELEFONE"
 from "CLIENTE" "CLIENTE",
     "PESSOA" "PESSOA" 
 where   "PESSOA"."NUMBI"="CLIENTE"."NUMBI"
);

create or replace view funcionarios as(
select     "PESSOA"."NOME" as "NOME",
     "PESSOA"."DATA_NSC" as "DATA_NSC",
     "PESSOA"."MORADA" as "MORADA",
     "PESSOA"."SEXO" as "SEXO",
     "PESSOA"."EMAIL" as "EMAIL",
     "PESSOA"."TELEFONE" as "TELEFONE",
     "FUNCIONARIO"."NOMECARGO" as "NOMECARGO",
     "PESSOA"."NUMBI" as "NUMBI" 
 from     "FUNCIONARIO" "FUNCIONARIO",
     "PESSOA" "PESSOA" 
 where   "PESSOA"."NUMBI"="FUNCIONARIO"."NUMBI"
);


create or replace view generos_filme as (
    select     "FILME"."CODFILME" as "CODFILME",
         "CARACTERIZADO"."IDGENERO" as "IDGENERO" 
     from     "CARACTERIZADO" "CARACTERIZADO",
         "FILME" "FILME" 
     where   "FILME"."CODFILME"="CARACTERIZADO"."CODFILME"
);

create or replace view protagonistas_filme as(
select     "FILME"."CODFILME" as "CODFILME", 
    "PROTAGONIZADO"."ID" as "ID"
 from     "PROTAGONIZADO" "PROTAGONIZADO",
     "FILME" "FILME" 
 where   "FILME"."CODFILME"="PROTAGONIZADO"."CODFILME"
);

create or replace view realizadores_filme as(
select     "FILME"."CODFILME" as "CODFILME" ,
    "REALIZADO"."ID" as "ID"
 from     "REALIZADO" "REALIZADO",
     "FILME" "FILME" 
 where   "FILME"."CODFILME"="REALIZADO"."CODFILME"
);

create or replace view copias_livres as(
    select "COPIA"."NUMCOPIA" as "NUMCOPIA",
         "COPIA"."CODFILME" as "CODFILME"
    from "COPIA" "COPIA"
    where ("NUMCOPIA","CODFILME") not in
        (select     "ALUGUER"."NUMCOPIA" as "NUMCOPIA",
             "ALUGUER"."CODFILME" as "CODFILME" 
         from     "ALUGUER" "ALUGUER" 
         where      "ALUGUER"."DATADEV" is null)
);

create or replace view generos_filme_master as (
    select    "CARACTERIZADO".rowid as "rowid", 
		"FILME"."CODFILME" as "CODFILME",
         "CARACTERIZADO"."IDGENERO" as "IDGENERO" 
     from     "CARACTERIZADO" "CARACTERIZADO",
         "FILME" "FILME" 
     where   "FILME"."CODFILME"="CARACTERIZADO"."CODFILME"
);

create or replace view protagonistas_filme_master as(
select     "PROTAGONIZADO".rowid as "rowid",
"FILME"."CODFILME" as "CODFILME", 
    "PROTAGONIZADO"."ID" as "ID"
 from     "PROTAGONIZADO" "PROTAGONIZADO",
     "FILME" "FILME" 
 where   "FILME"."CODFILME"="PROTAGONIZADO"."CODFILME"
);

create or replace view realizadores_filme_master as(
select    "REALIZADO".rowid as "rowid" ,
"FILME"."CODFILME" as "CODFILME" ,
    "REALIZADO"."ID" as "ID"
 from     "REALIZADO" "REALIZADO",
     "FILME" "FILME" 
 where   "FILME"."CODFILME"="REALIZADO"."CODFILME"
);

----------------------------------------------------
--------------------- Triggers ---------------------
----------------------------------------------------

-- Manipulacao do cliente
create or replace trigger add_cliente
  instead of insert on clientes
  for each row
  declare
    x number;
  begin
    select count(*) into x from pessoa where :new.numBI = numBI;
    if x=0 then
      insert into pessoa values (:new.numBI, :new.nome, :new.data_nsc, :new.morada, :new.sexo, :new.email, :new.telefone);
		end if;
  insert into cliente values (:new.numBI, seq_socio.nextval);
  end;
/

create or replace trigger del_cliente
  instead of delete on clientes
  for each row
  declare x number;
  begin
    SELECT COUNT(*) INTO x FROM funcionario where numBI = :old.numBI;
    delete from cliente where numBI = :old.numBI;
    if x=0 then
      delete from pessoa where numBI = :old.numBI;
    end if;
  end;
/

create or replace trigger update_cliente
  instead of update on clientes
  for each row
  begin 
    if :new.numbi = :old.numbi then
      update pessoa
      set nome = :new.nome, data_nsc = :new.data_nsc, morada = :new.morada, sexo = :new.sexo, email = :new.email, telefone = :new.telefone
          where numBI = :new.numBI;
    end if;
  end;
/

-- Manipulacao do funcionario
create or replace trigger add_funcionario
  instead of insert on funcionarios
  for each row
  declare
    x number;
  begin
    select count(*) into x from pessoa where :new.numBI = numBI;
    if x=0 then
      insert into pessoa values (:new.numBI, :new.nome, :new.data_nsc, :new.morada, :new.sexo, :new.email, :new.telefone);
		end if;
  insert into funcionario values (:new.numBI, seq_funcionario.nextval, :new.nomecargo);
  end;
/

create or replace trigger del_funcionario
  instead of delete on funcionarios
  for each row
  declare x number;
  begin
    SELECT COUNT(*) INTO x FROM cliente where numBI = :old.numBI;
    delete from funcionario where numBI = :old.numBI;
    if x=0 then
      delete from pessoa where numBI = :old.numBI;
    end if;
  end;
/

create or replace trigger update_funcionario
  instead of update on funcionarios
  for each row
  begin
    if :new.numbi = :old.numbi then
      update pessoa 
      set nome = :new.nome, data_nsc = :new.data_nsc, morada = :new.morada, sexo = :new.sexo, 
          email = :new.email, telefone = :new.telefone where numbi = :new.numbi;
      update funcionario
      set nomecargo = :new.nomecargo where numbi = :new.numbi;
    end if;
  end;
/

-- apagar atributos dos filmes
create or replace trigger del_filme
  after delete on filme
  for each row
  begin
    delete from caracterizado where codFilme=:old.codFilme;
    delete from protagonizado where codFilme=:old.codFilme;
    delete from realizado where codFilme=:old.codFilme;
  end;
/

create or replace trigger del_protagonista
  after delete on actor_realizador
  for each row
  begin
    delete from protagonizado where id = :old.id;
  end;
/

create or replace trigger del_realizador
  after delete on actor_realizador
  for each row
  begin
    delete from realizado where id = :old.id;
  end;
/

-- adicionar nova copia do filme
create or replace trigger adiciona_copia
  before insert on copia
  for each row
  declare
    numCopias number;
  begin
    select count(codFilme) into numCopias from copia where codFilme=:new.codfilme;
    :new.numCopia := numCopias +1;
  end;
/

-- verifica se ha copias do filme disponiveis
create or replace trigger adiciona_aluguer
  before insert on aluguer
  for each row
  declare
    xx number;
  begin
	if :new.datadev != null and :new.dataaluguer > :new.datadev then
      raise_application_error(-20798, ' Datas invalidas.');
    end if;
    if :new.dataaluguer > :new.datadevprevista then
      raise_application_error(-20799, ' Data ou prazo invalidos.');
    end if; 
    select min(numCopia) into xx from copias_livres where codFilme=:new.codfilme;
    if xx>0 then
      :new.numcopia := xx;
    else
      raise_application_error(-20799, 'Nao existem copias do filme disponiveis.');
    end if;
  end;
/

--verifica consistencia das datas
create or replace trigger dif_datas
  before update on aluguer
  for each row
  begin
    if :new.dataaluguer > :new.datadev then
      raise_application_error(-20798, ' Datas invalidas.');
    end if;
    if :new.dataaluguer > :new.datadevprevista then
      raise_application_error(-20799, ' Data ou prazo invalidos.');
    end if; 
  end;
/

-- Manipulacao da master table dos generos
create or replace trigger ins_generos_filme2
  instead of insert on generos_filme_master
  for each row
  begin
    insert into caracterizado values(:new.codfilme, :new.idgenero);
  end;
/

create or replace trigger del_generos_filme2
  instead of delete on generos_filme_master
  for each row
  begin
    delete from caracterizado where rowid=:old."rowid";
  end;
/

create or replace trigger up_generos_filme2
  instead of update on generos_filme_master
  for each row
  begin
    update caracterizado
      set idgenero=:new.idgenero where rowid=:old."rowid";
  end;
/

-- Manipulacao da master table dos protagonistas
create or replace trigger insert_protagonista
  instead of insert on protagonistas_filme_master
  for each row
  begin
    insert into protagonizado values(:new.codfilme, :new.id);
  end;
/

create or replace trigger delete_protagonista
  instead of delete on protagonistas_filme_master
  for each row
  begin
    delete from protagonizado where rowid=:old."rowid";
  end;
/

create or replace trigger update_protagonista
  instead of update on protagonistas_filme_master
  for each row
  begin
    update protagonizado
      set id=:new.id where rowid=:old."rowid";
  end;
/

-- Manipulacao da master table dos realizadores
create or replace trigger insert_realizador
  instead of insert on realizadores_filme_master
  for each row
  begin
    insert into realizado values(:new.codfilme, :new.id);
  end;
/

create or replace trigger delete_realizador
  instead of delete on realizadores_filme_master
  for each row
  begin
    delete from realizado where rowid=:old."rowid";
  end;
/

create or replace trigger update_realizador
  instead of update on realizadores_filme_master
  for each row
  begin
    update realizado
      set id=:new.id where rowid=:old."rowid";
  end;
/

----------------------------------------------------
---------------------- Funcoes ---------------------
----------------------------------------------------

create or replace function multa (date1 in date, date2 in date)
return number is
begin
if date1<date2 then
return 2*(date2-date1);
else return 0;
end if;
end;
/

create or replace function preco (date1 in date, date2 in date)
return number is
begin
return date2-date1;
end;
/

----------------------------------------------------
----------------------- Dados ----------------------
----------------------------------------------------

-- Pessoa(numBI, nome, data_nsc, morada, sexo, email, telefone)
INSERT INTO Pessoa values('12345679', 'Maria', to_date('23-04-1980', 'DD-MM-YYYY'), 'R.Amalia', 'F', 'maria@rev.com', 
'289123426');
INSERT INTO Pessoa values('12345677', 'Paula', to_date('01-09-1991', 'DD-MM-YYYY'), 'R.Augusta', 'F', 'paula@rev.com', 
'289123455');
INSERT INTO Pessoa values('12345671', 'David', to_date('12-02-1980', 'DD-MM-YYYY'), 'Av.5 de Outubro', 'M', 
'david@rev.com', '289123456');
INSERT INTO Pessoa values('12345672', 'Jose', to_date('25-04-1974', 'DD-MM-YYYY'), 'R. Santo António', 'M', 
'jose@rev.com', '289123123');
INSERT INTO Pessoa values('12345673', 'Salvio', to_date('30-12-1988', 'DD-MM-YYYY'), 'Praceta Augusto', 'M', 
'salvio@rev.com', '289123343');
INSERT INTO Pessoa values('12345681', 'Ana', to_date('02-04-1990', 'DD-MM-YYYY'), 'Avenida de Liberdade', 'F', 
'ana@gmail.com', '218596123');
INSERT INTO Pessoa values('12345683', 'Claudio', to_date('18-09-1975', 'DD-MM-YYYY'), 'Rua de Faro', 'M', 
'claudio@rev.com', '214563289');
INSERT INTO Pessoa values('12345685', 'Pedro', to_date('05-05-1987', 'DD-MM-YYYY'), 'Rua das Flores', 'M', 
'pedro@gmail.com', '214563456');
INSERT INTO Pessoa values('12325688', 'Miguel', to_date('29-03-1973', 'DD-MM-YYYY'), 'Avenida Casal Ribeiro', 'M', 
'miguel@gmail.com', '214563196');
INSERT INTO Pessoa values('12345688', 'Teresa', to_date('03-11-1995', 'DD-MM-YYYY'), 'Avenida Fontes Pereira', 'F', 
'teresa@gmail.com', '214269197');


-- Cliente(numBI, numSocio)
INSERT INTO Cliente values('12345673', seq_socio.nextval);
INSERT INTO Cliente values('12345679', seq_socio.nextval);
INSERT INTO Cliente values('12345677', seq_socio.nextval);
INSERT INTO Cliente values('12345681', seq_socio.nextval);
INSERT INTO Cliente values('12345683', seq_socio.nextval);
INSERT INTO Cliente values('12345688', seq_socio.nextval);



-- Cargo(nomeCargo, salario)
INSERT INTO Cargo values('Balcao', '450');
INSERT INTO Cargo values('Patrao', '5000');
INSERT INTO Cargo values('Voluntário', '0');
INSERT INTO Cargo values('Gerente', '525');

-- Funcionario(numBI, numFuncionario, nomeCargo)
INSERT INTO Funcionario values('12345671', seq_funcionario.nextval,'Balcao');
INSERT INTO Funcionario values('12345672', seq_funcionario.nextval,'Patrao');
INSERT INTO Funcionario values('12345673', seq_funcionario.nextval,'Balcao');
INSERT INTO Funcionario values('12345688', seq_funcionario.nextval,'Voluntário');
INSERT INTO Funcionario values('12325688', seq_funcionario.nextval,'Gerente');
INSERT INTO Funcionario values('12345685', seq_funcionario.nextval,'Balcao');


-- Filme(codFilme, titulo, dataLamcamento, duracao)
INSERT INTO Filme values(seq_filme.nextval, 'Happy', to_date('2011.10.15', 'YYYY.MM.DD'), '93');
INSERT INTO Filme values(seq_filme.nextval, 'Psycho', to_date('1960.11.22', 'YYYY.MM.DD'), '109');
INSERT INTO Filme values(seq_filme.nextval, 'Harry Potter and the Sorcerers Stone', to_date('2001.10.15', 'YYYY.MM.DD'), '152');
INSERT INTO Filme values(seq_filme.nextval, 'Pulp Fiction', to_date('1994.11.25', 'YYYY.MM.DD'), '154');
INSERT INTO Filme values(seq_filme.nextval, 'Lord Of The Rings', to_date('2001.12.21', 'YYYY.MM.DD'), '178');
INSERT INTO Filme values(seq_filme.nextval, 'Wildlife', to_date('2014.02.23', 'YYYY.MM.DD'), '80');
INSERT INTO Filme values(seq_filme.nextval, 'Jurassic Park', to_date('1993.06.09', 'YYYY.MM.DD'), '127');
INSERT INTO Filme values(seq_filme.nextval, 'Norbit', to_date('2007.03.15', 'YYYY.MM.DD'), '102');
INSERT INTO Filme values(seq_filme.nextval, 'Harry Potter and the Deathly Hallows: Part 2', to_date('2011.07.14', 'YYYY.MM.DD'), '130');
INSERT INTO Filme values(seq_filme.nextval, 'Burlesque', to_date('2010.12.30', 'YYYY.MM.DD'), '119');
INSERT INTO Filme values(seq_filme.nextval, 'Noah', to_date('2014.04.10', 'YYYY.MM.DD'), '138');


-- Actor_Realizador(ID, nome, nacionalidade)
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Daniel Radcliffe','UK');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Emma Watson','UK');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Rupert Grint','UK');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Chris Columbus','USA');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Steven Spielberg','USA');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Jeff Goldblum','USA');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Eddie Murphy','USA');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'David Yates','UK');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Russell Crowe','New Zealand');
INSERT INTO Actor_Realizador values(seq_actor.nextval,'Russell Crowe','New Zealand');


-- Realizado(codFilme, ID)
INSERT INTO Realizado values(3,4);
INSERT INTO Realizado values(7,5);
INSERT INTO Realizado values(9,8);
INSERT INTO Realizado values(9,9);


-- Protagonizado(codFilme, ID)
INSERT INTO Protagonizado values(3,1);
INSERT INTO Protagonizado values(3,2);
INSERT INTO Protagonizado values(3,3);
INSERT INTO Protagonizado values(7,6);
INSERT INTO Protagonizado values(8,7);
INSERT INTO Protagonizado values(9,1);
INSERT INTO Protagonizado values(9,2);
INSERT INTO Protagonizado values(9,3);
INSERT INTO Protagonizado values(11,9);


-- Genero(idGenero, nomeGenero)
INSERT INTO Genero values(seq_genero.nextval,'Fantasia');
INSERT INTO Genero values(seq_genero.nextval,'Aventura');
INSERT INTO Genero values(seq_genero.nextval, 'Terror');
INSERT INTO Genero values(seq_genero.nextval, 'Documentário');
INSERT INTO Genero values(seq_genero.nextval, 'Policial');
INSERT INTO Genero values(seq_genero.nextval, 'Comédia');
INSERT INTO Genero values(seq_genero.nextval, 'Musical');
INSERT INTO Genero values(seq_genero.nextval, 'Drama');


-- Caracterizado(codFilme, idGenero)
INSERT INTO Caracterizado values(3,1);
INSERT INTO Caracterizado values(3,2);
INSERT INTO Caracterizado values(6,4);
INSERT INTO Caracterizado values(11,2);
INSERT INTO Caracterizado values(10,8);
INSERT INTO Caracterizado values(11,8);
INSERT INTO Caracterizado values(8,7);

-- Copia(numCopia, codFilme)
INSERT INTO Copia values(null, 3);
INSERT INTO Copia values(null, 3);
INSERT INTO Copia values(null, 11);
INSERT INTO Copia values(null, 8);
INSERT INTO Copia values(null, 9);
INSERT INTO Copia values(null, 4);
INSERT INTO Copia values(null, 5);
INSERT INTO Copia values(null, 9);
INSERT INTO Copia values(null, 1);
INSERT INTO Copia values(null, 2);
INSERT INTO Copia values(null, 6);
INSERT INTO Copia values(null, 7);
INSERT INTO Copia values(null, 5);


-- Aluguer (numAluguer, dataAluguer, numCopia, codFilme, dataDev, numSocio, dataDevPrevista, numFuncionario )
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.04.10', 'YYYY.MM.DD'),null,3, null, 2,to_date('2014.04.11', 'YYYY.MM.DD') , 1);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.06.10', 'YYYY.MM.DD'),null,3,  null,2,to_date('2014.06.11', 'YYYY.MM.DD'), 3);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.05.22', 'YYYY.MM.DD'),null,11,  to_date('2014.05.23', 'YYYY.MM.DD'), 6, to_date('2014.05.23', 'YYYY.MM.DD'), 3);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.06.23', 'YYYY.MM.DD'),null,9,  to_date('2014.07.23', 'YYYY.MM.DD'),6,to_date('2014.06.24', 'YYYY.MM.DD'), 1);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.05.23', 'YYYY.MM.DD'),null,8, to_date('2014.05.28', 'YYYY.MM.DD'), 3, to_date('2014.05.24', 'YYYY.MM.DD'), 2);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.06.23', 'YYYY.MM.DD'),null,5,  null,5,to_date('2014.06.24', 'YYYY.MM.DD'), 1);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.05.23', 'YYYY.MM.DD'),null,4, to_date('2014.06.05', 'YYYY.MM.DD'), 4, to_date('2014.05.24', 'YYYY.MM.DD'), 2);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.06.23', 'YYYY.MM.DD'),null,5,  null,5,to_date('2014.06.24', 'YYYY.MM.DD'), 1);
INSERT INTO Aluguer values(seq_aluguer.nextval, to_date('2014.05.23', 'YYYY.MM.DD'),null,4, to_date('2014.06.09', 'YYYY.MM.DD'), 4, to_date('2014.05.24', 'YYYY.MM.DD'), 2);

