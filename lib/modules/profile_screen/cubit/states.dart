abstract class EditingProfileStates{}

class EditingProfileInitialState extends EditingProfileStates{}

class EditingProfileLoadingState extends EditingProfileStates{}

class EditingProfileSuccessState extends EditingProfileStates{}

class EditingProfileErrorState extends EditingProfileStates{}

class ShownOldPassword extends EditingProfileStates{}

class NotShownOldPassword extends EditingProfileStates{}

class ShownNewPassword extends EditingProfileStates{}

class NotShownNewPassword extends EditingProfileStates{}