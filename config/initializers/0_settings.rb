#最初に読み込ませるために、ファイル名の頭に0をつけた
class Settings < Settingslogic
  source "#{Rails.root}/config/settings.yml"
  namespace Rails.env
end
