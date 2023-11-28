import 'package:flutter/material.dart';

class RegCustomField extends StatelessWidget {
  final Icon icon;
  final String hint;
  final bool is_email;
  final bool is_pwd1;
  final bool is_pwd2;
  final TextInputType keyboard_type;
  TextEditingController? txtcontroller;
  String pwd1Msg;
  final Function(String) onTextChanged;

  RegCustomField({
    required this.icon,
    required this.is_pwd1,
    required this.is_pwd2,
    required this.is_email,
    required this.keyboard_type,
    this.hint = '',
    this.txtcontroller,
    this.pwd1Msg = '',
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
                    obscureText: (this.is_pwd1 || this.is_pwd2),
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
            height: 4,
          ),
          this.is_pwd1 ?
          Container(
              //height: 64,
              //width: double.infinity,
              margin: EdgeInsets.only(top: 2, left: 8, right: 8),
              //padding: EdgeInsets.all(2),
              child:
              Text(this.pwd1Msg,
                textAlign: TextAlign.center,
                //overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.normal)))
              :
          Container(),
        ],
      ),
    );
  }
}