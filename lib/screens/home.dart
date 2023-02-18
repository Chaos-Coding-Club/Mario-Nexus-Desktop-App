import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mario_nexus/auth/auth_failure.dart';
import 'package:mario_nexus/providers/providers.dart';
import 'package:mario_nexus/services/api.dart';
import 'package:process_run/shell.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  bool isDownloaded = false;
  late Either<AuthFailure, String> path;
  Api api = Api();
  Shell shell = Shell();
  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      titleBar: const TitleBar(
        title: Text("Mario Nexus"),
      ),
      child: CupertinoTabView(
        builder: (context) => MacosScaffold(
          toolBar: ToolBar(
            title: const Text(
              "Home",
              style: TextStyle(
                fontSize: 35,
              ),
            ),
            actions: [
              ToolBarIconButton(
                  label: "Sign Out",
                  icon: const Icon(Icons.logout),
                  showLabel: false,
                  onPressed: () async {
                    await ref.watch(authNotifierProvider.notifier).signOut();
                  }),
            ],
            titleWidth: 250,
            automaticallyImplyLeading: true,
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return Center(
                  child: isDownloaded
                      ? FilledButton(
                          onPressed: () async {
                            path.fold((l) => null, (r) async {
                              await shell.run(
                                  '''pip install gym_super_mario_bros==7.3.0 nes_py''');
                              await shell.run(
                                  '''pip install torch==1.10.1+cu113 torchvision==0.11.2+cu113 torchaudio===0.10.1+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html''');
                              await shell.run(
                                  '''pip install stable-baselines3[extra]''');
                              await shell.run('''python $path''');
                            });
                          },
                          style: const ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(5)),
                            fixedSize: MaterialStatePropertyAll(Size(400, 100)),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red),
                          ),
                          child: const Text(
                            "Run Scripts",
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                      : FilledButton(
                          onPressed: () async {
                            path = await api.getPythonScript(ref);
                            setState(() {
                              isDownloaded = true;
                            });
                          },
                          style: const ButtonStyle(
                            padding:
                                MaterialStatePropertyAll(EdgeInsets.all(5)),
                            fixedSize: MaterialStatePropertyAll(Size(400, 100)),
                          ),
                          child: const Text(
                            "Download script",
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
