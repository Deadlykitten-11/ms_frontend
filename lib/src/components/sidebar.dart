import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(Widget, List<Widget>) updateContent;
  final VoidCallback createProject;
  final Future<void> Function() fetchPersonalDetails;
  final String? userRole;

  Sidebar({
    required this.updateContent,
    required this.createProject,
    required this.fetchPersonalDetails,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.deepPurple[100],
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          ListTile(
            leading: Icon(Icons.terminal),
            title: Text('项目概览'),
            onTap: () {
              updateContent(Text('项目内容'), [
                ListTile(
                  leading: Icon(Icons.create_new_folder),
                  title: Text('创建项目'),
                  onTap: createProject,
                ),
              ]);
            },
          ),
          ListTile(
            leading: Icon(Icons.science),
            title: Text('材料管理'),
            onTap: () {
              updateContent(Text('材料管理内容'), [
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text('采购'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.local_shipping),
                  title: Text('运输'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.home_work),
                  title: Text('入库'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.check_circle),
                  title: Text('查验'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.outbox),
                  title: Text('出库'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.inventory),
                  title: Text('库存'),
                  onTap: () {},
                ),
              ]);
            },
          ),
          ListTile(
            leading: Icon(Icons.compress),
            title: Text('施工管理'),
            onTap: () {
              updateContent(Text('施工管理内容'), [
                ListTile(
                  leading: Icon(Icons.timeline),
                  title: Text('施工进度'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.shield),
                  title: Text('安全风险'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('项目要求'),
                  onTap: () {},
                ),
              ]);
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('财务管理'),
            onTap: () {
              updateContent(Text('财务管理内容'), [
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('预算'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.receipt),
                  title: Text('开支'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.account_balance),
                  title: Text('收入'),
                  onTap: () {},
                ),
              ]);
            },
          ),
          if (userRole == 'admin' || userRole == 'HR-1')
            ListTile(
              leading: Icon(Icons.build),
              title: Text('用户信息及权限'),
              onTap: () {
                updateContent(Text('Components Content'), [
                  ListTile(
                    leading: Icon(Icons.attach_money),
                    title: Text('用户信息'),
                    onTap: fetchPersonalDetails,
                  ),
                  ListTile(
                    leading: Icon(Icons.receipt),
                    title: Text('权限管理'),
                    onTap: () {},
                  ),
                ]);
              },
            ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('设置'),
            onTap: () {
              updateContent(Text('设置内容'), []);
            },
          ),
        ],
      ),
    );
  }
}