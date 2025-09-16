import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lges_teacher_app/components/base_scaffold.dart';
import 'package:lges_teacher_app/components/h_padding.dart';
import 'package:lges_teacher_app/module/auth/cubit/user_schools_cubit/user_schools_cubit.dart';
import 'package:lges_teacher_app/module/auth/repo/auth_repository.dart';
import 'package:lges_teacher_app/module/campus/pages/widgets/campuses_tile.dart';
import 'package:lges_teacher_app/module/class_section/pages/class_section_screen.dart';
import 'package:lges_teacher_app/module/home/pages/home_screen.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/loading_indicator.dart';
import '../../../components/search_textfield.dart';
import '../../../components/text_view.dart';
import '../../../config/routes/nav_router.dart';
import '../../../constants/app_colors.dart';
import '../../../core/di/service_locator.dart';
import '../../auth/models/auth_response.dart';

class CampusesScreen extends StatefulWidget {
  @override
  State<CampusesScreen> createState() => _CampusesScreenState();
}

class _CampusesScreenState extends State<CampusesScreen> {
  AuthRepository _authRepository = sl<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSchoolsCubit(sl())
        ..fetchUserSchools(UserSchoolsInput(
            entityId: _authRepository.user.entityId.toString(),
            userId: _authRepository.user.userId.toString())),
      child: BaseScaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: BlocBuilder<UserSchoolsCubit, UserSchoolsState>(
            builder: (context, state) {
              if (state.userSchoolsStatus == UserSchoolsStatus.loading) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (state.userSchoolsStatus == UserSchoolsStatus.success) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20) +
                      const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      SearchTextField(
                        hint: "Search Campus",
                        readOnly: false,
                        onValueChange: (String value) {
                          context.read<UserSchoolsCubit>().filterSearchResults(value);
                        },
                      ).hPadding(padding: 10),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: Container(
                        decoration: const BoxDecoration(
                            color: AppColors.lightGreyColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                  child: state.userSchools.isNotEmpty
                                      ? ListView.separated(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          itemCount: state.userSchools.length,
                                          physics: BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                AuthRepository _auth =
                                                    sl<AuthRepository>();
                                                User newUser = _auth.user;
                                                newUser.schoolId = state
                                                    .userSchools[index]
                                                    .schoolId;
                                                _auth.saveUser(newUser);
                                                NavRouter.pushAndRemoveUntil(context,
                                                    HomeScreen());
                                              },
                                              child: CampusesTile(
                                                  campusName: state
                                                      .userSchools[index]
                                                      .schoolName),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              height: 20,
                                            );
                                          },
                                        )
                                      : Center(
                                          child: TextView(
                                            "No results found",
                                            fontSize: 24,
                                            color: AppColors.greyColor,
                                          ),
                                        )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                );
              } else if (state.userSchoolsStatus == UserSchoolsStatus.failure) {
                return Center(
                  child: Text(state.failure.message),
                );
              }
              return SizedBox();
            },
          ),
        ),
        hMargin: 0,
        appBar: const CustomAppbar(
          'Campuses List',
          centerTitle: true,
        ),
        backgroundColor: AppColors.primaryDark,
      ),
    );
  }
}
