import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../GlobalComponents/GlobalPackages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: null,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              const Text(
                'Welcome ',
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
              Text(
                currentUser.id,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          ),
          actions: [
            GlobalFunction().logoutButton(context),
          ],
        ),
        body: WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return ZegoUIKit().onWillPop(context);
          },
          child: Stack(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseService.buildViews,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<QueryDocumentSnapshot>? docs = snapshot.data?.docs;
                  if (docs == null || docs.isEmpty) {
                    return const Text('No data');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final model = UserModel.fromJson(
                        docs[index].data() as Map<String, dynamic>,
                      );
                      if (model.username !=
                          FirebaseService.currentUser.username) {
                        return UserCard(userModel: model);
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
