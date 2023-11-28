import 'package:flutter/material.dart';


class LoginCustomField extends StatelessWidget {
  final Icon icon;
  final String hint;
  final bool is_email;
  final bool is_pwd;
  final TextInputType keyboard_type;
  TextEditingController? txtcontroller;
  String errorMsg;
  final Function(String) onTextChanged;

  LoginCustomField({
    required this.icon,
    required this.is_pwd,
    required this.is_email,
    required this.keyboard_type,
    this.hint = '',
    this.txtcontroller,
    this.errorMsg = '',
    required this.onTextChanged,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        children: [
          Container(
            height: 64,
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 26,
                  width: 40,
                  child: this.icon,
                ),
                Expanded(
                  child: TextFormField(
                    controller: this.txtcontroller,
                    obscureText: this.is_pwd,
                    keyboardType: this.keyboard_type,
                    cursorColor: Colors.white,
                    decoration: InputDecoration.collapsed(
                      hintText: this.hint,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),

                    onChanged: (val) => onTextChanged(val),

                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),

          Text(this.errorMsg,
            textAlign: TextAlign.left,
            //overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.amberAccent,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}





