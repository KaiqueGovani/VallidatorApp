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
    INSERT INTO public.Log(operacao, tabela, data_evento, detalhes)
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
