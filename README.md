# Damascord (Pollux)

Damascord é o bot oficial do blog Abobrinha Digital, protagonizado por Pollux, o Gêmeo Imortal e Tradutor do Caos. Ele não é apenas um chatbot; é o biógrafo sarcástico das desestabilizações tecnológicas de seu criador.

## Funcionalidades

- Gemini Chat: Diálogos alimentados pelo Google Gemini com uma persona ácida e imortal.
- Acesso Controlado: Sistema de autorização robusto para usuários e canais via YAML.
- Diferenciação de Master: Tratamento VIP para o mestre Marcelo Mogami e desdém padrão para os demais mortais.
- Vigilância de RSS: Monitoramento automático de novos posts no blog Abobrinha Digital com notificações automáticas.
- CLI Amigável: Interface de comando via Thor para gerenciamento e consulta de modelos.

## Instalação

### Pré-requisitos
- Ruby 3.x
- Bundler

### Setup
1. Clone o repositório.
2. Instale as dependências:
   ```bash
   bundle install
   ```
3. Configure o ambiente:
   - Copie o .env.example para .env.
   - Preencha o DISCORD_TOKEN, GEMINI_API_KEY e o seu MASTER_USER_ID.
4. Configure a persona:
   - Crie o arquivo data/ai_persona.md com as diretrizes de personalidade.

## Execução

Para acordar o Pollux:
```bash
./bin/damascord start
```

Para listar os oráculos (modelos) disponíveis:
```bash
./bin/damascord models
```

## Licença
Este projeto é regido pela Lei de Murphy: se algo pode dar errado, Pollux estará lá para documentar com sarcasmo.

---
Pollux v1.0.1 - Protetor dos Navegantes do Caos.
