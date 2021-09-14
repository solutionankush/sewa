import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../common/colors.dart';
import '../../common/functions.dart';
import '../../common/styles.dart';
import '../../common/variables.dart' as Variable;
import '../../common/widgets.dart';
import '../sp/add_service.dart';

class ServiceDetails extends StatefulWidget {
  final serviceId, serviceName, image, about;

  ServiceDetails({
    Key? key,
    this.serviceId,
    this.serviceName,
    this.image,
    this.about,
  });

  @override
  _ServiceDetailsState createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  var top = 0.0;

  @override
  Widget build(BuildContext context) {
    var body = CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: MediaQuery.of(context).size.height / 2.5,
          pinned: true,
          flexibleSpace: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              top = constraints.biggest.height;
              return FlexibleSpaceBar(
                centerTitle: true,
                title: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  //opacity: top == 80.0 ? 1.0 : 0.0,
                  opacity: 1.0,

                  child: Text(
                    widget.serviceName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: top == 56.0
                          ? MyColors.bgColor
                          : MyColors.highlightColor,
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                background: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.network(
                        widget.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: MyColors.themeColor,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.4),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        SliverFillRemaining(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 60),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '  About "${widget.serviceName}"  ',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,),
                  ),
                  Widgets.sizedBox(10, 0),
                  Text(
                    widget.about,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                  Widgets.sizedBox(10, 0),
                  Widgets.divider(),
                  Widgets.sizedBox(10, 0),
                  if (Variable.userType != '1') ...[
                    ElevatedButton(
                      style: Styles.roundButtonStyle(),
                      onPressed: () {
                        setState(() {
                          Variable.reqSid = widget.serviceId;
                          Variable.reqName = widget.serviceName;
                        });
                        Fun.router(context, Variable.Links.sendReq);
                      },
                      child: Text(
                        'Book ${widget.serviceName} Now',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ] else ...[
                    ElevatedButton(
                      style: Styles.roundButtonStyle(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddService(
                                      name: widget.serviceName,
                                      id: widget.serviceId,
                                      img: widget.image,
                                      about: widget.about,
                                    )));
                      },
                      child: Text(
                        'Change in ${widget.serviceName}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
          hasScrollBody: false,
          fillOverscroll: true,
        )
      ],
    );

    return Widgets.scaffoldWithoutAppBar(body, context);
  }
}
