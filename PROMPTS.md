# Documentación de Prompts: Reto TechFlow

Este documento detalla la estrategia de Desarrollo Asistido por IA utilizada para acelerar el despliegue del proyecto "Despliegue Inteligente en Azure". Siguiendo la filosofía del reto, se utilizó la IA para multiplicar la velocidad de entrega asegurando la calidad y seguridad del código.

**Nota Importante:** Para este proyecto se utilizó **exclusivamente el modelo Gemini Pro 3**.

Es fundamental mencionar que cada instrucción y bloque de código generado fue rigurosamente revisado, corregido y complementado manualmente. Esto se debió a que, en ocasiones, la IA presentaba alucinaciones o proporcionaba información desactualizada que requería ajuste.

## 1. Infraestructura como Código (Terraform)

Objetivo: Crear una infraestructura modular, segura y basada en identidades gestionadas.

Prompt utilizado:
"Actúa como un Ingeniero Senior de DevSecOps. Genera código Terraform modular para el proyecto 'TechFlow'. Requerimientos:

1. Módulos para Azure Key Vault (con secreto MY_SECRET), ACR, ACA Environment, y una Container App con un Init Container (Alpine ejecutando echo "Iniciando...").
2. Incluye un Azure Container App Job programado.
3. Configura Managed Identity para que la App lea del Key Vault sin secretos hardcodeados.
4. El código debe ser compatible con escaneos de tfsec/Checkov."

## 2. Aplicación Backend (Go)

Objetivo: Desarrollar una API ligera y resiliente que cumpla con los estándares de seguridad.

Prompt utilizado:
"Actúa como Desarrollador Senior de Go. Crea una API REST que:

1. Exponga un endpoint HTTP y lea la variable de entorno MY_SECRET retornándola en un JSON.
2. Implemente Structured Logging con el paquete slog y Graceful Shutdown.
3. Proporcione un Dockerfile multi-stage basado en alpine y scratch para máxima seguridad, la aplicación debe generar un archivo compilado que se use en la fase final sin agregar dependencias adicionales o modificaciones que afecten la seguridad.
4. No debe incluir secretos ni credenciales en el código fuente."

## 3. Pipeline CI/CD (GitHub Actions)

Objetivo: Ayudar en la validación, documentación y formateo de codigo del pipeline de GitHub Actions.

Prompt utilizado:
"Actúa como un Ingeniero Senior de DevSecOps. Revisa el pipeline de GitHub Actions y realiza las siguientes acciones:

1. Valida que el pipeline sea correcto y cumpla con los requerimientos de seguridad.
2. Documenta el pipeline y explica cada paso.
3. Formatea el codigo del pipeline para que sea mas legible.
4. Asegurate de que el pipeline sea compatible con escaneos de tfsec/Checkov.
5. Asegurate de que el pipeline cumple con las fases requeridas:
   1. Seguridad IaC: Escaneo de Terraform con Checkov.
   2. Build & Scan: Construcción de imágenes y escaneo de vulnerabilidades con Trivy.
   3. Push: Subida a Azure Container Registry.
   4. Deploy: Aplicación automática de Terraform para desplegar en Azure Container Apps."

## Estrategia de IA Aplicada

Iteración: Los prompts se diseñaron para ser específicos en cuanto a seguridad (Managed Identity y Escaneos), evitando respuestas genéricas.

Validación: Cada bloque de código generado fue revisado manualmente para asegurar que cumple con el principio de menor privilegio y los requerimientos de la arquitectura serverless de TechFlow.
