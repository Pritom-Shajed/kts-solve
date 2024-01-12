import 'package:flutter/material.dart';

class BottomSheets {
  static updateAdd(BuildContext context, {required TextEditingController rentTextController, VoidCallback? onTapUpdate}) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
        context: context,
        builder: (_) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Update your rent'),
                SizedBox(height: 10,),
                TextField(
                  controller: rentTextController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(4)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(4)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(4)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: onTapUpdate, child: Text('Update'))
              ],
            ),
          );
        });
  }
}
