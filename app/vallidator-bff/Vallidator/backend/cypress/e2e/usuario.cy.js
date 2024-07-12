/// <reference types="cypress" />

describe('Testa as funções do usuário', () => {
  context('Usuario permissao criar', () => {
    beforeEach(() => {
      cy.fixture('usuarios/criar').as('usuario').then((usuario) => {
        cy.login(usuario.email, usuario.senha)
      })
    })

    afterEach(() => {
      cy.contains(/Sair/i).click()
      cy.url().should('contain', '/login')
    })

    it(`Deve redirecionar para /templates.
        Não deve poder utilizar templates.
        Deve poder adicionar templates.`, () => {
      //Deve redirecionar para /templates
      cy.url().should('contain', '/templates')
      //Não deve poder utilizar templates
      cy.get('a.uploadArquivoBtn').should('not.be.visible')
      //Deve poder adicionar templates
      cy.contains(/Adicionar Novo Template/i).should('be.visible')
    })

    it('Adicionando um template CSV', () => {
      //Adiciona o template
      cy.get('#adicionarTemplateBtn').click()
      cy.get('#inputNomeTemplate').type('Template Teste')
      cy.get('#inputNCampos').select('2')
      cy.get('.btn-group').get('[for="csv"] > img').click()
      cy.get('#inputNomeCampo1').type('Nome')
      cy.get('#inputNomeCampo2').type('Idade')
      cy.get('#inputTipoCampo1').select('Texto')
      cy.get('#inputTipoCampo2').select('Inteiro')
      cy.get('#inputAnulavelCampo2').click()
      cy.intercept('POST', '/templates/criar').as('postTemplate')
      cy.get('#sendTemplate').click()
      cy.wait('@postTemplate').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })
      cy.contains(/Aguardando verificação de um administrador/i).should('be.visible')
      cy.wait(400)
      cy.get('#feedbackModal').find('button.btn-close').click()
      cy.contains('.card-title', 'Template Teste')
        .closest('.card-body')
        .find('.form-check-label')
        .contains('Aguardando Revisão')
        .should('be.visible');
    })

    it('Alterar informações do usuário', () => {
      cy.contains(/Minha conta/i).click()
      //Altera o nome
      cy.get('#nome').clear().type('Nome')
      //Altera o sobrenome
      cy.get('#sobrenome').clear().type('Sobrenome')
      //Altera o telefone
      cy.get('#telefone').clear().type('123456789')

      //Verifica se os campos estão desabilitados
      cy.get('#email').should('be.disabled')
      cy.get('#idUsuario').should('be.disabled')
      cy.get('#permissao').should('be.disabled')

      //Salva as alterações
      cy.get('#salvarBtn').click()

      //Verifica se as alterações foram salvas
      cy.contains(/Dados Atualizados/i).should('be.visible')

      // Retorna os valores para os originais
      cy.fixture('usuarios/criar').as('usuario').then((usuario) => {
        cy.get('#nome').clear().type(usuario.nome)
        cy.get('#sobrenome').clear().type(usuario.sobrenome)
        cy.get('#telefone').clear().type(usuario.telefone)
        cy.get('#salvarBtn').click()
        cy.contains(/Dados Atualizados/i).should('be.visible')
      })
    })

  })

  context('Usuario permissao upload', () => {
    beforeEach(() => {
      cy.fixture('usuarios/upload').as('usuario').then((usuario) => {
        cy.login(usuario.email, usuario.senha)
      })
    })

    afterEach(() => {
      cy.contains(/Sair/i).click()
      cy.url().should('contain', '/login')
    })

    it(`Deve redirecionar para /templates.
        Deve poder utilizar templates.
        Não deve poder adicionar templates.`, () => {
      //Deve redirecionar para /templates
      cy.url().should('contain', '/templates')
      //Deve poder utilizar templates
      cy.get('a.uploadArquivoBtn').should('be.visible')
      //Não deve poder adicionar templates
      cy.contains(/Adicionar Novo Template/i).should('not.be.visible')
    })

    it('Faz o upload de um arquivo correto para o template Clientes', () => {
      //Validação superficial
      cy.contains(/Clientes/i).closest('.card-body').find('a.uploadArquivoBtn').click()
      cy.get('#templateFile').selectFile('../../test/csv/clientes_correto.csv', { action: 'drag-drop' })
      cy.wait(400)
      cy.get('#uploadButton').click()
      cy.contains(/arquivo dentro dos padrões/i).should('be.visible')
      cy.wait(400)
      cy.get('#feedbackModal > .modal-dialog > .modal-content > .modal-header > .btn-close').click()

      //Validação completa
      cy.contains(/Clientes/i).closest('.card-body').find('a.uploadArquivoBtn').click()
      cy.get('#templateFile').selectFile('../../test/csv/clientes_correto.csv', { action: 'drag-drop' })
      cy.get('#depth').click()
      cy.wait(400)
      cy.get('#uploadButton').click()
      cy.contains(/arquivo dentro dos padrões/i).should('be.visible')
      cy.wait(400)
      cy.get('#feedbackModal > .modal-dialog > .modal-content > .modal-header > .btn-close').click()
    })

    it('Faz o upload de um arquivo incorreto para o template Clientes', () => {
      //Validação superficial
      cy.contains(/Clientes/i).closest('.card-body').find('a.uploadArquivoBtn').click()
      cy.get('#templateFile').selectFile('../../test/csv/clientes_incorreto_50k_linhas.csv', { action: 'drag-drop' })
      cy.wait(400)
      cy.intercept('POST', '/arquivos/validar').as('postTemplate')
      cy.get('#uploadButton').click()
      cy.wait('@postTemplate', { timeout: 15000 }).then((intercept) => {
        expect(intercept.response.statusCode).to.equal(400)
      })
      cy.contains(/Erro ao converter coluna/i).should('be.visible')
      cy.wait(400)
      cy.get('#feedbackModal > .modal-dialog > .modal-content > .modal-header > .btn-close').click()

      //Validação completa
      cy.contains(/Clientes/i).closest('.card-body').find('a.uploadArquivoBtn').click()
      cy.get('#templateFile').selectFile('../../test/csv/clientes_incorreto_50k_linhas.csv', { action: 'drag-drop' })
      cy.get('#depth').click()
      cy.wait(400)
      cy.intercept('POST', '/arquivos/validar').as('postTemplate')
      cy.get('#uploadButton').click()
      cy.wait('@postTemplate', { timeout: 15000 }).then((intercept) => {
        expect(intercept.response.statusCode).to.equal(400)
      })
      cy.contains(/Erro ao converter '/i).should('be.visible')
      cy.wait(400)
      cy.get('#feedbackModal > .modal-dialog > .modal-content > .modal-header > .btn-close').click()
    })
  })

  context('Usuario permissao admin', () => {
    beforeEach(() => {
      cy.fixture('usuarios/admin').as('usuario').then((usuario) => {
        cy.login(usuario.email, usuario.senha)
      })
    })

    afterEach(() => {
      cy.contains(/Sair/i).click()
      cy.url().should('contain', '/login')
    })

    it(`Deve redirecionar para /dashboard. 
        E deve possuir todas as permissões`, () => {
      //Deve redirecionar para /dashboard
      cy.url().should('contain', '/dashboard')
      
      //Deve poder utilizar templates
      cy.visit('admin/templates')
      cy.wait(1000)
      cy.contains(/Utilizar Template/i).should('be.visible')
      
      //Deve poder adicionar templates
      cy.contains(/Adicionar Novo Template/i).should('be.visible')

      //Deve poder editar templates
      cy.get('#editarTemplateBtn').should('be.visible')

      //Deve poder verificar templates
      cy.contains(/Verificar Template/i).should('be.visible')

      //Deve poder alterar status de um template
      cy.contains(/Clientes/i).closest('.card-body').as('cardClientes')
      cy.get('@cardClientes').find('input.form-check-input').should('be.visible')
      cy.get('@cardClientes').contains(/\bAtivo\b/i).should('be.visible')
      cy.intercept('PATCH', '/templates/status').as('statusTemplate')
      cy.get('@cardClientes').find('input.form-check-input').click()
      cy.wait('@statusTemplate').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })
      cy.get('@cardClientes').contains(/Inativo/i).should('be.visible')
      cy.get('@cardClientes').find('input.form-check-input').click()
      cy.wait('@statusTemplate').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })
      cy.get('@cardClientes').contains(/\bAtivo\b/i).should('be.visible')
    })

    it('Aprovando, editando e excluindo um template', () => {
      cy.visit('/templates')
      cy.wait(1000)
      //Aprova o template criado pelo usuario
      cy.contains(/Template Teste/i).closest('.card-body').contains(/verificar template/i).click()
      cy.wait(400)
      cy.contains(/Confirmar Template/i).click()
      cy.wait(400)
      cy.contains(/Template Teste/i).closest('.card-body').contains(/inativo/i).should('be.visible')

      //Edita o template
      cy.contains(/Template Teste/i).closest('.card-body').contains(/editar/i).click()
      cy.wait(400)
      cy.get('#inputNomeTemplate').clear().type('Template Teste Editado')
      cy.get('.btn-group').get('label[for="xlsx"]').click()
      cy.get('#inputNCampos').select('3')
      cy.get('#inputNomeCampo1').clear().type('Nome')
      cy.get('#inputNomeCampo2').clear().type('Idade')
      cy.get('#inputNomeCampo3').clear().type('Telefone')
      cy.get('#inputTipoCampo1').select('Texto')
      cy.get('#inputTipoCampo2').select('Inteiro')
      cy.get('#inputTipoCampo3').select('Texto')
      cy.get('#inputAnulavelCampo2').click()
      cy.get('#inputAnulavelCampo3').click()
      cy.intercept('PUT', 'templates/alterar').as('putTemplate')
      cy.contains(/Confirmar Template/i).click()
      cy.wait('@putTemplate').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })

      //Exclui o template
      cy.contains(/Template Teste Editado/i).closest('.card-body').contains(/editar/i).click()
      cy.wait(400)
      cy.get('#deleteTemplate').click()
      cy.wait(400)
      cy.contains(/Tem certeza que deseja deletar este template?/i).should('be.visible')
      cy.intercept('DELETE', 'templates/deletar/*').as('deleteTemplate')
      cy.contains(/Tem certeza que deseja deletar este template?/i).closest('.modal-content').contains(/Confirmar/i).click()
      cy.wait('@deleteTemplate').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(200)
      })
      cy.contains(/Template Deletado/i).should('be.visible')
    })

    it('Adicionando, editando e excluindo um usuários', () => {
      cy.visit('admin/usuarios')
      cy.wait(1000)
      cy.get('.page-title').contains(/Usuários/i).should('be.visible')
      
      //Adiciona um usuário
      cy.contains(/Adicionar Novo Usuário/i).click()
      cy.wait(400)
      cy.get('#conviteEmail').type('teste@teste')
      cy.contains(/Enviar convite/i).click()
      cy.contains(/convite enviado!/i, { timeout: 5000 }).should('be.visible')
      cy.get('body').type('{esc}')
      
      cy.contains(/teste@teste/i).closest('.card-body').as('cardTeste')
      
      //Altera as permissoes desse usuário
      cy.intercept('PATCH', '/usuarios/permissao').as('permUsuario')
      //Upload
      cy.get('@cardTeste').find('.form-check-input').eq(0).click()
      cy.wait('@permUsuario').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })
      //Criar
      cy.get('@cardTeste').find('.form-check-input').eq(1).click()
      cy.wait('@permUsuario').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })
      //Admin
      cy.get('@cardTeste').find('.form-check-input').eq(2).click()
      cy.wait('@permUsuario').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })

      //Edita as informações do usuário
      cy.get('@cardTeste').contains(/editar/i).click()
      cy.wait(400)
      cy.get('#nome').clear().type('Nome')
      cy.get('#sobrenome').clear().type('Sobrenome')
      cy.get('#telefone').clear().type('123456789')
      cy.get('#email').clear().type('teste@testeEditado')
      cy.intercept('PUT', '/usuarios/dados').as('putUsuarioDados')
      cy.get('#editarUsuarioBtn').click()
      cy.wait('@putUsuarioDados').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(201)
      })
      cy.contains(/Usuário editado com sucesso/i).should('be.visible')
      cy.wait(400)
      cy.get('body').type('{esc}')

      //Exclui o usuário
      cy.get('@cardTeste').contains(/editar/i).click()
      cy.wait(400)
      cy.get('#deletarUsuarioBtn').click()
      cy.wait(400)
      cy.contains(/Tem certeza que deseja deletar este usuário?/i).should('be.visible')
      cy.intercept('DELETE', 'usuarios/deletar').as('deleteUsuario')
      cy.contains(/Tem certeza que deseja deletar este usuário?/i).closest('.modal-content').contains(/Confirmar/i).click()
      cy.wait('@deleteUsuario').then((intercept) => {
        expect(intercept.response.statusCode).to.equal(204)
      })
      cy.contains(/Usuário Deletado/i).should('be.visible')
      cy.wait(400)
      cy.get('body').type('{esc}')

    })
  })
})