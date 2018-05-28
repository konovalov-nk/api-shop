module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def header(key)
    response.get_header(key)
  end

  def confirm_and_login(user)
    post '/users/sign_in', params: { user: {
        email: user.email, password: user.password
    } }

    header('Authorization')
  end

  def logout(user)
    delete '/users/sign_out', params: { user: {
        email: user.email, password: user.password
    } }
  end
end
