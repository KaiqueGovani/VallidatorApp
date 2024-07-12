import { Router } from 'express';
import pool from '../config/database.js';

const router = Router();

// Route for initializing the database with a query
router.get('/setup', (req, res) => {
    const query = `
    CREATE TABLE public.Usuario (
        id serial PRIMARY KEY,
        nome varchar,
        sobrenome varchar,
        telefone varchar,
        email varchar UNIQUE NOT NULL,
        senha varchar NOT NULL,
        permissao varchar DEFAULT 'ver' NOT NULL
    );
    
    CREATE TABLE public.Tipos (
        id serial PRIMARY KEY,
        tipo varchar UNIQUE NOT NULL,
        python_dtype varchar UNIQUE NOT NULL
    );
    
    CREATE TABLE public.Template (
        id serial PRIMARY KEY,
        nome varchar UNIQUE NOT NULL,
        id_criador integer REFERENCES public.Usuario(id) ON DELETE CASCADE NOT NULL,
        data_criacao TIMESTAMP NOT NULL,
        extensao varchar NOT NULL,
        status BOOLEAN
    );
    
    CREATE TABLE public.TemplatesCampos (
        id_template integer REFERENCES public.Template(id) ON DELETE CASCADE NOT NULL,
        id_tipo integer REFERENCES public.Tipos(id) NOT NULL,
        ordem integer NOT NULL,
        nome_campo varchar NOT NULL,
        anulavel BOOLEAN DEFAULT FALSE NOT NULL,
        PRIMARY KEY (id_template, ordem)
    );
    
    CREATE TABLE public.Upload (
        id serial PRIMARY KEY,
        id_template integer REFERENCES public.Template(id) ON DELETE CASCADE NOT NULL,
        id_usuario integer REFERENCES public.Usuario(id) ON DELETE CASCADE NOT NULL,
        nome varchar NOT NULL,
        data TIMESTAMP NOT NULL,
        path varchar NOT NULL,
        tamanho_bytes integer NOT NULL
    );    

    CREATE TABLE public.UploadData (
        aprovados INT NOT NULL DEFAULT 0,
        reprovados INT NOT NULL DEFAULT 0
    );

    CREATE TABLE public.Log (
        id SERIAL PRIMARY KEY,
        operacao VARCHAR NOT NULL,
        tabela VARCHAR NOT NULL,
        detalhes VARCHAR NOT NULL,
        data_evento timestamp NOT NULL
    );

    INSERT INTO tipos (tipo, python_dtype) 
    VALUES 
        ('Texto', 'str'),
        ('Inteiro', 'int64'),
        ('Decimal', 'float64'),
        ('Timestamp', 'datetime64[ns]'),
        ('Booleano', 'bool');

    INSERT INTO uploaddata DEFAULT VALUES;    

    --* Usuario *--
    --Insert--
    CREATE OR REPLACE FUNCTION log_usuario_insert()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES ('Inserção', 'Usuario', NOW(), 'Usuário inserido: ' || 'ID: ' || NEW.id || ' (' || NEW.email || ')');
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_usuario_insert
    AFTER INSERT ON public.Usuario
    FOR EACH ROW
    EXECUTE FUNCTION log_usuario_insert();

    --Delete--
    CREATE OR REPLACE FUNCTION log_usuario_delete()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Exclusão', 
            'Usuario', 
            NOW(), 
            'Usuário excluído: ID: ' || COALESCE(CAST(OLD.id AS VARCHAR), '') || 
            ' - ' || COALESCE(OLD.nome, 'Nome') || 
            ' ' || COALESCE(OLD.sobrenome, 'Sobrenome') || 
            ' - Permissao: ' || COALESCE(OLD.permissao, '') || 
            ' - Email: ' || COALESCE(OLD.email, '')
        );
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;


    CREATE TRIGGER trigger_log_usuario_delete
    AFTER DELETE ON public.Usuario
    FOR EACH ROW
    EXECUTE FUNCTION log_usuario_delete();

    --Update--
    CREATE OR REPLACE FUNCTION log_usuario_update()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Atualização', 
            'Usuario', 
            NOW(), 
            'Usuário atualizado: ID: ' || COALESCE(CAST(OLD.id AS VARCHAR), '') || 
            ' - ' || COALESCE(NEW.nome, 'NomeIndefinido') || 
            ' ' || COALESCE(NEW.sobrenome, 'SobrenomeIndefinido') || 
            ' - Permissao: ' || COALESCE(NEW.permissao, '') || 
            ' - Email: ' || COALESCE(NEW.email, '')
        );
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_usuario_update
    AFTER UPDATE ON public.Usuario
    FOR EACH ROW
    EXECUTE FUNCTION log_usuario_update();


    --* Template *--
    --Insert--
    CREATE OR REPLACE FUNCTION log_template_insert()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Inserção', 
            'Template', 
            NOW(), 
            'Template inserido: ID: ' || NEW.id || 
            ' - Nome: ' || NEW.nome || 
            ' - Criador ID: ' || NEW.id_criador ||
            ' - Extensão: ' || NEW.extensao ||
            ' - Status: ' || COALESCE(NEW.status::text, 'análise')
        );
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_template_insert
    AFTER INSERT ON public.Template
    FOR EACH ROW
    EXECUTE FUNCTION log_template_insert();

    --Delete--
    CREATE OR REPLACE FUNCTION log_template_delete()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, dataEvento, detalhes)
        VALUES (
            'Exclusão', 
            'Template', 
            NOW(), 
            'Template excluído: ID: ' ||  COALESCE(CAST(OLD.id AS VARCHAR), '') || 
            ' - Nome: ' || COALESCE(OLD.nome, '') ||
            ' - Criador ID: ' || COALESCE(CAST(OLD.id_criador AS VARCHAR), '') ||
            ' - Extensão: ' || COALESCE(OLD.extensao, '') ||
            ' - Status: ' || COALESCE(CAST(OLD.status AS VARCHAR), '')
        );
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_template_delete
    AFTER DELETE ON public.Template
    FOR EACH ROW
    EXECUTE FUNCTION log_template_delete();

    --Update--
    CREATE OR REPLACE FUNCTION log_template_update()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Atualização', 
            'Template', 
            NOW(), 
            'Template atualizado: ID: ' || COALESCE(CAST(OLD.id AS VARCHAR), '') || 
            ' - Nome: ' || COALESCE(NEW.nome, 'Nome') ||
            ' - Criador ID: ' || COALESCE(CAST(NEW.id_criador AS VARCHAR), '') ||
            ' - Extensão: ' || COALESCE(NEW.extensao, '') ||
            ' - Status: ' || COALESCE(CAST(NEW.status AS VARCHAR), '')
        );
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_template_update
    AFTER UPDATE ON public.Template
    FOR EACH ROW
    EXECUTE FUNCTION log_template_update();


    --* Upload *--
    --Insert--
    CREATE OR REPLACE FUNCTION log_upload_insert()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Inserção', 
            'Upload', 
            NOW(), 
            'Upload inserido: ID: ' || NEW.id || 
            ' - Template ID: ' || NEW.id_template || 
            ' - Usuário ID: ' || NEW.id_usuario || 
            ' - Nome: ' || NEW.nome || 
            ' - Data: ' || NEW.data || 
            ' - Path: ' || NEW.path || 
            ' - Tamanho Bytes: ' || NEW.tamanho_bytes
        );
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_upload_insert
    AFTER INSERT ON public.Upload
    FOR EACH ROW
    EXECUTE FUNCTION log_upload_insert();

    --Delete--
    CREATE OR REPLACE FUNCTION log_upload_delete()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Exclusão', 
            'Upload', 
            NOW(), 
            'Upload excluído: ID: ' || COALESCE(CAST(OLD.id AS VARCHAR), '') || 
            ' - Template ID: ' || COALESCE(CAST(OLD.id_template AS VARCHAR), '') || 
            ' - Usuário ID: ' || COALESCE(CAST(OLD.id_usuario AS VARCHAR), '') || 
            ' - Nome: ' || COALESCE(OLD.nome, '') || 
            ' - Data: ' || OLD.data || 
            ' - Path: ' || OLD.path || 
            ' - Tamanho Bytes: ' || OLD.tamanho_bytes
        );
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_upload_delete
    AFTER DELETE ON public.Upload
    FOR EACH ROW
    EXECUTE FUNCTION log_upload_delete();

    --Update--
    CREATE OR REPLACE FUNCTION log_upload_update()
    RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
        VALUES (
            'Atualização', 
            'Upload', 
            NOW(), 
            'Upload atualizado: ID: ' || COALESCE(CAST(OLD.id AS VARCHAR), '') || 
            ' - Template ID: ' || COALESCE(CAST(NEW.id_template AS VARCHAR), '') || 
            ' - Usuário ID: ' || COALESCE(CAST(NEW.id_usuario AS VARCHAR), '') || 
            ' - Nome: ' || COALESCE(NEW.nome, 'Nome') || 
            ' - Data: ' || NEW.data || 
            ' - Path: ' || NEW.path || 
            ' - Tamanho Bytes: ' || NEW.tamanho_bytes
        );
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

    CREATE TRIGGER trigger_log_upload_update
    AFTER UPDATE ON public.Upload
    FOR EACH ROW
    EXECUTE FUNCTION log_upload_update();


    `;

    pool.query(query, (error, result) => {
        if (error) {
            console.error(error);
            res.status(500).json({ mensagem: 'Erro ao inicializar o banco de dados' });
        } else {
            res.status(200).json({ mensagem: 'Banco de dados inicializado com sucesso' });
        }
    });
});

export default router;
