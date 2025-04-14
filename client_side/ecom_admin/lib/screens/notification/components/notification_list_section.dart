import 'package:ecom_admin/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/my_notification.dart';
import 'view_notification_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';

class NotificationListSection extends StatelessWidget {
  const NotificationListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Notifications",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: defaultPadding,
                          columns: const [
                            DataColumn(label: Text("Title")),
                            DataColumn(label: Text("Description")),
                            DataColumn(label: Text("Send Date")),
                            DataColumn(label: Text("View")),
                            DataColumn(label: Text("Delete")),
                          ],
                          rows: List.generate(
                            dataProvider.notifications.length,
                            (index) => notificationDataRow(
                              dataProvider.notifications[index],
                              index + 1,
                              edit: () {
                                viewNotificationStatics(
                                    context, dataProvider.notifications[index]);
                              },
                              delete: () {
                                context.notificationProvider.deleteNotification(
                                    dataProvider.notifications[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

DataRow notificationDataRow(MyNotification notification, int index,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 24,
              width: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(
                index.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: defaultPadding),
            SizedBox(
              width: 150,
              child: Text(
                notification.title ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        SizedBox(
          width: 200,
          child: Text(
            notification.description ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
      DataCell(Text(notification.createdAt ?? '')),
      DataCell(
        IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: const Icon(Icons.remove_red_eye_sharp, color: Colors.white),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    ],
  );
}
