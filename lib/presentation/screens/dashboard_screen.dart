import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_tecnica/controllers/tarea_controller.dart';
import 'package:prueba_tecnica/models/tarea.dart';
import 'package:prueba_tecnica/presentation/screens/info_task_screen.dart';
import 'package:prueba_tecnica/presentation/screens/register_task_screen.dart';
import 'package:prueba_tecnica/presentation/widgets/filter_dialog.dart';
import 'package:prueba_tecnica/presentation/widgets/task_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => const FilterDialog(),
              );
              if (result != null) {
                // ignore: use_build_context_synchronously
                Provider.of<TareaController>(context, listen: false)
                    .setFilter(result);
              }
            },
          )
        ],
      ),
      body: const _TasksView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nueva Tarea'),
        icon: const Icon(Icons.add),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const RegisterTaskScreen())),
      ),
    );
  }
}

class _TasksView extends StatefulWidget {
  const _TasksView();

  @override
  State<_TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<_TasksView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TareaController>(
      builder: (context, tareaController, child) {
        return FutureBuilder<List<Tarea>>(
          future: tareaController.obtenerTareasFiltradas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No hay tareas disponibles."));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final tarea = snapshot.data![index];
                  return InkWell(
                    onTap: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InfoTask(id: tarea.id)));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 20),
                        child: TaskCard(tarea: tarea),
                      ),
                    ),
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
