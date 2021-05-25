class ApplicationMailer < ActionMailer::Base
  default from: %(Cuisinier Rebelle <contact@cuisinierrebelle.com>)
  # layout 'mailer'
  layout 'bootstrap-mailer'
end
