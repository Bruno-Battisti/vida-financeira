# PLANEJAMENTO DO PROJETO — VIDA FINANCEIRA

Aplicativo mobile em Flutter para aprendizado prático de Dart e Flutter.

> Este documento é uma evolução do planejamento original. As mudanças mais importantes estão marcadas com 🆕 e explicadas na seção 15.

## 1. Visão geral

O Vida Financeira é um app de controle de receitas, despesas, saldo, categorias, metas financeiras e relatórios. O projeto é, antes de tudo, um laboratório de aprendizado: cada fase introduz **um** conceito novo de Flutter/Dart, evoluindo de uma interface com dados fictícios até uma aplicação completa com persistência, gráficos e nuvem.

Regra de ouro: **não pular fases**. Não usar Riverpod antes da Fase 4, não usar banco de dados antes da Fase 5, etc. — mesmo que pareça "mais eficiente", o objetivo é aprender cada camada isoladamente.

## 2. Objetivos

- Aprender Dart na prática.
- Aprender os principais widgets e padrões de layout do Flutter.
- Aprender navegação entre telas.
- Construir formulários e validações.
- Aprender gerenciamento de estado, primeiro com `setState`, depois com Riverpod.
- Implementar persistência local com SQLite/Drift.
- Consumir APIs REST.
- Aprender autenticação e sincronização com Firebase.
- Criar gráficos e relatórios.
- 🆕 Aprender a escrever testes (unitários e de widget) como parte do fluxo normal, não como etapa final.
- Praticar arquitetura, organização de código e Git.
- Chegar a uma versão final publicável.

## 3. Stack planejada

| Camada | Tecnologia | Entra na fase |
|---|---|---|
| UI | Flutter / Dart | 1 |
| Navegação | GoRouter | 2 |
| Formulários | Flutter forms nativos | 3 |
| Estado | `setState` → Riverpod | 1 → 4 |
| Modelos | 🆕 `freezed` + `json_serializable` | 4 |
| Persistência | SQLite via Drift | 5 |
| Gráficos | 🆕 `fl_chart` | 7 |
| Nuvem | Firebase Auth + Firestore | 10 |
| API externa | `http` / `dio` | 11 |
| Testes | 🆕 `flutter_test` + `mocktail` | contínuo a partir da fase 3 |

Nem tudo entra no início — a tabela acima serve como referência de "quando" introduzir cada peça.

## 4. Funcionalidades principais

(sem alterações de escopo em relação ao original — Dashboard, Transações, Cadastro de transação, Categorias, Relatórios, Metas, Configurações — ver detalhamento no final do documento, seção 16.)

🆕 **Backlog fora do v1.0** (para não gerar scope creep): exportação/importação de dados, PIN/biometria, PDF, responsividade web/tablet. Essas entram como "Fase 12 — opcional", só depois de v1.0 estar rodando.

## 5. Estrutura inicial de telas

```
APP
├── Início (Dashboard)
├── Transações
│   ├── Receitas
│   ├── Despesas
│   └── Detalhes da transação
├── Metas
│   └── Detalhes da meta
├── Relatórios
└── Configurações
```

🆕 Navegação principal via `BottomNavigationBar` com 4 abas (Início, Transações, Metas, Relatórios) + Configurações acessível pelo ícone no AppBar. Isso já define, desde a Fase 1, que layout construir.

## 6. Modelo de dados 🆕 (corrigido)

O modelo original tinha uma inconsistência: `Transaction.category` era uma `String` solta, sem relação com a entidade `Category`. Isso quebra na hora de fazer o banco relacional (Fase 5). Corrigido abaixo:

```dart
enum TransactionType { income, expense }
enum CategoryType { income, expense }

class Category {
  final int id;
  final String name;
  final String icon;     // nome do ícone (ex: 'restaurant')
  final CategoryType type;
}

class Transaction {
  final int id;
  final String description;
  final double amount;
  final TransactionType type;
  final int categoryId;  // 🆕 referencia Category.id, não String solta
  final DateTime date;
  final String? note;
}

class Goal {
  final int id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
}

// 🆕 histórico de aportes/retiradas da meta — permite auditoria e
// é um ótimo exercício de relação 1-para-muitos no banco (Fase 5/8)
class GoalTransaction {
  final int id;
  final int goalId;
  final double amount;     // positivo = aporte, negativo = retirada
  final DateTime date;
}
```

Nas Fases 1–3 (dados fictícios, sem banco), tudo bem simular `categoryId` com uma lista mockada de `Category` em memória — o ponto é já acostumar o formato certo desde o início, para a migração para Drift (Fase 5) não exigir refatorar os modelos.

## 7. Arquitetura planejada

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── widgets/
├── features/
│   ├── dashboard/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── transactions/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── widgets/
│   │   ├── repositories/
│   │   └── providers/
│   ├── goals/
│   │   ├── models/
│   │   ├── screens/
│   │   ├── repositories/
│   │   └── providers/
│   ├── reports/
│   │   ├── screens/
│   │   └── widgets/
│   └── settings/
│       └── screens/
└── database/
    ├── database.dart
    └── tables/
```

🆕 `test/` na raiz espelhando `lib/` (ex: `test/features/transactions/...`), criado a partir da Fase 3.

## 8. Roadmap de desenvolvimento

### 🆕 Fase 0 — Setup do ambiente (antes de codar)

- Instalar Flutter SDK, rodar `flutter doctor` e resolver pendências.
- Configurar editor (VS Code ou Android Studio) com extensões Dart/Flutter.
- Rodar `flutter create vida_financeira` e confirmar que builda em um emulador/dispositivo.
- Configurar `analysis_options.yaml` com lint (ex: `flutter_lints`).
- Primeiro commit: `chore: initial flutter project setup`.

**Critério de conclusão:** app padrão do `flutter create` roda no emulador sem erros.

### Fase 1 — Fundamentos do Flutter

- Construir as telas principais com dados fictícios (listas fixas em memória).
- Aprender `StatelessWidget` e `StatefulWidget`.
- Praticar `Scaffold`, `AppBar`, `Column`, `Row`, `Container`, `Padding`, `ListView`, `Card`, `FloatingActionButton`.
- Aprender layouts e composição de widgets.
- 🆕 Implementar o `BottomNavigationBar` com as 4 abas principais (ainda sem navegação real entre telas — pode trocar o `body` do `Scaffold` com `setState`).

**Critério de conclusão:** as 4 telas principais existem, mostram dados fictícios e têm boa aparência visual (mesmo sem navegação real ainda).

### Fase 2 — Navegação

- Adicionar GoRouter.
- Definir rotas para Dashboard, Transações, Metas, Relatórios, Configurações e telas de detalhe.
- Aprender rotas, parâmetros de rota e retorno de dados entre telas.
- 🆕 Usar `ShellRoute` do GoRouter para manter o `BottomNavigationBar` persistente entre as abas.

**Critério de conclusão:** navegar entre todas as telas via GoRouter, incluindo passar um `id` de transação para a tela de detalhes.

### Fase 3 — Formulários

- Criar formulário de nova transação.
- Usar `TextEditingController`, `Form`, `GlobalKey<FormState>`, `TextFormField`, `DropdownButtonFormField` e `showDatePicker`.
- Implementar validação dos campos (obrigatórios, valor numérico > 0).
- 🆕 Tratar estados de erro e vazio na UI (ex: lista de transações vazia, erro de validação visível).
- 🆕 Escrever o primeiro teste de widget (ex: validar que o formulário não submete com campos vazios).

**Critério de conclusão:** dá para cadastrar uma transação fictícia via formulário validado e vê-la aparecer na lista (ainda em memória).

### Fase 4 — Gerenciamento de estado

- Introduzir Riverpod (`flutter_riverpod` + `riverpod_generator`/`@riverpod`).
- 🆕 Adotar `freezed` para os modelos (`Transaction`, `Goal`, `Category`) — bom gancho para aprender imutabilidade e `copyWith`.
- Criar providers para transações, metas e categorias.
- Atualizar automaticamente dashboard, saldo e listas após alterações.
- 🆕 Escrever testes unitários para os providers/notifiers.

**Critério de conclusão:** editar/excluir uma transação em qualquer tela reflete instantaneamente no Dashboard, sem `setState` manual espalhado pelo app.

### Fase 5 — Banco de dados

- Substituir dados fictícios por SQLite usando Drift.
- Implementar CRUD real para `Transaction`, `Category` e `Goal` (com `categoryId` como chave estrangeira, conforme seção 6).
- Criar tabelas, queries, relacionamentos e migrations.
- Garantir que os dados permaneçam após fechar e reabrir o aplicativo.
- 🆕 Testes de repositório rodando contra um banco Drift em memória.

**Critério de conclusão:** fechar e reabrir o app mantém todas as transações e metas cadastradas.

### Fase 6 — Dashboard real

- Calcular saldo como receitas menos despesas.
- Calcular totais mensais.
- Agregar gastos por categoria.
- Preparar dados para os relatórios.
- 🆕 Formatar valores monetários com `intl` (`NumberFormat.currency`), já pensando na Fase de configurações (moeda).

**Critério de conclusão:** todos os números do Dashboard vêm de queries reais no banco, não de cálculos fictícios.

### Fase 7 — Gráficos

- Adicionar `fl_chart`.
- Criar gráfico de gastos por categoria (pizza/donut).
- Criar gráfico de evolução mensal (linha/barra).
- Criar visualizações de receitas vs. despesas.

**Critério de conclusão:** Relatórios mostra pelo menos 2 gráficos diferentes com dados reais do banco.

### Fase 8 — Metas

- Implementar criação, edição e exclusão de metas.
- Adicionar dinheiro e retirar dinheiro (gera registro em `GoalTransaction`).
- Calcular progresso (valor e porcentagem).
- Adicionar prazo e indicador visual de evolução (`LinearProgressIndicator` ou similar).

**Critério de conclusão:** progresso de uma meta é sempre igual à soma dos `GoalTransaction` associados a ela (nunca dessincroniza).

### Fase 9 — UX e tema

- Adicionar Light Mode e Dark Mode (`ThemeMode` + Riverpod provider persistido).
- Implementar animações simples (`AnimatedContainer`, `Hero`, transições de rota).
- Criar estados vazios ilustrados para listas sem dados.
- Adicionar loading (`CircularProgressIndicator`/skeletons), `SnackBar`, `Dialog` e mensagens de erro consistentes.
- Melhorar feedback e consistência visual em todo o app.

**Critério de conclusão:** nenhuma tela deixa o usuário "sem feedback" — toda ação tem loading, sucesso ou erro visível.

### Fase 10 — Firebase

- Adicionar Firebase Authentication (email/senha, depois Google Sign-In se quiser).
- Implementar login e criação de conta.
- Adicionar Firestore.
- Sincronizar dados entre dispositivos (estratégia simples: last-write-wins por enquanto).

**Critério de conclusão:** logar em dois dispositivos/emuladores diferentes mostra os mesmos dados.

### Fase 11 — API externa

- Consumir uma API REST pública (ex: cotação do dólar).
- Aprender HTTP, JSON, `dio`/`http`, parsing e tratamento de erros de rede.

**Critério de conclusão:** uma tela do app mostra um dado vindo de uma API externa, com tratamento de erro se a rede cair.

### 🆕 Fase 12 — Recursos avançados (pós v1.0, opcional)

- Notificações e lembretes.
- Exportação para CSV e PDF.
- Importação de dados.
- PIN e biometria.
- Responsividade para tablet e web.
- Preparação para publicação nas lojas.

## 9. Controle de versões

Git usado durante todo o desenvolvimento, com commits pequenos e descritivos (Conventional Commits):

```
chore: initial flutter project setup
feat: add dashboard screen with mock data
feat: add bottom navigation
feat: add go_router navigation
feat: add transaction form with validation
feat: migrate state to riverpod
feat: add sqlite database with drift
feat: implement transaction crud
feat: calculate real dashboard totals
feat: add financial reports charts
feat: add financial goals
feat: add dark mode
feat: add firebase authentication
test: add widget tests for transaction form
```

🆕 Estratégia de branches simplificada para projeto solo (menos overhead que Git Flow completo):

- `main` — sempre estável, cada fase concluída gera um merge.
- `feature/<nome-da-fase>` — uma branch por fase ou por funcionalidade grande (ex: `feature/transactions-crud`).
- Merge para `main` via PR (mesmo sozinho, é um bom hábito) ou merge direto, à vontade.

A branch `develop` do plano original é opcional — só vale a pena se em algum momento houver trabalho paralelo em duas fases ao mesmo tempo, o que é raro num projeto de aprendizado solo.

## 10. Versionamento do produto

| Versão | Corresponde à fase | Conteúdo |
|---|---|---|
| v0.1 | Fase 1 | Protótipo — interface básica com dados fictícios |
| v0.2 | Fase 2 | Navegação — telas conectadas |
| v0.3 | Fases 3–4 | Transações — CRUD completo (em memória, já com Riverpod) |
| v0.4 | Fase 5 | Persistência — SQLite |
| v0.5 | Fase 6 | Dashboard — cálculos e estatísticas reais |
| v0.6 | Fase 8 | Metas — sistema completo |
| v0.7 | Fase 7 | Relatórios — gráficos |
| v0.8 | Fase 9 | UX — tema, animações e estados |
| v0.9 | Fase 10 | Cloud — Firebase |
| v1.0 | Fase 11 | Release — versão final (API externa incluída) |

## 11. Ordem de aprendizado

```
Dart
 ↓
Widgets Flutter
 ↓
Layouts
 ↓
Navegação
 ↓
Formulários (+ testes de widget)
 ↓
Gerenciamento de estado (setState → Riverpod)
 ↓
Modelagem imutável (freezed)
 ↓
Arquitetura (repositories)
 ↓
SQLite / Drift
 ↓
CRUD real
 ↓
Gráficos
 ↓
APIs REST
 ↓
Firebase
 ↓
Notificações e recursos avançados
 ↓
Deploy
```

## 12. Arquitetura final esperada

```
                  Flutter
                     │
                  Riverpod
                     │
               Repositories
                  /      \
              SQLite    Firebase
                           │
                         API
```

## 13. Critérios de conclusão (v1.0)

- Usuário consegue cadastrar, editar e excluir receitas e despesas.
- Dados são persistidos localmente.
- Dashboard calcula saldo e totais corretamente, a partir do banco.
- Relatórios exibem dados reais do banco em gráficos.
- Metas possuem acompanhamento de progresso consistente com o histórico de aportes.
- Tema claro e escuro funcionam e persistem entre sessões.
- App trata erros e estados vazios em todas as telas principais.
- Autenticação e sincronização via Firebase funcionam entre dispositivos.
- 🆕 Existe cobertura mínima de testes (providers + pelo menos um widget por feature).
- Projeto está organizado na arquitetura da seção 7.
- Código está versionado no Git com histórico de commits coerente.
- Versão final roda sem erros e está pronta para preparação de publicação.

## 14. Estratégia recomendada

Desenvolvimento incremental, fase por fase, sem pular etapas. Começar só com Flutter, Dart e dados fictícios (Fase 0–1). Só depois de navegação e formulários funcionando, introduzir estado (Riverpod), depois banco de dados, depois gráficos, Firebase e recursos avançados.

O objetivo não é apenas produzir o aplicativo, mas usar cada etapa para aprender um conceito novo. O mesmo projeto funciona como laboratório prático de desenvolvimento mobile.

## 15. O que mudou em relação ao plano original

1. **Fase 0 adicionada** — setup de ambiente explícito antes de qualquer código, para não travar na primeira sessão.
2. **Modelo de dados corrigido** — `Transaction` agora referencia `Category` por `id` em vez de `String` solta (evita retrabalho na Fase 5); adicionado `GoalTransaction` para histórico de metas.
3. **Testes entram desde a Fase 3**, não só como polimento final — reforça o hábito cedo.
4. **Pacotes concretos definidos por fase** (freezed, fl_chart, intl, drift) em vez de só citados no geral.
5. **Navegação com `BottomNavigationBar` + `ShellRoute`** definida explicitamente desde a Fase 1/2.
6. **Tratamento de erro/estado vazio antecipado** para a Fase 3, não deixado só para a Fase 9.
7. **Fluxo de Git simplificado** — branch `develop` tornada opcional, já que é overhead desnecessário para projeto solo.
8. **Backlog de recursos avançados isolado na Fase 12 (opcional, pós v1.0)** para não inflar o escopo do v1.0 e evitar scope creep.
9. **Cada fase agora tem um "Critério de conclusão" próprio**, além dos critérios globais da seção 13 — fica mais fácil saber quando "está pronto para avançar".

## 16. Detalhamento de funcionalidades

### 16.1 Dashboard
- Saldo disponível.
- Total de receitas do mês.
- Total de despesas do mês.
- Resumo de gastos por categoria.
- Lista das últimas transações.

### 16.2 Transações
- Listar receitas e despesas.
- Cadastrar transação.
- Editar transação.
- Excluir transação.
- Filtrar por tipo, categoria, data e valor.
- Visualizar detalhes.

### 16.3 Cadastro de transação
- Tipo: receita ou despesa.
- Descrição.
- Valor.
- Categoria.
- Data.
- Observação opcional.
- Validação dos campos.

### 16.4 Categorias

Iniciais de despesas: Alimentação, Transporte, Moradia, Lazer, Compras, Saúde, Educação, Assinaturas, Outros.

Iniciais de receitas: Salário, Freelance, Investimentos, Outros.

Em etapa posterior, o usuário poderá criar e editar suas próprias categorias.

### 16.5 Relatórios
- Gastos por categoria.
- Gastos por mês.
- Comparação entre receitas e despesas.
- Gráfico de distribuição das despesas.
- Evolução financeira ao longo do tempo.

### 16.6 Metas financeiras
- Criar meta.
- Definir valor objetivo.
- Definir prazo opcional.
- Adicionar dinheiro à meta.
- Retirar dinheiro.
- Editar e excluir meta.
- Exibir progresso em valor e porcentagem.

### 16.7 Configurações
- Tema claro e escuro.
- Moeda.
- Preferências de notificações.
- Exportação de dados (Fase 12).
- Importação de dados (Fase 12).
- Informações sobre o aplicativo.
- Conta e sincronização (Fase 10).
