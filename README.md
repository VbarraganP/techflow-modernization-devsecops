# TechFlow Modernization DevSecOps

Solución integral para el Reto: Despliegue Inteligente en Azure. Este proyecto implementa una arquitectura serverless segura para TechFlow utilizando Azure Container Apps, Terraform como Infraestructura como Código (IaC) y prácticas de automatización DevSecOps.

## Descripción del Proyecto

El objetivo principal es modernizar la infraestructura de TechFlow mediante el despliegue de una aplicación en contenedores sobre Azure, garantizando la seguridad, escalabilidad y gestión automatizada.

La solución incluye:

- **Aplicación**: Un servicio escrito en Go que expone un endpoint HTTP y recupera secretos de manera segura.
- **Infraestructura**: Despliegue en Azure mediante Terraform, incluyendo:
  - Azure Container Apps (Entorno y Aplicación)
  - Azure Container Registry (ACR) para almacenamiento de imágenes
  - Azure Key Vault para gestión de secretos
  - Managed Identities y RBAC para seguridad sin llaves (keyless)
- **CI/CD**: Pipelines de GitHub Actions para integración y despliegue continuo.

## Requisitos Previos

Para ejecutar y desplegar este proyecto localmente o en un entorno de Azure, necesitas las siguientes herramientas:

- Azure CLI
- Terraform (versión 1.0+)
- Docker
- Go (opcional, para desarrollo local de la aplicación)

## Estructura del Repositorio

- **app/**: Código fuente de la aplicación en Go y su Dockerfile.
- **infra/**: Archivos de configuración de Terraform para la infraestructura en Azure.
- **.github/workflows/**: Definición de pipelines de CI/CD para GitHub Actions.
- **init_infrastructure.sh**: Script para inicializar y desplegar la infraestructura con Terraform.
- **setup_oidc.sh**: Script para configurar la federación de identidades (OIDC) entre GitHub y Azure.
- **destroy_infrastructure.sh**: Script para eliminar todos los recursos creados en Azure.

## Instalación y Despliegue

Sigue estos pasos para levantar el entorno completo:

1. **Iniciar sesión en Azure**:
   Ejecuta el comando `az login` en tu terminal y sigue las instrucciones para autenticarte.

2. **Inicializar Infraestructura**:
   Ejecuta el script de inicialización. Este script te solicitará un valor para el secreto que será almacenado en el Key Vault.

   ```bash
   ./init_infrastructure.sh
   ```

   Esto desplegará los recursos necesarios en Azure (Resource Group, ACR, Key Vault, Container Environment).

3. **Configurar OIDC para GitHub Actions**:
   Para permitir que GitHub Actions despliegue en tu suscripción de Azure de manera segura, ejecuta:

   ```bash
   ./setup_oidc.sh
   ```

4. **Verificar Despliegue**:
   Una vez finalizado, puedes verificar los recursos en el portal de Azure. La aplicación debería estar desplegada en Azure Container Apps.

## CI/CD (Integración y Despliegue Continuo)

El repositorio cuenta con un flujo de trabajo automatizado en `.github/workflows/deploy.yml`. Este pipeline se encarga de:

1. Construir la imagen Docker de la aplicación.
2. Escanear vulnerabilidades en la imagen (seguridad).
3. Subir la imagen al Azure Container Registry (ACR).
4. Desplegar la nueva versión en Azure Container Apps.

Cada vez que se realiza un push a la rama principal (main), este proceso se activa automáticamente.

## Limpieza de Recursos

Para eliminar todos los recursos creados y evitar costos adicionales en Azure, utiliza el script de destrucción:

```bash
./destroy_infrastructure.sh
```

Este comando ejecutará `terraform destroy` para limpiar la infraestructura.

## Notas Adicionales

- La seguridad se maneja mediante Managed Identities, lo que elimina la necesidad de gestionar credenciales de acceso explícitas en el código.
- Los secretos se inyectan en la aplicación directamente desde Azure Key Vault en tiempo de ejecución.
