class AppReviewsNotifierMailer < ApplicationMailer
  default from: "no-reply@micarrera.uy"
  layout 'mailer'

  def notify_new_review(review)
    @review = review
    @user = review.user
    mail(to: "feedback-micarrera@cedarcode.com", subject: "Nueva reseña de la aplicación",
         template_path: 'app_reviews_notifier_mailer',
         template_name: 'notify_new_review')
  end
end
