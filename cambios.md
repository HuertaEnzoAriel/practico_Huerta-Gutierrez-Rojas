# Cambios realizados

Resumen de los arreglos aplicados tras la revisión del proyecto.

## 1. Rutas de cliente con datos falsos

**Archivo:** `lib/src/routes/routes.dart`

**Problema:** si `/cliente` o `/editar_cliente` se abrían sin un `Cliente` como argumento, la app mostraba un cliente inventado (`Cliente 1`, teléfono `1111111111`). Ese cliente no tenía `id`, así que borrarlo hacía fallar la app. Eran restos de cuando el CRUD de clientes no existía.

**Qué hice:** reemplacé esos clientes falsos por una pantalla de error con un mensaje, igual que ya hacían las rutas de producto y pedido. También quité el código comentado que ya no hacía falta.

## 2. Editar y eliminar pedidos

**Archivo:** `lib/src/pages/pedidos/pedido_page.dart`

**Problema:** los botones de editar y eliminar solo aparecían si la fecha de entrega era futura. Un pedido vencido con deuda (el que más hay que corregir) perdía los botones. Además, el mismo día de la entrega ya desaparecían.

**Qué hice:** los botones ahora se ocultan solo si el pedido ya pasó su fecha de entrega **y** está pagado por completo, es decir, un pedido cerrado. Un pedido vencido con deuda sigue pudiéndose editar y eliminar. La comparación de fechas se hace por día, no por hora, así que el día de la entrega todavía se puede editar.

## 3. Imágenes de productos

**Archivos:** `nuevoproducto_page.dart` y `editarproducto_page.dart`

**Estado:** ya estaba resuelto en el código actual, así que no hubo cambios. Ambos formularios guardan la foto con `HiveService.guardarImagen`, que la copia a la carpeta permanente de la app. Ya no se guarda la ruta temporal del selector de imágenes.

## 5. `TextEditingController` sin `dispose`

**Archivo:** `lib/src/pages/pedidos/pedido_page.dart`

**Problema:** `_registrarPago` creaba un controller cada vez que se abría el diálogo de pago y nunca lo liberaba.

**Qué hice:** moví el diálogo a un widget propio, `_DialogoPago`. Ese widget crea el controller en `initState` y lo libera en `dispose`. Pasarlo a un widget propio evita el error de usar el controller mientras el diálogo todavía se está cerrando.

Cambios que vinieron con esto:
- El diálogo devuelve el monto con `Navigator.pop(context, monto)`, y `_registrarPago` hace el resto: actualiza la seña, guarda en Hive y muestra el aviso.
- Los errores de validación ("monto mayor a 0", "no puede superar la deuda") ahora aparecen dentro del propio diálogo como `errorText`. Antes salían en un `SnackBar` que quedaba detrás del diálogo.

## 10. Fechas de los pedidos

**Archivos:** `editarpedido_page.dart` y `nuevopedido_page.dart`

**Problemas:**
- Al editar, la fecha de entrega podía ser anterior a la fecha del encargo (el selector arrancaba en 2020).
- Las dos pantallas tenían un límite fijo en 2030, y no se podían agendar pedidos más allá.

**Qué hice:**
- En `editarpedido_page.dart`, la entrega no puede ser anterior al día del encargo. Si un pedido viejo ya tenía una fecha fuera de rango, el selector arranca en la fecha mínima, para que no falle.
- En las dos pantallas, el límite ahora es el año actual más 5, en lugar de 2030.

## Verificación

- `flutter analyze`: sin errores. Queda un aviso menor que ya existía (`_items` podría ser `final` en `nuevopedido_page.dart:26`).
- No ejecuté los tests ni probé la app en un dispositivo.
