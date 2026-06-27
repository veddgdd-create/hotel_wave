import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_wave/core/functions/email_validate.dart';
import 'package:hotel_wave/core/utils/app_text_styles.dart';
import 'package:hotel_wave/core/utils/colors.dart';
import 'package:hotel_wave/core/widgets/custom_button.dart';
import 'package:hotel_wave/core/widgets/custom_loading.dart';
import 'package:hotel_wave/features/auth/presentation/view_model/auth_cubit.dart';
import 'package:hotel_wave/features/auth/presentation/view_model/auth_states.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({
    super.key,
  });

  @override
  _ForgetPasswordViewState createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _newPasswordCon = TextEditingController();

  bool isVisable = true;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is AuthSuccessState) {
          // if (widget.index == 0) {
          //   Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //       builder: (context) => const DoctorMainPage(),
          //     ),
          //     (route) => false,
          //   );
          // } else {
          //   Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(
          //       builder: (context) => const PatientMainPage(),
          //     ),
          //     (route) => false,
          //   );
          // }
        } else if (state is AuthFailureState) {
          // Navigator.of(context).pop();
          // showErrorDialog(context, state.error);
        } else {
          showLoaderDialog(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset Password',
                    style: getTitleStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Password',
                    style: getbodyStyle(color: AppColors.white),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _passwordCon,
                    textAlign: TextAlign.end,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required*';
                      } else if (!emailValidate(value)) {
                        return 'Please enter the email correctly';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'New Password',
                    style: getbodyStyle(color: AppColors.white),
                  ),
                  const SizedBox(height: 5),
                  TextFormField(
                    style: TextStyle(color: AppColors.white),
                    obscureText: isVisable,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisable = !isVisable;
                            });
                          },
                          icon: Icon((isVisable)
                              ? Icons.remove_red_eye_outlined
                              : Icons.visibility_off_rounded)),
                    ),
                    controller: _newPasswordCon,
                    validator: (value) {
                      if (value!.isEmpty) return 'Password is required*';
                      return null;
                    },
                  ),
                  CheckboxListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      'Remember Me',
                      style: getbodyStyle(color: AppColors.white),
                    ),
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                      text: 'Reset',
                      onTap: () {
                        // if (_formKey.currentState!.validate()) {
                        //   await context.read<AuthCubit>().login(
                        //       _passwordCon.text,
                        //       _newPasswordCon.text);
                        // }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordCon.dispose();
    _newPasswordCon.dispose();
    super.dispose();
  }
}
