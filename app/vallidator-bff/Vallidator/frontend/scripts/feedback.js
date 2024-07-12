//Carregar os tooltips do Bootstrap
document.addEventListener('DOMContentLoaded', function () {
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
});

/**
 * Função de mostrar um Modal de Feedback
 * @param {string} title - Título do modal
 * @param {string} response - Mensagem do modal
 * @param {string} additionalInfo - Informação adicional do modal
 * @param {string} iconURL - URL do ícone do modal
 * @param {boolean} isLoading - Se o modal está carregando
 * @example
 * showFeedbackModal('Título', 'Mensagem', 'Informação adicional', 'https://cdn-icons-png.flaticon.com/512/1828/1828304.png');
 */
function showFeedbackModal(title, response, additionalInfo, iconURL, isLoading = false) {
    // Pega o modal se 
    let feedbackModalEl = document.getElementById("feedbackModal");
    const modalAnterior = bootstrap.Modal.getInstance(feedbackModalEl);
    const feedbackModal = modalAnterior || new bootstrap.Modal(feedbackModalEl);

    if (modalAnterior) {
        feedbackModal.hide();

        setTimeout(() => {
            const feedbackModalLabel = document.getElementById("feedbackModalLabel");
            const feedbackModalResponse = document.getElementById("feedbackModalResponse");
            const feedbackModalP = document.getElementById("feedbackModalP");
            const feedbackModalIcon = document.getElementById("feedbackModalIcon");

            // Seta o título, response e informação adicional
            feedbackModalLabel.innerText = title;
            feedbackModalResponse.innerText = response;
            feedbackModalP.innerText = additionalInfo;

            // Seta o ícone (pode ser um URL ou um elemento de Icone)
            if (isLoading) {
                feedbackModalIcon.innerHTML = `<div class="spinner-border text-success" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                           </div>`;
            } else if (iconURL) {
                feedbackModalIcon.innerHTML = `<img src="${iconURL}" alt="Icon">`;
            } else {
                feedbackModalIcon.innerHTML = '';
            }

            feedbackModal.show();
        }, 400) // Delay de 400ms para dar tempo do modal anterior fechar
    } else {
        const feedbackModalLabel = document.getElementById("feedbackModalLabel");
        const feedbackModalResponse = document.getElementById("feedbackModalResponse");
        const feedbackModalP = document.getElementById("feedbackModalP");
        const feedbackModalIcon = document.getElementById("feedbackModalIcon");

        // Seta o título, response e informação adicional
        feedbackModalLabel.innerText = title;
        feedbackModalResponse.innerText = response;
        feedbackModalP.innerText = additionalInfo;

        // Seta o ícone (pode ser um URL ou um elemento de Icone)
        if (isLoading) {
            feedbackModalIcon.innerHTML = `<div class="spinner-border text-success" role="status">
                                            <span class="visually-hidden">Loading...</span>
                                           </div>`;
        } else if (iconURL) {
            feedbackModalIcon.innerHTML = `<img src="${iconURL}" alt="Icon">`;
        } else {
            feedbackModalIcon.innerHTML = '';
        }

        // Mostra o modal
        feedbackModal.show();
    }
}

/**
 * Função de mostrar um Toast de Feedback
 * @param {string} title - Título do toast
 * @param {string} message - Mensagem do toast
 * @param {string} color - Cor do toast (primary, success, danger, warning)
 * @param {string} icon - URL do ícone do toast
 * @example
 * showFeedbackToast('Título', 'Mensagem', 'primary', 'https://cdn-icons-png.flaticon.com/512/1828/1828304.png');
 */
function showFeedbackToast(title, message, color = 'primary', icon = '') {
    const feedbackToast = document.getElementById("feedbackToast");
    const feedbackToastTitle = document.getElementById("feedbackToastTitle");
    const feedbackToastBody = document.querySelector(".toast-body")
    const feedbackToastIcon = document.getElementById("feedbackToastIcon");

    // Seta o título e mensagem
    feedbackToastTitle.innerText = title;
    feedbackToastBody.innerText = message;

    // Seta o ícone (pode ser um URL ou um elemento de Icone)
    if (icon) {
        feedbackToastIcon.innerHTML = `<img src="${icon}" alt="Icon" style="width: 21px">`;
    } else {
        feedbackToastIcon.innerHTML = '';
    }

    // Mostra o modal
    feedbackToast.classList.remove('bg-primary', 'bg-success', 'bg-danger', 'bg-warning');
    feedbackToast.classList.add(`bg-${color}`);
    if (color === 'warning') {
        feedbackToastBody.classList.add('text-dark');
    } else {
        feedbackToastBody.classList.remove('text-dark');
    }
    const toast = new bootstrap.Toast(feedbackToast);
    toast.show();
}

/** 
 * Função que cria um modal de confimação com um botão de confirmar e um de cancelar
 * Os botões retornam true e false respectivamente.
 * @param {string} title - Título do modal
 * @param {string} message - Mensagem do modal
 * @returns {Promise} - Retorna uma promise que resolve true ou false dependendo do botão clicado
 * @example
 * showConfirmationModal('Título', 'Mensagem').then((result) => {
 *     if (result) {
 *        console.log('Confirmado');
 *    }
 * }); 
 */
function showConfirmationModal(title, message) {
    // Criando o modal
    const confirmationModal = document.createElement('div');
    confirmationModal.classList.add('modal', 'fade');
    confirmationModal.id = 'confirmationModal';
    confirmationModal.tabIndex = '-1';
    confirmationModal.setAttribute('aria-labelledby', 'confirmationModalLabel');
    confirmationModal.setAttribute('aria-hidden', 'true');
    confirmationModal.innerHTML = `  
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalTitle">Modal Title</h5>
            </div>
            <div class="modal-body container px-4 px-lg-5 py-3">
                Modal message
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal" id="cancelButton">Cancelar</button>
                <button type="button" class="btn btn-primary" id="confirmButton">Confirmar</button>
            </div>
            </div>
        </div>`;
    document.body.appendChild(confirmationModal);

    return new Promise((resolve, reject) => {
        const modal = document.getElementById('confirmationModal');
        const modalTitle = document.getElementById('modalTitle');
        const modalBody = modal.querySelector('.modal-body');
        const confirmButton = document.getElementById('confirmButton');
        const cancelButton = document.getElementById('cancelButton');
    
        modalTitle.innerHTML = title;
        modalBody.innerHTML = message;
    
        // Mostra o modal
        modal.classList.add('show');
        modal.style.display = 'block';
        modal.removeAttribute('aria-hidden');
        modal.setAttribute('aria-modal', 'true');
        modal.style.backgroundColor = "rgba(0,0,0,0.5)";
    
        // Botões de confirmar/cancelar	
        confirmButton.onclick = () => {
          closeModal();
          resolve(true);
        };
        cancelButton.onclick = () => {
          closeModal();
          resolve(false);
        };
    
        // Função para remover o elemento do modal
        function closeModal() {
            // Remove o modal
            document.body.removeChild(modal);
        }
      });
}