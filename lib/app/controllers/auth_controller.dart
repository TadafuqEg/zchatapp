import 'package:flutter/cupertino.dart';
import 'package:quickalert/quickalert.dart';
import 'package:zchatapp/app/data/models/users_model.dart';
import 'package:zchatapp/app/helper/firebaseConstant.dart';
import 'package:zchatapp/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSkipIntro = false.obs;
  var isAuth = false.obs;

  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  UserCredential? userCredential;

  var user = UsersModel().obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> firstInitialized() async {
    await autoLogin().then((value) {
      if (value) {
        isAuth.value = true;
      }
    });

    await skipIntro().then((value) {
      if (value) {
        isSkipIntro.value = true;
      }
    });
  }

  Future<bool> skipIntro() async {
    // kita akan mengubah isSkipIntro => true
    final box = GetStorage();
    if (box.read('skipIntro') != null || box.read('skipIntro') == true) {
      return true;
    }
    return false;
  }

  Future<bool> autoLogin() async {
    // kita akan mengubah isAuth => true => autoLogin
    try {
      final isSignIn = await _googleSignIn.isSignedIn();
      if (isSignIn) {
        await _googleSignIn
            .signInSilently()
            .then((value) => _currentUser = value);
        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("USER CREDENTIAL");
        print(userCredential);

        // masukan data ke firebase...
        CollectionReference users = firestore.collection(userCollection);
        final currentuser = FirebaseAuth.instance.currentUser;
        await users.doc(currentuser!.email).update({
          "lastSignInTime":
          currentuser.metadata.lastSignInTime!.toIso8601String(),
        });

        final currUser = await users.doc(currentuser.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(currentuser.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });

          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();

        return true;
      }
      return false;
    } catch (err) {
      return false;
    }
  }
  TextEditingController nametec = TextEditingController();
  TextEditingController emailtec = TextEditingController();
  TextEditingController phonetec = TextEditingController();
  TextEditingController passwordtec = TextEditingController();
  TextEditingController confirmpasswordtec = TextEditingController();

  Future<void>RegisterWithEmailAndPassword(context)async{
    try{
      if(emailtec.text.isEmpty && passwordtec.text.isEmpty){
        print("Email,Password Is Empty");
      }else{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Loading',
          text: 'Fetching your data',
        );
      final credentional = FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailtec.text.trim(), password: passwordtec.text.trim());

      final box = GetStorage();
      if (box.read('skipIntro') != null) {
        box.remove('skipIntro');
      }
      box.write('skipIntro', true);

      await RegistDatatoFirestor();
      print('ssssssss');
      Get.offAllNamed(Routes.LOGIN);


      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      print(e);
    }
  }
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


  RegistDatatoFirestor()async{
    final currentuser = FirebaseAuth.instance.currentUser;
    CollectionReference users = firebaseFirestore.collection(userCollection);
    final checkuser = await users.doc(emailtec.text).get();
    if(checkuser.data() == null) {
      await users.doc(emailtec.text).set({
        "uid": currentuser!.uid,
        "name": nametec.text,
        "keyName": nametec.text.substring(0, 1).toUpperCase(),
        "email": emailtec.text,
        "photoUrl": currentuser.photoURL ?? "noimage",
        "status": "",
        "creationTime":currentuser.metadata.creationTime!.toIso8601String(),
        "lastSignInTime": currentuser.metadata.lastSignInTime!.toIso8601String(),
        "updatedTime": DateTime.now().toIso8601String(),
      });
      await users.doc(emailtec.text).collection("chats");
    }else{
      await users.doc(emailtec.text,).update({
        "lastSignInTime": currentuser!.metadata.lastSignInTime!.toIso8601String(),
      });
    }

    final currUser = await users.doc(currentuser.email).get();
    final currUserData = currUser.data()as Map<String, dynamic>;

    user(UsersModel.fromJson(currUserData));

    user.refresh();

    final listChats =
    await users.doc(emailtec.text).collection("chats").get();

    if (listChats.docs.length != 0) {
      List<ChatUser> dataListChats = [];
      listChats.docs.forEach((element) {
        var dataDocChat = element.data();
        var dataDocChatId = element.id;
        dataListChats.add(ChatUser(
          chatId: dataDocChatId,
          connection: dataDocChat["connection"],
          lastTime: dataDocChat["lastTime"],
          total_unread: dataDocChat["total_unread"],
        ));
      });

      user.update((user) {
        user!.chats = dataListChats;
      });
    } else {
      user.update((user) {
        user!.chats = [];
      });
    }

    user.refresh();

    isAuth.value = true;


}

  Future<void>LoginwithEmailAndPassword()async{
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailtec.text,
          password: passwordtec.text
      );
      final box = GetStorage();
      if (box.read('skipIntro') != null) {
        box.remove('skipIntro');
      }

      box.write('skipIntro', true);
      CollectionReference users = firestore.collection(userCollection);
      final currUser = await users.doc(emailtec.text).get();
      final currUserData = currUser.data() as Map<String, dynamic>;

      user(UsersModel.fromJson(currUserData));

      user.refresh();

      final listChats =
      await users.doc(emailtec.text).collection("chats").get();

      if (listChats.docs.length != 0) {
        List<ChatUser> dataListChats = [];
        listChats.docs.forEach((element) {
          var dataDocChat = element.data();
          var dataDocChatId = element.id;
          dataListChats.add(ChatUser(
            chatId: dataDocChatId,
            connection: dataDocChat["connection"],
            lastTime: dataDocChat["lastTime"],
            total_unread: dataDocChat["total_unread"],
          ));
        });

        user.update((user) {
          user!.chats = dataListChats;
        });
      } else {
        user.update((user) {
          user!.chats = [];
        });
      }

      user.refresh();

      isAuth.value = true;
      Get.offAllNamed(Routes.HOME);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> login() async {
    try {
      // Ini untuk handle kebocoran data user sebelum login
      await _googleSignIn.signOut();

      // Ini digunakan untuk mendapatkan google account
      await _googleSignIn.signIn().then((value) => _currentUser = value);

      // ini untuk mengecek status login user
      final isSignIn = await _googleSignIn.isSignedIn();

      if (isSignIn) {
        // kondisi login berhasil
        print("SUDAH BERHASIL LOGIN DENGAN AKUN : ");
        print(_currentUser);

        final googleAuth = await _currentUser!.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => userCredential = value);

        print("USER CREDENTIAL");
        print(userCredential);

        // simpan status user bahwa sudah pernah login & tidak akan menampilkan introduction kembali
        final box = GetStorage();
        if (box.read('skipIntro') != null) {
          box.remove('skipIntro');
        }
        box.write('skipIntro', true);

        // masukan data ke firebase...
        CollectionReference users = firestore.collection(userCollection);

        final checkuser = await users.doc(_currentUser!.email).get();

        if (checkuser.data() == null) {
          await users.doc(_currentUser!.email).set({
            "uid": userCredential!.user!.uid,
            "name": _currentUser!.displayName,
            "keyName": _currentUser!.displayName!.substring(0, 1).toUpperCase(),
            "email": _currentUser!.email,
            "photoUrl": _currentUser!.photoUrl ?? "noimage",
            "status": "",
            "creationTime":
                userCredential!.user!.metadata.creationTime!.toIso8601String(),
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
            "updatedTime": DateTime.now().toIso8601String(),
          });

          await users.doc(_currentUser!.email).collection("chats");
        } else {
          await users.doc(_currentUser!.email).update({
            "lastSignInTime": userCredential!.user!.metadata.lastSignInTime!
                .toIso8601String(),
          });
        }

        final currUser = await users.doc(_currentUser!.email).get();
        final currUserData = currUser.data() as Map<String, dynamic>;

        user(UsersModel.fromJson(currUserData));

        user.refresh();

        final listChats =
            await users.doc(_currentUser!.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = [];
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });

          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        user.refresh();

        isAuth.value = true;
        Get.offAllNamed(Routes.HOME);
      } else {
        print("TIDAK BERHASIL LOGIN");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  // PROFILE

  void changeProfile(String name, String status) {
    String date = DateTime.now().toIso8601String();

    // Update firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      "name": name,
      "keyName": name.substring(0, 1).toUpperCase(),
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    // Update model
    user.update((user) {
      user!.name = name;
      user.keyName = name.substring(0, 1).toUpperCase();
      user.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(title: "Success", middleText: "Change Profile success");
  }

  void updateStatus(String status) {
    String date = DateTime.now().toIso8601String();
    // Update firebase
    CollectionReference users = firestore.collection('users');

    users.doc(_currentUser!.email).update({
      "status": status,
      "lastSignInTime":
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String(),
      "updatedTime": date,
    });

    // Update model
    user.update((user) {
      user!.status = status;
      user.lastSignInTime =
          userCredential!.user!.metadata.lastSignInTime!.toIso8601String();
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(title: "Success", middleText: "Update status success");
  }

  void updatePhotoUrl(String url) async {
    String date = DateTime.now().toIso8601String();
    // Update firebase
    CollectionReference users = firestore.collection('users');

    await users.doc(_currentUser!.email).update({
      "photoUrl": url,
      "updatedTime": date,
    });

    // Update model
    user.update((user) {
      user!.photoUrl = url;
      user.updatedTime = date;
    });

    user.refresh();
    Get.defaultDialog(
        title: "Success", middleText: "Change photo profile success");
  }
  // SEARCH

  void addNewConnection(String friendEmail) async {
    final currentuser = FirebaseAuth.instance.currentUser;
    bool flagNewConnection = false;
    var chat_id;
    String date = DateTime.now().toIso8601String();
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection(userCollection);

    final docChats =
        await users.doc(currentuser!.email).collection("chats").get();

    if (docChats.docs.length != 0) {
      // user sudah pernah chat dengan siapapun
      final checkConnection = await users
          .doc(currentuser.email)
          .collection("chats")
          .where("connection", isEqualTo: friendEmail)
          .get();

      if (checkConnection.docs.length != 0) {
        // sudah pernah buat koneksi dengan => friendEmail
        flagNewConnection = false;

        //chat_id from chats collection
        chat_id = checkConnection.docs[0].id;
      } else {
        // blm pernah buat koneksi dengan => friendEmail
        // buat koneksi ....
        flagNewConnection = true;
      }
    } else {
      // blm pernah chat dengan siapapun
      // buat koneksi ....
      flagNewConnection = true;
    }

    if (flagNewConnection) {
      // cek dari chats collection => connections => mereka berdua...
      final chatsDocs = await chats.where(
        "connections",
        whereIn: [
          [
            currentuser.email,
            friendEmail,
          ],
          [
            friendEmail,
            currentuser.email,
          ],
        ],
      ).get();

      if (chatsDocs.docs.length != 0) {
        // terdapat data chats (sudah ada koneksi antara mereka berdua)
        final chatDataId = chatsDocs.docs[0].id;
        final chatsData = chatsDocs.docs[0].data() as Map<String, dynamic>;

        await users
            .doc(currentuser.email)
            .collection("chats")
            .doc(chatDataId)
            .set({
          "connection": friendEmail,
          "lastTime": chatsData["lastTime"],
          "total_unread": 0,
        });

        final listChats =
            await users.doc(currentuser.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = chatDataId;

        user.refresh();
      } else {
        // buat baru , mereka berdua benar2 belum ada koneksi
        final newChatDoc = await chats.add({
          "connections": [
            currentuser.email,
            friendEmail,
          ],
        });

        await chats.doc(newChatDoc.id).collection("chat");

        await users
            .doc(currentuser.email)
            .collection("chats")
            .doc(newChatDoc.id)
            .set({
          "connection": friendEmail,
          "lastTime": date,
          "total_unread": 0,
        });

        final listChats =
            await users.doc(currentuser.email).collection("chats").get();

        if (listChats.docs.length != 0) {
          List<ChatUser> dataListChats = List<ChatUser>.empty();
          listChats.docs.forEach((element) {
            var dataDocChat = element.data();
            var dataDocChatId = element.id;
            dataListChats.add(ChatUser(
              chatId: dataDocChatId,
              connection: dataDocChat["connection"],
              lastTime: dataDocChat["lastTime"],
              total_unread: dataDocChat["total_unread"],
            ));
          });
          user.update((user) {
            user!.chats = dataListChats;
          });
        } else {
          user.update((user) {
            user!.chats = [];
          });
        }

        chat_id = newChatDoc.id;

        user.refresh();
      }
    }

    print(chat_id);

    final updateStatusChat = await chats
        .doc(chat_id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("penerima", isEqualTo: currentuser.email)
        .get();

    updateStatusChat.docs.forEach((element) async {
      await chats
          .doc(chat_id)
          .collection("chat")
          .doc(element.id)
          .update({"isRead": true});
    });

    await users
        .doc(currentuser.email)
        .collection("chats")
        .doc(chat_id)
        .update({"total_unread": 0});

    Get.toNamed(
      Routes.CHAT_ROOM,
      arguments: {
        "chat_id": "$chat_id",
        "friendEmail": friendEmail,
      },
    );
  }
}
