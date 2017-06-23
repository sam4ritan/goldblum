class PoopMail
  module MailHelpers
    def mail_with_template(template, recipient, subject, locals={})
      Pony.mail({
        to:          recipient,
        from:        "#{settings.email_sender} <#{settings.email_sender_address}>",
        subject:     settings.email_subject,
        html_body:   erb("email/#{template}".to_sym, { layout: :email_layout }, locals),
        via:         :smtp,
        via_options: settings.smtp_config
      })
    end
  end

  helpers MailHelpers
end
