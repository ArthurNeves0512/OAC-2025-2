# Laboratório 1 OAC - Plano de Tarefas

Este documento organiza as tarefas pendentes e concluídas para o Laboratório 1 da disciplina de Organização e Arquitetura de Computadores (CIC0099).

- **Equipe:** Arthur, João Pedro, Maria Fernanda, Raul e Rodrigo.
- [cite_start]**Prazo de Entrega:** 19/10/2025, às 23h55[cite: 5].

## Status Geral
- **Repositório GitHub:** Criado e configurado por Arthur.
- **Relatório (Overleaf):** Criado e compartilhado por João Pedro.

---

## ✅ Tarefas Concluídas

### Questão 1: Simulador/Montador Rars
- [cite_start]**[CONCLUÍDO] 1.1.a - Ordenação Crescente:** Análise estática (contagem de instruções, tamanho do código) e dinâmica (medição de tempo e instruções executadas com CSR) realizadas. [cite: 22]
- [cite_start]**[CONCLUÍDO] 1.1.b - Ordenação Decrescente:** Código modificado e nova análise de desempenho realizada. [cite: 21]
- [cite_start]**[CONCLUÍDO] 1.1.c - Medição com CSR:** Contadores utilizados para os itens 'a' e 'b'. [cite: 22]
- **Responsável:** João Pedro.

### Questão 2: Compilador Cruzado GCC
- [cite_start]**[CONCLUÍDO] 2.2 - Compilação com `-O0`:** Arquivo `sortc.c` compilado e modificações necessárias para o RARS identificadas. [cite: 38]
- **Responsável:** Maria Fernanda.

### Questão 3: Transformada Discreta de Fourier (DFT)
- [cite_start]**[CONCLUÍDO] 3.1 - Funções `sincos`:** Procedimento para calcular seno e cosseno via aproximação de séries foi implementado e validado. [cite: 50, 52]
- **Responsáveis:** Maria Fernanda (implementação), Rodrigo (testes e validação).

---

## ⏳ Tarefas Pendentes

### Questão 1: Simulador/Montador Rars
- **[PENDENTE] 1.2.a - Equações de Tempo de Execução:**
  - [ ] [cite_start]Escrever as equações $t_o(n)$ (vetor ordenado) e $t_i(n)$ (vetor inversamente ordenado) para o procedimento `sort`. [cite: 26]
  - **Responsável:** A definir.

- **[PENDENTE] 1.2.b - Gráfico e Análise:**
  - [ ] Coletar os tempos de execução para n = {10, 20, ..., 100} para os dois casos.
  - [ ] [cite_start]Plotar as curvas $t_o(n)$ e $t_i(n)$ em um mesmo gráfico. [cite: 26]
  - [ ] [cite_start]Comentar os resultados obtidos. [cite: 27]
  - **Responsável:** Maria Fernanda (plotagem do gráfico), Grupo (coleta de dados e análise).

### Questão 2: Compilador Cruzado GCC
- **[PENDENTE] 2.3 - Tabela Comparativa de Otimizações:**
  - [ ] [cite_start]Compilar o `sortc_mod.c` com as otimizações `-O0`, `-O3` e `-Os`. [cite: 41]
  - [ ] Medir o total de instruções executadas e o tamanho do código para cada versão.
  - [ ] [cite_start]Montar a tabela comparativa e analisar os resultados, incluindo a comparação com o `sort.s` manual. [cite: 41, 42, 43]
  - **Responsável:** A definir.

- **[PENDENTE] 2.4 - Pesquisa sobre Otimizações:**
  - [ ] [cite_start]Pesquisar e explicar em texto as diferenças entre as otimizações `-O0`, `-O1`, `-O2`, `-O3` e `-Os`. [cite: 44]
  - **Responsável:** A definir.

### Questão 3: Transformada Discreta de Fourier (DFT)
- **[PENDENTE] 3.2 e 3.3 - Finalização da DFT e `main`:**
  - [ ] [cite_start]Finalizar a implementação e depuração do procedimento `DFT`. [cite: 53]
  - [ ] Integrar o procedimento `sincos` ao cálculo principal da DFT.
  - [ ] [cite_start]Implementar a rotina `main` para inicializar os dados e chamar a `DFT`. [cite: 55]
  - [ ] [cite_start]Implementar a rotina para apresentar a saída no console conforme o formato especificado. [cite: 78]
  - **Responsáveis:** Arthur, Rodrigo, Raul.

- **[PENDENTE] 3.4 - Testes da DFT:**
  - [ ] [cite_start]Executar a DFT com os vetores `x1`, `x2`, `x3` e `x4` (com N=8) e registrar os resultados. [cite: 91, 92, 93, 94, 95]
  - **Responsável:** A definir (quem finalizar a DFT).

- **[PENDENTE] 3.5 - Análise de Desempenho da DFT:**
  - [ ] [cite_start]Medir o tempo de execução da DFT para os valores de N listados de 'a' a 'j' (8 a 44). [cite: 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107]
  - [ ] [cite_start]Calcular a frequência do processador simulado para cada caso. [cite: 108]
  - [ ] Gerar os dados para o gráfico de $N \times t_{exec}$.
  - [ ] [cite_start]Plotar o gráfico e escrever as conclusões da análise. [cite: 109, 110]
  - **Responsável:** A definir.

---

##  deliverables finais

- **[PENDENTE] Relatório Final:**
  - [ ] Adicionar todas as seções pendentes ao documento no Overleaf.
  - [ ] Revisar todo o conteúdo e formatação.
  - **Responsáveis:** Todos.

- **[PENDENTE] Vídeo de Apresentação:**
  - [ ] Agendar e gravar a apresentação no sábado (18/10).
  - [ ] [cite_start]Garantir a participação e fala de todos os membros com a câmera ligada. [cite: 130, 131]
  - [ ] [cite_start]Editar e fazer o upload do vídeo para o YouTube. [cite: 132]
  - [ ] [cite_start]Adicionar a URL clicável do vídeo ao relatório final. [cite: 129]
  - **Responsáveis:** Todos.

- **[PENDENTE] Submissão:**
  - [ ] Gerar o arquivo `.zip` contendo o relatório em `.pdf` e todos os arquivos-fonte (`.s`).
  - [ ] [cite_start]Realizar a entrega no Moodle antes do prazo final. [cite: 5]
  - **Responsável:** A definir.
