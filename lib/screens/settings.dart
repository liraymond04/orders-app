import 'package:flutter/material.dart';

import 'package:orders_app/widgets/dialog_modal.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ Key? key }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _name = '';
  TextEditingController _name_controller = new TextEditingController();
  String _email = '';
  TextEditingController _email_controller = new TextEditingController();
  String _school = '';
  TextEditingController _school_controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _section(
              context,
              title: 'Information',
              children: <Widget>[
                _card(
                  context,
                  title: 'Name',
                  children: <Widget>[
                    Text(_name),
                    Spacer()
                  ],
                  onTap: () {
                    showEditTextDialog(
                      context: context,
                      title: 'Edit name',
                      description: 'description',
                      textFieldLabel: 'Name',
                      controller: _name_controller,
                      onPressed: () {
                        setState(() {
                          _name = _name_controller.text;
                          _name_controller.clear();
                        });
                        Navigator.of(context).pop();
                      }
                    );
                  }
                ),
                _card(
                  context,
                  title: 'Email',
                  children: <Widget>[
                    Text(_email),
                    Spacer()
                  ],
                  onTap: () {
                    showEditTextDialog(
                      context: context,
                      title: 'Edit email',
                      description: 'description',
                      textFieldLabel: 'Email',
                      controller: _email_controller,
                      onPressed: () {
                        setState(() {
                          _email = _email_controller.text;
                          _email_controller.clear();
                        });
                        Navigator.of(context).pop();
                      }
                    );
                  }
                ),
                _card(
                  context,
                  title: 'School',
                  children: <Widget>[
                    Text(_school),
                    Spacer()
                  ],
                  onTap: () {
                    showEditTextDialog(
                      context: context,
                      title: 'Edit school',
                      description: 'description',
                      textFieldLabel: 'School',
                      controller: _school_controller,
                      onPressed: () {
                        setState(() {
                          _school = _school_controller.text;
                          _school_controller.clear();
                        });
                        Navigator.of(context).pop();
                      }
                    );
                  }
                ),
              ],
            ),
            _section(
              context,
              title: 'General',
              children: <Widget>[
                _card(
                  context,
                  title: 'Notifications',
                  children: <Widget>[
                    
                  ],
                  onTap: () {
                    
                  }
                ),
                _card(
                  context,
                  title: 'Theme',
                  children: <Widget>[
                    
                  ],
                  onTap: () {
                    
                  }
                ),
              ],
            ),
            _section(
              context,
              title: 'Other',
              children: <Widget>[
                _card(
                  context,
                  title: 'Help',
                  children: <Widget>[
                    
                  ],
                  onTap: () {
                    
                  }
                ),
                _card(
                  context,
                  title: 'About',
                  children: <Widget>[
                    
                  ],
                  onTap: () {
                    
                  }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(context, { required title, required List<Widget> children }) {
    List<Widget> _children = [Divider()];
    children.forEach((element) {
      _children.add(element);
      _children.add(Divider());
    });
    return Container(
      margin: EdgeInsets.only(top: 15.0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Column(
            children: _children,
          ),
        ],
      ),
    );
  }

  Widget _card(context, { required title, required children, onTap }) {
    List<Widget> _children = [
      SizedBox(
        width: 115,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    ];
    _children.addAll(children);
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: InkWell(
        child: Container(
          margin: EdgeInsets.only(left: 15.0, top: 7.5, bottom: 7.5),
          child: Row(
            children: _children,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}