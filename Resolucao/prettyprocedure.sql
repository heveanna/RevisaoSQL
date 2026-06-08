USE PetShop;

GO 

IF EXISTS (SELECT 1 FROM [dbo].[sysobjects]
				WHERE Id = OBJECT_ID(N'Sp_ListarClientes')
					AND OBJECTPROPERTY(Id, N'IsProcedure') = 1)
				BEGIN 
					DROP PROCEDURE [dbo].[SP_ListarClientes]
				END
GO 
	CREATE PROCEDURE [dbo].[SP_ListarClientes]
		@Id				INT,
		@Nome			VARCHAR(120),
		@Cpf			CHAR(11),
		@Telefone		VARCHAR(15),
		@Email			VARCHAR(120),
		@DataCadastro	DATE

AS
/*
	Documentação:
	Arquivo Nome: prettyprocedure.sql
	Objetivo: Retornar todos os clientes ordenados por nome. 
	Autor: Anna Hevellyn 
	Data Criação: 08/06/2026
	Exemplo: 
*/

BEGIN 
	DECLARE 