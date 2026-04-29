# claude-container

Container para rodar o Claude Code em VPS com AlmaLinux (ou qualquer distro sem suporte nativo). Acesso via `docker exec` a partir da sessão SSH normal na VPS.

## Fluxo de uso

```
Você → SSH na VPS → docker exec no container → claude
```

## Estrutura

```
.
├── Dockerfile          # Node 22 slim + Claude Code
├── docker-compose.yml  # Sobe o container com volume e env vars (teste local)
├── claude-enter.sh     # Wrapper para entrar no container facilmente
└── .env.example        # Variáveis necessárias (teste local)
```

---

## 1. Conectar o repositório ao Coolify

O jeito recomendado é via **GitHub App**:

1. No painel do Coolify: **Settings → Sources → Add → GitHub App**
2. Autorize o Coolify na sua conta GitHub e selecione os repositórios que ele pode acessar
3. Feito isso, ao criar um novo serviço o repositório aparece disponível para seleção

> Se o repositório for público, você pode pular este passo e colar a URL diretamente.

---

## 2. Deploy no Coolify

1. **New Resource → Dockerfile** — selecione este repositório
2. Em **Environment Variables**, adicione (marque como secret):
   - `ANTHROPIC_API_KEY` — sua chave da Anthropic
3. Em **Persistent Storage**, adicione:
   - **Source Path** (na VPS): caminho dos seus projetos, ex: `/home/user/projects`
   - **Destination Path** (no container): `/projects`
4. Sem necessidade de expor portas
5. Deploy

A cada `git push` no repositório o Coolify faz redeploy automaticamente via webhook.

---

## 3. Preparar a VPS (apenas na primeira vez)

### Permissão para rodar Docker sem sudo

```bash
sudo usermod -aG docker $USER
# reconecte o SSH para o grupo ter efeito
```

### Instalar o wrapper de acesso

```bash
sudo cp claude-enter.sh /usr/local/bin/claude-enter
sudo chmod +x /usr/local/bin/claude-enter
```

---

## 4. Uso diário

```bash
# 1. SSH na VPS normalmente
ssh user@sua-vps.com

# 2. Entrar no container (vai direto para /projects)
claude-enter

# Ou entrar já em um subprojeto específico
claude-enter meu-projeto

# 3. Dentro do container, usar o Claude Code normalmente
claude
```

Sem o wrapper, o comando equivalente é:

```bash
docker exec -it $(docker ps --filter "label=app=claude-code" --format "{{.Names}}" | head -1) bash
```

---

## Teste local

```bash
cp .env.example .env
# edite .env com sua chave e caminho de projetos
docker compose up --build -d
./claude-enter.sh
```

---

## Segurança

- Sem SSH server no container — acesso apenas via `docker exec` (requer acesso à VPS)
- Usuário não-root (`claude`) dentro do container
- `cap_drop: ALL` — zero capacidades extras
- `ANTHROPIC_API_KEY` apenas em runtime via env var, nunca na imagem
