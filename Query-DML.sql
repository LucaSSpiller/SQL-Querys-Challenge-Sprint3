INSERT INTO nk_tb_usuario (ds_email, nm_usuario, ds_senha, nm_sobrenome) VALUES ('joao@gmail.com', 'João', 'senha123', 'Silva');
INSERT INTO nk_tb_usuario (ds_email, nm_usuario, ds_senha, nm_sobrenome) VALUES ('maria@hotmail.com', 'Maria', '123456', 'Souza');
INSERT INTO nk_tb_usuario (ds_email, nm_usuario, ds_senha, nm_sobrenome) VALUES ('pedro@yahoo.com', 'Pedro', 'p@ssw0rd', 'Ribeiro');
INSERT INTO nk_tb_usuario (ds_email, nm_usuario, ds_senha, nm_sobrenome) VALUES ('ana@gmail.com', 'Ana', 'ana123', 'Fernandes');
INSERT INTO nk_tb_usuario (ds_email, nm_usuario, ds_senha, nm_sobrenome) VALUES ('lucas@outlook.com', 'Lucas', 'lucas456', 'Santos');
    
    
INSERT INTO nk_tb_produto (ds_genero, nm_produto, nr_preco) VALUES ('MASCULINO', 'Tênis Air Max 270', 549.90);
INSERT INTO nk_tb_produto (ds_genero, nm_produto, nr_preco) VALUES ('FEMININO', 'Tênis Air Zoom Pegasus 38', 399.99);
INSERT INTO nk_tb_produto (ds_genero, nm_produto, nr_preco) VALUES ('MASCULINO', 'Moletom com Capuz', 149.90);
INSERT INTO nk_tb_produto (ds_genero, nm_produto, nr_preco) VALUES ('FEMININO', 'Calça Legging Sculpt', 199.90);
INSERT INTO nk_tb_produto (ds_genero, nm_produto, nr_preco) VALUES ('UNISSEX', 'Boné Heritage86', 79.90);
    
    
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Corrida');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('SNKRS');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Futebol');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Casual');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Basket');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Acessorio');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Skate');
INSERT INTO nk_tb_categoria (nm_categoria) VALUES ('Natação');
   	
INSERT INTO nk_tb_categoria_produto (id_produto, id_categoria) VALUES (1, 1);
INSERT INTO nk_tb_categoria_produto (id_produto, id_categoria) VALUES (2, 1);
INSERT INTO nk_tb_categoria_produto (id_produto, id_categoria) VALUES (3, 4);
INSERT INTO nk_tb_categoria_produto (id_produto, id_categoria) VALUES (4, 1);
INSERT INTO nk_tb_categoria_produto (id_produto, id_categoria) VALUES (5, 6);
		
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (1, 1);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (2, 5);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (3, 3);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (4, 2);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (5, 4);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (4, 1);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (5, 1);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (1, 2);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (2, 5);
INSERT INTO nk_tb_carrinho (id_produto, id_usuario) VALUES (1, 3);
		
		