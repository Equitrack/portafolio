## 🏛️ Infrastructure Design

At the beginning of a project, it is essential to define the base architecture and deployment environments, as this separation helps reduce risk, isolate changes, apply appropriate security controls, and ensure stability, especially in the production environment.

## 🌍 Environment Strategy

The most common environments in a DevOps workflow are:
- **DEV (Development):** Where code is developed and changes occur frequently. Making mistakes and experimenting is expected.
- **QA / TEST:** An environment intended to validate that the system behaves as expected.
- **STAGING (optional):** An environment designed to be an almost exact replica of production. Not all organizations implement staging due to cost considerations.
- **PROD (Production):** The environment that serves real users. Experimentation is not performed here.

For this portfolio, **two environments will be used: development and production**.

In the **development** environment, design simplicity is prioritized.  
In the **production** environment, security, high availability, and cost control are prioritized.

In both environments, **infrastructure, security, and deployment best practices** are applied while maintaining the same code base. This approach allows real DevOps principles to be demonstrated without introducing unnecessary complexity.

[The technical differences](environment_overview.md) and detailed architecture of each environment are described in later sections, along with the corresponding diagrams.

