import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/domain/auth/auth_failure.dart';
import 'package:flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:flutter_ddd/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';
part 'sign_in_form_bloc.freezed.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SignInFormState.initial()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<SignInWithGooglePressed>(_onSignInWithGooglePressed);
    on<RegisterWithEmailAndPasswordPressed>(_onRegisterWithEmailAndPasswordPressed);
    on<SignInWithEmailAndPasswordPressed>(_onSignInWithEmailAndPasswordPressed);
  }

  Future<void> _onEmailChanged(EmailChanged event, Emitter<SignInFormState> emit) async {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(event.emailStr),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  Future<void> _onPasswordChanged(
    PasswordChanged event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(
      state.copyWith(
        emailAddress: EmailAddress(event.passwordStr),
        authFailureOrSuccessOption: none(),
      ),
    );
  }

  Future<void> _onSignInWithGooglePressed(
    SignInWithGooglePressed event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, authFailureOrSuccessOption: none()));
    final failureOrSuccess = await _authFacade.signInWithGoogle();
    emit(
      state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess),
      ),
    );
  }

  Future<void> _onRegisterWithEmailAndPasswordPressed(
    RegisterWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(isSubmitting: true, authFailureOrSuccessOption: none()));

      final failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          authFailureOrSuccessOption: some(failureOrSuccess),
        ),
      );
    }
    emit(state.copyWith(showErrorMessages: true, authFailureOrSuccessOption: none()));
  }

  Future<void> _onSignInWithEmailAndPasswordPressed(
    SignInWithEmailAndPasswordPressed event,
    Emitter<SignInFormState> emit,
  ) async {
    late Either<AuthFailure, Unit> failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(state.copyWith(isSubmitting: true, authFailureOrSuccessOption: none()));

      failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
