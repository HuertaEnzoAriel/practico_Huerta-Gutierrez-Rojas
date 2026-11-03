# dime_el_precio – Práctico N.º 2 (Persistencia de datos)

App Flutter para gestionar **productos, clientes y pedidos**. Persistencia local con **Hive CE** (base NoSQL clave-valor).

Programación para Móviles – Tecnicatura Universitaria en Programación Web, FCEFN – UNSJ.

## Funcionalidades

- CRUD completo de productos, clientes y pedidos, leídos desde la base de datos (sin listas estáticas).
- Las listas se redibujan solas con `ValueListenableBuilder` sobre `box.listenable()`.
- Pedidos agrupados en: vencidos y con deuda, próximos a entregar, pendientes e historial.
- Registro de pagos (seña / saldo), foto del pedido y aviso por WhatsApp al cliente.
- Un cliente con pedidos no se puede borrar.

## Hive CE

| Box | Tipo | Clave |
|---|---|---|
| `clientes` | `Cliente` (typeId 0) | id |
| `productos` | `Producto` (typeId 1) | id |
| `pedidos` | `Pedido` (typeId 3) | id |

`ItemProducto` (typeId 2) va embebido dentro de cada `Pedido` con una copia del nombre y precio del producto.

- Inicialización en `lib/main.dart`: `Hive.initFlutter()`, `registerAdapters()` y `openBox<T>()`.
- Adaptadores generados con `@GenerateAdapters` en `lib/src/hive/`. Para regenerarlos: `dart run build_runner build`.
- Acceso a las cajas y operaciones de escritura (`put` / `delete` por id) en `lib/src/services/hive_service.dart`.
- Las imágenes se copian a la carpeta de documentos de la app (la ruta del picker es temporal) y se borran al eliminar o reemplazar el pedido.

## Estructura

```
lib/
  main.dart
  src/
    app.dart, routes/        navegación
    models/                  Cliente, Producto, ItemProducto, Pedido
    hive/                    adaptadores generados
    services/hive_service.dart
    pages/{clientes,productos,pedidos}/
    components/, utils/
```

## Ejecutar

```
flutter pub get
flutter run
```
