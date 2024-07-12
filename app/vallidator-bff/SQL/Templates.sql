SELECT 
	t.id as id_template,
	t.nome as nome_template,
	t.id_criador,
	DATE(t.data_criacao),
	t.extensao,
	CASE WHEN t.status = false THEN 'Inativo' WHEN t.status = true THEN 'Ativo' ELSE 'Pendente' END
FROM public.template t
ORDER BY id;

-- FULL SELECT TEMPLATE
SELECT
    t.id AS template_id,
    t.nome AS template_nome,
    t.id_criador,
    DATE(t.data_criacao),
	t.extensao,
	CASE 
		WHEN t.status = false THEN 'Inativo' 
		WHEN t.status = true THEN 'Ativo' 
		ELSE 'Pendente' 
	END,
	json_agg(json_build_object(
        'ordem', tc.ordem,
		'tipo', tp.id,
		'nome_tipo', tp.tipo,
        'nome_campo', tc.nome_campo,
        'anulavel', tc.anulavel
    )) AS campos
FROM
    public.template t
JOIN
    public.templatescampos tc ON t.id = tc.id_template
JOIN
	public.tipos tp ON tc.id_tipo = tp.id
GROUP BY
    t.id, t.nome, t.id_criador, t.data_criacao, t.extensao, t.status
ORDER BY
    template_id;