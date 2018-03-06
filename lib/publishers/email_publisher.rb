require 'mail'
require './lib/settings'

class EmailPublisher
  EMAIL_SUBJECT = 'Stock Update: %{stock}'
  EMAIL_TEMPLATE = <<~TEMPLATE
    %s
    ---------------------------------
    Cheers!
  TEMPLATE

  def initialize
    @settings = Settings[:publishers][:email]
  end

  def publish(info)
    subject = EMAIL_SUBJECT % info
    body = EMAIL_TEMPLATE % info
    self.send_email(subject, body)
  end

  def send_email(mail_subject, mail_body)
    options = @settings.merge(
      {
        authentication: 'plain',
        enable_starttls_auto: true,
      })
    Mail.defaults do
      delivery_method :smtp, options
    end

    # TODO handle errors?
    mail_from = @settings[:from]
    mail_to = @settings[:to]
    Mail.deliver do
      to mail_to
      from mail_from
      subject mail_subject
      body mail_body
    end
  end
end
