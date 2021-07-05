import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_lovepeople/model/todo.dart';
import 'package:todo_lovepeople/presenter/new_todo_controller.dart';

class NewTodoPage extends StatefulWidget {
  const NewTodoPage({Key? key}) : super(key: key);

  @override
  _NewTodoPageState createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final todoColors = ['#FFF2CC', '#FFD9F0', '#E8C5FF', '#CAFBFF', '#E3FFE6'];

  String colorSelected = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova tarefa'),
      ),
      body: Consumer<NewTodoController>(builder: (context, controller, _) {
        return Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Titulo',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Descrição',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _buildColors(),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: () {
                          String title = titleController.text;
                          String description = descriptionController.text;

                          if (title.isNotEmpty && description.isNotEmpty) {
                            final todo = Todo(
                              title: title,
                              description: description,
                              color: colorSelected,
                            );
                            controller.registerTodo(
                              todo,
                              onSuccess: () {
                                Navigator.of(context).pop(todo);
                              },
                              onFailure: _showError,
                            );
                          }
                        },
                        child: Text('Cadastrar'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.loading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildColors() {
    final double size = 50;
    return Container(
      height: size,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: todoColors.length,
        itemBuilder: (context, index) {
          final c = todoColors[index];
          return Padding(
            padding: EdgeInsets.only(right: 10),
            child: InkWell(
              onTap: () {
                setState(() {
                  colorSelected = c;
                });
              },
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: Color(
                    int.parse('0xFF${c.replaceAll('#', '')}'),
                  ),
                  border: colorSelected == c
                      ? Border.all(
                          color: Colors.black,
                          width: 2,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(size / 2),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Não foi possivel cadastrar TODO',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
