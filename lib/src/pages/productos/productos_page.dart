import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../components/visorimagen_page.dart';
import '../../models/producto.dart';
import '../../services/hive_service.dart';
import '../../utils/responsive.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Productos'), elevation: 0),
      body: SafeArea(
        // Escucha la caja de productos: se redibuja sola cuando cambia
        child: ValueListenableBuilder<Box<Producto>>(
          valueListenable: HiveService.productos.listenable(),
          builder: (context, box, _) {
            final productos = box.values.toList();
            if (productos.isEmpty) {
              return const Center(child: Text('No hay productos disponibles'));
            }
            return _hasData(responsive, theme, productos);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/nuevo_producto');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _hasData(
    Responsive responsive,
    ThemeData theme,
    List<Producto> productos,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.wp(4),
        vertical: responsive.hp(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catálogo actual',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: responsive.dp(2.2),
            ),
          ),
          SizedBox(height: responsive.hp(2)),

          // GridView de Productos
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: responsive.isTablet ? 4 : 2,
                crossAxisSpacing: responsive.wp(3),
                mainAxisSpacing: responsive.wp(3),
                childAspectRatio: 0.8,
              ),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return _ProductoCard(
                  producto: producto,
                  responsive: responsive,
                  alVolver: () => setState(() {}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductoCard extends StatelessWidget {
  final Producto producto;
  final Responsive responsive;
  final VoidCallback alVolver;

  const _ProductoCard({
    required this.producto,
    required this.responsive,
    required this.alVolver,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.dp(1.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.dp(1.5)),
        onTap: () async {
          await Navigator.pushNamed(context, '/producto', arguments: producto);
          alVolver();
        },
        child: Padding(
          padding: EdgeInsets.all(responsive.wp(2)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(responsive.dp(1)),
                    child: VisorImagen(imagen: producto.imagen),
                  ),
                ),
              ),
              SizedBox(height: responsive.hp(1)),

              Text(
                producto.nombre,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.dp(1.6),
                ),
              ),
              SizedBox(height: responsive.hp(0.5)),

              Text(
                '\$${producto.precio.toStringAsFixed(2)}',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: responsive.dp(1.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
