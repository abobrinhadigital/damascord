# Changelog
Todos os erros notáveis deste projeto serão documentados neste arquivo.

O formato baseia-se em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

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
