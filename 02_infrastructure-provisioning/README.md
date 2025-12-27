# 🏗️ Infrastructure Provisioning (Terraform)
Esta sección del portafolio se encarga del aprovisionamiento automatizado de la infraestructura en AWS. La organización del código sigue una arquitectura modular diseñada para escalar y adaptarse a diferentes necesidades de negocio.

📁 Estructura del Proyecto

```bash
├── DEV-Terraform/          # Orquestación específica para el entorno de Desarrollo
├── modules/                # Componentes atómicos y reutilizables (Building Blocks)
│   ├── vpc_base/           # Red fundamental (VPC, Subnets, IGW)
│   ├── nat_gateway/        # Conectividad de salida para subredes privadas
│   ├── bastion/            # Acceso administrativo para DEV
│   ├── vpn/                # Acceso seguro para PROD (Zero Trust)
│   └── compute/            # Instancias de aplicación y Security Groups
└── README.md
```

🎯 Filosofía de Diseño

La arquitectura de este repositorio se basa en las mejores [prácticas sugeridas por Hashicorp](https://developer.hashicorp.com/terraform/language/modules/develop/structure) (creadores de Terraform), estructurándose en tres niveles estratégicos:

- Mantenibilidad: Al desacoplar la infraestructura en módulos (Red, Cómputo, Acceso), las modificaciones se realizan de forma aislada. Si se requiere actualizar el NAT Gateway, el código de los servidores permanece intacto, reduciendo el radio de impacto (blast radius) de cualquier error.

- Reutilización (DRY - Don't Repeat Yourself): El proyecto utiliza módulos compartidos para la red base. Esto garantiza que la topología de red sea consistente en todos los entornos, eliminando la duplicación de código y errores manuales.

- Documentación Implícita: La estructura de carpetas y el uso de variables descriptivas permiten que cualquier ingeniero entienda la jerarquía de la infraestructura simplemente navegando por el árbol de directorios.

🛡️ Estrategia de Acceso por Entorno

Una de las decisiones arquitectónicas clave en este proyecto es la diferenciación del acceso según la criticidad del entorno:

- Ambiente DEV (Pragmático): Implementa una arquitectura basada en Bastion Host. Esto permite un acceso ágil y de bajo costo para desarrolladores, manteniendo la seguridad mediante el filtrado de IPs específicas.

- Ambiente PROD (Zero Trust / VPN): Evoluciona hacia una estrategia de Seguridad de Confianza Cero. En lugar de exponer un puerto SSH al internet, se implementa una VPN (Site-to-Site o Client), asegurando que solo usuarios autenticados y autorizados en la red privada puedan alcanzar los recursos críticos.

**NOTA:** 
```bash
Esta infraestructura está diseñada para entrar dentro de la Capa Gratuita de AWS (Free Tier), 
utilizando instancias t3.micro y un NAT Gateway que debe ser destruido después de las pruebas
para evitar cargos adicionales.
```

# 🚀 Guía de Inicio Rápido

**Pre-requisitos**

Antes de comenzar, asegúrate de tener instaladas las siguientes herramientas en tu sistema (instrucciones optimizadas para Fedora/RHEL):

1. AWS CLI
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure # Configura tus credenciales (Access Key, Secret Key, Región: us-east-2)
```

2. Terraform
```bash
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager addrepo --from-repofile=https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
sudo dnf install -y terraform
```

## Despliegue del Entorno (DEV)

1. Navega al directorio del entorno:
```bash
cd 02_infrastructure-provisioning/DEV-Terraform
``` 

2. Inicializa los módulos y el backend:
```bash
terraform init
```

3. Revisa los cambios planeados:
```bash
terraform plan
```

4. Aplica los cambios para crear la infraestructura:
```bash
terraform apply
```