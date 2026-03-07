# Changelog
Todos os erros notáveis deste projeto serão documentados neste arquivo.

O formato baseia-se em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [2.1.0] - 2026-03-07
### Adicionado
- **Integração com GoiabookLM:** Encaminhamento automático de URLs enviadas pelo Mestre via DM para a API do GoiabookLM.
- Novo `GoiabookClient` para comunicação com a API de bookmarks.
- Resposta automática simplificada para economia de tokens quando apenas uma URL é enviada.

### Corrigido
- `FeedManager`: Silenciamento de notificações automáticas de posts antigos na primeira inicialização do bot.
- `Bot`: Correção de processos duplicados e limpeza de handlers redundantes.

## [2.0.7] - 2026-03-05
### Corrigido
- `Bot`: Remoção de handlers de eventos sobrepostos que causavam respostas duplicadas em comandos de prefixo.

## [2.0.6] - 2026-03-05
### Corrigido
- `Commands`: Adicionada proteção contra registro duplicado de comandos (corrigindo respostas duplas no `!help`).

## [2.0.5] - 2026-03-05
### Corrigido
- `FeedManager`: Remoção de método duplicado e correção definitiva da visibilidade de `fetch_latest_post` como público.

## [2.0.4] - 2026-03-05
### Corrigido
- `FeedManager`: Método `fetch_latest_post` tornado público para que o comando `!blog` possa acessá-lo (corrigindo `NoMethodError`).

## [2.0.3] - 2026-03-05
### Corrigido
- Comando `!blog`: Melhoria na extração da URL do post para maior compatibilidade com diferentes formatos de feed.
- Log de erro interno no console para falhas na consulta ao RSS via comando.

## [2.0.2] - 2026-03-05
### Corrigido
- Tratamento robusto de erros HTTP (400, 401, 429, 500) na comunicação com o Gemini.
- Limpeza de código e correção de lints no `GeminiClient` e `version.rb`.

## [2.0.1] - 2026-03-05
### Corrigido
- Mitigação de Erro 429 (Too Many Requests) com redução da janela de memória para 5 turnos.

## [2.0.0] - 2026-03-05
### Adicionado
- **Sistema de Memória Persistente:** O Pollux agora lembra das últimas 10 interações em cada canal, mantendo o contexto da conversa mesmo após reinícios.
- Novo `MemoryManager` para persistência em disco (`data/history/`).
- Atualização do `GeminiClient` para suporte a conversas multi-turn.

## [1.1.0] - 2026-03-05
### Adicionado
- Bot Pollux totalmente funcional: chat, controle de acesso, monitoramento de blog e ajuda.
- Estabilização definitiva das menções de usuário com proteção de privacidade (IDs ocultos).

## [1.0.9] - 2026-03-05
### Corrigido
- Remoção definitiva de backticks exemplares na persona para evitar confusão imitativa da IA.

## [1.0.8] - 2026-03-05
### Corrigido
- Proibição estrita de backticks/blocos de código em menções (`<@ID>`) para garantir a renderização visual no Discord.

## [1.0.7] - 2026-03-05
### Adicionado
- Logs de console para as respostas da IA antes do envio (debugging de menções).

## [1.0.6] - 2026-03-05
### Corrigido
- Refinamento das instruções de menção para evitar falhas de renderização (exibição de `<@ID>` como texto).

## [1.0.5] - 2026-03-05
### Corrigido
- Proibição de exibição de IDs numéricos nas respostas da IA para maior privacidade e estética.
- Refinamento de menções orgânicas via `<@ID>`.

## [1.0.4] - 2026-03-05
### Adicionado
- Suporte a menções reais de usuários nas respostas da IA usando a sintaxe `<@ID>`.

## [1.0.3] - 2026-03-05
### Adicionado
- Comando `!help` com listagem dinâmica de permissões (Master vs Mortal).

## [1.0.2] - 2026-03-05
### Adicionado
- Comando `!blog` para consultar manualmente o último post do blog.

## [1.0.1] - 2026-03-05
### Adicionado
- Monitoramento automático de novos posts no blog via RSS (`/feed.xml`) a cada 1 hora.
- Notificações automáticas ácidas geradas pelo Gemini nos canais autorizados.
- Cache do último post monitorado em `data/last_post.yml`.
- Identificação de usuários Master vs Mortais via ID do Discord.

### Corrigido
- Sanitização de dados do RSS (remoção de tags HTML do título e resumo).
- Suporte a contexto de usuário opcional no `GeminiClient` para notificações automáticas limpas.
- Correção de bugs na URL do Gemini (remoção automática de `models/`).
- Interpolação correta das mensagens de erro da API do Gemini.

## [1.0.0] - 2026-03-05
- Primeira versão estável com resposta funcional via Discord.
- Estrutura modular: `Bot`, `Config`, `GeminiClient`, `AccessControl`.
- Integração com Google Gemini API para respostas automáticas.
- Sistema de controle de acesso (Allowlist) para usuários e canais via YAML.
- Comandos administrativos de prefixo: `!user_register`, `!channel_register`, etc.
- CLI via Thor com comandos `start` e `models`.
