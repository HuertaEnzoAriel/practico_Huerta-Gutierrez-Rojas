import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';

import '../../models/cliente.dart';
import '../../services/hive_service.dart';
import '../../utils/responsive.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis Clientes'), elevation: 0),
      body: SafeArea(
        // Escucha la caja de clientes: se redibuja sola cuando cambia
        child: ValueListenableBuilder<Box<Cliente>>(
          valueListenable: HiveService.clientes.listenable(),
          builder: (context, box, _) {
            final clientes = box.values.toList();
            if (clientes.isEmpty) return _sinClientes(responsive, theme);
            return _hasData(responsive, theme, clientes);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/nuevo_cliente');
          if (mounted) setState(() {});
        },
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Nuevo Cliente'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _sinClientes(Responsive responsive, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_alt_outlined,
            size: responsive.dp(8),
            color: theme.colorScheme.surfaceContainerHighest,
          ),
          SizedBox(height: responsive.hp(2)),
          Text(
            'Aún no tienes clientes registrados',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _hasData(
    Responsive responsive,
    ThemeData theme,
    List<Cliente> clientes,
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
            'Directorio (${clientes.length})',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: responsive.dp(2.2),
            ),
          ),
          SizedBox(height: responsive.hp(2)),

          // --- LISTVIEW DE CLIENTES ---
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final cliente = clientes[index];
                return _ClienteTile(
                  cliente: cliente,
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

// --- WIDGET DE LA TARJETA DEL CLIENTE ---
class _ClienteTile extends StatelessWidget {
  final Cliente cliente;
  final Responsive responsive;
  final VoidCallback alVolver;

  const _ClienteTile({
    required this.cliente,
    required this.responsive,
    required this.alVolver,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String inicial = cliente.nombre.isNotEmpty
        ? cliente.nombre.trim().substring(0, 1).toUpperCase()
        : '?';

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: responsive.hp(1.5)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(responsive.dp(1.5)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(responsive.dp(1.5)),
        onTap: () async {
          await Navigator.pushNamed(context, '/cliente', arguments: cliente);
          alVolver();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: responsive.hp(0.5)),
          child: ListTile(
            leading: CircleAvatar(
              radius: responsive.dp(2.5),
              backgroundColor: theme.colorScheme.primaryContainer,
              foregroundColor: theme.colorScheme.onPrimaryContainer,
              child: Text(
                inicial,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.dp(2),
                ),
              ),
            ),
            title: Text(
              cliente.nombre,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: responsive.dp(1.7),
              ),
            ),
            subtitle: Text(
              cliente.telefono.isNotEmpty ? cliente.telefono : 'Sin teléfono',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: responsive.dp(1.5),
              ),
            ),
            trailing: Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.outline,
              size: responsive.dp(3),
            ),
          ),
        ),
      ),
    );
  }
}
