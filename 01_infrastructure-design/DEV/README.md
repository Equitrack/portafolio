# 🔧 Ambiente de Desarrollo (DEV)

El ambiente de desarrollo está diseñado para favorecer la iteración rápida, la experimentación y los cambios frecuentes, sin impacto en usuarios reales.

Su objetivo principal es permitir validar cambios en la infraestructura y en las aplicaciones de forma ágil, manteniendo los costos bajos y reduciendo la complejidad operativa, antes de promover dichos cambios a ambientes más controlados.

## 🧱 Principios de diseño

- Simplicidad sobre alta disponibilidad.
- Eficiencia de costos sobre redundancia. 
- Feedback rápido sobre controles estrictos. 
- Paridad lógica con producción (no paridad de escala).

## 🧩 Componentes principales

El ambiente de desarrollo incluye los siguientes componentes:

- VPC dedicada para el ambiente DEV.
- Subredes públicas y privadas.
- Bastion Host para acceso administrativo controlado.
- Cluster de Kubernetes (EKS) con capacidad reducida.
- Registro de contenedores (Amazon ECR).
- Integración con pipelines CI/CD (GitLab / Jenkins).
- Monitoreo y logging básicos.

## 🔐 Consideraciones de seguridad

Aunque es un ambiente no productivo, se aplican controles básicos de seguridad:

- Acceso restringido mediante Bastion Host y roles IAM.
- No se permite acceso directo a recursos privados desde internet.
- Uso exclusivo de datos ficticios o de prueba.
- Gestión de secretos mediante variables de entorno o servicios administrados.

## 🗺️ Diagrama de arquitectura

El siguiente diagrama representa la arquitectura lógica del ambiente de desarrollo.

> *(El diagrama se incluirá en esta sección)*

## 🔄 Flujo de despliegue

Los despliegues en DEV se realizan mediante pipelines CI/CD automatizados, utilizando el mismo flujo general que producción, con diferencias únicamente en configuración y escala.
