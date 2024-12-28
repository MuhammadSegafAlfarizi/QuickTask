import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/components/custom_app_bar.dart';
import 'package:task_manager_app/tasks/presentation/bloc/tasks_bloc.dart';
import 'package:task_manager_app/tasks/presentation/widget/task_item_view.dart';
import 'package:task_manager_app/utils/color_palette.dart';
import 'package:task_manager_app/utils/util.dart';

import '../../../components/widgets.dart';
import '../../../routes/pages.dart';
import '../../../utils/font_sizes.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {

  @override
  void initState() {
    context.read<TasksBloc>().add(FetchTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
        child: ScaffoldMessenger(
            child: Scaffold(
          backgroundColor: kWhiteColor,
          appBar: const CustomAppBar(
            title: 'Daftar Task',
            showBackArrow: false,
          ),
          body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: BlocConsumer<TasksBloc, TasksState>(
                      listener: (context, state) {
                    if (state is LoadTaskFailure) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(getSnackBar(state.error, kRed));
                    }

                    if (state is AddTaskFailure || state is UpdateTaskFailure) {
                      context.read<TasksBloc>().add(FetchTaskEvent());
                    }
                  }, builder: (context, state) {
                    if (state is TasksLoading) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    if (state is LoadTaskFailure) {
                      return Center(
                        child: buildText(
                            state.error,
                            kBlackColor,
                            textMedium,
                            FontWeight.normal,
                            TextAlign.center,
                            TextOverflow.clip),
                      );
                    }

                    if (state is FetchTasksSuccess) {
                      return Column(
                        children: [
                          Expanded(
                              child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.tasks.length,
                            itemBuilder: (context, index) {
                              return TaskItemView(
                                  taskModel: state.tasks[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const Divider(
                                color: kGrey3,
                              );
                            },
                          ))
                        ],
                      );
                    }
                    return Container();
                  }))),
          floatingActionButton: FloatingActionButton(
              child: const Icon(
                Icons.add_circle,
                color: kPrimaryColor,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Pages.createNewTask);
              }),
        )));
  }
}