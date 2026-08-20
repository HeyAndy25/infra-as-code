# 🚀 Infraestrutura como Código (IaC) & Esteira CI/CD na AWS

![Build Status](https://img.shields.io/badge/build-passing-brightgreen)
![Terraform](https://img.shields.io/badge/Terraform-1.x-purple)
![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20ECR%20%7C%20S3-orange)
![Docker](https://img.shields.io/badge/Docker-Nginx-blue)
![Github](https://img.shields.io/badge/github-HeyAndy25-blue?logo=github)

Este foi o meu **primeiro laboratório prático** focado em unir **Infraestrutura como Código (IaC)** com **Automação de CI/CD**. 

O objetivo principal não foi apenas aprender a sintaxe das ferramentas, mas entender na prática como automatizar o provisionamento de recursos na AWS com segurança, sem depender de comandos manuais no terminal da minha máquina e evitando o gerenciamento arriscado de chaves de acesso estáticas.

---

## 🏛️ Arquitetura da Solução

```text
[Desenvolvedor] ──> Git Push / Workflow Dispatch
                          │
                          ▼
                 [GitHub Actions]
                          │ (Autenticação OIDC / Passwordless)
                          ▼
                      [AWS IAM]
               (Role: github-infra-role)
                          │
         ┌────────────────┴────────────────┐
         ▼                                 ▼
[Terraform Init / Plan / Apply]     [AWS S3 + DynamoDB]
         │                          (Backend & State Lock)
         ▼
   [Recursos AWS]
(VPC, Security Groups, EC2, ECR)
```



## 🛠️ Ferramentas & Tecnologias Aprendidas
- Containerização (Docker): Criação de imagens leves (Alpine), exposição de portas e gestão de containers Nginx.

- Infraestrutura como Código (Terraform): Declaração de recursos AWS (EC2, ECR, Security Groups, S3), gestão de variáveis e saídas (outputs).

- CI/CD & Orquestração (GitHub Actions): Criação de workflows YAML, execução de passos automatizados e triggers de disparo.

- Autenticação & Segurança (AWS OIDC & IAM): Configuração de acesso federado sem chaves estáticas, gestão de políticas de confiança (Trust Policies) e escopo de acesso por repositório.

---




## 🔧 Como Começar e Replicar
1. Clone o Repositório:
```bash
git clone https://github.com/HeyAndy25/infra-as-code.git
cd  infra-as-code
```

2. Pré-requisitos de Ambiente:
- Conta na AWS (utilizando o Free Tier).

- Docker, Terraform CLI e AWS CLI instalados localmente para validações locais.

- VS Code (ou editor de preferência) para manipulação dos arquivos .tf e .yml.

3. Dicas Gerais:
- Use VS Code para editar arquivos.

- Sempre teste localmente antes de apply/destroy.
- Limpe recursos AWS no final para evitar custos!
- Personalize: Substitua placeholders (ex.: regiões AWS, nomes de repos) com os seus.



## 🛠️ Desafios Enfrentados na Prática (Troubleshooting)

Durante a montagem deste laboratório, deparei-me com situações reais de integração e segurança que exigiram análise de logs para entender a fundo o funcionamento dos serviços:

### 1. Autenticação OIDC & Compatibilidade de Sub-claims no IAM (AssumeRoleWithWebIdentity)
* **O Problema:** Durante a execução da Action no GitHub, o pipeline falhou na etapa de autenticação com a mensagem `Not authorized to perform sts:AssumeRoleWithWebIdentity`.

* **Causa Raiz:** O GitHub atualizou a estrutura dos tokens OIDC para determinados repositórios e execuções manuais (workflow_dispatch), passando a enviar as claims sub contendo os IDs numéricos do usuário e do repositório (repo:owner@ID/repo@ID:*) em vez do formato texto tradicional (repo:owner/repo:*).
* **Ação/Resolução:** Atualizei a política de confiança (Trust Policy) da Role na AWS para suportar uma lista de condições no campo sub, incluindo tanto o formato de texto quanto a notação com IDs numéricos capturados via API REST do GitHub.

### 2. Concorrência no Estado do Terraform (*State Lock*)
* **O Problema:** Risco de corrupção do arquivo `.tfstate` caso alterações simultâneas sejam enviadas para a mesma infraestrutura.
* **Como Resolvi:** Implementei o backend remoto utilizando um bucket **Amazon S3** acompanhado de uma tabela no **DynamoDB** (`LockID`), garantindo trava de concorrência e integridade do estado.
