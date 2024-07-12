class Template { //Classe para representar um template
    constructor(data) {
        const { id, nome, id_criador, data_criacao, extensao, status, campos, nome_criador } = data;
        this.id = id;
        this.nome = nome;
        this.id_criador = id_criador; //-> Join usuario = nome_criador
        this.data_criacao = data_criacao;
        this.extensao = extensao;
        this.status = status;
        // Ordena os campos por ordem e mapeia para a classe Campo
        this.campos = campos.sort((a, b) => a.ordem - b.ordem).map(campo => new Campo(campo));
        this.nome_criador = nome_criador;
    }
}

class Campo { //Classe para representar um campo
    constructor(data) {
        const { ordem, nome_campo, id_tipo, anulavel, id_template } = data;
        this.ordem = ordem;
        this.nome_campo = nome_campo;
        this.nome_tipo = typeMapping[id_tipo];
        this.id_tipo = id_tipo;
        this.anulavel = anulavel;
    }
}

let typeMapping;

async function fetchTipos() {
    try {
        const response = await fetch('/tipos/listar');
        if (!response.ok) {
            throw new Error("Erro ao obter tipos!, HTTP status " + response.status);
        }
        data = await response.json();

        typeMapping = data.reduce((acc, tipo) => {
            acc[tipo.id] = tipo.tipo;
            return acc;
        }, {});
    } catch (error) {
        console.error('Erro ao obter tipos:', error);
    }
}

async function obterPermissao() {
    try {
        const perm = await fetch('/usuarios/obter-permissao', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        return perm.json();
    } catch (error) {
        console.error('Erro ao obter permissão:', error);
    }
}

async function downloadTemplate(template_id, templates) {
    try {
        const template = templates.find(template => template.id == template_id);
        const response = await fetch(`/templates/download`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(template)
        });

        if (!response.ok) {
            throw new Error("Erro ao baixar o template!");
        }

        const blob = await response.blob();

        // Create a URL for the Blob
        const url = window.URL.createObjectURL(blob);

        // Create a temporary <a> element to trigger the download
        const a = document.createElement("a");
        a.href = url;
        a.download = `${template.nome}.${template.extensao}`; // File name
        document.body.appendChild(a);

        // Trigger the click event on the <a> element
        a.click();

        // Clean up: remove the <a> element and revoke the URL
        document.body.removeChild(a);
        window.URL.revokeObjectURL(url);
    } catch (error) {
        console.error('Erro ao baixar o template:', error);
        showFeedbackToast("Erro ao baixar o template!", "Tente novamente mais tarde.", "danger", "../icons/ban.png");
    }
}

//Função para Atualizar os inputs de campos
function atualizarInputs(n) {
    //console.log(`Atualizando a área de inputs para ${n} inputs`);

    const areaInputsCampos = document.getElementById("areaInputsCampos");

    //Limpar a area de inputs de campos
    areaInputsCampos.innerHTML = '';

    //Adicionar os campos
    for (let i = 1; i < n + 1; i++) {
        areaInputsCampos.innerHTML += `
        <div class="col-md-6 mb-3">
            <label for="inputNomeCampo${i}" class="form-label">Nome do Campo # ${i}:<span>*</span></label>
            <input type="text" class="form-control" id="inputNomeCampo${i}">
        </div>
        <div class="col-md-4 mb-3">
            <label for="inputTipoCampo${i}" class="form-label">Tipo do Campo # ${i}:*</label>
            <select type="text" class="form-control form-select" id="inputTipoCampo${i}" required>
                ${Object.entries(typeMapping).map(([id, tipo]) => `<option value="${id}">${tipo}</option>`).join('')}
            </select>
        </div>
        <div class="col-md-2 mb-3">
            <div class="d-flex flex-column align-items-center gap-1">
                <div>
                    <label class="form-check-label" for="inputAnulavelCampo${i}">
                        Anulável 
                    </label>
                    <i class="bi bi-info-circle" data-bs-toggle="tooltip" data-bs-html="true"
                    data-bs-title="Define se podem haver registros sem valores/nulos nessa coluna"></i>
                    <br>
                </div>
                <div class="mt-2">
                    <input class="mx-2 form-check-input" type="checkbox" value="" id="inputAnulavelCampo${i}">
                </div>
            </div>
        </div>
        
        `
    }
}

function updateFooter(x) {
    const footerText = document.getElementById("footerText");
    footerText.innerHTML = `Visualizando ${x} templates.`
}

function getFormData() {
    const templateNome = document.getElementById("inputNomeTemplate").value;
    const extensao = getSelectedFileExtension();
    const nCampos = parseInt(document.getElementById("inputNCampos").value, 10);

    const campos = [];
    for (let i = 1; i <= nCampos; i++) {
        const nome_campo = document.getElementById(`inputNomeCampo${i}`).value;
        const id_tipo = document.getElementById(`inputTipoCampo${i}`).value;
        const anulavel = document.getElementById(`inputAnulavelCampo${i}`).checked;

        campos.push({
            ordem: i,
            nome_campo: nome_campo,
            id_tipo: id_tipo,
            anulavel: anulavel
        });
    }

    return {
        nome: templateNome,
        extensao: extensao,
        campos: campos
    };
}

function getSelectedFileExtension() {
    const radios = document.getElementsByName("btnradio");
    for (let radio of radios) {
        if (radio.checked) {
            return radio.id;
        }
    }
    return null; // No radio button selected
}

async function enviarTemplate() {
    try {
        let form = document.querySelector("form");
        if (!form.checkValidity()) {
            showFeedbackToast("Erro ao criar o template!", "Preencha todos os campos obrigatórios.", "danger", "../icons/ban.png");
            return false;
        }

        const formData = getFormData();
        const template = new Template(formData);

        console.log("Criando template:\n", template);

        // Utilizando await e fetch para fazer o POST
        const response = await fetch('/templates/criar', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(template)
        });

        if (!response.ok) {
            data = await response.json();
            throw new Error(data.mensagem || "Erro ao criar o template!");
        }

        showFeedbackModal("Template Criado!", "Enviado para Verificação.", "Aguardando verificação de um Administrador.", "../icons/clock.png");
        console.log("Resposta do servidor:", data.mensagem);

    }
    catch (error) {
        showFeedbackModal("Falha na Criação!", "Erro ao criar o template!", error.message, "../icons/ban.png");
    }
    finally {
        await popularTemplates(await fetchTemplates());
    }
}

function resetarForm() {
    const select = document.getElementById("inputNCampos");
    const nomeTemplate = document.getElementById("inputNomeTemplate");

    select.value = 1;
    atualizarInputs(1);

    nomeTemplate.value = "";

    const radios = document.getElementsByName("btnradio");
    for (let radio of radios) {
        radio.checked = false;
    }

}

async function enviarArquivo(id_template) {
    try {
        // Mostra o modal de carregamento
        showFeedbackModal("Enviando Arquivo!", "Enviando para o servidor.", "Aguarde...", "../icons/clock.png", true);

        const formUploadFile = document.getElementById("formUploadFile"); // ? resetar form
        const fileInput = document.getElementById("templateFile");
        const file = fileInput.files[0];
        console.log("Enviando arquivo...");
        console.log("File:", file);

        if (!file) { // Se não houver arquivo selecionado
            throw new Error("Nenhum arquivo selecionado");
        }

        const caminho = document.getElementById("caminhoEnvio").value;
        let depth = document.getElementById("depth").checked;
        depth ? depth = 1 : depth = 0;

        // Cria um FormData e adiciona o arquivo
        const formData = new FormData();
        formData.append("uploadedFile", file);
        formData.append("id_template", id_template);
        formData.append("caminho", caminho);
        formData.append("depth", depth);

        formData.forEach((value, key) => {
            console.log(key + ' = ' + value);
        });

        // Utilizando o fetch com promises para fazer o POST
        const response = await fetch('/arquivos/validar', {
            method: 'POST',
            body: formData,
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.mensagem || "Erro ao enviar o arquivo!");
        }

        showFeedbackModal("Validação Completa!", "Arquivo dentro dos padrões!", "Enviando para o repositório.", "../icons/badge-check.png");

        console.log("Resposta do servidor:", data.mensagem);

    } catch (error) {
        showFeedbackModal("Falha na Validação!", "Arquivo fora dos padrões!", error.message, "../icons/ban.png");
        console.log('Erro ao enviar arquivo:', error);
    }
}

function uploadArquivoModal(event, id_template) {
    const btn = event.target;
    const templateNome = btn.closest('.card-body').querySelector('h5').innerText;
    const templateUsado = document.getElementById("templateUsado");
    templateUsado.innerHTML = `Utilizando o template: ${templateNome} `;

    const uploadModal = new bootstrap.Modal(document.getElementById("uploadModal"));
    const uploadButton = document.getElementById("uploadButton");


    uploadButton.onclick = async () => await enviarArquivo(id_template);


    uploadModal.show();
}

async function atualizarCaminhos() {
    try {
        const response = await fetch('/arquivos/caminhos');
        const caminhos = await response.json();

        const caminhoEnvio = document.getElementById("caminhoEnvio");
        caminhoEnvio.innerHTML = "";

        for (let caminho of caminhos) {
            let value = caminho.path.replace('/', '');
            let path = caminho.path.replace('/', '');
            if (caminho.path == "/") {
                path = "Caminho Padrão"
                value = ""
            };
            caminhoEnvio.innerHTML += `
                <option value="${value}">${path}</option>
            `
        }
    } catch (error) {
        console.error('Erro ao carregar os caminhos:', error);
    }
}

async function filtrarTemplates() {
    const inputFiltro = document.getElementById("filtro");
    const filtro = inputFiltro.value.toLowerCase();
    const filterOp = document.getElementById("filterOp").value;
    const templates = await fetchTemplates();

    if (filtro == "") {
        popularTemplates(templates);
        return
    }

    const templatesFiltrados = templates.filter(template => {
        if (filterOp == "nome") {
            return template.nome.toLowerCase().includes(filtro);
        } else if (filterOp == "criador") {
            return template.nome_criador.toLowerCase().includes(filtro);
        } else if (filterOp == "id") {
            return template.id.toString().includes(filtro);
        } else if (filterOp == "extensao") {
            return template.extensao.toLowerCase().includes(filtro);
        }
    });

    showFeedbackToast("Filtro Aplicado!", `Filtrando por ${filterOp} contendo "${filtro}".`, "success", "../icons/badge-check.png");

    popularTemplates(templatesFiltrados);
}