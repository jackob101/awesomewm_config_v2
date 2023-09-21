--- @class Signals
Signals = {
  volume_increase = "volume::increase",                     --- shouldDisplayPopup: boolean \
  volume_decrease = "volume::decrease",                     --- shouldDisplayPopup: boolean \
  volume_toggle = "volume::toggle",                         --- shouldDisplayPopup: boolean \
  volume_update = "volume::update",                         ---  \ Needed to update volume service
  volume_update_widgets = "volume::update_widget",          --- newVolume: number, isMute boolean, shoulDisplayPopup boolean \
  volume_set = "volume::set",                               --- newValue: number, shouldDisplayPopup: boolean
  dnd_toggle = "dnd::toggle",                               --- \
  dnd_update = "dnd::update",                               --- isOn: boolean \
  client_mover_start = "client:mover::start",               --- client: Client \
  macros_toggle = "macros::toggle",                         --- \
  notification_panel_toggle = "notification:panel::toggle", --- \
}
