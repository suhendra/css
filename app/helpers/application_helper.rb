module ApplicationHelper
  def login_helper style = ''
    if current_user.present?
      "<li>".html_safe +
      (link_to "Edit Profile", edit_user_registration_path, class: style) +
      "</li> <li> ".html_safe +
      (link_to "Logout", destroy_user_session_path, method: :delete, class: style) +
      "</li>".html_safe
    else
      "<li>".html_safe +
      (link_to "Login", new_user_session_path, class: style) +
      "</li> <li> ".html_safe +
      (link_to "Sign Up", new_user_registration_path, class: style) +
      "</li>".html_safe
    end
  end
  def bootstrap_devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-danger alert-block devise-bs">
      <button type="button" class="close" data-dismiss="alert">&times;</button>
      <h5>#{sentence}</h5>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end
end
