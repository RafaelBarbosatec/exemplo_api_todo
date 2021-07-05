import 'package:flutter/material.dart';
import 'package:todo_lovepeople/core/functions.dart';
import 'package:provider/provider.dart';
import 'package:todo_lovepeople/model/repository/user_repository.dart';
import 'package:todo_lovepeople/model/todo.dart';
import 'package:todo_lovepeople/presenter/home_controller.dart';
import 'package:todo_lovepeople/view/login/login_page.dart';
import 'package:todo_lovepeople/view/new_todo/new_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    postFrame(() {
      context.read<HomeController>().loadTodoList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Olá ${controller.login?.user?.username}'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<UserRepository>().logout().then((value) {
                    _goLogin();
                  });
                },
                icon: Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () {
                  controller.loadTodoList();
                  return Future.value();
                },
                child: ListView.builder(
                  itemCount: controller.todoList.length,
                  itemBuilder: (context, index) {
                    final todo = controller.todoList[index];
                    return Card(
                      margin: EdgeInsets.all(10),
                      color: _getColor(todo.color),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(todo.title ?? ''),
                          subtitle: Text(todo.description ?? ''),
                          trailing: IconButton(
                            onPressed: () {
                              _showDialogDelete(controller, todo);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (controller.loading)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _goRegisterTodo(controller),
          ),
        );
      },
    );
  }

  void _goLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void _goRegisterTodo(HomeController controller) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewTodoPage(),
      ),
    );

    if (result != null) {
      controller.loadTodoList();
    }
  }

  Color _getColor(String? color) {
    try {
      return Color(int.parse('0xFF${color?.replaceAll('#', '')}'));
    } catch (e) {
      return Colors.transparent;
    }
  }

  void _showDialogDelete(HomeController controller, Todo todo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Atenção"),
          content: Text("Deseja excluir a tarefa: ${todo.title} ? "),
          actions: <Widget>[
            TextButton(
              child: new Text("Sim"),
              onPressed: () {
                controller.delete(todo);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
