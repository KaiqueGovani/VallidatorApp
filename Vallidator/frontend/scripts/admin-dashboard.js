document.addEventListener('DOMContentLoaded', async function () {
    await popularTabelas();
    await desenharGraficos();
});

async function popularTabelas() {
    await popularTemplates();
    await popularUploads();
}

async function popularTemplates() {
    try {
        const response = await fetch('/templates/recentes')
        const data = await response.json();

        console.log(data);

        const tabela = document.getElementById("table-content-templates");
        tabela.innerHTML = ""; //Limpa a tabela

        for (let template of data) {
            tabela.innerHTML +=
                `
                <tr>
                    <th scope="row">${template.id}</td>
                    <td>${template.nome}</td>
                    <td>${template.extensao.toUpperCase()}</td>
                    <td>${template.id_criador}</td>
                    <td>${new Date(template.data_criacao).toLocaleDateString()}</td>
                    <th>${template.status ?
                    `<div class="text-white rounded-5 text-center p-1"
                            style="background-color: var(--Terciaria);">Ativo
                        </div>`
                    : (template.status === null ? `<div class="rounded-5 text-center p-1" style="background-color: #FFFAAA;">
                        Pendente</div>`
                        :
                        `<div class="rounded-5 text-center p-1" style="background-color: var(--Baby-Green);">
                        Inativo</div>`)
                }
                    </th>
                </tr>
                `;
        }
    } catch (error) {
        console.error("Erro ao buscar templates recentes:", error);
    }
}

async function popularUploads() {
    try {
        const response = await fetch('/arquivos/recentes')
        const data = await response.json();

        console.log(data);

        const tabela = document.getElementById("table-content-files");
        tabela.innerHTML = ""; //Limpa a tabela

        for (let arquivo of data) {
            tabela.innerHTML +=
                `
                <tr>
                    <th scope="row">${arquivo.id}</td>
                    <td>${removeTimestampFromFilename(arquivo.nome)}</td>
                    <td>${arquivo.id_template}</td>
                    <td>${arquivo.id_usuario}</td>
                    <td>${new Date(arquivo.data).toLocaleDateString()}</td>
                    <td>${humanFileSize(arquivo.tamanho_bytes, true)}</td>
                </tr>
                `;
        }
    } catch (error) {
        console.error("Erro ao buscar uploads recentes:", error);
    }
}

async function desenharGraficos() {
    await desenharGraficoTemplates();
    await desenharGraficoArquivos();
}

async function desenharGraficoTemplates() {
    const response = await fetch('/templates/data')
    const data = await response.json();

    console.log(data);

    const ctx = document.getElementById('graficoTemplates1').getContext('2d');
    const grafico1 = new Chart(ctx, {
        type: 'pie',  // ou 'doughnut' para um gráfico de rosca
        data: {
            labels: ['Ativos', 'Inativos', 'Pendentes'],
            datasets: [{
                label: 'Templates',
                data: [data.ativo, data.inativo, data.pendente],
                backgroundColor: ['#36965E', '#B4EFCC', '#FFFAAA']
            },
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
            }
        }
    });

    const ctx2 = document.getElementById('graficoTemplates2').getContext('2d');
    const grafico2 = new Chart(ctx2, {
        type: 'pie',  // ou 'doughnut' para um gráfico de rosca
        data: {
            labels: ['CSV', 'XLS', 'XLSX'],
            datasets: [{
                label: 'Formatos',
                data: [data.csv, data.xls, data.xlsx],
                backgroundColor: ['#FFAAAA', '#FADFAD', '#AABBFF']
            },
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
            }
        }
    });

}

async function desenharGraficoArquivos() {
    const response = await fetch('/arquivos/data')
    const data = await response.json();

    console.log(data);

    const ctx = document.getElementById('graficoArquivos1').getContext('2d');
    const grafico1 = new Chart(ctx, {
        type: 'pie',  // ou 'doughnut' para um gráfico de rosca
        data: {
            labels: ['Aprovados', 'Reprovados'],
            datasets: [{
                label: 'Envios',
                data: [data.aprovados, data.reprovados],
                backgroundColor: ['#36965E', '#FFAAAF']
            },
            ]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'top',
                },
            }
        }
    });
}

function removeTimestampFromFilename(filename) {
    // Extrai a extensão do arquivo
    let extensao = filename.split('.').pop();

    // Remove a extensão do arquivo
    let semExtensao = filename.split('.').slice(0, -1).join('.');

    // Encontra a penúltima ocorrência de '_'
    let ultimoIndice = semExtensao.lastIndexOf('_');
    let penultimoIndice = semExtensao.lastIndexOf('_', ultimoIndice - 1);

    // Retorna a string até a penúltima '_'
    return semExtensao.substring(0, penultimoIndice) + '.' + extensao;
}

/**
 * Format bytes as human-readable text.
 * 
 * @param bytes Number of bytes.
 * @param si True to use metric (SI) units, aka powers of 1000. False to use 
 *           binary (IEC), aka powers of 1024.
 * @param dp Number of decimal places to display.
 * 
 * @return Formatted string.
 */
function humanFileSize(bytes, si = false, dp = 1) {
    const thresh = si ? 1000 : 1024;

    if (Math.abs(bytes) < thresh) {
        return bytes + ' B';
    }

    const units = si
        ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
        : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
    let u = -1;
    const r = 10 ** dp;

    do {
        bytes /= thresh;
        ++u;
    } while (Math.round(Math.abs(bytes) * r) / r >= thresh && u < units.length - 1);


    return bytes.toFixed(dp) + ' ' + units[u];
}
