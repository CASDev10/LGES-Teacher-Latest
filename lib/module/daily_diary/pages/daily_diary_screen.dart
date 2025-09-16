import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/custom_appbar.dart';
import 'package:lges_teacher_app/components/custom_button.dart';
import 'package:lges_teacher_app/components/custom_textfield.dart';
import 'package:lges_teacher_app/config/config.dart';
import 'package:lges_teacher_app/constants/app_colors.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/daily_diary/cubit/diary_list_cubit/diary_list_cubit.dart';
import 'package:lges_teacher_app/module/daily_diary/pages/add_daily_diary_screen.dart';
import 'package:lges_teacher_app/utils/custom_date_time_picker.dart';
import 'package:lges_teacher_app/utils/extensions/extended_string.dart';

import '../../../components/loading_indicator.dart';
import '../../../constants/keys.dart';
import '../../../core/di/service_locator.dart';
import '../../home/repo/home_repo.dart';
import '../cubit/diary_list_cubit/diary_list_state.dart';

class DailyDiaryScreen extends StatefulWidget {
  @override
  State<DailyDiaryScreen> createState() => _DailyDiaryScreenState();
}

class _DailyDiaryScreenState extends State<DailyDiaryScreen> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  AuthRepository _authRepository = sl<AuthRepository>();
  List<String> userPrivileges = [];
  HomeRepository homeRepository = sl<HomeRepository>();
  @override
  void initState() {
    super.initState();
    if (_authRepository.user.userPrivileges?.isNotEmpty == true) {
      userPrivileges = _authRepository.user.userPrivileges.toString().split(',');
    }
  }
  void _gotoAddDiary() {
    if (userPrivileges.isNotEmpty) {
      bool exists = false;
      for (var i = 0; i < userPrivileges.length; i++) {
        if (userPrivileges[i].toInt() == StorageKeys.addDiaryId) {
          exists = true;
          break;
        } else {
          exists = false;
        }
      }
      if (exists) {
        NavRouter.push(context, AddDailyDiaryScreen()).then((value) {
          context.read<DiaryListCubit>().fetchDiaryList('1');
        });
      } else {
        Fluttertoast.showToast(msg: "You are not allowed to add diary!");
      }
    } else {
      Fluttertoast.showToast(msg: "You are not allowed to add diary!");
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DiaryListCubit(sl())
        ..fetchDiaryList(_authRepository.user.schoolId.toString()),
      child: BaseScaffold(
        appBar: const CustomAppbar(
          'Diary Work',
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20) +
              const EdgeInsets.symmetric(vertical: 30),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          BlocBuilder<DiaryListCubit, DiaryListState>(builder: (context, state){
                            if (state.diaryListStatus == DiaryListStatus.loading) {
                              return Center(
                                child: LoadingIndicator(),
                              );
                            }
                            if(state.diaryListStatus == DiaryListStatus.success){
                              return Column(
                                children: List.generate(state.diaryList.length, (index) {
                                  return CustomTextField(
                                    hintText: state.diaryList[index].subjectName,
                                    height: 50,
                                    inputType: TextInputType.text,
                                    fillColor: AppColors.lightGreyColor,
                                    hintColor: AppColors.primaryDark,
                                    fontWeight: FontWeight.w500,
                                    readOnly: true,
                                    fontSize: 16,
                                    suffixWidget: SvgPicture.asset(
                                      'assets/images/svg/ic_arrow_forward.svg',
                                      color: AppColors.primaryDark,
                                      height: 16,
                                    ),
                                    onTap: () {},
                                  );
                                }),
                              );
                            }
                            if (state.diaryListStatus == DiaryListStatus.failure) {
                              return Center(
                                child: Text(state.failure.message),
                              );
                            }
                            return SizedBox();
                          }),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: AppColors.grey1,
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 10, vertical: 16),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: 'From Date',
                        height: 50,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        hintColor: AppColors.primaryDark,
                        fontWeight: FontWeight.w500,
                        readOnly: true,
                        fontSize: 16,
                        suffixWidget: SvgPicture.asset(
                          'assets/images/svg/ic_drop_down.svg',
                          color: AppColors.primaryDark,
                        ),
                        onTap: () async {
                          fromDateController.text =
                          await CustomDateTimePicker.selectDiaryDate(
                              context);
                        },
                        controller: fromDateController,
                      ),
                      CustomTextField(
                        hintText: 'To Date',
                        height: 50,
                        fontSize: 16,
                        inputType: TextInputType.text,
                        fillColor: AppColors.lightGreyColor,
                        fontWeight: FontWeight.w500,
                        hintColor: AppColors.primaryDark,
                        readOnly: true,
                        suffixWidget: SvgPicture.asset(
                          'assets/images/svg/ic_drop_down.svg',
                          color: AppColors.primaryDark,
                        ),
                        onTap: () async {
                          toDateController.text =
                          await CustomDateTimePicker.selectDiaryDate(
                              context);
                        },
                        controller: toDateController,
                      ),
                      CustomButton(
                        height: 44,
                        borderRadius: 6,
                        onPressed: () {},
                        title: 'Show',
                        isEnabled: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  height: 50,
                  borderRadius: 15,
                  onPressed: () {
                    _gotoAddDiary();
                  },
                  title: 'Add Diary Work',
                  isEnabled: true,
                )
              ],
            ),
          ),
        ),
        backgroundColor: AppColors.primaryDark,
        hMargin: 0,
      ),
    );
  }
}
