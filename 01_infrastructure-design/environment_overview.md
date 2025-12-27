# 🌍 Environment Overview

Esta sección amplía la información, describe las características generales, el nivel de riesgo y el uso esperado de los ambientes más comunes en un flujo DevOps.

Aunque este portafolio se enfoca en los ambientes de **desarrollo** y **producción**, se incluyen **QA/Test** y **Staging** con fines de referencia y para proporcionar un contexto completo del ciclo de vida de una aplicación.


### 🔧 Desarrollo (DEV)

El ambiente de desarrollo está diseñado para favorecer la iteración rápida y la experimentación. Se prioriza la flexibilidad y la reducción de costos sobre la alta disponibilidad y los controles estrictos de seguridad.

| Características reales         | Ejemplos prácticos                      |
| ------------------------------ | --------------------------------------- |
| Cambios constantes             | Terraform con menos validaciones        |
| Infraestructura de menor costo | Workloads sin alta disponibilidad       |
| Menos restricciones            | Instancias RDS de tamaño reducido       |
| Logs más verbosos              | Security Groups más permisivos          |
| Uso de datos ficticios         | Feature flags habilitados               |
| Accesos más abiertos           | Acceso controlado mediante bastion host |


### 🧪 QA / Test y Staging

Los ambientes de QA/Test y Staging funcionan como capas intermedias de validación entre desarrollo y producción. A medida que el código avanza por estos ambientes, se incrementan los controles, la estabilidad y la similitud con producción.

| Características reales               | Ejemplos prácticos               |
| ------------------------------------ | -------------------------------- |
| Infraestructura similar a producción | Pruebas de integración           |
| Datos de prueba o anonimizados       | Tests de seguridad (SAST / DAST) |
| Validaciones automatizadas           | Validación de pipelines CI/CD    |
| Pruebas funcionales                  | Smoke tests                      |
| Cambios más controlados que en DEV   | Ensayos de despliegue y rollback |
| Accesos más restringidos             | Roles IAM limitados              |

**Notas:** 
El ambiente de **staging** suele ser un clon casi exacto de producción:
- No reemplaza a otros ambientes como QA/Test.
- Debe mantener la misma topología y procesos de despliegue.
- No requiere la misma escalabilidad que producción.
- No siempre se implementa debido a consideraciones de costo.

###  🚀 Producción (PROD)

El ambiente de producción sirve a usuarios reales y debe garantizar disponibilidad, seguridad y observabilidad. Los cambios están estrictamente controlados y se realizan únicamente tras haber sido validados en ambientes previos.

| Características reales                      | Ejemplos prácticos               |
| ------------------------------------------- | -------------------------------- |
| Alta disponibilidad                         | Despliegues Multi-AZ             |
| Controles de seguridad estrictos            | WAF y políticas IAM restrictivas |
| Observabilidad completa                     | Monitoreo y alertas activas      |
| Cambios altamente controlados               | Despliegues con aprobación       |
| Acceso mínimo necesario (*least privilege*) | Gestión segura de secretos       |
| Estrategias de respaldo y recuperación      | Backups automáticos              |

### 📊 Resumen de ambientes

| Aspecto               | DEV    | QA/TEST/STAGING | PROD           |
| --------------------- | ------ | ------------ | -------------- |
| Riesgo permitido      | Alto   | Medio        | Muy bajo       |
| Costo                 | Bajo   | Medio        | Alto           |
| Nivel de seguridad    | Básico | Medio        | Alto           |
| Uso de datos reales   | ❌      | ❌ / ⚠️       | ✅              |
| Frecuencia de cambios | Alta   | Media        | Muy controlada |
| Nivel de acceso       | Amplio | Limitado     | Mínimo         |
