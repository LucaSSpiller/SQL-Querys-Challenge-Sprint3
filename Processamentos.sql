set serveroutput on

-- PROCEDURES

-- PROCEDURE CONSULTA - LISTAR PRODOUTO POR CATEGORIA
CREATE OR REPLACE PROCEDURE sp_listar_produtos_por_categoria (
    p_categoria IN VARCHAR2
) AS
    v_user VARCHAR2(50); -- Variável para armazenar o usuário logado
BEGIN
    -- Nome do usuário logado 
    SELECT USER INTO v_user FROM DUAL;

    -- Início da consulta
    DECLARE
        v_produto_encontrado BOOLEAN := FALSE;
    BEGIN
        FOR produto IN (
            SELECT p.nm_produto
            FROM nk_tb_produto p
            INNER JOIN nk_tb_categoria_produto cp ON p.id_produto = cp.id_produto
            INNER JOIN nk_tb_categoria c ON cp.id_categoria = c.id_categoria
            WHERE c.nm_categoria = p_categoria
        ) LOOP
            -- Exibir nome do produto
            DBMS_OUTPUT.PUT_LINE(produto.nm_produto);
            v_produto_encontrado := TRUE;
        END LOOP;

        -- Se nenhum produto for encontrado -> EXCEPTION
        IF NOT v_produto_encontrado THEN
            -- Utilize NO_DATA_FOUND para capturar a exceção
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Lidar com a exceção de "Nenhum dado encontrado"
            DBMS_OUTPUT.PUT_LINE('Nenhum produto encontrado para a categoria: ' || p_categoria);
            
        WHEN OTHERS THEN
            -- Capturar código e mensagem de erro
            DECLARE
                v_err_code NUMBER := SQLCODE;
                v_err_msg VARCHAR2(4000) := SQLERRM;
            BEGIN
                -- Inserir erro na tabela custom_exceptions
                INSERT INTO custom_exceptions (exception_id, exception_code, exception_name, occurrence_date, logged_in_user)
                VALUES (custom_exceptions_seq.nextval, TO_CHAR(v_err_code), v_err_msg, SYSTIMESTAMP, v_user);

                -- Imprimir a mensagem de erro original
                DBMS_OUTPUT.PUT_LINE('Ocorreu um erro: ' || v_err_msg);
            END;
    END;
END sp_listar_produtos_por_categoria;
/


BEGIN
    sp_listar_produtos_por_categoria('Corrida'); -- CATEGORIA QUE DESEJA
END;
/


-- LISTAGEM DE CLIENTES QUE FIZERAM PEDIDO DE PRODUTO DE UMA CATEGORIA
CREATE OR REPLACE PROCEDURE buscar_clientes_por_categoria(
    categoria_produto IN VARCHAR2
) AS
    v_user VARCHAR2(50); -- Variável para armazenar o usuário logado
    nome_cliente VARCHAR2(50);
    email_cliente VARCHAR2(50);
    v_cliente_encontrado BOOLEAN := FALSE; 
BEGIN
    -- Obtendo nome do usuário logado no momento da execuçlão
    SELECT USER INTO v_user FROM DUAL;

    -- Inicializando as variáveis
    nome_cliente := NULL;
    email_cliente := NULL;

    -- CONSULTA

    FOR cliente_rec IN (
        SELECT DISTINCT u.nm_usuario AS nome_cliente, u.ds_email AS email_cliente
        FROM nk_tb_usuario u
        JOIN nk_tb_carrinho c ON u.id_usuario = c.id_usuario
        JOIN nk_tb_produto p ON c.id_produto = p.id_produto
        JOIN nk_tb_categoria_produto cp ON p.id_produto = cp.id_produto
        JOIN nk_tb_categoria ct ON cp.id_categoria = ct.id_categoria
        WHERE ct.nm_categoria = categoria_produto
    ) LOOP
        v_cliente_encontrado := TRUE;

        -- Exibir nome e emial do cliente
        nome_cliente := cliente_rec.nome_cliente;
        email_cliente := cliente_rec.email_cliente;
        
        DBMS_OUTPUT.PUT_LINE('Nome do Cliente: ' || nome_cliente);
        DBMS_OUTPUT.PUT_LINE('Email do Cliente: ' || email_cliente);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;

    -- Se nenhum cliente for encontrado -> EXCEPTION
    IF NOT v_cliente_encontrado THEN
        RAISE NO_DATA_FOUND;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Exceção de No Data FOund
        DBMS_OUTPUT.PUT_LINE('Nenhum cliente encontrado para a categoria: ' || categoria_produto);
        
    WHEN OTHERS THEN
        DECLARE
            v_err_code NUMBER := SQLCODE;
            v_err_msg VARCHAR2(4000) := SQLERRM;
        BEGIN
            -- Inserindo erro na tabela Custom_exceptions
            INSERT INTO custom_exceptions (exception_id, exception_code, exception_name, occurrence_date, logged_in_user)
            VALUES (custom_exceptions_seq.nextval, TO_CHAR(v_err_code), v_err_msg, SYSTIMESTAMP, v_user);

            -- Mensagem original de erro
            DBMS_OUTPUT.PUT_LINE('Ocorreu um erro: ' || v_err_msg);
        END;
END buscar_clientes_por_categoria;
/


BEGIN
    buscar_clientes_por_categoria('Corrida'); -- Categoria de consulta
END;
/



-- PROCEDURE PARA LISTAR OS ITENS DO CARRINHO, COM O NOME DO CLIENTE, O PREÇO DO PRODUTO E CATEGORIA

CREATE OR REPLACE PROCEDURE sp_listar_itens_carrinho (
    p_id_usuario IN NUMBER
) AS
    v_user VARCHAR2(50); -- Variável para armazenar o usuário logado
    v_item_encontrado BOOLEAN;

BEGIN
    -- Obtendo nome do usuário logado no momento da execução
    SELECT USER INTO v_user FROM DUAL;

    -- Inicializando a vairável
    v_item_encontrado := FALSE;

    -- CONSULTA
    FOR item IN (
        SELECT c.id_carrinho, p.nm_produto, p.nr_preco, categ.nm_categoria, u.nm_usuario
        FROM nk_tb_carrinho c
        INNER JOIN nk_tb_produto p ON c.id_produto = p.id_produto
        INNER JOIN nk_tb_usuario u ON c.id_usuario = u.id_usuario
        INNER JOIN nk_tb_categoria_produto cp ON p.id_produto = cp.id_produto
        INNER JOIN nk_tb_categoria categ ON cp.id_categoria = categ.id_categoria
        WHERE c.id_usuario = p_id_usuario
    ) LOOP
        v_item_encontrado := TRUE;

        -- Exibindo detalhes ou caindo na exception
        DBMS_OUTPUT.PUT_LINE('Nome do Usuário: ' || item.nm_usuario || ' | ID do Carrinho: ' || item.id_carrinho || ' | Produto: ' || item.nm_produto || ' | Preço: ' || item.nr_preco || ' | Categoria: ' || item.nm_categoria);
    END LOOP;

    -- Se nenhum item for encontrado -> EXCEPTION
    IF NOT v_item_encontrado THEN
        RAISE NO_DATA_FOUND;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum item encontrado para o ID de usuário: ' || p_id_usuario);

    WHEN OTHERS THEN
        DECLARE
            v_err_code NUMBER := SQLCODE;
            v_err_msg VARCHAR2(4000) := SQLERRM;
        BEGIN
            -- Inserindo na tabela custom_exceptions
            INSERT INTO custom_exceptions (exception_id, exception_code, exception_name, occurrence_date, logged_in_user)
            VALUES (custom_exceptions_seq.nextval, TO_CHAR(v_err_code), v_err_msg, SYSTIMESTAMP, v_user);

            -- Mensagem de erro original
            DBMS_OUTPUT.PUT_LINE('Ocorreu um erro: ' || v_err_msg);
        END;
END sp_listar_itens_carrinho;
/



DECLARE
    p_usuario_id NUMBER := 10; -- ID DO USUÁRIO DO QUAL DESEJA BUSCAR O CARRINHO ( 1 - 5 )
BEGIN
    sp_listar_itens_carrinho(p_usuario_id);
END;
/



-- FUNCOES

-- Função que retorna valor total de carrinho do usuário
CREATE OR REPLACE FUNCTION calcular_total_carrinho(id_usuario_param IN NUMBER)
RETURN NUMBER
IS
    total NUMBER := 0;
BEGIN
    SELECT SUM(p.nr_preco)
    INTO total
    FROM nk_tb_carrinho c
    JOIN nk_tb_produto p ON c.id_produto = p.id_produto
    WHERE c.id_usuario = id_usuario_param;
    
    RETURN total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
END;
/


-- EXECUÇÃO 

DECLARE
    id_usuario NUMBER := 10; -- ID de consulta
    total_carrinho NUMBER;
BEGIN
    total_carrinho := calcular_total_carrinho(id_usuario);
    
    IF total_carrinho > 0 THEN
        DBMS_OUTPUT.PUT_LINE('O valor total do carrinho do usuário ' || id_usuario || ' é: R$ ' || total_carrinho);
    ELSE
        DBMS_OUTPUT.PUT_LINE('O carrinho do usuário ' || id_usuario || ' está vazio.');
    END IF;
END;
/



-- Função para obter quantidade de produtos por usuario

CREATE OR REPLACE FUNCTION obter_quantidade_produtos_por_usuario
RETURN SYS_REFCURSOR
IS
    cur SYS_REFCURSOR;
BEGIN
    OPEN cur FOR
    SELECT NK_TB_USUARIO.nm_usuario AS nm_usuario,
           LISTAGG(NK_TB_PRODUTO.nm_produto, ', ') WITHIN GROUP (ORDER BY NK_TB_PRODUTO.nm_produto) AS produtos_comprados,
           COUNT(*) AS quantidade
    FROM NK_TB_CARRINHO
    INNER JOIN NK_TB_USUARIO ON NK_TB_CARRINHO.id_usuario = NK_TB_USUARIO.id_usuario
    INNER JOIN NK_TB_PRODUTO ON NK_TB_CARRINHO.id_produto = NK_TB_PRODUTO.id_produto
    GROUP BY NK_TB_USUARIO.nm_usuario;
    
    RETURN cur;
END;
/

-- EXECUÇÃO

DECLARE
    resultado_cursor SYS_REFCURSOR;
    nm_usuario NK_TB_USUARIO.nm_usuario%TYPE;
    produtos_comprados VARCHAR2(4000);
    quantidade NUMBER;
BEGIN
    resultado_cursor := obter_quantidade_produtos_por_usuario;
    
    LOOP
        FETCH resultado_cursor INTO nm_usuario, produtos_comprados, quantidade;
        EXIT WHEN resultado_cursor%NOTFOUND;
        -- Faça algo com os valores obtidos, como imprimir ou processar
        DBMS_OUTPUT.PUT_LINE('Usuário: ' || nm_usuario);
        DBMS_OUTPUT.PUT_LINE('Produtos Comprados: ' || produtos_comprados);
        DBMS_OUTPUT.PUT_LINE('Quantidade Total: ' || quantidade);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
    
    CLOSE resultado_cursor;
END;
/


-- TRIGGER

SELECT trigger_name, status
FROM user_triggers
WHERE table_name = 'NK_TB_USUARIO';


-- Trigger
CREATE OR REPLACE TRIGGER usuario_update_trigger
BEFORE UPDATE ON nk_tb_usuario
FOR EACH ROW
BEGIN
    IF :NEW.nm_usuario <> :OLD.nm_usuario OR
       :NEW.ds_senha <> :OLD.ds_senha OR
       :NEW.nm_sobrenome <> :OLD.nm_sobrenome THEN
        INSERT INTO nk_tb_usuario_log (id_usuario, coluna_atualizada, valor_antigo, valor_novo, data_atualizacao)
        VALUES (:OLD.id_usuario, 'nm_usuario', :OLD.nm_usuario, :NEW.nm_usuario, SYSTIMESTAMP);

        INSERT INTO nk_tb_usuario_log (id_usuario, coluna_atualizada, valor_antigo, valor_novo, data_atualizacao)
        VALUES (:OLD.id_usuario, 'ds_senha', :OLD.ds_senha, :NEW.ds_senha, SYSTIMESTAMP);

        INSERT INTO nk_tb_usuario_log (id_usuario, coluna_atualizada, valor_antigo, valor_novo, data_atualizacao)
        VALUES (:OLD.id_usuario, 'nm_sobrenome', :OLD.nm_sobrenome, :NEW.nm_sobrenome, SYSTIMESTAMP);
    END IF;
END;
/


-- EXECUTANDO A ATUALIZAÇÃO DE DADOS
UPDATE nk_tb_usuario
SET ds_email = 'joaozera@gmail.com'
WHERE id_usuario = 1;

-- VERIFICANDO OS REGISTROS NO LOG
SELECT * FROM nk_tb_usuario_log WHERE id_usuario = 1;
