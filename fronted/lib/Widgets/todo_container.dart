import 'package:flutter/material.dart';
import 'package:fronted/Constants/colors.dart';

class TodoContainer extends StatelessWidget {
  final int id;
  final String title;
  final String desc;
  final Function onPressed;
  final Function onUpdate;
  final bool isDone;

  const TodoContainer({
    Key? key,
    required this.id,
    required this.title,
    required this.desc,
    required this.isDone,
    required this.onPressed,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final Color containerColor = isDone ? green : red;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          onUpdate();
        },
        child: Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: containerColor, 
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    IconButton(
                      onPressed: () => onPressed(),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    desc,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
