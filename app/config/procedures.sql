/* Procedure Animais */
DELIMITER $$
CREATE PROCEDURE inserir_animais(IN nome VARCHAR(30),
                                 IN descricao TEXT,
                               	 IN raca VARCHAR(35),
                               	 IN cor VARCHAR(25),
                               	 IN idade INTEGER,
                               	 IN sexo VARCHAR(5),
                                 IN adotado VARCHAR(5))
BEGIN

  SET @var_nome = nome;
  SET @var_descricao = descricao;
  SET @var_raca = raca;
  SET @var_cor = cor;
  SET @var_idade = idade;
  SET @var_sexo = sexo;
  SET @var_adotado = adotado;
  SET @var_id_animal = 0;

  IF (nome = "") THEN SET @var_nome = "Sem Nome"; END IF;
  IF(raca = "") THEN SET @var_raca = "SRD"; END IF;
  IF (idade = "") THEN SET @var_idade = NULL; END IF;
  IF (adotado = "") THEN SET @var_adotado = "false"; END IF;

  INSERT INTO Animais(nome, descricao, raca, cor, idade, sexo, adotado)
  VALUES(@var_nome, @var_descricao, @var_raca, @var_cor, @var_idade, @var_sexo, @var_adotado);

  SELECT LAST_INSERT_ID() INTO @var_id_animal;

  SELECT * from animais where id = @var_id_animal;

  COMMIT WORK;

END $$
DELIMITER ;

/* Procedure Imagens_Animais (VINCULADA AOS ANIMAIS) 
DELIMITER $$
CREATE PROCEDURE inserir_imagens_animais(IN id_animal INTEGER,
                                         IN nome_imagem TEXT)
BEGIN

  SET @var_id_animal = id_animal;
  SET @var_nome_imagem = nome_imagem;

  INSERT INTO Imagens_Animais(id_animal, nome_imagem)
  VALUES(@var_id_animal, @var_nome_imagem);

  COMMIT WORK;

END $$
DELIMITER ; */

/* Procedure Selecionar animais por filtro*/
DELIMITER $$
CREATE PROCEDURE filtro_animais(IN cor VARCHAR(25),
                               IN idademin INTEGER,
                               IN idademax INTEGER,
                               IN sexo VARCHAR(5))
BEGIN

  select 
    a.*,
    i.nome_imagem
  from 
    animais a
  inner join imagens_animais i on a.id = i.id_animal
  where a.cor = cor and (a.idade between idademin and idademax) and a.sexo = sexo;

END $$
DELIMITER ;

/* Procedure Denuncias */
DELIMITER $$
CREATE PROCEDURE inserir_denuncias(IN descricao TEXT,
                                   IN delator VARCHAR(75),
                                   IN descricao_local VARCHAR(150))
BEGIN

  SET @var_delator = delator;
  SET @var_id_denuncia = 0;  

  IF(delator = "") THEN SET @var_delator = "Anônimo"; END IF;

  INSERT INTO Denuncias(descricao, delator, descricao_local)
  VALUES(descricao, @var_delator, descricao_local);

  SELECT LAST_INSERT_ID() INTO @var_id_denuncia;

  SELECT * from Denuncias where id = @var_id_denuncia;

  COMMIT WORK;

END $$
DELIMITER ;

/* Procedure Imagens_Denuncias (VINCULADA AS DENUNCIAS) 
DELIMITER $$
CREATE PROCEDURE inserir_imagens_denuncias(IN id_denuncia INTEGER,
                                           IN nome_imagem TEXT)
BEGIN

  SET @var_id_denuncia = id_denuncia;
  SET @var_nome_imagem = nome_imagem;

  INSERT INTO Imagens_Denuncias(id_denuncia, nome_imagem)
  VALUES(@var_id_denuncia, @var_nome_imagem);

  COMMIT WORK;

END $$
DELIMITER ; */

/* Procedure Imagens */
DELIMITER $$
CREATE PROCEDURE inserir_imagens(IN nome_imagem TEXT,
                                 IN id_foreign INTEGER,
                                 IN flag VARCHAR(15))
BEGIN

  INSERT INTO Imagens(nome_imagem, id_foreign, flag)
  VALUES(nome_imagem, id_foreign, flag);

  COMMIT WORK;

END $$
DELIMITER ;

/* Procedure Associados */
DELIMITER $$
CREATE PROCEDURE inserir_associados(IN nome VARCHAR(80),
                                    IN sexo VARCHAR(10),
                                    IN email VARCHAR(70),
                                    IN pass VARCHAR(50),
                                    IN logradouro VARCHAR(150),
                                    IN numero VARCHAR(50),
                                    IN complemento VARCHAR(150),
                                    IN bairro VARCHAR(100),
                                    IN cep VARCHAR(10),
                                    IN cidade VARCHAR(100),
                                    IN estado CHAR(2))
BEGIN

  SET @var_email = email;
  SET @var_numero = numero;
  SET @var_complemento = complemento;
  SET @var_id_associado = 0;

  IF(email = "") THEN SET @var_email = NULL; END IF;
  IF(numero = "") THEN SET @var_numero = "S/n"; END IF;
  IF(complemento = "") THEN SET @var_complemento = NULL; END IF;

  INSERT INTO Associados(nome, sexo, email, pass)
  VALUES(nome, sexo, @var_email, pass);

  SELECT LAST_INSERT_ID() INTO @var_id_associado;

  INSERT INTO Enderecos(id_associado, logradouro, numero, complemento, bairro, cep, cidade, estado)
  VALUES(@var_id_associado, logradouro, @var_numero, @var_complemento, bairro, cep, cidade, estado);

  SELECT id from Associados WHERE id = @var_id_associado;

  COMMIT WORK;

END $$
DELIMITER ;

/* Procedure Telefones */
DELIMITER $$
CREATE PROCEDURE inserir_telefones(IN id_associado INTEGER,
                                   IN numero VARCHAR(15),
                                   IN tipo VARCHAR(15))
BEGIN

  INSERT INTO Telefones(id_associado, numero, tipo)
  VALUES(id_associado, numero, tipo);

  COMMIT WORK;

END $$
DELIMITER ;

/* Procedure atualizar Associados */
DELIMITER $$
CREATE PROCEDURE update_associados(IN id_associado INTEGER,
                                    IN nome VARCHAR(80),
                                    IN sexo VARCHAR(10),
                                    IN email VARCHAR(70),
                                    IN pass VARCHAR(50),
                                    IN id_endereco INTEGER,
                                    IN logradouro VARCHAR(150),
                                    IN numero VARCHAR(50),
                                    IN complemento VARCHAR(150),
                                    IN bairro VARCHAR(100),
                                    IN cep VARCHAR(10),
                                    IN cidade VARCHAR(100),
                                    IN estado CHAR(2))
BEGIN

  IF(pass = "d41d8cd98f00b204e9800998ecf8427e" or pass = "") THEN
    UPDATE Associados SET nome=nome, sexo=sexo, email=email WHERE id=id_associado;  
  ELSE    
    UPDATE Associados SET nome=nome, sexo=sexo, email=email, pass=pass WHERE id=id_associado;
  END IF;

  UPDATE Enderecos SET logradouro=logradouro, numero=numero, complemento=complemento, bairro=bairro, cep=cep, cidade=cidade, estado=estado WHERE id = id_endereco; 

  COMMIT WORK;

END $$
DELIMITER ;


