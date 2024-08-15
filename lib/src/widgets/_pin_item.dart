part of '../pinput.dart';

class _PinItem extends StatelessWidget {
  final _PinputState state;
  final int index;
  final int lenght;

  const _PinItem({
    required this.state,
    required this.index,
    required this.lenght,
  });

  @override
  Widget build(BuildContext context) {
    final pinTheme = _pinTheme(index, context);

    return Flexible(
      child: AnimatedContainer(
        height: pinTheme.height,
        width: pinTheme.width,
        constraints: pinTheme.constraints,
        padding: pinTheme.padding,
        margin: pinTheme.margin,
        decoration: pinTheme.decoration,
        alignment: state.widget.pinContentAlignment,
        duration: state.widget.animationDuration,
        curve: state.widget.animationCurve,
        child: AnimatedSwitcher(
          switchInCurve: state.widget.animationCurve,
          switchOutCurve: state.widget.animationCurve,
          duration: state.widget.animationDuration,
          transitionBuilder: _getTransition,
          child: _buildFieldContent(index, pinTheme),
        ),
      ),
    );
  }

  PinTheme _pinTheme(int index, BuildContext context) {
    final pintState = state._getState(index);
    switch (pintState) {
      case PinItemStateType.initial:
        return state.widget.defaultPinTheme ?? _defaultPinTheme(context);
      case PinItemStateType.focused:
        return _pinThemeOrDefault(state.widget.focusedPinTheme, context);
      case PinItemStateType.submitted:
        return _pinThemeOrDefault(state.widget.submittedPinTheme, context);
      case PinItemStateType.following:
        return _pinThemeOrDefault(state.widget.followingPinTheme, context);
      case PinItemStateType.disabled:
        return _pinThemeOrDefault(state.widget.disabledPinTheme, context);
      case PinItemStateType.error:
        return _pinThemeOrDefault(state.widget.errorPinTheme, context);
    }
  }

  /// The default value [Pinput.defaultPinTheme]
  PinTheme _defaultPinTheme(BuildContext context) {
    final double width = MediaQuery.of(context).size.width / lenght;
    return PinTheme(
      width: width,
      height: 70,
      textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 24),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
    );
  }

  PinTheme _getDefaultPinTheme(BuildContext context) =>
      state.widget.defaultPinTheme ?? _defaultPinTheme(context);

  PinTheme _pinThemeOrDefault(PinTheme? theme, BuildContext context) =>
      theme ?? _getDefaultPinTheme(context);

  Widget _buildFieldContent(int index, PinTheme pinTheme) {
    final pin = state.pin;
    final key = ValueKey<String>(index < pin.length ? pin[index] : '');
    final isSubmittedPin = index < pin.length;

    if (isSubmittedPin) {
      if (state.widget.obscureText && state.widget.obscuringWidget != null) {
        return SizedBox(key: key, child: state.widget.obscuringWidget);
      }

      return Text(
        state.widget.obscureText ? state.widget.obscuringCharacter : pin[index],
        key: key,
        style: pinTheme.textStyle,
      );
    }

    final isActiveField = index == pin.length;
    final focused =
        state.effectiveFocusNode.hasFocus || !state.widget.useNativeKeyboard;
    final shouldShowCursor =
        state.widget.showCursor && state.isEnabled && isActiveField && focused;

    if (shouldShowCursor) {
      return _buildCursor(pinTheme);
    }

    if (state.widget.preFilledWidget != null) {
      return SizedBox(key: key, child: state.widget.preFilledWidget);
    }

    return Text('', key: key, style: pinTheme.textStyle);
  }

  Widget _buildCursor(PinTheme pinTheme) {
    if (state.widget.isCursorAnimationEnabled) {
      return _PinputAnimatedCursor(
        textStyle: pinTheme.textStyle,
        cursor: state.widget.cursor,
      );
    }

    return _PinputCursor(
      textStyle: pinTheme.textStyle,
      cursor: state.widget.cursor,
    );
  }

  Widget _getTransition(Widget child, Animation<double> animation) {
    if (child is _PinputAnimatedCursor) {
      return child;
    }

    switch (state.widget.pinAnimationType) {
      case PinAnimationType.none:
        return child;
      case PinAnimationType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case PinAnimationType.scale:
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      case PinAnimationType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin:
                state.widget.slideTransitionBeginOffset ?? const Offset(0.8, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case PinAnimationType.rotation:
        return RotationTransition(
          turns: animation,
          child: child,
        );
    }
  }
}
