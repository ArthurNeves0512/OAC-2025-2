# Laboratório 1 OAC - Plano de Tarefas

Este documento organiza as tarefas pendentes e concluídas para o Laboratório 1 da disciplina de Organização e Arquitetura de Computadores (CIC0099).

- **Equipe:** Arthur, João Pedro, Maria Fernanda, Raul e Rodrigo.
- **Prazo de Entrega:** 19/10/2025, às 23h55.

## Status Geral
- **Repositório GitHub:** Criado e configurado.
- **Relatório (Overleaf):** Criado e compartilhado.

---

## ✅ Tarefas Concluídas

### Questão 1: Simulador/Montador Rars
- **[CONCLUÍDO] 1.1.a - Ordenação Crescente:** Análise estática (contagem de instruções, tamanho do código) e dinâmica (medição de tempo e instruções executadas com CSR) realizadas.
- **[CONCLUÍDO] 1.1.b - Ordenação Decrescente:** Código modificado e nova análise de desempenho realizada.
- **[CONCLUÍDO] 1.1.c - Medição com CSR:** Contadores utilizados para os itens 'a' e 'b'.

### Questão 2: Compilador Cruzado GCC
- **[CONCLUÍDO] 2.2 - Compilação com `-O0`:** Arquivo `sortc.c` compilado e modificações necessárias para o RARS identificadas.

### Questão 3: Transformada Discreta de Fourier (DFT)
- **[CONCLUÍDO] 3.1 - Funções `sincos`:** Procedimento para calcular seno e cosseno via aproximação de séries foi implementado e validado.

---

## ⏳ Tarefas Pendentes

### Questão 1: Simulador/Montador Rars
- **[PENDENTE] 1.2.a - Equações de Tempo de Execução:**
  - [ ] Escrever as equações $t_o(n)$ (vetor ordenado) e $t_i(n)$ (vetor inversamente ordenado) para o procedimento `sort`.

- **[PENDENTE] 1.2.b - Gráfico e Análise:**
  - [ ] Coletar os tempos de execução para n = {10, 20, ..., 100} para os dois casos.
  - [ ] Plotar as curvas $t_o(n)$ e $t_i(n)$ em um mesmo gráfico.
  - [ ] Comentar os resultados obtidos.

### Questão 2: Compilador Cruzado GCC
- **[PENDENTE] 2.3 - Tabela Comparativa de Otimizações:**
  - [ ] Compilar o `sortc_mod.c` com as otimizações `-O0`, `-O3` e `-Os`.
  - [ ] Medir o total de instruções executadas e o tamanho do código para cada versão.
  - [ ] Montar la tabela comparativa e analisar os resultados, incluindo a comparação com o `sort.s` manual.

- **[PENDENTE] 2.4 - Pesquisa sobre Otimizações:**
  - [ ] Pesquisar e explicar em texto as diferenças entre as otimizações `-O0`, `-O1`, `-O2`, `-O3` e `-Os`.

### Questão 3: Transformada Discreta de Fourier (DFT)
- **[PENDENTE] 3.2 e 3.3 - Finalização da DFT e `main`:**
  - [ ] Finalizar a implementação e depuração do procedimento `DFT`.
  - [ ] Integrar o procedimento `sincos` ao cálculo principal da DFT.
  - [ ] Implementar a rotina `main` para inicializar os dados e chamar a `DFT`.
  - [ ] Implementar a rotina para apresentar a saída no console conforme o formato especificado.

- **[PENDENTE] 3.4 - Testes da DFT:**
  - [ ] Executar a DFT com os vetores `x1`, `x2`, `x3` e `x4` (com N=8) e registrar os resultados.

- **[PENDENTE] 3.5 - Análise de Desempenho da DFT:**
  - [ ] Medir o tempo de execução da DFT para os valores de N listados de 'a' a 'j' (8 a 44).
  - [ ] Calcular a frequência do processador simulado para cada caso.
  - [ ] Gerar os dados para o gráfico de $N \times t_{exec}$.
  - [ ] Plotar o gráfico e escrever as conclusões da análise.

---

##  Deliverables Finais

- **[PENDENTE] Relatório Final:**
  - [ ] Adicionar todas as seções pendentes ao documento no Overleaf.
  - [ ] Revisar todo o conteúdo e formatação.

- **[PENDENTE] Vídeo de Apresentação:**
  - [ ] Agendar e gravar a apresentação.
  - [ ] Garantir a participação e fala de todos os membros com a câmera ligada.
  - [ ] Editar e fazer o upload do vídeo para o YouTube.
  - [ ] Adicionar a URL clicável do vídeo ao relatório final.

- **[PENDENTE] Submissão:**
  - [ ] Gerar o arquivo `.zip` contendo o relatório em `.pdf` e todos os arquivos-fonte (`.s`).
  - [ ] Realizar a entrega no Moodle antes do prazo final.
