import 'package:flutter/material.dart';
import 'package:sewa/backend_work/apis.dart';
import 'package:sewa/common/colors.dart';
import 'package:sewa/ui/user/service_details.dart';

class ServiceView extends StatelessWidget {
  final List? services;

  ServiceView({
    Key? key,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        if (services != null && services!.isNotEmpty) ...[
          for (int i = 0; i < services!.length; i++) ...[
            Container(
              width: MediaQuery.of(context).size.width * .5,
              padding:
                  EdgeInsets.only(left: 10, right: i.isOdd ? 10 : 0, bottom: 8),
              child: Card(
                elevation: 5,
                color: MyColors.bgColor,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetails(
                          serviceName: services![i]['service_name'],
                          image: Api.baseURL + services![i]['service_img'],
                          serviceId: services![i]['id'],
                          about: services![i]['service_about'],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Image.network(
                                Api.baseURL + services![i]['service_img'],
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 110,
                            ),
                            if (DateTime.now()
                                    .difference(DateTime.parse(
                                        services![i]['created_date']))
                                    .inDays <
                                5) ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(50)),
                                  color: MyColors.badColor,
                                ),
                                child: Text(
                                  'New',
                                  style: TextStyle(
                                      color: MyColors.defaultTextColor),
                                ),
                              ),
                            ]
                          ],
                        ),
                        Text(
                          services![i]['service_name'],
                          style: TextStyle(
                              color: MyColors.highlightColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ] else ...[
          Container(
            height: MediaQuery.of(context).size.height * .5,
            child: Center(
              child: Text('No Services Available'),
            ),
          ),
        ],
      ],
    );
  }
}
