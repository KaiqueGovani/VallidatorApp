document.addEventListener('DOMContentLoaded', async () => {
    await fetchTipos();

    //? Desnecessário
    const templates = await fetchTemplates();
    console.log(typeof (templates));

    for (let template of templates) {
        template = new Template(template);
        console.log(template);
    }// ? Desnecessário

    await popularTemplates(templates);
    await setupSelectCaminho();
});

async function fetchTemplates() {
    try {
        const response = await fetch('/templates/listar');
        const templates = await response.json();
        return templates;
    } catch (error) {
        console.error('Error:', error);
    }
}

const campoTemplates = document.getElementById("cb-templates");

async function popularTemplates(templates) {
    campoTemplates.innerHTML = "";

    try {
        for (let template of templates) {
            template = new Template(template);
            campoTemplates.innerHTML += `
            <div class="card-body d-flex justify-content-between align-items-center">
            <div class="card-text">
            <h5 class="card-title"># ${template.id} ${template.nome} - ${template.extensao.toUpperCase()}</h5>
            <p class="card-text">Criado por ${template.nome_criador} - ID: ${template.id_criador}<br>Criado em ${new Date(template.data_criacao).toLocaleDateString()}</p>
            </div>
            ${(template.status === null) ?
                    `
                <div class="card-options d-flex justify-content-between gap-4">
                <div class="form-check form-switch form-control-lg d-flex align-items-center">
                <div class="form-check-label" style="line-height: 20px">Status: Aguardando Revisão</div>   
                </div>
                <div class="d-flex gap-4 card-buttons"> 
                <a style="width: 320px; justify-content: center; background-color: #fffaaa" class="btn btn-warning d-flex coluna-responsiva" data-bs-toggle="modal"
                data-bs-target="#templateModal" id="editarTemplateBtn" data-template-id="${template.id}">
                <span>Verificar Template</span>
                <i style="font-size: 20px;" class="fa-solid fa-square-pen"></i>
                </a>
                </div>
                </div>
                `

                    : `
                <div class="card-options d-flex justify-content-between gap-4">
                <div class="form-check form-switch form-control-lg d-flex align-items-center">
                <label class="form-check-label" style="line-height: 20px" for="statusSwitch${template.id}">Status: </label>
                <input ${(template.status === true) ? 'checked' : ''} class="form-check-input mx-4 mt-0" type="checkbox" role="switch" 
                id="statusSwitch${template.id}" ${template.status == 1 ? 'checked' : ''}
                onchange="alterarStatus(${template.id}, this.checked)">
                <div class="statusText form-check-label" style="width: 65px">${template.status === true ? 'Ativo' : 'Inativo'}</div>
                </div>
                <div class="d-flex gap-4 card-buttons"> 
                <a id="downloadTemplateBtn" data-template-id="${template.id}" class="btn btn-secondary d-flex coluna-responsiva">
                <span>Download</span>
                <i style="font-size: 20px;" class="fa-solid fa-download"></i>
                </a>
                <a href="#" class="btn btn-light d-flex coluna-responsiva" onclick="uploadArquivoModal(event, ${template.id});"">
                <span>Utilizar Template</span>
                <i style="font-size: 20px;" class="fa-solid fa-folder"></i>
                </a>
                <a href="#" class="btn btn-outline-secondary d-flex coluna-responsiva" data-bs-toggle="modal"
                data-bs-target="#templateModal" id="editarTemplateBtn" data-template-id="${template.id}">
                <span>Editar</span>
                <i style="font-size: 20px;" class="fa-solid fa-square-pen"></i>
                </a>
                </div>
                </div>
                ` }
                </div>   
                `;
        }
        //Adiciona os eventos de click nos botões de download
        document.querySelectorAll("#downloadTemplateBtn")
            .forEach(btn => btn.addEventListener("click", () => {
                downloadTemplate(btn.dataset.templateId, templates)
            }));

        //Adiciona os eventos de click nos botões de editar
        document.querySelectorAll("#editarTemplateBtn")
            .forEach(btn => btn.addEventListener("click", () => {
                modalTemplate(btn.dataset.templateId, templates)
            }));

        updateFooter(templates.length);
    } catch (error) {
        console.error("Erro ao popular os templates: " + error.message);
    }
}

function modalTemplate(id, templates) { //Função para ver o template que será editado
    try {
        let template = new Template({ campos: [{}] }); //Cria um template vazio
        if (id != 0) {
            template = new Template(templates.find(template => template.id == id));
            console.log(template);
        }

        // Pega o modal
        const templateUploadForm = document.getElementById("templateUploadForm");

        // Altera o modal com os dados do template selecionado
        templateUploadForm.innerHTML = `
        <div class="container">
        <div class="row">
        <div class="col-md-6 mb-3">
        <label for="inputNomeTemplate" class="form-label">Nome do Template:*</label>
        <input type="text" class="form-control" id="inputNomeTemplate"
        placeholder="Escreva o nome do template" required value="${template.nome}">
        </div>
        <div class="col-md-6 mb-3">
        <label for="inputNCampos" class="form-label">Número de Campos no Arquivo:*</label>
        <select oninput="atualizarInputs(parseInt(value));" type="dropdown"
        class="form-control form-select" id="inputNCampos"
        placeholder="Escolha o número de campos" required>
        ${Array.from({ length: 7 }, (_, index) => `
        <option value="${index + 1}" ${index === template.campos.length - 1 ? 'selected' : ''}>${index + 1}</option>`)
                .join('')}
        </select>
        </div>
        </div>
        <div class="row">
        <div class="col-md-6 mb-3">
        <label for="csv" class="form-label">Tipo do arquivo:*</label>
        <div class="btn-group" role="group" aria-label="Basic radio toggle button group">
        <input type="radio" class="btn-check" name="btnradio" id="csv"
        autocomplete="off" ${(template.extensao == "csv") ? "checked" : ""} required>
        <label class="btn btn-outline-primary" for="csv">
        <img src="../icons/csv-icon.png" alt="">
        </label>
        
        <input type="radio" class="btn-check" name="btnradio" id="xls"
        autocomplete="off" ${(template.extensao == "xls") ? "checked" : ""}>
        <label class="btn btn-outline-primary" for="xls">
        <img src="../icons/xls-icon.png" alt="">
        </label>
        
        <input type="radio" class="btn-check" name="btnradio" id="xlsx"
        autocomplete="off" ${(template.extensao == "xlsx") ? "checked" : ""}>
        <label class="btn btn-outline-primary" for="xlsx">
        <img src="../icons/xlsx-icon.png" alt="">
        </label>
        </div>
        </div>
        </div>
        <div class="row" id="areaInputsCampos">
        ${Array.from({ length: template.campos.length }, (_, index) => `
        
        <div class="col-md-6 mb-3">
        <label for="inputNomeCampo${index + 1}" class="form-label">Nome do Campo # ${index + 1}:*</label>
        <input type="text" class="form-control" id="inputNomeCampo${index + 1}" value="${template.campos[index].nome_campo}">
        </div>
        <div class="col-md-4 mb-3">
        <label for="inputTipoCampo${index + 1}" class="form-label">Tipo do Campo # ${index + 1}:*</label>
        <select type="text" class="form-control form-select" id="inputTipoCampo${index + 1}" required>
        ${Array.from({ length: Object.keys(typeMapping).length }, (_, jndex) => `
        <option value="${jndex + 1}" ${(template.campos[index].id_tipo == jndex + 1 ? 'selected' : '')}>${typeMapping[jndex + 1]}</option>`)
                        .join('')}
        </select>
        </div>
        <div class="col-md-2 mb-3">
        <div class="d-flex flex-column align-items-center gap-1">
        <div>
        <label class="form-check-label" for="inputAnulavelCampo${index + 1}">
        Anulável 
        </label>
        <i class="bi bi-info-circle" data-bs-toggle="tooltip" data-bs-html="true"
        data-bs-title="Define se podem haver registros sem valores/nulos nessa coluna"></i>
        <br>
        </div>
        <div class="mt-2">
        <input class="mx-2 form-check-input" type="checkbox" ${template.campos[index].anulavel ? 'checked' : ''} id="inputAnulavelCampo${index + 1}">
        </div>
        </div>
        </div>`)
                .join('')}
        </div>
        </div>
        <div class="modal-footer align-content-center d-flex justify-content-between">
        <div>
        ${id == 0 ? '' : `
        <button data-bs-dismiss="modal" type="button" class="btn btn-danger justify-self-start" id="deleteTemplate" onclick="deletarTemplate(${template.id});">
        <i class="bi bi-trash"></i>
        </button>`}    
        </div>
        <div>
        <button type="reset" class="btn btn-danger" data-bs-dismiss="modal">Cancelar</button>
        <button onclick='${(id == 0) ? 'enviarTemplate(event)' : `alterarTemplate(${template.id})`};'
        type="submit" class="btn btn-primary" id="sendTemplate">Confirmar Template</button>
        </div>
        </div>
        `
    } catch (error) {
        console.error(error);
    }
}

async function alterarTemplate(id) {
    try {
        let form = document.querySelector("form");
        if (!form.checkValidity()) {
            showFeedbackToast("Erro!", "Preencha todos os campos obrigatórios.", "danger", "../icons/ban.png");
            return false;
        }
        const formData = getFormData();
        const template = new Template(formData);
        template.status = getStatus(id);
        template.id = id;

        console.log("Alterando template:\n", template);

        // Utilizando o fetch com promises para fazer o PUT
        const response = await fetch('/templates/alterar', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(template)
        });
        const data = await response.json();

        //Fecha o modal de template
        const templateModal = document.getElementById("templateModal");
        const templateModalBS = bootstrap.Modal.getInstance(templateModal);
        templateModalBS.hide();

        //Mostra o modal de feedback
        showFeedbackModal("Template Atualizado!", "Mudanças Registradas.", "Template está disponível para uso.", "../icons/badge-check.png");
        console.log("Resposta do servidor:", data.mensagem);

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await popularTemplates(await fetchTemplates());
    }
}

function getStatus(id) {
    const statusSwitch = document.getElementById(`statusSwitch${id}`);
    if (statusSwitch == null) return false;
    return statusSwitch.checked;
}

async function alterarStatus(id, status) {
    console.log(`Alterando status do template ${id} para ${status}`);
    try {
        const response = await fetch('/templates/status', {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ id: id, status: status })
        });

        const data = await response.json();
        console.log(data.mensagem); //? Alterar esse tipo de feedback para um toast?

        const statusText = document.querySelector(`#statusSwitch${id} + .statusText`);
        statusText.innerHTML = status ? 'Ativo' : 'Inativo';

    } catch (error) {
        console.log('Error:', error);
    }
}

async function deletarTemplate(id) {
    console.log(`Deletando template ${id}`);

    try {
        if (!(await showConfirmationModal("Deletar Template", "Tem certeza que deseja deletar este template? <br>Isso irá <b>deletar todos os dados relacionados a ele!</b> (uploads, etc)."))) {
            return;
        }

        const response = await fetch(`/templates/deletar/${id}`, {
            method: 'DELETE',
        })
        if (!response.ok) {
            throw new Error(response.statusText);
        }
        const data = await response.json();
        showFeedbackToast("Template Deletado!", "Template deletado com sucesso.", "success", "../icons/badge-check.png");


    } catch (error) {
        console.log("Erro:", error);
    } finally {
        await popularTemplates(await fetchTemplates());
    }
}

async function setupSelectCaminho() {
    let input = document.getElementById('inputNovoCaminho');
    const select = document.getElementById('caminhoEnvio');

    await atualizarCaminhos();

    select.add(new Option('+ Adicionar novo caminho', 'addNovo'));

    document.getElementById('caminhoEnvio').addEventListener('input', function () {
        if (this.value === 'addNovo') {
            this.classList.add('d-none');
            input.classList.remove('d-none');
            input.focus();
        }
    });

    input.addEventListener('keypress', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            if (this.value === '' || this.value === 'addNovo' || this.value.includes('/')) {
                select.value = select.options[0].value;
                showFeedbackToast('Caminho Inválido', 'Nome de caminho não permitido', 'danger', '../icons/ban.png');
            }
            else {
                input.value = input.value.trim();
                const novaOpcao = new Option(input.value, input.value);
                select.add(novaOpcao, select.options[select.options.length - 1]);
                select.value = novaOpcao.value;
                input.value = '';
                showFeedbackToast('Caminho Adicionado', 'Caminho adicionado com sucesso, faça um upload para adicionar ao banco de dados!', 'success', '../icons/badge-check.png');
            }
            input.classList.add('d-none');
            select.classList.remove('d-none');
        }
    });
}
