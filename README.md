# 📱 Repositório da Disciplina: Desenvolvimento para Dispositivos Móveis

Este repositório armazena os trabalhos desenvolvidos para a disciplina de Desenvolvimento para Dispositivos Móveis utilizando o framework **Flutter**.

## ⚽ Trabalho 1: App de Busca de Jogadores (API)

O primeiro trabalho consistiu na criação de um aplicativo para consulta de informações sobre futebol, consumindo uma API externa.

### ✨ Principais Funcionalidades

* **Consumo de API:** Integração com a **TheSportsDB API** para permitir a busca de jogadores e times pelo *nome*, oferecendo uma experiência de usuário mais intuitiva do que a busca por ID.
* **Interface Profissional (Dark Mode):** Design focado em "dark mode" com uma paleta de cores moderna (preto, dourado e verde neon) e fontes personalizadas (Poppins), inspirado em aplicativos de esporte.
* **Resultados em Grade:** A tela de resultados exibe os jogadores encontrados em um `GridView` (2 colunas), apresentando a foto e a posição de cada um, similar a "cards" de jogadores.
* **Experiência de Usuário (UX):**
    * **Feedback de Carregamento:** Exibição de um `CircularProgressIndicator` enquanto os dados são buscados na API.
    * **Tratamento de Erros:** Uso de `AlertDialog` (pop-ups) para informar ao usuário caso a busca falhe, não retorne resultados ou haja falha de conexão.
    * **Navegação e Detalhes:** Ao selecionar um jogador, o app navega para uma tela de detalhes (`PlayerDetailPage`) que exibe informações completas, como biografia e nacionalidade.

### Status
**Concluído.**

---

## 💾 Trabalho 2: Gerenciador de Jogadores (SQLite)

O segundo trabalho teve como objetivo a criação de um aplicativo para o gerenciamento de jogadores de futebol, com foco principal na **persistência de dados locais**.

### ✨ Principais Funcionalidades

* **CRUD Local:** Implementação completa das operações de Criar, Ler, Atualizar e Deletar (CRUD) jogadores diretamente no banco de dados do dispositivo.
* **Cadastro Avançado:**
    * Permite cadastrar jogadores com 8 atributos (Nome, Idade, Posição, Clube, etc.).
    * Integração com **Câmera e Galeria** para adicionar uma foto ao perfil do jogador.
    * Sistema de **Rating** (1 a 5 estrelas) e cálculo de **"Overall"** (nota geral), inspirado em jogos como FIFA.
* **Validação de Dados:** O sistema impede que jogadores sejam salvos com menos de 16 anos ou com um nome que já exista no banco, garantindo a integridade dos dados.
* **Design e UI "Premium":**
    * **Tela de Boas-Vindas:** Uma tela de entrada animada (com GIF e botão "pulsante") para recepcionar o usuário.
    * **Cards Estilo "FIFA":** A tela principal exibe os jogadores em uma grade (`GridView`) de cards personalizados, mostrando a foto com borda dourada, o "Overall" e o nome.
    * **Busca em Tempo Real:** A tela principal possui uma barra de busca que filtra os jogadores cadastrados instantaneamente.

### Status
**Concluído.**

---

## ⏳ Trabalho 3: (A ser definido)

O terceiro e último trabalho da disciplina ainda não foi iniciado. Esta seção será atualizada assim que o escopo e os requisitos do projeto forem definidos.

### Status
**Pendente.**