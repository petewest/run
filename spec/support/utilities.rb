def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = Session.new_remember_token
    cookies[:remember_token] = remember_token
    user.sessions.create(ip_addr: "localhost", remember_token: Session.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end