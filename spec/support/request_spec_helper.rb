module RequestSpecHelper
  @@headers = {
    'Accept' => 'application/json',
  }

  def json
    JSON.parse(response.body)
  end

  def header(key)
    response.get_header(key)
  end

  def get_with_token(path, params = {}, headers = {})
    headers.merge!(@@headers)
    get path, params: params, headers: headers
  end

  def delete_with_token(path, params = {}, headers = {})
    headers.merge!(@@headers)
    delete path, params: params, headers: headers
  end

  def put_with_token(path, params = {}, headers = {})
    headers.merge!(@@headers)
    put path, params: params, headers: headers
  end

  def post_with_token(path, params = {}, headers = {})
    headers.merge!(@@headers)
    post path, params: params, headers: headers
  end

  def confirm_and_login(user)
    post '/users/sign_in', params: { user: {
        email: user.email, password: user.password
    } }

    header('Authorization')
  end

  def logout(jwt)
    delete '/users/sign_out', headers: {
        'Accept' => 'application/json',
        'Content-type' => 'application/json',
        'Authorization' => jwt,
    }
  end
end
