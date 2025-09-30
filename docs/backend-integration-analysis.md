# Backend integration analysis

Este documento resume el estado del backend [`xacq/backend_nailfinderstore`](https://github.com/xacq/backend_nailfinderstore) y las adecuaciones necesarias en el frontend actual para conectarlo y operar la plataforma de forma funcional.

## Capacidades expuestas por el backend

- El módulo `CatalogModule` publica controladores REST bajo `/businesses/:businessId/service-categories` y `/businesses/:businessId/services` para listar categorías y servicios filtrando por negocio, categoría y bandera `includeInactive` según corresponda.【F:../backend_nailfinderstore/src/modules/scheduling/catalog/controllers/service-categories.controller.ts†L1-L21】【F:../backend_nailfinderstore/src/modules/scheduling/catalog/controllers/services.controller.ts†L1-L21】
- `TechniciansModule` dispone del controlador `/businesses/:businessId/technicians` que devuelve técnicos (y los servicios que atienden) con filtros opcionales por servicio e inactivos.【F:../backend_nailfinderstore/src/modules/scheduling/technicians/controllers/technicians.controller.ts†L1-L21】
- El servicio de catálogo ordena y filtra directamente contra MySQL vía TypeORM, por lo que requiere que la base de datos esté poblada con información real para responder al frontend.【F:../backend_nailfinderstore/src/modules/scheduling/catalog/catalog.service.ts†L1-L44】

> Nota: actualmente no existen controladores para autenticación, portafolio, ecommerce ni flujos de reservas; únicamente están implementadas estas consultas de catálogo y técnicos.

## Situación del frontend

- Las pantallas de dashboard consumen listas quemadas en memoria para tiendas y productos (`_stores`, `_products`) en vez de invocar un backend.【F:lib/features/dashboard/presentation/dashboard_page.dart†L12-L111】
- Los formularios de autenticación tienen TODOs pendientes y no llaman a ningún servicio remoto todavía.【F:lib/features/auth/presentation/login_page.dart†L1-L188】【F:lib/features/auth/presentation/register_page.dart†L230-L270】
- No hay una capa de cliente HTTP o providers que abstraigan llamadas al backend (no existen modelos ni repositorios relacionados con servicios, técnicos o usuarios).

## Ajustes necesarios en el frontend

1. **Configurar un cliente HTTP** (por ejemplo `dio` o `http`) y un provider que gestione la URL base y cabeceras (autenticación futura).
2. **Implementar repositorios y modelos** para consumir los endpoints disponibles:
   - `GET /businesses/:businessId/service-categories` → listar categorías para poblar filtros y secciones de catálogo.
   - `GET /businesses/:businessId/services` → reemplazar los catálogos estáticos de productos/servicios.
   - `GET /businesses/:businessId/technicians` → poblar listados de técnicos disponibles.
3. **Sincronizar el estado con Riverpod** creando `AsyncNotifier` o `FutureProvider` que lean del backend en lugar de usar listas constantes.
4. **Manejar errores y estados vacíos** (loading, sin conexión, sin datos) acorde al UX actual.
5. **Definir identificadores de negocio**: los endpoints requieren `businessId`; el frontend debe obtenerlo (por selección de tienda o por configuración) antes de lanzar las peticiones.
6. **Preparar autenticación**: aunque el backend aún no expone login, conviene dejar abstraída la capa de auth para integrar cuando exista un endpoint.

Sin estos cambios el frontend seguirá mostrando datos simulados y no podrá conectarse al backend tal como está.


## Implementación en el frontend

- Se añadió una capa de red reutilizable con `Dio` y configuración de base URL mediante parámetros de compilación para apuntar al backend en distintos entornos.【F:lib/core/network/dio_provider.dart†L1-L33】【F:lib/core/network/backend_config.dart†L1-L8】
- Se modelaron categorías, servicios y técnicos junto con un repositorio que encapsula el acceso a los endpoints REST documentados.【F:lib/features/dashboard/data/models/service_category.dart†L1-L17】【F:lib/features/dashboard/data/models/service.dart†L1-L35】【F:lib/features/dashboard/data/models/technician.dart†L1-L38】【F:lib/features/dashboard/data/repositories/catalog_repository.dart†L1-L29】
- El dashboard ahora consume estos providers de Riverpod para poblar listados dinámicos, chips de categorías y estados de carga/error en lugar de utilizar datos quemados en memoria.【F:lib/features/dashboard/application/catalog_providers.dart†L1-L21】【F:lib/features/dashboard/presentation/dashboard_page.dart†L1-L800】

