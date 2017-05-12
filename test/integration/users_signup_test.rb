require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'Invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '', email: 'user@invalid',
                                          password: 'foo', password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
    assert_select 'form[action="/signup"]'
  end

  test 'Valid signup information' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: 'Test User',
                                          email: 'test@example.com',
                                          password: '12345678',
                                          password_confirmation: '12345678' } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
