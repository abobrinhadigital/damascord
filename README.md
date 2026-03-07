# Damascord Protocol

O **Damascord** é um bot modular para Discord focado em integração com a API Google Gemini, monitoramento de feeds RSS e automação de diálogos com persistência de contexto.

## Funcionalidades

### 1. Diálogos Inteligentes (Gemini AI)
- **Multi-turn Chat**: Suporta conversas com histórico, permitindo que a IA mantenha o contexto das últimas mensagens.
- **Persistência de Memória**: Salva o histórico de interações por canal em arquivos locais, garantindo continuidade entre reinícios.
- **Identidade Dinâmica**: A persona da IA é totalmente configurável via arquivo Markdown externo.

### 2. Monitoramento de RSS
- **Vigilância de Feed**: Verifica periodicamente URLs de feed para anunciar novos conteúdos automaticamente.
- **Geração de Comentários**: Utiliza a IA para gerar introduções ou comentários personalizados baseados no conteúdo do post detectado.
- **Cache de Notificações**: Sistema de persistência para evitar notificações duplicadas.

### 4. Integração GoiabookLM (Exclusivo Mestre)
- **Salvamento Automático**: URLs enviadas em DM pelo Mestre são automaticamente cadastradas como bookmarks no GoiabookLM.
- **Detecção Inteligente**: Se houver texto acompanhando a URL, a IA processa o comentário enquanto o link é salvo.
- **Comandos de Prefix**: Implementação via `discordrb` para consultas rápidas (!blog, !help, etc).
- **Acesso Granular**: Controle de permissões para usuários e canais via arquivos de configuração YAML.
- **Tratamento de Erros**: Mitigação de limites de taxa (Rate Limit) e falhas de API com respostas amigáveis.

## Configuração e Instalação

### Requisitos
- Ruby 3.x
- Bundler

### Configuração Inicial
1. Clone o repositório.
2. Copie o arquivo `.env.example` para `.env` e preencha as chaves:
   - `DISCORD_TOKEN`: Token do bot no Discord Developer Portal.
   - `GEMINI_API_KEY`: Chave da API do Google AI Studio.
3. Configure os arquivos em `data/` (ignorados pelo versionamento) para definir usuários, canais e a persona da IA.

### Execução
- `bundle install` para instalar dependências.
- `./bin/damascord start` para iniciar o serviço.

## Estrutura do Projeto

- `bin/`: CLI e executáveis.
- `lib/`: Implementação core (Gemini, RSS, Storage).
- `data/`: Diretório de dados persistentes, histórico e configurações locais.

---
Desenvolvido para o ecossistema [Abobrinha Digital](https://abobrinhadigital.github.io/).
