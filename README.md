# Итоговый проект модуля «Облачная инфраструктура. Terraform»
## 1. Описание инфраструктуры
- Инфраструктура: Описана на [Terraform](./terraform). Состояние (`state`) хранится удаленно в S3-бакете Object Storage с поддержкой блокировок `statelocking`.
- Сеть: Создан VPC, 1 публичная подсеть, настроены Security Groups (порты 22, 80, 443).
- VM, VPC и Secutiry Groups создаются в [Ссылка на main.tf](./terraform/main.tf)
- БД MySQL создается в [Ссылка на database.tf](./terraform/database.tf)
- Секретные данные для создания инфраструктуры хранятся в (`personal.auto.tfvars`)
## 2. Развертывание инфраструктуры
Команды для развертывания:
- terraform init
- terraform validate
- terraform apply
<img width="1575" height="954" alt="{27D98E63-47E0-471C-9132-F2F92C16D39E}" src="https://github.com/user-attachments/assets/401a6a4f-ac55-41b0-b748-5b3f0c555cc9" />
<img width="1691" height="264" alt="{156A40F6-42B8-4807-9173-B0CA2FD91748}" src="https://github.com/user-attachments/assets/d02641b3-95dd-4373-af28-17fc9a8490cd" />

## 3. Инициализация хоста
Docker и Docker Compose устанавливаются автоматически. Проверить статус на VM можно командами:
- docker --version
- docker compose version
- [Ссылка на cloud-init.yaml](./cloud-init.yaml)

## 4. Сборка и Container Registry
Использован многоэтапный (Multi-stage) Dockerfile. 
- [Ссылка на Dockerfile](./app/dockerfile)
- Container Registry создается в [registry.tf](./terraform/registry.tf)
<img width="1143" height="164" alt="{7E0263DC-FE64-47B1-8BA6-702E3712FA22}" src="https://github.com/user-attachments/assets/ea201a1f-eec0-43c7-b955-d7e8b0299f17" />
<img width="1443" height="474" alt="{96E6FA38-43A5-479E-BE93-DB8A80CBC05B}" src="https://github.com/user-attachments/assets/34d13f6c-71d7-44d0-b269-6ffa495b25fb" />

## 5. Запуск приложения
Приложение связано с Managed MySQL через переменные окружения в Docker Compose. [Ссылка на docker-compose.yaml](./docker-compose.yaml)
Доступ к веб-интерфейсу осуществляется по адресу: `http://51.250.3.206` (External IP)
<img width="1915" height="985" alt="{966FB6E8-B66E-4241-BE56-247854488582}" src="https://github.com/user-attachments/assets/a52a4086-e45e-414b-9bcf-a0a1fa7eec18" />
